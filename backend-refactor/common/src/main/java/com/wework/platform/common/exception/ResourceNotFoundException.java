package com.wework.platform.common.exception;

import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;

/**
 * 资源未找到异常
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
public class ResourceNotFoundException extends BusinessException {

    public ResourceNotFoundException(String message) {
        super(ResultCode.NOT_FOUND.getCode(), message);
    }

    public ResourceNotFoundException(String resourceType, String resourceId) {
        super(ResultCode.NOT_FOUND.getCode(), String.format("%s not found: %s", resourceType, resourceId));
    }

    public ResourceNotFoundException(String resourceType, String field, Object value) {
        super(ResultCode.NOT_FOUND.getCode(), String.format("%s not found with %s: %s", resourceType, field, value));
    }
}