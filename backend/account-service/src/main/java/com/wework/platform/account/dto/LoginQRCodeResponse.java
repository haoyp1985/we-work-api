package com.wework.platform.account.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 登录二维码响应DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class LoginQRCodeResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 账号ID
     */
    private String accountId;

    /**
     * 企微实例GUID
     */
    private String guid;

    /**
     * 二维码内容
     */
    private String qrcodeContent;

    /**
     * 二维码Key
     */
    private String qrcodeKey;

    /**
     * 登录令牌
     */
    private String loginToken;

    /**
     * 二维码过期时间（秒）
     */
    private Integer expiresIn = 300;
}