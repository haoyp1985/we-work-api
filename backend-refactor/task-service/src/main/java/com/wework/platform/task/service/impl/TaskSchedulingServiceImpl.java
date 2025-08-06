package com.wework.platform.task.service.impl;

import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.lock.DistributedLock;
import com.wework.platform.task.repository.TaskDefinitionRepository;
import com.wework.platform.task.scheduler.DistributedTaskScheduler;
import com.wework.platform.task.service.TaskDefinitionService;
import com.wework.platform.task.service.TaskInstanceService;
import com.wework.platform.task.service.TaskSchedulingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.support.CronExpression;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 任务调度服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TaskSchedulingServiceImpl implements TaskSchedulingService {

    private final TaskDefinitionService taskDefinitionService;
    private final TaskInstanceService taskInstanceService;
    private final DistributedTaskScheduler distributedTaskScheduler;
    private final TaskDefinitionRepository taskDefinitionRepository;
    private final DistributedLock distributedLock;

    @Value("${task.scheduler.scan-interval:30}")
    private int scanIntervalSeconds;

    @Value("${task.scheduler.batch-size:100}")
    private int batchSize;

    @Value("${task.scheduler.advance-time:60}")
    private int advanceTimeSeconds;

    private final AtomicBoolean schedulingRunning = new AtomicBoolean(false);
    private final Map<String, TaskDefinition> scheduledTasks = new ConcurrentHashMap<>();
    private final AtomicLong lastScanTime = new AtomicLong(0);
    private final AtomicLong scanDuration = new AtomicLong(0);
    private final AtomicInteger createdInstancesInLastScan = new AtomicInteger(0);

    @PostConstruct
    public void init() {
        // 启动时自动开始调度
        startScheduling();
    }

    @Override
    public void startScheduling() {
        if (schedulingRunning.compareAndSet(false, true)) {
            log.info("启动任务调度服务");
            loadScheduledTasks();
        } else {
            log.warn("任务调度服务已在运行");
        }
    }

    @Override
    public void stopScheduling() {
        if (schedulingRunning.compareAndSet(true, false)) {
            log.info("停止任务调度服务");
            scheduledTasks.clear();
        } else {
            log.warn("任务调度服务未在运行");
        }
    }

    @Override
    public void restartScheduling() {
        stopScheduling();
        startScheduling();
    }

    @Override
    public boolean isSchedulingRunning() {
        return schedulingRunning.get();
    }

    @Override
    public boolean scheduleTask(TaskDefinition taskDefinition) {
        if (!isSchedulingRunning()) {
            log.warn("调度服务未运行，无法添加任务: taskId={}", taskDefinition.getId());
            return false;
        }

        if ("ENABLED".equals(taskDefinition.getStatus())) {
            scheduledTasks.put(taskDefinition.getId(), taskDefinition);
            log.info("添加任务到调度器: taskId={}, taskName={}", 
                    taskDefinition.getId(), taskDefinition.getTaskName());
            return true;
        }
        
        return false;
    }

    @Override
    public boolean unscheduleTask(String taskDefinitionId) {
        TaskDefinition removed = scheduledTasks.remove(taskDefinitionId);
        if (removed != null) {
            log.info("从调度器移除任务: taskId={}, taskName={}", 
                    taskDefinitionId, removed.getTaskName());
            return true;
        }
        return false;
    }

    @Override
    public boolean rescheduleTask(TaskDefinition taskDefinition) {
        unscheduleTask(taskDefinition.getId());
        return scheduleTask(taskDefinition);
    }

    @Override
    public boolean pauseTask(String taskDefinitionId) {
        TaskDefinition task = scheduledTasks.get(taskDefinitionId);
        if (task != null) {
            // 临时从调度中移除，但不删除
            scheduledTasks.remove(taskDefinitionId);
            log.info("暂停任务调度: taskId={}", taskDefinitionId);
            return true;
        }
        return false;
    }

    @Override
    public boolean resumeTask(String taskDefinitionId) {
        // 重新从数据库加载任务定义
        TaskDefinition taskDefinition = taskDefinitionRepository.selectById(taskDefinitionId);
        if (taskDefinition != null && "ENABLED".equals(taskDefinition.getStatus())) {
            return scheduleTask(taskDefinition);
        }
        return false;
    }

    @Override
    public TaskInstance triggerTask(String taskDefinitionId, String executionParams) {
        TaskDefinition taskDefinition = taskDefinitionRepository.selectById(taskDefinitionId);
        if (taskDefinition == null) {
            throw new RuntimeException("任务定义不存在: " + taskDefinitionId);
        }

        // 创建立即执行的任务实例
        TaskInstance taskInstance = taskInstanceService.createTaskInstance(
            taskDefinition.getTenantId(), 
            taskDefinitionId, 
            StringUtils.hasText(executionParams) ? executionParams : taskDefinition.getExecutionParams()
        );

        log.info("手动触发任务: taskId={}, instanceId={}", taskDefinitionId, taskInstance.getId());
        return taskInstance;
    }

    @Override
    public LocalDateTime calculateNextExecutionTime(TaskDefinition taskDefinition, LocalDateTime baseTime) {
        String scheduleType = taskDefinition.getScheduleType();
        
        switch (scheduleType) {
            case "CRON":
                return calculateCronNextTime(taskDefinition.getCronExpression(), baseTime);
            case "FIXED_INTERVAL":
                return baseTime.plusSeconds(taskDefinition.getFixedInterval());
            case "ONE_TIME":
                return null; // 一次性任务没有下次执行时间
            default:
                log.warn("未知的调度类型: {}", scheduleType);
                return null;
        }
    }

    @Override
    public List<TaskDefinition> getUpcomingTasks(int withinSeconds) {
        LocalDateTime cutoffTime = LocalDateTime.now().plusSeconds(withinSeconds);
        
        return scheduledTasks.values().stream()
                .filter(task -> {
                    LocalDateTime nextTime = calculateNextExecutionTime(task, LocalDateTime.now());
                    return nextTime != null && nextTime.isBefore(cutoffTime);
                })
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Scheduled(fixedDelayString = "${task.scheduler.scan-interval:30}000")
    public int scanAndCreatePendingInstances() {
        if (!isSchedulingRunning()) {
            return 0;
        }

        long startTime = System.currentTimeMillis();
        lastScanTime.set(startTime);
        int createdCount = 0;

        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime scanEndTime = now.plusSeconds(advanceTimeSeconds);

            for (TaskDefinition taskDefinition : scheduledTasks.values()) {
                try {
                    LocalDateTime nextExecutionTime = calculateNextExecutionTime(taskDefinition, now);
                    
                    if (nextExecutionTime != null && 
                        nextExecutionTime.isAfter(now) && 
                        nextExecutionTime.isBefore(scanEndTime)) {
                        
                        // 使用分布式锁确保同一时间点的任务实例只被创建一次
                        String lockKey = String.format("task:schedule:%s:%s", 
                                                      taskDefinition.getId(), 
                                                      nextExecutionTime.toString());
                        
                        if (distributedLock.tryLock(lockKey, "SCHEDULE", 5, TimeUnit.SECONDS)) {
                            try {
                            TaskInstance instance = taskInstanceService.createTaskInstance(
                                taskDefinition.getTenantId(),
                                taskDefinition.getId(),
                                taskDefinition.getExecutionParams()
                            );
                            
                            createdCount++;
                            log.debug("创建计划任务实例: taskId={}, instanceId={}, scheduledTime={}", 
                                     taskDefinition.getId(), instance.getId(), nextExecutionTime);
                            } finally {
                                distributedLock.releaseLock(lockKey, "SCHEDULE");
                            }
                        }
                    }
                } catch (Exception e) {
                    log.error("处理任务调度失败: taskId={}, taskName={}", 
                             taskDefinition.getId(), taskDefinition.getTaskName(), e);
                }
            }

            createdInstancesInLastScan.set(createdCount);
            log.debug("调度扫描完成: 创建任务实例 {} 个, 耗时 {} ms", 
                     createdCount, System.currentTimeMillis() - startTime);

        } catch (Exception e) {
            log.error("任务调度扫描异常", e);
        } finally {
            scanDuration.set(System.currentTimeMillis() - startTime);
        }

        return createdCount;
    }

    @Override
    public boolean handleMissedSchedule(TaskDefinition taskDefinition, LocalDateTime missedTime) {
        log.warn("处理错过的任务调度: taskId={}, taskName={}, missedTime={}", 
                taskDefinition.getId(), taskDefinition.getTaskName(), missedTime);
        
        // 根据任务配置决定是否执行错过的任务
        // 这里可以添加具体的策略，比如立即执行、跳过等
        return true;
    }

    @Override
    public SchedulerStatistics getSchedulerStatistics() {
        SchedulerStatistics statistics = new SchedulerStatistics();
        
        statistics.setTotalScheduledTasks(scheduledTasks.size());
        
        long runningTasks = scheduledTasks.values().stream()
                .mapToLong(task -> "ENABLED".equals(task.getStatus()) ? 1 : 0)
                .sum();
        statistics.setRunningTasks((int) runningTasks);
        
        long pausedTasks = scheduledTasks.values().stream()
                .mapToLong(task -> "DISABLED".equals(task.getStatus()) ? 1 : 0)
                .sum();
        statistics.setPausedTasks((int) pausedTasks);
        
        statistics.setErrorTasks(0); // TODO: 实现错误任务统计
        
        if (lastScanTime.get() > 0) {
            statistics.setLastScanTime(LocalDateTime.ofInstant(
                java.time.Instant.ofEpochMilli(lastScanTime.get()), 
                ZoneId.systemDefault()
            ));
        }
        
        statistics.setScanDuration(scanDuration.get());
        statistics.setCreatedInstancesInLastScan(createdInstancesInLastScan.get());
        
        return statistics;
    }

    @Override
    public List<TaskDefinition> getAllScheduledTasks() {
        return scheduledTasks.values().stream()
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public boolean isTaskScheduled(String taskDefinitionId) {
        return scheduledTasks.containsKey(taskDefinitionId);
    }

    /**
     * 加载已启用的任务到调度器
     */
    private void loadScheduledTasks() {
        try {
            List<TaskDefinition> enabledTasks = taskDefinitionService.getAllEnabledTaskDefinitions();
            
            for (TaskDefinition task : enabledTasks) {
                scheduledTasks.put(task.getId(), task);
            }
            
            log.info("加载任务到调度器完成: 共 {} 个任务", enabledTasks.size());
            
        } catch (Exception e) {
            log.error("加载调度任务失败", e);
        }
    }

    /**
     * 计算Cron表达式的下次执行时间
     */
    private LocalDateTime calculateCronNextTime(String cronExpression, LocalDateTime baseTime) {
        try {
            CronExpression cron = CronExpression.parse(cronExpression);
            return cron.next(baseTime);
        } catch (Exception e) {
            log.error("计算Cron下次执行时间失败: expression={}", cronExpression, e);
            return null;
        }
    }

    @PreDestroy
    public void destroy() {
        log.info("关闭任务调度服务");
        stopScheduling();
    }
}