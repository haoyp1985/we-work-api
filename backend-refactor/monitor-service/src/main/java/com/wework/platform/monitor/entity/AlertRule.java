package com.wework.platform.monitor.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 告警规则实体
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("alert_rules")
public class AlertRule {

    /**
     * 主键ID
     */
    @TableId(value = "id", type = IdType.ASSIGN_UUID)
    private String id;

    /**
     * 租户ID
     */
    @TableField("tenant_id")
    private String tenantId;

    /**
     * 规则名称
     */
    @TableField("rule_name")
    private String ruleName;

    /**
     * 规则描述
     */
    @TableField("description")
    private String description;

    /**
     * 监控指标名称
     */
    @TableField("metric_name")
    private String metricName;

    /**
     * 比较操作符 (>, <, >=, <=, ==, !=)
     */
    @TableField("comparison_operator")
    private String comparisonOperator;

    /**
     * 阈值
     */
    @TableField("threshold_value")
    private BigDecimal thresholdValue;

    /**
     * 告警级别
     */
    @TableField("alert_level")
    private AlertLevel alertLevel;

    /**
     * 持续时间(分钟)
     */
    @TableField("duration_minutes")
    private Integer durationMinutes;

    /**
     * 评估间隔(分钟)
     */
    @TableField("evaluation_interval")
    private Integer evaluationInterval;

    /**
     * 通知渠道(JSON格式)
     */
    @TableField("notification_channels")
    private String notificationChannels;

    /**
     * 恢复通知
     */
    @TableField("recovery_notification")
    private Boolean recoveryNotification;

    /**
     * 规则状态
     */
    @TableField("status")
    private AlertStatus status;

    /**
     * 最后执行时间
     */
    @TableField("last_executed_at")
    private LocalDateTime lastExecutedAt;

    /**
     * 最后告警时间
     */
    @TableField("last_alerted_at")
    private LocalDateTime lastAlertedAt;

    /**
     * 创建时间
     */
    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 创建人
     */
    @TableField(value = "created_by", fill = FieldFill.INSERT)
    private String createdBy;

    /**
     * 更新人
     */
    @TableField(value = "updated_by", fill = FieldFill.INSERT_UPDATE)
    private String updatedBy;

    /**
     * 软删除标记
     */
    @TableLogic
    @TableField("deleted_at")
    private LocalDateTime deletedAt;

    /**
     * 版本号(乐观锁)
     */
    @Version
    @TableField("version")
    private Integer version;
}