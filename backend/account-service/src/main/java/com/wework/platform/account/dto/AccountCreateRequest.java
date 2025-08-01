package com.wework.platform.account.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.io.Serializable;

/**
 * 账号创建请求DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class AccountCreateRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 租户ID
     */
    @NotBlank(message = "租户ID不能为空")
    private String tenantId;

    /**
     * 账号名称
     */
    @NotBlank(message = "账号名称不能为空")
    @Size(min = 2, max = 100, message = "账号名称长度必须在2-100字符之间")
    private String accountName;

    /**
     * 绑定手机号
     */
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    /**
     * 账号配置(JSON格式)
     */
    private String config;
}