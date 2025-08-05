package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.ConversationStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 对话会话DTO
 */
@Data
@Schema(description = "对话会话DTO")
public class ConversationDTO {

    @Schema(description = "会话ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "智能体ID")
    private String agentId;

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "会话标题")
    private String title;

    @Schema(description = "会话状态")
    private ConversationStatus status;

    @Schema(description = "外部平台会话ID")
    private String externalConversationId;

    @Schema(description = "会话上下文JSON")
    private String contextJson;

    @Schema(description = "会话配置JSON")
    private String configJson;

    @Schema(description = "最后消息时间")
    private LocalDateTime lastMessageAt;

    @Schema(description = "消息总数")
    private Integer messageCount;

    @Schema(description = "Token消耗总数")
    private Long totalTokens;

    @Schema(description = "会话开始时间")
    private LocalDateTime startedAt;

    @Schema(description = "会话结束时间")
    private LocalDateTime endedAt;

    @Schema(description = "是否置顶")
    private Boolean pinned;

    @Schema(description = "是否收藏")
    private Boolean starred;

    @Schema(description = "标签列表")
    private List<String> tags;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    @Schema(description = "创建人")
    private String createdBy;

    @Schema(description = "更新人")
    private String updatedBy;

    @Schema(description = "版本号")
    private Integer version;

    // 扩展信息
    @Schema(description = "智能体名称")
    private String agentName;

    @Schema(description = "智能体头像")
    private String agentAvatar;

    @Schema(description = "用户名称")
    private String userName;

    @Schema(description = "最后一条消息内容")
    private String lastMessageContent;

    @Schema(description = "最后一条消息发送者角色")
    private String lastMessageRole;

    @Schema(description = "会话持续时长(秒)")
    private Long durationSeconds;

    @Schema(description = "平均响应时间(毫秒)")
    private Double avgResponseTime;
}