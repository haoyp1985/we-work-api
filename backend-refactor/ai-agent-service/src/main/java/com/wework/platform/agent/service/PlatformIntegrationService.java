package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.request.ChatRequest;
import com.wework.platform.agent.dto.response.ChatResponse;
import com.wework.platform.agent.dto.ValidationResult;
import com.wework.platform.agent.dto.ModelInfo;
import com.wework.platform.agent.dto.PlatformCapabilities;
import com.wework.platform.agent.entity.Agent;
import com.wework.platform.agent.entity.PlatformConfig;
import com.wework.platform.agent.entity.ModelConfig;
import com.wework.platform.agent.enums.PlatformType;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;

/**
 * 外部平台集成服务接口
 */
public interface PlatformIntegrationService {

    /**
     * 获取支持的平台类型
     *
     * @return 平台类型
     */
    PlatformType getSupportedPlatformType();

    /**
     * 测试平台连接
     *
     * @param platformConfig 平台配置
     * @return 是否连接成功
     */
    boolean testConnection(PlatformConfig platformConfig);

    /**
     * 验证平台配置
     *
     * @param platformConfig 平台配置
     * @return 验证结果
     */
    ValidationResult validateConfig(PlatformConfig platformConfig);

    /**
     * 发送聊天消息(同步)
     *
     * @param agent          智能体信息
     * @param platformConfig 平台配置
     * @param modelConfig    模型配置
     * @param request        聊天请求
     * @param context        会话上下文
     * @return 聊天响应
     */
    ChatResponse sendMessage(Agent agent, PlatformConfig platformConfig, ModelConfig modelConfig, 
                           ChatRequest request, Map<String, Object> context);

    /**
     * 发送聊天消息(异步)
     *
     * @param agent          智能体信息
     * @param platformConfig 平台配置
     * @param modelConfig    模型配置
     * @param request        聊天请求
     * @param context        会话上下文
     * @return 聊天响应(异步)
     */
    Mono<ChatResponse> sendMessageAsync(Agent agent, PlatformConfig platformConfig, ModelConfig modelConfig,
                                      ChatRequest request, Map<String, Object> context);

    /**
     * 发送聊天消息(流式)
     *
     * @param agent          智能体信息
     * @param platformConfig 平台配置
     * @param modelConfig    模型配置
     * @param request        聊天请求
     * @param context        会话上下文
     * @return 聊天响应流
     */
    Flux<ChatResponse> sendMessageStream(Agent agent, PlatformConfig platformConfig, ModelConfig modelConfig,
                                       ChatRequest request, Map<String, Object> context);

    /**
     * 停止生成
     *
     * @param platformConfig 平台配置
     * @param conversationId 会话ID
     * @param requestId      请求ID
     */
    void stopGeneration(PlatformConfig platformConfig, String conversationId, String requestId);

    /**
     * 获取会话历史
     *
     * @param platformConfig 平台配置
     * @param conversationId 会话ID
     * @param limit          限制数量
     * @return 历史消息
     */
    java.util.List<Map<String, Object>> getConversationHistory(PlatformConfig platformConfig, 
                                                               String conversationId, Integer limit);

    /**
     * 清理会话
     *
     * @param platformConfig 平台配置
     * @param conversationId 会话ID
     */
    void clearConversation(PlatformConfig platformConfig, String conversationId);

    /**
     * 获取模型列表
     *
     * @param platformConfig 平台配置
     * @return 模型列表
     */
    java.util.List<ModelInfo> getAvailableModels(PlatformConfig platformConfig);

    /**
     * 获取平台功能信息
     *
     * @return 功能信息
     */
    PlatformCapabilities getCapabilities();

    /**
     * 估算Token消耗
     *
     * @param text 文本内容
     * @return Token数量
     */
    Integer estimateTokens(String text);

    /**
     * 计算调用费用
     *
     * @param inputTokens  输入Token数
     * @param outputTokens 输出Token数
     * @param modelName    模型名称
     * @return 费用
     */
    Double calculateCost(Integer inputTokens, Integer outputTokens, String modelName);

    /**
     * 验证结果
     */
    class ValidationResult {
        private boolean valid;
        private String errorMessage;
        private java.util.Map<String, String> fieldErrors;

        // Getter和Setter方法
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        
        public String getErrorMessage() { return errorMessage; }
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
        
        public java.util.Map<String, String> getFieldErrors() { return fieldErrors; }
        public void setFieldErrors(java.util.Map<String, String> fieldErrors) { this.fieldErrors = fieldErrors; }
    }

    /**
     * 模型信息
     */
    class ModelInfo {
        private String modelId;
        private String modelName;
        private String description;
        private Integer maxTokens;
        private Double inputCostPer1K;
        private Double outputCostPer1K;
        private boolean supportsStream;
        private boolean supportsTools;

        // Getter和Setter方法
        public String getModelId() { return modelId; }
        public void setModelId(String modelId) { this.modelId = modelId; }
        
        public String getModelName() { return modelName; }
        public void setModelName(String modelName) { this.modelName = modelName; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Integer getMaxTokens() { return maxTokens; }
        public void setMaxTokens(Integer maxTokens) { this.maxTokens = maxTokens; }
        
        public Double getInputCostPer1K() { return inputCostPer1K; }
        public void setInputCostPer1K(Double inputCostPer1K) { this.inputCostPer1K = inputCostPer1K; }
        
        public Double getOutputCostPer1K() { return outputCostPer1K; }
        public void setOutputCostPer1K(Double outputCostPer1K) { this.outputCostPer1K = outputCostPer1K; }
        
        public boolean isSupportsStream() { return supportsStream; }
        public void setSupportsStream(boolean supportsStream) { this.supportsStream = supportsStream; }
        
        public boolean isSupportsTools() { return supportsTools; }
        public void setSupportsTools(boolean supportsTools) { this.supportsTools = supportsTools; }
    }

    /**
     * 平台能力
     */
    class PlatformCapabilities {
        private boolean supportsChat;
        private boolean supportsWorkflow;
        private boolean supportsStream;
        private boolean supportsTools;
        private boolean supportsImages;
        private boolean supportsAudio;
        private boolean supportsVideo;
        private boolean supportsFiles;
        private java.util.List<String> supportedLanguages;

        // Getter和Setter方法
        public boolean isSupportsChat() { return supportsChat; }
        public void setSupportsChat(boolean supportsChat) { this.supportsChat = supportsChat; }
        
        public boolean isSupportsWorkflow() { return supportsWorkflow; }
        public void setSupportsWorkflow(boolean supportsWorkflow) { this.supportsWorkflow = supportsWorkflow; }
        
        public boolean isSupportsStream() { return supportsStream; }
        public void setSupportsStream(boolean supportsStream) { this.supportsStream = supportsStream; }
        
        public boolean isSupportsTools() { return supportsTools; }
        public void setSupportsTools(boolean supportsTools) { this.supportsTools = supportsTools; }
        
        public boolean isSupportsImages() { return supportsImages; }
        public void setSupportsImages(boolean supportsImages) { this.supportsImages = supportsImages; }
        
        public boolean isSupportsAudio() { return supportsAudio; }
        public void setSupportsAudio(boolean supportsAudio) { this.supportsAudio = supportsAudio; }
        
        public boolean isSupportsVideo() { return supportsVideo; }
        public void setSupportsVideo(boolean supportsVideo) { this.supportsVideo = supportsVideo; }
        
        public boolean isSupportsFiles() { return supportsFiles; }
        public void setSupportsFiles(boolean supportsFiles) { this.supportsFiles = supportsFiles; }
        
        public java.util.List<String> getSupportedLanguages() { return supportedLanguages; }
        public void setSupportedLanguages(java.util.List<String> supportedLanguages) { this.supportedLanguages = supportedLanguages; }
    }
}