package com.wework.platform.message.service.impl;

import com.alibaba.fastjson2.JSON;
import com.wework.platform.common.dto.message.BatchSendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageResponse;
import com.wework.platform.common.entity.MessageRecord;
import com.wework.platform.common.enums.MessageStatus;
import com.wework.platform.common.enums.MessageTemplateType;
import com.wework.platform.common.exception.BusinessException;
import com.wework.platform.message.provider.WeWorkApiProvider;
import com.wework.platform.message.provider.WeWorkProviderManager;
import com.wework.platform.message.service.MessageSendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Retryable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

/**
 * 消息发送服务实现
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MessageSendServiceImpl implements MessageSendService {

    private final WeWorkProviderManager providerManager;
    private final RocketMQTemplate rocketMQTemplate;
    private final RedisTemplate<String, Object> redisTemplate;

    @Value("${app.message.retry.max-attempts:3}")
    private int maxRetryAttempts;

    @Value("${app.message.retry.delay-ms:1000}")
    private long retryDelayMs;

    @Value("${app.message.retry.multiplier:2.0}")
    private double retryMultiplier;

    @Value("${app.message.limits.rate-limit-per-minute:1000}")
    private int rateLimitPerMinute;

    private static final String REDIS_KEY_PREFIX = "message:";
    private static final String REDIS_RATE_LIMIT_PREFIX = "rate_limit:";
    private static final String ROCKETMQ_TOPIC_ASYNC_MESSAGE = "async-message-send";
    private static final String ROCKETMQ_TOPIC_MESSAGE_CALLBACK = "message-callback";

    @Override
    public SendMessageResponse sendMessage(SendMessageRequest request) {
        // 参数验证
        validateSendRequest(request);
        
        // 速率限制检查
        checkRateLimit(request.getGuid());
        
        // 选择提供商
        WeWorkApiProvider provider = selectProvider(request);
        
        // 记录消息发送开始
        String messageId = UUID.randomUUID().toString();
        cacheMessageRequest(messageId, request);
        
        try {
            // 发送消息
            SendMessageResponse response = sendMessageInternal(provider, request);
            
            // 更新消息状态
            updateMessageStatus(messageId, response);
            
            return response;
            
        } catch (Exception e) {
            log.error("发送消息失败", e);
            
            // 记录失败状态
            SendMessageResponse errorResponse = SendMessageResponse.error(-1, e.getMessage());
            updateMessageStatus(messageId, errorResponse);
            
            // 尝试故障转移
            return handleFailoverIfNeeded(request, provider, e);
        }
    }

    @Override
    @Async
    public String sendMessageAsync(SendMessageRequest request) {
        String taskId = UUID.randomUUID().toString();
        
        try {
            // 将消息发送任务发送到RocketMQ
            rocketMQTemplate.convertAndSend(ROCKETMQ_TOPIC_ASYNC_MESSAGE, request);
            
            // 缓存任务状态
            redisTemplate.opsForValue().set(
                REDIS_KEY_PREFIX + "async_task:" + taskId,
                Map.of("status", "PENDING", "request", request),
                Duration.ofHours(1)
            );
            
            log.info("异步消息发送任务已提交: {}", taskId);
            return taskId;
            
        } catch (Exception e) {
            log.error("提交异步消息发送任务失败: {}", taskId, e);
            throw new BusinessException("提交异步任务失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> batchSendMessage(BatchSendMessageRequest request) {
        // 参数验证
        validateBatchSendRequest(request);
        
        // 选择提供商
        WeWorkApiProvider provider = selectProviderForBatch(request);
        
        try {
            // 批量发送
            Map<String, Object> response = provider.batchSendMessage(request);
            
            log.info("批量消息发送完成, guid: {}, 用户数: {}, 群数: {}", 
                    request.getGuid(),
                    request.getUserList() != null ? request.getUserList().size() : 0,
                    request.getRoomList() != null ? request.getRoomList().size() : 0);
            
            return response;
            
        } catch (Exception e) {
            log.error("批量发送消息失败", e);
            throw new BusinessException("批量发送失败: " + e.getMessage());
        }
    }

    @Override
    @Retryable(
        value = {Exception.class},
        maxAttempts = 3,
        backoff = @Backoff(delay = 1000, multiplier = 2.0)
    )
    public SendMessageResponse retryMessage(String messageId) {
        try {
            // 从缓存获取原始请求
            SendMessageRequest originalRequest = getCachedMessageRequest(messageId);
            if (originalRequest == null) {
                throw new BusinessException("找不到原始消息请求: " + messageId);
            }
            
            log.info("重试发送消息: {}", messageId);
            
            // 重新发送
            return sendMessage(originalRequest);
            
        } catch (Exception e) {
            log.error("重试发送消息失败: {}", messageId, e);
            throw new BusinessException("重试发送失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> recallMessage(String guid, String messageId) {
        try {
            // 获取默认提供商
            WeWorkApiProvider provider = providerManager.getDefaultProvider();
            
            // 撤回消息
            Map<String, Object> response = provider.recallMessage(guid, messageId);
            
            log.info("消息撤回完成, guid: {}, messageId: {}", guid, messageId);
            
            return response;
            
        } catch (Exception e) {
            log.error("撤回消息失败, guid: {}, messageId: {}", guid, messageId, e);
            throw new BusinessException("撤回消息失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> getMessageStatus(String messageId) {
        try {
            Object status = redisTemplate.opsForValue().get(REDIS_KEY_PREFIX + "status:" + messageId);
            
            if (status == null) {
                return Map.of("messageId", messageId, "status", "NOT_FOUND");
            }
            
            return (Map<String, Object>) status;
            
        } catch (Exception e) {
            log.error("获取消息状态失败: {}", messageId, e);
            return Map.of("messageId", messageId, "status", "ERROR", "error", e.getMessage());
        }
    }

    // ================================
    // 私有方法
    // ================================

    /**
     * 验证发送请求参数
     */
    private void validateSendRequest(SendMessageRequest request) {
        if (!StringUtils.hasText(request.getGuid())) {
            throw new BusinessException("实例GUID不能为空");
        }
        
        if (!StringUtils.hasText(request.getConversationId())) {
            throw new BusinessException("会话ID不能为空");
        }
        
        if (request.getMessageType() == null) {
            throw new BusinessException("消息类型不能为空");
        }
        
        // 根据消息类型验证必要字段
        switch (request.getMessageType()) {
            case TEXT -> {
                if (!StringUtils.hasText(request.getContent())) {
                    throw new BusinessException("文本消息内容不能为空");
                }
            }
            case IMAGE -> {
                if (!StringUtils.hasText(request.getFileId())) {
                    throw new BusinessException("图片消息文件ID不能为空");
                }
            }
            case LINK -> {
                if (!StringUtils.hasText(request.getLinkUrl())) {
                    throw new BusinessException("链接消息URL不能为空");
                }
            }
            // 其他类型的验证...
        }
    }

    /**
     * 验证批量发送请求参数
     */
    private void validateBatchSendRequest(BatchSendMessageRequest request) {
        if (!StringUtils.hasText(request.getGuid())) {
            throw new BusinessException("实例GUID不能为空");
        }
        
        if ((request.getUserList() == null || request.getUserList().isEmpty()) &&
            (request.getRoomList() == null || request.getRoomList().isEmpty())) {
            throw new BusinessException("用户列表和群列表不能同时为空");
        }
        
        // 检查数量限制
        int userCount = request.getUserList() != null ? request.getUserList().size() : 0;
        int roomCount = request.getRoomList() != null ? request.getRoomList().size() : 0;
        
        if (userCount + roomCount > 200) {
            throw new BusinessException("批量发送目标总数不能超过200个");
        }
    }

    /**
     * 速率限制检查
     */
    private void checkRateLimit(String guid) {
        String rateLimitKey = REDIS_RATE_LIMIT_PREFIX + guid + ":" + 
                            (System.currentTimeMillis() / 60000); // 按分钟分组
        
        Long currentCount = redisTemplate.opsForValue().increment(rateLimitKey);
        redisTemplate.expire(rateLimitKey, Duration.ofMinutes(1));
        
        if (currentCount != null && currentCount > rateLimitPerMinute) {
            throw new BusinessException("发送频率超限，请稍后再试");
        }
    }

    /**
     * 选择提供商
     */
    private WeWorkApiProvider selectProvider(SendMessageRequest request) {
        // 如果指定了提供商代码，优先使用指定的
        if (StringUtils.hasText(request.getProviderCode())) {
            return providerManager.getProvider(request.getProviderCode())
                    .orElseThrow(() -> new BusinessException("指定的提供商不存在: " + request.getProviderCode()));
        }
        
        // 根据消息类型选择支持的提供商
        return providerManager.getProviderForMessageType(request.getMessageType());
    }

    /**
     * 选择批量发送提供商
     */
    private WeWorkApiProvider selectProviderForBatch(BatchSendMessageRequest request) {
        if (StringUtils.hasText(request.getProviderCode())) {
            return providerManager.getProvider(request.getProviderCode())
                    .orElseThrow(() -> new BusinessException("指定的提供商不存在: " + request.getProviderCode()));
        }
        
        return providerManager.getProviderForFeature("BATCH_SEND");
    }

    /**
     * 发送消息内部方法
     */
    private SendMessageResponse sendMessageInternal(WeWorkApiProvider provider, SendMessageRequest request) {
        return switch (request.getMessageType()) {
            case TEXT -> provider.sendTextMessage(request);
            case IMAGE -> provider.sendImageMessage(request);
            case VIDEO -> provider.sendVideoMessage(request);
            case FILE -> provider.sendFileMessage(request);
            case VOICE -> provider.sendVoiceMessage(request);
            case LINK -> provider.sendLinkMessage(request);
            case MINIPROGRAM -> provider.sendMiniProgramMessage(request);
            case CONTACT -> provider.sendContactMessage(request);
            case LOCATION -> provider.sendLocationMessage(request);
            case GIF -> provider.sendGifMessage(request);
            case MENTION -> provider.sendMentionMessage(request);
            case QUOTE -> provider.sendQuoteMessage(request);
            default -> throw new BusinessException("不支持的消息类型: " + request.getMessageType());
        };
    }

    /**
     * 处理故障转移
     */
    private SendMessageResponse handleFailoverIfNeeded(SendMessageRequest request, 
                                                     WeWorkApiProvider failedProvider, 
                                                     Exception originalError) {
        try {
            // 尝试获取下一个可用提供商
            var nextProvider = providerManager.getNextAvailableProvider(failedProvider.getProviderCode());
            
            if (nextProvider.isPresent()) {
                log.warn("提供商 {} 发送失败，尝试故障转移到 {}", 
                        failedProvider.getProviderCode(), nextProvider.get().getProviderCode());
                
                return sendMessageInternal(nextProvider.get(), request);
            }
            
        } catch (Exception e) {
            log.error("故障转移也失败了", e);
        }
        
        // 如果故障转移失败，返回原始错误
        return SendMessageResponse.error(-1, "发送失败: " + originalError.getMessage());
    }

    /**
     * 缓存消息请求
     */
    private void cacheMessageRequest(String messageId, SendMessageRequest request) {
        try {
            redisTemplate.opsForValue().set(
                REDIS_KEY_PREFIX + "request:" + messageId,
                request,
                Duration.ofHours(24)
            );
        } catch (Exception e) {
            log.warn("缓存消息请求失败: {}", messageId, e);
        }
    }

    /**
     * 获取缓存的消息请求
     */
    private SendMessageRequest getCachedMessageRequest(String messageId) {
        try {
            Object cached = redisTemplate.opsForValue().get(REDIS_KEY_PREFIX + "request:" + messageId);
            if (cached instanceof SendMessageRequest) {
                return (SendMessageRequest) cached;
            }
        } catch (Exception e) {
            log.warn("获取缓存消息请求失败: {}", messageId, e);
        }
        return null;
    }

    /**
     * 更新消息状态
     */
    private void updateMessageStatus(String messageId, SendMessageResponse response) {
        try {
            Map<String, Object> status = Map.of(
                "messageId", messageId,
                "success", response.getSuccess(),
                "errorCode", response.getErrorCode(),
                "errorMessage", response.getErrorMessage(),
                "updateTime", LocalDateTime.now()
            );
            
            redisTemplate.opsForValue().set(
                REDIS_KEY_PREFIX + "status:" + messageId,
                status,
                Duration.ofDays(7)
            );
            
        } catch (Exception e) {
            log.warn("更新消息状态失败: {}", messageId, e);
        }
    }
}