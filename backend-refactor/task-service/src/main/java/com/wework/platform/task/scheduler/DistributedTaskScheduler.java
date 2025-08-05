package com.wework.platform.task.scheduler;

import com.wework.platform.common.context.TenantContextHolder;
import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.entity.TaskInstance.TaskStatus;
import com.wework.platform.task.entity.TaskLog;
import com.wework.platform.task.lock.DistributedLock;
import com.wework.platform.task.repository.TaskDefinitionRepository;
import com.wework.platform.task.repository.TaskInstanceRepository;
import com.wework.platform.task.repository.TaskLogRepository;
import com.wework.platform.task.handler.TaskHandler;
import com.wework.platform.task.handler.TaskHandlerRegistry;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.net.InetAddress;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 分布式任务调度器
 * 负责扫描、调度和执行任务的核心组件
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DistributedTaskScheduler implements ApplicationRunner {

    private final TaskInstanceRepository taskInstanceRepository;
    private final TaskDefinitionRepository taskDefinitionRepository;
    private final TaskLogRepository taskLogRepository;
    private final DistributedLock distributedLock;
    private final TaskHandlerRegistry taskHandlerRegistry;

    /**
     * 当前节点ID
     */
    private String nodeId;

    /**
     * 是否启用调度器
     */
    @Value("${app.task.scheduler.enabled:true}")
    private boolean schedulerEnabled;

    /**
     * 任务扫描间隔（毫秒）
     */
    @Value("${app.task.scheduler.scan-interval:10000}")
    private long scanInterval;

    /**
     * 单次扫描任务数量限制
     */
    @Value("${app.task.scheduler.batch-size:10}")
    private int batchSize;

    /**
     * 任务执行超时时间（分钟）
     */
    @Value("${app.task.scheduler.execution-timeout:30}")
    private int executionTimeout;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        // 生成节点ID
        this.nodeId = generateNodeId();
        log.info("分布式任务调度器启动: nodeId={}, enabled={}", nodeId, schedulerEnabled);
        
        if (schedulerEnabled) {
            // 启动时清理可能的过期锁
            cleanupExpiredLocks();
        }
    }

    /**
     * 定时扫描待执行任务
     */
    @Scheduled(fixedDelayString = "${app.task.scheduler.scan-interval:10000}")
    public void scanAndScheduleTasks() {
        if (!schedulerEnabled) {
            return;
        }

        try {
            log.debug("开始扫描待执行任务: nodeId={}", nodeId);
            
            // 1. 扫描准备执行的任务
            List<TaskInstance> readyTasks = taskInstanceRepository.findReadyTasks(
                LocalDateTime.now(), batchSize);
            
            if (readyTasks.isEmpty()) {
                log.debug("没有待执行任务");
                return;
            }
            
            log.info("发现 {} 个待执行任务", readyTasks.size());
            
            // 2. 尝试获取锁并执行任务
            for (TaskInstance task : readyTasks) {
                tryExecuteTask(task);
            }
            
        } catch (Exception e) {
            log.error("扫描任务异常: nodeId={}", nodeId, e);
        }
    }

    /**
     * 定时扫描需要重试的任务
     */
    @Scheduled(fixedDelayString = "${app.task.scheduler.retry-scan-interval:30000}")
    public void scanRetryTasks() {
        if (!schedulerEnabled) {
            return;
        }

        try {
            List<TaskInstance> retryTasks = taskInstanceRepository.findRetryTasks(
                LocalDateTime.now(), batchSize);
            
            if (!retryTasks.isEmpty()) {
                log.info("发现 {} 个需要重试的任务", retryTasks.size());
                
                for (TaskInstance task : retryTasks) {
                    // 重置任务状态为PENDING
                    task.setStatus(TaskStatus.PENDING);
                    task.setNextRetryTime(null);
                    taskInstanceRepository.updateById(task);
                    
                    // 尝试执行
                    tryExecuteTask(task);
                }
            }
            
        } catch (Exception e) {
            log.error("扫描重试任务异常: nodeId={}", nodeId, e);
        }
    }

    /**
     * 定时清理过期锁
     */
    @Scheduled(fixedDelayString = "${app.task.scheduler.cleanup-interval:300000}")
    public void cleanupExpiredLocks() {
        if (!schedulerEnabled) {
            return;
        }

        try {
            LocalDateTime expireTime = LocalDateTime.now().minusMinutes(executionTimeout);
            List<TaskInstance> expiredTasks = taskInstanceRepository.findExpiredLockTasks(
                expireTime, batchSize);
            
            if (!expiredTasks.isEmpty()) {
                log.warn("发现 {} 个锁过期任务，开始清理", expiredTasks.size());
                
                for (TaskInstance task : expiredTasks) {
                    // 重置任务状态
                    int updated = taskInstanceRepository.resetExpiredTask(
                        task.getId(), task.getExecutionNode());
                    
                    if (updated > 0) {
                        log.warn("重置过期任务: taskId={}, originalNode={}", 
                               task.getId(), task.getExecutionNode());
                        
                        // 记录日志
                        TaskLog errorLog = TaskLog.warn(task.getId(), task.getTenantId(),
                            "任务执行超时，已重置状态等待重新调度");
                        errorLog.setExecutionNode(nodeId);
                        taskLogRepository.insert(errorLog);
                    }
                }
            }
            
        } catch (Exception e) {
            log.error("清理过期锁异常: nodeId={}", nodeId, e);
        }
    }

    /**
     * 尝试执行任务
     */
    private void tryExecuteTask(TaskInstance task) {
        String lockKey = "task:" + task.getId();
        
        // 尝试获取Redis分布式锁
        boolean lockAcquired = distributedLock.tryLock(lockKey, nodeId, 
            executionTimeout, TimeUnit.MINUTES);
        
        if (!lockAcquired) {
            log.debug("任务锁获取失败，跳过执行: taskId={}", task.getId());
            return;
        }
        
        // 异步执行任务
        executeTaskAsync(task, lockKey);
    }

    /**
     * 异步执行任务
     */
    @Async("taskExecutor")
    public void executeTaskAsync(TaskInstance task, String lockKey) {
        try {
            // 设置租户上下文
            TenantContextHolder.setTenantId(task.getTenantId());
            
            // 更新任务状态为执行中
            updateTaskStatus(task, TaskStatus.RUNNING);
            
            // 记录开始执行日志
            logTaskExecution(task, TaskLog.LogLevel.INFO, "任务开始执行");
            
            // 执行具体业务逻辑
            TaskResult result = executeBusinessLogic(task);
            
            // 处理执行结果
            handleTaskResult(task, result);
            
        } catch (Exception e) {
            log.error("任务执行异常: taskId={}", task.getId(), e);
            handleTaskException(task, e);
            
        } finally {
            // 清理上下文
            TenantContextHolder.clear();
            
            // 释放分布式锁
            distributedLock.releaseLock(lockKey, nodeId);
        }
    }

    /**
     * 执行业务逻辑
     */
    private TaskResult executeBusinessLogic(TaskInstance task) {
        try {
            // 获取任务定义
            TaskDefinition definition = taskDefinitionRepository.selectById(task.getDefinitionId());
            if (definition == null) {
                return TaskResult.failure("任务定义不存在: " + task.getDefinitionId());
            }
            
            // 获取任务处理器
            TaskHandler handler = taskHandlerRegistry.getHandler(definition.getHandlerClass());
            if (handler == null) {
                return TaskResult.failure("任务处理器不存在: " + definition.getHandlerClass());
            }
            
            // 构建任务上下文
            TaskContext context = TaskContext.builder()
                .taskId(task.getId())
                .tenantId(task.getTenantId())
                .definitionId(task.getDefinitionId())
                .instanceName(task.getInstanceName())
                .parameters(definition.getParameters())
                .retryCount(task.getRetryCount())
                .maxRetryCount(definition.getMaxRetryCount())
                .executionNode(nodeId)
                .build();
            
            // 执行任务
            return handler.execute(context);
            
        } catch (Exception e) {
            log.error("业务逻辑执行异常: taskId={}", task.getId(), e);
            return TaskResult.failure("执行异常: " + e.getMessage());
        }
    }

    /**
     * 处理任务执行结果
     */
    private void handleTaskResult(TaskInstance task, TaskResult result) {
        if (result.isSuccess()) {
            // 任务执行成功
            updateTaskStatus(task, TaskStatus.SUCCESS);
            logTaskExecution(task, TaskLog.LogLevel.INFO, 
                "任务执行成功: " + result.getMessage());
            
            // 更新结果数据
            task.setResultData(result.getData());
            task.setEndTime(LocalDateTime.now());
            taskInstanceRepository.updateById(task);
            
        } else {
            // 任务执行失败，判断是否需要重试
            handleTaskFailure(task, result.getMessage());
        }
    }

    /**
     * 处理任务异常
     */
    private void handleTaskException(TaskInstance task, Exception e) {
        String errorMessage = "任务执行异常: " + e.getMessage();
        handleTaskFailure(task, errorMessage);
        
        // 记录异常堆栈
        TaskLog errorLog = TaskLog.error(task.getId(), task.getTenantId(), 
            errorMessage, getStackTrace(e));
        errorLog.setExecutionNode(nodeId);
        taskLogRepository.insert(errorLog);
    }

    /**
     * 处理任务失败
     */
    private void handleTaskFailure(TaskInstance task, String errorMessage) {
        // 获取任务定义以检查重试配置
        TaskDefinition definition = taskDefinitionRepository.selectById(task.getDefinitionId());
        
        if (definition != null && task.getRetryCount() < definition.getMaxRetryCount()) {
            // 需要重试
            scheduleRetry(task, definition);
            logTaskExecution(task, TaskLog.LogLevel.WARN, 
                String.format("任务执行失败，安排重试 (%d/%d): %s", 
                    task.getRetryCount() + 1, definition.getMaxRetryCount(), errorMessage));
        } else {
            // 不再重试，标记为失败
            updateTaskStatus(task, TaskStatus.FAILED);
            logTaskExecution(task, TaskLog.LogLevel.ERROR, 
                "任务执行失败，已达到最大重试次数: " + errorMessage);
            
            task.setErrorMessage(errorMessage);
            task.setEndTime(LocalDateTime.now());
            taskInstanceRepository.updateById(task);
        }
    }

    /**
     * 安排任务重试
     */
    private void scheduleRetry(TaskInstance task, TaskDefinition definition) {
        int newRetryCount = task.getRetryCount() + 1;
        LocalDateTime nextRetryTime = calculateNextRetryTime(newRetryCount, 
            definition.getRetryIntervalSeconds());
        
        // 更新重试信息
        taskInstanceRepository.updateRetryInfo(task.getId(), newRetryCount, 
            nextRetryTime, TaskStatus.WAITING_RETRY);
    }

    /**
     * 计算下次重试时间
     */
    private LocalDateTime calculateNextRetryTime(int retryCount, Integer intervalSeconds) {
        // 指数退避策略
        long delaySeconds = intervalSeconds * (long) Math.pow(2, retryCount - 1);
        // 最大延迟不超过1小时
        delaySeconds = Math.min(delaySeconds, 3600);
        
        return LocalDateTime.now().plusSeconds(delaySeconds);
    }

    /**
     * 更新任务状态
     */
    private void updateTaskStatus(TaskInstance task, TaskStatus status) {
        task.setStatus(status);
        
        if (status == TaskStatus.RUNNING) {
            task.setExecutionNode(nodeId);
            task.setStartTime(LocalDateTime.now());
        }
        
        taskInstanceRepository.updateById(task);
    }

    /**
     * 记录任务执行日志
     */
    private void logTaskExecution(TaskInstance task, TaskLog.LogLevel level, String message) {
        TaskLog taskLog = TaskLog.builder()
            .instanceId(task.getId())
            .tenantId(task.getTenantId())
            .logLevel(level.getCode())
            .logContent(message)
            .executionNode(nodeId)
            .logTime(LocalDateTime.now())
            .build();
        
        taskLogRepository.insert(taskLog);
    }

    /**
     * 生成节点ID
     */
    private String generateNodeId() {
        try {
            String hostname = InetAddress.getLocalHost().getHostName();
            String shortId = UUID.randomUUID().toString().substring(0, 8);
            return hostname + "-" + shortId;
        } catch (Exception e) {
            log.warn("获取主机名失败，使用随机ID", e);
            return "node-" + UUID.randomUUID().toString().substring(0, 8);
        }
    }

    /**
     * 获取异常堆栈信息
     */
    private String getStackTrace(Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        e.printStackTrace(new java.io.PrintWriter(sw));
        return sw.toString();
    }

    /**
     * 获取节点ID
     */
    public String getNodeId() {
        return nodeId;
    }

    /**
     * 手动触发任务执行
     */
    public boolean triggerTask(String taskId) {
        try {
            TaskInstance task = taskInstanceRepository.selectById(taskId);
            if (task == null) {
                log.warn("任务不存在: {}", taskId);
                return false;
            }
            
            if (!TaskStatus.PENDING.equals(task.getStatus()) && 
                !TaskStatus.WAITING_RETRY.equals(task.getStatus())) {
                log.warn("任务状态不允许执行: taskId={}, status={}", taskId, task.getStatus());
                return false;
            }
            
            tryExecuteTask(task);
            return true;
            
        } catch (Exception e) {
            log.error("手动触发任务执行失败: taskId={}", taskId, e);
            return false;
        }
    }
}