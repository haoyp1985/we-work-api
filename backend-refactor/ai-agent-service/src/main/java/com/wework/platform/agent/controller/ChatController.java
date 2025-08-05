package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.request.ChatRequest;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.dto.response.ChatResponse;
import com.wework.platform.agent.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;

/**
 * 聊天交互控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/chat")
@RequiredArgsConstructor
@Validated
@Tag(name = "聊天交互", description = "AI智能体聊天交互接口")
public class ChatController {

    private final ChatService chatService;

    @PostMapping("/send")
    @Operation(summary = "发送聊天消息", description = "向指定的智能体发送聊天消息")
    public ApiResult<ChatResponse> sendMessage(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "聊天请求", required = true)
            @Valid @RequestBody ChatRequest request) {
        
        log.info("发送聊天消息, tenantId={}, userId={}, agentId={}", 
                tenantId, userId, request.getAgentId());
        
        try {
            // 设置请求中的用户ID和租户ID
            request.setUserId(userId);
            
            ChatResponse response = chatService.chat(tenantId, request);
            
            log.info("聊天消息发送成功, conversationId={}, messageId={}", 
                    response.getConversationId(), response.getMessageId());
            
            return ApiResult.success(response);
            
        } catch (Exception e) {
            log.error("发送聊天消息失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("发送聊天消息失败: " + e.getMessage());
        }
    }

    @PostMapping("/conversations/{conversationId}/send")
    @Operation(summary = "在指定会话中发送消息", description = "在已存在的会话中继续聊天")
    public ApiResult<ChatResponse> sendMessageToConversation(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId,
            
            @Parameter(description = "聊天请求", required = true)
            @Valid @RequestBody ChatRequest request) {
        
        log.info("在会话中发送消息, tenantId={}, userId={}, conversationId={}", 
                tenantId, userId, conversationId);
        
        try {
            // 设置会话ID和用户ID
            request.setConversationId(conversationId);
            request.setUserId(userId);
            
            ChatResponse response = chatService.chatInConversation(tenantId, request);
            
            log.info("会话消息发送成功, conversationId={}, messageId={}", 
                    conversationId, response.getMessageId());
            
            return ApiResult.success(response);
            
        } catch (Exception e) {
            log.error("在会话中发送消息失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("发送消息失败: " + e.getMessage());
        }
    }

    @PostMapping("/stream")
    @Operation(summary = "流式聊天", description = "发送聊天消息并获得流式响应")
    public ApiResult<ChatResponse> streamChat(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "聊天请求", required = true)
            @Valid @RequestBody ChatRequest request) {
        
        log.info("流式聊天, tenantId={}, userId={}, agentId={}", 
                tenantId, userId, request.getAgentId());
        
        try {
            request.setUserId(userId);
            request.setStream(true);
            
            ChatResponse response = chatService.streamChat(tenantId, request);
            
            return ApiResult.success(response);
            
        } catch (Exception e) {
            log.error("流式聊天失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("流式聊天失败: " + e.getMessage());
        }
    }

    @PostMapping("/regenerate")
    @Operation(summary = "重新生成回复", description = "对上一条消息重新生成回复")
    public ApiResult<ChatResponse> regenerateResponse(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "聊天请求", required = true)
            @Valid @RequestBody ChatRequest request) {
        
        log.info("重新生成回复, tenantId={}, userId={}, conversationId={}", 
                tenantId, userId, request.getConversationId());
        
        try {
            request.setUserId(userId);
            
            ChatResponse response = chatService.regenerateResponse(tenantId, request);
            
            return ApiResult.success(response);
            
        } catch (Exception e) {
            log.error("重新生成回复失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, request.getConversationId(), e.getMessage(), e);
            return ApiResult.error("重新生成回复失败: " + e.getMessage());
        }
    }

    @GetMapping("/conversations/{conversationId}/context")
    @Operation(summary = "获取会话上下文", description = "获取指定会话的上下文信息")
    public ApiResult<ChatRequest> getConversationContext(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId,
            
            @Parameter(description = "上下文消息数量", required = false)
            @RequestParam(defaultValue = "10") int contextSize) {
        
        log.debug("获取会话上下文, tenantId={}, conversationId={}, contextSize={}", 
                 tenantId, conversationId, contextSize);
        
        try {
            ChatRequest context = chatService.getConversationContext(tenantId, conversationId, contextSize);
            
            return ApiResult.success(context);
            
        } catch (Exception e) {
            log.error("获取会话上下文失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("获取会话上下文失败: " + e.getMessage());
        }
    }

    @PostMapping("/conversations/{conversationId}/clear")
    @Operation(summary = "清空会话历史", description = "清空指定会话的聊天历史")
    public ApiResult<Void> clearConversationHistory(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId) {
        
        log.info("清空会话历史, tenantId={}, userId={}, conversationId={}", 
                tenantId, userId, conversationId);
        
        try {
            chatService.clearConversationHistory(tenantId, conversationId);
            
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("清空会话历史失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("清空会话历史失败: " + e.getMessage());
        }
    }

    @GetMapping("/health")
    @Operation(summary = "健康检查", description = "检查聊天服务是否正常")
    public ApiResult<String> health() {
        return ApiResult.success("Chat service is healthy");
    }
}