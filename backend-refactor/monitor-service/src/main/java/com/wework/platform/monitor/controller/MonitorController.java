package com.wework.platform.monitor.controller;

import com.wework.platform.common.dto.Result;
import com.wework.platform.monitor.dto.MonitorStatisticsDTO;
import com.wework.platform.monitor.service.MonitorService;
import com.wework.platform.monitor.service.SystemMetricService;
import com.wework.platform.monitor.service.AlertService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 监控管理控制器
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/monitor")
@RequiredArgsConstructor
@Tag(name = "监控管理", description = "监控系统的统一管理和控制")
public class MonitorController {

    private final MonitorService monitorService;
    private final SystemMetricService systemMetricService;
    private final AlertService alertService;

    @Operation(summary = "获取监控统计信息", description = "获取监控系统的整体统计信息")
    @GetMapping("/statistics")
    public Result<MonitorStatisticsDTO> getMonitorStatistics(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId) {
        
        return monitorService.getMonitorStatistics(tenantId);
    }

    @Operation(summary = "执行告警规则评估", description = "手动触发告警规则评估")
    @PostMapping("/evaluate-rules")
    public Result<Integer> evaluateAlertRules() {
        
        return monitorService.evaluateAlertRules();
    }

    @Operation(summary = "系统健康检查", description = "检查监控系统各组件的健康状态")
    @GetMapping("/health")
    public Result<Boolean> healthCheck() {
        
        return monitorService.healthCheck();
    }

    @Operation(summary = "清理过期数据", description = "清理过期的指标和告警数据")
    @PostMapping("/cleanup")
    public Result<String> cleanupExpiredData(
            @Parameter(description = "指标保留天数", example = "30") @RequestParam(defaultValue = "30") Integer metricRetentionDays,
            @Parameter(description = "告警保留天数", example = "90") @RequestParam(defaultValue = "90") Integer alertRetentionDays) {
        
        return monitorService.cleanupExpiredData(metricRetentionDays, alertRetentionDays);
    }

    @Operation(summary = "刷新监控配置", description = "重新加载监控系统配置")
    @PostMapping("/refresh-config")
    public Result<Void> refreshConfiguration() {
        
        return monitorService.refreshConfiguration();
    }

    @Operation(summary = "获取系统状态", description = "获取监控系统的运行状态信息")
    @GetMapping("/status")
    public Result<String> getSystemStatus() {
        
        return monitorService.getSystemStatus();
    }

    @Operation(summary = "清理过期指标数据", description = "单独清理过期的指标数据")
    @PostMapping("/cleanup-metrics")
    public Result<Integer> cleanupExpiredMetrics(
            @Parameter(description = "保留天数", example = "30") @RequestParam(defaultValue = "30") Integer retentionDays) {
        
        return systemMetricService.cleanupExpiredMetrics(retentionDays);
    }

    @Operation(summary = "清理过期告警数据", description = "单独清理过期的告警数据")
    @PostMapping("/cleanup-alerts")
    public Result<Integer> cleanupExpiredAlerts(
            @Parameter(description = "保留天数", example = "90") @RequestParam(defaultValue = "90") Integer retentionDays) {
        
        return alertService.cleanupExpiredAlerts(retentionDays);
    }

    @Operation(summary = "监控系统信息", description = "获取监控系统的基本信息", hidden = true)
    @GetMapping("/info")
    public Result<String> getMonitorInfo() {
        
        StringBuilder info = new StringBuilder();
        info.append("WeWork Platform Monitor Service v2.0.0\n");
        info.append("Build Time: 2024-01-15\n");
        info.append("Features: System Metrics, Alert Rules, Alert Management\n");
        info.append("Support: Prometheus, Grafana, Custom Metrics\n");
        
        return Result.success(info.toString());
    }
}