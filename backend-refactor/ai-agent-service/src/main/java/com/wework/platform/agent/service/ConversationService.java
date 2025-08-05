package com.wework.platform.agent.service;

import com.wework.platform.agent.dto.ConversationDTO;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.ConversationStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 对话会话服务接口
 */
public interface ConversationService {

    /**
     * 创建新会话
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param agentId  智能体ID
     * @param title    会话标题(可选)
     * @return 会话信息
     */
    ConversationDTO createConversation(String tenantId, String userId, String agentId, String title);

    /**
     * 更新会话信息
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param updates        更新字段
     * @return 会话信息
     */
    ConversationDTO updateConversation(String tenantId, String userId, String conversationId, 
                                     Map<String, Object> updates);

    /**
     * 删除会话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     */
    void deleteConversation(String tenantId, String userId, String conversationId);

    /**
     * 获取会话详情
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @return 会话信息
     */
    ConversationDTO getConversation(String tenantId, String userId, String conversationId);

    /**
     * 获取用户会话列表
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param pageNum  页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<ConversationDTO> getUserConversations(String tenantId, String userId, 
                                                   Integer pageNum, Integer pageSize);

    /**
     * 获取智能体的会话列表
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @param pageNum  页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<ConversationDTO> getAgentConversations(String tenantId, String agentId, 
                                                    Integer pageNum, Integer pageSize);

    /**
     * 搜索会话
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param keyword  关键词
     * @param pageNum  页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<ConversationDTO> searchConversations(String tenantId, String userId, String keyword,
                                                  Integer pageNum, Integer pageSize);

    /**
     * 更新会话状态
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param status         新状态
     * @return 会话信息
     */
    ConversationDTO updateConversationStatus(String tenantId, String conversationId, ConversationStatus status);

    /**
     * 置顶/取消置顶会话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param pinned         是否置顶
     * @return 会话信息
     */
    ConversationDTO pinConversation(String tenantId, String userId, String conversationId, Boolean pinned);

    /**
     * 收藏/取消收藏会话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param starred        是否收藏
     * @return 会话信息
     */
    ConversationDTO starConversation(String tenantId, String userId, String conversationId, Boolean starred);

    /**
     * 添加会话标签
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param tags           标签列表
     * @return 会话信息
     */
    ConversationDTO addConversationTags(String tenantId, String userId, String conversationId, List<String> tags);

    /**
     * 移除会话标签
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @param tags           标签列表
     * @return 会话信息
     */
    ConversationDTO removeConversationTags(String tenantId, String userId, String conversationId, List<String> tags);

    /**
     * 更新会话上下文
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param context        上下文数据
     */
    void updateConversationContext(String tenantId, String conversationId, Map<String, Object> context);

    /**
     * 获取会话上下文
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return 上下文数据
     */
    Map<String, Object> getConversationContext(String tenantId, String conversationId);

    /**
     * 清理会话上下文
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     */
    void clearConversationContext(String tenantId, String conversationId);

    /**
     * 归档会话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @return 会话信息
     */
    ConversationDTO archiveConversation(String tenantId, String userId, String conversationId);

    /**
     * 恢复归档会话
     *
     * @param tenantId       租户ID
     * @param userId         用户ID
     * @param conversationId 会话ID
     * @return 会话信息
     */
    ConversationDTO unarchiveConversation(String tenantId, String userId, String conversationId);

    /**
     * 获取会话统计信息
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @return 统计信息
     */
    ConversationStats getConversationStats(String tenantId, String userId);

    /**
     * 清理过期会话
     *
     * @param expiredBefore 过期时间
     * @return 清理数量
     */
    Long cleanupExpiredConversations(LocalDateTime expiredBefore);

    /**
     * 会话统计信息
     */
    class ConversationStats {
        private Long totalConversations;
        private Long activeConversations;
        private Long pinnedConversations;
        private Long starredConversations;
        private Long archivedConversations;
        private Double avgMessagesPerConversation;
        private Double avgDurationMinutes;

        // Getter和Setter方法
        public Long getTotalConversations() { return totalConversations; }
        public void setTotalConversations(Long totalConversations) { this.totalConversations = totalConversations; }
        
        public Long getActiveConversations() { return activeConversations; }
        public void setActiveConversations(Long activeConversations) { this.activeConversations = activeConversations; }
        
        public Long getPinnedConversations() { return pinnedConversations; }
        public void setPinnedConversations(Long pinnedConversations) { this.pinnedConversations = pinnedConversations; }
        
        public Long getStarredConversations() { return starredConversations; }
        public void setStarredConversations(Long starredConversations) { this.starredConversations = starredConversations; }
        
        public Long getArchivedConversations() { return archivedConversations; }
        public void setArchivedConversations(Long archivedConversations) { this.archivedConversations = archivedConversations; }
        
        public Double getAvgMessagesPerConversation() { return avgMessagesPerConversation; }
        public void setAvgMessagesPerConversation(Double avgMessagesPerConversation) { this.avgMessagesPerConversation = avgMessagesPerConversation; }
        
        public Double getAvgDurationMinutes() { return avgDurationMinutes; }
        public void setAvgDurationMinutes(Double avgDurationMinutes) { this.avgDurationMinutes = avgDurationMinutes; }
    }
}