package com.wework.platform.agent.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wework.platform.agent.dto.MessageDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.entity.Conversation;
import com.wework.platform.agent.entity.Message;
import com.wework.platform.agent.enums.ConversationStatus;
import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;
import com.wework.platform.agent.repository.ConversationRepository;
import com.wework.platform.agent.repository.MessageRepository;
import com.wework.platform.agent.service.MessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 消息服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    private final MessageRepository messageRepository;
    private final ConversationRepository conversationRepository;
    private final ObjectMapper objectMapper;

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO createMessage(String tenantId, String conversationId, String userId, 
                                   MessageType type, String content, Map<String, Object> metadata) {
        log.info("创建消息, tenantId={}, conversationId={}, userId={}, type={}", 
                tenantId, conversationId, userId, type);
        
        // 验证会话是否存在且活跃
        validateConversation(tenantId, conversationId);
        
        // 创建消息
        Message message = new Message();
        message.setTenantId(tenantId);
        message.setConversationId(conversationId);
        message.setUserId(userId);
        message.setType(type);
        message.setContent(content);
        
        // 转换metadata为JSON字符串
        if (metadata != null && !metadata.isEmpty()) {
            try {
                message.setMetadata(objectMapper.writeValueAsString(metadata));
            } catch (JsonProcessingException e) {
                log.warn("Failed to serialize metadata to JSON, setting as empty string", e);
                message.setMetadata("{}");
            }
        } else {
            message.setMetadata("{}");
        }
        
        message.setStatus(MessageStatus.SENT);
        message.setCreatedAt(LocalDateTime.now());
        message.setUpdatedAt(LocalDateTime.now());
        
        // 保存到数据库
        messageRepository.insert(message);
        
        log.info("消息创建成功, messageId={}", message.getId());
        return convertToDTO(message);
    }

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO createUserMessage(String tenantId, String conversationId, String userId, 
                                       String content) {
        return createMessage(tenantId, conversationId, userId, MessageType.TEXT, content, null);
    }

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO createAssistantMessage(String tenantId, String conversationId, 
                                            String content, Map<String, Object> metadata) {
        return createMessage(tenantId, conversationId, "assistant", MessageType.TEXT, content, metadata);
    }

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO createSystemMessage(String tenantId, String conversationId, 
                                         String content, Map<String, Object> metadata) {
        return createMessage(tenantId, conversationId, "system", MessageType.SYSTEM, content, metadata);
    }

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO createToolCallMessage(String tenantId, String conversationId, 
                                           String toolName, Map<String, Object> parameters) {
        Map<String, Object> metadata = Map.of(
            "tool_name", toolName,
            "parameters", parameters
        );
        
        return createMessage(tenantId, conversationId, "assistant", MessageType.TOOL_CALL, 
                           "调用工具: " + toolName, metadata);
    }

    @Transactional(rollbackFor = Exception.class)
    public MessageDTO updateMessageStatus(String tenantId, String messageId, MessageStatus status) {
        log.info("更新消息状态, tenantId={}, messageId={}, status={}", tenantId, messageId, status);
        
        Message message = getMessageEntity(tenantId, messageId);
        message.setStatus(status);
        message.setUpdatedAt(LocalDateTime.now());
        
        messageRepository.updateById(message);
        
        log.info("消息状态更新成功, messageId={}, status={}", messageId, status);
        
        return convertToDTO(message);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void updateMessageContent(String tenantId, String messageId, String content) {
        log.info("更新消息内容, tenantId={}, messageId={}", tenantId, messageId);
        
        Message message = getMessageEntity(tenantId, messageId);
        message.setContent(content);
        message.setUpdatedAt(LocalDateTime.now());
        
        messageRepository.updateById(message);
        
        log.info("消息内容更新成功, messageId={}", messageId);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteMessage(String tenantId, String messageId) {
        log.info("删除消息, tenantId={}, messageId={}", tenantId, messageId);
        
        Message message = getMessageEntity(tenantId, messageId);
        message.setStatus(MessageStatus.DELETED);
        message.setUpdatedAt(LocalDateTime.now());
        
        messageRepository.updateById(message);
        
        log.info("消息删除成功, messageId={}", messageId);
    }

    public MessageDTO getMessage(String tenantId, String messageId) {
        log.debug("查询消息详情, tenantId={}, messageId={}", tenantId, messageId);
        
        Message message = getMessageEntity(tenantId, messageId);
        return convertToDTO(message);
    }

    public PageResult<MessageDTO> getConversationMessages(String tenantId, String conversationId, 
                                                         int pageNum, int pageSize) {
        log.debug("分页查询会话消息, tenantId={}, conversationId={}, pageNum={}, pageSize={}", 
                 tenantId, conversationId, pageNum, pageSize);
        
        // 验证会话是否存在
        validateConversation(tenantId, conversationId);
        
        // 构建查询条件
        LambdaQueryWrapper<Message> queryWrapper = new LambdaQueryWrapper<Message>()
            .eq(Message::getTenantId, tenantId)
            .eq(Message::getConversationId, conversationId)
            .ne(Message::getStatus, MessageStatus.DELETED)
            .orderByAsc(Message::getCreatedAt); // 按时间正序排列
        
        // 分页查询
        Page<Message> page = new Page<>(pageNum, pageSize);
        IPage<Message> result = messageRepository.selectPage(page, queryWrapper);
        
        // 转换为DTO
        List<MessageDTO> dtoList = result.getRecords().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        return PageResult.<MessageDTO>builder()
            .records(dtoList)
            .total(result.getTotal())
            .current((long) pageNum)
            .size((long) pageSize)
            .pages(result.getPages())
            .build();
    }

    public List<MessageDTO> getRecentMessages(String tenantId, String conversationId, int limit) {
        log.debug("查询最近消息, tenantId={}, conversationId={}, limit={}", 
                 tenantId, conversationId, limit);
        
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getConversationId, conversationId)
                .ne(Message::getStatus, MessageStatus.DELETED)
                .orderByDesc(Message::getCreatedAt)
                .last("LIMIT " + limit)
        );
        
        // 按时间正序返回
        return messages.stream()
            .sorted((m1, m2) -> m1.getCreatedAt().compareTo(m2.getCreatedAt()))
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public List<MessageDTO> getUserMessages(String tenantId, String userId, int limit) {
        log.debug("查询用户消息, tenantId={}, userId={}, limit={}", tenantId, userId, limit);
        
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getUserId, userId)
                .ne(Message::getStatus, MessageStatus.DELETED)
                .orderByDesc(Message::getCreatedAt)
                .last("LIMIT " + limit)
        );
        
        return messages.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public long countMessagesByType(String tenantId, MessageType type) {
        return messageRepository.selectCount(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getType, type)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
    }

    @Override
    public long countMessagesByStatus(String tenantId, MessageStatus status) {
        return messageRepository.selectCount(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getStatus, status)
        );
    }

    @Override
    public long countConversationMessages(String tenantId, String conversationId) {
        return messageRepository.selectCount(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getConversationId, conversationId)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
    }

    @Override
    public long countUserMessages(String tenantId, String userId) {
        return messageRepository.selectCount(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getUserId, userId)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
    }

    @Transactional(rollbackFor = Exception.class)
    public void cleanupExpiredMessages(int retentionDays) {
        log.info("清理过期消息, retentionDays={}", retentionDays);
        
        LocalDateTime cutoffTime = LocalDateTime.now().minusDays(retentionDays);
        
        // 查询需要清理的消息
        List<Message> expiredMessages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getStatus, MessageStatus.DELETED)
                .lt(Message::getUpdatedAt, cutoffTime)
        );
        
        if (!expiredMessages.isEmpty()) {
            // 物理删除
            List<String> messageIds = expiredMessages.stream()
                .map(Message::getId)
                .collect(Collectors.toList());
            
            messageRepository.deleteBatchIds(messageIds);
            
            log.info("清理过期消息完成, 清理数量={}", expiredMessages.size());
        }
    }

    public List<MessageDTO> searchMessages(String tenantId, String keyword, int limit) {
        log.debug("搜索消息, tenantId={}, keyword={}, limit={}", tenantId, keyword, limit);
        
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .like(Message::getContent, keyword)
                .ne(Message::getStatus, MessageStatus.DELETED)
                .orderByDesc(Message::getCreatedAt)
                .last("LIMIT " + limit)
        );
        
        return messages.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public Map<String, Long> getMessageStatistics(String tenantId, LocalDateTime startTime, 
                                                 LocalDateTime endTime) {
        log.debug("获取消息统计, tenantId={}, startTime={}, endTime={}", 
                 tenantId, startTime, endTime);
        
        // 查询时间范围内的消息
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .between(Message::getCreatedAt, startTime, endTime)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
        
        // 统计各种类型的消息数量
        Map<String, Long> statistics = messages.stream()
            .collect(Collectors.groupingBy(
                message -> message.getType().name(),
                Collectors.counting()
            ));
        
        // 添加总数统计
        statistics.put("TOTAL", (long) messages.size());
        
        return statistics;
    }

    /**
     * 验证会话是否存在且活跃
     */
    private void validateConversation(String tenantId, String conversationId) {
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new IllegalArgumentException("会话不存在: " + conversationId);
        }
        
        if (conversation.getStatus() == ConversationStatus.ENDED) {
            throw new IllegalStateException("会话已结束，不能添加新消息: " + conversationId);
        }
    }

    /**
     * 获取消息实体
     */
    private Message getMessageEntity(String tenantId, String messageId) {
        Message message = messageRepository.selectOne(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getId, messageId)
                .eq(Message::getTenantId, tenantId)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
        
        if (message == null) {
            throw new IllegalArgumentException("消息不存在: " + messageId);
        }
        
        return message;
    }

    @Transactional(rollbackFor = Exception.class)
    public Long cleanupExpiredMessages(LocalDateTime expiredBefore) {
        log.info("清理过期消息, expiredBefore={}", expiredBefore);
        
        // 查询需要清理的消息
        List<Message> expiredMessages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .lt(Message::getCreatedAt, expiredBefore)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );
        
        if (!expiredMessages.isEmpty()) {
            // 批量软删除
            expiredMessages.forEach(message -> {
                message.setStatus(MessageStatus.DELETED);
                message.setUpdatedAt(LocalDateTime.now());
                messageRepository.updateById(message);
            });
            
            log.info("清理过期消息完成, 清理数量={}", expiredMessages.size());
            return (long) expiredMessages.size();
        }
        
        return 0L;
    }

    public MessageService.MessageStats getMessageStats(String tenantId, String conversationId, String agentId, String userId) {
        log.debug("获取消息统计, tenantId={}, conversationId={}, agentId={}, userId={}", 
                 tenantId, conversationId, agentId, userId);
        
        MessageService.MessageStats stats = new MessageService.MessageStats();
        
        // 构建查询条件
        LambdaQueryWrapper<Message> queryWrapper = new LambdaQueryWrapper<Message>()
            .eq(Message::getTenantId, tenantId)
            .ne(Message::getStatus, MessageStatus.DELETED);
        
        if (conversationId != null) {
            queryWrapper.eq(Message::getConversationId, conversationId);
        }
        if (agentId != null) {
            queryWrapper.eq(Message::getAgentId, agentId);
        }
        if (userId != null) {
            queryWrapper.eq(Message::getUserId, userId);
        }
        
        // 查询消息列表
        List<Message> messages = messageRepository.selectList(queryWrapper);
        
        // 计算基础统计
        stats.setTotalMessages((long) messages.size());
        stats.setUserMessages(messages.stream()
            .filter(m -> "user".equals(m.getRole()))
            .count());
        stats.setAssistantMessages(messages.stream()
            .filter(m -> "assistant".equals(m.getRole()))
            .count());
        stats.setSystemMessages(messages.stream()
            .filter(m -> "system".equals(m.getRole()))
            .count());
        
        // 计算总token数
        long totalTokens = messages.stream()
            .mapToLong(m -> m.getTokens() != null ? m.getTokens().longValue() : 0L)
            .sum();
        stats.setTotalTokens(totalTokens);
        
        // 计算平均响应时间（暂时设为0.0，需要根据实际业务逻辑计算）
        stats.setAvgResponseTime(0.0);
        
        // 计算平均消息长度
        if (!messages.isEmpty()) {
            double avgLength = messages.stream()
                .filter(m -> m.getContent() != null)
                .mapToInt(m -> m.getContent().length())
                .average()
                .orElse(0.0);
            stats.setAvgMessageLength(avgLength);
        } else {
            stats.setAvgMessageLength(0.0);
        }
        
        // 按类型统计消息
        Map<MessageType, Long> messagesByType = messages.stream()
            .collect(Collectors.groupingBy(
                Message::getType,
                Collectors.counting()
            ));
        stats.setMessagesByType(messagesByType);
        
        // 初始化按小时统计（暂时为空map，需要根据实际需求实现）
        stats.setMessagesByHour(new HashMap<>());
        
        return stats;
    }

    @Transactional(rollbackFor = Exception.class)
    public void removeMessageReaction(String tenantId, String userId, String messageId, String reactionType) {
        log.info("移除消息反应, tenantId={}, userId={}, messageId={}, reactionType={}", 
                 tenantId, userId, messageId, reactionType);
        
        // 验证消息存在
        Message message = getMessageEntity(tenantId, messageId);
        
        // TODO: 实现具体的反应移除逻辑
        // 这里应该从消息的reactions字段中移除对应的反应
        // 由于reactions字段的具体结构不明确，暂时记录日志
        
        log.info("消息反应移除成功, messageId={}, reactionType={}", messageId, reactionType);
    }

    @Transactional(rollbackFor = Exception.class)
    public void addMessageReaction(String tenantId, String userId, String messageId, String reactionType) {
        log.info("添加消息反应, tenantId={}, userId={}, messageId={}, reactionType={}", 
                 tenantId, userId, messageId, reactionType);
        
        // 验证消息存在
        Message message = getMessageEntity(tenantId, messageId);
        
        // TODO: 实现具体的反应添加逻辑
        // 这里应该向消息的reactions字段中添加对应的反应
        // 由于reactions字段的具体结构不明确，暂时记录日志
        
        log.info("消息反应添加成功, messageId={}, reactionType={}", messageId, reactionType);
    }

    public List<MessageDTO> getMessageQuoteChain(String tenantId, String messageId) {
        log.debug("获取消息引用链, tenantId={}, messageId={}", tenantId, messageId);
        
        // 验证消息存在
        Message message = getMessageEntity(tenantId, messageId);
        
        // TODO: 实现具体的引用链逻辑
        // 这里应该根据消息的引用关系构建引用链
        // 由于引用关系的具体实现不明确，暂时返回空列表
        
        List<MessageDTO> quoteChain = new ArrayList<>();
        
        log.debug("消息引用链获取完成, messageId={}, chainSize={}", messageId, quoteChain.size());
        return quoteChain;
    }

    public String exportConversationMessages(String tenantId, String conversationId, String format) {
        log.info("导出会话消息, tenantId={}, conversationId={}, format={}", tenantId, conversationId, format);
        
        // 查询会话消息
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getConversationId, conversationId)
                .ne(Message::getStatus, MessageStatus.DELETED)
                .orderByAsc(Message::getCreatedAt)
        );
        
        if (messages.isEmpty()) {
            return "{}";
        }
        
        // 根据格式导出（这里简化处理，返回JSON格式）
        try {
            List<MessageDTO> messageDTOs = messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
            
            // 使用JSON格式导出
            return objectMapper.writeValueAsString(messageDTOs);
        } catch (JsonProcessingException e) {
            log.error("导出会话消息失败, conversationId={}, error={}", conversationId, e.getMessage());
            throw new RuntimeException("导出会话消息失败: " + e.getMessage());
        }
    }

        @Override
    @Transactional
    public Integer clearConversationMessages(String tenantId, String conversationId) {
        log.info("清理会话消息, tenantId={}, conversationId={}", tenantId, conversationId);

        // 验证会话是否存在
        validateConversation(tenantId, conversationId);

        // 逻辑删除会话中的所有消息
        List<Message> messages = messageRepository.selectList(
            new LambdaQueryWrapper<Message>()
                .eq(Message::getTenantId, tenantId)
                .eq(Message::getConversationId, conversationId)
                .ne(Message::getStatus, MessageStatus.DELETED)
        );

        if (!messages.isEmpty()) {
            LocalDateTime now = LocalDateTime.now();
            for (Message message : messages) {
                message.setStatus(MessageStatus.DELETED);
                message.setUpdatedAt(now);
                messageRepository.updateById(message);
            }

            log.info("清理会话消息完成, conversationId={}, 清理数量={}", conversationId, messages.size());
            return messages.size();
        } else {
            log.info("会话无消息需要清理, conversationId={}", conversationId);
            return 0;
        }
    }

    @Override
    @Transactional
    public Integer batchDeleteMessages(String tenantId, String conversationId, List<String> messageIds) {
        log.info("批量删除消息, tenantId={}, conversationId={}, messageIds={}", tenantId, conversationId, messageIds);

        if (messageIds == null || messageIds.isEmpty()) {
            log.warn("消息ID列表为空，无需删除");
            return 0;
        }

        // 验证会话是否存在
        validateConversation(tenantId, conversationId);

        // 批量逻辑删除消息
        int deletedCount = 0;
        LocalDateTime now = LocalDateTime.now();
        
        for (String messageId : messageIds) {
            Message message = messageRepository.selectOne(
                new LambdaQueryWrapper<Message>()
                    .eq(Message::getId, messageId)
                    .eq(Message::getTenantId, tenantId)
                    .eq(Message::getConversationId, conversationId)
                    .ne(Message::getStatus, MessageStatus.DELETED)
            );

            if (message != null) {
                message.setStatus(MessageStatus.DELETED);
                message.setUpdatedAt(now);
                messageRepository.updateById(message);
                deletedCount++;
            }
        }

        log.info("批量删除消息完成, conversationId={}, 删除数量={}", conversationId, deletedCount);
        return deletedCount;
    }

    /**
     * 转换为DTO
     */
    private MessageDTO convertToDTO(Message message) {
        MessageDTO dto = new MessageDTO();
        BeanUtils.copyProperties(message, dto);
        return dto;
    }
}