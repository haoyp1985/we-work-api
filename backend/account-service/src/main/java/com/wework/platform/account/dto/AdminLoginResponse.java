package com.wework.platform.account.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员登录响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class AdminLoginResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 访问令牌
     */
    private String token;

    /**
     * 刷新令牌
     */
    private String refreshToken;

    /**
     * 用户信息
     */
    private UserInfo user;

    /**
     * 过期时间（秒）
     */
    private Integer expiresIn;
}