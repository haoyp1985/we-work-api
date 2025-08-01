package com.wework.platform.message.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * 消息服务配置
 *
 * @author WeWork Platform Team
 */
@Configuration
@EnableAsync
@EnableRetry
public class MessageConfig {

    @Value("${app.message.async.core-pool-size:10}")
    private int corePoolSize;

    @Value("${app.message.async.max-pool-size:50}")
    private int maxPoolSize;

    @Value("${app.message.async.queue-capacity:1000}")
    private int queueCapacity;

    @Value("${app.message.async.keep-alive-seconds:60}")
    private int keepAliveSeconds;

    /**
     * 异步消息发送线程池
     */
    @Bean("messageAsyncExecutor")
    public Executor messageAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(corePoolSize);
        executor.setMaxPoolSize(maxPoolSize);
        executor.setQueueCapacity(queueCapacity);
        executor.setKeepAliveSeconds(keepAliveSeconds);
        executor.setThreadNamePrefix("message-async-");
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(30);
        executor.initialize();
        return executor;
    }

    /**
     * 回调处理线程池
     */
    @Bean("callbackExecutor")
    public Executor callbackExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(500);
        executor.setKeepAliveSeconds(60);
        executor.setThreadNamePrefix("callback-");
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(30);
        executor.initialize();
        return executor;
    }
}