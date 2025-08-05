package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.AgentType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI智能体实体
 */
@Data
@TableName("agents")
@Schema(description = "AI智能体实体")
public class Agent {

    @TableId(type = IdType.ASSIGN_UUID)
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
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private AgentType type;

    @Schema(description = "智能体状态")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private AgentStatus status;

    @Schema(description = "外部平台类型(COZE/DIFY/DIRECT_MODEL)")
    private String platformType;

    @Schema(description = "外部平台配置ID")
    private String platformConfigId;

    @Schema(description = "模型配置ID(直接调用模型时使用)")
    private String modelConfigId;

    @Schema(description = "系统提示词")
    private String systemPrompt;

    @Schema(description = "智能体配置JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String configJson;

    @Schema(description = "是否启用")
    private Boolean enabled;

    @Schema(description = "排序")
    private Integer sortOrder;

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
}