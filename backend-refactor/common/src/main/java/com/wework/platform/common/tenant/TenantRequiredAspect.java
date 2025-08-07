package com.wework.platform.common.tenant;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;

/**
 * 租户权限验证切面
 * 处理@TenantRequired注解的权限验证逻辑
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Aspect
@Component
@Order(100) // 确保在事务切面之前执行
public class TenantRequiredAspect {

    @Around("@annotation(com.wework.platform.common.tenant.TenantRequired) || " +
            "@within(com.wework.platform.common.tenant.TenantRequired)")
    public Object validateTenantAccess(ProceedingJoinPoint joinPoint) throws Throwable {
        
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        
        // 获取注解信息
        TenantRequired tenantRequired = method.getAnnotation(TenantRequired.class);
        if (tenantRequired == null) {
            // 如果方法上没有注解，检查类上的注解
            tenantRequired = method.getDeclaringClass().getAnnotation(TenantRequired.class);
        }
        
        if (tenantRequired == null) {
            log.warn("租户权限切面被触发但未找到@TenantRequired注解: {}", method.getName());
            return joinPoint.proceed();
        }

        log.debug("执行租户权限验证: {}.{}", method.getDeclaringClass().getSimpleName(), method.getName());

        try {
            // 验证租户权限
            validateTenantPermission(joinPoint, tenantRequired);
            
            // 执行目标方法
            return joinPoint.proceed();
            
        } catch (SecurityException e) {
            log.warn("租户权限验证失败: {}.{} - {}", 
                method.getDeclaringClass().getSimpleName(), method.getName(), e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("租户权限验证过程中发生异常: {}.{}", 
                method.getDeclaringClass().getSimpleName(), method.getName(), e);
            throw e;
        }
    }

    /**
     * 验证租户权限
     */
    private void validateTenantPermission(ProceedingJoinPoint joinPoint, TenantRequired tenantRequired) {
        
        // 检查是否允许超级管理员访问
        if (tenantRequired.allowSuperAdmin() && TenantContext.isSuperAdmin()) {
            log.debug("超级管理员跳过租户权限验证");
            return;
        }

        // 根据验证类型进行不同的验证逻辑
        switch (tenantRequired.validationType()) {
            case CURRENT_TENANT:
                validateCurrentTenant(tenantRequired);
                break;
            case PARAMETER_TENANT:
                validateParameterTenant(joinPoint, tenantRequired);
                break;
            case CUSTOM:
                // 自定义验证逻辑可以在这里扩展
                validateCurrentTenant(tenantRequired);
                break;
            default:
                throw new IllegalArgumentException("不支持的租户验证类型: " + tenantRequired.validationType());
        }
    }

    /**
     * 验证当前租户上下文
     */
    private void validateCurrentTenant(TenantRequired tenantRequired) {
        if (tenantRequired.required() && !TenantContext.hasTenantContext()) {
            throw new SecurityException(tenantRequired.message() + ": 缺少租户上下文");
        }
    }

    /**
     * 验证参数中的租户ID
     */
    private void validateParameterTenant(ProceedingJoinPoint joinPoint, TenantRequired tenantRequired) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        Parameter[] parameters = method.getParameters();
        Object[] args = joinPoint.getArgs();

        String parameterTenantId = null;

        // 查找参数中的tenantId
        for (int i = 0; i < parameters.length; i++) {
            Parameter parameter = parameters[i];
            if (parameter.getName().equals("tenantId") && args[i] instanceof String) {
                parameterTenantId = (String) args[i];
                break;
            }
        }

        if (parameterTenantId == null) {
            log.warn("使用PARAMETER_TENANT验证但未找到tenantId参数: {}", method.getName());
            // 回退到当前租户验证
            validateCurrentTenant(tenantRequired);
            return;
        }

        // 验证参数租户ID与当前租户上下文是否匹配
        if (!TenantContext.isSuperAdmin()) {
            String currentTenantId = TenantContext.getTenantId();
            if (currentTenantId == null) {
                throw new SecurityException(tenantRequired.message() + ": 缺少租户上下文");
            }
            
            if (!currentTenantId.equals(parameterTenantId)) {
                throw new SecurityException(tenantRequired.message() + ": 租户权限不匹配");
            }
        }
    }
}