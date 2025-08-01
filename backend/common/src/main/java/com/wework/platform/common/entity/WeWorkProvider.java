package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 企微接口提供商实体
 *
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wework_providers")
public class WeWorkProvider extends BaseEntity {

    /**
     * 提供商名称
     */
    @TableField("provider_name")
    private String providerName;

    /**
     * 提供商代码（唯一标识）
     */
    @TableField("provider_code")
    private String providerCode;

    /**
     * API基础URL
     */
    @TableField("api_base_url")
    private String apiBaseUrl;

    /**
     * API版本
     */
    @TableField("api_version")
    private String apiVersion;

    /**
     * 认证方式（TOKEN, SIGNATURE等）
     */
    @TableField("auth_type")
    private String authType;

    /**
     * 认证配置（JSON格式）
     */
    @TableField("auth_config")
    private String authConfig;

    /**
     * 超时配置（毫秒）
     */
    @TableField("timeout_ms")
    private Integer timeoutMs;

    /**
     * 重试次数
     */
    @TableField("retry_count")
    private Integer retryCount;

    /**
     * 是否启用
     */
    @TableField("enabled")
    private Boolean enabled;

    /**
     * 优先级（数值越小优先级越高）
     */
    @TableField("priority")
    private Integer priority;

    /**
     * 支持的功能（JSON数组格式）
     */
    @TableField("supported_features")
    private String supportedFeatures;

    /**
     * 费用信息（JSON格式）
     */
    @TableField("pricing_info")
    private String pricingInfo;

    /**
     * 联系信息
     */
    @TableField("contact_info")
    private String contactInfo;

    /**
     * 备注信息
     */
    @TableField("remark")
    private String remark;

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    private Long tenantId;
}