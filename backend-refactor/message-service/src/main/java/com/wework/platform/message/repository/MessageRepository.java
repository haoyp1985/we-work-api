package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface MessageRepository extends BaseMapper<Message> {

    /**
     * 统计账号消息数量
     *
     * @param accountId 账号ID
     * @param sendStatus 发送状态
     * @return 消息数量
     */
    @Select("SELECT COUNT(*) FROM messages WHERE account_id = #{accountId} AND send_status = #{sendStatus} AND deleted_at IS NULL")
    Long countByAccountIdAndStatus(@Param("accountId") String accountId, @Param("sendStatus") Integer sendStatus);

    /**
     * 统计租户消息数量
     *
     * @param tenantId 租户ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 消息数量
     */
    @Select("SELECT COUNT(*) FROM messages WHERE tenant_id = #{tenantId} " +
            "AND send_time >= #{startTime} AND send_time <= #{endTime} AND deleted_at IS NULL")
    Long countByTenantIdAndTimeRange(@Param("tenantId") String tenantId, 
                                    @Param("startTime") LocalDateTime startTime, 
                                    @Param("endTime") LocalDateTime endTime);

    /**
     * 查询待重试的消息
     *
     * @param limit 限制数量
     * @return 消息列表
     */
    @Select("SELECT * FROM messages WHERE send_status = 3 " +
            "AND retry_count < max_retry_count " +
            "AND next_retry_time <= NOW() " +
            "AND deleted_at IS NULL " +
            "ORDER BY next_retry_time ASC LIMIT #{limit}")
    List<Message> findMessagesForRetry(@Param("limit") Integer limit);

    /**
     * 更新消息状态
     *
     * @param id 消息ID
     * @param sendStatus 发送状态
     * @param errorCode 错误码
     * @param errorMessage 错误信息
     * @return 更新数量
     */
    @Update("UPDATE messages SET send_status = #{sendStatus}, " +
            "error_code = #{errorCode}, error_message = #{errorMessage}, " +
            "complete_time = NOW(), updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateMessageStatus(@Param("id") String id, 
                          @Param("sendStatus") Integer sendStatus,
                          @Param("errorCode") String errorCode, 
                          @Param("errorMessage") String errorMessage);

    /**
     * 更新重试信息
     *
     * @param id 消息ID
     * @param retryCount 重试次数
     * @param nextRetryTime 下次重试时间
     * @return 更新数量
     */
    @Update("UPDATE messages SET retry_count = #{retryCount}, " +
            "next_retry_time = #{nextRetryTime}, updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateRetryInfo(@Param("id") String id, 
                       @Param("retryCount") Integer retryCount,
                       @Param("nextRetryTime") LocalDateTime nextRetryTime);

    /**
     * 批量更新任务消息状态
     *
     * @param taskId 任务ID
     * @param sendStatus 发送状态
     * @return 更新数量
     */
    @Update("UPDATE messages SET send_status = #{sendStatus}, updated_at = NOW() " +
            "WHERE task_id = #{taskId} AND send_status = 0")
    int updateTaskMessagesStatus(@Param("taskId") String taskId, @Param("sendStatus") Integer sendStatus);

    /**
     * 获取消息发送统计
     *
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    @Select("<script>" +
            "SELECT " +
            "COUNT(*) as totalCount, " +
            "SUM(CASE WHEN send_status = 2 THEN 1 ELSE 0 END) as successCount, " +
            "SUM(CASE WHEN send_status = 3 THEN 1 ELSE 0 END) as failCount, " +
            "SUM(CASE WHEN send_status IN (0,1) THEN 1 ELSE 0 END) as pendingCount " +
            "FROM messages " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='accountId != null'>" +
            "  AND account_id = #{accountId} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "  AND send_time >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "  AND send_time <= #{endTime} " +
            "</if>" +
            "AND deleted_at IS NULL" +
            "</script>")
    MessageStatistics getMessageStatistics(@Param("tenantId") String tenantId,
                                          @Param("accountId") String accountId,
                                          @Param("startTime") LocalDateTime startTime,
                                          @Param("endTime") LocalDateTime endTime);

    /**
     * 消息统计信息
     */
    class MessageStatistics {
        private Long totalCount;
        private Long successCount;
        private Long failCount;
        private Long pendingCount;

        // Getters and Setters
        public Long getTotalCount() { return totalCount; }
        public void setTotalCount(Long totalCount) { this.totalCount = totalCount; }
        public Long getSuccessCount() { return successCount; }
        public void setSuccessCount(Long successCount) { this.successCount = successCount; }
        public Long getFailCount() { return failCount; }
        public void setFailCount(Long failCount) { this.failCount = failCount; }
        public Long getPendingCount() { return pendingCount; }
        public void setPendingCount(Long pendingCount) { this.pendingCount = pendingCount; }
    }
}