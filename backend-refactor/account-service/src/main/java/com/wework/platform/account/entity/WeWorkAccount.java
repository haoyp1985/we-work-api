package com.wework.platform.account.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 企微账号实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wework_accounts")
public class WeWorkAccount extends BaseEntity {

    /**
     * 企业ID
     */
    private String corpId;

    /**
     * 企业名称
     */
    private String corpName;

    /**
     * 应用ID
     */
    private String agentId;

    /**
     * 应用密钥
     */
    private String secret;

    /**
     * 访问令牌
     */
    private String accessToken;

    /**
     * 访问令牌过期时间
     */
    private String accessTokenExpireTime;

    /**
     * 刷新令牌
     */
    private String refreshToken;

    /**
     * 账号状态：1-在线，2-离线，3-异常，4-初始化中，5-等待扫码，6-等待确认，7-验证中，8-恢复中，0-禁用
     */
    private Integer status;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 通讯录同步密钥
     */
    private String contactSyncSecret;

    /**
     * 消息加密密钥
     */
    private String messageEncryptKey;

    /**
     * 二维码URL
     */
    private String qrCodeUrl;

    /**
     * 登录设备信息
     */
    private String deviceInfo;

    /**
     * 最后登录时间
     */
    private String lastLoginTime;

    /**
     * 最后心跳时间
     */
    private String lastHeartbeatTime;

    /**
     * 配置信息（JSON格式）
     */
    private String configJson;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 重试次数
     */
    private Integer retryCount;

    /**
     * 是否启用自动重连
     */
    private Boolean autoReconnect;

    /**
     * 备注信息
     */
    private String remark;
}