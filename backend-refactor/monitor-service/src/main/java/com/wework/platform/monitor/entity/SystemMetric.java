package com.wework.platform.monitor.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 系统指标实体
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("system_metrics")
public class SystemMetric {

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
     * 指标值
     */
    @TableField("metric_value")
    private BigDecimal metricValue;

    /**
     * 指标单位
     */
    @TableField("metric_unit")
    private String metricUnit;

    /**
     * 指标标签(JSON格式)
     */
    @TableField("metric_tags")
    private String metricTags;

    /**
     * 收集时间
     */
    @TableField("collected_at")
    private LocalDateTime collectedAt;

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