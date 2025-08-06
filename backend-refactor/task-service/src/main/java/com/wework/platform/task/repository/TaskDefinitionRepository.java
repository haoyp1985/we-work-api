package com.wework.platform.task.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.task.entity.TaskDefinition;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 任务定义数据访问层
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Repository
@Mapper
public interface TaskDefinitionRepository extends BaseMapper<TaskDefinition> {

    /**
     * 分页查询任务定义
     */
    @Select("SELECT * FROM task_definitions " +
            "WHERE tenant_id = #{tenantId} " +
            "AND (@{taskName} IS NULL OR task_name LIKE CONCAT('%', #{taskName}, '%')) " +
            "AND (@{taskType} IS NULL OR task_type = #{taskType}) " +
            "AND (@{isEnabled} IS NULL OR is_enabled = #{isEnabled}) " +
            "AND deleted_at IS NULL " +
            "ORDER BY created_at DESC")
    Page<TaskDefinition> selectByPage(Page<TaskDefinition> page,
                                     @Param("tenantId") String tenantId,
                                     @Param("taskName") String taskName,
                                     @Param("taskType") String taskType,
                                     @Param("isEnabled") Boolean isEnabled);

    /**
     * 获取启用的任务定义
     */
    @Select("SELECT * FROM task_definitions " +
            "WHERE tenant_id = #{tenantId} " +
            "AND is_enabled = true " +
            "AND deleted_at IS NULL " +
            "ORDER BY priority DESC, created_at ASC")
    List<TaskDefinition> selectEnabledTasks(@Param("tenantId") String tenantId);

    /**
     * 获取需要调度的任务定义
     */
    @Select("SELECT * FROM task_definitions " +
            "WHERE is_enabled = true " +
            "AND deleted_at IS NULL " +
            "AND cron_expression IS NOT NULL " +
            "AND cron_expression != '' " +
            "ORDER BY priority DESC")
    List<TaskDefinition> selectSchedulableTasks();

    /**
     * 根据任务类型查询
     */
    @Select("SELECT * FROM task_definitions " +
            "WHERE tenant_id = #{tenantId} " +
            "AND task_type = #{taskType} " +
            "AND is_enabled = true " +
            "AND deleted_at IS NULL " +
            "ORDER BY priority DESC")
    List<TaskDefinition> selectByTaskType(@Param("tenantId") String tenantId,
                                         @Param("taskType") String taskType);

    /**
     * 统计任务定义数量
     */
    @Select("SELECT " +
            "COUNT(*) as total, " +
            "COUNT(CASE WHEN is_enabled = true THEN 1 END) as enabled, " +
            "COUNT(CASE WHEN is_enabled = false THEN 1 END) as disabled " +
            "FROM task_definitions " +
            "WHERE tenant_id = #{tenantId} " +
            "AND deleted_at IS NULL")
    @Results({
        @Result(property = "total", column = "total"),
        @Result(property = "enabled", column = "enabled"),
        @Result(property = "disabled", column = "disabled")
    })
    TaskDefinitionStatistics selectStatistics(@Param("tenantId") String tenantId);

    /**
     * 启用任务
     */
    @Update("UPDATE task_definitions SET " +
            "is_enabled = true, " +
            "updated_at = #{updateTime}, " +
            "updated_by = #{updatedBy} " +
            "WHERE id = #{id} AND tenant_id = #{tenantId}")
    int enableTask(@Param("id") String id,
                   @Param("tenantId") String tenantId,
                   @Param("updateTime") LocalDateTime updateTime,
                   @Param("updatedBy") String updatedBy);

    /**
     * 禁用任务
     */
    @Update("UPDATE task_definitions SET " +
            "is_enabled = false, " +
            "updated_at = #{updateTime}, " +
            "updated_by = #{updatedBy} " +
            "WHERE id = #{id} AND tenant_id = #{tenantId}")
    int disableTask(@Param("id") String id,
                    @Param("tenantId") String tenantId,
                    @Param("updateTime") LocalDateTime updateTime,
                    @Param("updatedBy") String updatedBy);

    /**
     * 软删除任务定义
     */
    @Update("UPDATE task_definitions SET " +
            "deleted_at = #{deleteTime}, " +
            "updated_at = #{deleteTime}, " +
            "updated_by = #{deletedBy} " +
            "WHERE id = #{id} AND tenant_id = #{tenantId}")
    int softDelete(@Param("id") String id,
                   @Param("tenantId") String tenantId,
                   @Param("deleteTime") LocalDateTime deleteTime,
                   @Param("deletedBy") String deletedBy);

    /**
     * 检查任务名称是否存在
     */
    @Select("SELECT COUNT(*) FROM task_definitions " +
            "WHERE tenant_id = #{tenantId} " +
            "AND task_name = #{taskName} " +
            "AND id != #{excludeId} " +
            "AND deleted_at IS NULL")
    int countByTaskName(@Param("tenantId") String tenantId,
                       @Param("taskName") String taskName,
                       @Param("excludeId") String excludeId);

    /**
     * 任务定义统计数据传输对象
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    class TaskDefinitionStatistics {
        private Long total;
        private Long enabled;
        private Long disabled;
    }
}