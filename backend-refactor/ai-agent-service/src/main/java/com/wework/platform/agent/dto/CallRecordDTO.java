package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.CallStatus;
import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 外部平台调用记录DTO
 */
@Data
@Schema(description = "外部平台调用记录DTO")
public class CallRecordDTO {

    @Schema(description = "记录ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "智能体ID")
    private String agentId;

    @Schema(description = "会话ID")
    private String conversationId;

    @Schema(description = "消息ID")
    private String messageId;

    @Schema(description = "平台类型")
    private PlatformType platformType;

    @Schema(description = "平台配置ID")
    private String platformConfigId;

    @Schema(description = "模型配置ID")
    private String modelConfigId;

    @Schema(description = "调用状态")
    private CallStatus status;

    @Schema(description = "调用方法")
    private String method;

    @Schema(description = "请求URL")
    private String requestUrl;

    @Schema(description = "请求头JSON")
    private String requestHeaders;

    @Schema(description = "请求体JSON")
    private String requestBody;

    @Schema(description = "响应状态码")
    private Integer responseStatus;

    @Schema(description = "响应头JSON")
    private String responseHeaders;

    @Schema(description = "响应体JSON")
    private String responseBody;

    @Schema(description = "外部请求ID")
    private String externalRequestId;

    @Schema(description = "开始时间")
    private LocalDateTime startTime;

    @Schema(description = "结束时间")
    private LocalDateTime endTime;

    @Schema(description = "响应时间(毫秒)")
    private Long responseTime;

    @Schema(description = "Token消耗数量")
    private Integer tokenCount;

    @Schema(description = "调用费用")
    private BigDecimal cost;

    @Schema(description = "重试次数")
    private Integer retryCount;

    @Schema(description = "错误代码")
    private String errorCode;

    @Schema(description = "错误信息")
    private String errorMessage;

    @Schema(description = "错误堆栈信息")
    private String errorStack;

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

    @Schema(description = "平台配置名称")
    private String platformConfigName;

    @Schema(description = "模型配置名称")
    private String modelConfigName;

    @Schema(description = "模型名称")
    private String modelName;

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "用户名称")
    private String userName;

    @Schema(description = "是否成功")
    private Boolean success;

    @Schema(description = "调用类型(chat/workflow/embedding等)")
    private String callType;
}