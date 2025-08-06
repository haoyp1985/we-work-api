package com.wework.platform.task.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.task.dto.CreateTaskDefinitionRequest;
import com.wework.platform.task.dto.TaskDefinitionDTO;
import com.wework.platform.task.dto.UpdateTaskDefinitionRequest;
import com.wework.platform.task.entity.TaskDefinition;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务定义服务接口
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
public interface TaskDefinitionService {

    /**
     * 创建任务定义
     * 
     * @param tenantId 租户ID
     * @param request 创建请求
     * @return 任务定义DTO
     */
    TaskDefinitionDTO createTaskDefinition(String tenantId, CreateTaskDefinitionRequest request);

    /**
     * 更新任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @param request 更新请求
     * @return 任务定义DTO
     */
    TaskDefinitionDTO updateTaskDefinition(String tenantId, String definitionId, UpdateTaskDefinitionRequest request);

    /**
     * 删除任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 是否删除成功
     */
    boolean deleteTaskDefinition(String tenantId, String definitionId);

    /**
     * 根据ID获取任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 任务定义DTO
     */
    TaskDefinitionDTO getTaskDefinition(String tenantId, String definitionId);

    /**
     * 分页查询任务定义
     * 
     * @param tenantId 租户ID
     * @param page 分页参数
     * @param taskName 任务名称（模糊查询）
     * @param taskType 任务类型
     * @param enabled 是否启用
     * @param status 状态
     * @return 分页结果
     */
    IPage<TaskDefinitionDTO> getTaskDefinitions(String tenantId, Page<TaskDefinition> page,
                                               String taskName, String taskType, 
                                               Boolean enabled, String status);

    /**
     * 获取租户下的所有任务定义
     * 
     * @param tenantId 租户ID
     * @return 任务定义列表
     */
    List<TaskDefinitionDTO> getAllTaskDefinitions(String tenantId);

    /**
     * 启用任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 是否操作成功
     */
    boolean enableTaskDefinition(String tenantId, String definitionId);

    /**
     * 禁用任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 是否操作成功
     */
    boolean disableTaskDefinition(String tenantId, String definitionId);

    /**
     * 批量启用任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionIds 任务定义ID列表
     * @return 操作结果数量
     */
    int batchEnableTaskDefinitions(String tenantId, List<String> definitionIds);

    /**
     * 批量禁用任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionIds 任务定义ID列表
     * @return 操作结果数量
     */
    int batchDisableTaskDefinitions(String tenantId, List<String> definitionIds);

    /**
     * 批量删除任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionIds 任务定义ID列表
     * @return 删除数量
     */
    int batchDeleteTaskDefinitions(String tenantId, List<String> definitionIds);

    /**
     * 复制任务定义
     * 
     * @param tenantId 租户ID
     * @param sourceDefinitionId 源任务定义ID
     * @param newTaskName 新任务名称
     * @return 新任务定义DTO
     */
    TaskDefinitionDTO copyTaskDefinition(String tenantId, String sourceDefinitionId, String newTaskName);

    /**
     * 手动触发任务执行
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 任务实例ID
     */
    String triggerTaskExecution(String tenantId, String definitionId);

    /**
     * 计算下次执行时间
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @return 下次执行时间
     */
    LocalDateTime calculateNextExecutionTime(String tenantId, String definitionId);

    /**
     * 更新任务定义的执行时间信息
     * 
     * @param tenantId 租户ID
     * @param definitionId 任务定义ID
     * @param lastExecutionTime 上次执行时间
     * @param lastExecutionStatus 上次执行状态
     * @param nextExecutionTime 下次执行时间
     */
    void updateExecutionInfo(String tenantId, String definitionId, 
                           LocalDateTime lastExecutionTime, String lastExecutionStatus,
                           LocalDateTime nextExecutionTime);

    /**
     * 获取需要执行的任务定义
     * 
     * @param currentTime 当前时间
     * @param limit 查询数量限制
     * @return 需要执行的任务定义列表
     */
    List<TaskDefinition> getExecutableTaskDefinitions(LocalDateTime currentTime, int limit);

    /**
     * 验证Cron表达式
     * 
     * @param cronExpression Cron表达式
     * @return 验证结果，null表示有效
     */
    String validateCronExpression(String cronExpression);

    /**
     * 验证处理器类名
     * 
     * @param handlerClass 处理器类名
     * @return 验证结果，null表示有效
     */
    String validateHandlerClass(String handlerClass);

    /**
     * 获取任务定义统计信息
     * 
     * @param tenantId 租户ID
     * @return 统计信息
     */
    TaskDefinitionStatistics getTaskDefinitionStatistics(String tenantId);

    /**
     * 获取所有启用的任务定义（跨租户）
     * 
     * @return 启用的任务定义列表
     */
    List<TaskDefinition> getAllEnabledTaskDefinitions();

    /**
     * 导出任务定义
     * 
     * @param tenantId 租户ID
     * @param definitionIds 任务定义ID列表（为空时导出全部）
     * @return 导出数据
     */
    String exportTaskDefinitions(String tenantId, List<String> definitionIds);

    /**
     * 导入任务定义
     * 
     * @param tenantId 租户ID
     * @param importData 导入数据
     * @return 导入结果
     */
    ImportResult importTaskDefinitions(String tenantId, String importData);

    /**
     * 任务定义统计信息
     */
    class TaskDefinitionStatistics {
        private long totalCount;
        private long enabledCount;
        private long disabledCount;
        private long activeCount;
        private long pausedCount;

        public long getTotalCount() {
            return totalCount;
        }

        public void setTotalCount(long totalCount) {
            this.totalCount = totalCount;
        }

        public long getEnabledCount() {
            return enabledCount;
        }

        public void setEnabledCount(long enabledCount) {
            this.enabledCount = enabledCount;
        }

        public long getDisabledCount() {
            return disabledCount;
        }

        public void setDisabledCount(long disabledCount) {
            this.disabledCount = disabledCount;
        }

        public long getActiveCount() {
            return activeCount;
        }

        public void setActiveCount(long activeCount) {
            this.activeCount = activeCount;
        }

        public long getPausedCount() {
            return pausedCount;
        }

        public void setPausedCount(long pausedCount) {
            this.pausedCount = pausedCount;
        }
    }

    /**
     * 导入结果
     */
    class ImportResult {
        private int successCount;
        private int failureCount;
        private List<String> errors;

        public int getSuccessCount() {
            return successCount;
        }

        public void setSuccessCount(int successCount) {
            this.successCount = successCount;
        }

        public int getFailureCount() {
            return failureCount;
        }

        public void setFailureCount(int failureCount) {
            this.failureCount = failureCount;
        }

        public List<String> getErrors() {
            return errors;
        }

        public void setErrors(List<String> errors) {
            this.errors = errors;
        }
    }

    /**
     * 验证任务定义
     */
    boolean validateTaskDefinition(CreateTaskDefinitionRequest request);
}