package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.wework.platform.common.enums.AccountStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 企微账号实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wework_accounts")
public class WeWorkAccount extends BaseEntity {

    /**
     * 租户ID (多租户必填字段)
     */
    private String tenantId;

    /**
     * 账号名称
     */
    private String accountName;

    /**
     * 企微实例GUID
     */
    private String weWorkGuid;

    /**
     * 代理ID
     */
    private String proxyId;

    /**
     * 绑定手机号
     */
    private String phone;

    /**
     * 回调地址
     */
    private String callbackUrl;

    /**
     * 状态
     */
    private AccountStatus status;

    /**
     * 健康度评分 (0-100)
     */
    private Integer healthScore;

    /**
     * 最后登录时间
     */
    private LocalDateTime lastLoginTime;

    /**
     * 最后心跳时间
     */
    private LocalDateTime lastHeartbeatTime;

    /**
     * 是否自动重连
     */
    private Boolean autoReconnect;

    /**
     * 监控间隔(秒)
     */
    private Integer monitorInterval;

    /**
     * 最大重试次数
     */
    private Integer maxRetryCount;

    /**
     * 当前重试次数
     */
    private Integer retryCount;

    /**
     * 账号配置(JSON格式)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object configJson;

    /**
     * 租户标签(用于分组管理)
     */
    private String tenantTag;

    /**
     * 自动恢复尝试次数
     */
    private Integer autoRecoveryAttempts;

    /**
     * 最后自动恢复时间
     */
    private LocalDateTime lastAutoRecoveryTime;

    /**
     * 增加重试次数
     */
    public void incrementRetryCount() {
        this.retryCount = (this.retryCount == null ? 0 : this.retryCount) + 1;
    }

    /**
     * 重置重试次数
     */
    public void resetRetryCount() {
        this.retryCount = 0;
    }

    /**
     * 检查是否可以开始登录
     */
    public boolean canStartLogin() {
        return this.status == AccountStatus.CREATED || 
               this.status == AccountStatus.OFFLINE || 
               this.status == AccountStatus.ERROR;
    }

    /**
     * 检查是否在线
     */
    public boolean isOnline() {
        return this.status == AccountStatus.ONLINE;
    }

    /**
     * 获取显示名称
     */
    public String getDisplayName() {
        return this.accountName + (this.phone != null ? " (" + this.phone + ")" : "");
    }

    /**
     * 增加自动恢复尝试次数
     */
    public void incrementAutoRecoveryAttempts() {
        this.autoRecoveryAttempts = (this.autoRecoveryAttempts == null ? 0 : this.autoRecoveryAttempts) + 1;
    }

    /**
     * 重置自动恢复尝试次数
     */
    public void resetAutoRecoveryAttempts() {
        this.autoRecoveryAttempts = 0;
    }

    /**
     * 获取企微GUID（兼容旧方法名）
     */
    public String getGuid() {
        return this.weWorkGuid;
    }

    /**
     * 设置企微GUID（兼容旧方法名）
     */
    public void setGuid(String guid) {
        this.weWorkGuid = guid;
    }

    /**
     * 获取配置JSON字符串
     */
    public String getConfig() {
        return this.configJson != null ? this.configJson.toString() : null;
    }

    /**
     * 设置配置JSON字符串
     */
    public void setConfig(String config) {
        this.configJson = config;
    }
}