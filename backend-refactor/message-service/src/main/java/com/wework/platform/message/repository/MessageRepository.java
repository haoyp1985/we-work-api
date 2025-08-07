package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    Long countByAccountIdAndStatus(@Param("accountId") String accountId, @Param("sendStatus") Integer sendStatus);

    /**
     * 统计租户消息数量
     *
     * @param tenantId 租户ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 消息数量
     */
    Long countByTenantIdAndTimeRange(@Param("tenantId") String tenantId, 
                                    @Param("startTime") LocalDateTime startTime, 
                                    @Param("endTime") LocalDateTime endTime);

    /**
     * 查询待重试的消息
     *
     * @param limit 限制数量
     * @return 消息列表
     */
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