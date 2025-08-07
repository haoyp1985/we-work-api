package com.wework.platform.task.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.task.entity.TaskDefinition;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
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
    Page<TaskDefinition> selectByPage(Page<TaskDefinition> page,
                                     @Param("tenantId") String tenantId,
                                     @Param("taskName") String taskName,
                                     @Param("taskType") String taskType,
                                     @Param("isEnabled") Boolean isEnabled);

    /**
     * 获取启用的任务定义
     */
    List<TaskDefinition> selectEnabledTasks(@Param("tenantId") String tenantId);

    /**
     * 获取需要调度的任务定义
     */
    List<TaskDefinition> selectSchedulableTasks();

    /**
     * 根据任务类型查询
     */
    List<TaskDefinition> selectByTaskType(@Param("tenantId") String tenantId,
                                         @Param("taskType") String taskType);

    /**
     * 统计任务定义数量
     */
    TaskDefinitionStatistics selectStatistics(@Param("tenantId") String tenantId);

    /**
     * 启用任务
     */
    int enableTask(@Param("id") String id,
                   @Param("tenantId") String tenantId,
                   @Param("updateTime") LocalDateTime updateTime,
                   @Param("updatedBy") String updatedBy);

    /**
     * 禁用任务
     */
    int disableTask(@Param("id") String id,
                    @Param("tenantId") String tenantId,
                    @Param("updateTime") LocalDateTime updateTime,
                    @Param("updatedBy") String updatedBy);

    /**
     * 软删除任务定义
     */
    int softDelete(@Param("id") String id,
                   @Param("tenantId") String tenantId,
                   @Param("deleteTime") LocalDateTime deleteTime,
                   @Param("deletedBy") String deletedBy);

    /**
     * 检查任务名称是否存在
     */
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