package com.wework.platform.message.controller;

import com.wework.platform.common.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 企微回调处理控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/callbacks")
@RequiredArgsConstructor
@Tag(name = "回调处理", description = "企微回调消息处理相关接口")
public class CallbackController {

    private final RocketMQTemplate rocketMQTemplate;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String ROCKETMQ_TOPIC_MESSAGE_CALLBACK = "message-callback";
    private static final String REDIS_KEY_PREFIX = "callback:";

    @PostMapping("/webhook")
    @Operation(summary = "接收回调", description = "接收企微回调消息的Webhook端点")
    public ApiResponse<String> receiveCallback(@RequestBody Map<String, Object> callbackData) {
        
        try {
            String guid = (String) callbackData.get("guid");
            Integer notifyType = (Integer) callbackData.get("notify_type");
            
            log.info("收到企微回调: GUID={}, 回调类型={}", guid, notifyType);
            log.debug("回调数据: {}", callbackData);
            
            // 发送到RocketMQ进行异步处理
            rocketMQTemplate.convertAndSend(ROCKETMQ_TOPIC_MESSAGE_CALLBACK, callbackData);
            
            return ApiResponse.success("回调已接收");
            
        } catch (Exception e) {
            log.error("处理回调失败", e);
            return ApiResponse.error(500, "处理回调失败: " + e.getMessage());
        }
    }

    @GetMapping("/{guid}/recent")
    @Operation(summary = "获取最近回调", description = "获取指定GUID的最近回调记录")
    public ApiResponse<List<Object>> getRecentCallbacks(
            @Parameter(description = "实例GUID") @PathVariable String guid,
            @Parameter(description = "数量限制") @RequestParam(defaultValue = "20") int limit) {
        
        try {
            String recentKey = REDIS_KEY_PREFIX + "recent:" + guid;
            List<Object> recentKeys = redisTemplate.opsForList().range(recentKey, 0, limit - 1);
            
            if (recentKeys == null || recentKeys.isEmpty()) {
                return ApiResponse.success(List.of());
            }
            
            List<Object> callbacks = recentKeys.stream()
                    .map(key -> redisTemplate.opsForValue().get((String) key))
                    .filter(java.util.Objects::nonNull)
                    .toList();
            
            return ApiResponse.success(callbacks);
            
        } catch (Exception e) {
            log.error("获取最近回调失败: {}", guid, e);
            return ApiResponse.error(500, "获取回调失败: " + e.getMessage());
        }
    }

    @GetMapping("/{guid}/callbacks/{notifyType}")
    @Operation(summary = "获取指定类型回调", description = "获取指定GUID和回调类型的回调记录")
    public ApiResponse<List<Object>> getCallbacksByType(
            @Parameter(description = "实例GUID") @PathVariable String guid,
            @Parameter(description = "回调类型") @PathVariable Integer notifyType,
            @Parameter(description = "数量限制") @RequestParam(defaultValue = "10") int limit) {
        
        try {
            // 构建模糊匹配的键模式
            String pattern = REDIS_KEY_PREFIX + guid + ":" + notifyType + ":*";
            
            // 注意：在生产环境中应避免使用 KEYS 命令，这里仅用于演示
            // 实际应用中应该使用专门的索引或者分页查询
            var keys = redisTemplate.keys(pattern);
            
            if (keys == null || keys.isEmpty()) {
                return ApiResponse.success(List.of());
            }
            
            List<Object> callbacks = keys.stream()
                    .limit(limit)
                    .map(key -> redisTemplate.opsForValue().get(key))
                    .filter(java.util.Objects::nonNull)
                    .toList();
            
            return ApiResponse.success(callbacks);
            
        } catch (Exception e) {
            log.error("获取指定类型回调失败: GUID={}, 类型={}", guid, notifyType, e);
            return ApiResponse.error(500, "获取回调失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    @Operation(summary = "获取回调统计", description = "获取回调处理的统计信息")
    public ApiResponse<Map<String, Object>> getCallbackStats() {
        
        try {
            // 这里可以实现更复杂的统计逻辑
            // 目前返回基本信息
            Map<String, Object> stats = Map.of(
                "description", "回调统计功能",
                "note", "可以在这里添加更多统计信息，如消息数量、处理速度等"
            );
            
            return ApiResponse.success(stats);
            
        } catch (Exception e) {
            log.error("获取回调统计失败", e);
            return ApiResponse.error(500, "获取统计失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{guid}/callbacks")
    @Operation(summary = "清理回调记录", description = "清理指定GUID的回调记录")
    public ApiResponse<String> clearCallbacks(
            @Parameter(description = "实例GUID") @PathVariable String guid) {
        
        try {
            String pattern = REDIS_KEY_PREFIX + guid + "*";
            var keys = redisTemplate.keys(pattern);
            
            if (keys != null && !keys.isEmpty()) {
                redisTemplate.delete(keys);
                log.info("已清理回调记录: GUID={}, 数量={}", guid, keys.size());
            }
            
            return ApiResponse.success("回调记录已清理");
            
        } catch (Exception e) {
            log.error("清理回调记录失败: {}", guid, e);
            return ApiResponse.error(500, "清理失败: " + e.getMessage());
        }
    }
}