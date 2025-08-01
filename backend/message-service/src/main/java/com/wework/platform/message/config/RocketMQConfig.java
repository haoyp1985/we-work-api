package com.wework.platform.message.config;

import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.client.consumer.DefaultMQPushConsumer;
import org.apache.rocketmq.client.producer.DefaultMQProducer;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

/**
 * RocketMQ配置
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Configuration
public class RocketMQConfig {

    @Value("${rocketmq-native.name-server}")
    private String nameServer;

    @Value("${rocketmq-native.producer.group}")
    private String producerGroup;

    @Value("${rocketmq-native.producer.send-message-timeout:3000}")
    private int sendMessageTimeout;

    @Value("${rocketmq-native.producer.retry-times-when-send-failed:3}")
    private int retryTimesWhenSendFailed;

    @Value("${rocketmq-native.producer.max-message-size:4194304}")
    private int maxMessageSize;

    /**
     * RocketMQ生产者配置
     */
    @Bean
    @Primary
    public DefaultMQProducer defaultMQProducer() {
        DefaultMQProducer producer = new DefaultMQProducer();
        producer.setProducerGroup(producerGroup);
        producer.setNamesrvAddr(nameServer);
        producer.setSendMsgTimeout(sendMessageTimeout);
        producer.setRetryTimesWhenSendFailed(retryTimesWhenSendFailed);
        producer.setMaxMessageSize(maxMessageSize);
        // producer.setCompressMsgBodyOverHowMuch(4096); // 在新版本RocketMQ中此方法已移除
        
        log.info("RocketMQ生产者配置完成: nameServer={}, group={}", nameServer, producerGroup);
        
        return producer;
    }

    /**
     * 创建Topic配置
     */
    @Bean
    public RocketMQTopicInitializer topicInitializer() {
        return new RocketMQTopicInitializer();
    }

    /**
     * RocketMQTemplate配置 (手动创建以确保可用)
     */
    @Bean
    public RocketMQTemplate rocketMQTemplate() {
        RocketMQTemplate template = new RocketMQTemplate();
        template.setProducer(defaultMQProducer());
        log.info("RocketMQTemplate配置完成");
        return template;
    }

    /**
     * Topic初始化器
     */
    public static class RocketMQTopicInitializer {
        
        public RocketMQTopicInitializer() {
            log.info("RocketMQ Topic初始化器已创建");
            // 这里可以添加Topic自动创建逻辑
            // 注意：生产环境建议手动创建Topic
        }
    }
}