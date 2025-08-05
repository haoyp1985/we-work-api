package com.wework.platform.account.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 创建企微账号请求对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "创建企微账号请求")
public class CreateAccountRequest {

    @Schema(description = "企业ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "企业ID不能为空")
    @Size(max = 50, message = "企业ID长度不能超过50个字符")
    private String corpId;

    @Schema(description = "企业名称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "企业名称不能为空")
    @Size(max = 100, message = "企业名称长度不能超过100个字符")
    private String corpName;

    @Schema(description = "应用ID", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "应用ID不能为空")
    @Size(max = 50, message = "应用ID长度不能超过50个字符")
    private String agentId;

    @Schema(description = "应用密钥", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "应用密钥不能为空")
    @Size(max = 200, message = "应用密钥长度不能超过200个字符")
    private String secret;

    @Schema(description = "通讯录同步密钥")
    @Size(max = 200, message = "通讯录同步密钥长度不能超过200个字符")
    private String contactSyncSecret;

    @Schema(description = "消息加密密钥")
    @Size(max = 200, message = "消息加密密钥长度不能超过200个字符")
    private String messageEncryptKey;

    @Schema(description = "是否启用自动重连")
    private Boolean autoReconnect = true;

    @Schema(description = "备注信息")
    @Size(max = 500, message = "备注信息长度不能超过500个字符")
    private String remark;
}