package com.wework.platform.common.config;

import com.baomidou.mybatisplus.extension.plugins.handler.TenantLineHandler;
import com.wework.platform.common.security.UserContextHolder;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.StringValue;

import java.util.Arrays;
import java.util.List;

/**
 * 自定义多租户处理器
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
public class CustomTenantLineHandler implements TenantLineHandler {

    /**
     * 不进行多租户隔离的表
     */
    private static final List<String> IGNORE_TABLES = Arrays.asList(
            // 系统表，不需要租户隔离
            "tenants",
            "permissions", 
            "dictionaries",
            "system_configs",
            
            // 监控表，全局性质
            "system_alerts",
            "alert_rules",
            "system_metrics",
            "error_logs",
            "api_call_logs",
            "data_retention_policies"
    );

    @Override
    public Expression getTenantId() {
        String tenantId = UserContextHolder.getCurrentTenantId();
        if (tenantId != null) {
            log.debug("当前租户ID: {}", tenantId);
            return new StringValue(tenantId);
        }
        log.debug("未获取到租户ID，跳过多租户处理");
        return null;
    }

    @Override
    public String getTenantIdColumn() {
        return "tenant_id";
    }

    @Override
    public boolean ignoreTable(String tableName) {
        boolean ignore = IGNORE_TABLES.contains(tableName.toLowerCase());
        if (ignore) {
            log.debug("表 {} 忽略多租户处理", tableName);
        }
        return ignore;
    }

    @Override
    public boolean ignoreInsert(List<net.sf.jsqlparser.schema.Column> columns, String tenantIdColumn) {
        // 如果插入语句中已经包含租户ID列，则忽略自动添加
        return columns.stream().anyMatch(column -> 
                tenantIdColumn.equalsIgnoreCase(column.getColumnName()));
    }
}