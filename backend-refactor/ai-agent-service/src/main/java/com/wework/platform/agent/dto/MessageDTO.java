package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 消息DTO
 */
@Data
@Schema(description = "消息DTO")
public class MessageDTO {

    @Schema(description = "消息ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "会话ID")
    private String conversationId;

    @Schema(description = "智能体ID")
    private String agentId;

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "消息类型")
    private MessageType type;

    @Schema(description = "消息状态")
    private MessageStatus status;

    @Schema(description = "发送者角色(user/assistant/system)")
    private String role;

    @Schema(description = "消息内容")
    private String content;

    @Schema(description = "结构化内容JSON")
    private String structuredContent;

    @Schema(description = "附件信息JSON")
    private String attachments;

    @Schema(description = "外部消息ID")
    private String externalMessageId;

    @Schema(description = "父消息ID(用于回复)")
    private String parentMessageId;

    @Schema(description = "Token消耗数量")
    private Integer tokenCount;

    @Schema(description = "模型名称")
    private String modelName;

    @Schema(description = "响应时间(毫秒)")
    private Long responseTime;

    @Schema(description = "错误信息")
    private String errorMessage;

    @Schema(description = "元数据JSON")
    private String metadata;

    @Schema(description = "排序号")
    private Integer sortOrder;

    @Schema(description = "是否已读")
    private Boolean isRead;

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

    @Schema(description = "用户头像")
    private String userAvatar;

    @Schema(description = "引用消息内容")
    private String quotedContent;

    @Schema(description = "是否为流式输出")
    private Boolean streaming;

    @Schema(description = "消息摘要")
    private String summary;
}