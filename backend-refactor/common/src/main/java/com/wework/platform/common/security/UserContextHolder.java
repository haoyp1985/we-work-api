package com.wework.platform.common.security;

import lombok.extern.slf4j.Slf4j;

/**
 * 用户上下文持有者
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
public class UserContextHolder {

    private static final ThreadLocal<UserContext> CONTEXT_HOLDER = new ThreadLocal<>();

    /**
     * 设置用户上下文
     */
    public static void setContext(UserContext context) {
        CONTEXT_HOLDER.set(context);
    }

    /**
     * 获取用户上下文
     */
    public static UserContext getContext() {
        return CONTEXT_HOLDER.get();
    }

    /**
     * 获取当前用户ID
     */
    public static String getCurrentUserId() {
        UserContext context = getContext();
        return context != null ? context.getUserId() : null;
    }

    /**
     * 获取当前租户ID
     */
    public static String getCurrentTenantId() {
        UserContext context = getContext();
        return context != null ? context.getTenantId() : null;
    }

    /**
     * 获取当前用户名
     */
    public static String getCurrentUsername() {
        UserContext context = getContext();
        return context != null ? context.getUsername() : null;
    }

    /**
     * 检查是否已登录
     */
    public static boolean isAuthenticated() {
        UserContext context = getContext();
        return context != null && context.getUserId() != null;
    }

    /**
     * 检查是否有指定权限
     */
    public static boolean hasPermission(String permission) {
        UserContext context = getContext();
        return context != null && context.hasPermission(permission);
    }

    /**
     * 检查是否有指定角色
     */
    public static boolean hasRole(String role) {
        UserContext context = getContext();
        return context != null && context.hasRole(role);
    }

    /**
     * 清除用户上下文
     */
    public static void clear() {
        CONTEXT_HOLDER.remove();
    }
}