package com.wework.platform.task.service.impl;

import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.handler.*;
import com.wework.platform.task.lock.DistributedLock;
import com.wework.platform.task.service.TaskExecutionService;
import com.wework.platform.task.service.TaskInstanceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import jakarta.annotation.PreDestroy;
import java.net.InetAddress;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;
import java.util.stream.Collectors;

/**
 * 任务执行服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TaskExecutionServiceImpl implements TaskExecutionService {

    private final TaskInstanceService taskInstanceService;
    private final TaskHandlerRegistry taskHandlerRegistry;
    private final DistributedLock distributedLock;

    @Value("${task.executor.core-pool-size:10}")
    private int corePoolSize;

    @Value("${task.executor.maximum-pool-size:50}")
    private int maximumPoolSize;

    @Value("${task.executor.keep-alive-time:60}")
    private long keepAliveTime;

    @Value("${task.executor.queue-capacity:1000}")
    private int queueCapacity;

    @Value("${task.execution.timeout:300}")
    private long defaultTimeoutSeconds;

    private ThreadPoolExecutor executor;
    private final Map<String, Future<?>> runningTasks = new ConcurrentHashMap<>();

    /**
     * 初始化线程池
     */
    private void initExecutor() {
        if (executor == null) {
            executor = new ThreadPoolExecutor(
                corePoolSize,
                maximumPoolSize,
                keepAliveTime,
                TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(queueCapacity),
                new ThreadFactory() {
                    private int counter = 0;
                    @Override
                    public Thread newThread(Runnable r) {
                        Thread thread = new Thread(r, "task-executor-" + (++counter));
                        thread.setDaemon(false);
                        return thread;
                    }
                },
                new ThreadPoolExecutor.CallerRunsPolicy()
            );
        }
    }

    @Override
    public CompletableFuture<TaskResult> executeTask(TaskInstance taskInstance) {
        initExecutor();
        
        return CompletableFuture.supplyAsync(() -> {
            String lockKey = "task:execution:" + taskInstance.getId();
            String lockValue = getExecutionNode();
            
            try {
                // 尝试获取分布式锁，避免重复执行
                if (!distributedLock.tryLock(lockKey, lockValue, 300, TimeUnit.SECONDS)) {
                    log.warn("无法获取任务执行锁，任务可能已在其他节点执行: instanceId={}", taskInstance.getId());
                    return TaskResult.failure("无法获取执行锁，任务可能已在执行");
                }

                return doExecuteTask(taskInstance);
                
            } finally {
                distributedLock.releaseLock(lockKey, lockValue);
            }
        }, executor);
    }

    @Override
    public List<CompletableFuture<TaskResult>> executeTasks(List<TaskInstance> taskInstances) {
        return taskInstances.stream()
                .map(this::executeTask)
                .collect(Collectors.toList());
    }

    @Override
    public void executeTaskAsync(TaskInstance taskInstance) {
        initExecutor();
        
        Future<?> future = executor.submit(() -> {
            try {
                TaskResult result = executeTask(taskInstance).get();
                log.debug("异步任务执行完成: instanceId={}, success={}", 
                         taskInstance.getId(), result.isSuccess());
            } catch (Exception e) {
                log.error("异步任务执行异常: instanceId={}", taskInstance.getId(), e);
            }
        });
        
        runningTasks.put(taskInstance.getId(), future);
    }

    @Override
    public boolean stopTask(String instanceId) {
        Future<?> future = runningTasks.get(instanceId);
        if (future != null && !future.isDone()) {
            boolean cancelled = future.cancel(true);
            if (cancelled) {
                runningTasks.remove(instanceId);
                taskInstanceService.updateTaskInstanceStatus(instanceId, "CANCELLED", null, "任务被手动停止");
                log.info("停止任务执行成功: instanceId={}", instanceId);
            }
            return cancelled;
        }
        return false;
    }

    @Override
    public CompletableFuture<TaskResult> retryTask(TaskInstance taskInstance) {
        log.info("重试任务执行: instanceId={}, retryCount={}", 
                taskInstance.getId(), taskInstance.getRetryCount());
        return executeTask(taskInstance);
    }

    @Override
    public boolean isTaskTimeout(TaskInstance taskInstance) {
        if (taskInstance.getStartTime() == null) {
            return false;
        }
        
        long timeoutSeconds = defaultTimeoutSeconds; // 使用默认超时时间
        // TODO: 从TaskDefinition获取具体的超时时间
        
        LocalDateTime timeoutTime = taskInstance.getStartTime().plusSeconds(timeoutSeconds);
        return LocalDateTime.now().isAfter(timeoutTime);
    }

    @Override
    public void handleTimeoutTask(TaskInstance taskInstance) {
        log.warn("处理超时任务: instanceId={}, startTime={}", 
                taskInstance.getId(), taskInstance.getStartTime());
        
        // 停止任务执行
        stopTask(taskInstance.getId());
        
        // 更新任务状态为超时
        taskInstanceService.markTaskComplete(
            taskInstance.getId(), 
            "TIMEOUT", 
            null, 
            "任务执行超时", 
            null
        );
    }

    @Override
    public int getRunningTaskCount() {
        return executor != null ? executor.getActiveCount() : 0;
    }

    @Override
    public int getExecutorCapacity() {
        return maximumPoolSize;
    }

    @Override
    public int getAvailableCapacity() {
        if (executor == null) {
            return maximumPoolSize;
        }
        return maximumPoolSize - executor.getActiveCount();
    }

    @Override
    public boolean hasAvailableCapacity() {
        return getAvailableCapacity() > 0;
    }

    @Override
    public void forceStopAllTasks() {
        if (executor != null) {
            executor.shutdownNow();
            runningTasks.clear();
            log.warn("强制停止所有任务执行");
        }
    }

    @Override
    public boolean gracefulShutdown(long timeoutSeconds) {
        if (executor == null) {
            return true;
        }
        
        try {
            executor.shutdown();
            boolean terminated = executor.awaitTermination(timeoutSeconds, TimeUnit.SECONDS);
            
            if (!terminated) {
                log.warn("优雅关闭超时，强制关闭任务执行器");
                executor.shutdownNow();
                terminated = executor.awaitTermination(5, TimeUnit.SECONDS);
            }
            
            runningTasks.clear();
            return terminated;
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            executor.shutdownNow();
            return false;
        }
    }

    /**
     * 执行具体任务
     */
    private TaskResult doExecuteTask(TaskInstance taskInstance) {
        String instanceId = taskInstance.getId();
        String executionNode = getExecutionNode();
        
        try {
            // 标记任务开始执行
            taskInstanceService.markTaskStart(instanceId, executionNode);
            
            // 构建任务上下文
            TaskContext context = buildTaskContext(taskInstance);
            
            // 获取任务处理器
            TaskHandler handler = taskHandlerRegistry.getHandler(taskInstance.getTaskDefinitionId());
            if (handler == null) {
                throw new RuntimeException("找不到对应的任务处理器");
            }
            
            // 执行任务
            TaskResult result = handler.execute(context);
            
            // 标记任务完成
            if (result.isSuccess()) {
                String resultStr = result.getResult() != null ? result.getResult().toString() : null;
                taskInstanceService.markTaskComplete(instanceId, "SUCCESS", resultStr, null, null);
                log.info("任务执行成功: instanceId={}", instanceId);
            } else {
                String resultStr = result.getResult() != null ? result.getResult().toString() : null;
                taskInstanceService.markTaskComplete(instanceId, "FAILED", resultStr, 
                                                   result.getErrorMessage(), null);
                log.warn("任务执行失败: instanceId={}, error={}", instanceId, result.getErrorMessage());
            }
            
            return result;
            
        } catch (Exception e) {
            log.error("任务执行异常: instanceId={}", instanceId, e);
            
            // 标记任务失败
            taskInstanceService.markTaskComplete(instanceId, "FAILED", null, 
                                               e.getMessage(), getStackTrace(e));
            
            // 判断是否需要重试
            if (shouldRetry(taskInstance, e)) {
                scheduleRetry(taskInstance);
            }
            
            return TaskResult.failure(e.getMessage());
            
        } finally {
            // 清理运行状态
            runningTasks.remove(instanceId);
        }
    }

    /**
     * 构建任务上下文
     */
    private TaskContext buildTaskContext(TaskInstance taskInstance) {
        TaskContext context = new TaskContext();
        context.setInstanceId(taskInstance.getId());
        context.setTaskDefinitionId(taskInstance.getTaskDefinitionId());
        context.setTenantId(taskInstance.getTenantId());
        context.setExecutionParams(taskInstance.getExecutionParams());
        context.setRetryCount(taskInstance.getRetryCount());
        // 创建简单的TaskLogger实现
        context.setLogger(new TaskLogger() {
            @Override
            public void info(String message) {
                log.info("[Task:{}] {}", taskInstance.getId(), message);
            }
            
            @Override
            public void info(String format, Object... args) {
                log.info("[Task:{}] " + format, taskInstance.getId(), args);
            }
            
            @Override
            public void warn(String message) {
                log.warn("[Task:{}] {}", taskInstance.getId(), message);
            }
            
            @Override
            public void warn(String format, Object... args) {
                log.warn("[Task:{}] " + format, taskInstance.getId(), args);
            }
            
            @Override
            public void error(String message) {
                log.error("[Task:{}] {}", taskInstance.getId(), message);
            }
            
            @Override
            public void error(String message, Exception exception) {
                log.error("[Task:{}] {}", taskInstance.getId(), message, exception);
            }
            
            @Override
            public void error(String format, Object... args) {
                log.error("[Task:{}] " + format, taskInstance.getId(), args);
            }
            
            @Override
            public void debug(String message) {
                log.debug("[Task:{}] {}", taskInstance.getId(), message);
            }
            
            @Override
            public void debug(String format, Object... args) {
                log.debug("[Task:{}] " + format, taskInstance.getId(), args);
            }
            
            @Override
            public void progress(int percent, String message) {
                log.info("[Task:{}] Progress: {}% - {}", taskInstance.getId(), percent, message);
            }
            
            @Override
            public void step(String stepName, String stepDescription) {
                log.info("[Task:{}] Step: {} - {}", taskInstance.getId(), stepName, stepDescription);
            }
        });
        context.setStartTime(LocalDateTime.now());
        return context;
    }

    /**
     * 判断是否应该重试
     */
    private boolean shouldRetry(TaskInstance taskInstance, Exception e) {
        return taskInstance.getRetryCount() < taskInstance.getMaxRetryCount() &&
               !(e instanceof InterruptedException); // 被中断的任务不重试
    }

    /**
     * 安排重试
     */
    private void scheduleRetry(TaskInstance taskInstance) {
        // 计算下次重试时间（指数退避）
        long delaySeconds = (long) Math.pow(2, taskInstance.getRetryCount()) * 60; // 1分钟、2分钟、4分钟...
        LocalDateTime nextRetryTime = LocalDateTime.now().plusSeconds(delaySeconds);
        
        taskInstanceService.incrementRetryCount(taskInstance.getId(), nextRetryTime);
        
        log.info("安排任务重试: instanceId={}, retryCount={}, nextRetryTime={}", 
                taskInstance.getId(), taskInstance.getRetryCount() + 1, nextRetryTime);
    }

    /**
     * 获取执行节点标识
     */
    private String getExecutionNode() {
        try {
            return InetAddress.getLocalHost().getHostName() + ":" + System.currentTimeMillis();
        } catch (Exception e) {
            return "unknown-node:" + System.currentTimeMillis();
        }
    }

    /**
     * 获取异常堆栈信息
     */
    private String getStackTrace(Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    /**
     * 应用关闭时清理资源
     */
    @PreDestroy
    public void destroy() {
        log.info("开始关闭任务执行服务...");
        gracefulShutdown(30);
        log.info("任务执行服务关闭完成");
    }
}