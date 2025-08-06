package com.wework.platform.agent.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 验证结果DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValidationResult {
    
    /**
     * 验证是否成功
     */
    private Boolean valid;
    
    /**
     * 错误消息
     */
    private String errorMessage;
    
    /**
     * 错误代码
     */
    private String errorCode;
    
    /**
     * 详细信息
     */
    private String details;
    
    /**
     * 创建成功结果
     */
    public static ValidationResult success() {
        ValidationResult result = new ValidationResult();
        result.setValid(true);
        return result;
    }
    
    /**
     * 创建失败结果
     */
    public static ValidationResult failure(String errorMessage) {
        ValidationResult result = new ValidationResult();
        result.setValid(false);
        result.setErrorMessage(errorMessage);
        return result;
    }
}