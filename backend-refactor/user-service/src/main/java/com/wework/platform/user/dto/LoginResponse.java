package com.wework.platform.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户登录响应对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "用户登录响应")
public class LoginResponse {

    @Schema(description = "访问令牌")
    private String accessToken;

    @Schema(description = "刷新令牌")
    private String refreshToken;

    @Schema(description = "令牌类型")
    private String tokenType = "Bearer";

    @Schema(description = "过期时间（秒）")
    private Long expiresIn;

    @Schema(description = "用户信息")
    private UserInfo userInfo;

    @Data
    @Schema(description = "用户基本信息")
    public static class UserInfo {
        
        @Schema(description = "用户ID")
        private String id;

        @Schema(description = "用户名")
        private String username;

        @Schema(description = "昵称")
        private String nickname;

        @Schema(description = "邮箱")
        private String email;

        @Schema(description = "头像URL")
        private String avatar;

        @Schema(description = "租户ID")
        private String tenantId;

        @Schema(description = "角色列表")
        private List<String> roles;

        @Schema(description = "权限列表")
        private List<String> permissions;

        @Schema(description = "最后登录时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private LocalDateTime lastLoginTime;
    }
}