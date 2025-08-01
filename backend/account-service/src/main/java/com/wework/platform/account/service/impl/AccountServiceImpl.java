package com.wework.platform.account.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.client.WeWorkApiClient;
import com.wework.platform.account.dto.*;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.account.service.AccountService;
import com.wework.platform.common.dto.PageRequest;
import com.wework.platform.common.dto.PageResponse;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.enums.AccountStatus;
import com.wework.platform.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 账号管理服务实现
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private final WeWorkAccountRepository accountRepository;
    private final WeWorkApiClient weWorkApiClient;
    private final RedisTemplate<String, Object> redisTemplate;

    @Value("${wework.account.heartbeat-interval:30}")
    private Integer heartbeatInterval;

    @Value("${wework.account.max-retry-times:3}")
    private Integer maxRetryTimes;

    @Value("${wework.account.login-timeout:300}")
    private Integer loginTimeout;

    @Value("${wework.cache.account-expire:3600}")
    private Integer accountCacheExpire;

    @Value("${wework.cache.status-expire:300}")
    private Integer statusCacheExpire;

    private static final String CACHE_ACCOUNT_PREFIX = "account:";
    private static final String CACHE_STATUS_PREFIX = "account:status:";
    private static final String CACHE_LOGIN_PREFIX = "account:login:";

    @Override
    @Transactional
    public AccountResponse createAccount(AccountCreateRequest request) {
        log.info("创建账号，租户ID: {}, 账号名称: {}", request.getTenantId(), request.getAccountName());

        // 检查租户配额
        checkTenantQuota(request.getTenantId());

        // 创建账号实体
        WeWorkAccount account = new WeWorkAccount();
        account.setTenantId(request.getTenantId());
        account.setAccountName(request.getAccountName());
        account.setPhone(request.getPhone());
        account.setStatus(AccountStatus.CREATED);
        account.setConfig(request.getConfig());

        // 保存到数据库
        accountRepository.insert(account);

        log.info("账号创建成功，账号ID: {}", account.getId());

        // 清除缓存
        clearAccountCache(account.getId());

        return convertToResponse(account);
    }

    @Override
    public AccountResponse getAccount(String accountId) {
        log.debug("获取账号详情，账号ID: {}", accountId);

        // 先从缓存获取
        String cacheKey = CACHE_ACCOUNT_PREFIX + accountId;
        WeWorkAccount cached = (WeWorkAccount) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return convertToResponse(cached);
        }

        // 从数据库获取
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        // 更新缓存
        redisTemplate.opsForValue().set(cacheKey, account, accountCacheExpire, TimeUnit.SECONDS);

        return convertToResponse(account);
    }

    @Override
    public PageResponse<AccountResponse> listAccounts(String tenantId, PageRequest pageRequest) {
        log.debug("分页查询账号，租户ID: {}, 页码: {}, 大小: {}", tenantId, pageRequest.getPage(), pageRequest.getSize());

        Page<WeWorkAccount> page = new Page<>(pageRequest.getPage(), pageRequest.getSize());
        Page<WeWorkAccount> result = accountRepository.selectByTenantId(page, tenantId, pageRequest.getKeyword());

        List<AccountResponse> records = result.getRecords().stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());

        return PageResponse.of(records, result.getTotal(), pageRequest.getPage(), pageRequest.getSize());
    }

    @Override
    @Transactional
    public AccountResponse updateAccount(String accountId, AccountCreateRequest request) {
        log.info("更新账号，账号ID: {}", accountId);

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        // 更新账号信息
        account.setAccountName(request.getAccountName());
        account.setPhone(request.getPhone());
        account.setConfig(request.getConfig());

        accountRepository.updateById(account);

        // 清除缓存
        clearAccountCache(accountId);

        log.info("账号更新成功，账号ID: {}", accountId);
        return convertToResponse(account);
    }

    @Override
    @Transactional
    public void deleteAccount(String accountId) {
        log.info("删除账号，账号ID: {}", accountId);

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        // 如果账号在线，先停止实例
        if (account.getStatus() == AccountStatus.ONLINE && StringUtils.hasText(account.getGuid())) {
            try {
                weWorkApiClient.stopInstance(account.getGuid());
                weWorkApiClient.deleteInstance(account.getGuid());
            } catch (Exception e) {
                log.warn("停止/删除企微实例失败: {}", e.getMessage());
            }
        }

        // 删除账号
        accountRepository.deleteById(accountId);

        // 清除缓存
        clearAccountCache(accountId);

        log.info("账号删除成功，账号ID: {}", accountId);
    }

    @Override
    @Transactional
    public LoginQRCodeResponse loginAccount(AccountLoginRequest request) {
        log.info("账号登录，账号ID: {}", request.getAccountId());

        WeWorkAccount account = accountRepository.selectById(request.getAccountId());
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        if (account.getStatus() == AccountStatus.ONLINE) {
            throw BusinessException.badRequest("账号已在线");
        }

        try {
            // 创建企微实例
            String guid = weWorkApiClient.createInstance(
                    request.getClientType().toString(),
                    request.getProxy(),
                    request.getBridge()
            );

            // 获取登录二维码
            JSONObject qrData = weWorkApiClient.getLoginQRCode(guid);

            // 更新账号状态
            accountRepository.updateStatus(account.getId(), AccountStatus.WAITING_QR, LocalDateTime.now());

            // 缓存登录信息
            String loginKey = CACHE_LOGIN_PREFIX + account.getId();
            redisTemplate.opsForValue().set(loginKey, guid, loginTimeout, TimeUnit.SECONDS);

            // 清除账号缓存
            clearAccountCache(account.getId());

            // 构建响应
            LoginQRCodeResponse response = new LoginQRCodeResponse();
            response.setAccountId(account.getId());
            response.setGuid(guid);
            response.setQrcodeContent(qrData.getString("qrcode"));
            response.setQrcodeKey(qrData.getString("qrcodeKey"));
            response.setLoginToken(qrData.getString("loginToken"));
            response.setExpiresIn(loginTimeout);

            log.info("登录二维码生成成功，账号ID: {}, GUID: {}", account.getId(), guid);
            return response;

        } catch (Exception e) {
            log.error("账号登录失败: {}", e.getMessage(), e);
            // 恢复账号状态
            accountRepository.updateStatus(account.getId(), account.getStatus(), LocalDateTime.now());
            throw new BusinessException("账号登录失败: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public void logoutAccount(String accountId) {
        log.info("账号登出，账号ID: {}", accountId);

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        if (StringUtils.hasText(account.getGuid())) {
            try {
                weWorkApiClient.stopInstance(account.getGuid());
            } catch (Exception e) {
                log.warn("停止企微实例失败: {}", e.getMessage());
            }
        }

        // 更新账号状态
        accountRepository.updateStatus(accountId, AccountStatus.OFFLINE, LocalDateTime.now());

        // 清除缓存
        clearAccountCache(accountId);
        redisTemplate.delete(CACHE_STATUS_PREFIX + accountId);
        redisTemplate.delete(CACHE_LOGIN_PREFIX + accountId);

        log.info("账号登出成功，账号ID: {}", accountId);
    }

    @Override
    public AccountStatusResponse getAccountStatus(String accountId) {
        log.debug("获取账号状态，账号ID: {}", accountId);

        // 先从缓存获取
        String cacheKey = CACHE_STATUS_PREFIX + accountId;
        AccountStatusResponse cached = (AccountStatusResponse) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return cached;
        }

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        AccountStatusResponse response = new AccountStatusResponse();
        response.setAccountId(accountId);
        response.setGuid(account.getGuid());
        response.setStatus(account.getStatus());
        response.setStatusDesc(account.getStatus().getDescription());
        response.setLastHeartbeatTime(account.getLastHeartbeatTime());

        // 计算在线时长
        if (account.getLastLoginTime() != null) {
            LocalDateTime endTime = account.getStatus() == AccountStatus.ONLINE 
                    ? LocalDateTime.now() 
                    : account.getLastHeartbeatTime();
            if (endTime != null) {
                response.setOnlineDuration(ChronoUnit.SECONDS.between(account.getLastLoginTime(), endTime));
            }
        }

        // 检查健康状态
        boolean healthy = checkAccountHealth(account);
        response.setHealthy(healthy);

        // 如果账号在线且有GUID，获取实时状态
        if (account.getStatus() == AccountStatus.ONLINE && StringUtils.hasText(account.getGuid())) {
            try {
                JSONObject statusData = weWorkApiClient.getInstanceStatus(account.getGuid());
                response.setDetails(statusData.toJSONString());
            } catch (Exception e) {
                log.warn("获取实例状态失败: {}", e.getMessage());
                response.setHealthy(false);
            }
        }

        // 缓存状态信息
        redisTemplate.opsForValue().set(cacheKey, response, statusCacheExpire, TimeUnit.SECONDS);

        return response;
    }

    @Override
    @Transactional
    public void restartAccount(String accountId) {
        log.info("重启账号，账号ID: {}", accountId);

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        // 先登出
        if (account.getStatus() == AccountStatus.ONLINE) {
            logoutAccount(accountId);
        }

        // 等待一秒后重新登录
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 重新登录
        AccountLoginRequest loginRequest = new AccountLoginRequest();
        loginRequest.setAccountId(accountId);
        loginAccount(loginRequest);

        log.info("账号重启完成，账号ID: {}", accountId);
    }

    @Override
    public List<AccountStatusResponse> batchGetAccountStatus(List<String> accountIds) {
        log.debug("批量获取账号状态，账号数量: {}", accountIds.size());

        return accountIds.stream()
                .map(this::getAccountStatus)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void verifyLoginCode(String accountId, String code) {
        log.info("验证登录验证码，账号ID: {}", accountId);

        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw BusinessException.notFound("账号不存在");
        }

        // 获取GUID
        String loginKey = CACHE_LOGIN_PREFIX + accountId;
        String guid = (String) redisTemplate.opsForValue().get(loginKey);
        if (!StringUtils.hasText(guid)) {
            throw BusinessException.badRequest("登录会话已过期，请重新登录");
        }

        try {
            // 验证登录验证码
            weWorkApiClient.verifyLoginCode(guid, code);

            // 更新账号登录信息
            LocalDateTime now = LocalDateTime.now();
            accountRepository.updateLoginInfo(
                    accountId, 
                    guid, 
                    AccountStatus.ONLINE, 
                    now, 
                    now, 
                    now
            );

            // 清除缓存
            clearAccountCache(accountId);
            redisTemplate.delete(loginKey);

            log.info("验证登录验证码成功，账号ID: {}", accountId);

        } catch (Exception e) {
            log.error("验证登录验证码失败: {}", e.getMessage(), e);
            throw new BusinessException("验证登录验证码失败: " + e.getMessage());
        }
    }

    /**
     * 检查租户配额
     */
    private void checkTenantQuota(String tenantId) {
        // TODO: 实现租户配额检查逻辑
        long accountCount = accountRepository.countByTenantId(tenantId);
        log.debug("租户 {} 当前账号数量: {}", tenantId, accountCount);
    }

    /**
     * 检查账号健康状态
     */
    private boolean checkAccountHealth(WeWorkAccount account) {
        if (account.getStatus() != AccountStatus.ONLINE) {
            return true; // 非在线状态认为是健康的
        }

        if (account.getLastHeartbeatTime() == null) {
            return false;
        }

        // 检查心跳时间是否超过阈值
        LocalDateTime threshold = LocalDateTime.now().minusSeconds(heartbeatInterval * 3);
        return account.getLastHeartbeatTime().isAfter(threshold);
    }

    /**
     * 转换为响应DTO
     */
    private AccountResponse convertToResponse(WeWorkAccount account) {
        AccountResponse response = new AccountResponse();
        response.setId(account.getId());
        response.setTenantId(account.getTenantId());
        response.setAccountName(account.getAccountName());
        response.setGuid(account.getGuid());
        response.setPhone(account.getPhone());
        response.setStatus(account.getStatus());
        response.setStatusDesc(account.getStatus().getDescription());
        response.setConfig(account.getConfig());
        response.setLastLoginTime(account.getLastLoginTime());
        response.setLastHeartbeatTime(account.getLastHeartbeatTime());
        response.setCreatedAt(account.getCreatedAt());
        response.setUpdatedAt(account.getUpdatedAt());

        // 计算在线时长
        if (account.getLastLoginTime() != null) {
            LocalDateTime endTime = account.getStatus() == AccountStatus.ONLINE 
                    ? LocalDateTime.now() 
                    : account.getLastHeartbeatTime();
            if (endTime != null) {
                response.setOnlineDuration(ChronoUnit.SECONDS.between(account.getLastLoginTime(), endTime));
            }
        }

        return response;
    }

    /**
     * 清除账号缓存
     */
    private void clearAccountCache(String accountId) {
        redisTemplate.delete(CACHE_ACCOUNT_PREFIX + accountId);
        redisTemplate.delete(CACHE_STATUS_PREFIX + accountId);
    }
}