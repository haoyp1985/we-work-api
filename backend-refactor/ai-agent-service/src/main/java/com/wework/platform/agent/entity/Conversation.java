package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.ConversationStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 对话会话实体
 */
@Data
@TableName("conversations")
@Schema(description = "对话会话实体")
public class Conversation {

    @TableId(type = IdType.ASSIGN_UUID)
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
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private ConversationStatus status;

    @Schema(description = "外部平台会话ID")
    private String externalConversationId;

    @Schema(description = "会话上下文JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String contextJson;

    @Schema(description = "会话配置JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String configJson;

    @Schema(description = "最后消息时间")
    private LocalDateTime lastMessageAt;

    @Schema(description = "最后一条消息内容")
    private String lastMessage;

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

    @Schema(description = "标签JSON数组")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String tags;

    @Schema(description = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    @Schema(description = "创建人")
    private String createdBy;

    @Schema(description = "更新人")
    private String updatedBy;

    @Schema(description = "版本号")
    @Version
    private Integer version;

    @Schema(description = "是否删除")
    @TableLogic
    private Boolean deleted;
}