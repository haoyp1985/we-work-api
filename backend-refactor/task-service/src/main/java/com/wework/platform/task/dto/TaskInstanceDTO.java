package com.wework.platform.task.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 任务实例DTO
 * 用于API响应和前端展示
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "任务实例信息")
public class TaskInstanceDTO {

    @Schema(description = "任务实例ID", example = "550e8400-e29b-41d4-a716-446655440000")
    private String id;

    @Schema(description = "租户ID", example = "tenant_001")
    private String tenantId;

    @Schema(description = "任务定义ID", example = "550e8400-e29b-41d4-a716-446655440001")
    private String definitionId;

    @Schema(description = "任务定义ID - 别名", example = "550e8400-e29b-41d4-a716-446655440001")
    private String taskDefinitionId;

    @Schema(description = "任务定义名称", example = "数据同步任务")
    private String definitionName;

    @Schema(description = "实例名称", example = "数据同步任务-20240101120000")
    private String instanceName;

    @Schema(description = "任务状态", example = "SUCCESS")
    private String status;

    @Schema(description = "执行状态 - 别名", example = "SUCCESS")
    private String executionStatus;

    @Schema(description = "执行结果")
    private String executionResult;

    @Schema(description = "执行参数")
    private String executionParams;

    @Schema(description = "任务优先级", example = "5")
    private Integer priority;

    @Schema(description = "计划执行时间", example = "2024-01-01T12:00:00")
    private LocalDateTime scheduledTime;

    @Schema(description = "实际开始时间", example = "2024-01-01T12:00:05")
    private LocalDateTime startTime;

    @Schema(description = "结束时间", example = "2024-01-01T12:05:30")
    private LocalDateTime endTime;

    @Schema(description = "执行时长(毫秒)", example = "325000")
    private Long executionDuration;

    @Schema(description = "执行节点", example = "node-001")
    private String executionNode;

    @Schema(description = "当前重试次数", example = "1")
    private Integer retryCount;

    @Schema(description = "最大重试次数", example = "3")
    private Integer maxRetryCount;

    @Schema(description = "下次重试时间", example = "2024-01-01T12:15:00")
    private LocalDateTime nextRetryTime;

    @Schema(description = "结果数据")
    private Object resultData;

    @Schema(description = "错误信息", example = "连接超时")
    private String errorMessage;

    @Schema(description = "锁版本号", example = "1")
    private Integer lockVersion;

    @Schema(description = "创建时间", example = "2024-01-01T11:55:00")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间", example = "2024-01-01T12:05:30")
    private LocalDateTime updatedAt;

    /**
     * 扩展信息
     */
    @Schema(description = "扩展属性")
    private Map<String, Object> properties;

    /**
     * 统计信息
     */
    @Schema(description = "日志总数")
    private Long logCount;

    @Schema(description = "错误日志数")
    private Long errorLogCount;

    @Schema(description = "警告日志数")
    private Long warningLogCount;

    /**
     * 计算执行时长
     */
    public Long getExecutionDuration() {
        if (startTime != null && endTime != null) {
            return java.time.Duration.between(startTime, endTime).toMillis();
        }
        return executionDuration;
    }

    /**
     * 检查是否正在执行
     */
    public boolean isRunning() {
        return "RUNNING".equals(status);
    }

    /**
     * 检查是否执行成功
     */
    public boolean isSuccess() {
        return "SUCCESS".equals(status);
    }

    /**
     * 检查是否执行失败
     */
    public boolean isFailed() {
        return "FAILED".equals(status);
    }

    /**
     * 检查是否已取消
     */
    public boolean isCancelled() {
        return "CANCELLED".equals(status);
    }

    /**
     * 检查是否等待重试
     */
    public boolean isWaitingRetry() {
        return "WAITING_RETRY".equals(status);
    }

    /**
     * 检查是否已完成（成功或失败）
     */
    public boolean isCompleted() {
        return isSuccess() || isFailed() || isCancelled();
    }

    /**
     * 检查是否可以重试
     */
    public boolean canRetry() {
        return isFailed() && retryCount != null && maxRetryCount != null && retryCount < maxRetryCount;
    }

    /**
     * 获取剩余重试次数
     */
    public Integer getRemainingRetries() {
        if (retryCount == null || maxRetryCount == null) {
            return 0;
        }
        return Math.max(0, maxRetryCount - retryCount);
    }

    /**
     * 获取状态显示文本
     */
    public String getStatusText() {
        if (status == null) {
            return "未知";
        }
        
        switch (status) {
            case "PENDING": return "等待执行";
            case "RUNNING": return "执行中";
            case "SUCCESS": return "执行成功";
            case "FAILED": return "执行失败";
            case "CANCELLED": return "已取消";
            case "WAITING_RETRY": return "等待重试";
            default: return status;
        }
    }

    /**
     * 获取优先级显示文本
     */
    public String getPriorityText() {
        if (priority == null) {
            return "普通";
        }
        
        if (priority >= 8) {
            return "紧急";
        } else if (priority >= 6) {
            return "高";
        } else if (priority >= 4) {
            return "普通";
        } else {
            return "低";
        }
    }

    /**
     * 获取执行时长显示文本
     */
    public String getExecutionDurationText() {
        Long duration = getExecutionDuration();
        if (duration == null) {
            return "-";
        }
        
        long seconds = duration / 1000;
        if (seconds < 60) {
            return seconds + "秒";
        } else if (seconds < 3600) {
            return (seconds / 60) + "分" + (seconds % 60) + "秒";
        } else {
            long hours = seconds / 3600;
            long minutes = (seconds % 3600) / 60;
            return hours + "小时" + minutes + "分";
        }
    }

    /**
     * 检查是否超时
     */
    public boolean isTimeout(Integer timeoutSeconds) {
        if (timeoutSeconds == null || startTime == null) {
            return false;
        }
        
        LocalDateTime timeoutTime = startTime.plusSeconds(timeoutSeconds);
        return LocalDateTime.now().isAfter(timeoutTime);
    }

    /**
     * 获取进度百分比（基于执行时间估算）
     */
    public Integer getProgressPercentage(Integer estimatedDurationSeconds) {
        if (!isRunning() || startTime == null || estimatedDurationSeconds == null || estimatedDurationSeconds <= 0) {
            return null;
        }
        
        long elapsedSeconds = java.time.Duration.between(startTime, LocalDateTime.now()).getSeconds();
        int progress = (int) Math.min(95, (elapsedSeconds * 100L) / estimatedDurationSeconds);
        return Math.max(1, progress);
    }
}