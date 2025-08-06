package com.wework.platform.common.context;

import lombok.extern.slf4j.Slf4j;

/**
 * 租户上下文持有者
 * 使用ThreadLocal存储当前线程的租户信息
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
public class TenantContextHolder {

    private static final ThreadLocal<String> TENANT_CONTEXT = new ThreadLocal<>();

    /**
     * 设置当前租户ID
     */
    public static void setTenantId(String tenantId) {
        if (tenantId != null) {
            TENANT_CONTEXT.set(tenantId);
            log.debug("Set tenant ID: {}", tenantId);
        }
    }

    /**
     * 获取当前租户ID
     */
    public static String getTenantId() {
        return TENANT_CONTEXT.get();
    }

    /**
     * 清除当前租户ID
     */
    public static void clear() {
        String tenantId = TENANT_CONTEXT.get();
        if (tenantId != null) {
            log.debug("Clear tenant ID: {}", tenantId);
            TENANT_CONTEXT.remove();
        }
    }

    /**
     * 获取当前租户ID，如果为空则返回默认值
     */
    public static String getTenantIdOrDefault(String defaultTenantId) {
        String tenantId = getTenantId();
        return tenantId != null ? tenantId : defaultTenantId;
    }

    /**
     * 检查当前是否有租户上下文
     */
    public static boolean hasTenantContext() {
        return getTenantId() != null;
    }

    /**
     * 使用指定租户ID执行代码块
     */
    public static <T> T withTenantId(String tenantId, TenantAction<T> action) {
        String originalTenantId = getTenantId();
        try {
            setTenantId(tenantId);
            return action.execute();
        } finally {
            if (originalTenantId != null) {
                setTenantId(originalTenantId);
            } else {
                clear();
            }
        }
    }

    /**
     * 使用指定租户ID执行代码块（无返回值）
     */
    public static void withTenantId(String tenantId, TenantTask task) {
        withTenantId(tenantId, () -> {
            task.execute();
            return null;
        });
    }

    /**
     * 租户操作接口（有返回值）
     */
    @FunctionalInterface
    public interface TenantAction<T> {
        T execute();
    }

    /**
     * 租户任务接口（无返回值）
     */
    @FunctionalInterface
    public interface TenantTask {
        void execute();
    }
}