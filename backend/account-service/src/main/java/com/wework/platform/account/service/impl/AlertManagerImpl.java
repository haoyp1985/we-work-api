package com.wework.platform.account.service.impl;

import com.wework.platform.account.service.AlertManager;
import com.wework.platform.account.service.NotificationService;
import com.wework.platform.account.repository.AccountAlertRepository;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.common.tenant.TenantRequired;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.redis.core.RedisTemplate;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import java.util.concurrent.TimeUnit;

/**
 * 告警管理器实现
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
@TenantRequired
public class AlertManagerImpl implements AlertManager {

    private final AccountAlertRepository alertRepository;
    private final NotificationService notificationService;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String ALERT_CACHE_PREFIX = "alert:";
    private static final String DUPLICATE_CHECK_PREFIX = "alert:dup:";
    private static final int DUPLICATE_CHECK_MINUTES = 10; // 10分钟内不重复创建相同告警
    private static final int CACHE_EXPIRE_SECONDS = 300;

    @Override
    @Transactional
    public AccountAlert createAlert(AccountAlert alert) {
        log.info("创建告警: 租户={}, 账号={}, 类型={}, 级别={}", 
            alert.getTenantId(), alert.getAccountId(), alert.getAlertType(), alert.getAlertLevel());
        
        // 验证租户权限
        TenantContext.validateTenantAccess(alert.getTenantId());
        
        // 检查重复告警
        if (isDuplicateAlert(alert.getTenantId(), alert.getAccountId(), alert.getAlertType())) {
            log.debug("检测到重复告警，增加发生次数: 租户={}, 账号={}, 类型={}", 
                alert.getTenantId(), alert.getAccountId(), alert.getAlertType());
            return incrementExistingAlert(alert.getTenantId(), alert.getAccountId(), alert.getAlertType());
        }
        
        // 设置告警基本信息
        alert.setStatus(AlertStatus.ACTIVE);
        alert.setFirstOccurredAt(LocalDateTime.now());
        alert.setLastOccurredAt(LocalDateTime.now());
        alert.setOccurrenceCount(1);
        alert.setAutoRecoveryAttempts(0);
        
        // 生成告警ID
        if (alert.getId() == null) {
            alert.setId(UUID.randomUUID().toString());
        }
        
        // 保存到数据库
        alertRepository.insert(alert);
        
        // 设置重复检查缓存
        setDuplicateCheckCache(alert.getTenantId(), alert.getAccountId(), alert.getAlertType());
        
        // 发送通知
        try {
            sendAlertNotification(alert);
        } catch (Exception e) {
            log.warn("发送告警通知失败: {}", e.getMessage());
        }
        
        log.info("告警创建成功: alertId={}", alert.getId());
        return alert;
    }

    @Override
    public AccountAlert createAlert(String tenantId, String accountId, AlertType alertType, 
                                  AlertLevel alertLevel, String message, Object alertData) {
        AccountAlert alert = new AccountAlert();
        alert.setTenantId(tenantId);
        alert.setAccountId(accountId);
        alert.setAlertType(alertType);
        alert.setAlertLevel(alertLevel);
        alert.setAlertMessage(message);
        alert.setAlertData(alertData);
        
        return createAlert(alert);
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.CURRENT_TENANT)
    public void updateAlertStatus(String alertId, AlertStatus status, String userId, String resolution) {
        AccountAlert alert = getAlertById(alertId);
        if (alert == null) {
            throw new RuntimeException("告警不存在: " + alertId);
        }
        
        AlertStatus oldStatus = alert.getStatus();
        alert.setStatus(status);
        
        LocalDateTime now = LocalDateTime.now();
        switch (status) {
            case ACKNOWLEDGED:
                alert.setAcknowledgedBy(userId);
                alert.setAcknowledgedAt(now);
                break;
            case RESOLVED:
                alert.setResolvedBy(userId);
                alert.setResolvedAt(now);
                alert.setResolution(resolution);
                break;
            case SUPPRESSED:
                // 抑制逻辑
                break;
            case ACTIVE:
                // 重新激活告警
                break;
            case EXPIRED:
                // 告警过期
                break;
        }
        
        alert.setUpdatedAt(now);
        alertRepository.updateById(alert);
        
        // 清除缓存
        clearAlertCache(alertId);
        
        log.info("告警状态更新: alertId={}, {} → {}, 操作人={}", 
            alertId, oldStatus, status, userId);
    }

    @Override
    public void acknowledgeAlert(String alertId, String userId) {
        updateAlertStatus(alertId, AlertStatus.ACKNOWLEDGED, userId, null);
    }

    @Override
    public void resolveAlert(String alertId, String userId, String resolution) {
        updateAlertStatus(alertId, AlertStatus.RESOLVED, userId, resolution);
    }

    @Override
    @Transactional
    public void suppressAlert(String alertId, String userId, int suppressMinutes) {
        AccountAlert alert = getAlertById(alertId);
        if (alert == null) {
            throw new RuntimeException("告警不存在: " + alertId);
        }
        
        alert.setStatus(AlertStatus.SUPPRESSED);
        alert.setAcknowledgedBy(userId);
        alert.setAcknowledgedAt(LocalDateTime.now());
        
        alertRepository.updateById(alert);
        
        // 设置自动恢复任务
        scheduleAlertReactivation(alertId, suppressMinutes);
        
        log.info("告警已抑制: alertId={}, 时长={}分钟, 操作人={}", alertId, suppressMinutes, userId);
    }

    @Override
    @Transactional
    public void batchProcessAlerts(List<String> alertIds, AlertStatus status, String userId, String reason) {
        log.info("批量处理告警: count={}, status={}, 操作人={}", alertIds.size(), status, userId);
        
        for (String alertId : alertIds) {
            try {
                updateAlertStatus(alertId, status, userId, reason);
            } catch (Exception e) {
                log.warn("批量处理告警失败: alertId={}, error={}", alertId, e.getMessage());
            }
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountAlert> getActiveAlerts(String tenantId) {
        // 先从缓存获取
        String cacheKey = ALERT_CACHE_PREFIX + "active:" + tenantId;
        @SuppressWarnings("unchecked")
        List<AccountAlert> cached = (List<AccountAlert>) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        List<AccountAlert> alerts = alertRepository.findActiveAlertsByTenantId(tenantId);
        
        // 缓存结果
        redisTemplate.opsForValue().set(cacheKey, alerts, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        return alerts;
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AccountAlert> getAccountActiveAlerts(String tenantId, String accountId) {
        return alertRepository.findActiveAlertsByAccountId(tenantId, accountId);
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public Map<String, Integer> getAlertStatistics(String tenantId) {
        Map<String, Integer> stats = new HashMap<>();
        
        stats.put("total", alertRepository.countAlertsByTenantId(tenantId));
        stats.put("active", alertRepository.countActiveAlertsByTenantId(tenantId));
        stats.put("critical", alertRepository.countAlertsByTenantIdAndLevel(tenantId, AlertLevel.CRITICAL));
        stats.put("error", alertRepository.countAlertsByTenantIdAndLevel(tenantId, AlertLevel.ERROR));
        stats.put("warning", alertRepository.countAlertsByTenantIdAndLevel(tenantId, AlertLevel.WARNING));
        stats.put("info", alertRepository.countAlertsByTenantIdAndLevel(tenantId, AlertLevel.INFO));
        stats.put("resolved", alertRepository.countAlertsByTenantIdAndStatus(tenantId, AlertStatus.RESOLVED));
        
        return stats;
    }

    @Override
    public boolean isDuplicateAlert(String tenantId, String accountId, AlertType alertType) {
        String duplicateKey = generateDuplicateKey(tenantId, accountId, alertType);
        return Boolean.TRUE.equals(redisTemplate.hasKey(duplicateKey));
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AlertAggregation> aggregateAlerts(String tenantId, String groupBy, int timeWindowMinutes) {
        LocalDateTime startTime = LocalDateTime.now().minusMinutes(timeWindowMinutes);
        List<AccountAlert> alerts = alertRepository.findAlertsByTenantIdAndTimeRange(tenantId, startTime, LocalDateTime.now());
        
        Map<String, List<AccountAlert>> groupedAlerts;
        
        switch (groupBy.toLowerCase()) {
            case "type":
                groupedAlerts = alerts.stream()
                    .collect(Collectors.groupingBy(alert -> alert.getAlertType().name()));
                break;
            case "account":
                groupedAlerts = alerts.stream()
                    .collect(Collectors.groupingBy(AccountAlert::getAccountId));
                break;
            case "level":
                groupedAlerts = alerts.stream()
                    .collect(Collectors.groupingBy(alert -> alert.getAlertLevel().name()));
                break;
            default:
                groupedAlerts = alerts.stream()
                    .collect(Collectors.groupingBy(alert -> "all"));
                break;
        }
        
        return groupedAlerts.entrySet().stream()
            .map(entry -> new AlertAggregationImpl(entry.getKey(), entry.getValue()))
            .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void escalateAlert(String alertId) {
        AccountAlert alert = getAlertById(alertId);
        if (alert == null) return;
        
        // 升级告警级别
        AlertLevel newLevel = escalateAlertLevel(alert.getAlertLevel());
        if (newLevel != alert.getAlertLevel()) {
            alert.setAlertLevel(newLevel);
            alert.setUpdatedAt(LocalDateTime.now());
            alertRepository.updateById(alert);
            
            // 发送升级通知
            try {
                sendAlertNotification(alert);
            } catch (Exception e) {
                log.warn("发送告警升级通知失败: {}", e.getMessage());
            }
            
            log.info("告警已升级: alertId={}, 新级别={}", alertId, newLevel);
        }
    }

    @Override
    @Transactional
    public int autoResolveExpiredAlerts() {
        log.debug("自动解决过期告警");
        
        // 找出超过24小时未处理的告警
        LocalDateTime expireTime = LocalDateTime.now().minusHours(24);
        List<AccountAlert> expiredAlerts = alertRepository.findExpiredActiveAlerts(expireTime);
        
        int resolvedCount = 0;
        for (AccountAlert alert : expiredAlerts) {
            try {
                alert.setStatus(AlertStatus.EXPIRED);
                alert.setResolvedAt(LocalDateTime.now());
                alert.setResolution("系统自动解决：告警已过期");
                alert.setUpdatedAt(LocalDateTime.now());
                
                alertRepository.updateById(alert);
                resolvedCount++;
                
            } catch (Exception e) {
                log.warn("自动解决告警失败: alertId={}, error={}", alert.getId(), e.getMessage());
            }
        }
        
        if (resolvedCount > 0) {
            log.info("自动解决过期告警完成: count={}", resolvedCount);
        }
        
        return resolvedCount;
    }

    @Override
    public void sendAlertNotification(AccountAlert alert) {
        try {
            // 根据告警级别决定通知方式
            switch (alert.getAlertLevel()) {
                case CRITICAL:
                    // 严重告警：短信、邮件、企微
                    notificationService.sendSmsNotification(alert);
                    notificationService.sendEmailNotification(alert);
                    notificationService.sendWeWorkNotification(alert);
                    break;
                case ERROR:
                    // 错误告警：邮件、企微
                    notificationService.sendEmailNotification(alert);
                    notificationService.sendWeWorkNotification(alert);
                    break;
                case WARNING:
                    // 警告告警：企微
                    notificationService.sendWeWorkNotification(alert);
                    break;
                case INFO:
                    // 信息告警：可选
                    break;
            }
            
            log.debug("告警通知发送完成: alertId={}, level={}", alert.getId(), alert.getAlertLevel());
            
        } catch (Exception e) {
            log.error("发送告警通知失败: alertId={}, error={}", alert.getId(), e.getMessage(), e);
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public List<AlertTrendPoint> getAlertTrend(String tenantId, int days) {
        LocalDateTime startTime = LocalDateTime.now().minusDays(days);
        return alertRepository.getAlertTrendByTenantId(tenantId, startTime);
    }

    // ========== 私有辅助方法 ==========

    /**
     * 根据ID获取告警
     */
    private AccountAlert getAlertById(String alertId) {
        // 先从缓存获取
        String cacheKey = ALERT_CACHE_PREFIX + alertId;
        AccountAlert cached = (AccountAlert) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        AccountAlert alert = alertRepository.selectById(alertId);
        if (alert != null) {
            // 验证租户权限
            TenantContext.validateTenantAccess(alert.getTenantId());
            
            // 缓存结果
            redisTemplate.opsForValue().set(cacheKey, alert, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        }
        
        return alert;
    }

    /**
     * 增加现有告警的发生次数
     */
    private AccountAlert incrementExistingAlert(String tenantId, String accountId, AlertType alertType) {
        AccountAlert existingAlert = alertRepository.findActiveAlertByTypeAndAccount(tenantId, accountId, alertType);
        if (existingAlert != null) {
            existingAlert.incrementOccurrenceCount();
            existingAlert.setUpdatedAt(LocalDateTime.now());
            alertRepository.updateById(existingAlert);
            
            // 清除缓存
            clearAlertCache(existingAlert.getId());
            
            return existingAlert;
        }
        
        return null;
    }

    /**
     * 生成重复检查键
     */
    private String generateDuplicateKey(String tenantId, String accountId, AlertType alertType) {
        return DUPLICATE_CHECK_PREFIX + tenantId + ":" + accountId + ":" + alertType.name();
    }

    /**
     * 设置重复检查缓存
     */
    private void setDuplicateCheckCache(String tenantId, String accountId, AlertType alertType) {
        String duplicateKey = generateDuplicateKey(tenantId, accountId, alertType);
        redisTemplate.opsForValue().set(duplicateKey, "1", DUPLICATE_CHECK_MINUTES, TimeUnit.MINUTES);
    }

    /**
     * 清除告警缓存
     */
    private void clearAlertCache(String alertId) {
        String cacheKey = ALERT_CACHE_PREFIX + alertId;
        redisTemplate.delete(cacheKey);
    }

    /**
     * 升级告警级别
     */
    private AlertLevel escalateAlertLevel(AlertLevel currentLevel) {
        switch (currentLevel) {
            case INFO:
                return AlertLevel.WARNING;
            case WARNING:
                return AlertLevel.ERROR;
            case ERROR:
                return AlertLevel.CRITICAL;
            case CRITICAL:
                return AlertLevel.CRITICAL; // 已经是最高级别
            default:
                return currentLevel;
        }
    }

    /**
     * 安排告警重新激活
     */
    private void scheduleAlertReactivation(String alertId, int suppressMinutes) {
        // 这里可以使用定时任务框架（如Quartz）或延迟队列来实现
        // 简化实现：使用Redis的过期机制
        String reactivationKey = "alert:reactivate:" + alertId;
        redisTemplate.opsForValue().set(reactivationKey, alertId, suppressMinutes, TimeUnit.MINUTES);
    }

    /**
     * 告警聚合实现类
     */
    private static class AlertAggregationImpl implements AlertAggregation {
        private final String groupKey;
        private final List<AccountAlert> alerts;

        public AlertAggregationImpl(String groupKey, List<AccountAlert> alerts) {
            this.groupKey = groupKey;
            this.alerts = alerts;
        }

        @Override
        public String getGroupKey() {
            return groupKey;
        }

        @Override
        public int getCount() {
            return alerts.size();
        }

        @Override
        public AlertLevel getMaxLevel() {
            return alerts.stream()
                .map(AccountAlert::getAlertLevel)
                .max(Comparator.comparing(AlertLevel::getSeverity))
                .orElse(AlertLevel.INFO);
        }

        @Override
        public String getFirstAlertTime() {
            return alerts.stream()
                .map(AccountAlert::getFirstOccurredAt)
                .min(LocalDateTime::compareTo)
                .map(LocalDateTime::toString)
                .orElse(null);
        }

        @Override
        public String getLastAlertTime() {
            return alerts.stream()
                .map(AccountAlert::getLastOccurredAt)
                .max(LocalDateTime::compareTo)
                .map(LocalDateTime::toString)
                .orElse(null);
        }

        @Override
        public List<String> getAlertIds() {
            return alerts.stream()
                .map(AccountAlert::getId)
                .collect(Collectors.toList());
        }
    }
}