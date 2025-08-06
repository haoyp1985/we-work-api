package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 外部平台配置实体
 */
@Data
@TableName("platform_configs")
@Schema(description = "外部平台配置实体")
public class PlatformConfig {

    @TableId(type = IdType.ASSIGN_UUID)
    @Schema(description = "配置ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "配置名称")
    private String name;

    @Schema(description = "平台类型")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private PlatformType platformType;

    @Schema(description = "平台基础URL")
    private String baseUrl;

    @Schema(description = "API密钥")
    private String apiKey;

    @Schema(description = "API密钥Secret")
    private String apiSecret;

    @Schema(description = "Bot ID或工作流ID")
    private String botId;

    @Schema(description = "工作空间ID")
    private String workspaceId;

    @Schema(description = "额外配置参数JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
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
     * 获取API URL
     * 返回baseUrl字段的值
     */
    public String getApiUrl() {
        return this.baseUrl;
    }
}