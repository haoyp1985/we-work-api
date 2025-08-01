package com.wework.platform.account.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 账号登录请求DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class AccountLoginRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 账号ID
     */
    @NotBlank(message = "账号ID不能为空")
    private String accountId;

    /**
     * 客户端类型（默认261）
     */
    private Integer clientType = 261;

    /**
     * 代理配置
     */
    private String proxy;

    /**
     * 桥接配置
     */
    private String bridge;

    /**
     * 是否自动启动
     */
    private Boolean autoStart = true;
}