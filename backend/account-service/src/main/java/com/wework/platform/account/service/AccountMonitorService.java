package com.wework.platform.account.service;

import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.entity.AccountMonitorRule;
import com.wework.platform.common.dto.AccountHealthReport;
import com.wework.platform.common.dto.MonitorStatistics;

import java.util.List;
import java.util.Map;

/**
 * 账号监控服务接口
 * 
 * @author WeWork Platform Team
 */
public interface AccountMonitorService {

    /**
     * 实时监控单个账号
     */
    AccountHealthReport monitorAccount(String tenantId, String accountId);

    /**
     * 监控租户的所有账号
     */
    List<AccountHealthReport> monitorTenantAccounts(String tenantId);

    /**
     * 监控所有在线账号
     */
    Map<String, List<AccountHealthReport>> monitorAllOnlineAccounts();

    /**
     * 计算账号健康度评分
     */
    int calculateHealthScore(WeWorkAccount account);

    /**
     * 检查账号心跳
     */
    boolean checkAccountHeartbeat(String tenantId, String accountId);

    /**
     * 执行监控规则检查
     */
    List<AccountAlert> executeMonitorRules(String tenantId, String accountId);

    /**
     * 获取租户监控统计
     */
    MonitorStatistics getTenantMonitorStatistics(String tenantId);

    /**
     * 获取系统监控统计
     */
    MonitorStatistics getSystemMonitorStatistics();

    /**
     * 启动实时监控
     */
    void startRealTimeMonitoring();

    /**
     * 停止实时监控
     */
    void stopRealTimeMonitoring();

    /**
     * 注册监控回调
     */
    void registerMonitorCallback(String tenantId, MonitorCallback callback);

    /**
     * 获取账号监控历史
     */
    List<AccountHealthReport> getAccountMonitorHistory(String tenantId, String accountId, int days);

    /**
     * 预测账号健康趋势
     */
    AccountHealthTrend predictAccountHealthTrend(String tenantId, String accountId);

    /**
     * 监控回调接口
     */
    interface MonitorCallback {
        void onHealthScoreChanged(String accountId, int oldScore, int newScore);
        void onAccountOffline(String accountId);
        void onAccountRecovered(String accountId);
        void onAlertTriggered(AccountAlert alert);
    }

    /**
     * 账号健康趋势
     */
    enum AccountHealthTrend {
        IMPROVING,    // 改善中
        STABLE,       // 稳定
        DECLINING,    // 下降中
        CRITICAL      // 危险
    }
}