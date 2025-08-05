package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.PlatformConfigDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.PlatformType;

import java.util.List;

/**
 * 外部平台配置服务接口
 */
public interface PlatformConfigService {

    /**
     * 创建平台配置
     *
     * @param tenantId       租户ID
     * @param name           配置名称
     * @param platformType   平台类型
     * @param baseUrl        基础URL
     * @param apiKey         API密钥
     * @param configJson     配置JSON
     * @return 平台配置信息
     */
    PlatformConfigDTO createPlatformConfig(String tenantId, String name, PlatformType platformType,
                                         String baseUrl, String apiKey, String configJson);

    /**
     * 更新平台配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @param updates  更新字段
     * @return 平台配置信息
     */
    PlatformConfigDTO updatePlatformConfig(String tenantId, String configId, 
                                         java.util.Map<String, Object> updates);

    /**
     * 删除平台配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     */
    void deletePlatformConfig(String tenantId, String configId);

    /**
     * 获取平台配置详情
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @return 平台配置信息
     */
    PlatformConfigDTO getPlatformConfig(String tenantId, String configId);

    /**
     * 分页查询平台配置列表
     *
     * @param tenantId     租户ID
     * @param name         配置名称(模糊匹配，可选)
     * @param platformType 平台类型(可选)
     * @param enabled      是否启用(可选)
     * @param pageNum      页码
     * @param pageSize     页大小
     * @return 分页结果
     */
    PageResult<PlatformConfigDTO> getPlatformConfigList(String tenantId, String name, 
                                                       PlatformType platformType, Boolean enabled,
                                                       Integer pageNum, Integer pageSize);

    /**
     * 获取指定类型的平台配置列表
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @return 配置列表
     */
    List<PlatformConfigDTO> getPlatformConfigsByType(String tenantId, PlatformType platformType);

    /**
     * 获取启用的平台配置列表
     *
     * @param tenantId 租户ID
     * @return 配置列表
     */
    List<PlatformConfigDTO> getEnabledPlatformConfigs(String tenantId);

    /**
     * 测试平台配置连接
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @return 测试结果
     */
    ConnectionTestResult testPlatformConnection(String tenantId, String configId);

    /**
     * 启用/禁用平台配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @param enabled  是否启用
     * @return 平台配置信息
     */
    PlatformConfigDTO togglePlatformConfig(String tenantId, String configId, Boolean enabled);

    /**
     * 复制平台配置
     *
     * @param tenantId    租户ID
     * @param sourceId    源配置ID
     * @param newName     新配置名称
     * @return 新平台配置信息
     */
    PlatformConfigDTO copyPlatformConfig(String tenantId, String sourceId, String newName);

    /**
     * 批量删除平台配置
     *
     * @param tenantId  租户ID
     * @param configIds 配置ID列表
     * @return 删除数量
     */
    Integer batchDeletePlatformConfigs(String tenantId, List<String> configIds);

    /**
     * 获取平台配置使用统计
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @return 使用统计
     */
    PlatformConfigUsageStats getPlatformConfigUsageStats(String tenantId, String configId);

    /**
     * 验证平台配置
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param baseUrl      基础URL
     * @param apiKey       API密钥
     * @param configJson   配置JSON
     * @return 验证结果
     */
    ValidationResult validatePlatformConfig(String tenantId, PlatformType platformType, 
                                           String baseUrl, String apiKey, String configJson);

    /**
     * 连接测试结果
     */
    class ConnectionTestResult {
        private boolean success;
        private String message;
        private long responseTime;
        private java.util.Map<String, Object> details;

        // Getter和Setter方法
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public long getResponseTime() { return responseTime; }
        public void setResponseTime(long responseTime) { this.responseTime = responseTime; }
        
        public java.util.Map<String, Object> getDetails() { return details; }
        public void setDetails(java.util.Map<String, Object> details) { this.details = details; }
    }

    /**
     * 平台配置使用统计
     */
    class PlatformConfigUsageStats {
        private Long totalCalls;
        private Long successCalls;
        private Long failedCalls;
        private Double successRate;
        private Double avgResponseTime;
        private Long totalTokens;
        private java.math.BigDecimal totalCost;
        private java.time.LocalDateTime lastUsedAt;
        private java.util.Map<String, Long> callsByDate;

        // Getter和Setter方法
        public Long getTotalCalls() { return totalCalls; }
        public void setTotalCalls(Long totalCalls) { this.totalCalls = totalCalls; }
        
        public Long getSuccessCalls() { return successCalls; }
        public void setSuccessCalls(Long successCalls) { this.successCalls = successCalls; }
        
        public Long getFailedCalls() { return failedCalls; }
        public void setFailedCalls(Long failedCalls) { this.failedCalls = failedCalls; }
        
        public Double getSuccessRate() { return successRate; }
        public void setSuccessRate(Double successRate) { this.successRate = successRate; }
        
        public Double getAvgResponseTime() { return avgResponseTime; }
        public void setAvgResponseTime(Double avgResponseTime) { this.avgResponseTime = avgResponseTime; }
        
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
        
        public java.math.BigDecimal getTotalCost() { return totalCost; }
        public void setTotalCost(java.math.BigDecimal totalCost) { this.totalCost = totalCost; }
        
        public java.time.LocalDateTime getLastUsedAt() { return lastUsedAt; }
        public void setLastUsedAt(java.time.LocalDateTime lastUsedAt) { this.lastUsedAt = lastUsedAt; }
        
        public java.util.Map<String, Long> getCallsByDate() { return callsByDate; }
        public void setCallsByDate(java.util.Map<String, Long> callsByDate) { this.callsByDate = callsByDate; }
    }

    /**
     * 验证结果
     */
    class ValidationResult {
        private boolean valid;
        private String message;
        private java.util.List<String> errors;

        // Getter和Setter方法
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public java.util.List<String> getErrors() { return errors; }
        public void setErrors(java.util.List<String> errors) { this.errors = errors; }
    }
}