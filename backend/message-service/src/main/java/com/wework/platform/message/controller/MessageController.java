package com.wework.platform.message.controller;

import com.wework.platform.common.dto.ApiResponse;
import com.wework.platform.common.dto.message.BatchSendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageRequest;
import com.wework.platform.common.dto.message.SendMessageResponse;
import com.wework.platform.message.service.MessageSendService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 消息发送控制器
 *
 * @author WeWork Platform Team
 */
@Slf4j
@RestController
@RequestMapping("/messages")
@RequiredArgsConstructor
@Tag(name = "消息发送", description = "企微消息发送相关接口")
public class MessageController {

    private final MessageSendService messageSendService;

    @PostMapping("/send")
    @Operation(summary = "发送消息", description = "同步发送单条消息")
    public ApiResponse<SendMessageResponse> sendMessage(
            @Valid @RequestBody SendMessageRequest request) {
        
        log.info("收到消息发送请求: 类型={}, 会话={}, GUID={}", 
                request.getMessageType(), request.getConversationId(), request.getGuid());
        
        SendMessageResponse response = messageSendService.sendMessage(request);
        
        if (response.getSuccess()) {
            return ApiResponse.success(response);
        } else {
            return ApiResponse.error(response.getErrorCode(), response.getErrorMessage());
        }
    }

    @PostMapping("/send/async")
    @Operation(summary = "异步发送消息", description = "异步发送单条消息，返回任务ID")
    public ApiResponse<String> sendMessageAsync(
            @Valid @RequestBody SendMessageRequest request) {
        
        log.info("收到异步消息发送请求: 类型={}, 会话={}, GUID={}", 
                request.getMessageType(), request.getConversationId(), request.getGuid());
        
        String taskId = messageSendService.sendMessageAsync(request);
        return ApiResponse.success(taskId);
    }

    @PostMapping("/send/batch")
    @Operation(summary = "批量发送消息", description = "群发助手批量发送消息")
    public ApiResponse<Map<String, Object>> batchSendMessage(
            @Valid @RequestBody BatchSendMessageRequest request) {
        
        log.info("收到批量消息发送请求: GUID={}, 用户数={}, 群数={}", 
                request.getGuid(),
                request.getUserList() != null ? request.getUserList().size() : 0,
                request.getRoomList() != null ? request.getRoomList().size() : 0);
        
        Map<String, Object> response = messageSendService.batchSendMessage(request);
        return ApiResponse.success(response);
    }

    @PostMapping("/{messageId}/retry")
    @Operation(summary = "重试发送消息", description = "重新发送失败的消息")
    public ApiResponse<SendMessageResponse> retryMessage(
            @Parameter(description = "消息ID") @PathVariable String messageId) {
        
        log.info("收到消息重试请求: {}", messageId);
        
        SendMessageResponse response = messageSendService.retryMessage(messageId);
        
        if (response.getSuccess()) {
            return ApiResponse.success(response);
        } else {
            return ApiResponse.error(response.getErrorCode(), response.getErrorMessage());
        }
    }

    @DeleteMapping("/{guid}/messages/{messageId}")
    @Operation(summary = "撤回消息", description = "撤回已发送的消息")
    public ApiResponse<Map<String, Object>> recallMessage(
            @Parameter(description = "实例GUID") @PathVariable String guid,
            @Parameter(description = "消息ID") @PathVariable String messageId) {
        
        log.info("收到消息撤回请求: GUID={}, 消息ID={}", guid, messageId);
        
        Map<String, Object> response = messageSendService.recallMessage(guid, messageId);
        return ApiResponse.success(response);
    }

    @GetMapping("/{messageId}/status")
    @Operation(summary = "获取消息状态", description = "查询消息发送状态")
    public ApiResponse<Map<String, Object>> getMessageStatus(
            @Parameter(description = "消息ID") @PathVariable String messageId) {
        
        Map<String, Object> status = messageSendService.getMessageStatus(messageId);
        return ApiResponse.success(status);
    }

    @GetMapping("/stats")
    @Operation(summary = "获取消息统计信息", description = "获取消息发送相关的统计数据")
    public ApiResponse<Map<String, Object>> getMessageStats(
            @Parameter(description = "开始时间") @RequestParam(name = "startTime", required = false) String startTime,
            @Parameter(description = "结束时间") @RequestParam(name = "endTime", required = false) String endTime) {
        
        log.info("获取消息统计信息: startTime={}, endTime={}", startTime, endTime);
        
        // 临时返回模拟统计数据
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalMessages", 2358);
        stats.put("successMessages", 2291);
        stats.put("failedMessages", 67);
        stats.put("todayMessages", 186);
        stats.put("successRate", 97.2);
        stats.put("peakHour", "14:00-15:00");
        stats.put("lastUpdateTime", LocalDateTime.now());
        
        return ApiResponse.success("获取统计信息成功", stats);
    }
}