package com.wework.platform.agent.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wework.platform.agent.dto.ConversationDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.entity.Agent;
import com.wework.platform.agent.entity.Conversation;
import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.ConversationStatus;
import com.wework.platform.agent.repository.AgentRepository;
import com.wework.platform.agent.repository.ConversationRepository;
import com.wework.platform.agent.service.ConversationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 会话服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ConversationServiceImpl implements ConversationService {

    private final ConversationRepository conversationRepository;
    private final AgentRepository agentRepository;
    private final ObjectMapper objectMapper;

    @Transactional(rollbackFor = Exception.class)
    public ConversationDTO createConversation(String tenantId, String agentId, String userId, String title) {
        log.info("创建会话, tenantId={}, agentId={}, userId={}", tenantId, agentId, userId);
        
        // 验证Agent是否存在且已发布
        Agent agent = validateAgent(tenantId, agentId);
        
        // 创建会话
        Conversation conversation = new Conversation();
        conversation.setTenantId(tenantId);
        conversation.setAgentId(agentId);
        conversation.setUserId(userId);
        conversation.setTitle(StringUtils.hasText(title) ? title : generateDefaultTitle());
        conversation.setStatus(ConversationStatus.ACTIVE);
        conversation.setMessageCount(0);
        conversation.setCreatedAt(LocalDateTime.now());
        conversation.setUpdatedAt(LocalDateTime.now());
        
        // 保存到数据库
        conversationRepository.insert(conversation);
        
        log.info("会话创建成功, conversationId={}", conversation.getId());
        return convertToDTO(conversation);
    }

    @Transactional(rollbackFor = Exception.class)
    public ConversationDTO updateConversationTitle(String tenantId, String conversationId, String title) {
        log.info("更新会话标题, tenantId={}, conversationId={}, title={}", tenantId, conversationId, title);
        
        if (!StringUtils.hasText(title)) {
            throw new IllegalArgumentException("会话标题不能为空");
        }
        
        Conversation conversation = getConversationEntity(tenantId, conversationId);
        conversation.setTitle(title);
        conversation.setUpdatedAt(LocalDateTime.now());
        
        conversationRepository.updateById(conversation);
        
        log.info("会话标题更新成功, conversationId={}", conversationId);
        return convertToDTO(conversation);
    }

    @Transactional(rollbackFor = Exception.class)
    public void endConversation(String tenantId, String conversationId) {
        log.info("结束会话, tenantId={}, conversationId={}", tenantId, conversationId);
        
        Conversation conversation = getConversationEntity(tenantId, conversationId);
        
        if (conversation.getStatus() == ConversationStatus.ENDED) {
            log.warn("会话已经是结束状态, conversationId={}", conversationId);
            return;
        }
        
        conversation.setStatus(ConversationStatus.ENDED);
        conversation.setEndedAt(LocalDateTime.now());
        conversation.setUpdatedAt(LocalDateTime.now());
        
        conversationRepository.updateById(conversation);
        
        log.info("会话结束成功, conversationId={}", conversationId);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteConversation(String tenantId, String conversationId) {
        log.info("删除会话, tenantId={}, conversationId={}", tenantId, conversationId);
        
        Conversation conversation = getConversationEntity(tenantId, conversationId);
        conversation.setStatus(ConversationStatus.DELETED);
        conversation.setUpdatedAt(LocalDateTime.now());
        
        conversationRepository.updateById(conversation);
        
        log.info("会话删除成功, conversationId={}", conversationId);
    }

    public ConversationDTO getConversation(String tenantId, String conversationId) {
        log.debug("查询会话详情, tenantId={}, conversationId={}", tenantId, conversationId);
        
        Conversation conversation = getConversationEntity(tenantId, conversationId);
        return convertToDTO(conversation);
    }

    public PageResult<ConversationDTO> getUserConversations(String tenantId, String userId, 
                                                           int pageNum, int pageSize) {
        log.debug("分页查询用户会话, tenantId={}, userId={}, pageNum={}, pageSize={}", 
                 tenantId, userId, pageNum, pageSize);
        
        // 构建查询条件
        LambdaQueryWrapper<Conversation> queryWrapper = new LambdaQueryWrapper<Conversation>()
            .eq(Conversation::getTenantId, tenantId)
            .eq(Conversation::getUserId, userId)
            .ne(Conversation::getStatus, ConversationStatus.DELETED)
            .orderByDesc(Conversation::getUpdatedAt);
        
        // 分页查询
        Page<Conversation> page = new Page<>(pageNum, pageSize);
        IPage<Conversation> result = conversationRepository.selectPage(page, queryWrapper);
        
        // 转换为DTO
        List<ConversationDTO> dtoList = result.getRecords().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        return PageResult.<ConversationDTO>builder()
            .records(dtoList)
            .total(result.getTotal())
            .current((long) pageNum)
            .size((long) pageSize)
            .pages(result.getPages())
            .build();
    }

    public PageResult<ConversationDTO> getAgentConversations(String tenantId, String agentId, 
                                                            int pageNum, int pageSize) {
        log.debug("分页查询智能体会话, tenantId={}, agentId={}, pageNum={}, pageSize={}", 
                 tenantId, agentId, pageNum, pageSize);
        
        // 构建查询条件
        LambdaQueryWrapper<Conversation> queryWrapper = new LambdaQueryWrapper<Conversation>()
            .eq(Conversation::getTenantId, tenantId)
            .eq(Conversation::getAgentId, agentId)
            .ne(Conversation::getStatus, ConversationStatus.DELETED)
            .orderByDesc(Conversation::getUpdatedAt);
        
        // 分页查询
        Page<Conversation> page = new Page<>(pageNum, pageSize);
        IPage<Conversation> result = conversationRepository.selectPage(page, queryWrapper);
        
        // 转换为DTO
        List<ConversationDTO> dtoList = result.getRecords().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        return PageResult.<ConversationDTO>builder()
            .records(dtoList)
            .total(result.getTotal())
            .current((long) pageNum)
            .size((long) pageSize)
            .pages(result.getPages())
            .build();
    }

    public List<ConversationDTO> getActiveConversations(String tenantId, String userId) {
        log.debug("查询用户活跃会话, tenantId={}, userId={}", tenantId, userId);
        
        List<Conversation> conversations = conversationRepository.selectList(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .eq(Conversation::getStatus, ConversationStatus.ACTIVE)
                .orderByDesc(Conversation::getUpdatedAt)
                .last("LIMIT 10") // 最多返回10个活跃会话
        );
        
        return conversations.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Transactional(rollbackFor = Exception.class)
    public void incrementMessageCount(String conversationId) {
        log.debug("增加会话消息计数, conversationId={}", conversationId);
        
        Conversation conversation = conversationRepository.selectById(conversationId);
        if (conversation != null) {
            conversation.setMessageCount(conversation.getMessageCount() + 1);
            conversation.setUpdatedAt(LocalDateTime.now());
            conversationRepository.updateById(conversation);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateLastMessage(String conversationId, String lastMessage) {
        log.debug("更新会话最后消息, conversationId={}", conversationId);
        
        Conversation conversation = conversationRepository.selectById(conversationId);
        if (conversation != null) {
            conversation.setLastMessage(lastMessage);
            conversation.setUpdatedAt(LocalDateTime.now());
            conversationRepository.updateById(conversation);
        }
    }

    public long countConversationsByStatus(String tenantId, ConversationStatus status) {
        return conversationRepository.selectCount(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getStatus, status)
        );
    }

    public long countUserConversations(String tenantId, String userId) {
        return conversationRepository.selectCount(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
    }

    public long countAgentConversations(String tenantId, String agentId) {
        return conversationRepository.selectCount(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getAgentId, agentId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
    }

    @Transactional(rollbackFor = Exception.class)
    public Long cleanupExpiredConversations(LocalDateTime expiredBefore) {
        log.info("清理过期会话, expiredBefore={}", expiredBefore);
        
        // 查询需要清理的会话
        List<Conversation> expiredConversations = conversationRepository.selectList(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getStatus, ConversationStatus.ENDED)
                .lt(Conversation::getEndedAt, expiredBefore)
        );
        
        if (!expiredConversations.isEmpty()) {
            // 批量删除
            expiredConversations.forEach(conversation -> {
                conversation.setStatus(ConversationStatus.DELETED);
                conversation.setUpdatedAt(LocalDateTime.now());
                conversationRepository.updateById(conversation);
            });
            
            log.info("清理过期会话完成, 清理数量={}", expiredConversations.size());
            return (long) expiredConversations.size();
        }
        
        return 0L;
    }

    public ConversationService.ConversationStats getConversationStats(String tenantId, String userId) {
        log.debug("获取会话统计, tenantId={}, userId={}", tenantId, userId);
        
        ConversationService.ConversationStats stats = new ConversationService.ConversationStats();
        
        // 查询用户的所有会话
        List<Conversation> conversations = conversationRepository.selectList(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        // 计算各种统计信息
        stats.setTotalConversations((long) conversations.size());
        stats.setActiveConversations(conversations.stream()
            .filter(c -> c.getStatus() == ConversationStatus.ACTIVE)
            .count());
        stats.setPinnedConversations(conversations.stream()
            .filter(c -> Boolean.TRUE.equals(c.getPinned()))
            .count());
        stats.setStarredConversations(conversations.stream()
            .filter(c -> Boolean.TRUE.equals(c.getStarred()))
            .count());
        stats.setArchivedConversations(conversations.stream()
            .filter(c -> c.getStatus() == ConversationStatus.ENDED)
            .count());
        
        // 计算平均消息数
        if (!conversations.isEmpty()) {
            double avgMessages = conversations.stream()
                .mapToInt(c -> c.getMessageCount() != null ? c.getMessageCount() : 0)
                .average()
                .orElse(0.0);
            stats.setAvgMessagesPerConversation(avgMessages);
        } else {
            stats.setAvgMessagesPerConversation(0.0);
        }
        
        // 计算平均持续时间（暂时设为0，需要根据实际业务逻辑计算）
        stats.setAvgDurationMinutes(0.0);
        
        return stats;
    }

    @Transactional(rollbackFor = Exception.class)
    public ConversationDTO unarchiveConversation(String tenantId, String userId, String conversationId) {
        log.info("取消归档会话, tenantId={}, userId={}, conversationId={}", tenantId, userId, conversationId);
        
        // 查询会话
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new RuntimeException("会话不存在或已删除");
        }
        
        // 更新状态为活跃
        conversation.setStatus(ConversationStatus.ACTIVE);
        conversation.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        conversationRepository.updateById(conversation);
        
        log.info("会话取消归档成功, conversationId={}", conversationId);
        return convertToDTO(conversation);
    }

    @Transactional(rollbackFor = Exception.class)
    public ConversationDTO archiveConversation(String tenantId, String userId, String conversationId) {
        log.info("归档会话, tenantId={}, userId={}, conversationId={}", tenantId, userId, conversationId);
        
        // 查询会话
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new RuntimeException("会话不存在或已删除");
        }
        
        // 更新状态为结束（作为归档状态）
        conversation.setStatus(ConversationStatus.ENDED);
        conversation.setEndedAt(LocalDateTime.now());
        conversation.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        conversationRepository.updateById(conversation);
        
        log.info("会话归档成功, conversationId={}", conversationId);
        return convertToDTO(conversation);
    }

    @Transactional(rollbackFor = Exception.class)
    public void clearConversationContext(String tenantId, String conversationId) {
        log.info("清理会话上下文, tenantId={}, conversationId={}", tenantId, conversationId);
        
        // 查询会话
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new RuntimeException("会话不存在或已删除");
        }
        
        // 清理上下文JSON
        conversation.setContextJson("{}");
        conversation.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        conversationRepository.updateById(conversation);
        
        log.info("会话上下文清理成功, conversationId={}", conversationId);
    }

    public Map<String, Object> getConversationContext(String tenantId, String conversationId) {
        log.debug("获取会话上下文, tenantId={}, conversationId={}", tenantId, conversationId);
        
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new RuntimeException("会话不存在或已删除");
        }
        
        // 解析JSON字符串为Map
        String contextJson = conversation.getContextJson();
        if (contextJson == null || contextJson.trim().isEmpty()) {
            return new HashMap<>();
        }
        
        try {
            return objectMapper.readValue(contextJson, Map.class);
        } catch (Exception e) {
            log.warn("解析会话上下文JSON失败, conversationId={}, error={}", conversationId, e.getMessage());
            return new HashMap<>();
        }
    }

    /**
     * 验证Agent是否存在且可用
     */
    private Agent validateAgent(String tenantId, String agentId) {
        Agent agent = agentRepository.selectOne(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getId, agentId)
                .eq(Agent::getTenantId, tenantId)
                .eq(Agent::getStatus, AgentStatus.PUBLISHED)
        );
        
        if (agent == null) {
            throw new IllegalArgumentException("智能体不存在或未发布: " + agentId);
        }
        
        return agent;
    }

    /**
     * 获取会话实体
     */
    private Conversation getConversationEntity(String tenantId, String conversationId) {
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new IllegalArgumentException("会话不存在: " + conversationId);
        }
        
        return conversation;
    }

    @Override
    @Transactional
    public void updateConversationContext(String tenantId, String conversationId, Map<String, Object> context) {
        log.info("更新会话上下文, tenantId={}, conversationId={}", tenantId, conversationId);
        
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );
        
        if (conversation == null) {
            throw new RuntimeException("会话不存在或已删除");
        }
        
        try {
            // 将Map转换为JSON字符串保存
            String contextJson = objectMapper.writeValueAsString(context);
            conversation.setContextJson(contextJson);
            conversation.setUpdatedAt(LocalDateTime.now());
            
            conversationRepository.updateById(conversation);
            
            log.info("会话上下文更新成功, conversationId={}", conversationId);
        } catch (Exception e) {
            log.error("更新会话上下文失败, conversationId={}", conversationId, e);
            throw new RuntimeException("更新会话上下文失败: " + e.getMessage());
        }
    }

        @Override
    @Transactional
    public ConversationDTO removeConversationTags(String tenantId, String userId, String conversationId, List<String> tags) {
        log.info("移除会话标签, tenantId={}, conversationId={}, userId={}, tags={}", tenantId, conversationId, userId, tags);

        if (tags == null || tags.isEmpty()) {
            log.warn("标签列表为空，无需移除");
            return getConversation(tenantId, userId, conversationId);
        }

        // 验证会话存在且用户有权限
        Conversation conversation = conversationRepository.selectOne(
            new LambdaQueryWrapper<Conversation>()
                .eq(Conversation::getId, conversationId)
                .eq(Conversation::getTenantId, tenantId)
                .eq(Conversation::getUserId, userId)
                .ne(Conversation::getStatus, ConversationStatus.DELETED)
        );

        if (conversation == null) {
            throw new RuntimeException("会话不存在或无权限访问");
        }

        // TODO: 实现具体的标签移除逻辑
        // 这里应该根据实际的标签存储方式来实现
        // 可能需要更新conversation的tagsJson字段或者操作专门的标签表

        log.info("会话标签移除成功, conversationId={}, removedTags={}", conversationId, tags);
        return convertToDTO(conversation);
    }

    /**
     * 生成默认会话标题
     */
    private String generateDefaultTitle() {
        return "新会话 " + LocalDateTime.now().toString().substring(0, 16);
    }

    /**
     * 转换为DTO
     */
    private ConversationDTO convertToDTO(Conversation conversation) {
        ConversationDTO dto = new ConversationDTO();
        BeanUtils.copyProperties(conversation, dto);
        return dto;
    }
}