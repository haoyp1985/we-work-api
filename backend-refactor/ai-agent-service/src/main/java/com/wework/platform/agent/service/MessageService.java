package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.MessageDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 消息服务接口
 */
public interface MessageService {

    /**
     * 创建消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param agentId        智能体ID
     * @param userId         用户ID
     * @param type           消息类型
     * @param role           发送者角色
     * @param content        消息内容
     * @return 消息信息
     */
    MessageDTO createMessage(String tenantId, String conversationId, String agentId, String userId,
                           MessageType type, String role, String content);

    /**
     * 更新消息
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @param updates   更新字段
     * @return 消息信息
     */
    MessageDTO updateMessage(String tenantId, String messageId, Map<String, Object> updates);

    /**
     * 删除消息
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     */
    void deleteMessage(String tenantId, String messageId);

    /**
     * 获取消息详情
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @return 消息信息
     */
    MessageDTO getMessage(String tenantId, String messageId);

    /**
     * 获取会话消息列表
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param pageNum        页码
     * @param pageSize       页大小
     * @param ascending      是否升序
     * @return 分页结果
     */
    PageResult<MessageDTO> getConversationMessages(String tenantId, String conversationId,
                                                 Integer pageNum, Integer pageSize, Boolean ascending);

    /**
     * 获取会话最近消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param limit          数量限制
     * @return 消息列表
     */
    List<MessageDTO> getRecentMessages(String tenantId, String conversationId, Integer limit);

    /**
     * 搜索消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID(可选)
     * @param keyword        关键词
     * @param messageType    消息类型(可选)
     * @param startTime      开始时间(可选)
     * @param endTime        结束时间(可选)
     * @param pageNum        页码
     * @param pageSize       页大小
     * @return 分页结果
     */
    PageResult<MessageDTO> searchMessages(String tenantId, String conversationId, String keyword,
                                        MessageType messageType, LocalDateTime startTime, LocalDateTime endTime,
                                        Integer pageNum, Integer pageSize);

    /**
     * 更新消息状态
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @param status    新状态
     * @return 消息信息
     */
    MessageDTO updateMessageStatus(String tenantId, String messageId, MessageStatus status);

    /**
     * 标记消息为已读
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param messageId      消息ID(可选，为空时标记会话所有消息)
     */
    void markMessageAsRead(String tenantId, String userId, String conversationId, String messageId);

    /**
     * 获取未读消息数量
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID(可选)
     * @return 未读数量
     */
    Long getUnreadMessageCount(String tenantId, String userId, String conversationId);

    /**
     * 批量删除消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param messageIds     消息ID列表
     * @return 删除数量
     */
    Integer batchDeleteMessages(String tenantId, String conversationId, List<String> messageIds);

    /**
     * 清空会话消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return 删除数量
     */
    Integer clearConversationMessages(String tenantId, String conversationId);

    /**
     * 导出会话消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param format         导出格式(json/txt/markdown)
     * @return 导出内容
     */
    String exportConversationMessages(String tenantId, String conversationId, String format);

    /**
     * 获取消息引用链
     *
     * @param tenantId  租户ID
     * @param messageId 消息ID
     * @return 引用链消息列表
     */
    List<MessageDTO> getMessageQuoteChain(String tenantId, String messageId);

    /**
     * 添加消息反应(点赞/点踩等)
     *
     * @param tenantId     租户ID
     * @param userId       用户ID
     * @param messageId    消息ID
     * @param reactionType 反应类型
     */
    void addMessageReaction(String tenantId, String userId, String messageId, String reactionType);

    /**
     * 移除消息反应
     *
     * @param tenantId     租户ID
     * @param userId       用户ID
     * @param messageId    消息ID
     * @param reactionType 反应类型
     */
    void removeMessageReaction(String tenantId, String userId, String messageId, String reactionType);

    /**
     * 获取消息统计
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID(可选)
     * @param agentId        智能体ID(可选)
     * @param userId         用户ID(可选)
     * @return 统计信息
     */
    MessageStats getMessageStats(String tenantId, String conversationId, String agentId, String userId);

    /**
     * 清理过期消息
     *
     * @param expiredBefore 过期时间
     * @return 清理数量
     */
    Long cleanupExpiredMessages(LocalDateTime expiredBefore);

    /**
     * 消息统计信息
     */
    class MessageStats {
        private Long totalMessages;
        private Long userMessages;
        private Long assistantMessages;
        private Long systemMessages;
        private Long totalTokens;
        private Double avgResponseTime;
        private Double avgMessageLength;
        private Map<MessageType, Long> messagesByType;
        private Map<String, Long> messagesByHour;

        // Getter和Setter方法
        public Long getTotalMessages() { return totalMessages; }
        public void setTotalMessages(Long totalMessages) { this.totalMessages = totalMessages; }
        
        public Long getUserMessages() { return userMessages; }
        public void setUserMessages(Long userMessages) { this.userMessages = userMessages; }
        
        public Long getAssistantMessages() { return assistantMessages; }
        public void setAssistantMessages(Long assistantMessages) { this.assistantMessages = assistantMessages; }
        
        public Long getSystemMessages() { return systemMessages; }
        public void setSystemMessages(Long systemMessages) { this.systemMessages = systemMessages; }
        
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
        
        public Double getAvgResponseTime() { return avgResponseTime; }
        public void setAvgResponseTime(Double avgResponseTime) { this.avgResponseTime = avgResponseTime; }
        
        public Double getAvgMessageLength() { return avgMessageLength; }
        public void setAvgMessageLength(Double avgMessageLength) { this.avgMessageLength = avgMessageLength; }
        
        public Map<MessageType, Long> getMessagesByType() { return messagesByType; }
        public void setMessagesByType(Map<MessageType, Long> messagesByType) { this.messagesByType = messagesByType; }
        
        public Map<String, Long> getMessagesByHour() { return messagesByHour; }
        public void setMessagesByHour(Map<String, Long> messagesByHour) { this.messagesByHour = messagesByHour; }
    }
}