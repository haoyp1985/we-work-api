package com.wework.platform.monitor.controller;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertRuleDTO;
import com.wework.platform.monitor.dto.CreateAlertRuleRequest;
import com.wework.platform.monitor.dto.UpdateAlertRuleRequest;
import com.wework.platform.monitor.service.AlertRuleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 告警规则控制器
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/monitor/alert-rules")
@RequiredArgsConstructor
@Tag(name = "告警规则管理", description = "告警规则的创建、配置和管理")
public class AlertRuleController {

    private final AlertRuleService alertRuleService;

    @Operation(summary = "创建告警规则", description = "创建新的告警规则")
    @PostMapping
    public Result<AlertRuleDTO> createRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Valid @RequestBody CreateAlertRuleRequest request) {
        
        return alertRuleService.createRule(tenantId, request);
    }

    @Operation(summary = "更新告警规则", description = "更新现有的告警规则")
    @PutMapping("/{ruleId}")
    public Result<AlertRuleDTO> updateRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId,
            @Valid @RequestBody UpdateAlertRuleRequest request) {
        
        return alertRuleService.updateRule(tenantId, ruleId, request);
    }

    @Operation(summary = "获取告警规则详情", description = "根据规则ID获取详细信息")
    @GetMapping("/{ruleId}")
    public Result<AlertRuleDTO> getRuleById(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId) {
        
        return alertRuleService.getRuleById(tenantId, ruleId);
    }

    @Operation(summary = "分页查询告警规则", description = "根据条件分页查询告警规则")
    @GetMapping
    public Result<PageResult<AlertRuleDTO>> getRules(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则名称") @RequestParam(required = false) String ruleName,
            @Parameter(description = "指标名称") @RequestParam(required = false) String metricName,
            @Parameter(description = "告警级别") @RequestParam(required = false) AlertLevel alertLevel,
            @Parameter(description = "状态") @RequestParam(required = false) AlertStatus status,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        return alertRuleService.getRules(tenantId, ruleName, metricName, alertLevel, status, pageNum, pageSize);
    }

    @Operation(summary = "获取启用的告警规则", description = "获取所有启用状态的告警规则")
    @GetMapping("/enabled")
    public Result<List<AlertRuleDTO>> getEnabledRules(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId) {
        
        return alertRuleService.getEnabledRules(tenantId);
    }

    @Operation(summary = "启用告警规则", description = "启用指定的告警规则")
    @PostMapping("/{ruleId}/enable")
    public Result<Void> enableRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId) {
        
        return alertRuleService.enableRule(tenantId, ruleId);
    }

    @Operation(summary = "禁用告警规则", description = "禁用指定的告警规则")
    @PostMapping("/{ruleId}/disable")
    public Result<Void> disableRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId) {
        
        return alertRuleService.disableRule(tenantId, ruleId);
    }

    @Operation(summary = "删除告警规则", description = "删除指定的告警规则")
    @DeleteMapping("/{ruleId}")
    public Result<Void> deleteRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId) {
        
        return alertRuleService.deleteRule(tenantId, ruleId);
    }

    @Operation(summary = "批量删除告警规则", description = "批量删除多个告警规则")
    @DeleteMapping("/batch")
    public Result<Void> batchDeleteRules(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID列表", required = true) @RequestBody List<String> ruleIds) {
        
        return alertRuleService.batchDeleteRules(tenantId, ruleIds);
    }

    @Operation(summary = "复制告警规则", description = "复制现有告警规则创建新规则")
    @PostMapping("/{ruleId}/copy")
    public Result<AlertRuleDTO> copyRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId,
            @Parameter(description = "新规则名称", required = true) @RequestParam String newRuleName) {
        
        return alertRuleService.copyRule(tenantId, ruleId, newRuleName);
    }

    @Operation(summary = "测试告警规则", description = "测试告警规则是否会触发")
    @PostMapping("/{ruleId}/test")
    public Result<Boolean> testRule(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "规则ID", required = true) @PathVariable String ruleId) {
        
        return alertRuleService.testRule(tenantId, ruleId);
    }

    @Operation(summary = "获取规则统计", description = "获取告警规则数量统计")
    @GetMapping("/stats/count")
    public Result<Long> getRuleCount(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "状态") @RequestParam(required = false) AlertStatus status) {
        
        return alertRuleService.getRuleCount(tenantId, status);
    }
}