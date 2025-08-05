package com.wework.platform.agent.service.impl;

import com.wework.platform.agent.dto.request.ChatRequest;
import com.wework.platform.agent.dto.response.ChatResponse;
import com.wework.platform.agent.entity.*;
import com.wework.platform.agent.enums.*;
import com.wework.platform.agent.repository.*;
import com.wework.platform.agent.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 聊天服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final AgentRepository agentRepository;
    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;
    private final PlatformConfigRepository platformConfigRepository;
    private final ModelConfigRepository modelConfigRepository;
    private final CallRecordRepository callRecordRepository;
    
    private final ConversationService conversationService;
    private final MessageService messageService;
    private final Map<PlatformType, PlatformIntegrationService> platformServices;
    
    // 活跃会话缓存
    private final Map<String, Object> activeConversations = new ConcurrentHashMap<>();
    
    @Override
    @Transactional
    public ChatResponse chat(String tenantId, String userId, ChatRequest request) {
        log.info("处理聊天请求: tenantId={}, userId={}, agentId={}", tenantId, userId, request.getAgentId());
        
        try {
            // 1. 验证和获取智能体信息
            Agent agent = validateAndGetAgent(tenantId, request.getAgentId());
            
            // 2. 获取或创建会话
            Conversation conversation = getOrCreateConversation(tenantId, userId, request);
            
            // 3. 保存用户消息
            Message userMessage = saveUserMessage(tenantId, conversation, agent, userId, request);
            
            // 4. 调用外部平台获取AI响应
            ChatResponse response = callExternalPlatform(tenantId, agent, conversation, request, userMessage);
            
            // 5. 保存AI响应消息
            saveAssistantMessage(tenantId, conversation, agent, response, userMessage);
            
            // 6. 更新会话信息
            updateConversationInfo(conversation, response);
            
            // 7. 记录调用统计
            recordCallStats(tenantId, agent, conversation, userMessage, response);
            
            return response;
            
        } catch (Exception e) {
            log.error("聊天处理失败: tenantId={}, userId={}, error={}", tenantId, userId, e.getMessage(), e);
            return createErrorResponse(e.getMessage());
        }
    }

    @Override
    public Mono<ChatResponse> chatAsync(String tenantId, String userId, ChatRequest request) {
        return Mono.fromCallable(() -> chat(tenantId, userId, request))
                .doOnError(error -> log.error("异步聊天处理失败: {}", error.getMessage()));
    }

    @Override
    public Flux<ChatResponse> chatStream(String tenantId, String userId, ChatRequest request) {
        log.info("处理流式聊天请求: tenantId={}, userId={}, agentId={}", tenantId, userId, request.getAgentId());
        
        return Flux.create(emitter -> {
            try {
                // 1. 验证和获取智能体信息
                Agent agent = validateAndGetAgent(tenantId, request.getAgentId());
                
                // 2. 获取或创建会话
                Conversation conversation = getOrCreateConversation(tenantId, userId, request);
                
                // 3. 保存用户消息
                Message userMessage = saveUserMessage(tenantId, conversation, agent, userId, request);
                
                // 4. 获取平台集成服务
                PlatformIntegrationService platformService = getPlatformService(agent);
                PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
                ModelConfig modelConfig = getModelConfig(tenantId, agent);
                
                // 5. 调用流式API
                Map<String, Object> context = getConversationContext(conversation);
                Flux<ChatResponse> responseStream = platformService.sendMessageStream(
                    agent, platformConfig, modelConfig, request, context);
                
                // 6. 处理流式响应
                StringBuilder fullContent = new StringBuilder();
                responseStream.subscribe(
                    response -> {
                        // 更新完整内容
                        if (response.getContent() != null) {
                            fullContent.append(response.getContent());
                        }
                        
                        // 设置会话ID和请求消息ID
                        response.setConversationId(conversation.getId());
                        response.setRequestMessageId(userMessage.getId());
                        
                        // 发送给客户端
                        emitter.next(response);
                        
                        // 如果是最后一个响应，保存完整消息
                        if (Boolean.TRUE.equals(response.getFinished())) {
                            response.setContent(fullContent.toString());
                            saveAssistantMessage(tenantId, conversation, agent, response, userMessage);
                            updateConversationInfo(conversation, response);
                            recordCallStats(tenantId, agent, conversation, userMessage, response);
                            emitter.complete();
                        }
                    },
                    error -> {
                        log.error("流式聊天处理失败: {}", error.getMessage(), error);
                        emitter.error(error);
                    }
                );
                
            } catch (Exception e) {
                log.error("流式聊天初始化失败: {}", e.getMessage(), e);
                emitter.error(e);
            }
        });
    }

    @Override
    public ChatResponse continueConversation(String tenantId, String userId, String conversationId, String message) {
        ChatRequest request = new ChatRequest();
        request.setConversationId(conversationId);
        request.setContent(message);
        request.setMessageType(MessageType.TEXT);
        
        // 从会话中获取智能体ID
        Conversation conversation = conversationRepository.selectById(conversationId);
        if (conversation == null || !conversation.getTenantId().equals(tenantId)) {
            throw new IllegalArgumentException("会话不存在或无权限访问");
        }
        request.setAgentId(conversation.getAgentId());
        
        return chat(tenantId, userId, request);
    }

    @Override
    @Transactional
    public ChatResponse regenerateResponse(String tenantId, String userId, String messageId) {
        // 1. 获取原始消息
        Message originalMessage = messageRepository.selectById(messageId);
        if (originalMessage == null || !originalMessage.getTenantId().equals(tenantId)) {
            throw new IllegalArgumentException("消息不存在或无权限访问");
        }
        
        // 2. 获取对应的用户消息
        Message userMessage = messageRepository.selectById(originalMessage.getParentMessageId());
        if (userMessage == null) {
            throw new IllegalArgumentException("无法找到对应的用户消息");
        }
        
        // 3. 重新构建请求
        ChatRequest request = new ChatRequest();
        request.setAgentId(originalMessage.getAgentId());
        request.setConversationId(originalMessage.getConversationId());
        request.setContent(userMessage.getContent());
        request.setMessageType(userMessage.getType());
        
        // 4. 删除原始AI响应
        messageRepository.deleteById(messageId);
        
        // 5. 重新生成响应
        return chat(tenantId, userId, request);
    }

    @Override
    public void stopGeneration(String tenantId, String userId, String conversationId) {
        try {
            // 1. 验证会话权限
            Conversation conversation = conversationRepository.selectById(conversationId);
            if (conversation == null || !conversation.getTenantId().equals(tenantId)) {
                throw new IllegalArgumentException("会话不存在或无权限访问");
            }
            
            // 2. 获取智能体和平台配置
            Agent agent = agentRepository.selectById(conversation.getAgentId());
            PlatformIntegrationService platformService = getPlatformService(agent);
            PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
            
            // 3. 调用平台停止生成API
            String requestId = activeConversations.get(conversationId + ":requestId") != null ? 
                             activeConversations.get(conversationId + ":requestId").toString() : null;
            platformService.stopGeneration(platformConfig, conversationId, requestId);
            
            // 4. 更新会话状态
            conversation.setStatus(ConversationStatus.ACTIVE);
            conversationRepository.updateById(conversation);
            
            log.info("已停止生成: conversationId={}", conversationId);
            
        } catch (Exception e) {
            log.error("停止生成失败: conversationId={}, error={}", conversationId, e.getMessage(), e);
            throw new RuntimeException("停止生成失败: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public void rateResponse(String tenantId, String userId, String messageId, Integer rating, String feedback) {
        // 1. 验证消息
        Message message = messageRepository.selectById(messageId);
        if (message == null || !message.getTenantId().equals(tenantId)) {
            throw new IllegalArgumentException("消息不存在或无权限访问");
        }
        
        // 2. 更新消息元数据
        Map<String, Object> metadata = parseMetadata(message.getMetadata());
        Map<String, Object> ratingInfo = new HashMap<>();
        ratingInfo.put("rating", rating);
        ratingInfo.put("feedback", feedback);
        ratingInfo.put("ratedAt", LocalDateTime.now());
        ratingInfo.put("ratedBy", userId);
        metadata.put("userRating", ratingInfo);
        
        message.setMetadata(toJsonString(metadata));
        messageRepository.updateById(message);
        
        log.info("消息评价已保存: messageId={}, rating={}", messageId, rating);
    }

    @Override
    public List<String> getChatSuggestions(String tenantId, String userId, String conversationId) {
        try {
            // 1. 获取会话信息
            Conversation conversation = conversationRepository.selectById(conversationId);
            if (conversation == null || !conversation.getTenantId().equals(tenantId)) {
                return Collections.emptyList();
            }
            
            // 2. 获取智能体信息
            Agent agent = agentRepository.selectById(conversation.getAgentId());
            if (agent == null) {
                return Collections.emptyList();
            }
            
            // 3. 根据智能体类型和最近消息生成建议
            List<String> suggestions = new ArrayList<>();
            
            // 基础建议
            if (agent.getType() == AgentType.CHAT_ASSISTANT) {
                suggestions.addAll(Arrays.asList(
                    "请帮我总结一下上面的内容",
                    "能否给我更详细的解释？",
                    "这个问题有其他解决方案吗？"
                ));
            } else if (agent.getType() == AgentType.WORKFLOW) {
                suggestions.addAll(Arrays.asList(
                    "开始新的工作流程",
                    "查看当前任务状态",
                    "继续下一步操作"
                ));
            }
            
            // 根据智能体能力添加建议
            if (agent.getCapabilities() != null) {
                List<String> capabilities = Arrays.asList(agent.getCapabilities().split(","));
                if (capabilities.contains("文档处理")) {
                    suggestions.add("上传文档进行分析");
                }
                if (capabilities.contains("图片分析")) {
                    suggestions.add("上传图片进行识别");
                }
                if (capabilities.contains("代码生成")) {
                    suggestions.add("帮我生成代码");
                }
            }
            
            return suggestions.subList(0, Math.min(suggestions.size(), 5));
            
        } catch (Exception e) {
            log.error("获取聊天建议失败: conversationId={}, error={}", conversationId, e.getMessage());
            return Collections.emptyList();
        }
    }

    @Override
    @Transactional
    public void clearConversationContext(String tenantId, String userId, String conversationId) {
        try {
            // 1. 验证会话权限
            Conversation conversation = conversationRepository.selectById(conversationId);
            if (conversation == null || !conversation.getTenantId().equals(tenantId)) {
                throw new IllegalArgumentException("会话不存在或无权限访问");
            }
            
            // 2. 清理本地上下文
            conversation.setContextJson("{}");
            conversationRepository.updateById(conversation);
            
            // 3. 清理平台侧上下文
            Agent agent = agentRepository.selectById(conversation.getAgentId());
            PlatformIntegrationService platformService = getPlatformService(agent);
            PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
            platformService.clearConversation(platformConfig, conversationId);
            
            log.info("会话上下文已清理: conversationId={}", conversationId);
            
        } catch (Exception e) {
            log.error("清理会话上下文失败: conversationId={}, error={}", conversationId, e.getMessage(), e);
            throw new RuntimeException("清理会话上下文失败: " + e.getMessage());
        }
    }

    @Override
    public void warmupAgent(String tenantId, String agentId) {
        try {
            Agent agent = agentRepository.selectById(agentId);
            if (agent == null || !agent.getTenantId().equals(tenantId)) {
                return;
            }
            
            // 预加载平台配置和模型配置
            PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
            ModelConfig modelConfig = getModelConfig(tenantId, agent);
            PlatformIntegrationService platformService = getPlatformService(agent);
            
            // 测试连接
            if (platformConfig != null) {
                platformService.testConnection(platformConfig);
            }
            
            log.info("智能体预热完成: agentId={}", agentId);
            
        } catch (Exception e) {
            log.warn("智能体预热失败: agentId={}, error={}", agentId, e.getMessage());
        }
    }

    @Override
    public boolean isAgentAvailable(String tenantId, String agentId) {
        try {
            Agent agent = agentRepository.selectById(agentId);
            if (agent == null || !agent.getTenantId().equals(tenantId)) {
                return false;
            }
            
            // 检查智能体状态
            if (agent.getStatus() != AgentStatus.RUNNING && agent.getStatus() != AgentStatus.PUBLISHED) {
                return false;
            }
            
            // 检查平台连接
            PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
            if (platformConfig == null || !platformConfig.getEnabled()) {
                return false;
            }
            
            PlatformIntegrationService platformService = getPlatformService(agent);
            return platformService.testConnection(platformConfig);
            
        } catch (Exception e) {
            log.error("检查智能体可用性失败: agentId={}, error={}", agentId, e.getMessage());
            return false;
        }
    }

    @Override
    public String getAgentCapabilities(String tenantId, String agentId) {
        try {
            Agent agent = agentRepository.selectById(agentId);
            if (agent == null || !agent.getTenantId().equals(tenantId)) {
                return "智能体不存在";
            }
            
            StringBuilder capabilities = new StringBuilder();
            capabilities.append("智能体类型: ").append(agent.getType().getDescription()).append("\n");
            capabilities.append("状态: ").append(agent.getStatus().getDescription()).append("\n");
            
            if (agent.getCapabilities() != null) {
                capabilities.append("能力: ").append(agent.getCapabilities()).append("\n");
            }
            
            if (agent.getSystemPrompt() != null) {
                capabilities.append("系统提示: ").append(agent.getSystemPrompt()).append("\n");
            }
            
            // 获取平台能力
            PlatformIntegrationService platformService = getPlatformService(agent);
            PlatformIntegrationService.PlatformCapabilities platformCaps = platformService.getCapabilities();
            capabilities.append("平台能力: ");
            if (platformCaps.isSupportsChat()) capabilities.append("聊天 ");
            if (platformCaps.isSupportsWorkflow()) capabilities.append("工作流 ");
            if (platformCaps.isSupportsStream()) capabilities.append("流式输出 ");
            if (platformCaps.isSupportsTools()) capabilities.append("工具调用 ");
            if (platformCaps.isSupportsImages()) capabilities.append("图片处理 ");
            
            return capabilities.toString();
            
        } catch (Exception e) {
            log.error("获取智能体能力失败: agentId={}, error={}", agentId, e.getMessage());
            return "获取能力信息失败: " + e.getMessage();
        }
    }

    // ========== 私有辅助方法 ==========
    
    private Agent validateAndGetAgent(String tenantId, String agentId) {
        Agent agent = agentRepository.selectById(agentId);
        if (agent == null || !agent.getTenantId().equals(tenantId)) {
            throw new IllegalArgumentException("智能体不存在或无权限访问");
        }
        
        if (agent.getStatus() != AgentStatus.RUNNING && agent.getStatus() != AgentStatus.PUBLISHED) {
            throw new IllegalStateException("智能体状态不可用: " + agent.getStatus().getDescription());
        }
        
        return agent;
    }
    
    private Conversation getOrCreateConversation(String tenantId, String userId, ChatRequest request) {
        if (request.getConversationId() != null) {
            Conversation conversation = conversationRepository.selectById(request.getConversationId());
            if (conversation != null && conversation.getTenantId().equals(tenantId)) {
                return conversation;
            }
        }
        
        // 创建新会话
        return conversationService.createConversation(tenantId, userId, request.getAgentId(), null);
    }
    
    private Message saveUserMessage(String tenantId, Conversation conversation, Agent agent, 
                                  String userId, ChatRequest request) {
        return messageService.createMessage(
            tenantId, conversation.getId(), agent.getId(), userId,
            request.getMessageType(), "user", request.getContent()
        );
    }
    
    private ChatResponse callExternalPlatform(String tenantId, Agent agent, Conversation conversation,
                                            ChatRequest request, Message userMessage) {
        try {
            // 获取平台集成服务
            PlatformIntegrationService platformService = getPlatformService(agent);
            PlatformConfig platformConfig = getPlatformConfig(tenantId, agent);
            ModelConfig modelConfig = getModelConfig(tenantId, agent);
            
            // 获取会话上下文
            Map<String, Object> context = getConversationContext(conversation);
            
            // 调用平台API
            ChatResponse response = platformService.sendMessage(agent, platformConfig, modelConfig, request, context);
            
            // 设置响应信息
            response.setConversationId(conversation.getId());
            response.setRequestMessageId(userMessage.getId());
            response.setAgentId(agent.getId());
            response.setAgentName(agent.getName());
            response.setAgentAvatar(agent.getAvatar());
            
            return response;
            
        } catch (Exception e) {
            log.error("调用外部平台失败: agentId={}, error={}", agent.getId(), e.getMessage(), e);
            throw new RuntimeException("AI服务调用失败: " + e.getMessage());
        }
    }
    
    private Message saveAssistantMessage(String tenantId, Conversation conversation, Agent agent,
                                       ChatResponse response, Message userMessage) {
        Message assistantMessage = messageService.createMessage(
            tenantId, conversation.getId(), agent.getId(), null,
            response.getMessageType(), "assistant", response.getContent()
        );
        
        // 设置父消息关系
        assistantMessage.setParentMessageId(userMessage.getId());
        
        // 设置Token统计
        if (response.getTokenUsage() != null) {
            assistantMessage.setTokenCount(response.getTokenUsage().getTotalTokens());
        }
        
        // 设置响应时间
        if (response.getResponseTime() != null) {
            assistantMessage.setResponseTime(response.getResponseTime());
        }
        
        // 设置响应消息ID
        response.setResponseMessageId(assistantMessage.getId());
        
        return assistantMessage;
    }
    
    private void updateConversationInfo(Conversation conversation, ChatResponse response) {
        conversation.setLastMessageAt(LocalDateTime.now());
        conversation.setMessageCount(conversation.getMessageCount() + 2); // 用户消息 + AI消息
        
        if (response.getTokenUsage() != null) {
            conversation.setTotalTokens(conversation.getTotalTokens() + response.getTokenUsage().getTotalTokens());
        }
        
        conversationRepository.updateById(conversation);
    }
    
    private void recordCallStats(String tenantId, Agent agent, Conversation conversation,
                               Message userMessage, ChatResponse response) {
        // 创建调用记录
        CallRecord callRecord = new CallRecord();
        callRecord.setTenantId(tenantId);
        callRecord.setAgentId(agent.getId());
        callRecord.setConversationId(conversation.getId());
        callRecord.setMessageId(userMessage.getId());
        callRecord.setPlatformType(PlatformType.valueOf(agent.getExternalPlatformType()));
        callRecord.setStatus(response.getErrorMessage() == null ? CallStatus.SUCCESS : CallStatus.FAILED);
        callRecord.setStartTime(LocalDateTime.now().minusSeconds(response.getResponseTime() / 1000));
        callRecord.setEndTime(LocalDateTime.now());
        callRecord.setResponseTime(response.getResponseTime());
        
        if (response.getTokenUsage() != null) {
            callRecord.setTokenCount(response.getTokenUsage().getTotalTokens());
            callRecord.setCost(java.math.BigDecimal.valueOf(response.getTokenUsage().getCost()));
        }
        
        if (response.getErrorMessage() != null) {
            callRecord.setErrorMessage(response.getErrorMessage());
        }
        
        callRecordRepository.insert(callRecord);
    }
    
    private PlatformIntegrationService getPlatformService(Agent agent) {
        PlatformType platformType = PlatformType.valueOf(agent.getExternalPlatformType());
        PlatformIntegrationService service = platformServices.get(platformType);
        if (service == null) {
            throw new UnsupportedOperationException("不支持的平台类型: " + platformType);
        }
        return service;
    }
    
    private PlatformConfig getPlatformConfig(String tenantId, Agent agent) {
        if (agent.getPlatformConfigId() != null) {
            return platformConfigRepository.selectById(agent.getPlatformConfigId());
        }
        return null;
    }
    
    private ModelConfig getModelConfig(String tenantId, Agent agent) {
        if (agent.getModelConfigId() != null) {
            return modelConfigRepository.selectById(agent.getModelConfigId());
        }
        return null;
    }
    
    private Map<String, Object> getConversationContext(Conversation conversation) {
        try {
            if (conversation.getContextJson() != null) {
                return parseMetadata(conversation.getContextJson());
            }
        } catch (Exception e) {
            log.warn("解析会话上下文失败: {}", e.getMessage());
        }
        return new HashMap<>();
    }
    
    private ChatResponse createErrorResponse(String errorMessage) {
        ChatResponse response = new ChatResponse();
        response.setMessageType(MessageType.TEXT);
        response.setMessageStatus(MessageStatus.FAILED);
        response.setContent("抱歉，我遇到了一些问题，请稍后再试。");
        response.setErrorMessage(errorMessage);
        response.setCreatedAt(LocalDateTime.now());
        return response;
    }
    
    @SuppressWarnings("unchecked")
    private Map<String, Object> parseMetadata(String json) {
        try {
            if (json == null || json.trim().isEmpty()) {
                return new HashMap<>();
            }
            // 这里应该使用JSON解析库，简化处理
            return new HashMap<>();
        } catch (Exception e) {
            return new HashMap<>();
        }
    }
    
    private String toJsonString(Map<String, Object> map) {
        try {
            // 这里应该使用JSON序列化库，简化处理
            return "{}";
        } catch (Exception e) {
            return "{}";
        }
    }
}