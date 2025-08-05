package com.wework.platform.account.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 企微账号信息传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "企微账号信息")
public class WeWorkAccountDTO {

    @Schema(description = "账号ID")
    private String id;

    @Schema(description = "企业ID")
    private String corpId;

    @Schema(description = "企业名称")
    private String corpName;

    @Schema(description = "应用ID")
    private String agentId;

    @Schema(description = "账号状态")
    private Integer status;

    @Schema(description = "状态描述")
    private String statusDesc;

    @Schema(description = "租户ID")
    private String tenantId;

    @Schema(description = "二维码URL")
    private String qrCodeUrl;

    @Schema(description = "设备信息")
    private String deviceInfo;

    @Schema(description = "最后登录时间")
    private String lastLoginTime;

    @Schema(description = "最后心跳时间")
    private String lastHeartbeatTime;

    @Schema(description = "错误信息")
    private String errorMsg;

    @Schema(description = "重试次数")
    private Integer retryCount;

    @Schema(description = "是否启用自动重连")
    private Boolean autoReconnect;

    @Schema(description = "备注信息")
    private String remark;

    @Schema(description = "联系人统计")
    private ContactStats contactStats;

    @Schema(description = "创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    @Schema(description = "创建人")
    private String createdBy;

    @Data
    @Schema(description = "联系人统计信息")
    public static class ContactStats {
        @Schema(description = "总联系人数")
        private Integer total;

        @Schema(description = "内部员工数")
        private Integer internal;

        @Schema(description = "外部联系人数")
        private Integer external;

        @Schema(description = "群聊数")
        private Integer groups;
    }
}