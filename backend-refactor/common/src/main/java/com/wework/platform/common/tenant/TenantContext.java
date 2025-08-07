package com.wework.platform.common.tenant;

import lombok.extern.slf4j.Slf4j;

/**
 * 租户上下文管理
 * 使用ThreadLocal实现线程隔离的租户信息存储
 * 
 * @author WeWork Platform Team
 */
@Slf4j
public class TenantContext {

    private static final ThreadLocal<String> TENANT_ID_HOLDER = new ThreadLocal<>();
    private static final ThreadLocal<String> USER_ID_HOLDER = new ThreadLocal<>();
    private static final ThreadLocal<String> USERNAME_HOLDER = new ThreadLocal<>();
    private static final ThreadLocal<Boolean> SUPER_ADMIN_HOLDER = new ThreadLocal<>();

    /**
     * 设置当前租户ID
     */
    public static void setTenantId(String tenantId) {
        log.debug("设置租户上下文: {}", tenantId);
        TENANT_ID_HOLDER.set(tenantId);
    }

    /**
     * 获取当前租户ID
     */
    public static String getTenantId() {
        return TENANT_ID_HOLDER.get();
    }

    /**
     * 设置当前用户ID
     */
    public static void setUserId(String userId) {
        USER_ID_HOLDER.set(userId);
    }

    /**
     * 获取当前用户ID
     */
    public static String getUserId() {
        return USER_ID_HOLDER.get();
    }

    /**
     * 设置当前用户名
     */
    public static void setUsername(String username) {
        USERNAME_HOLDER.set(username);
    }

    /**
     * 获取当前用户名
     */
    public static String getUsername() {
        return USERNAME_HOLDER.get();
    }

    /**
     * 设置是否为超级管理员
     */
    public static void setSuperAdmin(boolean isSuperAdmin) {
        SUPER_ADMIN_HOLDER.set(isSuperAdmin);
    }

    /**
     * 检查是否为超级管理员
     */
    public static boolean isSuperAdmin() {
        Boolean superAdmin = SUPER_ADMIN_HOLDER.get();
        return superAdmin != null && superAdmin;
    }

    /**
     * 检查是否有租户上下文
     */
    public static boolean hasTenantContext() {
        return getTenantId() != null;
    }

    /**
     * 检查是否有用户上下文
     */
    public static boolean hasUserContext() {
        return getUserId() != null;
    }

    /**
     * 清除所有上下文信息
     */
    public static void clear() {
        log.debug("清除租户上下文");
        TENANT_ID_HOLDER.remove();
        USER_ID_HOLDER.remove();
        USERNAME_HOLDER.remove();
        SUPER_ADMIN_HOLDER.remove();
    }

    /**
     * 获取租户上下文信息
     */
    public static TenantInfo getTenantInfo() {
        return TenantInfo.builder()
                .tenantId(getTenantId())
                .userId(getUserId())
                .username(getUsername())
                .isSuperAdmin(isSuperAdmin())
                .build();
    }

    /**
     * 设置完整的租户上下文
     */
    public static void setTenantContext(String tenantId, String userId, String username, boolean isSuperAdmin) {
        setTenantId(tenantId);
        setUserId(userId);
        setUsername(username);
        setSuperAdmin(isSuperAdmin);
    }

    /**
     * 执行带租户上下文的操作
     */
    public static <T> T executeWithTenant(String tenantId, TenantContextCallback<T> callback) {
        String originalTenantId = getTenantId();
        try {
            setTenantId(tenantId);
            return callback.execute();
        } finally {
            if (originalTenantId != null) {
                setTenantId(originalTenantId);
            } else {
                TENANT_ID_HOLDER.remove();
            }
        }
    }

    /**
     * 执行带完整上下文的操作
     */
    public static <T> T executeWithContext(TenantInfo tenantInfo, TenantContextCallback<T> callback) {
        TenantInfo originalInfo = getTenantInfo();
        try {
            setTenantContext(
                tenantInfo.getTenantId(),
                tenantInfo.getUserId(),
                tenantInfo.getUsername(),
                tenantInfo.isSuperAdmin()
            );
            return callback.execute();
        } finally {
            if (originalInfo.getTenantId() != null) {
                setTenantContext(
                    originalInfo.getTenantId(),
                    originalInfo.getUserId(),
                    originalInfo.getUsername(),
                    originalInfo.isSuperAdmin()
                );
            } else {
                clear();
            }
        }
    }

    /**
     * 验证租户权限
     */
    public static void validateTenantAccess(String resourceTenantId) {
        if (isSuperAdmin()) {
            return; // 超级管理员可以访问所有租户资源
        }
        
        String currentTenantId = getTenantId();
        if (currentTenantId == null) {
            throw new SecurityException("未设置租户上下文");
        }
        
        if (!currentTenantId.equals(resourceTenantId)) {
            log.warn("租户权限验证失败: 当前租户={}, 资源租户={}", currentTenantId, resourceTenantId);
            throw new SecurityException("无权访问其他租户的资源");
        }
    }

    /**
     * 检查租户权限（不抛出异常）
     */
    public static boolean checkTenantAccess(String resourceTenantId) {
        try {
            validateTenantAccess(resourceTenantId);
            return true;
        } catch (SecurityException e) {
            return false;
        }
    }

    /**
     * 确保有租户上下文
     */
    public static void ensureTenantContext() {
        if (!hasTenantContext() && !isSuperAdmin()) {
            throw new IllegalStateException("操作需要租户上下文");
        }
    }

    /**
     * 租户上下文回调接口
     */
    @FunctionalInterface
    public interface TenantContextCallback<T> {
        T execute();
    }

    /**
     * 租户信息类
     */
    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class TenantInfo {
        private String tenantId;
        private String userId;
        private String username;
        private boolean isSuperAdmin;
    }
}