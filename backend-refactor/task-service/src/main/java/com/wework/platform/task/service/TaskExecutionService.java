package com.wework.platform.task.service;

import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.handler.TaskResult;

import java.util.List;
import java.util.concurrent.CompletableFuture;

/**
 * 任务执行服务接口
 */
public interface TaskExecutionService {

    /**
     * 执行单个任务实例
     *
     * @param taskInstance 任务实例
     * @return 执行结果Future
     */
    CompletableFuture<TaskResult> executeTask(TaskInstance taskInstance);

    /**
     * 批量执行任务实例
     *
     * @param taskInstances 任务实例列表
     * @return 执行结果Future列表
     */
    List<CompletableFuture<TaskResult>> executeTasks(List<TaskInstance> taskInstances);

    /**
     * 异步执行任务
     *
     * @param taskInstance 任务实例
     */
    void executeTaskAsync(TaskInstance taskInstance);

    /**
     * 停止任务执行
     *
     * @param instanceId 实例ID
     * @return 是否停止成功
     */
    boolean stopTask(String instanceId);

    /**
     * 重试失败的任务
     *
     * @param taskInstance 任务实例
     * @return 执行结果Future
     */
    CompletableFuture<TaskResult> retryTask(TaskInstance taskInstance);

    /**
     * 检查任务是否超时
     *
     * @param taskInstance 任务实例
     * @return 是否超时
     */
    boolean isTaskTimeout(TaskInstance taskInstance);

    /**
     * 处理超时任务
     *
     * @param taskInstance 任务实例
     */
    void handleTimeoutTask(TaskInstance taskInstance);

    /**
     * 获取正在执行的任务数量
     *
     * @return 执行中的任务数量
     */
    int getRunningTaskCount();

    /**
     * 获取任务执行器的容量
     *
     * @return 执行器容量
     */
    int getExecutorCapacity();

    /**
     * 获取任务执行器的可用容量
     *
     * @return 可用容量
     */
    int getAvailableCapacity();

    /**
     * 检查是否可以执行更多任务
     *
     * @return 是否有可用容量
     */
    boolean hasAvailableCapacity();

    /**
     * 强制停止所有正在执行的任务
     */
    void forceStopAllTasks();

    /**
     * 优雅关闭任务执行器
     *
     * @param timeoutSeconds 等待超时时间（秒）
     * @return 是否成功关闭
     */
    boolean gracefulShutdown(long timeoutSeconds);
}