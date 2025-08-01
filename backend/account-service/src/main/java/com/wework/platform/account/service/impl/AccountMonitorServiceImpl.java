package com.wework.platform.account.service.impl;

import com.wework.platform.account.service.AccountMonitorService;
import com.wework.platform.account.client.WeWorkApiClient;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.account.repository.AccountAlertRepository;
import com.wework.platform.account.service.AlertManager;
import com.wework.platform.account.service.MonitorRuleEngine;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.entity.AccountMonitorRule;
import com.wework.platform.common.dto.AccountHealthReport;
import com.wework.platform.common.dto.MonitorStatistics;
import com.wework.platform.common.enums.AccountStatus;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.common.tenant.TenantRequired;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.data.redis.core.RedisTemplate;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;

/**
 * 账号监控服务实现 - 支持多租户
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
@TenantRequired
public class AccountMonitorServiceImpl implements AccountMonitorService {

    private final WeWorkAccountRepository accountRepository;
    private final AccountAlertRepository alertRepository;
    private final WeWorkApiClient weWorkApiClient;
    private final AlertManager alertManager;
    private final MonitorRuleEngine ruleEngine;
    private final RedisTemplate<String, Object> redisTemplate;

    /**
     * 监控回调注册表
     */
    private final Map<String, MonitorCallback> tenantCallbacks = new ConcurrentHashMap<>();
    
    /**
     * 监控状态
     */
    private final AtomicBoolean monitoringActive = new AtomicBoolean(false);

    /**
     * 健康报告缓存前缀
     */
    private static final String HEALTH_REPORT_PREFIX = "health:report:";
    
    /**
     * 监控统计缓存前缀
     */
    private static final String MONITOR_STATS_PREFIX = "monitor:stats:";
    
    /**
     * 缓存过期时间(秒)
     */
    private static final int CACHE_EXPIRE_SECONDS = 300;

    @PostConstruct
    public void init() {
        log.info("初始化账号监控服务");
        startRealTimeMonitoring();
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public AccountHealthReport monitorAccount(String tenantId, String accountId) {
        log.debug("监控账号健康度: 租户={}, 账号={}", tenantId, accountId);
        
        // 先从缓存获取
        String cacheKey = HEALTH_REPORT_PREFIX + tenantId + ":" + accountId;
        AccountHealthReport cached = (AccountHealthReport) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null && isReportValid(cached)) {
            return cached;
        }
        
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw new RuntimeException("账号不存在: " + accountId);
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(account.getTenantId());
        
        AccountHealthReport report = buildHealthReport(account);
        
        // 缓存结果
        redisTemplate.opsForValue().set(cacheKey, report, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        // 触发回调
        triggerCallbacks(account.getTenantId(), report);
        
        return report;
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountHealthReport> monitorTenantAccounts(String tenantId) {
        log.debug("监控租户所有账号: 租户={}", tenantId);
        
        List<WeWorkAccount> accounts = accountRepository.selectByTenantId(null, tenantId, null).getRecords();
        
        return accounts.parallelStream()
                .map(this::buildHealthReport)
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, List<AccountHealthReport>> monitorAllOnlineAccounts() {
        log.debug("监控所有在线账号");
        
        // 只有超级管理员才能监控所有账号
        if (!TenantContext.isSuperAdmin()) {
            throw new SecurityException("无权限监控所有账号");
        }
        
        List<WeWorkAccount> onlineAccounts = accountRepository.selectByStatus(AccountStatus.ONLINE);
        
        return onlineAccounts.parallelStream()
                .map(this::buildHealthReport)
                .collect(Collectors.groupingBy(AccountHealthReport::getTenantId));
    }

    @Override
    public int calculateHealthScore(WeWorkAccount account) {
        int score = 100; // 基础分数
        
        LocalDateTime now = LocalDateTime.now();
        
        // 1. 状态评分 (40分)
        score += getStatusScore(account.getStatus());
        
        // 2. 心跳评分 (30分)
        score += getHeartbeatScore(account, now);
        
        // 3. 重试次数评分 (20分)
        score += getRetryScore(account);
        
        // 4. 在线时长评分 (10分)
        score += getUptimeScore(account, now);
        
        // 确保分数在 0-100 范围内
        return Math.max(0, Math.min(100, score));
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public boolean checkAccountHeartbeat(String tenantId, String accountId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) return false;
        
        // 验证租户权限
        TenantContext.validateTenantAccess(account.getTenantId());
        
        try {
            // 调用企微API检查状态
            var statusResult = weWorkApiClient.getInstanceStatus(account.getWeWorkGuid());
            
            if (statusResult != null && statusResult.getBoolean("success")) {
                // 更新心跳时间
                accountRepository.updateHeartbeatTime(accountId, LocalDateTime.now());
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            log.warn("检查账号心跳失败: accountId={}, error={}", accountId, e.getMessage());
            return false;
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountAlert> executeMonitorRules(String tenantId, String accountId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) return Collections.emptyList();
        
        // 验证租户权限
        TenantContext.validateTenantAccess(account.getTenantId());
        
        return ruleEngine.executeRules(account);
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public MonitorStatistics getTenantMonitorStatistics(String tenantId) {
        log.debug("获取租户监控统计: 租户={}", tenantId);
        
        // 先从缓存获取
        String cacheKey = MONITOR_STATS_PREFIX + tenantId;
        MonitorStatistics cached = (MonitorStatistics) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        MonitorStatistics stats = buildTenantStatistics(tenantId);
        
        // 缓存结果
        redisTemplate.opsForValue().set(cacheKey, stats, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        return stats;
    }

    @Override
    public MonitorStatistics getSystemMonitorStatistics() {
        log.debug("获取系统监控统计");
        
        // 只有超级管理员才能查看系统统计
        if (!TenantContext.isSuperAdmin()) {
            throw new SecurityException("无权限查看系统统计");
        }
        
        String cacheKey = MONITOR_STATS_PREFIX + "system";
        MonitorStatistics cached = (MonitorStatistics) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        MonitorStatistics stats = buildSystemStatistics();
        
        // 缓存结果
        redisTemplate.opsForValue().set(cacheKey, stats, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        return stats;
    }

    @Override
    public void startRealTimeMonitoring() {
        if (monitoringActive.compareAndSet(false, true)) {
            log.info("启动实时监控");
        }
    }

    @Override
    public void stopRealTimeMonitoring() {
        if (monitoringActive.compareAndSet(true, false)) {
            log.info("停止实时监控");
        }
    }

    @Override
    public void registerMonitorCallback(String tenantId, MonitorCallback callback) {
        tenantCallbacks.put(tenantId, callback);
        log.info("注册租户监控回调: 租户={}", tenantId);
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountHealthReport> getAccountMonitorHistory(String tenantId, String accountId, int days) {
        // TODO: 实现历史查询逻辑
        // 这里可以从时序数据库(如InfluxDB)或历史表中查询
        log.debug("获取账号监控历史: 租户={}, 账号={}, 天数={}", tenantId, accountId, days);
        
        // 暂时返回空列表，实际实现时需要查询历史数据
        return Collections.emptyList();
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public AccountHealthTrend predictAccountHealthTrend(String tenantId, String accountId) {
        // TODO: 实现健康趋势预测算法
        // 可以基于历史数据使用机器学习算法预测
        log.debug("预测账号健康趋势: 租户={}, 账号={}", tenantId, accountId);
        
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) return AccountHealthTrend.STABLE;
        
        // 简单的趋势预测逻辑
        int healthScore = calculateHealthScore(account);
        
        if (healthScore < 40) return AccountHealthTrend.CRITICAL;
        if (healthScore < 60) return AccountHealthTrend.DECLINING;
        if (healthScore > 90) return AccountHealthTrend.IMPROVING;
        return AccountHealthTrend.STABLE;
    }

    /**
     * 定时监控任务 - 每30秒执行一次
     */
    @Scheduled(fixedRate = 30000) // 30秒
    @Async
    public void scheduledMonitoringTask() {
        if (!monitoringActive.get()) {
            return;
        }
        
        try {
            log.debug("执行定时监控任务");
            
            // 监控所有在线账号
            List<WeWorkAccount> onlineAccounts = accountRepository.selectByStatus(AccountStatus.ONLINE);
            
            for (WeWorkAccount account : onlineAccounts) {
                try {
                    // 异步监控每个账号
                    monitorAccountAsync(account);
                } catch (Exception e) {
                    log.warn("监控账号失败: accountId={}, error={}", account.getId(), e.getMessage());
                }
            }
            
            // 清理过期缓存
            cleanupExpiredCache();
            
        } catch (Exception e) {
            log.error("定时监控任务执行失败", e);
        }
    }

    /**
     * 异步监控单个账号
     */
    @Async
    public void monitorAccountAsync(WeWorkAccount account) {
        try {
            // 执行健康检查
            AccountHealthReport report = buildHealthReport(account);
            
            // 检查是否需要触发告警
            if (report.needsAttention()) {
                List<AccountAlert> alerts = ruleEngine.executeRules(account);
                
                for (AccountAlert alert : alerts) {
                    alertManager.createAlert(alert);
                }
            }
            
            // 更新健康度评分
            Integer newHealthScore = report.getHealthScore();
            if (newHealthScore != null && !newHealthScore.equals(account.getHealthScore())) {
                accountRepository.updateHealthScore(account.getId(), newHealthScore);
                
                // 触发健康度变化回调
                triggerHealthScoreChangeCallback(account.getTenantId(), account.getId(), 
                    account.getHealthScore(), newHealthScore);
            }
            
        } catch (Exception e) {
            log.warn("异步监控账号失败: accountId={}, error={}", account.getId(), e.getMessage());
        }
    }

    // ========== 私有辅助方法 ==========

    /**
     * 构建健康报告
     */
    private AccountHealthReport buildHealthReport(WeWorkAccount account) {
        LocalDateTime now = LocalDateTime.now();
        int healthScore = calculateHealthScore(account);
        
        AccountHealthReport.AccountHealthReportBuilder builder = AccountHealthReport.builder()
                .accountId(account.getId())
                .tenantId(account.getTenantId())
                .accountName(account.getAccountName())
                .status(account.getStatus())
                .healthScore(healthScore)
                .previousHealthScore(account.getHealthScore())
                .lastHeartbeatTime(account.getLastHeartbeatTime())
                .retryCount(account.getRetryCount())
                .maxRetryCount(account.getMaxRetryCount())
                .checkTime(now)
                .dataValidSeconds(CACHE_EXPIRE_SECONDS);

        // 计算心跳间隔
        if (account.getLastHeartbeatTime() != null) {
            Duration heartbeatDuration = Duration.between(account.getLastHeartbeatTime(), now);
            builder.heartbeatInterval(heartbeatDuration.getSeconds());
            builder.heartbeatNormal(heartbeatDuration.getSeconds() <= account.getMonitorInterval() * 2);
        } else {
            builder.heartbeatNormal(false);
        }

        // 计算在线时长
        if (account.getLastLoginTime() != null && account.isOnline()) {
            Duration onlineDuration = Duration.between(account.getLastLoginTime(), now);
            builder.onlineDuration(onlineDuration.toMinutes());
        }

        // 健康检查项
        List<AccountHealthReport.HealthCheckItem> checkItems = performHealthChecks(account);
        builder.healthCheckItems(checkItems);

        // 建议操作
        List<String> recommendations = generateRecommendations(account, healthScore);
        builder.recommendedActions(recommendations);

        // 风险评估
        String riskAssessment = assessRisk(account, healthScore);
        builder.riskAssessment(riskAssessment);

        // 活跃告警数量
        int activeAlerts = alertRepository.countActiveAlertsByAccountId(account.getId());
        builder.activeAlertCount(activeAlerts);

        if (activeAlerts > 0) {
            AlertLevel maxLevel = alertRepository.getMaxAlertLevelByAccountId(account.getId());
            builder.alertLevel(maxLevel != null ? maxLevel.getDisplayName() : "INFO");
        }

        return builder.build();
    }

    /**
     * 执行健康检查
     */
    private List<AccountHealthReport.HealthCheckItem> performHealthChecks(WeWorkAccount account) {
        List<AccountHealthReport.HealthCheckItem> items = new ArrayList<>();
        
        // 状态检查
        items.add(AccountHealthReport.HealthCheckItem.builder()
                .checkName("状态检查")
                .checkType("STATUS")
                .passed(account.isOnline())
                .result(account.getStatus().getDescription())
                .message(account.isOnline() ? "账号状态正常" : "账号未在线")
                .severity(account.isOnline() ? "INFO" : "WARNING")
                .build());

        // 心跳检查
        boolean heartbeatNormal = isHeartbeatNormal(account);
        items.add(AccountHealthReport.HealthCheckItem.builder()
                .checkName("心跳检查")
                .checkType("HEARTBEAT")
                .passed(heartbeatNormal)
                .result(heartbeatNormal ? "正常" : "异常")
                .message(heartbeatNormal ? "心跳正常" : "心跳超时或异常")
                .severity(heartbeatNormal ? "INFO" : "ERROR")
                .build());

        // 重试次数检查
        boolean retryOk = account.getRetryCount() < account.getMaxRetryCount();
        items.add(AccountHealthReport.HealthCheckItem.builder()
                .checkName("重试次数检查")
                .checkType("RETRY")
                .passed(retryOk)
                .result(String.format("%d/%d", account.getRetryCount(), account.getMaxRetryCount()))
                .message(retryOk ? "重试次数正常" : "重试次数过多")
                .severity(retryOk ? "INFO" : "WARNING")
                .build());

        return items;
    }

    /**
     * 生成建议操作
     */
    private List<String> generateRecommendations(WeWorkAccount account, int healthScore) {
        List<String> recommendations = new ArrayList<>();
        
        if (healthScore < 40) {
            recommendations.add("立即重启账号");
            recommendations.add("检查网络连接");
            recommendations.add("联系技术支持");
        } else if (healthScore < 60) {
            recommendations.add("检查账号状态");
            recommendations.add("监控心跳情况");
        } else if (healthScore < 80) {
            recommendations.add("定期检查账号状态");
        }
        
        if (account.getRetryCount() >= account.getMaxRetryCount()) {
            recommendations.add("重置重试次数");
        }
        
        if (!isHeartbeatNormal(account)) {
            recommendations.add("检查心跳连接");
        }
        
        return recommendations;
    }

    /**
     * 风险评估
     */
    private String assessRisk(WeWorkAccount account, int healthScore) {
        if (healthScore < 40) {
            return "高风险：账号可能随时离线，需要立即处理";
        } else if (healthScore < 60) {
            return "中风险：账号状态不稳定，建议密切监控";
        } else if (healthScore < 80) {
            return "低风险：账号基本正常，但需要定期关注";
        } else {
            return "安全：账号运行良好";
        }
    }

    /**
     * 状态评分
     */
    private int getStatusScore(AccountStatus status) {
        switch (status) {
            case ONLINE: return 0;
            case WAITING_QR:
            case WAITING_CONFIRM:
            case VERIFYING: return -10;
            case RECOVERING: return -20;
            case OFFLINE: return -30;
            case ERROR: return -40;
            default: return -40;
        }
    }

    /**
     * 心跳评分
     */
    private int getHeartbeatScore(WeWorkAccount account, LocalDateTime now) {
        if (account.getLastHeartbeatTime() == null) {
            return -30;
        }
        
        Duration heartbeatDuration = Duration.between(account.getLastHeartbeatTime(), now);
        long heartbeatSeconds = heartbeatDuration.getSeconds();
        long expectedInterval = account.getMonitorInterval();
        
        if (heartbeatSeconds <= expectedInterval) {
            return 0; // 正常
        } else if (heartbeatSeconds <= expectedInterval * 2) {
            return -10; // 轻微延迟
        } else if (heartbeatSeconds <= expectedInterval * 5) {
            return -20; // 严重延迟
        } else {
            return -30; // 心跳丢失
        }
    }

    /**
     * 重试评分
     */
    private int getRetryScore(WeWorkAccount account) {
        if (account.getRetryCount() == 0) {
            return 0;
        }
        
        double retryRate = (double) account.getRetryCount() / account.getMaxRetryCount();
        
        if (retryRate < 0.3) {
            return -5;
        } else if (retryRate < 0.6) {
            return -10;
        } else if (retryRate < 0.9) {
            return -15;
        } else {
            return -20;
        }
    }

    /**
     * 在线时长评分
     */
    private int getUptimeScore(WeWorkAccount account, LocalDateTime now) {
        if (account.getLastLoginTime() == null || !account.isOnline()) {
            return -10;
        }
        
        Duration onlineDuration = Duration.between(account.getLastLoginTime(), now);
        long onlineHours = onlineDuration.toHours();
        
        if (onlineHours >= 24) {
            return 0; // 长期在线
        } else if (onlineHours >= 12) {
            return -2;
        } else if (onlineHours >= 6) {
            return -5;
        } else {
            return -10; // 刚上线或频繁重启
        }
    }

    /**
     * 检查心跳是否正常
     */
    private boolean isHeartbeatNormal(WeWorkAccount account) {
        if (account.getLastHeartbeatTime() == null) {
            return false;
        }
        
        Duration heartbeatDuration = Duration.between(account.getLastHeartbeatTime(), LocalDateTime.now());
        return heartbeatDuration.getSeconds() <= account.getMonitorInterval() * 2;
    }

    /**
     * 构建租户统计
     */
    private MonitorStatistics buildTenantStatistics(String tenantId) {
        // 获取租户的所有账号
        List<WeWorkAccount> accounts = accountRepository.selectByTenantId(null, tenantId, null).getRecords();
        
        return buildStatisticsFromAccounts(accounts, tenantId);
    }

    /**
     * 构建系统统计
     */
    private MonitorStatistics buildSystemStatistics() {
        // 获取所有账号
        List<WeWorkAccount> allAccounts = accountRepository.selectList(null);
        
        return buildStatisticsFromAccounts(allAccounts, null);
    }

    /**
     * 从账号列表构建统计
     */
    private MonitorStatistics buildStatisticsFromAccounts(List<WeWorkAccount> accounts, String tenantId) {
        LocalDateTime now = LocalDateTime.now();
        
        // 基础统计
        int totalAccounts = accounts.size();
        int onlineAccounts = (int) accounts.stream().filter(WeWorkAccount::isOnline).count();
        int offlineAccounts = (int) accounts.stream().filter(a -> a.getStatus() == AccountStatus.OFFLINE).count();
        int errorAccounts = (int) accounts.stream().filter(a -> a.getStatus() == AccountStatus.ERROR).count();
        int recoveringAccounts = (int) accounts.stream().filter(a -> a.getStatus() == AccountStatus.RECOVERING).count();
        
        // 健康度统计
        double avgHealthScore = accounts.stream()
                .mapToInt(this::calculateHealthScore)
                .average()
                .orElse(0.0);
        
        int healthyAccounts = (int) accounts.stream()
                .mapToInt(this::calculateHealthScore)
                .filter(score -> score >= 80)
                .count();
        
        int attentionNeededAccounts = (int) accounts.stream()
                .mapToInt(this::calculateHealthScore)
                .filter(score -> score < 60)
                .count();
        
        int criticalAccounts = (int) accounts.stream()
                .mapToInt(this::calculateHealthScore)
                .filter(score -> score < 40)
                .count();

        // 告警统计
        int activeAlerts = tenantId != null ? 
                alertRepository.countActiveAlertsByTenantId(tenantId) : 
                alertRepository.countAllActiveAlerts();

        return MonitorStatistics.builder()
                .tenantId(tenantId)
                .statisticsTime(now)
                .periodSeconds(CACHE_EXPIRE_SECONDS)
                .totalAccounts(totalAccounts)
                .onlineAccounts(onlineAccounts)
                .offlineAccounts(offlineAccounts)
                .errorAccounts(errorAccounts)
                .recoveringAccounts(recoveringAccounts)
                .onlineRate(totalAccounts > 0 ? (double) onlineAccounts / totalAccounts * 100 : 0.0)
                .avgHealthScore(avgHealthScore)
                .healthyAccounts(healthyAccounts)
                .attentionNeededAccounts(attentionNeededAccounts)
                .criticalAccounts(criticalAccounts)
                .activeAlerts(activeAlerts)
                .build();
    }

    /**
     * 检查报告是否有效
     */
    private boolean isReportValid(AccountHealthReport report) {
        if (report.getCheckTime() == null || report.getDataValidSeconds() == null) {
            return false;
        }
        
        Duration age = Duration.between(report.getCheckTime(), LocalDateTime.now());
        return age.getSeconds() < report.getDataValidSeconds();
    }

    /**
     * 触发回调
     */
    private void triggerCallbacks(String tenantId, AccountHealthReport report) {
        MonitorCallback callback = tenantCallbacks.get(tenantId);
        if (callback != null) {
            try {
                if (report.getHealthScore() != null && report.getPreviousHealthScore() != null &&
                    !report.getHealthScore().equals(report.getPreviousHealthScore())) {
                    callback.onHealthScoreChanged(report.getAccountId(), 
                        report.getPreviousHealthScore(), report.getHealthScore());
                }
            } catch (Exception e) {
                log.warn("触发监控回调失败: {}", e.getMessage());
            }
        }
    }

    /**
     * 触发健康度变化回调
     */
    private void triggerHealthScoreChangeCallback(String tenantId, String accountId, Integer oldScore, Integer newScore) {
        MonitorCallback callback = tenantCallbacks.get(tenantId);
        if (callback != null && oldScore != null && newScore != null) {
            try {
                callback.onHealthScoreChanged(accountId, oldScore, newScore);
            } catch (Exception e) {
                log.warn("触发健康度变化回调失败: {}", e.getMessage());
            }
        }
    }

    /**
     * 清理过期缓存
     */
    private void cleanupExpiredCache() {
        // 这里可以实现更复杂的缓存清理逻辑
        log.debug("清理过期监控缓存");
    }
}