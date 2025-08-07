package com.wework.platform.common.tenant;

import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.cache.CacheKey;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlSource;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Component;

import java.util.Properties;
import java.util.regex.Pattern;

/**
 * 租户数据范围拦截器
 * 自动为SQL查询添加租户ID过滤条件
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Component
@Intercepts({
    @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
    @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class, CacheKey.class, BoundSql.class}),
    @Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})
})
public class TenantDataScopeInterceptor implements Interceptor {

    /**
     * 需要进行租户隔离的表名模式
     */
    private static final Pattern TENANT_TABLE_PATTERN = Pattern.compile(
        ".*(wework_accounts|account_status_history|account_alerts|tenant_usage|account_monitor_rules).*",
        Pattern.CASE_INSENSITIVE
    );

    /**
     * 不需要租户隔离的SQL模式
     */
    private static final Pattern SKIP_TENANT_SQL_PATTERN = Pattern.compile(
        ".*(information_schema|mysql|performance_schema|sys|show|desc|explain).*",
        Pattern.CASE_INSENSITIVE
    );

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        Object[] args = invocation.getArgs();
        MappedStatement mappedStatement = (MappedStatement) args[0];
        Object parameter = args[1];
        
        // 检查是否需要进行租户隔离
        if (!shouldApplyTenantScope(mappedStatement)) {
            return invocation.proceed();
        }

        // 获取当前租户ID
        String currentTenantId = TenantContext.getTenantId();
        
        // 如果是超级管理员或者没有租户上下文，跳过租户隔离
        if (TenantContext.isSuperAdmin() || currentTenantId == null) {
            log.debug("跳过租户数据隔离: 超级管理员={}, 租户ID={}", 
                TenantContext.isSuperAdmin(), currentTenantId);
            return invocation.proceed();
        }

        try {
            // 获取原始SQL
            BoundSql boundSql = mappedStatement.getBoundSql(parameter);
            String originalSql = boundSql.getSql();
            
            // 检查SQL是否需要添加租户过滤条件
            if (!needsTenantFilter(originalSql)) {
                return invocation.proceed();
            }

            // 添加租户过滤条件
            String modifiedSql = addTenantFilter(originalSql, currentTenantId);
            
            if (!originalSql.equals(modifiedSql)) {
                log.debug("添加租户过滤条件: 租户={}, 原SQL长度={}, 修改后SQL长度={}", 
                    currentTenantId, originalSql.length(), modifiedSql.length());
                
                // 创建新的MappedStatement
                MappedStatement newMappedStatement = createNewMappedStatement(mappedStatement, modifiedSql);
                args[0] = newMappedStatement;
            }

            return invocation.proceed();

        } catch (Exception e) {
            log.error("租户数据隔离处理失败: {}", e.getMessage(), e);
            // 发生异常时继续执行原SQL，避免影响业务
            return invocation.proceed();
        }
    }

    /**
     * 检查是否需要应用租户范围
     */
    private boolean shouldApplyTenantScope(MappedStatement mappedStatement) {
        String statementId = mappedStatement.getId();
        
        // 跳过系统级别的查询
        if (statementId.contains("system") || statementId.contains("admin")) {
            return false;
        }

        return true;
    }

    /**
     * 检查SQL是否需要租户过滤
     */
    private boolean needsTenantFilter(String sql) {
        String lowerCaseSql = sql.toLowerCase().trim();
        
        // 跳过系统表查询
        if (SKIP_TENANT_SQL_PATTERN.matcher(lowerCaseSql).find()) {
            return false;
        }

        // 检查是否包含需要租户隔离的表
        if (!TENANT_TABLE_PATTERN.matcher(lowerCaseSql).find()) {
            return false;
        }

        // 检查是否已经包含tenant_id条件
        if (lowerCaseSql.contains("tenant_id")) {
            log.debug("SQL已包含tenant_id条件，跳过自动添加");
            return false;
        }

        return true;
    }

    /**
     * 为SQL添加租户过滤条件
     */
    private String addTenantFilter(String originalSql, String tenantId) {
        String sql = originalSql.trim();
        String lowerCaseSql = sql.toLowerCase();

        try {
            if (lowerCaseSql.startsWith("select")) {
                return addTenantFilterToSelect(sql, tenantId);
            } else if (lowerCaseSql.startsWith("update")) {
                return addTenantFilterToUpdate(sql, tenantId);
            } else if (lowerCaseSql.startsWith("delete")) {
                return addTenantFilterToDelete(sql, tenantId);
            } else if (lowerCaseSql.startsWith("insert")) {
                // INSERT语句一般不需要添加WHERE条件，但可以在VALUES中添加tenant_id
                return sql; // 暂时不处理INSERT，交给应用层处理
            }
        } catch (Exception e) {
            log.warn("添加租户过滤条件失败，使用原SQL: {}", e.getMessage());
        }

        return sql;
    }

    /**
     * 为SELECT语句添加租户过滤条件
     */
    private String addTenantFilterToSelect(String sql, String tenantId) {
        // 简单的WHERE条件添加逻辑
        if (sql.toLowerCase().contains(" where ")) {
            // 已有WHERE条件，添加AND
            return sql + " AND tenant_id = '" + tenantId + "'";
        } else {
            // 没有WHERE条件，添加WHERE
            // 找到FROM子句后的位置
            int fromIndex = sql.toLowerCase().indexOf(" from ");
            if (fromIndex == -1) {
                return sql;
            }
            
            // 查找GROUP BY, ORDER BY, LIMIT等子句
            String[] endClauses = {" group by ", " order by ", " limit ", " having "};
            int insertIndex = sql.length();
            
            for (String clause : endClauses) {
                int clauseIndex = sql.toLowerCase().indexOf(clause);
                if (clauseIndex != -1 && clauseIndex < insertIndex) {
                    insertIndex = clauseIndex;
                }
            }
            
            return sql.substring(0, insertIndex) + " WHERE tenant_id = '" + tenantId + "'" + sql.substring(insertIndex);
        }
    }

    /**
     * 为UPDATE语句添加租户过滤条件
     */
    private String addTenantFilterToUpdate(String sql, String tenantId) {
        if (sql.toLowerCase().contains(" where ")) {
            return sql + " AND tenant_id = '" + tenantId + "'";
        } else {
            return sql + " WHERE tenant_id = '" + tenantId + "'";
        }
    }

    /**
     * 为DELETE语句添加租户过滤条件
     */
    private String addTenantFilterToDelete(String sql, String tenantId) {
        if (sql.toLowerCase().contains(" where ")) {
            return sql + " AND tenant_id = '" + tenantId + "'";
        } else {
            return sql + " WHERE tenant_id = '" + tenantId + "'";
        }
    }

    /**
     * 创建新的MappedStatement
     */
    private MappedStatement createNewMappedStatement(MappedStatement originalStatement, String newSql) {
        MappedStatement.Builder builder = new MappedStatement.Builder(
            originalStatement.getConfiguration(),
            originalStatement.getId(),
            new StaticSqlSource(originalStatement.getConfiguration(), newSql),
            originalStatement.getSqlCommandType()
        );

        builder.resource(originalStatement.getResource());
        builder.fetchSize(originalStatement.getFetchSize());
        builder.timeout(originalStatement.getTimeout());
        builder.statementType(originalStatement.getStatementType());
        builder.keyGenerator(originalStatement.getKeyGenerator());
        builder.keyProperty(originalStatement.getKeyProperties() != null ? String.join(",", originalStatement.getKeyProperties()) : null);
        builder.keyColumn(originalStatement.getKeyColumns() != null ? String.join(",", originalStatement.getKeyColumns()) : null);
        builder.databaseId(originalStatement.getDatabaseId());
        builder.lang(originalStatement.getLang());
        builder.resultOrdered(originalStatement.isResultOrdered());
        builder.resultSets(originalStatement.getResultSets() != null ? String.join(",", originalStatement.getResultSets()) : null);
        builder.resultMaps(originalStatement.getResultMaps());
        builder.resultSetType(originalStatement.getResultSetType());
        builder.flushCacheRequired(originalStatement.isFlushCacheRequired());
        builder.useCache(originalStatement.isUseCache());
        builder.cache(originalStatement.getCache());
        builder.parameterMap(originalStatement.getParameterMap());

        return builder.build();
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
        // 可以从properties中读取配置
    }

    /**
     * 静态SQL源
     */
    private static class StaticSqlSource implements SqlSource {
        private final String sql;
        private final org.apache.ibatis.session.Configuration configuration;

        public StaticSqlSource(org.apache.ibatis.session.Configuration configuration, String sql) {
            this.sql = sql;
            this.configuration = configuration;
        }

        @Override
        public BoundSql getBoundSql(Object parameterObject) {
            return new BoundSql(configuration, sql, null, parameterObject);
        }
    }
}