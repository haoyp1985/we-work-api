package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 模型配置DTO
 */
@Data
@Schema(description = "模型配置DTO")
public class ModelConfigDTO {

    @Schema(description = "配置ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "配置名称")
    private String name;

    @Schema(description = "平台类型")
    private PlatformType platformType;

    @Schema(description = "模型名称")
    private String modelName;

    @Schema(description = "模型版本")
    private String modelVersion;

    @Schema(description = "API基础URL")
    private String baseUrl;

    @Schema(description = "API密钥(脱敏)")
    private String apiKeyMasked;

    @Schema(description = "温度参数(0.0-2.0)")
    private BigDecimal temperature;

    @Schema(description = "最大Token数")
    private Integer maxTokens;

    @Schema(description = "Top P参数(0.0-1.0)")
    private BigDecimal topP;

    @Schema(description = "Top K参数")
    private Integer topK;

    @Schema(description = "重复惩罚参数")
    private BigDecimal repetitionPenalty;

    @Schema(description = "停止词列表JSON")
    private String stopWords;

    @Schema(description = "系统提示词")
    private String systemPrompt;

    @Schema(description = "额外配置参数JSON")
    private String configJson;

    @Schema(description = "请求超时时间(毫秒)")
    private Integer timeoutMs;

    @Schema(description = "最大重试次数")
    private Integer maxRetries;

    @Schema(description = "每分钟最大请求数")
    private Integer rpmLimit;

    @Schema(description = "是否启用")
    private Boolean enabled;

    @Schema(description = "描述")
    private String description;

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
    @Schema(description = "关联的智能体数量")
    private Long agentCount;

    @Schema(description = "使用次数")
    private Long usageCount;

    @Schema(description = "最近使用时间")
    private LocalDateTime lastUsedTime;

    @Schema(description = "平均Token消耗")
    private Double avgTokens;

    @Schema(description = "总费用")
    private BigDecimal totalCost;

    @Schema(description = "调用成功率")
    private Double successRate;
}