package com.wework.platform.task.handler;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 任务执行上下文
 * 包含任务执行所需的所有上下文信息
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaskContext {

    /**
     * 任务实例ID
     */
    private String taskId;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 任务定义ID
     */
    private String definitionId;

    /**
     * 任务实例名称
     */
    private String instanceName;

    /**
     * 任务参数
     */
    private Map<String, Object> parameters;

    /**
     * 当前重试次数
     */
    private Integer retryCount;

    /**
     * 最大重试次数
     */
    private Integer maxRetryCount;

    /**
     * 执行节点ID
     */
    private String executionNode;

    /**
     * 任务开始时间
     */
    private LocalDateTime startTime;

    /**
     * 计划执行时间
     */
    private LocalDateTime scheduledTime;

    /**
     * 任务类型
     */
    private String taskType;

    /**
     * 任务优先级
     */
    private Integer priority;

    /**
     * 超时时间（秒）
     */
    private Integer timeoutSeconds;

    /**
     * 扩展属性
     */
    private Map<String, Object> attributes;

    /**
     * 日志记录器（用于任务内部记录日志）
     */
    private TaskLogger logger;

    /**
     * 获取参数值
     * 
     * @param key 参数键
     * @return 参数值
     */
    public Object getParameter(String key) {
        return parameters != null ? parameters.get(key) : null;
    }

    /**
     * 获取参数值（带默认值）
     * 
     * @param key 参数键
     * @param defaultValue 默认值
     * @return 参数值或默认值
     */
    @SuppressWarnings("unchecked")
    public <T> T getParameter(String key, T defaultValue) {
        if (parameters == null) {
            return defaultValue;
        }
        T value = (T) parameters.get(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 获取字符串参数
     * 
     * @param key 参数键
     * @return 字符串值
     */
    public String getStringParameter(String key) {
        Object value = getParameter(key);
        return value != null ? value.toString() : null;
    }

    /**
     * 获取字符串参数（带默认值）
     * 
     * @param key 参数键
     * @param defaultValue 默认值
     * @return 字符串值或默认值
     */
    public String getStringParameter(String key, String defaultValue) {
        String value = getStringParameter(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 获取整数参数
     * 
     * @param key 参数键
     * @return 整数值
     */
    public Integer getIntParameter(String key) {
        Object value = getParameter(key);
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        if (value instanceof String) {
            try {
                return Integer.valueOf((String) value);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    /**
     * 获取整数参数（带默认值）
     * 
     * @param key 参数键
     * @param defaultValue 默认值
     * @return 整数值或默认值
     */
    public Integer getIntParameter(String key, Integer defaultValue) {
        Integer value = getIntParameter(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 获取布尔参数
     * 
     * @param key 参数键
     * @return 布尔值
     */
    public Boolean getBooleanParameter(String key) {
        Object value = getParameter(key);
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        if (value instanceof String) {
            return Boolean.valueOf((String) value);
        }
        return null;
    }

    /**
     * 获取布尔参数（带默认值）
     * 
     * @param key 参数键
     * @param defaultValue 默认值
     * @return 布尔值或默认值
     */
    public Boolean getBooleanParameter(String key, Boolean defaultValue) {
        Boolean value = getBooleanParameter(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 检查是否有指定参数
     * 
     * @param key 参数键
     * @return 是否存在
     */
    public boolean hasParameter(String key) {
        return parameters != null && parameters.containsKey(key);
    }

    /**
     * 获取属性值
     * 
     * @param key 属性键
     * @return 属性值
     */
    public Object getAttribute(String key) {
        return attributes != null ? attributes.get(key) : null;
    }

    /**
     * 设置属性值
     * 
     * @param key 属性键
     * @param value 属性值
     */
    public void setAttribute(String key, Object value) {
        if (attributes == null) {
            attributes = new java.util.HashMap<>();
        }
        attributes.put(key, value);
    }

    /**
     * 获取属性值（带默认值）
     * 
     * @param key 属性键
     * @param defaultValue 默认值
     * @return 属性值或默认值
     */
    @SuppressWarnings("unchecked")
    public <T> T getAttribute(String key, T defaultValue) {
        if (attributes == null) {
            return defaultValue;
        }
        T value = (T) attributes.get(key);
        return value != null ? value : defaultValue;
    }

    /**
     * 检查是否有指定属性
     * 
     * @param key 属性键
     * @return 是否存在
     */
    public boolean hasAttribute(String key) {
        return attributes != null && attributes.containsKey(key);
    }

    /**
     * 是否为首次执行（非重试）
     * 
     * @return 是否首次执行
     */
    public boolean isFirstExecution() {
        return retryCount == null || retryCount == 0;
    }

    /**
     * 是否为重试执行
     * 
     * @return 是否重试
     */
    public boolean isRetry() {
        return retryCount != null && retryCount > 0;
    }

    /**
     * 是否达到最大重试次数
     * 
     * @return 是否达到最大重试次数
     */
    public boolean isMaxRetryReached() {
        return retryCount != null && maxRetryCount != null && retryCount >= maxRetryCount;
    }

    /**
     * 计算剩余重试次数
     * 
     * @return 剩余重试次数
     */
    public int getRemainingRetries() {
        if (maxRetryCount == null) return 0;
        int current = retryCount != null ? retryCount : 0;
        return Math.max(0, maxRetryCount - current);
    }

    /**
     * 检查任务是否超时
     * 
     * @return 是否超时
     */
    public boolean isTimeout() {
        if (timeoutSeconds == null || startTime == null) {
            return false;
        }
        LocalDateTime timeoutTime = startTime.plusSeconds(timeoutSeconds);
        return LocalDateTime.now().isAfter(timeoutTime);
    }

    /**
     * 获取剩余执行时间（秒）
     * 
     * @return 剩余秒数，负数表示已超时
     */
    public long getRemainingTimeSeconds() {
        if (timeoutSeconds == null || startTime == null) {
            return Long.MAX_VALUE;
        }
        LocalDateTime timeoutTime = startTime.plusSeconds(timeoutSeconds);
        LocalDateTime now = LocalDateTime.now();
        return java.time.Duration.between(now, timeoutTime).getSeconds();
    }

    /**
     * 记录信息日志
     * 
     * @param message 日志消息
     */
    public void logInfo(String message) {
        if (logger != null) {
            logger.info(message);
        }
    }

    /**
     * 记录警告日志
     * 
     * @param message 日志消息
     */
    public void logWarn(String message) {
        if (logger != null) {
            logger.warn(message);
        }
    }

    /**
     * 记录错误日志
     * 
     * @param message 日志消息
     */
    public void logError(String message) {
        if (logger != null) {
            logger.error(message);
        }
    }

    /**
     * 记录错误日志（带异常）
     * 
     * @param message 日志消息
     * @param exception 异常
     */
    public void logError(String message, Exception exception) {
        if (logger != null) {
            logger.error(message, exception);
        }
    }

    /**
     * 创建子任务上下文
     * 
     * @param subTaskName 子任务名称
     * @return 子任务上下文
     */
    public TaskContext createSubContext(String subTaskName) {
        return TaskContext.builder()
                .taskId(this.taskId + ":" + subTaskName)
                .tenantId(this.tenantId)
                .definitionId(this.definitionId)
                .instanceName(this.instanceName + ":" + subTaskName)
                .parameters(this.parameters)
                .retryCount(this.retryCount)
                .maxRetryCount(this.maxRetryCount)
                .executionNode(this.executionNode)
                .startTime(LocalDateTime.now())
                .scheduledTime(this.scheduledTime)
                .taskType(this.taskType)
                .priority(this.priority)
                .timeoutSeconds(this.timeoutSeconds)
                .logger(this.logger)
                .build();
    }

    @Override
    public String toString() {
        return "TaskContext{" +
                "taskId='" + taskId + '\'' +
                ", tenantId='" + tenantId + '\'' +
                ", instanceName='" + instanceName + '\'' +
                ", retryCount=" + retryCount +
                ", maxRetryCount=" + maxRetryCount +
                ", executionNode='" + executionNode + '\'' +
                '}';
    }

    /**
     * 设置实例ID（用于兼容接口调用）
     */
    public void setInstanceId(String instanceId) {
        this.taskId = instanceId;
    }

    /**
     * 设置任务定义ID（用于兼容接口调用）
     */
    public void setTaskDefinitionId(String taskDefinitionId) {
        this.definitionId = taskDefinitionId;
    }

    /**
     * 设置执行参数（用于兼容接口调用）
     */
    public void setExecutionParams(String executionParams) {
        this.parameters = Map.of("executionParams", executionParams);
    }
}