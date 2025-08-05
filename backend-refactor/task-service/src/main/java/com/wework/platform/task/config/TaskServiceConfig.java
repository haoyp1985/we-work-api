package com.wework.platform.task.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 任务服务配置类
 */
@Data
@Configuration
@EnableAsync
@EnableScheduling
@ConfigurationProperties(prefix = "app.task")
public class TaskServiceConfig {

    /**
     * 任务执行器配置
     */
    private Executor executor = new Executor();

    /**
     * 调度器配置
     */
    private Scheduler scheduler = new Scheduler();

    /**
     * 分布式锁配置
     */
    private DistributedLock distributedLock = new DistributedLock();

    /**
     * 任务清理配置
     */
    private Cleanup cleanup = new Cleanup();

    @Data
    public static class Executor {
        /**
         * 核心线程数
         */
        private int corePoolSize = 10;

        /**
         * 最大线程数
         */
        private int maximumPoolSize = 50;

        /**
         * 线程保活时间（秒）
         */
        private long keepAliveTime = 60;

        /**
         * 队列容量
         */
        private int queueCapacity = 1000;

        /**
         * 默认任务超时时间（秒）
         */
        private long defaultTimeout = 300;

        /**
         * 是否允许核心线程超时
         */
        private boolean allowCoreThreadTimeOut = false;
    }

    @Data
    public static class Scheduler {
        /**
         * 调度扫描间隔（秒）
         */
        private int scanInterval = 30;

        /**
         * 批处理大小
         */
        private int batchSize = 100;

        /**
         * 提前调度时间（秒）
         */
        private int advanceTime = 60;

        /**
         * 启动时是否自动开始调度
         */
        private boolean autoStart = true;

        /**
         * 错过调度的处理策略
         * IGNORE: 忽略
         * EXECUTE_ONCE: 执行一次
         * EXECUTE_ALL: 执行所有错过的
         */
        private String missedScheduleStrategy = "IGNORE";
    }

    @Data
    public static class DistributedLock {
        /**
         * 锁的前缀
         */
        private String keyPrefix = "task:lock:";

        /**
         * 默认锁超时时间（秒）
         */
        private long defaultTimeout = 300;

        /**
         * 锁续期间隔（秒）
         */
        private long renewalInterval = 30;

        /**
         * 是否启用锁续期
         */
        private boolean enableRenewal = true;
    }

    @Data
    public static class Cleanup {
        /**
         * 是否启用自动清理
         */
        private boolean enabled = true;

        /**
         * 清理间隔（小时）
         */
        private int intervalHours = 24;

        /**
         * 保留成功任务实例的天数
         */
        private int retainSuccessDays = 7;

        /**
         * 保留失败任务实例的天数
         */
        private int retainFailureDays = 30;

        /**
         * 保留日志的天数
         */
        private int retainLogDays = 30;

        /**
         * 每次清理的批大小
         */
        private int batchSize = 1000;
    }
}