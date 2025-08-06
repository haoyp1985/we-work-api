package com.wework.platform.agent.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * 连接测试结果DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConnectionTestResult {
    
    /**
     * 测试是否成功
     */
    private Boolean success;
    
    /**
     * 响应时间(毫秒)
     */
    private Long responseTime;
    
    /**
     * 错误消息
     */
    private String errorMessage;
    
    /**
     * 状态码
     */
    private Integer statusCode;
    
    /**
     * 测试时间
     */
    private LocalDateTime testTime;
    
    /**
     * 详细信息
     */
    private String details;
    
    /**
     * 创建成功结果
     */
    public static ConnectionTestResult success(Long responseTime) {
        return ConnectionTestResult.builder()
            .success(true)
            .responseTime(responseTime)
            .testTime(LocalDateTime.now())
            .build();
    }
    
    /**
     * 创建失败结果
     */
    public static ConnectionTestResult failure(String errorMessage) {
        return ConnectionTestResult.builder()
            .success(false)
            .errorMessage(errorMessage)
            .testTime(LocalDateTime.now())
            .build();
    }
}