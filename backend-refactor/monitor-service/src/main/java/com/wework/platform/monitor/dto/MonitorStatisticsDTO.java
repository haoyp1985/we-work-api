package com.wework.platform.monitor.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 监控统计DTO
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "监控统计信息")
public class MonitorStatisticsDTO {

    @Schema(description = "总指标数量")
    private Long totalMetrics;

    @Schema(description = "活跃服务数量")
    private Long activeServices;

    @Schema(description = "告警规则数量")
    private Long totalRules;

    @Schema(description = "启用的告警规则数量")
    private Long enabledRules;

    @Schema(description = "总告警数量")
    private Long totalAlerts;

    @Schema(description = "活跃告警数量")
    private Long activeAlerts;

    @Schema(description = "严重告警数量")
    private Long criticalAlerts;

    @Schema(description = "警告告警数量")
    private Long warningAlerts;

    @Schema(description = "信息告警数量")
    private Long infoAlerts;

    @Schema(description = "未确认告警数量")
    private Long unacknowledgedAlerts;

    @Schema(description = "今日新增告警数量")
    private Long todayNewAlerts;

    @Schema(description = "本周新增告警数量")
    private Long weekNewAlerts;

    @Schema(description = "本月新增告警数量")
    private Long monthNewAlerts;
}