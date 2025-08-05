package com.wework.platform.task.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.*;
import java.util.Map;

/**
 * 创建任务定义请求DTO
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "创建任务定义请求")
public class CreateTaskDefinitionRequest {

    @NotBlank(message = "任务名称不能为空")
    @Size(min = 2, max = 100, message = "任务名称长度必须在2-100之间")
    @Schema(description = "任务名称", example = "数据同步任务", required = true)
    private String taskName;

    @Size(max = 500, message = "任务描述长度不能超过500")
    @Schema(description = "任务描述", example = "定时同步企微账号状态")
    private String description;

    @NotBlank(message = "任务类型不能为空")
    @Schema(description = "任务类型", example = "SYNC", required = true)
    private String taskType;

    @NotBlank(message = "处理器类名不能为空")
    @Schema(description = "处理器类名", example = "com.wework.platform.task.handler.impl.AccountSyncHandler", required = true)
    private String handlerClass;

    @Pattern(regexp = "^[0-9\\s\\*\\?\\-\\/\\,]+$", message = "Cron表达式格式不正确")
    @Schema(description = "Cron表达式", example = "0 0 */6 * * ?")
    private String cronExpression;

    @Schema(description = "任务参数")
    private Map<String, Object> parameters;

    @Min(value = 1, message = "超时时间必须大于0")
    @Max(value = 86400, message = "超时时间不能超过1天")
    @Schema(description = "超时时间(秒)", example = "3600")
    private Integer timeoutSeconds;

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
     * 设置默认值
     */
    public void setDefaults() {
        if (timeoutSeconds == null) {
            timeoutSeconds = 3600; // 默认1小时
        }
        if (maxRetryCount == null) {
            maxRetryCount = 3; // 默认重试3次
        }
        if (retryIntervalSeconds == null) {
            retryIntervalSeconds = 300; // 默认5分钟
        }
        if (priority == null) {
            priority = 5; // 默认优先级
        }
        if (enabled == null) {
            enabled = true; // 默认启用
        }
    }

    /**
     * 验证Cron表达式和处理器类名
     */
    public String validate() {
        if (cronExpression != null && !cronExpression.trim().isEmpty()) {
            // 这里可以添加Cron表达式验证逻辑
            String[] parts = cronExpression.trim().split("\\s+");
            if (parts.length != 6 && parts.length != 7) {
                return "Cron表达式格式错误，应该包含6或7个字段";
            }
        }
        
        if (handlerClass != null && !handlerClass.trim().isEmpty()) {
            // 验证类名格式
            if (!handlerClass.matches("^[a-zA-Z_][a-zA-Z0-9_]*(\\.[a-zA-Z_][a-zA-Z0-9_]*)*$")) {
                return "处理器类名格式不正确";
            }
        }
        
        return null; // 验证通过
    }
}