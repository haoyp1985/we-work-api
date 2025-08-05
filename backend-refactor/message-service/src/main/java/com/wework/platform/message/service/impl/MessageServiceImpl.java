package com.wework.platform.message.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.message.dto.MessageDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.entity.Message;
import com.wework.platform.message.repository.MessageRepository;
import com.wework.platform.message.service.MessageService;
import com.wework.platform.message.client.WeWorkClient;
import com.wework.platform.message.event.MessageSentEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 消息服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    private final MessageRepository messageRepository;
    private final WeWorkClient weWorkClient;
    private final ApplicationEventPublisher eventPublisher;

    @Override
    @Transactional
    public MessageDTO sendMessage(String tenantId, SendMessageRequest request) {
        log.info("开始发送消息, tenantId: {}, accountId: {}", tenantId, request.getAccountId());

        // 构建消息实体
        Message message = buildMessage(tenantId, request);
        
        // 保存消息记录
        messageRepository.insert(message);

        // 异步发送消息
        if (request.getAsync()) {
            sendMessageAsync(message);
        } else {
            sendMessageSync(message);
        }

        return convertToDTO(message);
    }

    @Override
    @Transactional
    public List<MessageDTO> batchSendMessages(String tenantId, List<SendMessageRequest> requests) {
        log.info("批量发送消息, tenantId: {}, 数量: {}", tenantId, requests.size());

        List<MessageDTO> results = new ArrayList<>();
        String batchId = UUID.randomUUID().toString();

        for (SendMessageRequest request : requests) {
            try {
                Message message = buildMessage(tenantId, request);
                message.setBatchId(batchId);
                results.add(sendMessage(tenantId, request));
            } catch (Exception e) {
                log.error("批量发送消息失败, request: {}", request, e);
            }
        }

        return results;
    }

    @Override
    public PageResult<MessageDTO> getMessageList(String tenantId, String accountId, Integer messageType,
                                               Integer sendStatus, LocalDateTime startTime, LocalDateTime endTime,
                                               Integer pageNum, Integer pageSize) {
        Page<Message> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(Message::getTenantId, tenantId)
               .eq(StringUtils.hasText(accountId), Message::getAccountId, accountId)
               .eq(messageType != null, Message::getMessageType, messageType)
               .eq(sendStatus != null, Message::getSendStatus, sendStatus)
               .ge(startTime != null, Message::getSendTime, startTime)
               .le(endTime != null, Message::getSendTime, endTime)
               .orderByDesc(Message::getCreatedAt);

        IPage<Message> result = messageRepository.selectPage(page, wrapper);
        
        List<MessageDTO> dtoList = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return PageResult.of(dtoList, result.getTotal(), pageNum.longValue(), pageSize.longValue());
    }

    @Override
    public MessageDTO getMessageById(String messageId) {
        Message message = messageRepository.selectById(messageId);
        if (message == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "消息不存在");
        }
        return convertToDTO(message);
    }

    @Override
    @Transactional
    public MessageDTO resendMessage(String messageId) {
        Message message = messageRepository.selectById(messageId);
        if (message == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "消息不存在");
        }

        // 重置发送状态
        message.setSendStatus(0);
        message.setRetryCount(0);
        message.setErrorCode(null);
        message.setErrorMessage(null);
        message.setSendTime(LocalDateTime.now());
        messageRepository.updateById(message);

        // 重新发送
        sendMessageAsync(message);

        return convertToDTO(message);
    }

    @Override
    @Transactional
    public Boolean recallMessage(String messageId) {
        Message message = messageRepository.selectById(messageId);
        if (message == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "消息不存在");
        }

        if (message.getSendStatus() != 2) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只能撤回已发送成功的消息");
        }

        try {
            // 调用企微API撤回消息
            boolean success = weWorkClient.recallMessage(message.getAccountId(), message.getWeworkMsgId());
            
            if (success) {
                // 更新消息状态
                message.setSendStatus(5); // 已撤回
                messageRepository.updateById(message);
            }
            
            return success;
        } catch (Exception e) {
            log.error("撤回消息失败, messageId: {}", messageId, e);
            return false;
        }
    }

    @Override
    @Transactional
    public void updateMessageStatus(String messageId, Integer sendStatus, String errorCode, String errorMessage) {
        messageRepository.updateMessageStatus(messageId, sendStatus, errorCode, errorMessage);
    }

    @Override
    public List<MessageDTO> getMessagesForRetry(Integer limit) {
        List<Message> messages = messageRepository.findMessagesForRetry(limit);
        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Boolean handleMessageRetry(String messageId) {
        Message message = messageRepository.selectById(messageId);
        if (message == null) {
            return false;
        }

        // 更新重试信息
        int retryCount = message.getRetryCount() + 1;
        LocalDateTime nextRetryTime = calculateNextRetryTime(retryCount, message.getCreatedAt());
        
        messageRepository.updateRetryInfo(messageId, retryCount, nextRetryTime);

        // 重新发送
        sendMessageAsync(message);

        return true;
    }

    @Override
    public MessageStatisticsDTO getMessageStatistics(String tenantId, String accountId,
                                                   LocalDateTime startTime, LocalDateTime endTime) {
        MessageRepository.MessageStatistics stats = messageRepository.getMessageStatistics(
                tenantId, accountId, startTime, endTime);

        MessageStatisticsDTO dto = new MessageStatisticsDTO();
        
        // 设置时间范围
        MessageStatisticsDTO.TimeRange timeRange = MessageStatisticsDTO.TimeRange.builder()
                .startTime(startTime != null ? startTime.toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null)
                .endTime(endTime != null ? endTime.toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null)
                .build();
        dto.setTimeRange(timeRange);

        // 设置总体统计
        MessageStatisticsDTO.OverallStatistics overall = MessageStatisticsDTO.OverallStatistics.builder()
                .totalMessages(stats.getTotalCount())
                .successCount(stats.getSuccessCount())
                .failCount(stats.getFailCount())
                .pendingCount(stats.getPendingCount())
                .successRate(stats.getTotalCount() > 0 ? 
                           (double) stats.getSuccessCount() / stats.getTotalCount() * 100 : 0)
                .build();
        dto.setOverall(overall);

        return dto;
    }

    @Override
    @Transactional
    public Boolean deleteMessage(String messageId) {
        return messageRepository.deleteById(messageId) > 0;
    }

    @Override
    @Transactional
    public Integer batchDeleteMessages(List<String> messageIds) {
        return messageRepository.deleteBatchIds(messageIds);
    }

    @Override
    @Transactional
    public Integer cleanHistoryMessages(String tenantId, Integer beforeDays) {
        LocalDateTime beforeTime = LocalDateTime.now().minusDays(beforeDays);
        
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Message::getTenantId, tenantId)
               .le(Message::getCreatedAt, beforeTime);
        
        return messageRepository.delete(wrapper);
    }

    /**
     * 构建消息实体
     */
    private Message buildMessage(String tenantId, SendMessageRequest request) {
        Message message = new Message();
        message.setId(UUID.randomUUID().toString());
        message.setTenantId(tenantId);
        message.setAccountId(request.getAccountId());
        message.setMessageType(request.getMessageType());
        message.setSendType(request.getReceiverIds().size() > 1 ? 2 : 1); // 群发或单发
        message.setReceiverId(request.getReceiverIds().get(0));
        message.setReceiverType(request.getReceiverType());
        
        // 处理消息内容
        if (request.getContent() != null) {
            message.setContent(com.alibaba.fastjson.JSON.toJSONString(request.getContent()));
        }
        
        message.setTemplateId(request.getTemplateId());
        message.setSendStatus(0); // 待发送
        message.setSendTime(LocalDateTime.now());
        message.setRetryCount(0);
        
        // 设置重试配置
        if (request.getRetryConfig() != null) {
            message.setMaxRetryCount(request.getRetryConfig().getMaxRetryCount());
        } else {
            message.setMaxRetryCount(3);
        }
        
        message.setCallbackUrl(request.getCallbackUrl());
        
        if (request.getExtParams() != null) {
            message.setExtData(com.alibaba.fastjson.JSON.toJSONString(request.getExtParams()));
        }
        
        message.setRemark(request.getRemark());
        
        return message;
    }

    /**
     * 异步发送消息
     */
    @Async("messageExecutor")
    protected void sendMessageAsync(Message message) {
        try {
            sendMessageSync(message);
        } catch (Exception e) {
            log.error("异步发送消息失败, messageId: {}", message.getId(), e);
        }
    }

    /**
     * 同步发送消息
     */
    private void sendMessageSync(Message message) {
        try {
            // 更新状态为发送中
            messageRepository.updateMessageStatus(message.getId(), 1, null, null);

            // 调用企微API发送消息
            String weworkMsgId = weWorkClient.sendMessage(message);
            
            // 更新发送成功状态
            message.setWeworkMsgId(weworkMsgId);
            message.setSendStatus(2);
            message.setCompleteTime(LocalDateTime.now());
            messageRepository.updateById(message);

            // 发布消息发送成功事件
            eventPublisher.publishEvent(new MessageSentEvent(message.getId(), true));

        } catch (Exception e) {
            log.error("发送消息失败, messageId: {}", message.getId(), e);
            
            // 更新发送失败状态
            messageRepository.updateMessageStatus(message.getId(), 3, 
                    e.getClass().getSimpleName(), e.getMessage());

            // 发布消息发送失败事件
            eventPublisher.publishEvent(new MessageSentEvent(message.getId(), false));
        }
    }

    /**
     * 计算下次重试时间
     */
    private LocalDateTime calculateNextRetryTime(int retryCount, LocalDateTime firstTime) {
        // 指数退避算法
        int delaySeconds = (int) Math.pow(2, retryCount) * 60;
        return LocalDateTime.now().plusSeconds(delaySeconds);
    }

    /**
     * 转换为DTO
     */
    private MessageDTO convertToDTO(Message message) {
        MessageDTO dto = new MessageDTO();
        BeanUtils.copyProperties(message, dto);
        
        // 转换时间戳
        dto.setSendTime(message.getSendTime() != null ? 
                       message.getSendTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setCompleteTime(message.getCompleteTime() != null ? 
                           message.getCompleteTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setCreatedAt(message.getCreatedAt() != null ? 
                        message.getCreatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setUpdatedAt(message.getUpdatedAt() != null ? 
                        message.getUpdatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        
        // 设置类型名称
        dto.setMessageTypeName(getMessageTypeName(message.getMessageType()));
        dto.setSendTypeName(getSendTypeName(message.getSendType()));
        dto.setSendStatusName(getSendStatusName(message.getSendStatus()));
        
        return dto;
    }

    private String getMessageTypeName(Integer type) {
        if (type == null) return "";
        switch (type) {
            case 1: return "文本";
            case 2: return "图片";
            case 3: return "视频";
            case 4: return "文件";
            case 5: return "链接";
            case 6: return "小程序";
            case 7: return "群发";
            default: return "未知";
        }
    }

    private String getSendTypeName(Integer type) {
        if (type == null) return "";
        switch (type) {
            case 1: return "单发";
            case 2: return "群发";
            case 3: return "朋友圈";
            default: return "未知";
        }
    }

    private String getSendStatusName(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 0: return "待发送";
            case 1: return "发送中";
            case 2: return "发送成功";
            case 3: return "发送失败";
            case 4: return "部分成功";
            case 5: return "已撤回";
            default: return "未知";
        }
    }
}