package com.wework.platform.agent.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

/**
 * AI智能体服务配置类
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Configuration
public class AgentServiceConfiguration {

    /**
     * RestTemplate配置
     */
    @Bean
    public RestTemplate restTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(30000); // 30秒连接超时
        factory.setReadTimeout(60000);    // 60秒读取超时
        
        return new RestTemplate(factory);
    }

    /**
     * ObjectMapper配置
     */
    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        
        // 注册Java时间模块
        mapper.registerModule(new JavaTimeModule());
        
        // 设置属性命名策略
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
        
        // 忽略未知属性
        mapper.configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        
        return mapper;
    }
}