package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.wework.platform.common.enums.AccountStatus;
import com.wework.platform.common.enums.TriggerType;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 账号状态历史实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("account_status_history")
public class AccountStatusHistory extends BaseEntity {

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 租户ID (用于多租户隔离)
     */
    private String tenantId;

    /**
     * 旧状态
     */
    private AccountStatus oldStatus;

    /**
     * 新状态
     */
    private AccountStatus newStatus;

    /**
     * 变更原因
     */
    private String changeReason;

    /**
     * 触发类型
     */
    private TriggerType triggerType;

    /**
     * 额外数据(JSON格式)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object extraData;

    /**
     * 操作用户ID
     */
    private String operatorId;

    /**
     * 操作用户名
     */
    private String operatorName;

    /**
     * IP地址
     */
    private String ipAddress;

    /**
     * 用户代理
     */
    private String userAgent;

    /**
     * 获取状态变更描述
     */
    public String getStatusChangeDescription() {
        return String.format("%s → %s", 
            oldStatus != null ? oldStatus.getDescription() : "未知",
            newStatus != null ? newStatus.getDescription() : "未知");
    }

    /**
     * 检查是否为状态降级
     */
    public boolean isStatusDowngrade() {
        if (oldStatus == null || newStatus == null) return false;
        return oldStatus.getPriority() > newStatus.getPriority();
    }

    /**
     * 检查是否为异常状态变更
     */
    public boolean isErrorStatusChange() {
        return newStatus == AccountStatus.ERROR || newStatus == AccountStatus.OFFLINE;
    }
}