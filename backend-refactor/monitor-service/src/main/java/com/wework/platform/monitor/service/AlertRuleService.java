package com.wework.platform.monitor.service;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertRuleDTO;
import com.wework.platform.monitor.dto.CreateAlertRuleRequest;
import com.wework.platform.monitor.dto.UpdateAlertRuleRequest;

import java.util.List;

/**
 * 告警规则服务接口
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface AlertRuleService {

    /**
     * 创建告警规则
     *
     * @param tenantId 租户ID
     * @param request 创建请求
     * @return 规则信息
     */
    Result<AlertRuleDTO> createRule(String tenantId, CreateAlertRuleRequest request);

    /**
     * 更新告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @param request 更新请求
     * @return 规则信息
     */
    Result<AlertRuleDTO> updateRule(String tenantId, String ruleId, UpdateAlertRuleRequest request);

    /**
     * 获取告警规则详情
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @return 规则信息
     */
    Result<AlertRuleDTO> getRuleById(String tenantId, String ruleId);

    /**
     * 分页查询告警规则
     *
     * @param tenantId 租户ID
     * @param ruleName 规则名称
     * @param metricName 指标名称
     * @param alertLevel 告警级别
     * @param status 状态
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    Result<PageResult<AlertRuleDTO>> getRules(String tenantId, String ruleName, String metricName,
                                             AlertLevel alertLevel, AlertStatus status,
                                             Integer pageNum, Integer pageSize);

    /**
     * 获取启用的告警规则
     *
     * @param tenantId 租户ID
     * @return 规则列表
     */
    Result<List<AlertRuleDTO>> getEnabledRules(String tenantId);

    /**
     * 启用告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @return 操作结果
     */
    Result<Void> enableRule(String tenantId, String ruleId);

    /**
     * 禁用告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @return 操作结果
     */
    Result<Void> disableRule(String tenantId, String ruleId);

    /**
     * 删除告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @return 操作结果
     */
    Result<Void> deleteRule(String tenantId, String ruleId);

    /**
     * 批量删除告警规则
     *
     * @param tenantId 租户ID
     * @param ruleIds 规则ID列表
     * @return 操作结果
     */
    Result<Void> batchDeleteRules(String tenantId, List<String> ruleIds);

    /**
     * 复制告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @param newRuleName 新规则名称
     * @return 新规则信息
     */
    Result<AlertRuleDTO> copyRule(String tenantId, String ruleId, String newRuleName);

    /**
     * 测试告警规则
     *
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @return 测试结果
     */
    Result<Boolean> testRule(String tenantId, String ruleId);

    /**
     * 获取规则统计信息
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @return 统计信息
     */
    Result<Long> getRuleCount(String tenantId, AlertStatus status);
}