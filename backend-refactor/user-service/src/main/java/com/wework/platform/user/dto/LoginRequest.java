package com.wework.platform.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 用户登录请求对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "用户登录请求")
public class LoginRequest {

    @Schema(description = "用户名或邮箱", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "用户名或邮箱不能为空")
    @Size(max = 100, message = "用户名或邮箱长度不能超过100个字符")
    private String username;

    @Schema(description = "密码", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度必须在6-20个字符之间")
    private String password;
}