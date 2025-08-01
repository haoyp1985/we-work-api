package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.enums.TenantStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 租户实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("tenants")
public class Tenant extends BaseEntity {

    /**
     * 租户名称
     */
    private String tenantName;

    /**
     * 租户编码
     */
    private String tenantCode;

    /**
     * 最大账号数
     */
    private Integer maxAccounts;

    /**
     * 日最大消息数
     */
    private Integer maxDailyMessages;

    /**
     * 回调地址
     */
    private String webhookUrl;

    /**
     * 租户配置(JSON格式)
     */
    private String config;

    /**
     * 状态
     */
    private TenantStatus status;
}