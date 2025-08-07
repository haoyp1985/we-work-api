package com.wework.platform.gateway;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Bean;

/**
 * 网关服务启动类
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@SpringBootApplication(
        scanBasePackages = {
                "com.wework.platform.gateway",
                "com.wework.platform.common"
        },
        exclude = {DataSourceAutoConfiguration.class}
)
@EnableDiscoveryClient
public class GatewayServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(GatewayServiceApplication.class, args);
    }

    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }
}