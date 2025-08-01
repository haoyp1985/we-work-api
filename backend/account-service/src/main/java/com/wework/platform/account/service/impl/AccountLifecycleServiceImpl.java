package com.wework.platform.account.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.wework.platform.account.service.AccountLifecycleService;
import com.wework.platform.account.client.WeWorkApiClient;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.enums.AccountStatus;
import com.wework.platform.common.exception.BusinessException;
import com.wework.platform.common.service.TenantQuotaService;
import com.wework.platform.common.dto.TenantQuotaCheckResult;
import com.wework.platform.common.tenant.TenantContext;
import com.wework.platform.common.tenant.TenantRequired;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.redis.core.RedisTemplate;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 企微账号生命周期服务实现 - 支持多租户
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
@TenantRequired
public class AccountLifecycleServiceImpl implements AccountLifecycleService {

    private final WeWorkApiClient weWorkApiClient;
    private final WeWorkAccountRepository accountRepository;
    private final TenantQuotaService tenantQuotaService;
    private final RedisTemplate<String, Object> redisTemplate;

    private static final String CACHE_PREFIX_ACCOUNT = "account:";
    private static final String LOCK_PREFIX_ACCOUNT = "account:lock:";
    private static final int CACHE_EXPIRE_SECONDS = 300;
    private static final int LOCK_EXPIRE_SECONDS = 30;

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public WeWorkAccount createAccount(String tenantId, String accountName, String phone, String tag) {
        log.info("租户 {} 创建账号: name={}, phone={}, tag={}", tenantId, accountName, phone, tag);
        
        // 验证租户权限
        TenantContext.validateTenantAccess(tenantId);
        
        // 检查租户账号配额
        TenantQuotaCheckResult quotaResult = tenantQuotaService.checkAccountQuota(tenantId, 1);
        if (!quotaResult.isPassed()) {
            throw new BusinessException("账号配额不足: " + quotaResult.getMessage());
        }
        
        // 检查账号名称是否重复
        validateAccountName(tenantId, accountName);
        
        // 创建企微实例
        String weWorkGuid;
        try {
            weWorkGuid = weWorkApiClient.createInstance(tenantId, null, null, null);
            log.info("租户 {} 创建企微实例成功: guid={}", tenantId, weWorkGuid);
        } catch (Exception e) {
            log.error("租户 {} 创建企微实例失败: {}", tenantId, e.getMessage(), e);
            throw new BusinessException("创建企微实例失败: " + e.getMessage());
        }
        
        // 创建账号记录
        WeWorkAccount account = new WeWorkAccount();
        account.setTenantId(tenantId);
        account.setAccountName(accountName);
        account.setWeWorkGuid(weWorkGuid);
        account.setPhone(phone);
        account.setTenantTag(tag);
        account.setStatus(AccountStatus.CREATED);
        account.setHealthScore(100);
        account.setAutoReconnect(true);
        account.setMonitorInterval(30);
        account.setMaxRetryCount(3);
        account.setRetryCount(0);
        account.setCallbackUrl(generateCallbackUrl(tenantId, weWorkGuid));
        
        try {
            accountRepository.insert(account);
            log.info("租户 {} 创建账号成功: accountId={}, guid={}", tenantId, account.getId(), weWorkGuid);
            
            // 记录账号使用量
            recordAccountUsage(tenantId);
            
            // 更新缓存
            updateAccountCache(account);
            
            return account;
            
        } catch (Exception e) {
            log.error("租户 {} 保存账号记录失败: {}", tenantId, e.getMessage(), e);
            
            // 回滚：删除已创建的企微实例
            try {
                weWorkApiClient.deleteInstance(weWorkGuid);
            } catch (Exception rollbackException) {
                log.warn("回滚删除企微实例失败: {}", rollbackException.getMessage());
            }
            
            throw new BusinessException("创建账号失败: " + e.getMessage());
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public JSONObject startLogin(String tenantId, String accountId) {
        log.info("租户 {} 启动账号登录: accountId={}", tenantId, accountId);
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查账号状态
        if (!account.canStartLogin()) {
            throw new BusinessException("账号当前状态不允许登录: " + account.getStatus().getDescription());
        }
        
        try {
            // 获取登录二维码
            JSONObject qrResult = weWorkApiClient.getLoginQRCode(account.getWeWorkGuid());
            
            // 更新账号状态
            updateAccountStatus(tenantId, accountId, AccountStatus.WAITING_QR, "获取登录二维码成功");
            
            log.info("租户 {} 获取登录二维码成功: accountId={}", tenantId, accountId);
            return qrResult;
            
        } catch (Exception e) {
            log.error("租户 {} 获取登录二维码失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            updateAccountStatus(tenantId, accountId, AccountStatus.ERROR, "获取登录二维码失败: " + e.getMessage());
            throw new BusinessException("获取登录二维码失败: " + e.getMessage());
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public AccountStatus checkLoginStatus(String tenantId, String accountId) {
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        try {
            JSONObject statusResult = weWorkApiClient.checkLogin(account.getWeWorkGuid());
            
            if (statusResult != null) {
                // 根据API返回结果更新状态
                String apiStatus = statusResult.getString("status");
                AccountStatus newStatus = mapApiStatusToAccountStatus(apiStatus);
                
                if (newStatus != account.getStatus()) {
                    updateAccountStatus(tenantId, accountId, newStatus, "API状态检查更新");
                }
                
                return newStatus;
            }
            
            return account.getStatus();
            
        } catch (Exception e) {
            log.warn("租户 {} 检查登录状态失败: accountId={}, error={}", tenantId, accountId, e.getMessage());
            return account.getStatus();
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void confirmLogin(String tenantId, String accountId, String verificationCode) {
        log.info("租户 {} 确认登录: accountId={}", tenantId, accountId);
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查账号状态
        if (account.getStatus() != AccountStatus.WAITING_CONFIRM && 
            account.getStatus() != AccountStatus.VERIFYING) {
            throw new BusinessException("账号状态不允许确认登录: " + account.getStatus().getDescription());
        }
        
        try {
            // 验证登录验证码
            weWorkApiClient.verifyLoginCode(account.getWeWorkGuid(), verificationCode);
            
            // 更新账号状态为在线
            updateAccountStatus(tenantId, accountId, AccountStatus.ONLINE, "登录验证成功");
            
            // 更新登录时间和心跳时间
            LocalDateTime now = LocalDateTime.now();
            accountRepository.updateLoginInfo(
                accountId, 
                account.getWeWorkGuid(),
                AccountStatus.ONLINE,
                now,
                now,
                now
            );
            
            // 重置重试次数
            account.resetRetryCount();
            accountRepository.updateRetryCount(accountId, account.getRetryCount());
            
            log.info("租户 {} 账号登录成功: accountId={}", tenantId, accountId);
            
        } catch (Exception e) {
            log.error("租户 {} 账号登录失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            updateAccountStatus(tenantId, accountId, AccountStatus.ERROR, "登录验证失败: " + e.getMessage());
            throw new BusinessException("登录验证失败: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void stopAccount(String tenantId, String accountId) {
        log.info("租户 {} 停止账号: accountId={}", tenantId, accountId);
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查功能权限
        if (!hasOperationPermission(tenantId, "STOP_ACCOUNT")) {
            throw new BusinessException("租户无权限执行此操作");
        }
        
        try {
            weWorkApiClient.stopInstance(account.getWeWorkGuid());
            updateAccountStatus(tenantId, accountId, AccountStatus.OFFLINE, "手动停止");
            
            log.info("租户 {} 停止账号成功: accountId={}", tenantId, accountId);
            
        } catch (Exception e) {
            log.error("租户 {} 停止账号失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            throw new BusinessException("停止账号失败: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void restartAccount(String tenantId, String accountId) {
        log.info("租户 {} 重启账号: accountId={}", tenantId, accountId);
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查功能权限
        if (!hasOperationPermission(tenantId, "RESTART_ACCOUNT")) {
            throw new BusinessException("租户无权限执行此操作");
        }
        
        String lockKey = LOCK_PREFIX_ACCOUNT + accountId;
        try {
            // 获取分布式锁
            Boolean lockAcquired = redisTemplate.opsForValue().setIfAbsent(lockKey, "locked", LOCK_EXPIRE_SECONDS, TimeUnit.SECONDS);
            if (!Boolean.TRUE.equals(lockAcquired)) {
                throw new BusinessException("账号正在处理中，请稍后重试");
            }
            
            // 先停止实例
            try {
                weWorkApiClient.stopInstance(account.getWeWorkGuid());
                Thread.sleep(2000); // 等待2秒
            } catch (Exception e) {
                log.warn("停止实例失败，继续重启流程: {}", e.getMessage());
            }
            
            // 重新创建实例
            String newGuid = weWorkApiClient.createInstance(tenantId, null, null, null);
            
            // 更新账号信息
            account.setWeWorkGuid(newGuid);
            account.setStatus(AccountStatus.CREATED);
            account.resetRetryCount();
            accountRepository.updateById(account);
            
            updateAccountStatus(tenantId, accountId, AccountStatus.CREATED, "重启成功，等待登录");
            
            log.info("租户 {} 重启账号成功: accountId={}, newGuid={}", tenantId, accountId, newGuid);
            
        } catch (Exception e) {
            log.error("租户 {} 重启账号失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            updateAccountStatus(tenantId, accountId, AccountStatus.ERROR, "重启失败: " + e.getMessage());
            throw new BusinessException("重启账号失败: " + e.getMessage());
        } finally {
            // 释放锁
            redisTemplate.delete(lockKey);
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void deleteAccount(String tenantId, String accountId) {
        log.info("租户 {} 删除账号: accountId={}", tenantId, accountId);
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查功能权限
        if (!hasOperationPermission(tenantId, "DELETE_ACCOUNT")) {
            throw new BusinessException("租户无权限执行此操作");
        }
        
        try {
            // 删除企微实例
            weWorkApiClient.deleteInstance(account.getWeWorkGuid());
            
            // 删除账号记录
            accountRepository.deleteById(accountId);
            
            // 清除缓存
            clearAccountCache(accountId);
            
            // 记录账号使用量变化
            recordAccountUsage(tenantId);
            
            log.info("租户 {} 删除账号成功: accountId={}", tenantId, accountId);
            
        } catch (Exception e) {
            log.error("租户 {} 删除账号失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            throw new BusinessException("删除账号失败: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void updateAccountStatus(String tenantId, String accountId, AccountStatus status, String reason) {
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        AccountStatus oldStatus = account.getStatus();
        if (oldStatus == status) {
            return; // 状态未变化
        }
        
        // 更新账号状态
        account.setStatus(status);
        accountRepository.updateStatus(accountId, status, LocalDateTime.now());
        
        // 记录状态历史
        recordStatusHistory(account, oldStatus, status, reason);
        
        // 更新缓存
        updateAccountCache(account);
        
        log.info("租户 {} 更新账号状态: accountId={}, {} → {}, reason={}",
            tenantId, accountId, oldStatus.getDescription(), status.getDescription(), reason);
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public WeWorkAccount getAccountDetail(String tenantId, String accountId) {
        return getAndValidateAccount(tenantId, accountId);
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public boolean validateAccountAccess(String tenantId, String accountId) {
        try {
            getAndValidateAccount(tenantId, accountId);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public boolean autoRecoverAccount(String tenantId, String accountId) {
        log.info("租户 {} 自动恢复账号: accountId={}", tenantId, accountId);
        
        // 检查是否允许自动恢复
        if (!tenantQuotaService.hasFeaturePermission(tenantId, "AUTO_RECOVERY")) {
            log.warn("租户 {} 无自动恢复权限", tenantId);
            return false;
        }
        
        WeWorkAccount account = getAndValidateAccount(tenantId, accountId);
        
        // 检查重试次数
        if (account.getRetryCount() >= account.getMaxRetryCount()) {
            log.warn("租户 {} 账号重试次数已达上限: accountId={}, retryCount={}", 
                tenantId, accountId, account.getRetryCount());
            return false;
        }
        
        try {
            updateAccountStatus(tenantId, accountId, AccountStatus.RECOVERING, "开始自动恢复");
            
            // 增加重试次数
            account.incrementRetryCount();
            accountRepository.updateRetryCount(accountId, account.getRetryCount());
            
            // 执行重启操作
            restartAccount(tenantId, accountId);
            
            log.info("租户 {} 自动恢复账号成功: accountId={}", tenantId, accountId);
            return true;
            
        } catch (Exception e) {
            log.error("租户 {} 自动恢复账号失败: accountId={}, error={}", tenantId, accountId, e.getMessage(), e);
            updateAccountStatus(tenantId, accountId, AccountStatus.ERROR, "自动恢复失败: " + e.getMessage());
            return false;
        }
    }

    @Override
    @Transactional
    @TenantRequired(validationType = TenantRequired.TenantValidationType.PARAMETER_TENANT)
    public void batchOperateAccounts(String tenantId, List<String> accountIds, String operation) {
        log.info("租户 {} 批量操作账号: operation={}, count={}", tenantId, operation, accountIds.size());
        
        // 检查功能权限
        if (!hasOperationPermission(tenantId, "BATCH_OPERATION")) {
            throw new BusinessException("租户无权限执行批量操作");
        }
        
        for (String accountId : accountIds) {
            try {
                switch (operation.toUpperCase()) {
                    case "STOP":
                        stopAccount(tenantId, accountId);
                        break;
                    case "RESTART":
                        restartAccount(tenantId, accountId);
                        break;
                    case "DELETE":
                        deleteAccount(tenantId, accountId);
                        break;
                    default:
                        throw new BusinessException("不支持的操作类型: " + operation);
                }
            } catch (Exception e) {
                log.error("租户 {} 批量操作账号失败: accountId={}, operation={}, error={}", 
                    tenantId, accountId, operation, e.getMessage());
                // 继续处理其他账号
            }
        }
    }

    // ========== 私有辅助方法 ==========

    /**
     * 获取并验证账号
     */
    private WeWorkAccount getAndValidateAccount(String tenantId, String accountId) {
        // 先从缓存获取
        String cacheKey = CACHE_PREFIX_ACCOUNT + accountId;
        WeWorkAccount cached = (WeWorkAccount) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null && tenantId.equals(cached.getTenantId())) {
            return cached;
        }
        
        // 从数据库获取
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw new BusinessException("账号不存在");
        }
        
        // 验证租户权限
        TenantContext.validateTenantAccess(account.getTenantId());
        
        // 更新缓存
        updateAccountCache(account);
        
        return account;
    }

    /**
     * 验证账号名称
     */
    private void validateAccountName(String tenantId, String accountName) {
        // 这里可以添加账号名称重复检查等逻辑
        if (accountName == null || accountName.trim().isEmpty()) {
            throw new BusinessException("账号名称不能为空");
        }
        
        // TODO: 检查租户内账号名称是否重复
    }

    /**
     * 生成回调URL
     */
    private String generateCallbackUrl(String tenantId, String guid) {
        return String.format("/api/callback/tenant/%s/account/%s", tenantId, guid);
    }

    /**
     * 记录账号使用量
     */
    private void recordAccountUsage(String tenantId) {
        try {
            int accountCount = (int) accountRepository.countByTenantId(tenantId);
            tenantQuotaService.recordAccountUsage(tenantId, accountCount);
        } catch (Exception e) {
            log.warn("记录账号使用量失败: {}", e.getMessage());
        }
    }

    /**
     * 记录状态历史
     */
    private void recordStatusHistory(WeWorkAccount account, AccountStatus oldStatus, AccountStatus newStatus, String reason) {
        // TODO: 实现状态历史记录
        log.debug("记录状态历史: accountId={}, {} → {}, reason={}", 
            account.getId(), oldStatus, newStatus, reason);
    }

    /**
     * 更新账号缓存
     */
    private void updateAccountCache(WeWorkAccount account) {
        String cacheKey = CACHE_PREFIX_ACCOUNT + account.getId();
        redisTemplate.opsForValue().set(cacheKey, account, CACHE_EXPIRE_SECONDS, TimeUnit.SECONDS);
    }

    /**
     * 清除账号缓存
     */
    private void clearAccountCache(String accountId) {
        String cacheKey = CACHE_PREFIX_ACCOUNT + accountId;
        redisTemplate.delete(cacheKey);
    }

    /**
     * 映射API状态到账号状态
     */
    private AccountStatus mapApiStatusToAccountStatus(String apiStatus) {
        if (apiStatus == null) return AccountStatus.OFFLINE;
        
        switch (apiStatus.toLowerCase()) {
            case "online":
                return AccountStatus.ONLINE;
            case "offline":
                return AccountStatus.OFFLINE;
            case "waiting":
                return AccountStatus.WAITING_QR;
            case "confirming":
                return AccountStatus.WAITING_CONFIRM;
            case "error":
                return AccountStatus.ERROR;
            default:
                return AccountStatus.OFFLINE;
        }
    }

    /**
     * 检查操作权限
     */
    private boolean hasOperationPermission(String tenantId, String operation) {
        // 这里可以根据租户配额和权限检查具体操作权限
        return true; // 暂时返回true，可以根据具体需求实现
    }
}