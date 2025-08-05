package com.wework.platform.account.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 账号状态变更日志DTO
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "账号状态变更日志")
public class AccountStatusLogDTO {

    @Schema(description = "日志ID")
    private String id;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "企微账号ID")
    private String accountId;

    @Schema(description = "旧状态")
    private Integer oldStatus;

    @Schema(description = "新状态")
    private Integer newStatus;

    @Schema(description = "状态变更原因")
    private String reason;

    @Schema(description = "操作类型：1-手动操作，2-系统自动，3-异常触发")
    private Integer operationType;

    @Schema(description = "操作人ID")
    private String operatorId;

    @Schema(description = "操作人名称")
    private String operatorName;

    @Schema(description = "错误信息")
    private String errorMsg;

    @Schema(description = "操作时长（毫秒）")
    private Long duration;

    @Schema(description = "客户端IP")
    private String clientIp;

    @Schema(description = "扩展信息（JSON格式）")
    private String extraInfo;

    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

    @Schema(description = "创建人ID")
    private String createdBy;

    @Schema(description = "更新人ID")
    private String updatedBy;
}