package com.wework.platform.account;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * 企微账号服务启动类
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@SpringBootApplication(scanBasePackages = {
        "com.wework.platform.account",
        "com.wework.platform.common"
})
@EnableDiscoveryClient
@EnableFeignClients
@EnableCaching
@MapperScan("com.wework.platform.account.repository")
public class AccountServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AccountServiceApplication.class, args);
    }
}