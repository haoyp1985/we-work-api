package com.wework.platform.common.exception;

import com.wework.platform.common.dto.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 全局异常处理器
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常处理
     */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException e) {
        String requestId = generateRequestId();
        log.warn("Business exception [{}]: {}", requestId, e.getMessage(), e);
        
        ApiResponse<Void> response = ApiResponse.error(e.getCode(), e.getMessage())
                .requestId(requestId);
        
        return ResponseEntity.status(getHttpStatus(e.getCode())).body(response);
    }

    /**
     * 参数校验异常处理
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidationException(MethodArgumentNotValidException e) {
        String requestId = generateRequestId();
        log.warn("Validation exception [{}]: {}", requestId, e.getMessage());
        
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        
        ApiResponse<Void> response = ApiResponse.badRequest("参数校验失败: " + message)
                .requestId(requestId);
        
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 绑定异常处理
     */
    @ExceptionHandler(BindException.class)
    public ResponseEntity<ApiResponse<Void>> handleBindException(BindException e) {
        String requestId = generateRequestId();
        log.warn("Bind exception [{}]: {}", requestId, e.getMessage());
        
        String message = e.getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        
        ApiResponse<Void> response = ApiResponse.badRequest("参数绑定失败: " + message)
                .requestId(requestId);
        
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 约束违反异常处理
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleConstraintViolationException(ConstraintViolationException e) {
        String requestId = generateRequestId();
        log.warn("Constraint violation exception [{}]: {}", requestId, e.getMessage());
        
        String message = e.getConstraintViolations().stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.joining(", "));
        
        ApiResponse<Void> response = ApiResponse.badRequest("约束违反: " + message)
                .requestId(requestId);
        
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 非法参数异常处理
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalArgumentException(IllegalArgumentException e) {
        String requestId = generateRequestId();
        log.warn("Illegal argument exception [{}]: {}", requestId, e.getMessage(), e);
        
        ApiResponse<Void> response = ApiResponse.badRequest(e.getMessage())
                .requestId(requestId);
        
        return ResponseEntity.badRequest().body(response);
    }

    /**
     * 通用异常处理
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleException(Exception e) {
        String requestId = generateRequestId();
        log.error("Unexpected exception [{}]: {}", requestId, e.getMessage(), e);
        
        ApiResponse<Void> response = ApiResponse.error("系统内部错误，请稍后重试")
                .requestId(requestId);
        
        return ResponseEntity.internalServerError().body(response);
    }

    /**
     * 生成请求ID
     */
    private String generateRequestId() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                String requestId = request.getHeader("X-Request-ID");
                if (requestId != null && !requestId.isEmpty()) {
                    return requestId;
                }
            }
        } catch (Exception ignored) {
            // 忽略异常
        }
        return UUID.randomUUID().toString();
    }

    /**
     * 根据错误码获取HTTP状态码
     */
    private HttpStatus getHttpStatus(Integer code) {
        return switch (code) {
            case 400 -> HttpStatus.BAD_REQUEST;
            case 401 -> HttpStatus.UNAUTHORIZED;
            case 403 -> HttpStatus.FORBIDDEN;
            case 404 -> HttpStatus.NOT_FOUND;
            case 503 -> HttpStatus.SERVICE_UNAVAILABLE;
            default -> HttpStatus.INTERNAL_SERVER_ERROR;
        };
    }
}