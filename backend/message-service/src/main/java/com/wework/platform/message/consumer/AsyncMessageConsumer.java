package com.wework.platform.message.consumer;

import com.alibaba.fastjson2.JSON;
import com.wework.platform.common.dto.message.SendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageResponse;
import com.wework.platform.message.service.MessageSendService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * 异步消息发送消费者
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
    topic = "async-message-send",
    consumerGroup = "message-service-async-consumer",
    selectorExpression = "*"
)
public class AsyncMessageConsumer implements RocketMQListener<SendMessageRequest> {

    private final MessageSendService messageSendService;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String REDIS_KEY_PREFIX = "message:async_task:";

    @Override
    public void onMessage(SendMessageRequest request) {
        String taskId = null;
        long startTime = System.currentTimeMillis();
        
        try {
            // 生成任务ID（如果没有的话）
            taskId = request.getExtra() != null ? 
                    (String) request.getExtra().get("taskId") : 
                    java.util.UUID.randomUUID().toString();
            
            log.info("开始处理异步消息发送任务: {}, 消息类型: {}, 会话ID: {}", 
                    taskId, request.getMessageType(), request.getConversationId());
            
            // 更新任务状态为处理中
            updateTaskStatus(taskId, "PROCESSING", null, null);
            
            // 执行消息发送
            SendMessageResponse response = messageSendService.sendMessage(request);
            
            // 更新任务状态
            if (response.getSuccess()) {
                updateTaskStatus(taskId, "COMPLETED", response, null);
                log.info("异步消息发送成功: {}, 消息ID: {}, 耗时: {}ms", 
                        taskId, response.getMessageId(), System.currentTimeMillis() - startTime);
            } else {
                updateTaskStatus(taskId, "FAILED", response, response.getErrorMessage());
                log.error("异步消息发送失败: {}, 错误: {}, 耗时: {}ms", 
                        taskId, response.getErrorMessage(), System.currentTimeMillis() - startTime);
            }
            
        } catch (Exception e) {
            log.error("处理异步消息发送任务异常: {}", taskId, e);
            updateTaskStatus(taskId, "ERROR", null, e.getMessage());
        }
    }

    /**
     * 更新任务状态
     */
    private void updateTaskStatus(String taskId, String status, SendMessageResponse response, String error) {
        try {
            Map<String, Object> taskStatus = Map.of(
                "taskId", taskId,
                "status", status,
                "updateTime", LocalDateTime.now(),
                "response", response != null ? response : Map.of(),
                "error", error != null ? error : ""
            );
            
            redisTemplate.opsForValue().set(
                REDIS_KEY_PREFIX + taskId,
                taskStatus,
                Duration.ofHours(24)
            );
            
        } catch (Exception e) {
            log.warn("更新异步任务状态失败: {}", taskId, e);
        }
    }
}