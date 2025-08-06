package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.request.ChatRequest;
import com.wework.platform.agent.dto.response.ChatResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * 聊天服务接口
 */
public interface ChatService {

    /**
     * 发送聊天消息(同步)
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param request  聊天请求
     * @return 聊天响应
     */
    ChatResponse chat(String tenantId, String userId, ChatRequest request);

    /**
     * 发送聊天消息(异步)
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param request  聊天请求
     * @return 聊天响应(异步)
     */
    Mono<ChatResponse> chatAsync(String tenantId, String userId, ChatRequest request);

    /**
     * 发送聊天消息(流式)
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param request  聊天请求
     * @return 聊天响应流
     */
    Flux<ChatResponse> chatStream(String tenantId, String userId, ChatRequest request);

    /**
     * 继续对话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param message        消息内容
     * @return 聊天响应
     */
    ChatResponse continueConversation(String tenantId, String userId, String conversationId, String message);

    /**
     * 重新生成回答
     *
     * @param tenantId  租户ID
     * @param userId    用户ID
     * @param messageId 消息ID
     * @return 新的聊天响应
     */
    ChatResponse regenerateResponse(String tenantId, String userId, String messageId);

    /**
     * 停止生成
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     */
    void stopGeneration(String tenantId, String userId, String conversationId);

    /**
     * 在会话中聊天
     *
     * @param tenantId 租户ID
     * @param request  聊天请求
     * @return 聊天响应
     */
    ChatResponse chatInConversation(String tenantId, ChatRequest request);

    /**
     * 流式聊天
     *
     * @param tenantId 租户ID
     * @param request  聊天请求
     * @return 流式响应
     */
    Flux<ChatResponse> streamChat(String tenantId, ChatRequest request);

    /**
     * 获取会话上下文
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param limit          限制数量
     * @return 上下文信息
     */
    Object getConversationContext(String tenantId, String conversationId, int limit);

    /**
     * 清理会话历史
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     */
    void clearConversationHistory(String tenantId, String conversationId);

    /**
     * 评价回答
     *
     * @param tenantId  租户ID
     * @param userId    用户ID
     * @param messageId 消息ID
     * @param rating    评分(1-5)
     * @param feedback  反馈内容
     */
    void rateResponse(String tenantId, String userId, String messageId, Integer rating, String feedback);

    /**
     * 获取聊天建议
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @return 建议列表
     */
    java.util.List<String> getChatSuggestions(String tenantId, String userId, String conversationId);

    /**
     * 清理会话上下文
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     */
    void clearConversationContext(String tenantId, String userId, String conversationId);

    /**
     * 预热智能体(提前加载配置和模型)
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     */
    void warmupAgent(String tenantId, String agentId);

    /**
     * 检查智能体可用性
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 是否可用
     */
    boolean isAgentAvailable(String tenantId, String agentId);

    /**
     * 获取智能体能力描述
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @return 能力描述
     */
    String getAgentCapabilities(String tenantId, String agentId);
}