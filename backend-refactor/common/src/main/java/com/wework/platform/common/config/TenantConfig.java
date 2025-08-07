package com.wework.platform.common.config;

import com.wework.platform.common.tenant.TenantDataScopeInterceptor;
import com.wework.platform.common.tenant.TenantInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 租户配置类
 * 注册租户相关的拦截器和组件
 * 
 * @author WeWork Platform Team
 */
@Configuration
public class TenantConfig implements WebMvcConfigurer {

    @Autowired
    private TenantInterceptor tenantInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(tenantInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                    "/api/health",
                    "/api/login", 
                    "/api/logout",
                    "/api/register",
                    "/actuator/**",
                    "/swagger/**",
                    "/v3/api-docs/**",
                    "/error"
                )
                .order(1); // 设置优先级，确保在其他拦截器之前执行
    }

    /**
     * 注册MyBatis租户数据隔离拦截器
     * 这个方法会被MyBatis自动调用
     */
    @org.springframework.context.annotation.Bean
    public TenantDataScopeInterceptor tenantDataScopeInterceptor() {
        return new TenantDataScopeInterceptor();
    }
}