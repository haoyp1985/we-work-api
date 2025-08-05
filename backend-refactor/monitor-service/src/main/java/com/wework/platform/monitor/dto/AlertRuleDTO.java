package com.wework.platform.monitor.dto;

import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 告警规则DTO
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "告警规则信息")
public class AlertRuleDTO {

    @Schema(description = "规则ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "规则名称")
    private String ruleName;

    @Schema(description = "规则描述")
    private String description;

    @Schema(description = "监控指标名称")
    private String metricName;

    @Schema(description = "比较操作符")
    private String comparisonOperator;

    @Schema(description = "阈值")
    private BigDecimal thresholdValue;

    @Schema(description = "告警级别")
    private AlertLevel alertLevel;

    @Schema(description = "持续时间(分钟)")
    private Integer durationMinutes;

    @Schema(description = "评估间隔(分钟)")
    private Integer evaluationInterval;

    @Schema(description = "通知渠道")
    private String notificationChannels;

    @Schema(description = "恢复通知")
    private Boolean recoveryNotification;

    @Schema(description = "规则状态")
    private AlertStatus status;

    @Schema(description = "最后执行时间")
    private LocalDateTime lastExecutedAt;

    @Schema(description = "最后告警时间")
    private LocalDateTime lastAlertedAt;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;
}