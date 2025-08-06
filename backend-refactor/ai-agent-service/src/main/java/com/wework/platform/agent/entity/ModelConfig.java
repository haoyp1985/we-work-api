package com.wework.platform.agent.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.agent.enums.PlatformType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.HashMap;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 模型配置实体
 */
@Data
@TableName("model_configs")
@Schema(description = "模型配置实体")
public class ModelConfig {

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

    @Schema(description = "模型名称")
    private String modelName;

    @Schema(description = "模型版本")
    private String modelVersion;

    @Schema(description = "API基础URL")
    private String baseUrl;

    @Schema(description = "API密钥")
    private String apiKey;

    @Schema(description = "API密钥Secret")
    private String apiSecret;

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
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private String stopWords;

    @Schema(description = "系统提示词")
    private String systemPrompt;

    @Schema(description = "额外配置参数JSON")
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
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
     * 获取参数配置
     * 解析configJson字段并返回Map对象
     */
    public Map<String, Object> getParameters() {
        if (configJson == null || configJson.trim().isEmpty()) {
            return new HashMap<>();
        }
        
        try {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(configJson, new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            // 如果解析失败，返回空Map
            return new HashMap<>();
        }
    }
}