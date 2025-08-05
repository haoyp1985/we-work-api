package com.wework.platform.user.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

/**
 * UserService配置类
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Configuration
@MapperScan("com.wework.platform.user.repository")
public class UserServiceConfig {
    
}