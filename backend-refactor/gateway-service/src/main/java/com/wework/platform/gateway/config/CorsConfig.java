package com.wework.platform.gateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

/**
 * CORS配置类
 * 允许前端跨域访问网关服务
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsWebFilter corsWebFilter() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        
        // 允许的源
        corsConfig.addAllowedOriginPattern("*");
        // 或者明确指定前端地址
        // corsConfig.addAllowedOrigin("http://localhost:15000");
        // corsConfig.addAllowedOrigin("http://127.0.0.1:15000");
        
        // 允许的HTTP方法
        corsConfig.addAllowedMethod("*");
        
        // 允许的请求头
        corsConfig.addAllowedHeader("*");
        
        // 允许发送凭证（cookies等）
        corsConfig.setAllowCredentials(true);
        
        // 预检请求的缓存时间（秒）
        corsConfig.setMaxAge(3600L);
        
        // 暴露的响应头
        corsConfig.addExposedHeader("Authorization");
        corsConfig.addExposedHeader("Content-Type");
        corsConfig.addExposedHeader("X-Requested-With");
        corsConfig.addExposedHeader("Accept");
        corsConfig.addExposedHeader("Origin");
        corsConfig.addExposedHeader("Access-Control-Request-Method");
        corsConfig.addExposedHeader("Access-Control-Request-Headers");
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);
        
        return new CorsWebFilter(source);
    }
}
