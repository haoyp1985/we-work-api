package com.wework.platform.common.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.TenantLineInnerInterceptor;
import com.wework.platform.common.security.UserContextHolder;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;

/**
 * MyBatis Plus 配置
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
@Configuration
public class MyBatisPlusConfig {

    /**
     * MyBatis Plus 插件配置
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        
        // 多租户插件
        interceptor.addInnerInterceptor(tenantLineInnerInterceptor());
        
        // 分页插件
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        
        return interceptor;
    }

    /**
     * 多租户插件配置
     */
    private TenantLineInnerInterceptor tenantLineInnerInterceptor() {
        TenantLineInnerInterceptor interceptor = new TenantLineInnerInterceptor();
        
        // 设置租户处理器
        interceptor.setTenantLineHandler(new CustomTenantLineHandler());
        
        return interceptor;
    }

    /**
     * 元对象字段填充控制器
     */
    @Bean
    public MetaObjectHandler metaObjectHandler() {
        return new CustomMetaObjectHandler();
    }

    /**
     * 自定义元对象处理器
     */
    @Slf4j
    public static class CustomMetaObjectHandler implements MetaObjectHandler {

        @Override
        public void insertFill(MetaObject metaObject) {
            String currentUserId = UserContextHolder.getCurrentUserId();
            LocalDateTime now = LocalDateTime.now();
            
            // 填充创建时间
            this.strictInsertFill(metaObject, "createdAt", LocalDateTime.class, now);
            this.strictInsertFill(metaObject, "updatedAt", LocalDateTime.class, now);
            
            // 填充创建者
            if (currentUserId != null) {
                this.strictInsertFill(metaObject, "createdBy", String.class, currentUserId);
                this.strictInsertFill(metaObject, "updatedBy", String.class, currentUserId);
            }
            
            log.debug("自动填充插入字段: createdAt={}, createdBy={}", now, currentUserId);
        }

        @Override
        public void updateFill(MetaObject metaObject) {
            String currentUserId = UserContextHolder.getCurrentUserId();
            LocalDateTime now = LocalDateTime.now();
            
            // 填充更新时间
            this.strictUpdateFill(metaObject, "updatedAt", LocalDateTime.class, now);
            
            // 填充更新者
            if (currentUserId != null) {
                this.strictUpdateFill(metaObject, "updatedBy", String.class, currentUserId);
            }
            
            log.debug("自动填充更新字段: updatedAt={}, updatedBy={}", now, currentUserId);
        }
    }
}