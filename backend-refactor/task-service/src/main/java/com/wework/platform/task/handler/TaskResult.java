package com.wework.platform.task.handler;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 任务执行结果
 * 包含任务执行状态、结果数据和消息等信息
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaskResult {

    /**
     * 执行是否成功
     */
    private boolean success;

    /**
     * 结果消息
     */
    private String message;

    /**
     * 结果数据
     */
    private Object data;

    /**
     * 执行时间（毫秒）
     */
    private Long executionTime;

    /**
     * 扩展属性
     */
    private Map<String, Object> properties;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;

    /**
     * 创建成功结果
     * 
     * @return 成功结果
     */
    public static TaskResult success() {
        return TaskResult.builder()
                .success(true)
                .message("执行成功")
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 创建成功结果（带消息）
     * 
     * @param message 结果消息
     * @return 成功结果
     */
    public static TaskResult success(String message) {
        return TaskResult.builder()
                .success(true)
                .message(message)
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 创建成功结果（带数据）
     * 
     * @param data 结果数据
     * @return 成功结果
     */
    public static TaskResult success(Object data) {
        return TaskResult.builder()
                .success(true)
                .message("执行成功")
                .data(data)
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 创建成功结果（带消息和数据）
     * 
     * @param message 结果消息
     * @param data 结果数据
     * @return 成功结果
     */
    public static TaskResult success(String message, Object data) {
        return TaskResult.builder()
                .success(true)
                .message(message)
                .data(data)
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 创建失败结果
     * 
     * @param message 错误消息
     * @return 失败结果
     */
    public static TaskResult failure(String message) {
        return TaskResult.builder()
                .success(false)
                .message(message)
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 创建失败结果（带异常）
     * 
     * @param message 错误消息
     * @param exception 异常对象
     * @return 失败结果
     */
    public static TaskResult failure(String message, Exception exception) {
        return TaskResult.builder()
                .success(false)
                .message(message + ": " + exception.getMessage())
                .createdAt(LocalDateTime.now())
                .build();
    }

    /**
     * 添加执行时间
     * 
     * @param executionTime 执行时间（毫秒）
     * @return 当前对象
     */
    public TaskResult withExecutionTime(Long executionTime) {
        this.executionTime = executionTime;
        return this;
    }

    /**
     * 添加属性
     * 
     * @param key 属性键
     * @param value 属性值
     * @return 当前对象
     */
    public TaskResult withProperty(String key, Object value) {
        if (this.properties == null) {
            this.properties = new java.util.HashMap<>();
        }
        this.properties.put(key, value);
        return this;
    }

    /**
     * 添加多个属性
     * 
     * @param properties 属性映射
     * @return 当前对象
     */
    public TaskResult withProperties(Map<String, Object> properties) {
        if (this.properties == null) {
            this.properties = new java.util.HashMap<>();
        }
        this.properties.putAll(properties);
        return this;
    }

    /**
     * 获取属性值
     * 
     * @param key 属性键
     * @return 属性值
     */
    public Object getProperty(String key) {
        return properties != null ? properties.get(key) : null;
    }

    /**
     * 获取属性值（带默认值）
     * 
     * @param key 属性键
     * @param defaultValue 默认值
     * @return 属性值或默认值
     */
    @SuppressWarnings("unchecked")
    public <T> T getProperty(String key, T defaultValue) {
        if (properties == null) {
            return defaultValue;
        }
        T value = (T) properties.get(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 检查是否有指定属性
     * 
     * @param key 属性键
     * @return 是否存在
     */
    public boolean hasProperty(String key) {
        return properties != null && properties.containsKey(key);
    }

    /**
     * 转换为JSON字符串（用于存储）
     * 
     * @return JSON字符串
     */
    public String toJson() {
        try {
            // 这里可以使用Jackson或其他JSON库
            return "{\"success\":" + success + 
                   ",\"message\":\"" + (message != null ? message.replace("\"", "\\\"") : "") + "\"" +
                   ",\"data\":" + (data != null ? "\"" + data.toString().replace("\"", "\\\"") + "\"" : "null") +
                   ",\"executionTime\":" + executionTime +
                   "}";
        } catch (Exception e) {
            return "{\"success\":" + success + ",\"message\":\"" + message + "\"}";
        }
    }

    /**
     * 从JSON字符串创建TaskResult（用于从存储中恢复）
     * 
     * @param json JSON字符串
     * @return TaskResult对象
     */
    public static TaskResult fromJson(String json) {
        // 这里应该使用JSON库解析，这里只是简单示例
        if (json == null || json.trim().isEmpty()) {
            return TaskResult.failure("空的结果数据");
        }
        
        try {
            boolean success = json.contains("\"success\":true");
            String message = "解析的结果";
            
            return TaskResult.builder()
                    .success(success)
                    .message(message)
                    .build();
        } catch (Exception e) {
            return TaskResult.failure("解析结果失败: " + e.getMessage());
        }
    }

    @Override
    public String toString() {
        return "TaskResult{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", data=" + data +
                ", executionTime=" + executionTime +
                ", createdAt=" + createdAt +
                '}';
    }
}