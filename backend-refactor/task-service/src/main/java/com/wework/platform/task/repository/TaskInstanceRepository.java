package com.wework.platform.task.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.enums.TaskStatus;
import com.wework.platform.task.entity.TaskInstance;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务实例数据访问层
 * 提供任务实例的CRUD操作和分布式调度相关功能
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Repository
@Mapper
public interface TaskInstanceRepository extends BaseMapper<TaskInstance> {

    /**
     * 分页查询任务实例
     * 
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @param status 任务状态
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 分页结果
     */
    @Select("<script>" +
            "SELECT * FROM task_instances " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='definitionId != null and definitionId != \"\"'>" +
            "AND definition_id = #{definitionId} " +
            "</if>" +
            "<if test='status != null and status != \"\"'>" +
            "AND status = #{status} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND created_at >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND created_at <= #{endTime} " +
            "</if>" +
            "ORDER BY created_at DESC" +
            "</script>")
    IPage<TaskInstance> selectPageByConditions(Page<TaskInstance> page,
                                              @Param("tenantId") String tenantId,
                                              @Param("definitionId") String definitionId,
                                              @Param("status") String status,
                                              @Param("startTime") LocalDateTime startTime,
                                              @Param("endTime") LocalDateTime endTime);

    /**
     * 查询准备执行的任务（分布式调度核心方法）
     * 
     * @param now 当前时间
     * @param limit 查询数量限制
     * @return 待执行任务列表
     */
    @Select("SELECT * FROM task_instances " +
            "WHERE status = 'PENDING' " +
            "AND scheduled_time <= #{now} " +
            "AND (lock_expires_at IS NULL OR lock_expires_at < #{now}) " +
            "ORDER BY priority DESC, scheduled_time ASC " +
            "LIMIT #{limit}")
    List<TaskInstance> findReadyTasks(@Param("now") LocalDateTime now, 
                                     @Param("limit") int limit);

    /**
     * 获取任务执行锁（基于数据库乐观锁）
     * 
     * @param taskId 任务ID
     * @param lockVersion 当前锁版本
     * @param nodeId 执行节点ID
     * @param lockedAt 锁定时间
     * @param lockExpiresAt 锁过期时间
     * @param status 更新后的状态
     * @return 更新行数（>0表示获取锁成功）
     */
    @Update("UPDATE task_instances SET " +
            "execution_node = #{nodeId}, " +
            "locked_at = #{lockedAt}, " +
            "lock_expires_at = #{lockExpiresAt}, " +
            "status = #{status}, " +
            "lock_version = lock_version + 1, " +
            "start_time = #{lockedAt} " +
            "WHERE id = #{taskId} " +
            "AND lock_version = #{lockVersion} " +
            "AND (execution_node IS NULL OR lock_expires_at < #{lockedAt})")
    int acquireTaskLock(@Param("taskId") String taskId,
                       @Param("lockVersion") Integer lockVersion,
                       @Param("nodeId") String nodeId,
                       @Param("lockedAt") LocalDateTime lockedAt,
                       @Param("lockExpiresAt") LocalDateTime lockExpiresAt,
                       @Param("status") TaskStatus status);

    /**
     * 释放任务锁
     * 
     * @param taskId 任务ID
     * @param nodeId 执行节点ID
     * @param status 最终状态
     * @param endTime 结束时间
     * @param resultData 执行结果
     * @param errorMessage 错误信息
     * @return 更新行数
     */
    @Update("UPDATE task_instances SET " +
            "status = #{status}, " +
            "end_time = #{endTime}, " +
            "lock_expires_at = NULL, " +
            "result_data = #{resultData}, " +
            "error_message = #{errorMessage} " +
            "WHERE id = #{taskId} AND execution_node = #{nodeId}")
    int releaseTaskLock(@Param("taskId") String taskId,
                       @Param("nodeId") String nodeId,
                       @Param("status") TaskStatus status,
                       @Param("endTime") LocalDateTime endTime,
                       @Param("resultData") String resultData,
                       @Param("errorMessage") String errorMessage);

    /**
     * 更新任务重试信息
     * 
     * @param taskId 任务ID
     * @param retryCount 重试次数
     * @param nextRetryTime 下次重试时间
     * @param status 任务状态
     * @return 更新行数
     */
    @Update("UPDATE task_instances SET " +
            "retry_count = #{retryCount}, " +
            "next_retry_time = #{nextRetryTime}, " +
            "status = #{status}, " +
            "lock_expires_at = NULL " +
            "WHERE id = #{taskId}")
    int updateRetryInfo(@Param("taskId") String taskId,
                       @Param("retryCount") Integer retryCount,
                       @Param("nextRetryTime") LocalDateTime nextRetryTime,
                       @Param("status") TaskStatus status);

    /**
     * 查询需要重试的任务
     * 
     * @param now 当前时间
     * @param limit 查询数量限制
     * @return 需要重试的任务列表
     */
    @Select("SELECT * FROM task_instances " +
            "WHERE status = 'WAITING_RETRY' " +
            "AND next_retry_time <= #{now} " +
            "AND (lock_expires_at IS NULL OR lock_expires_at < #{now}) " +
            "ORDER BY next_retry_time ASC " +
            "LIMIT #{limit}")
    List<TaskInstance> findRetryTasks(@Param("now") LocalDateTime now, 
                                     @Param("limit") int limit);

    /**
     * 查询过期锁的任务（用于故障恢复）
     * 
     * @param expireTime 过期时间点
     * @param limit 查询数量限制
     * @return 锁过期的任务列表
     */
    @Select("SELECT * FROM task_instances " +
            "WHERE status = 'RUNNING' " +
            "AND lock_expires_at < #{expireTime} " +
            "ORDER BY lock_expires_at ASC " +
            "LIMIT #{limit}")
    List<TaskInstance> findExpiredLockTasks(@Param("expireTime") LocalDateTime expireTime,
                                           @Param("limit") int limit);

    /**
     * 重置过期锁的任务状态
     * 
     * @param taskId 任务ID
     * @param originalNode 原执行节点
     * @return 更新行数
     */
    @Update("UPDATE task_instances SET " +
            "status = 'PENDING', " +
            "execution_node = NULL, " +
            "locked_at = NULL, " +
            "lock_expires_at = NULL " +
            "WHERE id = #{taskId} " +
            "AND execution_node = #{originalNode} " +
            "AND status = 'RUNNING'")
    int resetExpiredTask(@Param("taskId") String taskId,
                        @Param("originalNode") String originalNode);

    /**
     * 统计任务状态分布
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID（可选）
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 状态统计结果
     */
    @Select("<script>" +
            "SELECT status, COUNT(*) as count " +
            "FROM task_instances " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='definitionId != null and definitionId != \"\"'>" +
            "AND definition_id = #{definitionId} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND created_at >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND created_at <= #{endTime} " +
            "</if>" +
            "GROUP BY status" +
            "</script>")
    @Results({
            @Result(column = "status", property = "status"),
            @Result(column = "count", property = "count")
    })
    List<TaskStatusStat> getStatusStatistics(@Param("tenantId") String tenantId,
                                           @Param("definitionId") String definitionId,
                                           @Param("startTime") LocalDateTime startTime,
                                           @Param("endTime") LocalDateTime endTime);

    /**
     * 批量取消任务
     * 
     * @param tenantId 租户ID
     * @param taskIds 任务ID列表
     * @return 更新行数
     */
    @Update("<script>" +
            "UPDATE task_instances SET " +
            "status = 'CANCELLED', " +
            "end_time = NOW(), " +
            "lock_expires_at = NULL " +
            "WHERE tenant_id = #{tenantId} " +
            "AND status IN ('PENDING', 'WAITING_RETRY') " +
            "AND id IN " +
            "<foreach collection='taskIds' item='taskId' open='(' separator=',' close=')'>" +
            "#{taskId}" +
            "</foreach>" +
            "</script>")
    int batchCancelTasks(@Param("tenantId") String tenantId,
                        @Param("taskIds") List<String> taskIds);

    /**
     * 清理历史任务实例
     * 
     * @param tenantId 租户ID
     * @param beforeTime 清理时间点
     * @param keepCount 每个任务定义保留的最新实例数
     * @return 删除行数
     */
    @Delete("DELETE t1 FROM task_instances t1 " +
            "WHERE t1.tenant_id = #{tenantId} " +
            "AND t1.created_at < #{beforeTime} " +
            "AND t1.status IN ('SUCCESS', 'FAILED', 'CANCELLED') " +
            "AND (" +
            "  SELECT COUNT(*) FROM task_instances t2 " +
            "  WHERE t2.definition_id = t1.definition_id " +
            "  AND t2.tenant_id = t1.tenant_id " +
            "  AND t2.created_at > t1.created_at" +
            ") >= #{keepCount}")
    int cleanHistoryInstances(@Param("tenantId") String tenantId,
                             @Param("beforeTime") LocalDateTime beforeTime,
                             @Param("keepCount") int keepCount);

    /**
     * 任务状态统计结果类
     */
    class TaskStatusStat {
        private String status;
        private Long count;

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Long getCount() {
            return count;
        }

        public void setCount(Long count) {
            this.count = count;
        }
    }
}