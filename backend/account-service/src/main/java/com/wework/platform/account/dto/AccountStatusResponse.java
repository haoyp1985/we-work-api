package com.wework.platform.account.dto;

import com.wework.platform.common.enums.AccountStatus;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 账号状态响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class AccountStatusResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 企微实例GUID
     */
    private String guid;

    /**
     * 账号状态
     */
    private AccountStatus status;

    /**
     * 状态描述
     */
    private String statusDesc;

    /**
     * 最后心跳时间
     */
    private LocalDateTime lastHeartbeatTime;

    /**
     * 在线时长（秒）
     */
    private Long onlineDuration;

    /**
     * 是否健康
     */
    private Boolean healthy;

    /**
     * 状态详情
     */
    private String details;
}