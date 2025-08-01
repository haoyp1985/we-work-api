package com.wework.platform.account.dto;

import com.wework.platform.common.enums.AccountStatus;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 账号响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class AccountResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 账号ID
     */
    private String id;

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
     * 状态描述
     */
    private String statusDesc;

    /**
     * 账号配置
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

    /**
     * 在线时长（秒）
     */
    private Long onlineDuration;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;
}