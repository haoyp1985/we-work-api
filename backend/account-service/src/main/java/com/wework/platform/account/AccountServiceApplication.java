package com.wework.platform.account;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 账号管理服务启动类
 *
 * @author WeWork Platform Team
 */
@SpringBootApplication(scanBasePackages = {
        "com.wework.platform.account",
        "com.wework.platform.common"
})
@EnableDiscoveryClient
@EnableAsync
@EnableScheduling
@MapperScan("com.wework.platform.account.repository")
public class AccountServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AccountServiceApplication.class, args);
    }
}