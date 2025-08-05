package com.wework.platform.task.service;

import com.wework.platform.task.dto.TaskInstanceDTO;
import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.PageQuery;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务实例服务接口
 */
public interface TaskInstanceService {

    /**
     * 创建任务实例
     *
     * @param tenantId           租户ID
     * @param taskDefinitionId   任务定义ID
     * @param executionParams    执行参数
     * @return 任务实例
     */
    TaskInstance createTaskInstance(String tenantId, String taskDefinitionId, String executionParams);

    /**
     * 获取任务实例详情
     *
     * @param tenantId 租户ID
     * @param instanceId 实例ID
     * @return 任务实例
     */
    TaskInstanceDTO getTaskInstance(String tenantId, String instanceId);

    /**
     * 分页查询任务实例
     *
     * @param tenantId 租户ID
     * @param taskDefinitionId 任务定义ID（可选）
     * @param status 执行状态（可选）
     * @param pageQuery 分页参数
     * @return 分页结果
     */
    PageResult<TaskInstanceDTO> getTaskInstances(String tenantId, String taskDefinitionId, 
                                                String status, PageQuery pageQuery);

    /**
     * 更新任务实例状态
     *
     * @param instanceId 实例ID
     * @param status 新状态
     * @param result 执行结果（可选）
     * @param errorMessage 错误信息（可选）
     * @return 是否更新成功
     */
    boolean updateTaskInstanceStatus(String instanceId, String status, String result, String errorMessage);

    /**
     * 标记任务开始执行
     *
     * @param instanceId 实例ID
     * @param executionNode 执行节点
     * @return 是否更新成功
     */
    boolean markTaskStart(String instanceId, String executionNode);

    /**
     * 标记任务执行完成
     *
     * @param instanceId 实例ID
     * @param status 最终状态
     * @param result 执行结果
     * @param errorMessage 错误信息
     * @param errorStack 错误堆栈
     * @return 是否更新成功
     */
    boolean markTaskComplete(String instanceId, String status, String result, 
                           String errorMessage, String errorStack);

    /**
     * 增加重试次数
     *
     * @param instanceId 实例ID
     * @param nextRetryTime 下次重试时间
     * @return 是否更新成功
     */
    boolean incrementRetryCount(String instanceId, LocalDateTime nextRetryTime);

    /**
     * 获取待执行的任务实例
     *
     * @param limit 限制数量
     * @return 待执行的任务实例列表
     */
    List<TaskInstance> getPendingTaskInstances(int limit);

    /**
     * 获取需要重试的任务实例
     *
     * @param limit 限制数量
     * @return 需要重试的任务实例列表
     */
    List<TaskInstance> getRetryTaskInstances(int limit);

    /**
     * 清理过期的任务实例
     *
     * @param beforeTime 清理此时间之前的实例
     * @return 清理的数量
     */
    int cleanExpiredInstances(LocalDateTime beforeTime);

    /**
     * 取消任务实例
     *
     * @param tenantId 租户ID
     * @param instanceId 实例ID
     * @return 是否取消成功
     */
    boolean cancelTaskInstance(String tenantId, String instanceId);

    /**
     * 获取任务实例统计信息
     *
     * @param tenantId 租户ID
     * @param taskDefinitionId 任务定义ID（可选）
     * @param startTime 开始时间（可选）
     * @param endTime 结束时间（可选）
     * @return 统计信息
     */
    TaskInstanceStatistics getTaskInstanceStatistics(String tenantId, String taskDefinitionId, 
                                                    LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 任务实例统计信息
     */
    class TaskInstanceStatistics {
        private Long totalCount;
        private Long successCount;
        private Long failedCount;
        private Long runningCount;
        private Long pendingCount;
        private Double successRate;
        private Long avgExecutionTime;

        // getters and setters...
        public Long getTotalCount() { return totalCount; }
        public void setTotalCount(Long totalCount) { this.totalCount = totalCount; }
        
        public Long getSuccessCount() { return successCount; }
        public void setSuccessCount(Long successCount) { this.successCount = successCount; }
        
        public Long getFailedCount() { return failedCount; }
        public void setFailedCount(Long failedCount) { this.failedCount = failedCount; }
        
        public Long getRunningCount() { return runningCount; }
        public void setRunningCount(Long runningCount) { this.runningCount = runningCount; }
        
        public Long getPendingCount() { return pendingCount; }
        public void setPendingCount(Long pendingCount) { this.pendingCount = pendingCount; }
        
        public Double getSuccessRate() { return successRate; }
        public void setSuccessRate(Double successRate) { this.successRate = successRate; }
        
        public Long getAvgExecutionTime() { return avgExecutionTime; }
        public void setAvgExecutionTime(Long avgExecutionTime) { this.avgExecutionTime = avgExecutionTime; }
    }
}