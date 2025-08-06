package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.MessageType;
import com.wework.platform.agent.enums.MessageStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 消息实体
 */
@Data
@TableName("messages")
@Schema(description = "消息实体")
public class Message {

    @TableId(type = IdType.ASSIGN_UUID)
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
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private MessageType messageType;

    @Schema(description = "消息状态")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private MessageStatus status;

    @Schema(description = "消息内容")
    @TableField(value = "content", typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String content;

    @Schema(description = "消息原始内容JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String rawContent;

    @Schema(description = "消息角色(user/assistant/system)")
    private String role;

    @Schema(description = "外部消息ID")
    private String externalMessageId;

    @Schema(description = "父消息ID")
    private String parentMessageId;

    @Schema(description = "消息序号")
    private Integer sequenceNumber;

    @Schema(description = "Token消耗数量")
    private Integer tokens;

    @Schema(description = "处理耗时(毫秒)")
    private Long processTimeMs;

    @Schema(description = "附件信息JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String attachments;

    @Schema(description = "元数据JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String metadata;

    @Schema(description = "错误信息")
    private String errorMessage;

    @Schema(description = "重试次数")
    private Integer retryCount;

    @Schema(description = "发送时间")
    private LocalDateTime sentAt;

    @Schema(description = "接收时间")
    private LocalDateTime receivedAt;

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

    /**
     * 获取消息类型（用于兼容接口调用）
     */
    public MessageType getType() {
        return this.messageType;
    }

    /**
     * 设置消息类型（用于兼容接口调用）
     */
    public void setType(MessageType type) {
        this.messageType = type;
    }

    /**
     * 设置Token数量（用于兼容接口调用）
     */
    public void setTokenCount(Integer tokenCount) {
        this.tokens = tokenCount;
    }

    /**
     * 设置响应时间（用于兼容接口调用）
     */
    public void setResponseTime(Long responseTime) {
        this.processTimeMs = responseTime;
    }
}