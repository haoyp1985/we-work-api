package com.wework.platform.task.service;

import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.entity.TaskInstance;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务调度服务接口
 */
public interface TaskSchedulingService {

    /**
     * 启动任务调度
     */
    void startScheduling();

    /**
     * 停止任务调度
     */
    void stopScheduling();

    /**
     * 重启任务调度
     */
    void restartScheduling();

    /**
     * 检查调度器状态
     *
     * @return 是否正在运行
     */
    boolean isSchedulingRunning();

    /**
     * 添加任务到调度器
     *
     * @param taskDefinition 任务定义
     * @return 是否添加成功
     */
    boolean scheduleTask(TaskDefinition taskDefinition);

    /**
     * 从调度器中移除任务
     *
     * @param taskDefinitionId 任务定义ID
     * @return 是否移除成功
     */
    boolean unscheduleTask(String taskDefinitionId);

    /**
     * 重新调度任务（更新调度信息）
     *
     * @param taskDefinition 任务定义
     * @return 是否重新调度成功
     */
    boolean rescheduleTask(TaskDefinition taskDefinition);

    /**
     * 暂停任务调度
     *
     * @param taskDefinitionId 任务定义ID
     * @return 是否暂停成功
     */
    boolean pauseTask(String taskDefinitionId);

    /**
     * 恢复任务调度
     *
     * @param taskDefinitionId 任务定义ID
     * @return 是否恢复成功
     */
    boolean resumeTask(String taskDefinitionId);

    /**
     * 立即触发任务执行
     *
     * @param taskDefinitionId 任务定义ID
     * @param executionParams 执行参数（可选）
     * @return 创建的任务实例
     */
    TaskInstance triggerTask(String taskDefinitionId, String executionParams);

    /**
     * 计算任务下次执行时间
     *
     * @param taskDefinition 任务定义
     * @param baseTime 基准时间
     * @return 下次执行时间
     */
    LocalDateTime calculateNextExecutionTime(TaskDefinition taskDefinition, LocalDateTime baseTime);

    /**
     * 获取即将执行的任务
     *
     * @param withinSeconds 在指定秒数内即将执行的任务
     * @return 任务定义列表
     */
    List<TaskDefinition> getUpcomingTasks(int withinSeconds);

    /**
     * 扫描并创建待执行的任务实例
     *
     * @return 创建的任务实例数量
     */
    int scanAndCreatePendingInstances();

    /**
     * 处理错过的任务调度
     *
     * @param taskDefinition 任务定义
     * @param missedTime 错过的执行时间
     * @return 是否处理成功
     */
    boolean handleMissedSchedule(TaskDefinition taskDefinition, LocalDateTime missedTime);

    /**
     * 获取调度器统计信息
     *
     * @return 调度器统计信息
     */
    SchedulerStatistics getSchedulerStatistics();

    /**
     * 获取所有已调度的任务
     *
     * @return 已调度的任务定义列表
     */
    List<TaskDefinition> getAllScheduledTasks();

    /**
     * 检查任务是否已被调度
     *
     * @param taskDefinitionId 任务定义ID
     * @return 是否已调度
     */
    boolean isTaskScheduled(String taskDefinitionId);

    /**
     * 调度器统计信息
     */
    class SchedulerStatistics {
        private Integer totalScheduledTasks;
        private Integer runningTasks;
        private Integer pausedTasks;
        private Integer errorTasks;
        private LocalDateTime lastScanTime;
        private Long scanDuration;
        private Integer createdInstancesInLastScan;

        // getters and setters...
        public Integer getTotalScheduledTasks() { return totalScheduledTasks; }
        public void setTotalScheduledTasks(Integer totalScheduledTasks) { this.totalScheduledTasks = totalScheduledTasks; }
        
        public Integer getRunningTasks() { return runningTasks; }
        public void setRunningTasks(Integer runningTasks) { this.runningTasks = runningTasks; }
        
        public Integer getPausedTasks() { return pausedTasks; }
        public void setPausedTasks(Integer pausedTasks) { this.pausedTasks = pausedTasks; }
        
        public Integer getErrorTasks() { return errorTasks; }
        public void setErrorTasks(Integer errorTasks) { this.errorTasks = errorTasks; }
        
        public LocalDateTime getLastScanTime() { return lastScanTime; }
        public void setLastScanTime(LocalDateTime lastScanTime) { this.lastScanTime = lastScanTime; }
        
        public Long getScanDuration() { return scanDuration; }
        public void setScanDuration(Long scanDuration) { this.scanDuration = scanDuration; }
        
        public Integer getCreatedInstancesInLastScan() { return createdInstancesInLastScan; }
        public void setCreatedInstancesInLastScan(Integer createdInstancesInLastScan) { this.createdInstancesInLastScan = createdInstancesInLastScan; }
    }
}