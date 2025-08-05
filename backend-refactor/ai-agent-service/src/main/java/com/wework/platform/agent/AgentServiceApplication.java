package com.wework.platform.agent;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * AI智能体服务启动类
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@SpringBootApplication
@EnableDiscoveryClient
@EnableTransactionManagement
@MapperScan("com.wework.platform.agent.repository")
public class AgentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AgentServiceApplication.class, args);
    }
}