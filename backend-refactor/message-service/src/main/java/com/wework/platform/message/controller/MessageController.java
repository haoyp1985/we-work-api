package com.wework.platform.message.controller;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.security.UserContext;
import com.wework.platform.common.security.UserContextHolder;
import com.wework.platform.message.dto.MessageDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.service.MessageService;
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
 * 消息管理控制器
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@RestController
@RequestMapping("/messages")
@RequiredArgsConstructor
@Tag(name = "消息管理", description = "消息发送和管理相关接口")
public class MessageController {

    private final MessageService messageService;

    @Operation(summary = "发送消息", description = "发送单条消息到指定接收者")
    @PostMapping("/send")
    public Result<MessageDTO> sendMessage(@Validated @RequestBody SendMessageRequest request) {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageDTO message = messageService.sendMessage(tenantId, request);
        return Result.success(message);
    }

    @Operation(summary = "批量发送消息", description = "批量发送多条消息")
    @PostMapping("/batch-send")
    public Result<List<MessageDTO>> batchSendMessages(@Validated @RequestBody List<SendMessageRequest> requests) {
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        List<MessageDTO> messages = messageService.batchSendMessages(tenantId, requests);
        return Result.success(messages);
    }

    @Operation(summary = "分页查询消息列表", description = "根据条件分页查询消息列表")
    @GetMapping
    public Result<PageResult<MessageDTO>> getMessageList(
            @Parameter(description = "账号ID") @RequestParam(required = false) String accountId,
            @Parameter(description = "消息类型") @RequestParam(required = false) Integer messageType,
            @Parameter(description = "发送状态") @RequestParam(required = false) Integer sendStatus,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime,
            @Parameter(description = "页码", example = "1") @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "页大小", example = "10") @RequestParam(defaultValue = "10") Integer pageSize) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        PageResult<MessageDTO> result = messageService.getMessageList(
                tenantId, accountId, messageType, sendStatus, startTime, endTime, pageNum, pageSize);
        return Result.success(result);
    }

    @Operation(summary = "根据ID获取消息详情", description = "根据消息ID获取消息详细信息")
    @GetMapping("/{messageId}")
    public Result<MessageDTO> getMessageById(
            @Parameter(description = "消息ID", required = true) @PathVariable String messageId) {
        MessageDTO message = messageService.getMessageById(messageId);
        return Result.success(message);
    }

    @Operation(summary = "重新发送消息", description = "重新发送失败的消息")
    @PostMapping("/{messageId}/resend")
    public Result<MessageDTO> resendMessage(
            @Parameter(description = "消息ID", required = true) @PathVariable String messageId) {
        MessageDTO message = messageService.resendMessage(messageId);
        return Result.success(message);
    }

    @Operation(summary = "撤回消息", description = "撤回已发送成功的消息")
    @PostMapping("/{messageId}/recall")
    public Result<Boolean> recallMessage(
            @Parameter(description = "消息ID", required = true) @PathVariable String messageId) {
        Boolean success = messageService.recallMessage(messageId);
        return Result.success(success);
    }

    @Operation(summary = "获取消息统计信息", description = "获取指定时间范围内的消息统计数据")
    @GetMapping("/statistics")
    public Result<MessageStatisticsDTO> getMessageStatistics(
            @Parameter(description = "账号ID") @RequestParam(required = false) String accountId,
            @Parameter(description = "开始时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        MessageStatisticsDTO statistics = messageService.getMessageStatistics(
                tenantId, accountId, startTime, endTime);
        return Result.success(statistics);
    }

    @Operation(summary = "删除消息", description = "删除指定的消息记录")
    @DeleteMapping("/{messageId}")
    public Result<Boolean> deleteMessage(
            @Parameter(description = "消息ID", required = true) @PathVariable String messageId) {
        Boolean success = messageService.deleteMessage(messageId);
        return Result.success(success);
    }

    @Operation(summary = "批量删除消息", description = "批量删除指定的消息记录")
    @DeleteMapping("/batch")
    public Result<Integer> batchDeleteMessages(@RequestBody List<String> messageIds) {
        Integer count = messageService.batchDeleteMessages(messageIds);
        return Result.success(count);
    }

    @Operation(summary = "清理历史消息", description = "清理指定天数前的历史消息")
    @DeleteMapping("/cleanup")
    public Result<Integer> cleanHistoryMessages(
            @Parameter(description = "清理多少天前的消息", example = "30") 
            @RequestParam(defaultValue = "30") Integer beforeDays) {
        
        UserContext userContext = UserContextHolder.getUserContext();
        String tenantId = userContext.getTenantId();
        
        Integer count = messageService.cleanHistoryMessages(tenantId, beforeDays);
        return Result.success(count);
    }

    @Operation(summary = "获取待重试消息", description = "获取需要重试的消息列表")
    @GetMapping("/retry-list")
    public Result<List<MessageDTO>> getMessagesForRetry(
            @Parameter(description = "限制数量", example = "10") 
            @RequestParam(defaultValue = "10") Integer limit) {
        
        List<MessageDTO> messages = messageService.getMessagesForRetry(limit);
        return Result.success(messages);
    }

    @Operation(summary = "处理消息重试", description = "手动触发消息重试")
    @PostMapping("/{messageId}/retry")
    public Result<Boolean> handleMessageRetry(
            @Parameter(description = "消息ID", required = true) @PathVariable String messageId) {
        Boolean success = messageService.handleMessageRetry(messageId);
        return Result.success(success);
    }
}