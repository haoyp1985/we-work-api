package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.Conversation;
import com.wework.platform.agent.enums.ConversationStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
    @Select({
        "<script>",
        "SELECT * FROM conversations",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='userId != null and userId != \"\"'>",
        "AND user_id = #{userId}",
        "</if>",
        "<if test='agentId != null and agentId != \"\"'>",
        "AND agent_id = #{agentId}",
        "</if>",
        "<if test='status != null'>",
        "AND status = #{status}",
        "</if>",
        "<if test='title != null and title != \"\"'>",
        "AND title LIKE CONCAT('%', #{title}, '%')",
        "</if>",
        "ORDER BY pinned DESC, last_message_at DESC, created_at DESC",
        "</script>"
    })
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
    @Select({
        "SELECT * FROM conversations",
        "WHERE tenant_id = #{tenantId} AND user_id = #{userId}",
        "AND status IN ('ACTIVE', 'WAITING_USER', 'WAITING_AI', 'PROCESSING')",
        "AND deleted = 0",
        "ORDER BY last_message_at DESC",
        "LIMIT #{limit}"
    })
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
    @Select({
        "SELECT * FROM conversations",
        "WHERE tenant_id = #{tenantId} AND agent_id = #{agentId}",
        "AND deleted = 0",
        "ORDER BY last_message_at DESC",
        "LIMIT #{limit}"
    })
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
    @Select({
        "SELECT * FROM conversations",
        "WHERE tenant_id = #{tenantId} AND user_id = #{userId}",
        "AND starred = 1 AND deleted = 0",
        "ORDER BY last_message_at DESC"
    })
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
    @Update("UPDATE conversations SET status = #{status}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Update("UPDATE conversations SET last_message_at = #{lastMessageAt}, message_count = #{messageCount}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Update("UPDATE conversations SET total_tokens = #{totalTokens}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Update("UPDATE conversations SET pinned = #{pinned}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Update("UPDATE conversations SET starred = #{starred}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
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
    @Select({
        "<script>",
        "SELECT",
        "COUNT(*) as total,",
        "SUM(CASE WHEN status IN ('ACTIVE', 'WAITING_USER', 'WAITING_AI', 'PROCESSING') THEN 1 ELSE 0 END) as active_count,",
        "SUM(CASE WHEN starred = 1 THEN 1 ELSE 0 END) as starred_count,",
        "SUM(message_count) as total_messages,",
        "SUM(total_tokens) as total_tokens",
        "FROM conversations",
        "WHERE tenant_id = #{tenantId}",
        "<if test='userId != null and userId != \"\"'>",
        "AND user_id = #{userId}",
        "</if>",
        "AND deleted = 0",
        "</script>"
    })
    ConversationStatistics selectStatistics(@Param("tenantId") String tenantId,
                                           @Param("userId") String userId);

    /**
     * 查询超时的会话
     *
     * @param timeoutMinutes 超时分钟数
     * @param limit          限制数量
     * @return 超时会话列表
     */
    @Select({
        "SELECT * FROM conversations",
        "WHERE status IN ('WAITING_AI', 'PROCESSING')",
        "AND last_message_at < DATE_SUB(NOW(), INTERVAL #{timeoutMinutes} MINUTE)",
        "AND deleted = 0",
        "ORDER BY last_message_at ASC",
        "LIMIT #{limit}"
    })
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