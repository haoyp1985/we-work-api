package com.wework.platform.agent.dto;

import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.AgentType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 智能体DTO
 */
@Data
@Schema(description = "智能体DTO")
public class AgentDTO {

    @Schema(description = "智能体ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "智能体名称")
    private String name;

    @Schema(description = "智能体描述")
    private String description;

    @Schema(description = "智能体头像")
    private String avatar;

    @Schema(description = "智能体类型")
    private AgentType type;

    @Schema(description = "智能体状态")
    private AgentStatus status;

    @Schema(description = "外部平台类型")
    private String platformType;

    @Schema(description = "外部平台配置ID")
    private String platformConfigId;

    @Schema(description = "模型配置ID")
    private String modelConfigId;

    @Schema(description = "系统提示词")
    private String systemPrompt;

    @Schema(description = "智能体配置JSON")
    private String configJson;

    @Schema(description = "是否启用")
    private Boolean enabled;

    @Schema(description = "排序")
    private Integer sortOrder;

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
    @Schema(description = "平台配置名称")
    private String platformConfigName;

    @Schema(description = "模型配置名称")
    private String modelConfigName;

    @Schema(description = "活跃会话数")
    private Long activeConversations;

    @Schema(description = "总消息数")
    private Long totalMessages;

    @Schema(description = "最后使用时间")
    private LocalDateTime lastUsedAt;
}