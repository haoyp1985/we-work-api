package com.wework.platform.task.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.*;
import java.util.Map;

/**
 * 更新任务定义请求DTO
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "更新任务定义请求")
public class UpdateTaskDefinitionRequest {

    @Size(min = 2, max = 100, message = "任务名称长度必须在2-100之间")
    @Schema(description = "任务名称", example = "数据同步任务")
    private String taskName;

    @Size(max = 500, message = "任务描述长度不能超过500")
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

    @Pattern(regexp = "^[0-9\\s\\*\\?\\-\\/\\,]+$", message = "Cron表达式格式不正确")
    @Schema(description = "Cron表达式", example = "0 0 */6 * * ?")
    private String cronExpression;

    @Schema(description = "任务参数")
    private Map<String, Object> parameters;

    @Min(value = 1, message = "超时时间必须大于0")
    @Max(value = 86400, message = "超时时间不能超过1天")
    @Schema(description = "超时时间(秒)", example = "3600")
    private Integer timeoutSeconds;

    @Schema(description = "超时时间(秒) - 别名", example = "3600")
    private Integer timeout;

    @Schema(description = "任务状态", example = "ACTIVE")
    private String status;

    @Min(value = 0, message = "最大重试次数不能小于0")
    @Max(value = 10, message = "最大重试次数不能超过10")
    @Schema(description = "最大重试次数", example = "3")
    private Integer maxRetryCount;

    @Min(value = 1, message = "重试间隔必须大于0")
    @Max(value = 3600, message = "重试间隔不能超过1小时")
    @Schema(description = "重试间隔(秒)", example = "300")
    private Integer retryIntervalSeconds;

    @Min(value = 1, message = "任务优先级必须大于0")
    @Max(value = 10, message = "任务优先级不能超过10")
    @Schema(description = "任务优先级(1-10)", example = "5")
    private Integer priority;

    @Schema(description = "是否启用", example = "true")
    private Boolean enabled;

    /**
     * 检查是否有字段需要更新
     */
    public boolean hasUpdates() {
        return taskName != null ||
               description != null ||
               taskType != null ||
               handlerClass != null ||
               cronExpression != null ||
               parameters != null ||
               timeoutSeconds != null ||
               maxRetryCount != null ||
               retryIntervalSeconds != null ||
               priority != null ||
               enabled != null;
    }

    /**
     * 验证更新字段
     */
    public String validate() {
        if (cronExpression != null && !cronExpression.trim().isEmpty()) {
            String[] parts = cronExpression.trim().split("\\s+");
            if (parts.length != 6 && parts.length != 7) {
                return "Cron表达式格式错误，应该包含6或7个字段";
            }
        }
        
        if (handlerClass != null && !handlerClass.trim().isEmpty()) {
            if (!handlerClass.matches("^[a-zA-Z_][a-zA-Z0-9_]*(\\.[a-zA-Z_][a-zA-Z0-9_]*)*$")) {
                return "处理器类名格式不正确";
            }
        }
        
        return null;
    }
}