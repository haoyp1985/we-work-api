package com.wework.platform.message;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 消息服务启动类
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients(basePackages = "com.wework.platform")
@EnableAsync
@EnableScheduling
@EnableTransactionManagement
@MapperScan("com.wework.platform.message.repository")
@ComponentScan(basePackages = {
        "com.wework.platform.message",
        "com.wework.platform.common"
})
public class MessageServiceApplication {

    public static void main(String[] args) {
        System.setProperty("spring.application.name", "message-service");
        SpringApplication.run(MessageServiceApplication.class, args);
    }
}