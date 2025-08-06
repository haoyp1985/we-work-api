package com.wework.platform.agent.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wework.platform.agent.dto.request.ChatRequest;
import com.wework.platform.agent.dto.response.ChatResponse;
import com.wework.platform.agent.entity.ModelConfig;
import com.wework.platform.agent.entity.PlatformConfig;
import com.wework.platform.agent.enums.PlatformType;
import com.wework.platform.agent.service.PlatformIntegrationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * 平台集成服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PlatformIntegrationServiceImpl implements PlatformIntegrationService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public ChatResponse callPlatform(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                   ChatRequest request) {
        log.info("调用外部平台, platformType={}, modelName={}", 
                platformConfig.getPlatformType(), modelConfig.getModelName());
        
        try {
            switch (platformConfig.getPlatformType()) {
                case COZE:
                    return callCoze(platformConfig, modelConfig, request);
                case DIFY:
                    return callDify(platformConfig, modelConfig, request);
                case ALIBABA_DASHSCOPE:
                    return callDashScope(platformConfig, modelConfig, request);
                case OPENAI:
                    return callOpenAI(platformConfig, modelConfig, request);
                case ANTHROPIC_CLAUDE:
                    return callClaude(platformConfig, modelConfig, request);
                case BAIDU_WENXIN:
                    return callWenxin(platformConfig, modelConfig, request);
                default:
                    throw new UnsupportedOperationException("不支持的平台类型: " + platformConfig.getPlatformType());
            }
        } catch (Exception e) {
            log.error("调用外部平台失败, platformType={}, error={}", 
                     platformConfig.getPlatformType(), e.getMessage(), e);
            return ChatResponse.builder()
                .success(false)
                .errorMessage("调用外部平台失败: " + e.getMessage())
                .timestamp(LocalDateTime.now())
                .build();
        }
    }

    public CompletableFuture<ChatResponse> callPlatformAsync(PlatformConfig platformConfig, 
                                                           ModelConfig modelConfig, 
                                                           ChatRequest request) {
        return CompletableFuture.supplyAsync(() -> callPlatform(platformConfig, modelConfig, request));
    }

    public boolean testConnection(PlatformConfig platformConfig) {
        log.info("测试平台连接, platformType={}", platformConfig.getPlatformType());
        
        try {
            switch (platformConfig.getPlatformType()) {
                case COZE:
                    return testCozeConnection(platformConfig);
                case DIFY:
                    return testDifyConnection(platformConfig);
                case ALIBABA_DASHSCOPE:
                    return testDashScopeConnection(platformConfig);
                case OPENAI:
                    return testOpenAIConnection(platformConfig);
                case CLAUDE:
                    return testClaudeConnection(platformConfig);
                case WENXIN:
                    return testWenxinConnection(platformConfig);
                default:
                    log.warn("不支持的平台类型连接测试: {}", platformConfig.getPlatformType());
                    return false;
            }
        } catch (Exception e) {
            log.error("测试平台连接失败, platformType={}, error={}", 
                     platformConfig.getPlatformType(), e.getMessage());
            return false;
        }
    }

    public List<String> getSupportedModels(PlatformConfig platformConfig) {
        log.info("获取支持的模型列表, platformType={}", platformConfig.getPlatformType());
        
        try {
            switch (platformConfig.getPlatformType()) {
                case COZE:
                    return getCozeModels(platformConfig);
                case DIFY:
                    return getDifyModels(platformConfig);
                case ALIBABA_DASHSCOPE:
                    return getDashScopeModels(platformConfig);
                case OPENAI:
                    return getOpenAIModels(platformConfig);
                case ANTHROPIC_CLAUDE:
                    return getClaudeModels(platformConfig);
                case BAIDU_WENXIN:
                    return getWenxinModels(platformConfig);
                default:
                    log.warn("不支持的平台类型: {}", platformConfig.getPlatformType());
                    return List.of();
            }
        } catch (Exception e) {
            log.error("获取支持的模型列表失败, platformType={}, error={}", 
                     platformConfig.getPlatformType(), e.getMessage());
            return List.of();
        }
    }

    /**
     * 调用Coze平台
     */
    private ChatResponse callCoze(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                 ChatRequest request) {
        log.debug("调用Coze平台, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("bot_id", modelConfig.getModelName());
        requestBody.put("user", request.getUserId());
        requestBody.put("query", request.getMessage());
        requestBody.put("chat_history", request.getHistory());
        
        // 添加模型参数
        if (modelConfig.getParameters() != null) {
            requestBody.putAll(modelConfig.getParameters());
        }
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(platformConfig.getApiKey());
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                platformConfig.getApiUrl() + "/open_api/v2/chat",
                entity,
                Map.class
            );
            
            return parseCozeResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("Coze平台调用失败", e);
            throw new RuntimeException("Coze平台调用失败: " + e.getMessage());
        }
    }

    /**
     * 调用Dify平台
     */
    private ChatResponse callDify(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                 ChatRequest request) {
        log.debug("调用Dify平台, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("inputs", Map.of());
        requestBody.put("query", request.getMessage());
        requestBody.put("response_mode", "blocking");
        requestBody.put("conversation_id", request.getConversationId());
        requestBody.put("user", request.getUserId());
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + platformConfig.getApiKey());
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                platformConfig.getApiUrl() + "/v1/chat-messages",
                entity,
                Map.class
            );
            
            return parseDifyResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("Dify平台调用失败", e);
            throw new RuntimeException("Dify平台调用失败: " + e.getMessage());
        }
    }

    /**
     * 调用阿里百炼
     */
    private ChatResponse callDashScope(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                      ChatRequest request) {
        log.debug("调用阿里百炼, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        Map<String, Object> model = new HashMap<>();
        model.put("model", modelConfig.getModelName());
        
        Map<String, Object> input = new HashMap<>();
        input.put("messages", buildOpenAIMessages(request));
        
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("result_format", "message");
        if (modelConfig.getParameters() != null) {
            parameters.putAll(modelConfig.getParameters());
        }
        
        requestBody.put("model", modelConfig.getModelName());
        requestBody.put("input", input);
        requestBody.put("parameters", parameters);
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + platformConfig.getApiKey());
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                platformConfig.getApiUrl() + "/services/aigc/text-generation/generation",
                entity,
                Map.class
            );
            
            return parseDashScopeResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("阿里百炼调用失败", e);
            throw new RuntimeException("阿里百炼调用失败: " + e.getMessage());
        }
    }

    /**
     * 调用OpenAI
     */
    private ChatResponse callOpenAI(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                   ChatRequest request) {
        log.debug("调用OpenAI, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", modelConfig.getModelName());
        requestBody.put("messages", buildOpenAIMessages(request));
        
        // 添加模型参数
        if (modelConfig.getParameters() != null) {
            requestBody.putAll(modelConfig.getParameters());
        }
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(platformConfig.getApiKey());
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                platformConfig.getApiUrl() + "/v1/chat/completions",
                entity,
                Map.class
            );
            
            return parseOpenAIResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("OpenAI调用失败", e);
            throw new RuntimeException("OpenAI调用失败: " + e.getMessage());
        }
    }

    /**
     * 调用Claude
     */
    private ChatResponse callClaude(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                   ChatRequest request) {
        log.debug("调用Claude, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", modelConfig.getModelName());
        requestBody.put("max_tokens", 4096);
        requestBody.put("messages", buildClaudeMessages(request));
        
        // 添加模型参数
        if (modelConfig.getParameters() != null) {
            requestBody.putAll(modelConfig.getParameters());
        }
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-api-key", platformConfig.getApiKey());
        headers.set("anthropic-version", "2023-06-01");
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                platformConfig.getApiUrl() + "/v1/messages",
                entity,
                Map.class
            );
            
            return parseClaudeResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("Claude调用失败", e);
            throw new RuntimeException("Claude调用失败: " + e.getMessage());
        }
    }

    /**
     * 调用文心一言
     */
    private ChatResponse callWenxin(PlatformConfig platformConfig, ModelConfig modelConfig, 
                                   ChatRequest request) {
        log.debug("调用文心一言, modelName={}", modelConfig.getModelName());
        
        // 构建请求体
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("messages", buildOpenAIMessages(request));
        
        // 添加模型参数
        if (modelConfig.getParameters() != null) {
            requestBody.putAll(modelConfig.getParameters());
        }
        
        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + platformConfig.getApiKey());
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            String url = String.format("%s/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/%s", 
                                     platformConfig.getApiUrl(), modelConfig.getModelName());
            
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            
            return parseWenxinResponse(response.getBody());
            
        } catch (Exception e) {
            log.error("文心一言调用失败", e);
            throw new RuntimeException("文心一言调用失败: " + e.getMessage());
        }
    }

    // 测试连接方法
    private boolean testCozeConnection(PlatformConfig platformConfig) {
        // TODO: 实现Coze连接测试
        return true;
    }

    private boolean testDifyConnection(PlatformConfig platformConfig) {
        // TODO: 实现Dify连接测试
        return true;
    }

    private boolean testDashScopeConnection(PlatformConfig platformConfig) {
        // TODO: 实现阿里百炼连接测试
        return true;
    }

    private boolean testOpenAIConnection(PlatformConfig platformConfig) {
        // TODO: 实现OpenAI连接测试
        return true;
    }

    private boolean testClaudeConnection(PlatformConfig platformConfig) {
        // TODO: 实现Claude连接测试
        return true;
    }

    private boolean testWenxinConnection(PlatformConfig platformConfig) {
        // TODO: 实现文心一言连接测试
        return true;
    }

    // 获取模型列表方法
    private List<String> getCozeModels(PlatformConfig platformConfig) {
        return List.of("coze-bot-1", "coze-bot-2");
    }

    private List<String> getDifyModels(PlatformConfig platformConfig) {
        return List.of("dify-app-1", "dify-app-2");
    }

    private List<String> getDashScopeModels(PlatformConfig platformConfig) {
        return List.of("qwen-turbo", "qwen-plus", "qwen-max", "qwen-max-longcontext");
    }

    private List<String> getOpenAIModels(PlatformConfig platformConfig) {
        return List.of("gpt-3.5-turbo", "gpt-4", "gpt-4-turbo", "gpt-4o");
    }

    private List<String> getClaudeModels(PlatformConfig platformConfig) {
        return List.of("claude-3-haiku-20240307", "claude-3-sonnet-20240229", "claude-3-opus-20240229");
    }

    private List<String> getWenxinModels(PlatformConfig platformConfig) {
        return List.of("ernie-bot", "ernie-bot-turbo", "ernie-bot-4", "ernie-3.5-8k");
    }

    // 响应解析方法
    private ChatResponse parseCozeResponse(Map<String, Object> response) {
        // TODO: 解析Coze响应
        return ChatResponse.builder()
            .success(true)
            .message("Coze响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    private ChatResponse parseDifyResponse(Map<String, Object> response) {
        // TODO: 解析Dify响应
        return ChatResponse.builder()
            .success(true)
            .message("Dify响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    private ChatResponse parseDashScopeResponse(Map<String, Object> response) {
        // TODO: 解析阿里百炼响应
        return ChatResponse.builder()
            .success(true)
            .message("阿里百炼响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    private ChatResponse parseOpenAIResponse(Map<String, Object> response) {
        // TODO: 解析OpenAI响应
        return ChatResponse.builder()
            .success(true)
            .message("OpenAI响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    private ChatResponse parseClaudeResponse(Map<String, Object> response) {
        // TODO: 解析Claude响应
        return ChatResponse.builder()
            .success(true)
            .message("Claude响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    private ChatResponse parseWenxinResponse(Map<String, Object> response) {
        // TODO: 解析文心一言响应
        return ChatResponse.builder()
            .success(true)
            .message("文心一言响应")
            .timestamp(LocalDateTime.now())
            .build();
    }

    // 消息构建方法
    private List<Map<String, Object>> buildOpenAIMessages(ChatRequest request) {
        // TODO: 构建OpenAI格式的消息
        return List.of(
            Map.of("role", "user", "content", request.getMessage())
        );
    }

    private List<Map<String, Object>> buildClaudeMessages(ChatRequest request) {
        // TODO: 构建Claude格式的消息
        return List.of(
            Map.of("role", "user", "content", request.getMessage())
        );
    }

    public Double calculateCost(Integer inputTokens, Integer outputTokens, String modelName) {
        log.debug("计算费用, inputTokens={}, outputTokens={}, modelName={}", 
                 inputTokens, outputTokens, modelName);
        
        if (inputTokens == null || outputTokens == null || modelName == null) {
            return 0.0;
        }
        
        // 定义不同模型的价格（每1000个token的费用，单位：USD）
        Map<String, Map<String, Double>> modelPricing = Map.of(
            "gpt-3.5-turbo", Map.of("input", 0.0015, "output", 0.002),
            "gpt-4", Map.of("input", 0.03, "output", 0.06),
            "gpt-4-turbo", Map.of("input", 0.01, "output", 0.03),
            "claude-3-haiku", Map.of("input", 0.00025, "output", 0.00125),
            "claude-3-sonnet", Map.of("input", 0.003, "output", 0.015),
            "claude-3-opus", Map.of("input", 0.015, "output", 0.075)
        );
        
        // 获取模型价格，如果没有找到则使用默认价格
        Map<String, Double> pricing = modelPricing.getOrDefault(
            modelName.toLowerCase(), 
            Map.of("input", 0.001, "output", 0.002) // 默认价格
        );
        
        // 计算费用
        double inputCost = (inputTokens / 1000.0) * pricing.get("input");
        double outputCost = (outputTokens / 1000.0) * pricing.get("output");
        double totalCost = inputCost + outputCost;
        
        log.debug("费用计算完成, inputCost={}, outputCost={}, totalCost={}", 
                 inputCost, outputCost, totalCost);
        
        return totalCost;
    }

    public Integer estimateTokens(String text) {
        if (text == null || text.trim().isEmpty()) {
            return 0;
        }
        
        // 简单的Token估算算法
        // 通常1个英文单词约等于1.3个token，1个中文字符约等于2个token
        String trimmedText = text.trim();
        
        // 统计中文字符数
        int chineseChars = 0;
        int englishWords = 0;
        
        for (char c : trimmedText.toCharArray()) {
            if (c >= 0x4e00 && c <= 0x9fff) { // Unicode中文范围
                chineseChars++;
            }
        }
        
        // 统计英文单词数（简单按空格分割）
        String[] words = trimmedText.split("\\s+");
        for (String word : words) {
            if (word.matches("[a-zA-Z0-9]+")) {
                englishWords++;
            }
        }
        
        // 计算预估token数
        int estimatedTokens = (int) (chineseChars * 2 + englishWords * 1.3);
        
        // 加上一些基础token（标点符号等）
        estimatedTokens += trimmedText.length() - chineseChars - englishWords * 5; // 估算其他字符
        
        log.debug("Token估算完成, text length={}, estimatedTokens={}", trimmedText.length(), estimatedTokens);
        
        return Math.max(1, estimatedTokens); // 至少1个token
    }

    public PlatformIntegrationService.PlatformCapabilities getCapabilities() {
        log.debug("获取平台功能信息");
        
        PlatformIntegrationService.PlatformCapabilities capabilities = new PlatformIntegrationService.PlatformCapabilities();
        
        // 设置平台支持的功能
        capabilities.setSupportsChat(true);
        capabilities.setSupportsWorkflow(true);
        capabilities.setSupportsStream(true);
        capabilities.setSupportsTools(true);
        capabilities.setSupportsImages(true);
        capabilities.setSupportsAudio(false); // 暂不支持音频
        capabilities.setSupportsVideo(false); // 暂不支持视频
        capabilities.setSupportsFiles(true);
        
        // 设置支持的语言
        capabilities.setSupportedLanguages(List.of("zh-CN", "en-US", "ja-JP", "ko-KR"));
        
        log.debug("平台功能信息获取完成");
        return capabilities;
    }

    public List<PlatformIntegrationService.ModelInfo> getAvailableModels(PlatformConfig platformConfig) {
        log.debug("获取可用模型列表, platformType={}", platformConfig.getPlatformType());
        
        List<PlatformIntegrationService.ModelInfo> models = new ArrayList<>();
        
        // 根据平台类型返回预定义的模型列表
        switch (platformConfig.getPlatformType()) {
            case OPENAI:
                models.add(createModelInfo("gpt-3.5-turbo", "GPT-3.5 Turbo", true, 4096));
                models.add(createModelInfo("gpt-4", "GPT-4", true, 8192));
                models.add(createModelInfo("gpt-4-turbo", "GPT-4 Turbo", true, 128000));
                break;
            case ANTHROPIC_CLAUDE:
                models.add(createModelInfo("claude-3-haiku", "Claude 3 Haiku", true, 200000));
                models.add(createModelInfo("claude-3-sonnet", "Claude 3 Sonnet", true, 200000));
                models.add(createModelInfo("claude-3-opus", "Claude 3 Opus", true, 200000));
                break;
            case ALIBABA_DASHSCOPE:
                models.add(createModelInfo("qwen-turbo", "通义千问-Turbo", true, 6000));
                models.add(createModelInfo("qwen-plus", "通义千问-Plus", true, 30000));
                break;
            case BAIDU_WENXIN:
                models.add(createModelInfo("ernie-bot", "文心一言", true, 5120));
                models.add(createModelInfo("ernie-bot-turbo", "文心一言-Turbo", true, 5120));
                break;
            default:
                models.add(createModelInfo("default-model", "默认模型", true, 4096));
                break;
        }
        
        log.debug("获取可用模型列表完成, count={}", models.size());
        return models;
    }

    @Override
    public boolean clearConversation(PlatformConfig platformConfig, String conversationId) {
        log.info("清理平台会话, platformType={}, conversationId={}", platformConfig.getPlatformType(), conversationId);
        
        try {
            switch (platformConfig.getPlatformType()) {
                case OPENAI:
                    // OpenAI 无需显式清理会话，每次请求都是独立的
                    log.debug("OpenAI平台无需清理会话");
                    return true;
                    
                case ANTHROPIC_CLAUDE:
                    // Claude 无需显式清理会话，每次请求都是独立的
                    log.debug("Claude平台无需清理会话");
                    return true;
                    
                case BAIDU_WENXIN:
                    // 文心一言 无需显式清理会话，每次请求都是独立的
                    log.debug("文心一言平台无需清理会话");
                    return true;
                    
                case COZE:
                    return clearCozeConversation(platformConfig, conversationId);
                    
                case DIFY:
                    return clearDifyConversation(platformConfig, conversationId);
                    
                default:
                    log.warn("未知的平台类型: {}", platformConfig.getPlatformType());
                    return false;
            }
        } catch (Exception e) {
            log.error("清理平台会话失败, conversationId={}", conversationId, e);
            return false;
        }
    }

    private boolean clearCozeConversation(PlatformConfig platformConfig, String conversationId) {
        // TODO: 实现Coze平台会话清理逻辑
        log.debug("Coze平台会话清理暂未实现, conversationId={}", conversationId);
        return true;
    }

    private boolean clearDifyConversation(PlatformConfig platformConfig, String conversationId) {
        // TODO: 实现Dify平台会话清理逻辑
        log.debug("Dify平台会话清理暂未实现, conversationId={}", conversationId);
        return true;
    }

    private PlatformIntegrationService.ModelInfo createModelInfo(String id, String name, boolean available, int maxTokens) {
        PlatformIntegrationService.ModelInfo modelInfo = new PlatformIntegrationService.ModelInfo();
        modelInfo.setId(id);
        modelInfo.setName(name);
        modelInfo.setAvailable(available);
        modelInfo.setMaxTokens(maxTokens);
        return modelInfo;
    }
}