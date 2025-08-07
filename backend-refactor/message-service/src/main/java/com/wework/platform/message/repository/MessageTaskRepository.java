package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.MessageTask;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息任务数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface MessageTaskRepository extends BaseMapper<MessageTask> {

    /**
     * 查询待执行的任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
        List<MessageTask> findPendingTasks(@Param("limit") Integer limit);

    /**
     * 查询需要重试的任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
        List<MessageTask> findTasksForRetry(@Param("limit") Integer limit);

    /**
     * 查询周期性任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
        List<MessageTask> findPeriodicTasks(@Param("limit") Integer limit);

    /**
     * 更新任务状态
     *
     * @param id 任务ID
     * @param taskStatus 任务状态
     * @param errorMessage 错误信息
     * @return 更新数量
     */
        int updateTaskStatus(@Param("id") String id,
                        @Param("taskStatus") Integer taskStatus,
                        @Param("errorMessage") String errorMessage);

    /**
     * 更新任务执行信息
     *
     * @param id 任务ID
     * @param taskStatus 任务状态
     * @param progress 进度
     * @param sentCount 已发送数量
     * @param successCount 成功数量
     * @param failCount 失败数量
     * @return 更新数量
     */
        int updateTaskProgress(@Param("id") String id,
                          @Param("taskStatus") Integer taskStatus,
                          @Param("progress") Integer progress,
                          @Param("sentCount") Integer sentCount,
                          @Param("successCount") Integer successCount,
                          @Param("failCount") Integer failCount);

    /**
     * 更新任务开始执行时间
     *
     * @param id 任务ID
     * @return 更新数量
     */
        int updateTaskStartTime(@Param("id") String id);

    /**
     * 更新任务完成时间
     *
     * @param id 任务ID
     * @return 更新数量
     */
        int updateTaskCompleteTime(@Param("id") String id);

    /**
     * 更新周期任务下次执行时间
     *
     * @param id 任务ID
     * @param nextExecuteTime 下次执行时间
     * @return 更新数量
     */
        int updateNextExecuteTime(@Param("id") String id,
                             @Param("nextExecuteTime") LocalDateTime nextExecuteTime);

    /**
     * 统计任务数量
     *
     * @param tenantId 租户ID
     * @param taskStatus 任务状态
     * @return 任务数量
     */
        Long countByTenantIdAndStatus(@Param("tenantId") String tenantId,
                                 @Param("taskStatus") Integer taskStatus);

    /**
     * 获取任务统计信息
     *
     * @param tenantId 租户ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
        TaskStatistics getTaskStatistics(@Param("tenantId") String tenantId,
                                    @Param("startTime") LocalDateTime startTime,
                                    @Param("endTime") LocalDateTime endTime);

    /**
     * 任务统计信息
     */
    class TaskStatistics {
        private Long totalTasks;
        private Long completedTasks;
        private Long failedTasks;
        private Long totalMessages;
        private Long successMessages;
        private Long failMessages;

        // Getters and Setters
        public Long getTotalTasks() { return totalTasks; }
        public void setTotalTasks(Long totalTasks) { this.totalTasks = totalTasks; }
        public Long getCompletedTasks() { return completedTasks; }
        public void setCompletedTasks(Long completedTasks) { this.completedTasks = completedTasks; }
        public Long getFailedTasks() { return failedTasks; }
        public void setFailedTasks(Long failedTasks) { this.failedTasks = failedTasks; }
        public Long getTotalMessages() { return totalMessages; }
        public void setTotalMessages(Long totalMessages) { this.totalMessages = totalMessages; }
        public Long getSuccessMessages() { return successMessages; }
        public void setSuccessMessages(Long successMessages) { this.successMessages = successMessages; }
        public Long getFailMessages() { return failMessages; }
        public void setFailMessages(Long failMessages) { this.failMessages = failMessages; }
    }
}