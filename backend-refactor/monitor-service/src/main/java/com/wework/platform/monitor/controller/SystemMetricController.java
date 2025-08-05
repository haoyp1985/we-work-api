package com.wework.platform.monitor.controller;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.monitor.dto.CreateMetricRequest;
import com.wework.platform.monitor.dto.SystemMetricDTO;
import com.wework.platform.monitor.service.SystemMetricService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 系统指标控制器
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/monitor/metrics")
@RequiredArgsConstructor
@Tag(name = "系统指标管理", description = "系统指标数据的收集和查询")
public class SystemMetricController {

    private final SystemMetricService systemMetricService;

    @Operation(summary = "添加系统指标", description = "收集并存储系统指标数据")
    @PostMapping
    public Result<SystemMetricDTO> addMetric(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Valid @RequestBody CreateMetricRequest request) {
        
        return systemMetricService.addMetric(tenantId, request);
    }

    @Operation(summary = "批量添加系统指标", description = "批量收集并存储系统指标数据")
    @PostMapping("/batch")
    public Result<Integer> batchAddMetrics(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Valid @RequestBody List<CreateMetricRequest> requests) {
        
        return systemMetricService.batchAddMetrics(tenantId, requests);
    }

    @Operation(summary = "获取系统指标详情", description = "根据指标ID获取详细信息")
    @GetMapping("/{metricId}")
    public Result<SystemMetricDTO> getMetricById(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "指标ID", required = true) @PathVariable String metricId) {
        
        return systemMetricService.getMetricById(tenantId, metricId);
    }

    @Operation(summary = "分页查询系统指标", description = "根据条件分页查询系统指标数据")
    @GetMapping
    public Result<PageResult<SystemMetricDTO>> getMetrics(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "服务名称") @RequestParam(required = false) String serviceName,
            @Parameter(description = "指标名称") @RequestParam(required = false) String metricName,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        return systemMetricService.getMetrics(tenantId, serviceName, metricName, 
                startTime, endTime, pageNum, pageSize);
    }

    @Operation(summary = "获取最新指标", description = "获取指定服务和指标的最新数据")
    @GetMapping("/latest")
    public Result<List<SystemMetricDTO>> getLatestMetrics(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "服务名称") @RequestParam(required = false) String serviceName,
            @Parameter(description = "指标名称") @RequestParam(required = false) String metricName,
            @Parameter(description = "限制数量", example = "10") @RequestParam(defaultValue = "10") Integer limit) {
        
        return systemMetricService.getLatestMetrics(tenantId, serviceName, metricName, limit);
    }

    @Operation(summary = "获取服务指标名称", description = "获取指定服务的所有指标名称")
    @GetMapping("/names")
    public Result<List<String>> getMetricNamesByService(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "服务名称", required = true) @RequestParam String serviceName) {
        
        return systemMetricService.getMetricNamesByService(tenantId, serviceName);
    }

    @Operation(summary = "获取服务名称列表", description = "获取租户下所有服务名称")
    @GetMapping("/services")
    public Result<List<String>> getServiceNamesByTenant(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId) {
        
        return systemMetricService.getServiceNamesByTenant(tenantId);
    }

    @Operation(summary = "删除系统指标", description = "删除指定的系统指标数据")
    @DeleteMapping("/{metricId}")
    public Result<Void> deleteMetric(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "指标ID", required = true) @PathVariable String metricId) {
        
        return systemMetricService.deleteMetric(tenantId, metricId);
    }

    @Operation(summary = "获取指标统计", description = "获取指定条件下的指标数量统计")
    @GetMapping("/stats/count")
    public Result<Long> getMetricCount(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "服务名称") @RequestParam(required = false) String serviceName,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        return systemMetricService.getMetricCount(tenantId, serviceName, startTime, endTime);
    }
}