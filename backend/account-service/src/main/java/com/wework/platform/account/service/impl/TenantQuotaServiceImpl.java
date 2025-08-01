package com.wework.platform.account.service.impl;

import com.wework.platform.common.service.TenantQuotaService;
import com.wework.platform.common.entity.TenantQuota;
import com.wework.platform.common.entity.TenantUsage;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.dto.TenantQuotaCheckResult;
import com.wework.platform.account.repository.TenantQuotaRepository;
import com.wework.platform.account.repository.TenantUsageRepository;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.common.exception.BusinessException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.redis.core.RedisTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

/**
 * 租户配额服务实现
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TenantQuotaServiceImpl implements TenantQuotaService {

    private final TenantQuotaRepository tenantQuotaRepository;
    private final TenantUsageRepository tenantUsageRepository;
    private final WeWorkAccountRepository accountRepository;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String CACHE_PREFIX_QUOTA = "tenant:quota:";
    private static final String CACHE_PREFIX_USAGE = "tenant:usage:";
    private static final String CACHE_PREFIX_HOURLY_API = "tenant:api:hourly:";
    private static final int CACHE_EXPIRE_SECONDS = 300; // 5分钟

    @Override
    public TenantQuota getTenantQuota(String tenantId) {
        log.debug("获取租户配额: {}", tenantId);
        
        // 先从缓存获取
        String cacheKey = CACHE_PREFIX_QUOTA + tenantId;
        TenantQuota cached = (TenantQuota) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        // 从数据库获取
        TenantQuota quota = tenantQuotaRepository.findByTenantId(tenantId);
        if (quota == null) {
            log.warn("租户配额不存在，使用默认配额: {}", tenantId);
            quota = createDefaultQuota(tenantId);
        }
        
        // 检查配额是否有效
        if (!quota.isEffective()) {
            log.warn("租户配额已过期: {}", tenantId);
            throw new BusinessException("租户配额已过期，请联系管理员");
        }
        
        // 更新缓存
        redisTemplate.opsForValue().set(cacheKey, quota, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        
        return quota;
    }

    @Override
    public TenantQuotaCheckResult checkAccountQuota(String tenantId, int requestCount) {
        log.debug("检查账号配额: 租户={}, 请求数量={}", tenantId, requestCount);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxAccounts() == null) {
            return TenantQuotaCheckResult.unlimited("ACCOUNT");
        }
        
        // 获取当前账号数量
        long currentCount = accountRepository.countByTenantId(tenantId);
        long totalAfterRequest = currentCount + requestCount;
        
        if (totalAfterRequest > quota.getMaxAccounts()) {
            return TenantQuotaCheckResult.failure(
                "ACCOUNT", 
                currentCount, 
                (long) quota.getMaxAccounts(),
                (long) requestCount,
                "ACCOUNT_QUOTA_EXCEEDED",
                String.format("账号数量超出限制，当前: %d, 限制: %d, 请求: %d", 
                    currentCount, quota.getMaxAccounts(), requestCount)
            );
        }
        
        // 检查是否接近限制（90%警告）
        double usageRate = (double) totalAfterRequest / quota.getMaxAccounts() * 100;
        if (usageRate >= 90) {
            return TenantQuotaCheckResult.warning(
                "ACCOUNT",
                totalAfterRequest,
                (long) quota.getMaxAccounts(),
                90.0,
                "账号使用率较高，建议关注配额情况"
            );
        }
        
        return TenantQuotaCheckResult.success("ACCOUNT", totalAfterRequest, (long) quota.getMaxAccounts());
    }

    @Override
    public TenantQuotaCheckResult checkMessageQuota(String tenantId, long requestCount) {
        log.debug("检查消息配额: 租户={}, 请求数量={}", tenantId, requestCount);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxDailyMessages() == null) {
            return TenantQuotaCheckResult.unlimited("MESSAGE");
        }
        
        // 获取今日消息使用量
        TenantUsage todayUsage = getUsageByDate(tenantId, LocalDate.now());
        long currentCount = todayUsage != null ? todayUsage.getMessageCount() : 0;
        long totalAfterRequest = currentCount + requestCount;
        
        if (totalAfterRequest > quota.getMaxDailyMessages()) {
            return TenantQuotaCheckResult.failure(
                "MESSAGE",
                currentCount,
                quota.getMaxDailyMessages(),
                requestCount,
                "MESSAGE_QUOTA_EXCEEDED",
                String.format("今日消息数量超出限制，当前: %d, 限制: %d, 请求: %d",
                    currentCount, quota.getMaxDailyMessages(), requestCount)
            );
        }
        
        // 检查是否接近限制（90%警告）
        double usageRate = (double) totalAfterRequest / quota.getMaxDailyMessages() * 100;
        if (usageRate >= 90) {
            return TenantQuotaCheckResult.warning(
                "MESSAGE",
                totalAfterRequest,
                quota.getMaxDailyMessages(),
                90.0,
                "今日消息使用率较高，建议关注配额情况"
            );
        }
        
        return TenantQuotaCheckResult.success("MESSAGE", totalAfterRequest, quota.getMaxDailyMessages());
    }

    @Override
    public TenantQuotaCheckResult checkApiCallQuota(String tenantId, long requestCount) {
        log.debug("检查API调用配额: 租户={}, 请求数量={}", tenantId, requestCount);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxDailyApiCalls() == null) {
            return TenantQuotaCheckResult.unlimited("API_CALL");
        }
        
        // 获取今日API调用使用量
        TenantUsage todayUsage = getUsageByDate(tenantId, LocalDate.now());
        long currentCount = todayUsage != null ? todayUsage.getApiCallCount() : 0;
        long totalAfterRequest = currentCount + requestCount;
        
        if (totalAfterRequest > quota.getMaxDailyApiCalls()) {
            return TenantQuotaCheckResult.failure(
                "API_CALL",
                currentCount,
                quota.getMaxDailyApiCalls(),
                requestCount,
                "API_QUOTA_EXCEEDED",
                String.format("今日API调用数量超出限制，当前: %d, 限制: %d, 请求: %d",
                    currentCount, quota.getMaxDailyApiCalls(), requestCount)
            );
        }
        
        return TenantQuotaCheckResult.success("API_CALL", totalAfterRequest, quota.getMaxDailyApiCalls());
    }

    @Override
    public TenantQuotaCheckResult checkHourlyApiCallQuota(String tenantId, long requestCount) {
        log.debug("检查小时API调用配额: 租户={}, 请求数量={}", tenantId, requestCount);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxHourlyApiCalls() == null) {
            return TenantQuotaCheckResult.unlimited("HOURLY_API_CALL");
        }
        
        // 获取当前小时的API调用数量（使用Redis计数）
        String hourlyKey = CACHE_PREFIX_HOURLY_API + tenantId + ":" + 
            LocalDateTime.now().getYear() + ":" +
            LocalDateTime.now().getMonthValue() + ":" +
            LocalDateTime.now().getDayOfMonth() + ":" +
            LocalDateTime.now().getHour();
        
        Long currentCount = redisTemplate.opsForValue().increment(hourlyKey, 0);
        if (currentCount == null) currentCount = 0L;
        
        long totalAfterRequest = currentCount + requestCount;
        
        if (totalAfterRequest > quota.getMaxHourlyApiCalls()) {
            return TenantQuotaCheckResult.failure(
                "HOURLY_API_CALL",
                currentCount,
                quota.getMaxHourlyApiCalls(),
                requestCount,
                "HOURLY_API_QUOTA_EXCEEDED",
                String.format("当前小时API调用数量超出限制，当前: %d, 限制: %d, 请求: %d",
                    currentCount, quota.getMaxHourlyApiCalls(), requestCount)
            );
        }
        
        return TenantQuotaCheckResult.success("HOURLY_API_CALL", totalAfterRequest, quota.getMaxHourlyApiCalls());
    }

    @Override
    public TenantQuotaCheckResult checkStorageQuota(String tenantId, BigDecimal requestSize) {
        log.debug("检查存储配额: 租户={}, 请求大小={}GB", tenantId, requestSize);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxStorageGb() == null) {
            return TenantQuotaCheckResult.unlimited("STORAGE");
        }
        
        // 获取当前存储使用量
        TenantUsage todayUsage = getUsageByDate(tenantId, LocalDate.now());
        BigDecimal currentUsage = todayUsage != null ? todayUsage.getStorageUsed() : BigDecimal.ZERO;
        BigDecimal totalAfterRequest = currentUsage.add(requestSize);
        
        if (totalAfterRequest.compareTo(quota.getMaxStorageGb()) > 0) {
            return TenantQuotaCheckResult.failure(
                "STORAGE",
                currentUsage.longValue(),
                quota.getMaxStorageGb().longValue(),
                requestSize.longValue(),
                "STORAGE_QUOTA_EXCEEDED",
                String.format("存储空间超出限制，当前: %.2fGB, 限制: %.2fGB, 请求: %.2fGB",
                    currentUsage.doubleValue(), quota.getMaxStorageGb().doubleValue(), requestSize.doubleValue())
            );
        }
        
        return TenantQuotaCheckResult.success("STORAGE", 
            totalAfterRequest.longValue(), quota.getMaxStorageGb().longValue());
    }

    @Override
    public TenantQuotaCheckResult checkBandwidthQuota(String tenantId, BigDecimal requestSize) {
        // 类似存储配额检查的实现
        log.debug("检查带宽配额: 租户={}, 请求大小={}GB", tenantId, requestSize);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxBandwidthGb() == null) {
            return TenantQuotaCheckResult.unlimited("BANDWIDTH");
        }
        
        // 获取本月带宽使用量（这里简化为当日）
        TenantUsage todayUsage = getUsageByDate(tenantId, LocalDate.now());
        BigDecimal currentUsage = todayUsage != null ? todayUsage.getBandwidthUsed() : BigDecimal.ZERO;
        BigDecimal totalAfterRequest = currentUsage.add(requestSize);
        
        if (totalAfterRequest.compareTo(quota.getMaxBandwidthGb()) > 0) {
            return TenantQuotaCheckResult.failure(
                "BANDWIDTH",
                currentUsage.longValue(),
                quota.getMaxBandwidthGb().longValue(),
                requestSize.longValue(),
                "BANDWIDTH_QUOTA_EXCEEDED",
                String.format("带宽使用量超出限制，当前: %.2fGB, 限制: %.2fGB, 请求: %.2fGB",
                    currentUsage.doubleValue(), quota.getMaxBandwidthGb().doubleValue(), requestSize.doubleValue())
            );
        }
        
        return TenantQuotaCheckResult.success("BANDWIDTH", 
            totalAfterRequest.longValue(), quota.getMaxBandwidthGb().longValue());
    }

    @Override
    public TenantQuotaCheckResult checkMonitorRuleQuota(String tenantId, int requestCount) {
        log.debug("检查监控规则配额: 租户={}, 请求数量={}", tenantId, requestCount);
        
        TenantQuota quota = getTenantQuota(tenantId);
        if (quota.getMaxMonitorRules() == null) {
            return TenantQuotaCheckResult.unlimited("MONITOR_RULE");
        }
        
        // 这里需要查询当前监控规则数量（暂时返回成功）
        // TODO: 实现监控规则数量查询
        return TenantQuotaCheckResult.success("MONITOR_RULE", 0L, (long) quota.getMaxMonitorRules());
    }

    @Override
    public boolean hasFeaturePermission(String tenantId, String featureName) {
        log.debug("检查功能权限: 租户={}, 功能={}", tenantId, featureName);
        
        TenantQuota quota = getTenantQuota(tenantId);
        
        switch (featureName) {
            case "AUTO_RECOVERY":
                return Boolean.TRUE.equals(quota.getEnableAutoRecovery());
            case "CUSTOM_CALLBACK":
                return Boolean.TRUE.equals(quota.getEnableCustomCallback());
            case "ADVANCED_MONITORING":
                return Boolean.TRUE.equals(quota.getEnableAdvancedMonitoring());
            case "API_ACCESS":
                return Boolean.TRUE.equals(quota.getEnableApiAccess());
            default:
                log.warn("未知功能权限: {}", featureName);
                return false;
        }
    }

    @Override
    public TenantUsage getCurrentUsage(String tenantId) {
        return getUsageByDate(tenantId, LocalDate.now());
    }

    @Override
    public TenantUsage getUsageByDate(String tenantId, LocalDate date) {
        log.debug("获取租户使用量: 租户={}, 日期={}", tenantId, date);
        
        // 先从缓存获取
        String cacheKey = CACHE_PREFIX_USAGE + tenantId + ":" + date.toString();
        TenantUsage cached = (TenantUsage) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }
        
        // 从数据库获取
        TenantUsage usage = tenantUsageRepository.findByTenantIdAndUsageDate(tenantId, date);
        if (usage == null) {
            // 创建默认使用量记录
            usage = createDefaultUsage(tenantId, date);
        }
        
        // 更新缓存（较短过期时间，因为数据可能频繁变化）
        redisTemplate.opsForValue().set(cacheKey, usage, 60, TimeUnit.SECONDS);
        
        return usage;
    }

    @Override
    @Transactional
    public void updateTenantQuota(TenantQuota quota) {
        log.info("更新租户配额: {}", quota.getTenantId());
        
        tenantQuotaRepository.insert(quota);
        
        // 清除缓存
        String cacheKey = CACHE_PREFIX_QUOTA + quota.getTenantId();
        redisTemplate.delete(cacheKey);
    }

    @Override
    @Transactional
    public void recordAccountUsage(String tenantId, int accountCount) {
        log.debug("记录账号使用: 租户={}, 数量={}", tenantId, accountCount);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        usage.setAccountCount(accountCount);
        
        // 计算在线账号数
        long onlineCount = accountRepository.countByTenantIdAndStatus(
            tenantId, com.wework.platform.common.enums.AccountStatus.ONLINE);
        usage.setOnlineAccountCount((int) onlineCount);
        
        // 更新峰值
        if (usage.getPeakOnlineAccounts() == null || onlineCount > usage.getPeakOnlineAccounts()) {
            usage.setPeakOnlineAccounts((int) onlineCount);
        }
        
        tenantUsageRepository.insert(usage);
        
        // 清除缓存
        clearUsageCache(tenantId, LocalDate.now());
    }

    @Override
    @Transactional
    public void recordMessageUsage(String tenantId, long messageCount, long successCount, long failedCount) {
        log.debug("记录消息使用: 租户={}, 消息数={}, 成功数={}, 失败数={}", 
            tenantId, messageCount, successCount, failedCount);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        usage.setMessageCount((usage.getMessageCount() != null ? usage.getMessageCount() : 0) + messageCount);
        usage.setMessageSuccessCount((usage.getMessageSuccessCount() != null ? usage.getMessageSuccessCount() : 0) + successCount);
        usage.setMessageFailedCount((usage.getMessageFailedCount() != null ? usage.getMessageFailedCount() : 0) + failedCount);
        
        tenantUsageRepository.insert(usage);
        clearUsageCache(tenantId, LocalDate.now());
    }

    @Override
    @Transactional
    public void recordApiUsage(String tenantId, long apiCallCount, long successCount, int avgResponseTime) {
        log.debug("记录API使用: 租户={}, API调用数={}, 成功数={}, 平均响应时间={}ms", 
            tenantId, apiCallCount, successCount, avgResponseTime);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        usage.setApiCallCount((usage.getApiCallCount() != null ? usage.getApiCallCount() : 0) + apiCallCount);
        usage.setApiSuccessCount((usage.getApiSuccessCount() != null ? usage.getApiSuccessCount() : 0) + successCount);
        
        // 计算平均响应时间
        if (usage.getAvgResponseTime() != null && usage.getApiCallCount() > 1) {
            usage.setAvgResponseTime((usage.getAvgResponseTime() + avgResponseTime) / 2);
        } else {
            usage.setAvgResponseTime(avgResponseTime);
        }
        
        tenantUsageRepository.insert(usage);
        clearUsageCache(tenantId, LocalDate.now());
        
        // 记录小时API调用数（用于限流）
        recordHourlyApiCall(tenantId, apiCallCount);
    }

    @Override
    @Transactional
    public void recordStorageUsage(String tenantId, BigDecimal storageUsed) {
        log.debug("记录存储使用: 租户={}, 存储使用={}GB", tenantId, storageUsed);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        usage.setStorageUsed(storageUsed);
        
        tenantUsageRepository.insert(usage);
        clearUsageCache(tenantId, LocalDate.now());
    }

    @Override
    @Transactional
    public void recordBandwidthUsage(String tenantId, BigDecimal bandwidthUsed) {
        log.debug("记录带宽使用: 租户={}, 带宽使用={}GB", tenantId, bandwidthUsed);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        BigDecimal currentBandwidth = usage.getBandwidthUsed() != null ? usage.getBandwidthUsed() : BigDecimal.ZERO;
        usage.setBandwidthUsed(currentBandwidth.add(bandwidthUsed));
        
        tenantUsageRepository.insert(usage);
        clearUsageCache(tenantId, LocalDate.now());
    }

    @Override
    @Transactional
    public void recordAlertUsage(String tenantId, int alertCount, int criticalAlertCount) {
        log.debug("记录告警使用: 租户={}, 告警数={}, 严重告警数={}", 
            tenantId, alertCount, criticalAlertCount);
        
        TenantUsage usage = getUsageByDate(tenantId, LocalDate.now());
        usage.setAlertCount((usage.getAlertCount() != null ? usage.getAlertCount() : 0) + alertCount);
        usage.setCriticalAlertCount((usage.getCriticalAlertCount() != null ? usage.getCriticalAlertCount() : 0) + criticalAlertCount);
        
        tenantUsageRepository.insert(usage);
        clearUsageCache(tenantId, LocalDate.now());
    }

    @Override
    public TenantQuotaCheckResult checkAllQuotas(String tenantId) {
        log.debug("检查所有配额: 租户={}", tenantId);
        
        // 检查账号配额
        TenantQuotaCheckResult accountResult = checkAccountQuota(tenantId, 0);
        if (!accountResult.isPassed()) {
            return accountResult;
        }
        
        // 检查消息配额
        TenantQuotaCheckResult messageResult = checkMessageQuota(tenantId, 0);
        if (!messageResult.isPassed()) {
            return messageResult;
        }
        
        // 检查API配额
        TenantQuotaCheckResult apiResult = checkApiCallQuota(tenantId, 0);
        if (!apiResult.isPassed()) {
            return apiResult;
        }
        
        // 所有检查都通过
        return TenantQuotaCheckResult.success("ALL", 0L, Long.MAX_VALUE);
    }

    @Override
    public boolean isUsageWarning(String tenantId, double threshold) {
        log.debug("检查使用率警告: 租户={}, 阈值={}", tenantId, threshold);
        
        TenantQuota quota = getTenantQuota(tenantId);
        TenantUsage usage = getCurrentUsage(tenantId);
        
        if (usage == null) return false;
        
        // 检查各项使用率
        if (quota.getMaxAccounts() != null) {
            double accountUsageRate = quota.getAccountUsageRate(usage.getAccountCount() != null ? usage.getAccountCount() : 0);
            if (accountUsageRate >= threshold) return true;
        }
        
        if (quota.getMaxDailyMessages() != null) {
            double messageUsageRate = quota.getDailyMessageUsageRate(usage.getMessageCount() != null ? usage.getMessageCount() : 0);
            if (messageUsageRate >= threshold) return true;
        }
        
        if (quota.getMaxStorageGb() != null && usage.getStorageUsed() != null) {
            double storageUsageRate = quota.getStorageUsageRate(usage.getStorageUsed());
            if (storageUsageRate >= threshold) return true;
        }
        
        return false;
    }

    @Override
    public BigDecimal calculateCost(String tenantId, LocalDate date) {
        // 简化的费用计算逻辑
        TenantUsage usage = getUsageByDate(tenantId, date);
        if (usage == null) return BigDecimal.ZERO;
        
        BigDecimal cost = BigDecimal.ZERO;
        
        // 账号费用：每个账号每天1元
        if (usage.getAccountCount() != null) {
            cost = cost.add(BigDecimal.valueOf(usage.getAccountCount()));
        }
        
        // 消息费用：每千条消息0.1元
        if (usage.getMessageCount() != null) {
            cost = cost.add(BigDecimal.valueOf(usage.getMessageCount()).divide(BigDecimal.valueOf(1000), 2, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(0.1)));
        }
        
        // 存储费用：每GB每天0.1元
        if (usage.getStorageUsed() != null) {
            cost = cost.add(usage.getStorageUsed().multiply(BigDecimal.valueOf(0.1)));
        }
        
        return cost;
    }

    /**
     * 创建默认配额
     */
    private TenantQuota createDefaultQuota(String tenantId) {
        TenantQuota quota = new TenantQuota();
        quota.setTenantId(tenantId);
        quota.setMaxAccounts(10);
        quota.setMaxOnlineAccounts(10);
        quota.setMaxDailyMessages(10000L);
        quota.setMaxDailyApiCalls(100000L);
        quota.setMaxHourlyApiCalls(5000L);
        quota.setMaxStorageGb(BigDecimal.valueOf(10));
        quota.setMaxBandwidthGb(BigDecimal.valueOf(100));
        quota.setMaxMonitorRules(50);
        quota.setMaxAlertsPerDay(1000);
        quota.setEnableAutoRecovery(true);
        quota.setEnableCustomCallback(true);
        quota.setEnableAdvancedMonitoring(false);
        quota.setEnableApiAccess(true);
        quota.setEffectiveFrom(LocalDate.now());
        
        tenantQuotaRepository.insert(quota);
        return quota;
    }

    /**
     * 创建默认使用量记录
     */
    private TenantUsage createDefaultUsage(String tenantId, LocalDate date) {
        TenantUsage usage = new TenantUsage();
        usage.setTenantId(tenantId);
        usage.setUsageDate(date);
        usage.setAccountCount(0);
        usage.setOnlineAccountCount(0);
        usage.setMessageCount(0L);
        usage.setMessageSuccessCount(0L);
        usage.setMessageFailedCount(0L);
        usage.setApiCallCount(0L);
        usage.setApiSuccessCount(0L);
        usage.setAlertCount(0);
        usage.setCriticalAlertCount(0);
        usage.setStorageUsed(BigDecimal.ZERO);
        usage.setBandwidthUsed(BigDecimal.ZERO);
        usage.setCost(BigDecimal.ZERO);
        usage.setBilled(false);
        usage.setPeakOnlineAccounts(0);
        usage.setAvgResponseTime(0);
        usage.setRecoveryCount(0);
        
        tenantUsageRepository.insert(usage);
        return usage;
    }

    /**
     * 记录小时API调用数
     */
    private void recordHourlyApiCall(String tenantId, long apiCallCount) {
        String hourlyKey = CACHE_PREFIX_HOURLY_API + tenantId + ":" + 
            LocalDateTime.now().getYear() + ":" +
            LocalDateTime.now().getMonthValue() + ":" +
            LocalDateTime.now().getDayOfMonth() + ":" +
            LocalDateTime.now().getHour();
        
        redisTemplate.opsForValue().increment(hourlyKey, apiCallCount);
        redisTemplate.expire(hourlyKey, 2, TimeUnit.HOURS); // 保留2小时
    }

    /**
     * 清除使用量缓存
     */
    private void clearUsageCache(String tenantId, LocalDate date) {
        String cacheKey = CACHE_PREFIX_USAGE + tenantId + ":" + date.toString();
        redisTemplate.delete(cacheKey);
    }
}