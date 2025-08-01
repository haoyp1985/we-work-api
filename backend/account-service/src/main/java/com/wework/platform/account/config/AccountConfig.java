package com.wework.platform.account.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * 账号服务配置
 *
 * @author WeWork Platform Team
 */
@Configuration
public class AccountConfig {

    // 交换机名称
    public static final String ACCOUNT_EXCHANGE = "account.exchange";
    
    // 队列名称
    public static final String ACCOUNT_STATUS_QUEUE = "account.status.queue";
    public static final String ACCOUNT_HEARTBEAT_QUEUE = "account.heartbeat.queue";
    public static final String ACCOUNT_NOTIFICATION_QUEUE = "account.notification.queue";
    
    // 路由键
    public static final String ACCOUNT_STATUS_ROUTING_KEY = "account.status";
    public static final String ACCOUNT_HEARTBEAT_ROUTING_KEY = "account.heartbeat";
    public static final String ACCOUNT_NOTIFICATION_ROUTING_KEY = "account.notification";

    /**
     * 账号交换机
     */
    @Bean
    public TopicExchange accountExchange() {
        return ExchangeBuilder.topicExchange(ACCOUNT_EXCHANGE)
                .durable(true)
                .build();
    }

    /**
     * 账号状态队列
     */
    @Bean
    public Queue accountStatusQueue() {
        return QueueBuilder.durable(ACCOUNT_STATUS_QUEUE)
                .withArgument("x-message-ttl", 300000) // 5分钟TTL
                .build();
    }

    /**
     * 账号心跳队列
     */
    @Bean
    public Queue accountHeartbeatQueue() {
        return QueueBuilder.durable(ACCOUNT_HEARTBEAT_QUEUE)
                .withArgument("x-message-ttl", 60000) // 1分钟TTL
                .build();
    }

    /**
     * 账号通知队列
     */
    @Bean
    public Queue accountNotificationQueue() {
        return QueueBuilder.durable(ACCOUNT_NOTIFICATION_QUEUE)
                .build();
    }

    /**
     * 绑定状态队列到交换机
     */
    @Bean
    public Binding accountStatusBinding() {
        return BindingBuilder.bind(accountStatusQueue())
                .to(accountExchange())
                .with(ACCOUNT_STATUS_ROUTING_KEY);
    }

    /**
     * 绑定心跳队列到交换机
     */
    @Bean
    public Binding accountHeartbeatBinding() {
        return BindingBuilder.bind(accountHeartbeatQueue())
                .to(accountExchange())
                .with(ACCOUNT_HEARTBEAT_ROUTING_KEY);
    }

    /**
     * 绑定通知队列到交换机
     */
    @Bean
    public Binding accountNotificationBinding() {
        return BindingBuilder.bind(accountNotificationQueue())
                .to(accountExchange())
                .with(ACCOUNT_NOTIFICATION_ROUTING_KEY);
    }

    /**
     * 消息转换器
     */
    @Bean
    public MessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    /**
     * RabbitTemplate配置
     */
    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate template = new RabbitTemplate(connectionFactory);
        template.setMessageConverter(messageConverter());
        template.setMandatory(true);
        template.setConfirmCallback((correlationData, ack, cause) -> {
            if (!ack) {
                // 消息发送失败处理
                System.err.println("消息发送失败: " + cause);
            }
        });
        template.setReturnsCallback(returnedMessage -> {
            // 消息被退回处理
            System.err.println("消息被退回: " + returnedMessage.getMessage());
        });
        return template;
    }

    /**
     * 监听器容器工厂
     */
    @Bean
    public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory(ConnectionFactory connectionFactory) {
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setMessageConverter(messageConverter());
        factory.setConcurrentConsumers(3);
        factory.setMaxConcurrentConsumers(10);
        factory.setPrefetchCount(10);
        return factory;
    }

    /**
     * 异步任务执行器
     */
    @Bean(name = "accountTaskExecutor")
    public Executor accountTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("account-task-");
        executor.setKeepAliveSeconds(60);
        executor.setRejectedExecutionHandler(new java.util.concurrent.ThreadPoolExecutor.CallerRunsPolicy());
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(30);
        executor.initialize();
        return executor;
    }
}