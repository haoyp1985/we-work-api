package com.wework.platform.task.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.task.entity.TaskLog;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务日志数据访问层
 * 提供任务执行日志的存储和查询功能
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Repository
@Mapper
public interface TaskLogRepository extends BaseMapper<TaskLog> {

    /**
     * 分页查询任务日志
     * 
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param instanceId 任务实例ID
     * @param logLevel 日志级别
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 分页结果
     */
    @Select("<script>" +
            "SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='instanceId != null and instanceId != \"\"'>" +
            "AND instance_id = #{instanceId} " +
            "</if>" +
            "<if test='logLevel != null and logLevel != \"\"'>" +
            "AND log_level = #{logLevel} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND log_time >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND log_time <= #{endTime} " +
            "</if>" +
            "ORDER BY log_time DESC" +
            "</script>")
    IPage<TaskLog> selectPageByConditions(Page<TaskLog> page,
                                         @Param("tenantId") String tenantId,
                                         @Param("instanceId") String instanceId,
                                         @Param("logLevel") String logLevel,
                                         @Param("startTime") LocalDateTime startTime,
                                         @Param("endTime") LocalDateTime endTime);

    /**
     * 根据任务实例ID查询日志
     * 
     * @param tenantId 租户ID
     * @param instanceId 任务实例ID
     * @return 日志列表
     */
    @Select("SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND instance_id = #{instanceId} " +
            "ORDER BY log_time ASC")
    List<TaskLog> findByInstanceId(@Param("tenantId") String tenantId,
                                  @Param("instanceId") String instanceId);

    /**
     * 查询任务实例的错误日志
     * 
     * @param tenantId 租户ID
     * @param instanceId 任务实例ID
     * @return 错误日志列表
     */
    @Select("SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND instance_id = #{instanceId} " +
            "AND log_level = 'ERROR' " +
            "ORDER BY log_time DESC")
    List<TaskLog> findErrorLogsByInstanceId(@Param("tenantId") String tenantId,
                                           @Param("instanceId") String instanceId);

    /**
     * 批量插入日志
     * 
     * @param logs 日志列表
     * @return 插入行数
     */
    @Insert("<script>" +
            "INSERT INTO task_logs " +
            "(id, tenant_id, instance_id, log_level, log_content, exception_stack, " +
            "execution_node, execution_step, extra_data, log_time, created_at) " +
            "VALUES " +
            "<foreach collection='logs' item='log' separator=','>" +
            "(#{log.id}, #{log.tenantId}, #{log.instanceId}, #{log.logLevel}, " +
            "#{log.logContent}, #{log.exceptionStack}, #{log.executionNode}, " +
            "#{log.executionStep}, #{log.extraData}, #{log.logTime}, #{log.createdAt})" +
            "</foreach>" +
            "</script>")
    int batchInsert(@Param("logs") List<TaskLog> logs);

    /**
     * 统计日志级别分布
     * 
     * @param tenantId 租户ID
     * @param instanceId 任务实例ID（可选）
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 级别统计结果
     */
    @Select("<script>" +
            "SELECT log_level, COUNT(*) as count " +
            "FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='instanceId != null and instanceId != \"\"'>" +
            "AND instance_id = #{instanceId} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND log_time >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND log_time <= #{endTime} " +
            "</if>" +
            "GROUP BY log_level" +
            "</script>")
    @Results({
            @Result(column = "log_level", property = "logLevel"),
            @Result(column = "count", property = "count")
    })
    List<LogLevelStat> getLogLevelStatistics(@Param("tenantId") String tenantId,
                                           @Param("instanceId") String instanceId,
                                           @Param("startTime") LocalDateTime startTime,
                                           @Param("endTime") LocalDateTime endTime);

    /**
     * 查询最近的错误日志
     * 
     * @param tenantId 租户ID
     * @param limit 查询数量限制
     * @return 最近错误日志列表
     */
    @Select("SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND log_level = 'ERROR' " +
            "ORDER BY log_time DESC " +
            "LIMIT #{limit}")
    List<TaskLog> findRecentErrorLogs(@Param("tenantId") String tenantId,
                                     @Param("limit") int limit);

    /**
     * 清理历史日志
     * 
     * @param tenantId 租户ID
     * @param beforeTime 清理时间点
     * @param keepErrorLogs 是否保留错误日志
     * @return 删除行数
     */
    @Delete("<script>" +
            "DELETE FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND log_time < #{beforeTime} " +
            "<if test='keepErrorLogs'>" +
            "AND log_level != 'ERROR' " +
            "</if>" +
            "</script>")
    int cleanHistoryLogs(@Param("tenantId") String tenantId,
                        @Param("beforeTime") LocalDateTime beforeTime,
                        @Param("keepErrorLogs") boolean keepErrorLogs);

    /**
     * 根据执行节点查询日志
     * 
     * @param tenantId 租户ID
     * @param executionNode 执行节点
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 日志列表
     */
    @Select("SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND execution_node = #{executionNode} " +
            "AND log_time BETWEEN #{startTime} AND #{endTime} " +
            "ORDER BY log_time DESC")
    List<TaskLog> findByExecutionNode(@Param("tenantId") String tenantId,
                                     @Param("executionNode") String executionNode,
                                     @Param("startTime") LocalDateTime startTime,
                                     @Param("endTime") LocalDateTime endTime);

    /**
     * 搜索日志内容
     * 
     * @param tenantId 租户ID
     * @param keyword 关键词
     * @param logLevel 日志级别（可选）
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param limit 查询数量限制
     * @return 日志列表
     */
    @Select("<script>" +
            "SELECT * FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND log_content LIKE CONCAT('%', #{keyword}, '%') " +
            "<if test='logLevel != null and logLevel != \"\"'>" +
            "AND log_level = #{logLevel} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND log_time >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND log_time <= #{endTime} " +
            "</if>" +
            "ORDER BY log_time DESC " +
            "LIMIT #{limit}" +
            "</script>")
    List<TaskLog> searchLogs(@Param("tenantId") String tenantId,
                            @Param("keyword") String keyword,
                            @Param("logLevel") String logLevel,
                            @Param("startTime") LocalDateTime startTime,
                            @Param("endTime") LocalDateTime endTime,
                            @Param("limit") int limit);

    /**
     * 获取任务实例的执行摘要
     * 
     * @param tenantId 租户ID
     * @param instanceId 任务实例ID
     * @return 执行摘要
     */
    @Select("SELECT " +
            "COUNT(*) as total_logs, " +
            "SUM(CASE WHEN log_level = 'ERROR' THEN 1 ELSE 0 END) as error_count, " +
            "SUM(CASE WHEN log_level = 'WARN' THEN 1 ELSE 0 END) as warn_count, " +
            "MIN(log_time) as first_log_time, " +
            "MAX(log_time) as last_log_time " +
            "FROM task_logs " +
            "WHERE tenant_id = #{tenantId} " +
            "AND instance_id = #{instanceId}")
    @Results({
            @Result(column = "total_logs", property = "totalLogs"),
            @Result(column = "error_count", property = "errorCount"),
            @Result(column = "warn_count", property = "warnCount"),
            @Result(column = "first_log_time", property = "firstLogTime"),
            @Result(column = "last_log_time", property = "lastLogTime")
    })
    ExecutionSummary getExecutionSummary(@Param("tenantId") String tenantId,
                                        @Param("instanceId") String instanceId);

    /**
     * 日志级别统计结果类
     */
    class LogLevelStat {
        private String logLevel;
        private Long count;

        public String getLogLevel() {
            return logLevel;
        }

        public void setLogLevel(String logLevel) {
            this.logLevel = logLevel;
        }

        public Long getCount() {
            return count;
        }

        public void setCount(Long count) {
            this.count = count;
        }
    }

    /**
     * 执行摘要结果类
     */
    class ExecutionSummary {
        private Long totalLogs;
        private Long errorCount;
        private Long warnCount;
        private LocalDateTime firstLogTime;
        private LocalDateTime lastLogTime;

        public Long getTotalLogs() {
            return totalLogs;
        }

        public void setTotalLogs(Long totalLogs) {
            this.totalLogs = totalLogs;
        }

        public Long getErrorCount() {
            return errorCount;
        }

        public void setErrorCount(Long errorCount) {
            this.errorCount = errorCount;
        }

        public Long getWarnCount() {
            return warnCount;
        }

        public void setWarnCount(Long warnCount) {
            this.warnCount = warnCount;
        }

        public LocalDateTime getFirstLogTime() {
            return firstLogTime;
        }

        public void setFirstLogTime(LocalDateTime firstLogTime) {
            this.firstLogTime = firstLogTime;
        }

        public LocalDateTime getLastLogTime() {
            return lastLogTime;
        }

        public void setLastLogTime(LocalDateTime lastLogTime) {
            this.lastLogTime = lastLogTime;
        }
    }
}