package com.wework.platform.monitor.dto;

import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 告警记录DTO
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "告警记录信息")
public class AlertDTO {

    @Schema(description = "告警ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "告警规则ID")
    private String ruleId;

    @Schema(description = "告警标题")
    private String title;

    @Schema(description = "告警描述")
    private String description;

    @Schema(description = "告警级别")
    private AlertLevel alertLevel;

    @Schema(description = "告警状态")
    private AlertStatus status;

    @Schema(description = "服务名称")
    private String serviceName;

    @Schema(description = "指标名称")
    private String metricName;

    @Schema(description = "当前值")
    private BigDecimal currentValue;

    @Schema(description = "阈值")
    private BigDecimal thresholdValue;

    @Schema(description = "告警标签")
    private String alertTags;

    @Schema(description = "告警开始时间")
    private LocalDateTime startedAt;

    @Schema(description = "告警结束时间")
    private LocalDateTime endedAt;

    @Schema(description = "确认时间")
    private LocalDateTime acknowledgedAt;

    @Schema(description = "确认人")
    private String acknowledgedBy;

    @Schema(description = "通知状态")
    private Boolean notificationSent;

    @Schema(description = "通知时间")
    private LocalDateTime notifiedAt;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;
}