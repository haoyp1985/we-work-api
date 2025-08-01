package com.wework.platform.account.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 刷新令牌响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class RefreshTokenResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 新的访问令牌
     */
    private String token;

    /**
     * 新的刷新令牌
     */
    private String refreshToken;
}