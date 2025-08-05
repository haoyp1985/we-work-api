package com.wework.platform.agent.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.entity.Message;
import com.wework.platform.agent.enums.MessageStatus;
import com.wework.platform.agent.enums.MessageType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息数据访问接口
 */
@Mapper
public interface MessageRepository extends BaseMapper<Message> {

    /**
     * 分页查询消息列表
     *
     * @param page           分页参数
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param userId         用户ID
     * @param messageType    消息类型
     * @param status         消息状态
     * @return 分页结果
     */
    @Select({
        "<script>",
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId}",
        "AND deleted = 0",
        "<if test='conversationId != null and conversationId != \"\"'>",
        "AND conversation_id = #{conversationId}",
        "</if>",
        "<if test='userId != null and userId != \"\"'>",
        "AND user_id = #{userId}",
        "</if>",
        "<if test='messageType != null'>",
        "AND message_type = #{messageType}",
        "</if>",
        "<if test='status != null'>",
        "AND status = #{status}",
        "</if>",
        "ORDER BY sequence_number ASC, created_at ASC",
        "</script>"
    })
    IPage<Message> selectPageByConditions(Page<Message> page,
                                         @Param("tenantId") String tenantId,
                                         @Param("conversationId") String conversationId,
                                         @Param("userId") String userId,
                                         @Param("messageType") MessageType messageType,
                                         @Param("status") MessageStatus status);

    /**
     * 根据会话ID查询消息列表
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param limit          限制数量
     * @return 消息列表
     */
    @Select({
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId}",
        "AND deleted = 0",
        "ORDER BY sequence_number ASC, created_at ASC",
        "LIMIT #{limit}"
    })
    List<Message> selectByConversation(@Param("tenantId") String tenantId,
                                      @Param("conversationId") String conversationId,
                                      @Param("limit") Integer limit);

    /**
     * 根据会话ID查询最新的消息
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @param limit          限制数量
     * @return 最新消息列表
     */
    @Select({
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId}",
        "AND deleted = 0",
        "ORDER BY sequence_number DESC, created_at DESC",
        "LIMIT #{limit}"
    })
    List<Message> selectLatestByConversation(@Param("tenantId") String tenantId,
                                            @Param("conversationId") String conversationId,
                                            @Param("limit") Integer limit);

    /**
     * 根据会话ID和序号范围查询消息
     *
     * @param tenantId         租户ID
     * @param conversationId   会话ID
     * @param startSequence    开始序号
     * @param endSequence      结束序号
     * @return 消息列表
     */
    @Select({
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId}",
        "AND sequence_number BETWEEN #{startSequence} AND #{endSequence}",
        "AND deleted = 0",
        "ORDER BY sequence_number ASC"
    })
    List<Message> selectBySequenceRange(@Param("tenantId") String tenantId,
                                       @Param("conversationId") String conversationId,
                                       @Param("startSequence") Integer startSequence,
                                       @Param("endSequence") Integer endSequence);

    /**
     * 查询会话中的最大序号
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return 最大序号
     */
    @Select("SELECT COALESCE(MAX(sequence_number), 0) FROM messages WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId} AND deleted = 0")
    Integer selectMaxSequenceByConversation(@Param("tenantId") String tenantId,
                                           @Param("conversationId") String conversationId);

    /**
     * 查询失败的消息
     *
     * @param tenantId 租户ID
     * @param limit    限制数量
     * @return 失败消息列表
     */
    @Select({
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId}",
        "AND status IN ('FAILED', 'PROCESS_FAILED', 'TIMEOUT')",
        "AND deleted = 0",
        "ORDER BY created_at DESC",
        "LIMIT #{limit}"
    })
    List<Message> selectFailedMessages(@Param("tenantId") String tenantId,
                                      @Param("limit") Integer limit);

    /**
     * 查询处理中的消息
     *
     * @param tenantId 租户ID
     * @param timeoutMinutes 超时分钟数
     * @return 处理中消息列表
     */
    @Select({
        "SELECT * FROM messages",
        "WHERE tenant_id = #{tenantId}",
        "AND status = 'PROCESSING'",
        "AND created_at < DATE_SUB(NOW(), INTERVAL #{timeoutMinutes} MINUTE)",
        "AND deleted = 0",
        "ORDER BY created_at ASC"
    })
    List<Message> selectProcessingMessages(@Param("tenantId") String tenantId,
                                          @Param("timeoutMinutes") Integer timeoutMinutes);

    /**
     * 更新消息状态
     *
     * @param tenantId 租户ID
     * @param id       消息ID
     * @param status   新状态
     * @return 更新记录数
     */
    @Update("UPDATE messages SET status = #{status}, updated_at = NOW() WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0")
    int updateStatus(@Param("tenantId") String tenantId,
                    @Param("id") String id,
                    @Param("status") MessageStatus status);

    /**
     * 更新消息处理结果
     *
     * @param tenantId       租户ID
     * @param id             消息ID
     * @param status         状态
     * @param content        内容
     * @param tokens         Token数量
     * @param processTimeMs  处理时间
     * @return 更新记录数
     */
    @Update({
        "UPDATE messages SET",
        "status = #{status},",
        "content = #{content},",
        "tokens = #{tokens},",
        "process_time_ms = #{processTimeMs},",
        "received_at = NOW(),",
        "updated_at = NOW()",
        "WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0"
    })
    int updateProcessResult(@Param("tenantId") String tenantId,
                           @Param("id") String id,
                           @Param("status") MessageStatus status,
                           @Param("content") String content,
                           @Param("tokens") Integer tokens,
                           @Param("processTimeMs") Long processTimeMs);

    /**
     * 更新消息错误信息
     *
     * @param tenantId     租户ID
     * @param id           消息ID
     * @param status       状态
     * @param errorMessage 错误信息
     * @param retryCount   重试次数
     * @return 更新记录数
     */
    @Update({
        "UPDATE messages SET",
        "status = #{status},",
        "error_message = #{errorMessage},",
        "retry_count = #{retryCount},",
        "updated_at = NOW()",
        "WHERE tenant_id = #{tenantId} AND id = #{id} AND deleted = 0"
    })
    int updateError(@Param("tenantId") String tenantId,
                   @Param("id") String id,
                   @Param("status") MessageStatus status,
                   @Param("errorMessage") String errorMessage,
                   @Param("retryCount") Integer retryCount);

    /**
     * 统计会话消息数量
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return 消息数量
     */
    @Select("SELECT COUNT(*) FROM messages WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId} AND deleted = 0")
    int countByConversation(@Param("tenantId") String tenantId,
                           @Param("conversationId") String conversationId);

    /**
     * 统计会话Token消耗
     *
     * @param tenantId       租户ID
     * @param conversationId 会话ID
     * @return Token总数
     */
    @Select("SELECT COALESCE(SUM(tokens), 0) FROM messages WHERE tenant_id = #{tenantId} AND conversation_id = #{conversationId} AND deleted = 0")
    Long sumTokensByConversation(@Param("tenantId") String tenantId,
                                @Param("conversationId") String conversationId);

    /**
     * 统计消息数量
     *
     * @param tenantId 租户ID
     * @param agentId  智能体ID(可选)
     * @param userId   用户ID(可选)
     * @param startTime 开始时间(可选)
     * @param endTime   结束时间(可选)
     * @return 消息统计信息
     */
    @Select({
        "<script>",
        "SELECT",
        "COUNT(*) as total,",
        "SUM(CASE WHEN role = 'user' THEN 1 ELSE 0 END) as user_messages,",
        "SUM(CASE WHEN role = 'assistant' THEN 1 ELSE 0 END) as assistant_messages,",
        "SUM(CASE WHEN status IN ('SENT', 'DELIVERED', 'READ') THEN 1 ELSE 0 END) as success_messages,",
        "SUM(CASE WHEN status IN ('FAILED', 'PROCESS_FAILED', 'TIMEOUT') THEN 1 ELSE 0 END) as failed_messages,",
        "SUM(COALESCE(tokens, 0)) as total_tokens",
        "FROM messages",
        "WHERE tenant_id = #{tenantId}",
        "<if test='agentId != null and agentId != \"\"'>",
        "AND agent_id = #{agentId}",
        "</if>",
        "<if test='userId != null and userId != \"\"'>",
        "AND user_id = #{userId}",
        "</if>",
        "<if test='startTime != null'>",
        "AND created_at >= #{startTime}",
        "</if>",
        "<if test='endTime != null'>",
        "AND created_at <= #{endTime}",
        "</if>",
        "AND deleted = 0",
        "</script>"
    })
    MessageStatistics selectStatistics(@Param("tenantId") String tenantId,
                                      @Param("agentId") String agentId,
                                      @Param("userId") String userId,
                                      @Param("startTime") LocalDateTime startTime,
                                      @Param("endTime") LocalDateTime endTime);

    /**
     * 消息统计信息内部类
     */
    class MessageStatistics {
        private Long total;
        private Long userMessages;
        private Long assistantMessages;
        private Long successMessages;
        private Long failedMessages;
        private Long totalTokens;

        // getters and setters
        public Long getTotal() { return total; }
        public void setTotal(Long total) { this.total = total; }
        public Long getUserMessages() { return userMessages; }
        public void setUserMessages(Long userMessages) { this.userMessages = userMessages; }
        public Long getAssistantMessages() { return assistantMessages; }
        public void setAssistantMessages(Long assistantMessages) { this.assistantMessages = assistantMessages; }
        public Long getSuccessMessages() { return successMessages; }
        public void setSuccessMessages(Long successMessages) { this.successMessages = successMessages; }
        public Long getFailedMessages() { return failedMessages; }
        public void setFailedMessages(Long failedMessages) { this.failedMessages = failedMessages; }
        public Long getTotalTokens() { return totalTokens; }
        public void setTotalTokens(Long totalTokens) { this.totalTokens = totalTokens; }
    }
}