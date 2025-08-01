package com.wework.platform.message;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 消息发送服务启动类
 *
 * @author WeWork Platform Team
 */
@SpringBootApplication(scanBasePackages = {
        "com.wework.platform.message",
        "com.wework.platform.common"
})
@EnableDiscoveryClient
@EnableFeignClients
@EnableAsync
@EnableScheduling
@MapperScan("com.wework.platform.message.repository")
public class MessageServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(MessageServiceApplication.class, args);
    }
}