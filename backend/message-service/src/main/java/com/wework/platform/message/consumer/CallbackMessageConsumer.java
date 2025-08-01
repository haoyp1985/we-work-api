package com.wework.platform.message.consumer;

import com.alibaba.fastjson2.JSON;
import com.wework.platform.common.dto.message.CallbackData;
import com.wework.platform.common.enums.CallbackType;
import com.wework.platform.message.provider.WeWorkProviderManager;
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
 * 企微回调消息消费者
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
    topic = "message-callback",
    consumerGroup = "message-service-callback-consumer",
    selectorExpression = "*"
)
public class CallbackMessageConsumer implements RocketMQListener<String> {

    private final WeWorkProviderManager providerManager;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String REDIS_KEY_PREFIX = "callback:";

    @Override
    public void onMessage(String message) {
        try {
            log.debug("收到回调消息: {}", message);
            
            // 解析回调数据
            Map<String, Object> rawData = JSON.parseObject(message, Map.class);
            CallbackData callbackData = parseCallbackData(rawData);
            
            // 缓存回调数据
            cacheCallbackData(callbackData);
            
            // 分发到相应的提供商处理
            providerManager.getAllProviders().forEach(provider -> {
                try {
                    provider.handleCallback(callbackData);
                } catch (Exception e) {
                    log.error("提供商处理回调失败: {}, 回调类型: {}", 
                            provider.getProviderCode(), callbackData.getCallbackType(), e);
                }
            });
            
            log.info("回调消息处理完成: {}, 类型: {}, GUID: {}", 
                    callbackData.getNotifyType(), callbackData.getCallbackType(), callbackData.getGuid());
            
        } catch (Exception e) {
            log.error("处理回调消息失败: {}", message, e);
        }
    }

    /**
     * 解析回调数据
     */
    private CallbackData parseCallbackData(Map<String, Object> rawData) {
        String guid = (String) rawData.get("guid");
        Integer notifyType = (Integer) rawData.get("notify_type");
        Object data = rawData.get("data");
        
        CallbackData callbackData = CallbackData.fromNotifyType(guid, notifyType, data);
        callbackData.setRawData(JSON.toJSONString(rawData));
        
        return callbackData;
    }

    /**
     * 缓存回调数据
     */
    private void cacheCallbackData(CallbackData callbackData) {
        try {
            String cacheKey = REDIS_KEY_PREFIX + callbackData.getGuid() + ":" + 
                             callbackData.getNotifyType() + ":" + System.currentTimeMillis();
            
            redisTemplate.opsForValue().set(
                cacheKey,
                callbackData,
                Duration.ofDays(1)
            );
            
            // 维护最近回调列表
            String recentKey = REDIS_KEY_PREFIX + "recent:" + callbackData.getGuid();
            redisTemplate.opsForList().leftPush(recentKey, cacheKey);
            redisTemplate.opsForList().trim(recentKey, 0, 99); // 保留最近100条
            redisTemplate.expire(recentKey, Duration.ofDays(7));
            
        } catch (Exception e) {
            log.warn("缓存回调数据失败", e);
        }
    }
}