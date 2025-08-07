package com.wework.platform.common.tenant;

import java.lang.annotation.*;

/**
 * 租户隔离注解
 * 标记需要租户隔离的方法或类
 * 
 * @author WeWork Platform Team
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface TenantRequired {

    /**
     * 是否强制要求租户上下文
     * 默认为true，表示必须有租户上下文才能执行
     */
    boolean required() default true;

    /**
     * 是否允许超级管理员跨租户访问
     * 默认为true，表示超级管理员可以访问所有租户数据
     */
    boolean allowSuperAdmin() default true;

    /**
     * 租户验证类型
     */
    TenantValidationType validationType() default TenantValidationType.CURRENT_TENANT;

    /**
     * 错误消息
     */
    String message() default "需要租户权限";

    /**
     * 租户验证类型枚举
     */
    enum TenantValidationType {
        /**
         * 验证当前租户上下文
         */
        CURRENT_TENANT,
        
        /**
         * 验证参数中的租户ID
         */
        PARAMETER_TENANT,
        
        /**
         * 自定义验证逻辑
         */
        CUSTOM
    }
}