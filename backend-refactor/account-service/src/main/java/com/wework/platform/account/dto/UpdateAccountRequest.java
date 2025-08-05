package com.wework.platform.account.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.Size;

/**
 * 更新企微账号请求对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "更新企微账号请求")
public class UpdateAccountRequest {

    @Schema(description = "企业名称")
    @Size(max = 100, message = "企业名称长度不能超过100个字符")
    private String corpName;

    @Schema(description = "应用密钥")
    @Size(max = 200, message = "应用密钥长度不能超过200个字符")
    private String secret;

    @Schema(description = "通讯录同步密钥")
    @Size(max = 200, message = "通讯录同步密钥长度不能超过200个字符")
    private String contactSyncSecret;

    @Schema(description = "消息加密密钥")
    @Size(max = 200, message = "消息加密密钥长度不能超过200个字符")
    private String messageEncryptKey;

    @Schema(description = "是否启用自动重连")
    private Boolean autoReconnect;

    @Schema(description = "备注信息")
    @Size(max = 500, message = "备注信息长度不能超过500个字符")
    private String remark;
}