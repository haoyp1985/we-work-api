package com.wework.platform.agent.dto.response;

import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 聊天响应DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "聊天响应")
public class ChatResponse {

    @Schema(description = "会话ID")
    private String conversationId;

    @Schema(description = "请求消息ID")
    private String requestMessageId;

    @Schema(description = "响应消息ID")
    private String responseMessageId;

    @Schema(description = "智能体ID")
    private String agentId;

    @Schema(description = "智能体名称")
    private String agentName;

    @Schema(description = "智能体头像")
    private String agentAvatar;

    @Schema(description = "消息类型")
    private MessageType messageType;

    @Schema(description = "消息状态")
    private MessageStatus messageStatus;

    @Schema(description = "响应内容")
    private String content;

    @Schema(description = "结构化内容JSON")
    private String structuredContent;

    @Schema(description = "是否流式响应")
    private Boolean streaming;

    @Schema(description = "流式响应序号(流式时使用)")
    private Integer streamSequence;

    @Schema(description = "是否完成(流式时使用)")
    private Boolean finished;

    @Schema(description = "Token消耗统计")
    private TokenUsage tokenUsage;

    @Schema(description = "调用统计")
    private CallStats callStats;

    @Schema(description = "使用的模型名称")
    private String modelName;

    @Schema(description = "响应时间(毫秒)")
    private Long responseTime;

    @Schema(description = "错误信息")
    private String errorMessage;

    @Schema(description = "工具调用结果")
    private List<ToolCallResult> toolCalls;

    @Schema(description = "引用信息")
    private List<ReferenceInfo> references;

    @Schema(description = "建议操作")
    private List<SuggestedAction> suggestedActions;

    @Schema(description = "扩展数据")
    private Map<String, Object> extraData;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "请求追踪ID")
    private String traceId;

    /**
     * Token使用统计
     */
    @Data
    @Schema(description = "Token使用统计")
    public static class TokenUsage {
        @Schema(description = "输入Token数")
        private Integer inputTokens;

        @Schema(description = "输出Token数")
        private Integer outputTokens;

        @Schema(description = "总Token数")
        private Integer totalTokens;

        @Schema(description = "Token费用")
        private Double cost;
    }

    /**
     * 调用统计
     */
    @Data
    @Schema(description = "调用统计")
    public static class CallStats {
        @Schema(description = "外部调用次数")
        private Integer callCount;

        @Schema(description = "总调用时间(毫秒)")
        private Long totalCallTime;

        @Schema(description = "平均调用时间(毫秒)")
        private Double avgCallTime;

        @Schema(description = "成功调用次数")
        private Integer successCount;

        @Schema(description = "失败调用次数")
        private Integer failedCount;
    }

    /**
     * 工具调用结果
     */
    @Data
    @Schema(description = "工具调用结果")
    public static class ToolCallResult {
        @Schema(description = "工具名称")
        private String toolName;

        @Schema(description = "调用参数")
        private Map<String, Object> parameters;

        @Schema(description = "调用结果")
        private Object result;

        @Schema(description = "是否成功")
        private Boolean success;

        @Schema(description = "错误信息")
        private String errorMessage;

        @Schema(description = "执行时间(毫秒)")
        private Long executionTime;
    }

    /**
     * 引用信息
     */
    @Data
    @Schema(description = "引用信息")
    public static class ReferenceInfo {
        @Schema(description = "引用类型(knowledge/document/url)")
        private String type;

        @Schema(description = "引用标题")
        private String title;

        @Schema(description = "引用内容")
        private String content;

        @Schema(description = "引用来源")
        private String source;

        @Schema(description = "引用URL")
        private String url;

        @Schema(description = "相关性分数")
        private Double relevanceScore;
    }

    /**
     * 建议操作
     */
    @Data
    @Schema(description = "建议操作")
    public static class SuggestedAction {
        @Schema(description = "操作类型")
        private String type;

        @Schema(description = "操作标题")
        private String title;

        @Schema(description = "操作描述")
        private String description;

        @Schema(description = "操作参数")
        private Map<String, Object> parameters;

        @Schema(description = "操作图标")
        private String icon;
    }
}