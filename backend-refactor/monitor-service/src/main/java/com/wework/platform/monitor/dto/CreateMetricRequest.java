package com.wework.platform.monitor.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 创建系统指标请求
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "创建系统指标请求")
public class CreateMetricRequest {

    @Schema(description = "服务名称", required = true)
    @NotBlank(message = "服务名称不能为空")
    private String serviceName;

    @Schema(description = "指标名称", required = true)
    @NotBlank(message = "指标名称不能为空")
    private String metricName;

    @Schema(description = "指标值", required = true)
    @NotNull(message = "指标值不能为空")
    private BigDecimal metricValue;

    @Schema(description = "指标单位")
    private String metricUnit;

    @Schema(description = "指标标签(JSON格式)")
    private String metricTags;

    @Schema(description = "收集时间")
    private LocalDateTime collectedAt;
}