package com.wework.platform.agent.dto.request;

import com.wework.platform.agent.enums.MessageType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.List;
import java.util.Map;

/**
 * 聊天请求DTO
 */
@Data
@Schema(description = "聊天请求")
public class ChatRequest {

    @NotBlank(message = "智能体ID不能为空")
    @Schema(description = "智能体ID", required = true)
    private String agentId;

    @Schema(description = "会话ID(为空时创建新会话)")
    private String conversationId;

    @NotNull(message = "消息类型不能为空")
    @Schema(description = "消息类型", required = true)
    private MessageType messageType = MessageType.TEXT;

    @NotBlank(message = "消息内容不能为空")
    @Size(max = 10000, message = "消息内容长度不能超过10000个字符")
    @Schema(description = "消息内容", required = true)
    private String content;

    @Schema(description = "结构化内容JSON")
    private String structuredContent;

    @Schema(description = "附件列表")
    private List<AttachmentInfo> attachments;

    @Schema(description = "引用消息ID")
    private String quotedMessageId;

    @Schema(description = "额外参数")
    private Map<String, Object> extraParams;

    @Schema(description = "是否流式响应")
    private Boolean streaming = false;

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "消息内容(兼容字段)")
    private String message;

    @Schema(description = "会话历史")
    private List<Map<String, Object>> history;

    @Schema(description = "是否流式输出(兼容字段)")
    private Boolean stream = false;

    @Schema(description = "会话配置覆盖")
    private ConversationConfigOverride configOverride;

    @Schema(description = "客户端ID")
    private String clientId;

    @Schema(description = "请求追踪ID")
    private String traceId;

    /**
     * 附件信息
     */
    @Data
    @Schema(description = "附件信息")
    public static class AttachmentInfo {
        @Schema(description = "附件类型(image/audio/video/file)")
        private String type;

        @Schema(description = "附件URL")
        private String url;

        @Schema(description = "附件名称")
        private String name;

        @Schema(description = "附件大小(字节)")
        private Long size;

        @Schema(description = "MIME类型")
        private String mimeType;

        @Schema(description = "附件描述")
        private String description;

        @Schema(description = "元数据")
        private Map<String, Object> metadata;
    }

    /**
     * 会话配置覆盖
     */
    @Data
    @Schema(description = "会话配置覆盖")
    public static class ConversationConfigOverride {
        @Schema(description = "模型配置ID")
        private String modelConfigId;

        @Schema(description = "系统提示词")
        private String systemPrompt;

        @Schema(description = "温度参数")
        private Double temperature;

        @Schema(description = "最大Token数")
        private Integer maxTokens;

        @Schema(description = "Top P参数")
        private Double topP;

        @Schema(description = "是否启用历史记录")
        private Boolean enableHistory;

        @Schema(description = "历史记录长度")
        private Integer historyLength;
    }
}