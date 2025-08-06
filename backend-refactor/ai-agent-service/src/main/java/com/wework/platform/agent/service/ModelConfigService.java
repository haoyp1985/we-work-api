package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.ModelConfigDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.PlatformType;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 模型配置服务接口
 */
public interface ModelConfigService {

    /**
     * 创建模型配置
     *
     * @param tenantId          租户ID
     * @param platformConfigId  平台配置ID
     * @param modelName         模型名称
     * @param displayName       显示名称
     * @param parameters        配置参数
     * @return 模型配置信息
     */
    ModelConfigDTO createModelConfig(String tenantId, String platformConfigId, String modelName,
                                   String displayName, Map<String, Object> parameters);

    /**
     * 更新模型配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @param updates  更新字段
     * @return 模型配置信息
     */
    ModelConfigDTO updateModelConfig(String tenantId, String configId, Map<String, Object> updates);

    /**
     * 删除模型配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     */
    void deleteModelConfig(String tenantId, String configId);

    /**
     * 获取模型配置详情
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @return 模型配置信息
     */
    ModelConfigDTO getModelConfig(String tenantId, String configId);

    /**
     * 分页查询模型配置列表
     *
     * @param tenantId     租户ID
     * @param name         配置名称(模糊匹配，可选)
     * @param platformType 平台类型(可选)
     * @param modelName    模型名称(可选)
     * @param enabled      是否启用(可选)
     * @param pageNum      页码
     * @param pageSize     页大小
     * @return 分页结果
     */
    PageResult<ModelConfigDTO> getModelConfigList(String tenantId, String name, 
                                                 PlatformType platformType, String modelName, Boolean enabled,
                                                 Integer pageNum, Integer pageSize);

    /**
     * 获取指定平台类型的模型配置列表
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @return 配置列表
     */
    List<ModelConfigDTO> getModelConfigsByPlatform(String tenantId, PlatformType platformType);

    /**
     * 获取启用的模型配置列表
     *
     * @param tenantId 租户ID
     * @return 配置列表
     */
    List<ModelConfigDTO> getEnabledModelConfigs(String tenantId);

    /**
     * 测试模型配置
     *
     * @param tenantId  租户ID
     * @param configId  配置ID
     * @param testInput 测试输入
     * @return 测试结果
     */
    ModelTestResult testModelConfig(String tenantId, String configId, String testInput);

    /**
     * 启用/禁用模型配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @param enabled  是否启用
     * @return 模型配置信息
     */
    ModelConfigDTO toggleModelConfig(String tenantId, String configId, Boolean enabled);

    /**
     * 复制模型配置
     *
     * @param tenantId  租户ID
     * @param sourceId  源配置ID
     * @param newName   新配置名称
     * @return 新模型配置信息
     */
    ModelConfigDTO copyModelConfig(String tenantId, String sourceId, String newName);

    /**
     * 批量删除模型配置
     *
     * @param tenantId  租户ID
     * @param configIds 配置ID列表
     * @return 删除数量
     */
    Integer batchDeleteModelConfigs(String tenantId, List<String> configIds);

    /**
     * 获取租户所有模型配置
     *
     * @param tenantId 租户ID
     * @return 配置列表
     */
    List<ModelConfigDTO> getTenantModelConfigs(String tenantId);

    /**
     * 按平台类型获取模型配置
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @return 配置列表
     */
    List<ModelConfigDTO> getModelConfigsByType(String tenantId, PlatformType platformType);

    /**
     * 启用模型配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     */
    void enableModelConfig(String tenantId, String configId);

    /**
     * 禁用模型配置
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     */
    void disableModelConfig(String tenantId, String configId);

    /**
     * 获取默认模型配置
     *
     * @param tenantId  租户ID
     * @param modelName 模型名称
     * @return 默认配置
     */
    ModelConfigDTO getDefaultModelConfig(String tenantId, String modelName);

    /**
     * 根据名称查找模型配置
     *
     * @param tenantId     租户ID
     * @param platformType 平台类型
     * @param modelName    模型名称
     * @return 配置信息
     */
    ModelConfigDTO findModelConfigByName(String tenantId, String platformType, String modelName);

    /**
     * 批量创建模型配置
     *
     * @param tenantId          租户ID
     * @param platformConfigId  平台配置ID
     * @param configList        配置列表
     */
    void batchCreateModelConfigs(String tenantId, String platformConfigId, List<Map<String, Object>> configList);

    /**
     * 统计模型配置数量
     *
     * @param tenantId 租户ID
     * @return 配置数量
     */
    long countModelConfigs(String tenantId);

    /**
     * 统计启用的模型配置数量
     *
     * @param tenantId 租户ID
     * @return 启用配置数量
     */
    long countEnabledModelConfigs(String tenantId);

    /**
     * 统计平台模型配置数量
     *
     * @param tenantId          租户ID
     * @param platformConfigId  平台配置ID
     * @return 配置数量
     */
    long countPlatformModelConfigs(String tenantId, String platformConfigId);

    /**
     * 检查是否存在指定模型配置
     *
     * @param tenantId          租户ID
     * @param platformConfigId  平台配置ID
     * @return 是否存在
     */
    boolean hasModelConfig(String tenantId, String platformConfigId);

    /**
     * 获取模型配置使用统计
     *
     * @param tenantId 租户ID
     * @param configId 配置ID
     * @return 使用统计
     */
    ModelConfigUsageStats getModelConfigUsageStats(String tenantId, String configId);

    /**
     * 估算Token消耗
     *
     * @param configId 配置ID
     * @param text     文本内容
     * @return Token数量
     */
    Integer estimateTokens(String configId, String text);

    /**
     * 计算调用费用
     *
     * @param configId     配置ID
     * @param inputTokens  输入Token数
     * @param outputTokens 输出Token数
     * @return 费用
     */
    BigDecimal calculateCost(String configId, Integer inputTokens, Integer outputTokens);

    /**
     * 获取可用模型列表
     *
     * @param platformType 平台类型
     * @return 模型列表
     */
    List<AvailableModel> getAvailableModels(PlatformType platformType);

    /**
     * 验证模型配置参数
     *
     * @param platformType 平台类型
     * @param modelName    模型名称
     * @param parameters   参数
     * @return 验证结果
     */
    ValidationResult validateModelParameters(PlatformType platformType, String modelName, 
                                           Map<String, Object> parameters);

    /**
     * 模型测试结果
     */
    class ModelTestResult {
        private boolean success;
        private String output;
        private String errorMessage;
        private long responseTime;
        private Integer tokenCount;
        private BigDecimal cost;
        private Map<String, Object> metadata;

        // Getter和Setter方法
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getOutput() { return output; }
        public void setOutput(String output) { this.output = output; }
        
        public String getErrorMessage() { return errorMessage; }
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
        
        public long getResponseTime() { return responseTime; }
        public void setResponseTime(long responseTime) { this.responseTime = responseTime; }
        
        public Integer getTokenCount() { return tokenCount; }
        public void setTokenCount(Integer tokenCount) { this.tokenCount = tokenCount; }
        
        public BigDecimal getCost() { return cost; }
        public void setCost(BigDecimal cost) { this.cost = cost; }
        
        public Map<String, Object> getMetadata() { return metadata; }
        public void setMetadata(Map<String, Object> metadata) { this.metadata = metadata; }
    }

    /**
     * 模型配置使用统计
     */
    class ModelConfigUsageStats {
        private Long totalCalls;
        private Long successCalls;
        private Long failedCalls;
        private Double successRate;
        private Double avgResponseTime;
        private Long totalInputTokens;
        private Long totalOutputTokens;
        private BigDecimal totalCost;
        private java.time.LocalDateTime lastUsedAt;
        private Map<String, Long> callsByDate;
        private Map<String, Long> tokensByDate;

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
        
        public Long getTotalInputTokens() { return totalInputTokens; }
        public void setTotalInputTokens(Long totalInputTokens) { this.totalInputTokens = totalInputTokens; }
        
        public Long getTotalOutputTokens() { return totalOutputTokens; }
        public void setTotalOutputTokens(Long totalOutputTokens) { this.totalOutputTokens = totalOutputTokens; }
        
        public BigDecimal getTotalCost() { return totalCost; }
        public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }
        
        public java.time.LocalDateTime getLastUsedAt() { return lastUsedAt; }
        public void setLastUsedAt(java.time.LocalDateTime lastUsedAt) { this.lastUsedAt = lastUsedAt; }
        
        public Map<String, Long> getCallsByDate() { return callsByDate; }
        public void setCallsByDate(Map<String, Long> callsByDate) { this.callsByDate = callsByDate; }
        
        public Map<String, Long> getTokensByDate() { return tokensByDate; }
        public void setTokensByDate(Map<String, Long> tokensByDate) { this.tokensByDate = tokensByDate; }
    }

    /**
     * 可用模型
     */
    class AvailableModel {
        private String modelId;
        private String modelName;
        private String description;
        private Integer maxTokens;
        private BigDecimal inputCostPer1K;
        private BigDecimal outputCostPer1K;
        private boolean supportsStream;
        private boolean supportsTools;
        private boolean supportsImages;
        private List<String> supportedLanguages;

        // Getter和Setter方法
        public String getModelId() { return modelId; }
        public void setModelId(String modelId) { this.modelId = modelId; }
        
        public String getModelName() { return modelName; }
        public void setModelName(String modelName) { this.modelName = modelName; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Integer getMaxTokens() { return maxTokens; }
        public void setMaxTokens(Integer maxTokens) { this.maxTokens = maxTokens; }
        
        public BigDecimal getInputCostPer1K() { return inputCostPer1K; }
        public void setInputCostPer1K(BigDecimal inputCostPer1K) { this.inputCostPer1K = inputCostPer1K; }
        
        public BigDecimal getOutputCostPer1K() { return outputCostPer1K; }
        public void setOutputCostPer1K(BigDecimal outputCostPer1K) { this.outputCostPer1K = outputCostPer1K; }
        
        public boolean isSupportsStream() { return supportsStream; }
        public void setSupportsStream(boolean supportsStream) { this.supportsStream = supportsStream; }
        
        public boolean isSupportsTools() { return supportsTools; }
        public void setSupportsTools(boolean supportsTools) { this.supportsTools = supportsTools; }
        
        public boolean isSupportsImages() { return supportsImages; }
        public void setSupportsImages(boolean supportsImages) { this.supportsImages = supportsImages; }
        
        public List<String> getSupportedLanguages() { return supportedLanguages; }
        public void setSupportedLanguages(List<String> supportedLanguages) { this.supportedLanguages = supportedLanguages; }
    }

    /**
     * 验证结果
     */
    class ValidationResult {
        private boolean valid;
        private String message;
        private Map<String, String> fieldErrors;

        // Getter和Setter方法
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public Map<String, String> getFieldErrors() { return fieldErrors; }
        public void setFieldErrors(Map<String, String> fieldErrors) { this.fieldErrors = fieldErrors; }
    }
}