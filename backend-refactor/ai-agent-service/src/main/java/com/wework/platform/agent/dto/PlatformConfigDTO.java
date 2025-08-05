package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 外部平台配置DTO
 */
@Data
@Schema(description = "外部平台配置DTO")
public class PlatformConfigDTO {

    @Schema(description = "配置ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "配置名称")
    private String name;

    @Schema(description = "平台类型")
    private PlatformType platformType;

    @Schema(description = "平台基础URL")
    private String baseUrl;

    @Schema(description = "API密钥(脱敏)")
    private String apiKeyMasked;

    @Schema(description = "Bot ID或工作流ID")
    private String botId;

    @Schema(description = "工作空间ID")
    private String workspaceId;

    @Schema(description = "额外配置参数JSON")
    private String configJson;

    @Schema(description = "请求超时时间(毫秒)")
    private Integer timeoutMs;

    @Schema(description = "最大重试次数")
    private Integer maxRetries;

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

    @Schema(description = "最近调用时间")
    private LocalDateTime lastCallTime;

    @Schema(description = "调用成功率")
    private Double successRate;

    @Schema(description = "平均响应时间(毫秒)")
    private Double avgResponseTime;
}