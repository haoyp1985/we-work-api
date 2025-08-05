package com.wework.platform.monitor.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertRuleDTO;
import com.wework.platform.monitor.dto.CreateAlertRuleRequest;
import com.wework.platform.monitor.dto.UpdateAlertRuleRequest;
import com.wework.platform.monitor.entity.AlertRule;
import com.wework.platform.monitor.repository.AlertRuleRepository;
import com.wework.platform.monitor.service.AlertRuleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 告警规则服务实现
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AlertRuleServiceImpl implements AlertRuleService {

    private final AlertRuleRepository alertRuleRepository;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<AlertRuleDTO> createRule(String tenantId, CreateAlertRuleRequest request) {
        try {
            // 检查规则名称是否已存在
            Long existCount = alertRuleRepository.countByRuleName(tenantId, request.getRuleName(), null);
            if (existCount > 0) {
                return Result.error("规则名称已存在");
            }

            AlertRule rule = new AlertRule();
            BeanUtils.copyProperties(request, rule);
            rule.setTenantId(tenantId);
            rule.setStatus(AlertStatus.ENABLED);

            alertRuleRepository.insert(rule);

            AlertRuleDTO dto = convertToDTO(rule);
            return Result.success(dto);

        } catch (Exception e) {
            log.error("创建告警规则失败, tenantId={}, request={}", tenantId, request, e);
            return Result.error("创建告警规则失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<AlertRuleDTO> updateRule(String tenantId, String ruleId, UpdateAlertRuleRequest request) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            AlertRule rule = ruleOpt.get();

            // 检查规则名称是否已存在
            if (StringUtils.hasText(request.getRuleName()) && 
                !request.getRuleName().equals(rule.getRuleName())) {
                Long existCount = alertRuleRepository.countByRuleName(tenantId, request.getRuleName(), ruleId);
                if (existCount > 0) {
                    return Result.error("规则名称已存在");
                }
            }

            // 更新非空字段
            if (StringUtils.hasText(request.getRuleName())) {
                rule.setRuleName(request.getRuleName());
            }
            if (StringUtils.hasText(request.getDescription())) {
                rule.setDescription(request.getDescription());
            }
            if (StringUtils.hasText(request.getMetricName())) {
                rule.setMetricName(request.getMetricName());
            }
            if (StringUtils.hasText(request.getComparisonOperator())) {
                rule.setComparisonOperator(request.getComparisonOperator());
            }
            if (request.getThresholdValue() != null) {
                rule.setThresholdValue(request.getThresholdValue());
            }
            if (request.getAlertLevel() != null) {
                rule.setAlertLevel(request.getAlertLevel());
            }
            if (request.getDurationMinutes() != null) {
                rule.setDurationMinutes(request.getDurationMinutes());
            }
            if (request.getEvaluationInterval() != null) {
                rule.setEvaluationInterval(request.getEvaluationInterval());
            }
            if (StringUtils.hasText(request.getNotificationChannels())) {
                rule.setNotificationChannels(request.getNotificationChannels());
            }
            if (request.getRecoveryNotification() != null) {
                rule.setRecoveryNotification(request.getRecoveryNotification());
            }

            alertRuleRepository.updateById(rule);

            AlertRuleDTO dto = convertToDTO(rule);
            return Result.success(dto);

        } catch (Exception e) {
            log.error("更新告警规则失败, tenantId={}, ruleId={}, request={}", tenantId, ruleId, request, e);
            return Result.error("更新告警规则失败");
        }
    }

    @Override
    public Result<AlertRuleDTO> getRuleById(String tenantId, String ruleId) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            AlertRuleDTO dto = convertToDTO(ruleOpt.get());
            return Result.success(dto);

        } catch (Exception e) {
            log.error("获取告警规则失败, tenantId={}, ruleId={}", tenantId, ruleId, e);
            return Result.error("获取告警规则失败");
        }
    }

    @Override
    public Result<PageResult<AlertRuleDTO>> getRules(String tenantId, String ruleName, String metricName,
                                                    AlertLevel alertLevel, AlertStatus status,
                                                    Integer pageNum, Integer pageSize) {
        try {
            Page<AlertRule> page = new Page<>(pageNum, pageSize);
            IPage<AlertRule> result = alertRuleRepository.selectPageByConditions(
                    page, tenantId, ruleName, metricName, alertLevel, status);

            List<AlertRuleDTO> records = result.getRecords().stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            PageResult<AlertRuleDTO> pageResult = new PageResult<>();
            pageResult.setRecords(records);
            pageResult.setTotal(result.getTotal());
            pageResult.setPageNum(pageNum);
            pageResult.setPageSize(pageSize);
            pageResult.setPages((int) Math.ceil((double) result.getTotal() / pageSize));

            return Result.success(pageResult);

        } catch (Exception e) {
            log.error("分页查询告警规则失败, tenantId={}", tenantId, e);
            return Result.error("分页查询告警规则失败");
        }
    }

    @Override
    public Result<List<AlertRuleDTO>> getEnabledRules(String tenantId) {
        try {
            List<AlertRule> rules = alertRuleRepository.selectEnabledRules(tenantId);
            List<AlertRuleDTO> dtos = rules.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            return Result.success(dtos);

        } catch (Exception e) {
            log.error("获取启用告警规则失败, tenantId={}", tenantId, e);
            return Result.error("获取启用告警规则失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> enableRule(String tenantId, String ruleId) {
        return updateRuleStatus(tenantId, ruleId, AlertStatus.ENABLED);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> disableRule(String tenantId, String ruleId) {
        return updateRuleStatus(tenantId, ruleId, AlertStatus.DISABLED);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> deleteRule(String tenantId, String ruleId) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            alertRuleRepository.deleteById(ruleId);
            return Result.success();

        } catch (Exception e) {
            log.error("删除告警规则失败, tenantId={}, ruleId={}", tenantId, ruleId, e);
            return Result.error("删除告警规则失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> batchDeleteRules(String tenantId, List<String> ruleIds) {
        if (CollectionUtils.isEmpty(ruleIds)) {
            return Result.success();
        }

        try {
            for (String ruleId : ruleIds) {
                Result<Void> result = deleteRule(tenantId, ruleId);
                if (!result.isSuccess()) {
                    return result;
                }
            }

            return Result.success();

        } catch (Exception e) {
            log.error("批量删除告警规则失败, tenantId={}, ruleIds={}", tenantId, ruleIds, e);
            return Result.error("批量删除告警规则失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<AlertRuleDTO> copyRule(String tenantId, String ruleId, String newRuleName) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            // 检查新规则名称是否已存在
            Long existCount = alertRuleRepository.countByRuleName(tenantId, newRuleName, null);
            if (existCount > 0) {
                return Result.error("规则名称已存在");
            }

            AlertRule originalRule = ruleOpt.get();
            AlertRule newRule = new AlertRule();
            BeanUtils.copyProperties(originalRule, newRule);
            newRule.setId(null);
            newRule.setRuleName(newRuleName);
            newRule.setStatus(AlertStatus.DISABLED);
            newRule.setLastExecutedAt(null);
            newRule.setLastAlertedAt(null);

            alertRuleRepository.insert(newRule);

            AlertRuleDTO dto = convertToDTO(newRule);
            return Result.success(dto);

        } catch (Exception e) {
            log.error("复制告警规则失败, tenantId={}, ruleId={}, newRuleName={}", tenantId, ruleId, newRuleName, e);
            return Result.error("复制告警规则失败");
        }
    }

    @Override
    public Result<Boolean> testRule(String tenantId, String ruleId) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            // TODO: 实现规则测试逻辑
            // 1. 获取最新的指标数据
            // 2. 根据规则配置进行评估
            // 3. 返回是否会触发告警

            return Result.success(false);

        } catch (Exception e) {
            log.error("测试告警规则失败, tenantId={}, ruleId={}", tenantId, ruleId, e);
            return Result.error("测试告警规则失败");
        }
    }

    @Override
    public Result<Long> getRuleCount(String tenantId, AlertStatus status) {
        try {
            Long count = alertRuleRepository.countByTenantAndStatus(tenantId, status);
            return Result.success(count);

        } catch (Exception e) {
            log.error("获取规则统计失败, tenantId={}, status={}", tenantId, status, e);
            return Result.error("获取规则统计失败");
        }
    }

    private Result<Void> updateRuleStatus(String tenantId, String ruleId, AlertStatus status) {
        try {
            Optional<AlertRule> ruleOpt = Optional.ofNullable(alertRuleRepository.selectById(ruleId));
            if (!ruleOpt.isPresent() || !tenantId.equals(ruleOpt.get().getTenantId())) {
                return Result.error("告警规则不存在");
            }

            AlertRule rule = ruleOpt.get();
            rule.setStatus(status);
            alertRuleRepository.updateById(rule);

            return Result.success();

        } catch (Exception e) {
            log.error("更新告警规则状态失败, tenantId={}, ruleId={}, status={}", tenantId, ruleId, status, e);
            return Result.error("更新告警规则状态失败");
        }
    }

    private AlertRuleDTO convertToDTO(AlertRule rule) {
        AlertRuleDTO dto = new AlertRuleDTO();
        BeanUtils.copyProperties(rule, dto);
        return dto;
    }
}