package com.wework.platform.account.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.account.dto.AccountStatusLogDTO;
import com.wework.platform.account.service.AccountStatusLogService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 账号状态日志控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/status-logs")
@RequiredArgsConstructor
@Tag(name = "账号状态日志", description = "账号状态变更日志相关接口")
public class AccountStatusLogController {

    private final AccountStatusLogService statusLogService;

    @Operation(summary = "分页查询状态日志", description = "根据条件分页查询账号状态变更日志")
    @GetMapping
    public Result<PageResult<AccountStatusLogDTO>> getStatusLogList(
            @Parameter(description = "账号ID") @RequestParam(required = false) String accountId,
            @Parameter(description = "原状态") @RequestParam(required = false) Integer fromStatus,
            @Parameter(description = "目标状态") @RequestParam(required = false) Integer toStatus,
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小") @RequestParam(defaultValue = "20") Integer pageSize) {
        
        UserContext userContext = UserContextHolder.getContext();
        PageResult<AccountStatusLogDTO> result = statusLogService.getStatusLogList(
                userContext.getTenantId(), accountId, fromStatus, toStatus, pageNum, pageSize);
        return Result.success(result);
    }

    @Operation(summary = "根据账号ID查询状态日志", description = "查询指定账号的状态变更日志")
    @GetMapping("/account/{accountId}")
    public Result<List<AccountStatusLogDTO>> getStatusLogsByAccountId(
            @Parameter(description = "账号ID") @PathVariable String accountId,
            @Parameter(description = "限制数量") @RequestParam(defaultValue = "50") Integer limit) {
        
        List<AccountStatusLogDTO> logs = statusLogService.getStatusLogsByAccountId(accountId, limit);
        return Result.success(logs);
    }

    @Operation(summary = "根据ID获取状态日志详情", description = "根据日志ID获取详细信息")
    @GetMapping("/{logId}")
    public Result<AccountStatusLogDTO> getStatusLogById(@Parameter(description = "日志ID") @PathVariable String logId) {
        AccountStatusLogDTO logDTO = statusLogService.getStatusLogById(logId);
        return Result.success(logDTO);
    }

    @Operation(summary = "获取状态变更统计", description = "获取账号状态变更统计信息")
    @GetMapping("/statistics")
    public Result<AccountStatusLogService.StatusChangeStatistics> getStatusChangeStatistics(
            @Parameter(description = "账号ID") @RequestParam(required = false) String accountId,
            @Parameter(description = "开始时间") @RequestParam(required = false) Long startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) Long endTime) {
        
        UserContext userContext = UserContextHolder.getContext();
        AccountStatusLogService.StatusChangeStatistics statistics = statusLogService.getStatusChangeStatistics(
                userContext.getTenantId(), accountId, startTime, endTime);
        return Result.success(statistics);
    }

    @Operation(summary = "获取账号状态趋势", description = "获取指定时间范围内的账号状态变更趋势")
    @GetMapping("/trends")
    public Result<List<AccountStatusLogService.StatusTrend>> getStatusTrends(
            @Parameter(description = "账号ID") @RequestParam(required = false) String accountId,
            @Parameter(description = "开始时间") @RequestParam Long startTime,
            @Parameter(description = "结束时间") @RequestParam Long endTime,
            @Parameter(description = "时间间隔") @RequestParam(defaultValue = "HOUR") String interval) {
        
        UserContext userContext = UserContextHolder.getContext();
        List<AccountStatusLogService.StatusTrend> trends = statusLogService.getStatusTrends(
                userContext.getTenantId(), accountId, startTime, endTime, interval);
        return Result.success(trends);
    }

    @Operation(summary = "清理历史日志", description = "清理指定时间之前的状态日志")
    @DeleteMapping("/cleanup")
    public Result<Integer> cleanupOldLogs(@Parameter(description = "保留天数") @RequestParam(defaultValue = "30") Integer keepDays) {
        UserContext userContext = UserContextHolder.getContext();
        int deletedCount = statusLogService.cleanupOldLogs(userContext.getTenantId(), keepDays);
        return Result.success(deletedCount);
    }
}