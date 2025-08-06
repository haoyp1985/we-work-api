package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.MessageDTO;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;
import com.wework.platform.agent.service.MessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 消息管理控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/messages")
@RequiredArgsConstructor
@Validated
@Tag(name = "消息管理", description = "聊天消息的查询、管理和统计接口")
public class MessageController {

    private final MessageService messageService;

    @GetMapping("/{messageId}")
    @Operation(summary = "获取消息详情", description = "根据ID获取消息详细信息")
    public ApiResult<MessageDTO> getMessage(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息ID", required = true)
            @PathVariable @NotBlank String messageId) {
        
        log.debug("获取消息详情, tenantId={}, messageId={}", tenantId, messageId);
        
        try {
            MessageDTO message = messageService.getMessage(tenantId, messageId);
            
            return ApiResult.success(message);
            
        } catch (Exception e) {
            log.error("获取消息详情失败, tenantId={}, messageId={}, error={}", 
                     tenantId, messageId, e.getMessage(), e);
            return ApiResult.error("获取消息详情失败: " + e.getMessage());
        }
    }

    @GetMapping("/conversation/{conversationId}")
    @Operation(summary = "获取会话消息列表", description = "分页获取指定会话的消息列表")
    public ApiResult<PageResult<MessageDTO>> getConversationMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId,
            
            @Parameter(description = "页码", required = false)
            @RequestParam(defaultValue = "1") int pageNum,
            
            @Parameter(description = "每页大小", required = false)
            @RequestParam(defaultValue = "20") int pageSize) {
        
        log.debug("获取会话消息列表, tenantId={}, conversationId={}", tenantId, conversationId);
        
        try {
            PageResult<MessageDTO> result = messageService.getConversationMessages(
                tenantId, conversationId, pageNum, pageSize, true);
            
            return ApiResult.success(result);
            
        } catch (Exception e) {
            log.error("获取会话消息列表失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("获取会话消息列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/conversation/{conversationId}/recent")
    @Operation(summary = "获取会话最近消息", description = "获取指定会话的最近N条消息")
    public ApiResult<List<MessageDTO>> getRecentMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId,
            
            @Parameter(description = "消息数量", required = false)
            @RequestParam(defaultValue = "10") int limit) {
        
        log.debug("获取会话最近消息, tenantId={}, conversationId={}, limit={}", 
                 tenantId, conversationId, limit);
        
        try {
            List<MessageDTO> messages = messageService.getRecentMessages(tenantId, conversationId, limit);
            
            return ApiResult.success(messages);
            
        } catch (Exception e) {
            log.error("获取会话最近消息失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("获取会话最近消息失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "获取用户消息列表", description = "获取指定用户的最近消息")
    public ApiResult<List<MessageDTO>> getUserMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @PathVariable @NotBlank String userId,
            
            @Parameter(description = "消息数量", required = false)
            @RequestParam(defaultValue = "50") int limit) {
        
        log.debug("获取用户消息列表, tenantId={}, userId={}, limit={}", tenantId, userId, limit);
        
        try {
            List<MessageDTO> messages = messageService.getUserMessages(tenantId, userId, limit);
            
            return ApiResult.success(messages);
            
        } catch (Exception e) {
            log.error("获取用户消息列表失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("获取用户消息列表失败: " + e.getMessage());
        }
    }

    @PutMapping("/{messageId}/status")
    @Operation(summary = "更新消息状态", description = "更新指定消息的状态")
    public ApiResult<Void> updateMessageStatus(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息ID", required = true)
            @PathVariable @NotBlank String messageId,
            
            @Parameter(description = "新状态", required = true)
            @RequestParam MessageStatus status) {
        
        log.info("更新消息状态, tenantId={}, messageId={}, status={}", tenantId, messageId, status);
        
        try {
            messageService.updateMessageStatus(tenantId, messageId, status);
            
            log.info("消息状态更新成功, messageId={}, status={}", messageId, status);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("更新消息状态失败, tenantId={}, messageId={}, status={}, error={}", 
                     tenantId, messageId, status, e.getMessage(), e);
            return ApiResult.error("更新消息状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{messageId}/content")
    @Operation(summary = "更新消息内容", description = "更新指定消息的内容")
    public ApiResult<Void> updateMessageContent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息ID", required = true)
            @PathVariable @NotBlank String messageId,
            
            @Parameter(description = "新内容", required = true)
            @RequestParam @NotBlank String content) {
        
        log.info("更新消息内容, tenantId={}, messageId={}", tenantId, messageId);
        
        try {
            messageService.updateMessageContent(tenantId, messageId, content);
            
            log.info("消息内容更新成功, messageId={}", messageId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("更新消息内容失败, tenantId={}, messageId={}, error={}", 
                     tenantId, messageId, e.getMessage(), e);
            return ApiResult.error("更新消息内容失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{messageId}")
    @Operation(summary = "删除消息", description = "删除指定的消息")
    public ApiResult<Void> deleteMessage(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息ID", required = true)
            @PathVariable @NotBlank String messageId) {
        
        log.info("删除消息, tenantId={}, messageId={}", tenantId, messageId);
        
        try {
            messageService.deleteMessage(tenantId, messageId);
            
            log.info("消息删除成功, messageId={}", messageId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("删除消息失败, tenantId={}, messageId={}, error={}", 
                     tenantId, messageId, e.getMessage(), e);
            return ApiResult.error("删除消息失败: " + e.getMessage());
        }
    }

    @GetMapping("/search")
    @Operation(summary = "搜索消息", description = "根据关键字搜索消息")
    public ApiResult<List<MessageDTO>> searchMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "搜索关键字", required = true)
            @RequestParam @NotBlank String keyword,
            
            @Parameter(description = "结果数量限制", required = false)
            @RequestParam(defaultValue = "50") int limit) {
        
        log.debug("搜索消息, tenantId={}, keyword={}, limit={}", tenantId, keyword, limit);
        
        try {
            PageResult<MessageDTO> result = messageService.searchMessages(
                tenantId, null, keyword, null, null, null, 1, limit);
            
            return ApiResult.success(result);
            
        } catch (Exception e) {
            log.error("搜索消息失败, tenantId={}, keyword={}, error={}", 
                     tenantId, keyword, e.getMessage(), e);
            return ApiResult.error("搜索消息失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取消息统计信息", description = "获取指定时间范围内的消息统计数据")
    public ApiResult<Map<String, Long>> getMessageStatistics(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "开始时间", required = false)
            @RequestParam(required = false) 
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            
            @Parameter(description = "结束时间", required = false)
            @RequestParam(required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        
        log.debug("获取消息统计信息, tenantId={}, startTime={}, endTime={}", 
                 tenantId, startTime, endTime);
        
        try {
            // 默认统计最近7天
            if (startTime == null) {
                startTime = LocalDateTime.now().minusDays(7);
            }
            if (endTime == null) {
                endTime = LocalDateTime.now();
            }
            
            Map<String, Long> statistics = messageService.getMessageStatistics(tenantId, startTime, endTime);
            
            return ApiResult.success(statistics);
            
        } catch (Exception e) {
            log.error("获取消息统计信息失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取统计信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/count/type/{type}")
    @Operation(summary = "按类型统计消息数量", description = "获取指定类型的消息总数")
    public ApiResult<Long> countMessagesByType(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息类型", required = true)
            @PathVariable MessageType type) {
        
        log.debug("按类型统计消息数量, tenantId={}, type={}", tenantId, type);
        
        try {
            long count = messageService.countMessagesByType(tenantId, type);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("按类型统计消息数量失败, tenantId={}, type={}, error={}", 
                     tenantId, type, e.getMessage(), e);
            return ApiResult.error("统计消息数量失败: " + e.getMessage());
        }
    }

    @GetMapping("/count/status/{status}")
    @Operation(summary = "按状态统计消息数量", description = "获取指定状态的消息总数")
    public ApiResult<Long> countMessagesByStatus(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "消息状态", required = true)
            @PathVariable MessageStatus status) {
        
        log.debug("按状态统计消息数量, tenantId={}, status={}", tenantId, status);
        
        try {
            long count = messageService.countMessagesByStatus(tenantId, status);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("按状态统计消息数量失败, tenantId={}, status={}, error={}", 
                     tenantId, status, e.getMessage(), e);
            return ApiResult.error("统计消息数量失败: " + e.getMessage());
        }
    }

    @GetMapping("/conversation/{conversationId}/count")
    @Operation(summary = "获取会话消息数量", description = "获取指定会话的消息总数")
    public ApiResult<Long> countConversationMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "会话ID", required = true)
            @PathVariable @NotBlank String conversationId) {
        
        log.debug("获取会话消息数量, tenantId={}, conversationId={}", tenantId, conversationId);
        
        try {
            long count = messageService.countConversationMessages(tenantId, conversationId);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("获取会话消息数量失败, tenantId={}, conversationId={}, error={}", 
                     tenantId, conversationId, e.getMessage(), e);
            return ApiResult.error("获取会话消息数量失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}/count")
    @Operation(summary = "获取用户消息数量", description = "获取指定用户的消息总数")
    public ApiResult<Long> countUserMessages(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "用户ID", required = true)
            @PathVariable @NotBlank String userId) {
        
        log.debug("获取用户消息数量, tenantId={}, userId={}", tenantId, userId);
        
        try {
            long count = messageService.countUserMessages(tenantId, userId);
            
            return ApiResult.success(count);
            
        } catch (Exception e) {
            log.error("获取用户消息数量失败, tenantId={}, userId={}, error={}", 
                     tenantId, userId, e.getMessage(), e);
            return ApiResult.error("获取用户消息数量失败: " + e.getMessage());
        }
    }
}