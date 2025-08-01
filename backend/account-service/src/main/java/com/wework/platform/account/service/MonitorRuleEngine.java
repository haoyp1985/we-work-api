package com.wework.platform.account.service;

import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.entity.AccountMonitorRule;

import java.util.List;
import java.util.Map;

/**
 * 监控规则引擎接口
 * 
 * @author WeWork Platform Team
 */
public interface MonitorRuleEngine {

    /**
     * 执行账号的所有监控规则
     */
    List<AccountAlert> executeRules(WeWorkAccount account);

    /**
     * 执行特定监控规则
     */
    AccountAlert executeRule(WeWorkAccount account, AccountMonitorRule rule);

    /**
     * 验证规则表达式
     */
    boolean validateRuleExpression(String expression);

    /**
     * 获取租户的所有监控规则
     */
    List<AccountMonitorRule> getTenantRules(String tenantId);

    /**
     * 创建监控规则
     */
    AccountMonitorRule createRule(AccountMonitorRule rule);

    /**
     * 更新监控规则
     */
    AccountMonitorRule updateRule(AccountMonitorRule rule);

    /**
     * 删除监控规则
     */
    void deleteRule(String ruleId);

    /**
     * 启用/禁用监控规则
     */
    void toggleRule(String ruleId, boolean enabled);

    /**
     * 测试监控规则
     */
    boolean testRule(String ruleId, String accountId);

    /**
     * 获取内置规则模板
     */
    List<RuleTemplate> getBuiltinRuleTemplates();

    /**
     * 从模板创建规则
     */
    AccountMonitorRule createRuleFromTemplate(String tenantId, String templateId, RuleConfig config);

    /**
     * 规则模板
     */
    interface RuleTemplate {
        String getId();
        String getName();
        String getDescription();
        String getExpressionTemplate();
        List<RuleParameter> getParameters();
    }

    /**
     * 规则参数
     */
    interface RuleParameter {
        String getName();
        String getType();
        String getDescription();
        Object getDefaultValue();
        boolean isRequired();
    }

    /**
     * 规则配置
     */
    interface RuleConfig {
        Map<String, Object> getParameters();
        String getAlertLevel();
        String getAlertMessage();
    }
}