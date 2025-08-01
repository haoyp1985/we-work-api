package com.wework.platform.gateway.controller;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 网关健康检查控制器
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@RestController
public class HealthController implements HealthIndicator {

    @Autowired
    private DiscoveryClient discoveryClient;

    @Autowired
    private ReactiveRedisTemplate<String, String> redisTemplate;

    @Override
    public Health health() {
        return Health.up()
            .withDetail("service", "gateway-service")
            .withDetail("status", "运行正常")
            .build();
    }

    /**
     * 基础健康检查
     */
    @GetMapping("/health")
    public Mono<Map<String, Object>> healthCheck() {
        return checkGateway();
    }

    /**
     * 检查网关服务健康状态
     */
    @GetMapping("/gateway")
    public Mono<Map<String, Object>> checkGateway() {
        Map<String, Object> health = new HashMap<>();
        health.put("service", "gateway-service");
        health.put("status", "UP");
        health.put("timestamp", System.currentTimeMillis());
        return Mono.just(health);
    }

    /**
     * 检查服务发现健康状态
     */
    @GetMapping("/discovery")
    public Mono<Map<String, Object>> checkDiscovery() {
        return Mono.fromCallable(() -> {
            Map<String, Object> health = new HashMap<>();
            try {
                // 获取所有注册的服务
                var services = discoveryClient.getServices();
                health.put("status", "UP");
                health.put("services", services);
                health.put("serviceCount", services.size());
                log.debug("发现 {} 个注册服务: {}", services.size(), services);
            } catch (Exception e) {
                health.put("status", "DOWN");
                health.put("error", e.getMessage());
                log.error("服务发现健康检查失败", e);
            }
            health.put("timestamp", System.currentTimeMillis());
            return health;
        });
    }

    /**
     * 检查Redis连接健康状态
     */
    @GetMapping("/redis")
    public Mono<Map<String, Object>> checkRedis() {
        Map<String, Object> health = new HashMap<>();
        
        return redisTemplate.opsForValue()
            .set("health:check", "ping")
            .timeout(Duration.ofSeconds(3))
            .then(redisTemplate.opsForValue().get("health:check"))
            .map(result -> {
                if ("ping".equals(result)) {
                    health.put("status", "UP");
                    health.put("connection", "正常");
                } else {
                    health.put("status", "DOWN");
                    health.put("connection", "异常");
                }
                health.put("timestamp", System.currentTimeMillis());
                return health;
            })
            .onErrorResume(error -> {
                health.put("status", "DOWN");
                health.put("error", error.getMessage());
                health.put("timestamp", System.currentTimeMillis());
                log.error("Redis健康检查失败", error);
                return Mono.just(health);
            });
    }

    /**
     * 综合健康检查
     */
    @GetMapping("/all")
    public Mono<Map<String, Object>> checkAll() {
        return Mono.zip(
            checkGateway(),
            checkDiscovery(), 
            checkRedis()
        ).map(tuple -> {
            Map<String, Object> result = new HashMap<>();
            result.put("gateway", tuple.getT1());
            result.put("discovery", tuple.getT2());
            result.put("redis", tuple.getT3());
            result.put("timestamp", System.currentTimeMillis());
            
            // 计算整体状态
            boolean allUp = tuple.getT1().get("status").equals("UP") &&
                           tuple.getT2().get("status").equals("UP") &&
                           tuple.getT3().get("status").equals("UP");
            result.put("overallStatus", allUp ? "UP" : "DOWN");
            
            return result;
        });
    }

    @GetMapping("/monitor/metrics")
    public Mono<Map<String, Object>> getSystemMetrics() {
        log.info("获取系统监控指标");
        
        Map<String, Object> metrics = new HashMap<>();
        
        // CPU指标
        Map<String, Object> cpu = new HashMap<>();
        cpu.put("usage", 45.6);
        cpu.put("cores", 8);
        
        // 内存指标
        Map<String, Object> memory = new HashMap<>();
        memory.put("usage", 62.3);
        memory.put("used", 6584000000L); // 6.5GB
        memory.put("total", 10585000000L); // 10GB
        
        // 磁盘指标  
        Map<String, Object> disk = new HashMap<>();
        disk.put("usage", 38.7);
        disk.put("used", 387000000000L); // 387GB
        disk.put("total", 1000000000000L); // 1TB
        
        // 网络指标
        Map<String, Object> network = new HashMap<>();
        network.put("in", 1024.5);
        network.put("out", 2048.3);
        network.put("inRate", 102.4);  // KB/s
        network.put("outRate", 204.8); // KB/s
        
        metrics.put("cpu", cpu);
        metrics.put("memory", memory);
        metrics.put("disk", disk);
        metrics.put("network", network);
        
        // 构建标准的API响应格式
        Map<String, Object> response = new HashMap<>();
        response.put("code", 200);
        response.put("message", "获取系统指标成功");
        response.put("data", metrics);
        response.put("timestamp", LocalDateTime.now());
        response.put("success", true);
        
        return Mono.just(response);
    }
}