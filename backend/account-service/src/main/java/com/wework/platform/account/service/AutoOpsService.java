package com.wework.platform.account.service;

import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.entity.AccountAlert;

import java.util.List;
import java.util.Map;

/**
 * 自动化运维服务接口
 * 
 * @author WeWork Platform Team
 */
public interface AutoOpsService {

    /**
     * 自动恢复账号
     */
    boolean autoRecoverAccount(String tenantId, String accountId);

    /**
     * 批量自动恢复账号
     */
    Map<String, Boolean> batchAutoRecoverAccounts(String tenantId, List<String> accountIds);

    /**
     * 处理告警自动恢复
     */
    boolean autoResolveAlert(String alertId);

    /**
     * 预防性维护
     */
    void performPreventiveMaintenance(String tenantId);

    /**
     * 系统自愈检查
     */
    void performSelfHealingCheck();

    /**
     * 智能重启账号
     */
    boolean intelligentRestartAccount(String tenantId, String accountId);

    /**
     * 故障诊断
     */
    FaultDiagnosis diagnoseFault(String tenantId, String accountId);

    /**
     * 获取恢复策略
     */
    List<RecoveryStrategy> getRecoveryStrategies(String tenantId, String accountId);

    /**
     * 执行恢复策略
     */
    boolean executeRecoveryStrategy(String tenantId, String accountId, String strategyId);

    /**
     * 获取自动运维统计
     */
    AutoOpsStatistics getAutoOpsStatistics(String tenantId);

    /**
     * 配置自动运维策略
     */
    void configureAutoOpsPolicy(String tenantId, AutoOpsPolicy policy);

    /**
     * 获取自动运维策略
     */
    AutoOpsPolicy getAutoOpsPolicy(String tenantId);

    /**
     * 故障诊断结果
     */
    interface FaultDiagnosis {
        String getFaultType();
        String getFaultCause();
        String getSeverity();
        List<String> getSymptoms();
        List<String> getRecommendations();
        Map<String, Object> getDiagnosticData();
    }

    /**
     * 恢复策略
     */
    interface RecoveryStrategy {
        String getId();
        String getName();
        String getDescription();
        String getType();
        int getPriority();
        Map<String, Object> getParameters();
        boolean isAutomatic();
        String getEstimatedTime();
        String getSuccessRate();
    }

    /**
     * 自动运维统计
     */
    interface AutoOpsStatistics {
        int getTotalAutoRecoveryAttempts();
        int getSuccessfulAutoRecoveries();
        double getAutoRecoverySuccessRate();
        int getPreventiveMaintenanceCount();
        int getFaultDiagnosisCount();
        Map<String, Integer> getRecoveryStrategyUsage();
        List<TopFaultType> getTopFaultTypes();
        
        interface TopFaultType {
            String getFaultType();
            int getCount();
            double getSuccessRate();
        }
    }

    /**
     * 自动运维策略
     */
    interface AutoOpsPolicy {
        boolean isAutoRecoveryEnabled();
        int getMaxAutoRecoveryAttempts();
        int getAutoRecoveryIntervalMinutes();
        boolean isPreventiveMaintenanceEnabled();
        String getMaintenanceSchedule();
        boolean isSelfHealingEnabled();
        Map<String, Object> getStrategySettings();
    }
}