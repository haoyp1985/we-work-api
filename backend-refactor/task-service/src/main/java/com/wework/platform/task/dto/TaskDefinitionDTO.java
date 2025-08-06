package com.wework.platform.task.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * 任务定义DTO
 * 用于API响应和前端展示
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "任务定义信息")
public class TaskDefinitionDTO {

    @Schema(description = "任务定义ID", example = "550e8400-e29b-41d4-a716-446655440000")
    private String id;

    @Schema(description = "租户ID", example = "tenant_001")
    private String tenantId;

    @Schema(description = "任务名称", example = "数据同步任务")
    private String taskName;

    @Schema(description = "任务描述", example = "定时同步企微账号状态")
    private String description;

    @Schema(description = "任务类型", example = "SYNC")
    private String taskType;

    @Schema(description = "处理器类名", example = "com.wework.platform.task.handler.impl.AccountSyncHandler")
    private String handlerClass;

    @Schema(description = "处理器名称", example = "AccountSyncHandler")
    private String handlerName;

    @Schema(description = "调度类型", example = "CRON")
    private String scheduleType;

    @Schema(description = "固定间隔(毫秒)", example = "60000")
    private Long fixedInterval;

    @Schema(description = "执行参数(JSON格式)")
    private String executionParams;

    @Schema(description = "Cron表达式", example = "0 0 */6 * * ?")
    private String cronExpression;

    @Schema(description = "任务参数")
    private Map<String, Object> parameters;

    @Schema(description = "超时时间(秒)", example = "3600")
    private Integer timeoutSeconds;

    @Schema(description = "超时时间(秒) - 别名", example = "3600")
    private Integer timeout;

    @Schema(description = "最大重试次数", example = "3")
    private Integer maxRetryCount;

    @Schema(description = "重试间隔(秒)", example = "300")
    private Integer retryIntervalSeconds;

    @Schema(description = "任务优先级", example = "5")
    private Integer priority;

    @Schema(description = "是否启用", example = "true")
    private Boolean enabled;

    @Schema(description = "任务状态", example = "ACTIVE")
    private String status;

    @Schema(description = "下次执行时间", example = "2024-01-01T12:00:00")
    private LocalDateTime nextExecutionTime;

    @Schema(description = "上次执行时间", example = "2024-01-01T06:00:00")
    private LocalDateTime lastExecutionTime;

    @Schema(description = "上次执行状态", example = "SUCCESS")
    private String lastExecutionStatus;

    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间", example = "2024-01-01T00:00:00")
    private LocalDateTime updatedAt;

    @Schema(description = "创建人", example = "admin")
    private String createdBy;

    @Schema(description = "更新人", example = "admin")
    private String updatedBy;

    /**
     * 统计信息
     */
    @Schema(description = "总执行次数")
    private Long totalExecutions;

    @Schema(description = "成功执行次数")
    private Long successExecutions;

    @Schema(description = "失败执行次数")
    private Long failedExecutions;

    @Schema(description = "平均执行时间(毫秒)")
    private Long avgExecutionTime;

    @Schema(description = "最长执行时间(毫秒)")
    private Long maxExecutionTime;

    @Schema(description = "成功率")
    private Double successRate;

    /**
     * 计算成功率
     */
    public Double getSuccessRate() {
        if (totalExecutions == null || totalExecutions == 0) {
            return 0.0;
        }
        if (successExecutions == null) {
            return 0.0;
        }
        return (double) successExecutions / totalExecutions * 100;
    }

    /**
     * 检查是否为定时任务
     */
    public boolean isScheduled() {
        return cronExpression != null && !cronExpression.trim().isEmpty();
    }

    /**
     * 检查是否启用
     */
    public boolean isEnabled() {
        return Boolean.TRUE.equals(enabled);
    }

    /**
     * 检查状态是否激活
     */
    public boolean isActive() {
        return "ACTIVE".equals(status);
    }
}