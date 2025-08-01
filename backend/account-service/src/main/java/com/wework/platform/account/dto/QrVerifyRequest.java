package com.wework.platform.account.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 二维码验证请求DTO
 *
 * @author WeWork Platform Team
 */
@Data
public class QrVerifyRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 二维码Key
     */
    @NotBlank(message = "二维码Key不能为空")
    private String key;
}