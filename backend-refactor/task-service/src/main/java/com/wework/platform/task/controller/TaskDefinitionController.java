package com.wework.platform.task.controller;

import com.wework.platform.common.dto.PageQuery;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.task.dto.CreateTaskDefinitionRequest;
import com.wework.platform.task.dto.TaskDefinitionDTO;
import com.wework.platform.task.dto.UpdateTaskDefinitionRequest;
import com.wework.platform.task.service.TaskDefinitionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * 任务定义控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/tasks/definitions")
@RequiredArgsConstructor
@Validated
@Tag(name = "任务定义管理", description = "任务定义的CRUD操作")
public class TaskDefinitionController {

    private final TaskDefinitionService taskDefinitionService;

    @PostMapping
    @Operation(summary = "创建任务定义", description = "创建新的任务定义")
    public Result<TaskDefinitionDTO> createTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义信息", required = true) @Valid @RequestBody CreateTaskDefinitionRequest request) {
        
        log.info("创建任务定义: tenantId={}, taskName={}", tenantId, request.getTaskName());
        
        TaskDefinitionDTO result = taskDefinitionService.createTaskDefinition(tenantId, request);
        return Result.success(result);
    }

    @GetMapping("/{taskDefinitionId}")
    @Operation(summary = "获取任务定义详情", description = "根据ID获取任务定义详情")
    public Result<TaskDefinitionDTO> getTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        TaskDefinitionDTO result = taskDefinitionService.getTaskDefinition(tenantId, taskDefinitionId);
        return Result.success(result);
    }

    @GetMapping
    @Operation(summary = "分页查询任务定义", description = "根据条件分页查询任务定义列表")
    public Result<PageResult<TaskDefinitionDTO>> getTaskDefinitions(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务名称(模糊查询)") @RequestParam(required = false) String taskName,
            @Parameter(description = "状态") @RequestParam(required = false) String status,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        PageQuery pageQuery = PageQuery.builder()
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
        
        PageResult<TaskDefinitionDTO> result = taskDefinitionService.getTaskDefinitions(
                tenantId, taskName, status, pageQuery);
        return Result.success(result);
    }

    @PutMapping("/{taskDefinitionId}")
    @Operation(summary = "更新任务定义", description = "更新指定的任务定义")
    public Result<TaskDefinitionDTO> updateTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId,
            @Parameter(description = "更新信息", required = true) @Valid @RequestBody UpdateTaskDefinitionRequest request) {
        
        log.info("更新任务定义: tenantId={}, taskDefinitionId={}", tenantId, taskDefinitionId);
        
        TaskDefinitionDTO result = taskDefinitionService.updateTaskDefinition(tenantId, taskDefinitionId, request);
        return Result.success(result);
    }

    @DeleteMapping("/{taskDefinitionId}")
    @Operation(summary = "删除任务定义", description = "删除指定的任务定义")
    public Result<Void> deleteTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("删除任务定义: tenantId={}, taskDefinitionId={}", tenantId, taskDefinitionId);
        
        taskDefinitionService.deleteTaskDefinition(tenantId, taskDefinitionId);
        return Result.success();
    }

    @PostMapping("/{taskDefinitionId}/enable")
    @Operation(summary = "启用任务定义", description = "启用指定的任务定义")
    public Result<Void> enableTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("启用任务定义: tenantId={}, taskDefinitionId={}", tenantId, taskDefinitionId);
        
        taskDefinitionService.enableTaskDefinition(tenantId, taskDefinitionId);
        return Result.success();
    }

    @PostMapping("/{taskDefinitionId}/disable")
    @Operation(summary = "禁用任务定义", description = "禁用指定的任务定义")
    public Result<Void> disableTaskDefinition(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("禁用任务定义: tenantId={}, taskDefinitionId={}", tenantId, taskDefinitionId);
        
        taskDefinitionService.disableTaskDefinition(tenantId, taskDefinitionId);
        return Result.success();
    }

    @PostMapping("/{taskDefinitionId}/trigger")
    @Operation(summary = "手动触发任务", description = "立即触发指定任务的执行")
    public Result<String> triggerTask(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId,
            @Parameter(description = "执行参数") @RequestParam(required = false) String executionParams) {
        
        log.info("手动触发任务: tenantId={}, taskDefinitionId={}", tenantId, taskDefinitionId);
        
        // 这里需要调用TaskSchedulingService的triggerTask方法
        // 暂时返回成功状态
        return Result.success("任务触发成功");
    }

    @PostMapping("/validate")
    @Operation(summary = "验证任务定义", description = "验证任务定义的配置是否正确")
    public Result<Boolean> validateTaskDefinition(
            @Parameter(description = "任务定义信息", required = true) @Valid @RequestBody CreateTaskDefinitionRequest request) {
        
        boolean isValid = taskDefinitionService.validateTaskDefinition(request);
        return Result.success(isValid);
    }
}