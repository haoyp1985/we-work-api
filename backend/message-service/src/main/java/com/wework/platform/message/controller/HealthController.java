package com.wework.platform.message.controller;

import com.wework.platform.common.dto.ApiResponse;
import com.wework.platform.message.provider.WeWorkProviderManager;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 健康检查控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/health")
@RequiredArgsConstructor
@Tag(name = "健康检查", description = "服务健康状态检查")
public class HealthController {

    private final WeWorkProviderManager providerManager;
    private final RedisTemplate<String, Object> redisTemplate;

    @GetMapping("")
    @Operation(summary = "服务健康检查", description = "检查消息发送服务的整体健康状态")
    public ApiResponse<Map<String, Object>> health() {
        
        try {
            Map<String, Object> healthInfo = new HashMap<>();
            healthInfo.put("service", "message-service");
            healthInfo.put("status", "UP");
            healthInfo.put("timestamp", LocalDateTime.now());
            
            // 检查Redis连接
            Map<String, Object> redisHealth = checkRedisHealth();
            healthInfo.put("redis", redisHealth);
            
            // 检查企微提供商
            Map<String, Object> providersHealth = checkProvidersHealth();
            healthInfo.put("providers", providersHealth);
            
            // 检查RocketMQ（简单检查）
            Map<String, Object> rocketmqHealth = checkRocketMQHealth();
            healthInfo.put("rocketmq", rocketmqHealth);
            
            // 计算整体状态
            boolean overallHealthy = (boolean) redisHealth.get("healthy") && 
                                   (boolean) providersHealth.get("healthy") &&
                                   (boolean) rocketmqHealth.get("healthy");
            
            healthInfo.put("status", overallHealthy ? "UP" : "DOWN");
            
            return ApiResponse.success(healthInfo);
            
        } catch (Exception e) {
            log.error("健康检查失败", e);
            Map<String, Object> errorInfo = Map.of(
                "service", "message-service",
                "status", "DOWN",
                "error", e.getMessage(),
                "timestamp", LocalDateTime.now()
            );
            return ApiResponse.success(errorInfo);
        }
    }



    // ================================
    // 私有方法
    // ================================

    /**
     * 检查Redis健康状态
     */
    private Map<String, Object> checkRedisHealth() {
        try {
            // 尝试执行一个简单的Redis操作
            String testKey = "health_check_" + System.currentTimeMillis();
            redisTemplate.opsForValue().set(testKey, "test");
            String value = (String) redisTemplate.opsForValue().get(testKey);
            redisTemplate.delete(testKey);
            
            return Map.of(
                "healthy", "test".equals(value),
                "status", "test".equals(value) ? "UP" : "DOWN",
                "checkTime", LocalDateTime.now()
            );
            
        } catch (Exception e) {
            log.warn("Redis健康检查失败", e);
            return Map.of(
                "healthy", false,
                "status", "DOWN",
                "error", e.getMessage(),
                "checkTime", LocalDateTime.now()
            );
        }
    }

    /**
     * 检查企微提供商健康状态
     */
    private Map<String, Object> checkProvidersHealth() {
        try {
            Map<String, Boolean> providerHealthMap = providerManager.healthCheck();
            Map<String, Object> stats = providerManager.getProviderStats();
            
            boolean anyHealthy = providerHealthMap.values().stream().anyMatch(Boolean::booleanValue);
            
            return Map.of(
                "healthy", anyHealthy,
                "status", anyHealthy ? "UP" : "DOWN",
                "details", providerHealthMap,
                "stats", stats,
                "checkTime", LocalDateTime.now()
            );
            
        } catch (Exception e) {
            log.warn("提供商健康检查失败", e);
            return Map.of(
                "healthy", false,
                "status", "DOWN",
                "error", e.getMessage(),
                "checkTime", LocalDateTime.now()
            );
        }
    }

    /**
     * 检查RocketMQ健康状态
     */
    private Map<String, Object> checkRocketMQHealth() {
        try {
            // 这里可以添加更复杂的RocketMQ健康检查逻辑
            // 目前返回基本状态
            return Map.of(
                "healthy", true,
                "status", "UP",
                "note", "RocketMQ health check needs implementation",
                "checkTime", LocalDateTime.now()
            );
            
        } catch (Exception e) {
            log.warn("RocketMQ健康检查失败", e);
            return Map.of(
                "healthy", false,
                "status", "DOWN",
                "error", e.getMessage(),
                "checkTime", LocalDateTime.now()
            );
        }
    }
}