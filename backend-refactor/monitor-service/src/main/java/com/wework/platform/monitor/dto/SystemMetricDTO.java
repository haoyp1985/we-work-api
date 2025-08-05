package com.wework.platform.monitor.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 系统指标DTO
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "系统指标信息")
public class SystemMetricDTO {

    @Schema(description = "指标ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "服务名称")
    private String serviceName;

    @Schema(description = "指标名称")
    private String metricName;

    @Schema(description = "指标值")
    private BigDecimal metricValue;

    @Schema(description = "指标单位")
    private String metricUnit;

    @Schema(description = "指标标签")
    private String metricTags;

    @Schema(description = "收集时间")
    private LocalDateTime collectedAt;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;
}