package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.Conversation;
import com.wework.platform.agent.enums.ConversationStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 对话会话数据访问接口
 */
@Mapper
public interface ConversationRepository extends BaseMapper<Conversation> {

    /**
     * 分页查询会话列表
     *
     * @param page    分页参数
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param agentId  智能体ID
     * @param status   会话状态
     * @param title    标题(模糊匹配)
     * @return 分页结果
     */
        IPage<Conversation> selectPageByConditions(Page<Conversation> page,
                                              @Param("tenantId") String tenantId,
                                              @Param("userId") String userId,
                                              @Param("agentId") String agentId,
                                              @Param("status") ConversationStatus status,
                                              @Param("title") String title);

    /**
     * 根据用户ID查询活跃会话列表
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @param limit    限制数量
     * @return 活跃会话列表
     */
        List<Conversation> selectActiveByUser(@Param("tenantId") String tenantId,
                                         @Param("userId") String userId,
                                         @Param("limit") Integer limit);

    /**
     * 根据智能体ID查询会话列表
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID
     * @param limit    限制数量
     * @return 会话列表
     */
        List<Conversation> selectByAgent(@Param("tenantId") String tenantId,
                                    @Param("agentId") String agentId,
                                    @Param("limit") Integer limit);

    /**
     * 查询用户收藏的会话
     *
     * @param tenantId 租户ID
     * @param userId   用户ID
     * @return 收藏的会话列表
     */
        List<Conversation> selectStarredByUser(@Param("tenantId") String tenantId,
                                          @Param("userId") String userId);

    /**
     * 更新会话状态
     *
     * @param tenantId 租户ID
     * @param id       会话ID
     * @param status   新状态
     * @return 更新记录数
     */
        int updateStatus(@Param("tenantId") String tenantId,
                    @Param("id") String id,
                    @Param("status") ConversationStatus status);

    /**
     * 更新会话最后消息时间和消息数量
     *
     * @param tenantId        租户ID
     * @param id              会话ID
     * @param lastMessageAt   最后消息时间
     * @param messageCount    消息数量
     * @return 更新记录数
     */
        int updateMessageInfo(@Param("tenantId") String tenantId,
                         @Param("id") String id,
                         @Param("lastMessageAt") LocalDateTime lastMessageAt,
                         @Param("messageCount") Integer messageCount);

    /**
     * 更新会话Token消耗
     *
     * @param tenantId    租户ID
     * @param id          会话ID
     * @param totalTokens 总Token数
     * @return 更新记录数
     */
        int updateTokens(@Param("tenantId") String tenantId,
                    @Param("id") String id,
                    @Param("totalTokens") Long totalTokens);

    /**
     * 设置会话置顶状态
     *
     * @param tenantId 租户ID
     * @param id       会话ID
     * @param pinned   是否置顶
     * @return 更新记录数
     */
        int updatePinned(@Param("tenantId") String tenantId,
                    @Param("id") String id,
                    @Param("pinned") Boolean pinned);

    /**
     * 设置会话收藏状态
     *
     * @param tenantId 租户ID
     * @param id       会话ID
     * @param starred  是否收藏
     * @return 更新记录数
     */
        int updateStarred(@Param("tenantId") String tenantId,
                     @Param("id") String id,
                     @Param("starred") Boolean starred);

    /**
     * 统计会话数量
     *
     * @param tenantId 租户ID
     * @param userId   用户ID(可选)
     * @return 会话统计信息
     */
        ConversationStatistics selectStatistics(@Param("tenantId") String tenantId,
                                           @Param("userId") String userId);

    /**
     * 查询超时的会话
     *
     * @param timeoutMinutes 超时分钟数
     * @param limit          限制数量
     * @return 超时会话列表
     */
        List<Conversation> selectTimeoutConversations(@Param("timeoutMinutes") Integer timeoutMinutes,
                                                 @Param("limit") Integer limit);

    /**
     * 会话统计信息内部类
     */
    class ConversationStatistics {
        private Long total;
        private Long activeCount;
        private Long starredCount;
        private Long totalMessages;
        private Long totalTokens;

        // getters and setters
        public Long getTotal() { return total; }
        public void setTotal(Long total) { this.total = total; }
        public Long getActiveCount() { return activeCount; }
        public void setActiveCount(Long activeCount) { this.activeCount = activeCount; }
        public Long getStarredCount() { return starredCount; }
        public void setStarredCount(Long starredCount) { this.starredCount = starredCount; }
        public Long getTotalMessages() { return totalMessages; }
        public void setTotalMessages(Long totalMessages) { this.totalMessages = totalMessages; }
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
    }
}