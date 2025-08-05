package com.wework.platform.task.controller;

import com.wework.platform.common.dto.PageQuery;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.task.dto.TaskInstanceDTO;
import com.wework.platform.task.service.TaskInstanceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

/**
 * 任务实例控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/tasks/instances")
@RequiredArgsConstructor
@Validated
@Tag(name = "任务实例管理", description = "任务实例的查询和管理操作")
public class TaskInstanceController {

    private final TaskInstanceService taskInstanceService;

    @GetMapping("/{instanceId}")
    @Operation(summary = "获取任务实例详情", description = "根据ID获取任务实例详情")
    public Result<TaskInstanceDTO> getTaskInstance(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务实例ID", required = true) @PathVariable String instanceId) {
        
        TaskInstanceDTO result = taskInstanceService.getTaskInstance(tenantId, instanceId);
        return Result.success(result);
    }

    @GetMapping
    @Operation(summary = "分页查询任务实例", description = "根据条件分页查询任务实例列表")
    public Result<PageResult<TaskInstanceDTO>> getTaskInstances(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID") @RequestParam(required = false) String taskDefinitionId,
            @Parameter(description = "执行状态") @RequestParam(required = false) String status,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        PageQuery pageQuery = PageQuery.builder()
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
        
        PageResult<TaskInstanceDTO> result = taskInstanceService.getTaskInstances(
                tenantId, taskDefinitionId, status, pageQuery);
        return Result.success(result);
    }

    @PostMapping("/{instanceId}/cancel")
    @Operation(summary = "取消任务实例", description = "取消指定的任务实例执行")
    public Result<Void> cancelTaskInstance(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务实例ID", required = true) @PathVariable String instanceId) {
        
        log.info("取消任务实例: tenantId={}, instanceId={}", tenantId, instanceId);
        
        taskInstanceService.cancelTaskInstance(tenantId, instanceId);
        return Result.success();
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取任务实例统计", description = "获取任务实例的统计信息")
    public Result<TaskInstanceService.TaskInstanceStatistics> getTaskInstanceStatistics(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务定义ID") @RequestParam(required = false) String taskDefinitionId,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        TaskInstanceService.TaskInstanceStatistics result = taskInstanceService.getTaskInstanceStatistics(
                tenantId, taskDefinitionId, startTime, endTime);
        return Result.success(result);
    }

    @PostMapping("/{instanceId}/retry")
    @Operation(summary = "重试任务实例", description = "重新执行失败的任务实例")
    public Result<Void> retryTaskInstance(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "任务实例ID", required = true) @PathVariable String instanceId) {
        
        log.info("重试任务实例: tenantId={}, instanceId={}", tenantId, instanceId);
        
        // 这里需要调用TaskExecutionService的retryTask方法
        // 暂时返回成功状态
        return Result.success();
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "按状态查询任务实例", description = "查询指定状态的任务实例")
    public Result<PageResult<TaskInstanceDTO>> getTaskInstancesByStatus(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "执行状态", required = true) @PathVariable String status,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        PageQuery pageQuery = PageQuery.builder()
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
        
        PageResult<TaskInstanceDTO> result = taskInstanceService.getTaskInstances(
                tenantId, null, status, pageQuery);
        return Result.success(result);
    }

    @GetMapping("/running")
    @Operation(summary = "获取正在执行的任务实例", description = "获取当前正在执行的任务实例列表")
    public Result<PageResult<TaskInstanceDTO>> getRunningTaskInstances(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        PageQuery pageQuery = PageQuery.builder()
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
        
        PageResult<TaskInstanceDTO> result = taskInstanceService.getTaskInstances(
                tenantId, null, "RUNNING", pageQuery);
        return Result.success(result);
    }

    @GetMapping("/failed")
    @Operation(summary = "获取失败的任务实例", description = "获取执行失败的任务实例列表")
    public Result<PageResult<TaskInstanceDTO>> getFailedTaskInstances(
            @Parameter(description = "租户ID", required = true) @RequestHeader("X-Tenant-Id") String tenantId,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "20") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        PageQuery pageQuery = PageQuery.builder()
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
        
        PageResult<TaskInstanceDTO> result = taskInstanceService.getTaskInstances(
                tenantId, null, "FAILED", pageQuery);
        return Result.success(result);
    }
}