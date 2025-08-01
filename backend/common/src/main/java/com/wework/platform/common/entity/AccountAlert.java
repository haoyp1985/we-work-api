package com.wework.platform.common.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.enums.AlertType;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 账号告警实体
 * 
 * @author WeWork Platform Team
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("account_alerts")
public class AccountAlert extends BaseEntity {

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 租户ID (用于多租户隔离)
     */
    private String tenantId;

    /**
     * 监控规则ID
     */
    private String ruleId;

    /**
     * 告警类型
     */
    private AlertType alertType;

    /**
     * 告警级别
     */
    private AlertLevel alertLevel;

    /**
     * 告警消息
     */
    private String alertMessage;

    /**
     * 告警详细数据(JSON格式)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object alertData;

    /**
     * 告警状态
     */
    private AlertStatus status;

    /**
     * 首次发生时间
     */
    private LocalDateTime firstOccurredAt;

    /**
     * 最后发生时间
     */
    private LocalDateTime lastOccurredAt;

    /**
     * 发生次数
     */
    private Integer occurrenceCount;

    /**
     * 确认人ID
     */
    private String acknowledgedBy;

    /**
     * 确认时间
     */
    private LocalDateTime acknowledgedAt;

    /**
     * 解决人ID
     */
    private String resolvedBy;

    /**
     * 解决时间
     */
    private LocalDateTime resolvedAt;

    /**
     * 解决方案
     */
    private String resolution;

    /**
     * 自动恢复尝试次数
     */
    private Integer autoRecoveryAttempts;

    /**
     * 通知状态(JSON格式记录各种通知渠道的发送状态)
     */
    @TableField(typeHandler = com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler.class)
    private Object notificationStatus;

    /**
     * 增加发生次数
     */
    public void incrementOccurrenceCount() {
        this.occurrenceCount = (this.occurrenceCount == null ? 0 : this.occurrenceCount) + 1;
        this.lastOccurredAt = LocalDateTime.now();
        if (this.firstOccurredAt == null) {
            this.firstOccurredAt = LocalDateTime.now();
        }
    }

    /**
     * 确认告警
     */
    public void acknowledge(String userId, String username) {
        this.status = AlertStatus.ACKNOWLEDGED;
        this.acknowledgedBy = userId;
        this.acknowledgedAt = LocalDateTime.now();
    }

    /**
     * 解决告警
     */
    public void resolve(String userId, String resolution) {
        this.status = AlertStatus.RESOLVED;
        this.resolvedBy = userId;
        this.resolvedAt = LocalDateTime.now();
        this.resolution = resolution;
    }

    /**
     * 检查是否为严重告警
     */
    public boolean isCritical() {
        return this.alertLevel == AlertLevel.CRITICAL || this.alertLevel == AlertLevel.ERROR;
    }

    /**
     * 获取持续时间(分钟)
     */
    public long getDurationMinutes() {
        if (firstOccurredAt == null) return 0;
        LocalDateTime endTime = resolvedAt != null ? resolvedAt : LocalDateTime.now();
        return java.time.Duration.between(firstOccurredAt, endTime).toMinutes();
    }

    /**
     * 检查是否需要升级告警
     */
    public boolean needsEscalation(int maxDurationMinutes) {
        return status == AlertStatus.ACTIVE && 
               getDurationMinutes() > maxDurationMinutes &&
               isCritical();
    }
}