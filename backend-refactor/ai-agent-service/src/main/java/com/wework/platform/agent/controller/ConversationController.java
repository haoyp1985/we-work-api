package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.ConversationDTO;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.ConversationStatus;
import com.wework.platform.agent.service.ConversationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.constraints.NotBlank;
import java.util.List;
import java.util.Map;

/**
 * 会话管理控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/conversations")
@RequiredArgsConstructor
@Validated
@Tag(name = "会话管理", description = "聊天会话的创建、管理和查询接口")
public class ConversationController {

    private final ConversationService conversationService;

    @PostMapping
    @Operation(summary = "创建会话", description = "为指定智能体创建新的聊天会话")
    public ApiResult<ConversationDTO> createConversation(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "智能体ID", required = true)
            @RequestParam @NotBlank String agentId,
            
            @Parameter(description = "会话标题", required = false)
            @RequestParam(required = false) String title) {
        
        log.info("创建会话, tenantId={}, userId={}, agentId={}", tenantId, userId, agentId);
        
        try {
            ConversationDTO conversation = conversationService.createConversation(
                tenantId, agentId, userId, title);
            
            log.info("会话创建成功, conversationId={}", conversation.getId());
            return ApiResult.success(conversation);
            
        } catch (Exception e) {
            log.error("创建会话失败, tenantId={}, userId={}, agentId={}, error={}", 
                     tenantId, userId, agentId, e.getMessage(), e);
            return ApiResult.error("创建会话失败: " + e.getMessage());
        }
    }

    @PutMapping("/{conversationId}/title")
    @Operation(summary = "更新会话标题", description = "修改指定会话的标题")
    public ApiResult<ConversationDTO> updateConversationTitle(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId,
            
            @Parameter(description = "新标题", required = true)
            @RequestParam @NotBlank String title) {
        
        log.info("更新会话标题, tenantId={}, conversationId={}, title={}", 
                tenantId, conversationId, title);
        
        try {
            ConversationDTO conversation = conversationService.updateConversationTitle(
                tenantId, conversationId, title);
            
            log.info("会话标题更新成功, conversationId={}", conversationId);
            return ApiResult.success(conversation);
            
        } catch (Exception e) {
            log.error("更新会话标题失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("更新会话标题失败: " + e.getMessage());
        }
    }

    @PostMapping("/{conversationId}/end")
    @Operation(summary = "结束会话", description = "结束指定的聊天会话")
    public ApiResult<Void> endConversation(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId) {
        
        log.info("结束会话, tenantId={}, conversationId={}", tenantId, conversationId);
        
        try {
            conversationService.endConversation(tenantId, conversationId);
            
            log.info("会话结束成功, conversationId={}", conversationId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("结束会话失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("结束会话失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{conversationId}")
    @Operation(summary = "删除会话", description = "删除指定的聊天会话")
    public ApiResult<Void> deleteConversation(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId) {
        
        log.info("删除会话, tenantId={}, userId={}, conversationId={}", tenantId, userId, conversationId);
        
        try {
            conversationService.deleteConversation(tenantId, userId, conversationId);
            
            log.info("会话删除成功, conversationId={}", conversationId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("删除会话失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("删除会话失败: " + e.getMessage());
        }
    }

    @GetMapping("/{conversationId}")
    @Operation(summary = "获取会话详情", description = "根据ID获取会话详细信息")
    public ApiResult<ConversationDTO> getConversation(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @RequestHeader("X-User-Id") @NotBlank String userId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId) {
        
        log.debug("获取会话详情, tenantId={}, userId={}, conversationId={}", tenantId, userId, conversationId);
        
        try {
            ConversationDTO conversation = conversationService.getConversation(tenantId, userId, conversationId);
            
            return ApiResult.success(conversation);
            
        } catch (Exception e) {
            log.error("获取会话详情失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("获取会话详情失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "获取用户会话列表", description = "分页获取指定用户的会话列表")
    public ApiResult<PageResult<ConversationDTO>> getUserConversations(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @PathVariable @NotBlank String userId,
            
            @Parameter(description = "页码", required = false)
            @RequestParam(defaultValue = "1") int pageNum,
            
            @Parameter(description = "每页大小", required = false)
            @RequestParam(defaultValue = "20") int pageSize) {
        
        log.debug("获取用户会话列表, tenantId={}, userId={}", tenantId, userId);
        
        try {
            PageResult<ConversationDTO> result = conversationService.getUserConversations(
                tenantId, userId, pageNum, pageSize);
            
            return ApiResult.success(result);
            
        } catch (Exception e) {
            log.error("获取用户会话列表失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("获取用户会话列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/agent/{agentId}")
    @Operation(summary = "获取智能体会话列表", description = "分页获取指定智能体的会话列表")
    public ApiResult<PageResult<ConversationDTO>> getAgentConversations(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId,
            
            @Parameter(description = "页码", required = false)
            @RequestParam(defaultValue = "1") int pageNum,
            
            @Parameter(description = "每页大小", required = false)
            @RequestParam(defaultValue = "20") int pageSize) {
        
        log.debug("获取智能体会话列表, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            PageResult<ConversationDTO> result = conversationService.getAgentConversations(
                tenantId, agentId, pageNum, pageSize);
            
            return ApiResult.success(result);
            
        } catch (Exception e) {
            log.error("获取智能体会话列表失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("获取智能体会话列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}/active")
    @Operation(summary = "获取用户活跃会话", description = "获取指定用户的活跃会话列表")
    public ApiResult<List<ConversationDTO>> getActiveConversations(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @PathVariable @NotBlank String userId) {
        
        log.debug("获取用户活跃会话, tenantId={}, userId={}", tenantId, userId);
        
        try {
            List<ConversationDTO> conversations = conversationService.getActiveConversations(tenantId, userId);
            
            return ApiResult.success(conversations);
            
        } catch (Exception e) {
            log.error("获取用户活跃会话失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("获取用户活跃会话失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取会话统计信息", description = "获取租户下会话的统计数据")
    public ApiResult<Map<String, Long>> getConversationStatistics(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取会话统计信息, tenantId={}", tenantId);
        
        try {
            Map<String, Long> statistics = Map.of(
                "ACTIVE", conversationService.countConversationsByStatus(tenantId, ConversationStatus.ACTIVE),
                "ENDED", conversationService.countConversationsByStatus(tenantId, ConversationStatus.ENDED),
                "DELETED", conversationService.countConversationsByStatus(tenantId, ConversationStatus.DELETED)
            );
            
            return ApiResult.success(statistics);
            
        } catch (Exception e) {
            log.error("获取会话统计信息失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取统计信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}/count")
    @Operation(summary = "获取用户会话数量", description = "获取指定用户的会话总数")
    public ApiResult<Long> countUserConversations(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @PathVariable @NotBlank String userId) {
        
        log.debug("获取用户会话数量, tenantId={}, userId={}", tenantId, userId);
        
        try {
            long count = conversationService.countUserConversations(tenantId, userId);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("获取用户会话数量失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("获取用户会话数量失败: " + e.getMessage());
        }
    }

    @GetMapping("/agent/{agentId}/count")
    @Operation(summary = "获取智能体会话数量", description = "获取指定智能体的会话总数")
    public ApiResult<Long> countAgentConversations(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.debug("获取智能体会话数量, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            long count = conversationService.countAgentConversations(tenantId, agentId);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("获取智能体会话数量失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("获取智能体会话数量失败: " + e.getMessage());
        }
    }
}