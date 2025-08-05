package com.wework.platform.agent.dto.request;

import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.AgentType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.Size;
import java.util.List;

/**
 * 更新智能体请求DTO
 */
@Data
@Schema(description = "更新智能体请求")
public class UpdateAgentRequest {

    @Size(max = 100, message = "智能体名称长度不能超过100个字符")
    @Schema(description = "智能体名称")
    private String name;

    @Size(max = 500, message = "智能体描述长度不能超过500个字符")
    @Schema(description = "智能体描述")
    private String description;

    @Schema(description = "智能体头像URL")
    private String avatar;

    @Schema(description = "智能体类型")
    private AgentType type;

    @Schema(description = "智能体状态")
    private AgentStatus status;

    @Schema(description = "外部平台类型")
    private String externalPlatformType;

    @Schema(description = "外部智能体ID")
    private String externalAgentId;

    @Schema(description = "平台配置ID")
    private String platformConfigId;

    @Schema(description = "模型配置ID")
    private String modelConfigId;

    @Schema(description = "系统提示词")
    private String systemPrompt;

    @Schema(description = "欢迎消息")
    private String welcomeMessage;

    @Schema(description = "智能体配置JSON")
    private String configJson;

    @Schema(description = "是否启用")
    private Boolean enabled;

    @Schema(description = "是否公开")
    private Boolean isPublic;

    @Schema(description = "标签列表")
    private List<String> tags;

    @Schema(description = "能力列表")
    private List<String> capabilities;

    @Schema(description = "知识库ID列表")
    private List<String> knowledgeBaseIds;

    @Schema(description = "工具ID列表")
    private List<String> toolIds;

    @Schema(description = "智能体图标")
    private String icon;

    @Schema(description = "智能体颜色")
    private String color;

    @Schema(description = "排序权重")
    private Integer sortWeight;

    @Schema(description = "备注")
    private String remarks;
}