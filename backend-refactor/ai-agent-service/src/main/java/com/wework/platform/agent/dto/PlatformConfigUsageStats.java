package com.wework.platform.agent.dto;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * 平台配置使用统计DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformConfigUsageStats {
    
    /**
     * 总调用次数
     */
    private Long totalCalls;
    
    /**
     * 成功调用次数
     */
    private Long successfulCalls;
    
    /**
     * 失败调用次数
     */
    private Long failedCalls;
    
    /**
     * 平均响应时间(毫秒)
     */
    private Double averageResponseTime;
    
    /**
     * 最后调用时间
     */
    private LocalDateTime lastCallTime;
    
    /**
     * 今日调用次数
     */
    private Long todayCalls;
    
    /**
     * 本月调用次数
     */
    private Long monthCalls;
    
    /**
     * 错误率
     */
    private Double errorRate;
    
    /**
     * 配置状态
     */
    private String status;
}