package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
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
     * 租户ID
     */
    private String tenantId;

    /**
     * 账号名称
     */
    private String accountName;

    /**
     * 企微实例GUID
     */
    private String guid;

    /**
     * 绑定手机号
     */
    private String phone;

    /**
     * 状态
     */
    private AccountStatus status;

    /**
     * 账号配置(JSON格式)
     */
    private String config;

    /**
     * 最后登录时间
     */
    private LocalDateTime lastLoginTime;

    /**
     * 最后心跳时间
     */
    private LocalDateTime lastHeartbeatTime;
}