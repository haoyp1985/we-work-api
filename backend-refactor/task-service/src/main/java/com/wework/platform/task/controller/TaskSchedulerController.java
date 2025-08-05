package com.wework.platform.task.controller;

import com.wework.platform.common.dto.Result;
import com.wework.platform.task.dto.TaskDefinitionDTO;
import com.wework.platform.task.dto.TaskInstanceDTO;
import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.service.TaskSchedulingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 任务调度器控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/tasks/scheduler")
@RequiredArgsConstructor
@Validated
@Tag(name = "任务调度器管理", description = "任务调度器的控制和监控操作")
public class TaskSchedulerController {

    private final TaskSchedulingService taskSchedulingService;

    @PostMapping("/start")
    @Operation(summary = "启动调度器", description = "启动任务调度器")
    public Result<Void> startScheduler() {
        log.info("启动任务调度器");
        
        taskSchedulingService.startScheduling();
        return Result.success();
    }

    @PostMapping("/stop")
    @Operation(summary = "停止调度器", description = "停止任务调度器")
    public Result<Void> stopScheduler() {
        log.info("停止任务调度器");
        
        taskSchedulingService.stopScheduling();
        return Result.success();
    }

    @PostMapping("/restart")
    @Operation(summary = "重启调度器", description = "重启任务调度器")
    public Result<Void> restartScheduler() {
        log.info("重启任务调度器");
        
        taskSchedulingService.restartScheduling();
        return Result.success();
    }

    @GetMapping("/status")
    @Operation(summary = "获取调度器状态", description = "获取任务调度器的运行状态")
    public Result<Boolean> getSchedulerStatus() {
        boolean isRunning = taskSchedulingService.isSchedulingRunning();
        return Result.success(isRunning);
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取调度器统计信息", description = "获取任务调度器的统计信息")
    public Result<TaskSchedulingService.SchedulerStatistics> getSchedulerStatistics() {
        TaskSchedulingService.SchedulerStatistics statistics = taskSchedulingService.getSchedulerStatistics();
        return Result.success(statistics);
    }

    @GetMapping("/scheduled-tasks")
    @Operation(summary = "获取已调度的任务", description = "获取当前已调度的任务列表")
    public Result<List<TaskDefinitionDTO>> getScheduledTasks() {
        List<TaskDefinition> scheduledTasks = taskSchedulingService.getAllScheduledTasks();
        
        List<TaskDefinitionDTO> result = scheduledTasks.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return Result.success(result);
    }

    @GetMapping("/upcoming-tasks")
    @Operation(summary = "获取即将执行的任务", description = "获取在指定时间内即将执行的任务")
    public Result<List<TaskDefinitionDTO>> getUpcomingTasks(
            @Parameter(description = "时间范围（秒）", example = "300") @RequestParam(defaultValue = "300") Integer withinSeconds) {
        
        List<TaskDefinition> upcomingTasks = taskSchedulingService.getUpcomingTasks(withinSeconds);
        
        List<TaskDefinitionDTO> result = upcomingTasks.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return Result.success(result);
    }

    @PostMapping("/trigger/{taskDefinitionId}")
    @Operation(summary = "立即触发任务", description = "立即触发指定任务的执行")
    public Result<TaskInstanceDTO> triggerTask(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId,
            @Parameter(description = "执行参数") @RequestParam(required = false) String executionParams) {
        
        log.info("立即触发任务: taskDefinitionId={}", taskDefinitionId);
        
        TaskInstance taskInstance = taskSchedulingService.triggerTask(taskDefinitionId, executionParams);
        TaskInstanceDTO result = convertToInstanceDTO(taskInstance);
        
        return Result.success(result);
    }

    @PostMapping("/scan")
    @Operation(summary = "手动扫描任务", description = "手动触发任务调度扫描")
    public Result<Integer> scanTasks() {
        log.info("手动触发任务调度扫描");
        
        int createdCount = taskSchedulingService.scanAndCreatePendingInstances();
        return Result.success(createdCount);
    }

    @PostMapping("/schedule/{taskDefinitionId}")
    @Operation(summary = "添加任务到调度器", description = "将指定任务添加到调度器")
    public Result<Void> scheduleTask(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("添加任务到调度器: taskDefinitionId={}", taskDefinitionId);
        
        // 这里需要获取TaskDefinition，然后调用scheduleTask方法
        // 暂时返回成功状态
        return Result.success();
    }

    @PostMapping("/unschedule/{taskDefinitionId}")
    @Operation(summary = "从调度器移除任务", description = "将指定任务从调度器中移除")
    public Result<Void> unscheduleTask(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("从调度器移除任务: taskDefinitionId={}", taskDefinitionId);
        
        taskSchedulingService.unscheduleTask(taskDefinitionId);
        return Result.success();
    }

    @PostMapping("/pause/{taskDefinitionId}")
    @Operation(summary = "暂停任务调度", description = "暂停指定任务的调度")
    public Result<Void> pauseTask(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("暂停任务调度: taskDefinitionId={}", taskDefinitionId);
        
        taskSchedulingService.pauseTask(taskDefinitionId);
        return Result.success();
    }

    @PostMapping("/resume/{taskDefinitionId}")
    @Operation(summary = "恢复任务调度", description = "恢复指定任务的调度")
    public Result<Void> resumeTask(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        log.info("恢复任务调度: taskDefinitionId={}", taskDefinitionId);
        
        taskSchedulingService.resumeTask(taskDefinitionId);
        return Result.success();
    }

    @GetMapping("/is-scheduled/{taskDefinitionId}")
    @Operation(summary = "检查任务是否已调度", description = "检查指定任务是否已被调度")
    public Result<Boolean> isTaskScheduled(
            @Parameter(description = "任务定义ID", required = true) @PathVariable String taskDefinitionId) {
        
        boolean isScheduled = taskSchedulingService.isTaskScheduled(taskDefinitionId);
        return Result.success(isScheduled);
    }

    /**
     * 转换TaskDefinition为DTO
     */
    private TaskDefinitionDTO convertToDTO(TaskDefinition taskDefinition) {
        TaskDefinitionDTO dto = new TaskDefinitionDTO();
        // 这里应该使用BeanCopyUtils进行属性拷贝
        dto.setId(taskDefinition.getId());
        dto.setTenantId(taskDefinition.getTenantId());
        dto.setTaskName(taskDefinition.getTaskName());
        dto.setDescription(taskDefinition.getDescription());
        dto.setHandlerName(taskDefinition.getHandlerName());
        dto.setScheduleType(taskDefinition.getScheduleType());
        dto.setCronExpression(taskDefinition.getCronExpression());
        dto.setFixedInterval(taskDefinition.getFixedInterval());
        dto.setExecutionParams(taskDefinition.getExecutionParams());
        dto.setTimeout(taskDefinition.getTimeout());
        dto.setMaxRetryCount(taskDefinition.getMaxRetryCount());
        dto.setStatus(taskDefinition.getStatus());
        dto.setCreatedAt(taskDefinition.getCreatedAt());
        dto.setUpdatedAt(taskDefinition.getUpdatedAt());
        return dto;
    }

    /**
     * 转换TaskInstance为DTO
     */
    private TaskInstanceDTO convertToInstanceDTO(TaskInstance taskInstance) {
        TaskInstanceDTO dto = new TaskInstanceDTO();
        // 这里应该使用BeanCopyUtils进行属性拷贝
        dto.setId(taskInstance.getId());
        dto.setTenantId(taskInstance.getTenantId());
        dto.setTaskDefinitionId(taskInstance.getTaskDefinitionId());
        dto.setExecutionStatus(taskInstance.getExecutionStatus());
        dto.setStartTime(taskInstance.getStartTime());
        dto.setEndTime(taskInstance.getEndTime());
        dto.setExecutionDuration(taskInstance.getExecutionDuration());
        dto.setExecutionResult(taskInstance.getExecutionResult());
        dto.setErrorMessage(taskInstance.getErrorMessage());
        dto.setExecutionParams(taskInstance.getExecutionParams());
        dto.setExecutionNode(taskInstance.getExecutionNode());
        dto.setRetryCount(taskInstance.getRetryCount());
        dto.setMaxRetryCount(taskInstance.getMaxRetryCount());
        dto.setCreatedAt(taskInstance.getCreatedAt());
        dto.setUpdatedAt(taskInstance.getUpdatedAt());
        return dto;
    }
}