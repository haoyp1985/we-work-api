package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.CallStatus;
import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 外部平台调用记录实体
 */
@Data
@TableName("call_records")
@Schema(description = "外部平台调用记录实体")
public class CallRecord {

    @TableId(type = IdType.ASSIGN_UUID)
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

    @Schema(description = "用户ID")
    private String userId;

    @Schema(description = "平台类型")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private PlatformType platformType;

    @Schema(description = "调用类型(CHAT/WORKFLOW/MODEL)")
    private String callType;

    @Schema(description = "平台配置ID")
    private String platformConfigId;

    @Schema(description = "模型配置ID")
    private String modelConfigId;

    @Schema(description = "请求URL")
    private String requestUrl;

    @Schema(description = "请求方法")
    private String requestMethod;

    @Schema(description = "请求头JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String requestHeaders;

    @Schema(description = "请求体JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String requestBody;

    @Schema(description = "响应状态码")
    private Integer responseStatus;

    @Schema(description = "响应头JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String responseHeaders;

    @Schema(description = "响应体JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String responseBody;

    @Schema(description = "调用状态")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private CallStatus callStatus;

    @Schema(description = "开始时间")
    private LocalDateTime startTime;

    @Schema(description = "结束时间")
    private LocalDateTime endTime;

    @Schema(description = "耗时(毫秒)")
    private Long durationMs;

    @Schema(description = "输入Token数")
    private Integer inputTokens;

    @Schema(description = "输出Token数")
    private Integer outputTokens;

    @Schema(description = "总Token数")
    private Integer totalTokens;

    @Schema(description = "调用费用")
    private BigDecimal cost;

    @Schema(description = "错误码")
    private String errorCode;

    @Schema(description = "错误信息")
    private String errorMessage;

    @Schema(description = "重试次数")
    private Integer retryCount;

    @Schema(description = "元数据JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String metadata;

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

    @Schema(description = "是否删除")
    @TableLogic
    private Boolean deleted;
}