package com.wework.platform.common.core.exception;

import com.wework.platform.common.enums.ResultCode;
import lombok.Getter;

/**
 * 业务异常
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Getter
public class BusinessException extends RuntimeException {

    private final Integer code;
    private final String message;
    private final Object[] args;

    public BusinessException(ResultCode resultCode) {
        super(resultCode.getMessage());
        this.code = resultCode.getCode();
        this.message = resultCode.getMessage();
        this.args = null;
    }

    public BusinessException(ResultCode resultCode, String message) {
        super(message);
        this.code = resultCode.getCode();
        this.message = message;
        this.args = null;
    }

    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
        this.message = message;
        this.args = null;
    }

    public BusinessException(ResultCode resultCode, Object... args) {
        super(formatMessage(resultCode.getMessage(), args));
        this.code = resultCode.getCode();
        this.message = formatMessage(resultCode.getMessage(), args);
        this.args = args;
    }

    private static String formatMessage(String template, Object... args) {
        if (args == null || args.length == 0) {
            return template;
        }
        String result = template;
        for (int i = 0; i < args.length; i++) {
            result = result.replace("{" + i + "}", String.valueOf(args[i]));
        }
        return result;
    }
}