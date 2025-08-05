package com.wework.platform.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;

/**
 * 更新用户请求对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "更新用户请求")
public class UpdateUserRequest {

    @Schema(description = "昵称")
    @Size(max = 50, message = "昵称长度不能超过50个字符")
    private String nickname;

    @Schema(description = "邮箱")
    @Email(message = "邮箱格式不正确")
    @Size(max = 100, message = "邮箱长度不能超过100个字符")
    private String email;

    @Schema(description = "手机号")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    @Schema(description = "头像URL")
    @Size(max = 255, message = "头像URL长度不能超过255个字符")
    private String avatar;

    @Schema(description = "状态：1-启用，0-禁用")
    private Integer status;

    @Schema(description = "角色ID列表")
    private List<String> roleIds;
}