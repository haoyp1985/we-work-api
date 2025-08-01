package com.wework.platform.account.controller;

import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.common.dto.ApiResponse;
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

    private final WeWorkAccountRepository accountRepository;
    private final RedisTemplate<String, Object> redisTemplate;

    @GetMapping
    @Operation(summary = "服务健康检查", description = "检查账号服务的健康状态")
    public ApiResponse<Map<String, Object>> health() {
        Map<String, Object> healthInfo = new HashMap<>();
        
        try {
            // 检查数据库连接
            boolean dbHealth = checkDatabaseHealth();
            healthInfo.put("database", dbHealth ? "UP" : "DOWN");
            
            // 检查Redis连接
            boolean redisHealth = checkRedisHealth();
            healthInfo.put("redis", redisHealth ? "UP" : "DOWN");
            
            // 获取账号统计信息
            Map<String, Object> statistics = getAccountStatistics();
            healthInfo.put("statistics", statistics);
            
            // 服务信息
            healthInfo.put("service", "account-service");
            healthInfo.put("version", "1.0.0");
            healthInfo.put("timestamp", LocalDateTime.now());
            
            // 整体健康状态
            boolean overallHealth = dbHealth && redisHealth;
            healthInfo.put("status", overallHealth ? "UP" : "DOWN");
            
            if (overallHealth) {
                return ApiResponse.success("服务健康", healthInfo);
            } else {
                return ApiResponse.error(503, "服务不健康").requestId("health-check");
            }
            
        } catch (Exception e) {
            log.error("健康检查失败", e);
            healthInfo.put("status", "DOWN");
            healthInfo.put("error", e.getMessage());
            return ApiResponse.error(503, "健康检查失败").requestId("health-check");
        }
    }



    /**
     * 检查数据库健康状态
     */
    private boolean checkDatabaseHealth() {
        try {
            // 执行一个简单的数据库查询
            accountRepository.selectCount(null);
            return true;
        } catch (Exception e) {
            log.warn("数据库健康检查失败: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 检查Redis健康状态
     */
    private boolean checkRedisHealth() {
        try {
            // 执行一个简单的Redis操作
            String testKey = "health:check:" + System.currentTimeMillis();
            redisTemplate.opsForValue().set(testKey, "test", 10, java.util.concurrent.TimeUnit.SECONDS);
            String value = (String) redisTemplate.opsForValue().get(testKey);
            redisTemplate.delete(testKey);
            return "test".equals(value);
        } catch (Exception e) {
            log.warn("Redis健康检查失败: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 获取账号统计信息
     */
    private Map<String, Object> getAccountStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        try {
            // 这里可以添加更多统计信息
            statistics.put("timestamp", LocalDateTime.now());
            statistics.put("description", "账号统计信息");
            
        } catch (Exception e) {
            log.warn("获取统计信息失败: {}", e.getMessage());
            statistics.put("error", "获取统计信息失败");
        }
        
        return statistics;
    }
}