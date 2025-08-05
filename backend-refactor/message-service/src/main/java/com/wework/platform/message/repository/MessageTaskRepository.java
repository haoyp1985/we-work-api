package com.wework.platform.message.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.message.entity.MessageTask;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
    @Select("SELECT * FROM message_tasks " +
            "WHERE task_status = 0 " +
            "AND schedule_time <= NOW() " +
            "AND deleted_at IS NULL " +
            "ORDER BY schedule_time ASC " +
            "LIMIT #{limit}")
    List<MessageTask> findPendingTasks(@Param("limit") Integer limit);

    /**
     * 查询需要重试的任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
    @Select("SELECT * FROM message_tasks " +
            "WHERE task_status = 4 " +
            "AND execute_count < max_execute_count " +
            "AND deleted_at IS NULL " +
            "ORDER BY updated_at ASC " +
            "LIMIT #{limit}")
    List<MessageTask> findTasksForRetry(@Param("limit") Integer limit);

    /**
     * 查询周期性任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
    @Select("SELECT * FROM message_tasks " +
            "WHERE task_type = 3 " +
            "AND task_status IN (0, 2) " +
            "AND next_execute_time <= NOW() " +
            "AND (max_execute_count IS NULL OR execute_count < max_execute_count) " +
            "AND deleted_at IS NULL " +
            "ORDER BY next_execute_time ASC " +
            "LIMIT #{limit}")
    List<MessageTask> findPeriodicTasks(@Param("limit") Integer limit);

    /**
     * 更新任务状态
     *
     * @param id 任务ID
     * @param taskStatus 任务状态
     * @param errorMessage 错误信息
     * @return 更新数量
     */
    @Update("UPDATE message_tasks SET " +
            "task_status = #{taskStatus}, " +
            "error_message = #{errorMessage}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
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
    @Update("UPDATE message_tasks SET " +
            "task_status = #{taskStatus}, " +
            "progress = #{progress}, " +
            "sent_count = #{sentCount}, " +
            "success_count = #{successCount}, " +
            "fail_count = #{failCount}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
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
    @Update("UPDATE message_tasks SET " +
            "start_time = NOW(), " +
            "task_status = 1, " +
            "execute_count = execute_count + 1, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateTaskStartTime(@Param("id") String id);

    /**
     * 更新任务完成时间
     *
     * @param id 任务ID
     * @return 更新数量
     */
    @Update("UPDATE message_tasks SET " +
            "complete_time = NOW(), " +
            "task_status = 2, " +
            "progress = 100, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateTaskCompleteTime(@Param("id") String id);

    /**
     * 更新周期任务下次执行时间
     *
     * @param id 任务ID
     * @param nextExecuteTime 下次执行时间
     * @return 更新数量
     */
    @Update("UPDATE message_tasks SET " +
            "next_execute_time = #{nextExecuteTime}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int updateNextExecuteTime(@Param("id") String id,
                             @Param("nextExecuteTime") LocalDateTime nextExecuteTime);

    /**
     * 统计任务数量
     *
     * @param tenantId 租户ID
     * @param taskStatus 任务状态
     * @return 任务数量
     */
    @Select("SELECT COUNT(*) FROM message_tasks " +
            "WHERE tenant_id = #{tenantId} AND task_status = #{taskStatus} AND deleted_at IS NULL")
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
    @Select("<script>" +
            "SELECT " +
            "COUNT(*) as totalTasks, " +
            "SUM(CASE WHEN task_status = 2 THEN 1 ELSE 0 END) as completedTasks, " +
            "SUM(CASE WHEN task_status = 4 THEN 1 ELSE 0 END) as failedTasks, " +
            "SUM(total_count) as totalMessages, " +
            "SUM(success_count) as successMessages, " +
            "SUM(fail_count) as failMessages " +
            "FROM message_tasks " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='startTime != null'>" +
            "  AND created_at >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "  AND created_at <= #{endTime} " +
            "</if>" +
            "AND deleted_at IS NULL" +
            "</script>")
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