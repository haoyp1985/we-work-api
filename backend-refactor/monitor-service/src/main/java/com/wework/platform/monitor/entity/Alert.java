package com.wework.platform.monitor.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 告警记录实体
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("alerts")
public class Alert {

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
     * 告警规则ID
     */
    @TableField("rule_id")
    private String ruleId;

    /**
     * 告警标题
     */
    @TableField("title")
    private String title;

    /**
     * 告警描述
     */
    @TableField("description")
    private String description;

    /**
     * 告警级别
     */
    @TableField("alert_level")
    private AlertLevel alertLevel;

    /**
     * 告警状态
     */
    @TableField("status")
    private AlertStatus status;

    /**
     * 服务名称
     */
    @TableField("service_name")
    private String serviceName;

    /**
     * 指标名称
     */
    @TableField("metric_name")
    private String metricName;

    /**
     * 当前值
     */
    @TableField("current_value")
    private BigDecimal currentValue;

    /**
     * 阈值
     */
    @TableField("threshold_value")
    private BigDecimal thresholdValue;

    /**
     * 告警标签(JSON格式)
     */
    @TableField("alert_tags")
    private String alertTags;

    /**
     * 告警开始时间
     */
    @TableField("started_at")
    private LocalDateTime startedAt;

    /**
     * 告警结束时间
     */
    @TableField("ended_at")
    private LocalDateTime endedAt;

    /**
     * 确认时间
     */
    @TableField("acknowledged_at")
    private LocalDateTime acknowledgedAt;

    /**
     * 确认人
     */
    @TableField("acknowledged_by")
    private String acknowledgedBy;

    /**
     * 通知状态
     */
    @TableField("notification_sent")
    private Boolean notificationSent;

    /**
     * 通知时间
     */
    @TableField("notified_at")
    private LocalDateTime notifiedAt;

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