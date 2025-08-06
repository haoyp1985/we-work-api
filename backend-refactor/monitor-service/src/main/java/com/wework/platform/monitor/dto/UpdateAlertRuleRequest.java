package com.wework.platform.monitor.dto;

import com.wework.platform.common.enums.AlertLevel;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * 更新告警规则请求DTO
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "更新告警规则请求")
public class UpdateAlertRuleRequest {

    @Schema(description = "规则名称", example = "CPU使用率告警")
    @Size(min = 2, max = 100, message = "规则名称长度必须在2-100之间")
    private String ruleName;

    @Schema(description = "规则描述", example = "当CPU使用率超过80%时触发告警")
    @Size(max = 500, message = "规则描述长度不能超过500")
    private String description;

    @Schema(description = "监控指标名称", example = "cpu_usage_percent")
    private String metricName;

    @Schema(description = "比较操作符", example = ">", allowableValues = {">", "<", ">=", "<=", "==", "!="})
    @Pattern(regexp = "^(>|<|>=|<=|==|!=)$", message = "比较操作符必须是 >, <, >=, <=, ==, != 中的一个")
    private String comparisonOperator;

    @Schema(description = "阈值", example = "80.0")
    @DecimalMin(value = "0", message = "阈值不能小于0")
    private BigDecimal thresholdValue;

    @Schema(description = "告警级别", example = "WARNING")
    private AlertLevel alertLevel;

    @Schema(description = "持续时间(分钟)", example = "5")
    @Min(value = 1, message = "持续时间不能小于1分钟")
    @Max(value = 1440, message = "持续时间不能超过1440分钟")
    private Integer durationMinutes;

    @Schema(description = "评估间隔(分钟)", example = "1")
    @Min(value = 1, message = "评估间隔不能小于1分钟")
    @Max(value = 60, message = "评估间隔不能超过60分钟")
    private Integer evaluationInterval;

    @Schema(description = "通知渠道(JSON格式)", example = "[\"email\", \"webhook\"]")
    private String notificationChannels;

    @Schema(description = "恢复通知", example = "true")
    private Boolean recoveryNotification;
}