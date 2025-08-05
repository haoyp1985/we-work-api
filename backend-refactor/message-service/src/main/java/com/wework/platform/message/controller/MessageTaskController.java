package com.wework.platform.message.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.message.dto.MessageTaskDTO;
import com.wework.platform.message.dto.CreateTaskRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.service.MessageTaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息任务管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/tasks")
@RequiredArgsConstructor
@Tag(name = "消息任务管理", description = "消息任务创建、调度和管理相关接口")
public class MessageTaskController {

    private final MessageTaskService messageTaskService;

    @Operation(summary = "分页查询任务列表", description = "根据条件分页查询消息任务列表")
    @GetMapping
    public Result<PageResult<MessageTaskDTO>> getTaskList(
            @Parameter(description = "任务类型") @RequestParam(required = false) Integer taskType,
            @Parameter(description = "任务状态") @RequestParam(required = false) Integer taskStatus,
            @Parameter(description = "关键词") @RequestParam(required = false) String keyword,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "10") @RequestParam(defaultValue = "10") Integer pageSize) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        PageResult<MessageTaskDTO> result = messageTaskService.getTaskList(
                tenantId, taskType, taskStatus, keyword, startTime, endTime, pageNum, pageSize);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取任务详情", description = "根据任务ID获取任务详细信息")
    @GetMapping("/{taskId}")
    public Result<MessageTaskDTO> getTaskById(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        MessageTaskDTO task = messageTaskService.getTaskById(taskId);
        return Result.success(task);
    }

    @Operation(summary = "创建消息任务", description = "创建新的消息发送任务")
    @PostMapping
    public Result<MessageTaskDTO> createTask(@Validated @RequestBody CreateTaskRequest request) {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageTaskDTO task = messageTaskService.createTask(tenantId, request);
        return Result.success(task);
    }

    @Operation(summary = "更新消息任务", description = "更新指定的消息任务")
    @PutMapping("/{taskId}")
    public Result<MessageTaskDTO> updateTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId,
            @Validated @RequestBody CreateTaskRequest request) {
        MessageTaskDTO task = messageTaskService.updateTask(taskId, request);
        return Result.success(task);
    }

    @Operation(summary = "执行任务", description = "立即执行指定的消息任务")
    @PostMapping("/{taskId}/execute")
    public Result<Boolean> executeTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.executeTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "暂停任务", description = "暂停正在执行的消息任务")
    @PostMapping("/{taskId}/pause")
    public Result<Boolean> pauseTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.pauseTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "恢复任务", description = "恢复暂停的消息任务")
    @PostMapping("/{taskId}/resume")
    public Result<Boolean> resumeTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.resumeTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "取消任务", description = "取消指定的消息任务")
    @PostMapping("/{taskId}/cancel")
    public Result<Boolean> cancelTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.cancelTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "重试任务", description = "重试失败的任务")
    @PostMapping("/{taskId}/retry")
    public Result<Boolean> retryTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.retryTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "删除任务", description = "删除指定的消息任务")
    @DeleteMapping("/{taskId}")
    public Result<Boolean> deleteTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId) {
        Boolean success = messageTaskService.deleteTask(taskId);
        return Result.success(success);
    }

    @Operation(summary = "批量删除任务", description = "批量删除指定的消息任务")
    @DeleteMapping("/batch")
    public Result<Integer> batchDeleteTasks(@RequestBody List<String> taskIds) {
        Integer count = messageTaskService.batchDeleteTasks(taskIds);
        return Result.success(count);
    }

    @Operation(summary = "清理历史任务", description = "清理指定天数前的历史任务")
    @DeleteMapping("/cleanup")
    public Result<Integer> cleanHistoryTasks(
            @Parameter(description = "清理多少天前的任务", example = "30") 
            @RequestParam(defaultValue = "30") Integer beforeDays) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        Integer count = messageTaskService.cleanHistoryTasks(tenantId, beforeDays);
        return Result.success(count);
    }

    @Operation(summary = "获取待执行任务", description = "获取需要执行的任务列表")
    @GetMapping("/pending")
    public Result<List<MessageTaskDTO>> getPendingTasks(
            @Parameter(description = "限制数量", example = "10") 
            @RequestParam(defaultValue = "10") Integer limit) {
        List<MessageTaskDTO> tasks = messageTaskService.getPendingTasks(limit);
        return Result.success(tasks);
    }

    @Operation(summary = "获取重试任务", description = "获取需要重试的任务列表")
    @GetMapping("/retry")
    public Result<List<MessageTaskDTO>> getTasksForRetry(
            @Parameter(description = "限制数量", example = "10") 
            @RequestParam(defaultValue = "10") Integer limit) {
        List<MessageTaskDTO> tasks = messageTaskService.getTasksForRetry(limit);
        return Result.success(tasks);
    }

    @Operation(summary = "获取周期性任务", description = "获取周期性任务列表")
    @GetMapping("/periodic")
    public Result<List<MessageTaskDTO>> getPeriodicTasks(
            @Parameter(description = "限制数量", example = "10") 
            @RequestParam(defaultValue = "10") Integer limit) {
        List<MessageTaskDTO> tasks = messageTaskService.getPeriodicTasks(limit);
        return Result.success(tasks);
    }

    @Operation(summary = "更新任务进度", description = "更新任务的执行进度")
    @PostMapping("/{taskId}/progress")
    public Result<Boolean> updateTaskProgress(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId,
            @Parameter(description = "进度百分比") @RequestParam Integer progress,
            @Parameter(description = "已发送数量") @RequestParam Integer sentCount,
            @Parameter(description = "成功数量") @RequestParam Integer successCount,
            @Parameter(description = "失败数量") @RequestParam Integer failCount) {
        
        messageTaskService.updateTaskProgress(taskId, progress, sentCount, successCount, failCount);
        return Result.success(true);
    }

    @Operation(summary = "审核任务", description = "审核指定的消息任务")
    @PostMapping("/{taskId}/audit")
    public Result<Boolean> auditTask(
            @Parameter(description = "任务ID", required = true) @PathVariable String taskId,
            @Parameter(description = "审核状态", required = true) @RequestParam Integer auditStatus,
            @Parameter(description = "审核备注") @RequestParam(required = false) String auditRemark) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String auditorId = userContext.getUserId();
        
        Boolean success = messageTaskService.auditTask(taskId, auditStatus, auditorId, auditRemark);
        return Result.success(success);
    }

    @Operation(summary = "获取任务统计信息", description = "获取任务的统计信息")
    @GetMapping("/statistics")
    public Result<MessageStatisticsDTO.TaskStatistics> getTaskStatistics(
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageStatisticsDTO.TaskStatistics statistics = messageTaskService.getTaskStatistics(tenantId, startTime, endTime);
        return Result.success(statistics);
    }
}