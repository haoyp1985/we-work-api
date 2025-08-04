package com.wework.platform.user;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * 用户权限服务启动类
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@SpringBootApplication(scanBasePackages = {
        "com.wework.platform.user",
        "com.wework.platform.common"
})
@EnableDiscoveryClient
@EnableFeignClients
@EnableCaching
@MapperScan("com.wework.platform.user.mapper")
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}