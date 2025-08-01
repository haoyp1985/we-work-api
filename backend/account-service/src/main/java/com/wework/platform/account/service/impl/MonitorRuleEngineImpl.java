package com.wework.platform.account.service.impl;

import com.wework.platform.account.service.MonitorRuleEngine;
import com.wework.platform.account.repository.AccountMonitorRuleRepository;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.entity.AccountMonitorRule;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.enums.MonitorRuleType;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.common.tenant.TenantRequired;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.data.redis.core.RedisTemplate;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

/**
 * 监控规则引擎实现
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
@TenantRequired
public class MonitorRuleEngineImpl implements MonitorRuleEngine {

    private final AccountMonitorRuleRepository ruleRepository;
    private final RedisTemplate<String, Object> redisTemplate;
    
    private final ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
    private static final String RULE_CACHE_PREFIX = "rule:";
    private static final int CACHE_EXPIRE_SECONDS = 600; // 10分钟

    @Override
    public List<AccountAlert> executeRules(WeWorkAccount account) {
        log.debug("执行账号监控规则: accountId={}, tenantId={}", account.getId(), account.getTenantId());
        
        List<AccountMonitorRule> rules = getTenantRules(account.getTenantId());
        List<AccountAlert> alerts = new ArrayList<>();
        
        for (AccountMonitorRule rule : rules) {
            if (!rule.getEnabled()) {
                continue;
            }
            
            try {
                AccountAlert alert = executeRule(account, rule);
                if (alert != null) {
                    alerts.add(alert);
                }
            } catch (Exception e) {
                log.warn("执行监控规则失败: ruleId={}, accountId={}, error={}", 
                    rule.getId(), account.getId(), e.getMessage());
            }
        }
        
        log.debug("监控规则执行完成: accountId={}, 触发告警数={}", account.getId(), alerts.size());
        return alerts;
    }

    @Override
    public AccountAlert executeRule(WeWorkAccount account, AccountMonitorRule rule) {
        try {
            // 检查规则是否匹配
            if (!evaluateRuleCondition(account, rule)) {
                return null;
            }
            
            // 创建告警
            AccountAlert alert = new AccountAlert();
            alert.setId(UUID.randomUUID().toString());
            alert.setTenantId(account.getTenantId());
            alert.setAccountId(account.getId());
            alert.setRuleId(rule.getId());
            alert.setAlertType(rule.getAlertType());
            alert.setAlertLevel(rule.getAlertLevel());
            alert.setAlertMessage(formatAlertMessage(account, rule));
            alert.setStatus(AlertStatus.ACTIVE);
            alert.setFirstOccurredAt(LocalDateTime.now());
            alert.setLastOccurredAt(LocalDateTime.now());
            alert.setOccurrenceCount(1);
            alert.setAutoRecoveryAttempts(0);
            
            // 设置告警数据
            Map<String, Object> alertData = new HashMap<>();
            alertData.put("ruleName", rule.getRuleName());
            alertData.put("ruleExpression", rule.getRuleExpression());
            alertData.put("accountStatus", account.getStatus().name());
            alertData.put("healthScore", account.getHealthScore());
            alertData.put("retryCount", account.getRetryCount());
            alertData.put("lastHeartbeatTime", account.getLastHeartbeatTime());
            alert.setAlertData(alertData);
            
            log.info("监控规则触发告警: ruleId={}, accountId={}, alertType={}", 
                rule.getId(), account.getId(), rule.getAlertType());
            
            return alert;
            
        } catch (Exception e) {
            log.error("执行监控规则异常: ruleId={}, accountId={}, error={}", 
                rule.getId(), account.getId(), e.getMessage(), e);
            return null;
        }
    }

    @Override
    public boolean validateRuleExpression(String expression) {
        try {
            ScriptEngine engine = scriptEngineManager.getEngineByName("JavaScript");
            
            // 添加测试变量
            engine.put("status", "ONLINE");
            engine.put("healthScore", 80);
            engine.put("retryCount", 0);
            engine.put("heartbeatMinutes", 5);
            engine.put("onlineHours", 24);
            
            // 执行表达式
            Object result = engine.eval(expression);
            
            // 检查结果是否为布尔值
            return result instanceof Boolean;
            
        } catch (ScriptException e) {
            log.warn("规则表达式验证失败: expression={}, error={}", expression, e.getMessage());
            return false;
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountMonitorRule> getTenantRules(String tenantId) {
        // 先从缓存获取
        String cacheKey = RULE_CACHE_PREFIX + tenantId;
        @SuppressWarnings("unchecked")
        List<AccountMonitorRule> cached = (List<AccountMonitorRule>) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        List<AccountMonitorRule> rules = ruleRepository.findByTenantIdOrderByPriorityDesc(tenantId);
        
        // 缓存结果
        redisTemplate.opsForValue().set(cacheKey, rules, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        return rules;
    }

    @Override
    @TenantRequired
    public AccountMonitorRule createRule(AccountMonitorRule rule) {
        // 验证规则表达式
        if (!validateRuleExpression(rule.getRuleExpression())) {
            throw new IllegalArgumentException("无效的规则表达式: " + rule.getRuleExpression());
        }
        
        // 设置创建信息
        rule.setId(UUID.randomUUID().toString());
        rule.setEnabled(true);
        rule.setCreatedAt(LocalDateTime.now());
        rule.setUpdatedAt(LocalDateTime.now());
        
        ruleRepository.insert(rule);
        
        // 清除缓存
        clearRuleCache(rule.getTenantId());
        
        log.info("创建监控规则: ruleId={}, tenantId={}, ruleName={}", 
            rule.getId(), rule.getTenantId(), rule.getRuleName());
        
        return rule;
    }

    @Override
    @TenantRequired
    public AccountMonitorRule updateRule(AccountMonitorRule rule) {
        AccountMonitorRule existing = ruleRepository.selectById(rule.getId());
        if (existing == null) {
            throw new RuntimeException("监控规则不存在: " + rule.getId());
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(existing.getTenantId());
        
        // 验证规则表达式
        if (!validateRuleExpression(rule.getRuleExpression())) {
            throw new IllegalArgumentException("无效的规则表达式: " + rule.getRuleExpression());
        }
        
        rule.setUpdatedAt(LocalDateTime.now());
        ruleRepository.updateById(rule);
        
        // 清除缓存
        clearRuleCache(existing.getTenantId());
        
        log.info("更新监控规则: ruleId={}, tenantId={}", rule.getId(), existing.getTenantId());
        
        return rule;
    }

    @Override
    @TenantRequired
    public void deleteRule(String ruleId) {
        AccountMonitorRule rule = ruleRepository.selectById(ruleId);
        if (rule == null) {
            throw new RuntimeException("监控规则不存在: " + ruleId);
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(rule.getTenantId());
        
        ruleRepository.deleteById(ruleId);
        
        // 清除缓存
        clearRuleCache(rule.getTenantId());
        
        log.info("删除监控规则: ruleId={}, tenantId={}", ruleId, rule.getTenantId());
    }

    @Override
    @TenantRequired
    public void toggleRule(String ruleId, boolean enabled) {
        AccountMonitorRule rule = ruleRepository.selectById(ruleId);
        if (rule == null) {
            throw new RuntimeException("监控规则不存在: " + ruleId);
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(rule.getTenantId());
        
        rule.setEnabled(enabled);
        rule.setUpdatedAt(LocalDateTime.now());
        ruleRepository.updateById(rule);
        
        // 清除缓存
        clearRuleCache(rule.getTenantId());
        
        log.info("{}监控规则: ruleId={}, tenantId={}", 
            enabled ? "启用" : "禁用", ruleId, rule.getTenantId());
    }

    @Override
    @TenantRequired
    public boolean testRule(String ruleId, String accountId) {
        AccountMonitorRule rule = ruleRepository.selectById(ruleId);
        if (rule == null) {
            throw new RuntimeException("监控规则不存在: " + ruleId);
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(rule.getTenantId());
        
        // TODO: 获取账号信息并测试规则
        // WeWorkAccount account = accountRepository.selectById(accountId);
        // return evaluateRuleCondition(account, rule);
        
        log.info("测试监控规则: ruleId={}, accountId={}", ruleId, accountId);
        return true; // 暂时返回true
    }

    @Override
    public List<RuleTemplate> getBuiltinRuleTemplates() {
        List<RuleTemplate> templates = new ArrayList<>();
        
        // 账号离线规则模板
        templates.add(new RuleTemplateImpl(
            "account_offline",
            "账号离线检测",
            "检测账号是否离线超过指定时间",
            "status == 'OFFLINE'",
            Arrays.asList(
                new RuleParameterImpl("offlineMinutes", "INTEGER", "离线时长(分钟)", 10, true)
            )
        ));
        
        // 健康度低规则模板
        templates.add(new RuleTemplateImpl(
            "low_health_score",
            "健康度过低",
            "检测账号健康度是否低于阈值",
            "healthScore < threshold",
            Arrays.asList(
                new RuleParameterImpl("threshold", "INTEGER", "健康度阈值", 60, true)
            )
        ));
        
        // 重试次数过多规则模板
        templates.add(new RuleTemplateImpl(
            "high_retry_count",
            "重试次数过多",
            "检测账号重试次数是否过多",
            "retryCount >= maxRetries",
            Arrays.asList(
                new RuleParameterImpl("maxRetries", "INTEGER", "最大重试次数", 5, true)
            )
        ));
        
        // 心跳超时规则模板
        templates.add(new RuleTemplateImpl(
            "heartbeat_timeout",
            "心跳超时",
            "检测账号心跳是否超时",
            "heartbeatMinutes > timeoutMinutes",
            Arrays.asList(
                new RuleParameterImpl("timeoutMinutes", "INTEGER", "超时时长(分钟)", 5, true)
            )
        ));
        
        return templates;
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public AccountMonitorRule createRuleFromTemplate(String tenantId, String templateId, RuleConfig config) {
        RuleTemplate template = getBuiltinRuleTemplates().stream()
            .filter(t -> t.getId().equals(templateId))
            .findFirst()
            .orElseThrow(() -> new RuntimeException("规则模板不存在: " + templateId));
        
        AccountMonitorRule rule = new AccountMonitorRule();
        rule.setTenantId(tenantId);
        rule.setRuleName(template.getName());
        rule.setRuleType(MonitorRuleType.BUILTIN);
        rule.setRuleExpression(buildExpressionFromTemplate(template, config));
        rule.setAlertType(AlertType.ACCOUNT_OFFLINE); // 默认类型，可根据模板调整
        rule.setAlertLevel(AlertLevel.valueOf(config.getAlertLevel()));
        rule.setAlertMessage(config.getAlertMessage());
        rule.setPriority(1);
        rule.setDescription(template.getDescription());
        
        return createRule(rule);
    }

    // ========== 私有辅助方法 ==========

    /**
     * 评估规则条件
     */
    private boolean evaluateRuleCondition(WeWorkAccount account, AccountMonitorRule rule) {
        try {
            ScriptEngine engine = scriptEngineManager.getEngineByName("JavaScript");
            
            // 设置账号变量
            engine.put("status", account.getStatus().name());
            engine.put("healthScore", account.getHealthScore() != null ? account.getHealthScore() : 0);
            engine.put("retryCount", account.getRetryCount() != null ? account.getRetryCount() : 0);
            
            // 计算心跳分钟数
            if (account.getLastHeartbeatTime() != null) {
                Duration heartbeatDuration = Duration.between(account.getLastHeartbeatTime(), LocalDateTime.now());
                engine.put("heartbeatMinutes", heartbeatDuration.toMinutes());
            } else {
                engine.put("heartbeatMinutes", Long.MAX_VALUE);
            }
            
            // 计算在线小时数
            if (account.getLastLoginTime() != null && account.isOnline()) {
                Duration onlineDuration = Duration.between(account.getLastLoginTime(), LocalDateTime.now());
                engine.put("onlineHours", onlineDuration.toHours());
            } else {
                engine.put("onlineHours", 0);
            }
            
            // 执行规则表达式
            Object result = engine.eval(rule.getRuleExpression());
            
            return Boolean.TRUE.equals(result);
            
        } catch (ScriptException e) {
            log.warn("规则条件评估失败: ruleId={}, expression={}, error={}", 
                rule.getId(), rule.getRuleExpression(), e.getMessage());
            return false;
        }
    }

    /**
     * 格式化告警消息
     */
    private String formatAlertMessage(WeWorkAccount account, AccountMonitorRule rule) {
        String message = rule.getAlertMessage();
        if (message == null || message.isEmpty()) {
            message = "账号 ${accountName} 触发监控规则: ${ruleName}";
        }
        
        // 替换占位符
        message = message.replace("${accountName}", account.getAccountName());
        message = message.replace("${ruleName}", rule.getRuleName());
        message = message.replace("${status}", account.getStatus().getDescription());
        message = message.replace("${healthScore}", String.valueOf(account.getHealthScore()));
        message = message.replace("${retryCount}", String.valueOf(account.getRetryCount()));
        
        return message;
    }

    /**
     * 从模板构建表达式
     */
    private String buildExpressionFromTemplate(RuleTemplate template, RuleConfig config) {
        String expression = template.getExpressionTemplate();
        
        // 替换参数占位符
        for (Map.Entry<String, Object> entry : config.getParameters().entrySet()) {
            String placeholder = entry.getKey();
            String value = String.valueOf(entry.getValue());
            expression = expression.replace(placeholder, value);
        }
        
        return expression;
    }

    /**
     * 清除规则缓存
     */
    private void clearRuleCache(String tenantId) {
        String cacheKey = RULE_CACHE_PREFIX + tenantId;
        redisTemplate.delete(cacheKey);
    }

    // ========== 内部实现类 ==========

    /**
     * 规则模板实现
     */
    private static class RuleTemplateImpl implements RuleTemplate {
        private final String id;
        private final String name;
        private final String description;
        private final String expressionTemplate;
        private final List<RuleParameter> parameters;

        public RuleTemplateImpl(String id, String name, String description, 
                               String expressionTemplate, List<RuleParameter> parameters) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.expressionTemplate = expressionTemplate;
            this.parameters = parameters;
        }

        @Override
        public String getId() { return id; }

        @Override
        public String getName() { return name; }

        @Override
        public String getDescription() { return description; }

        @Override
        public String getExpressionTemplate() { return expressionTemplate; }

        @Override
        public List<RuleParameter> getParameters() { return parameters; }
    }

    /**
     * 规则参数实现
     */
    private static class RuleParameterImpl implements RuleParameter {
        private final String name;
        private final String type;
        private final String description;
        private final Object defaultValue;
        private final boolean required;

        public RuleParameterImpl(String name, String type, String description, 
                               Object defaultValue, boolean required) {
            this.name = name;
            this.type = type;
            this.description = description;
            this.defaultValue = defaultValue;
            this.required = required;
        }

        @Override
        public String getName() { return name; }

        @Override
        public String getType() { return type; }

        @Override
        public String getDescription() { return description; }

        @Override
        public Object getDefaultValue() { return defaultValue; }

        @Override
        public boolean isRequired() { return required; }
    }
}