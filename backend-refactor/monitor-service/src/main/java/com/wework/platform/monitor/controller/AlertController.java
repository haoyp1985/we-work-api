package com.wework.platform.monitor.controller;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertDTO;
import com.wework.platform.monitor.service.AlertService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 告警记录控制器
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/monitor/alerts")
@RequiredArgsConstructor
@Tag(name = "告警记录管理", description = "告警记录的查询和处理")
public class AlertController {

    private final AlertService alertService;

    @Operation(summary = "获取告警详情", description = "根据告警ID获取详细信息")
    @GetMapping("/{alertId}")
    public Result<AlertDTO> getAlertById(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId) {
        
        return alertService.getAlertById(tenantId, alertId);
    }

    @Operation(summary = "分页查询告警记录", description = "根据条件分页查询告警记录")
    @GetMapping
    public Result<PageResult<AlertDTO>> getAlerts(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID") @RequestParam(required = false) String ruleId,
            @Parameter(description = "告警级别") @RequestParam(required = false) AlertLevel alertLevel,
            @Parameter(description = "状态") @RequestParam(required = false) AlertStatus status,
            @Parameter(description = "服务名称") @RequestParam(required = false) String serviceName,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        return alertService.getAlerts(tenantId, ruleId, alertLevel, status, serviceName, 
                startTime, endTime, pageNum, pageSize);
    }

    @Operation(summary = "获取活跃告警", description = "获取所有活跃状态的告警")
    @GetMapping("/active")
    public Result<List<AlertDTO>> getActiveAlerts(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId) {
        
        return alertService.getActiveAlerts(tenantId);
    }

    @Operation(summary = "获取未确认告警", description = "获取所有未确认的告警")
    @GetMapping("/unacknowledged")
    public Result<List<AlertDTO>> getUnacknowledgedAlerts(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId) {
        
        return alertService.getUnacknowledgedAlerts(tenantId);
    }

    @Operation(summary = "确认告警", description = "确认指定的告警")
    @PostMapping("/{alertId}/acknowledge")
    public Result<Void> acknowledgeAlert(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId,
            @Parameter(description = "确认人", required = true) @RequestParam String acknowledgedBy) {
        
        return alertService.acknowledgeAlert(tenantId, alertId, acknowledgedBy);
    }

    @Operation(summary = "批量确认告警", description = "批量确认多个告警")
    @PostMapping("/batch-acknowledge")
    public Result<Void> batchAcknowledgeAlerts(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID列表", required = true) @RequestBody List<String> alertIds,
            @Parameter(description = "确认人", required = true) @RequestParam String acknowledgedBy) {
        
        return alertService.batchAcknowledgeAlerts(tenantId, alertIds, acknowledgedBy);
    }

    @Operation(summary = "解决告警", description = "标记告警为已解决")
    @PostMapping("/{alertId}/resolve")
    public Result<Void> resolveAlert(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId) {
        
        return alertService.resolveAlert(tenantId, alertId);
    }

    @Operation(summary = "抑制告警", description = "抑制指定的告警")
    @PostMapping("/{alertId}/suppress")
    public Result<Void> suppressAlert(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId) {
        
        return alertService.suppressAlert(tenantId, alertId);
    }

    @Operation(summary = "删除告警记录", description = "删除指定的告警记录")
    @DeleteMapping("/{alertId}")
    public Result<Void> deleteAlert(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId) {
        
        return alertService.deleteAlert(tenantId, alertId);
    }

    @Operation(summary = "批量删除告警记录", description = "批量删除多个告警记录")
    @DeleteMapping("/batch")
    public Result<Void> batchDeleteAlerts(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID列表", required = true) @RequestBody List<String> alertIds) {
        
        return alertService.batchDeleteAlerts(tenantId, alertIds);
    }

    @Operation(summary = "重新发送通知", description = "重新发送告警通知")
    @PostMapping("/{alertId}/resend-notification")
    public Result<Void> resendNotification(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "告警ID", required = true) @PathVariable String alertId) {
        
        return alertService.resendNotification(tenantId, alertId);
    }

    @Operation(summary = "获取告警统计", description = "获取告警数量统计")
    @GetMapping("/stats/count")
    public Result<Long> getAlertCount(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "状态") @RequestParam(required = false) AlertStatus status,
            @Parameter(description = "告警级别") @RequestParam(required = false) AlertLevel alertLevel,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        return alertService.getAlertCount(tenantId, status, alertLevel, startTime, endTime);
    }
}