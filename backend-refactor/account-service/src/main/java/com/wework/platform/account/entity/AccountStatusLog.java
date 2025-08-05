package com.wework.platform.account.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 账号状态变更日志实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("account_status_logs")
public class AccountStatusLog extends BaseEntity {

    /**
     * 企微账号ID
     */
    private String accountId;

    /**
     * 旧状态
     */
    private Integer oldStatus;

    /**
     * 新状态
     */
    private Integer newStatus;

    /**
     * 状态变更原因
     */
    private String reason;

    /**
     * 操作类型：1-手动操作，2-系统自动，3-异常触发
     */
    private Integer operationType;

    /**
     * 操作人ID
     */
    private String operatorId;

    /**
     * 操作人名称
     */
    private String operatorName;

    /**
     * 错误信息
     */
    private String errorMsg;

    /**
     * 操作时长（毫秒）
     */
    private Long duration;

    /**
     * 客户端IP
     */
    private String clientIp;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 扩展信息（JSON格式）
     */
    private String extraInfo;
}