package com.wework.platform.account.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.account.dto.*;
import com.wework.platform.account.entity.AccountStatusLog;
import com.wework.platform.account.entity.WeWorkAccount;
import com.wework.platform.account.repository.AccountStatusLogRepository;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.account.repository.WeWorkContactRepository;
import com.wework.platform.account.service.WeWorkAccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 企微账号服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WeWorkAccountServiceImpl implements WeWorkAccountService {

    private final WeWorkAccountRepository accountRepository;
    private final WeWorkContactRepository contactRepository;
    private final AccountStatusLogRepository statusLogRepository;

    @Override
    public PageResult<WeWorkAccountDTO> getAccountList(String tenantId, Integer pageNum, Integer pageSize, 
                                                      String keyword, Integer status) {
        Page<WeWorkAccount> page = new Page<>(pageNum, pageSize);
        Page<WeWorkAccount> accountPage = accountRepository.findAccountsPage(page, tenantId, keyword, status);
        
        List<WeWorkAccountDTO> accountDTOs = accountPage.getRecords().stream()
                .map(this::convertToAccountDTO)
                .collect(Collectors.toList());

        return PageResult.<WeWorkAccountDTO>builder()
                .records(accountDTOs)
                .total(accountPage.getTotal())
                .current(pageNum.longValue())
                .size(pageSize.longValue())
                .pages(accountPage.getPages())
                .build();
    }

    @Override
    public WeWorkAccountDTO getAccountById(String accountId, String tenantId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        return convertToAccountDTO(account);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WeWorkAccountDTO createAccount(CreateAccountRequest request, String tenantId, String operatorId) {
        // 检查企业ID是否已存在
        if (isCorpIdExists(request.getCorpId(), tenantId, null)) {
            throw new BusinessException(ResultCode.CONFLICT, "企业ID已存在");
        }

        WeWorkAccount account = new WeWorkAccount();
        account.setId(UUID.randomUUID().toString());
        account.setCorpId(request.getCorpId());
        account.setCorpName(request.getCorpName());
        account.setAgentId(request.getAgentId());
        account.setSecret(request.getSecret());
        account.setContactSyncSecret(request.getContactSyncSecret());
        account.setMessageEncryptKey(request.getMessageEncryptKey());
        account.setStatus(4); // 初始化中
        account.setTenantId(tenantId);
        account.setAutoReconnect(request.getAutoReconnect());
        account.setRemark(request.getRemark());
        account.setRetryCount(0);
        account.setCreatedAt(LocalDateTime.now());
        account.setUpdatedAt(LocalDateTime.now());
        account.setCreatedBy(operatorId);
        account.setUpdatedBy(operatorId);

        accountRepository.insert(account);

        // 记录状态变更日志
        logStatusChange(account.getId(), null, 4, "账号创建", 1, operatorId, "系统管理员", tenantId);

        log.info("创建企微账号成功: accountId={}, corpId={}, operator={}", 
                account.getId(), request.getCorpId(), operatorId);

        return convertToAccountDTO(account);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public WeWorkAccountDTO updateAccount(String accountId, UpdateAccountRequest request, 
                                        String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // 更新字段
        if (StringUtils.hasText(request.getCorpName())) {
            account.setCorpName(request.getCorpName());
        }
        if (StringUtils.hasText(request.getSecret())) {
            account.setSecret(request.getSecret());
            // 密钥变更需要重新登录
            if (account.getStatus() == 1) {
                account.setStatus(4); // 设为初始化中状态
            }
        }
        if (StringUtils.hasText(request.getContactSyncSecret())) {
            account.setContactSyncSecret(request.getContactSyncSecret());
        }
        if (StringUtils.hasText(request.getMessageEncryptKey())) {
            account.setMessageEncryptKey(request.getMessageEncryptKey());
        }
        if (request.getAutoReconnect() != null) {
            account.setAutoReconnect(request.getAutoReconnect());
        }
        if (StringUtils.hasText(request.getRemark())) {
            account.setRemark(request.getRemark());
        }

        account.setUpdatedAt(LocalDateTime.now());
        account.setUpdatedBy(operatorId);

        accountRepository.updateById(account);

        log.info("更新企微账号成功: accountId={}, operator={}", accountId, operatorId);

        return convertToAccountDTO(account);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteAccount(String accountId, String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // 软删除账号
        account.setDeletedAt(LocalDateTime.now());
        account.setUpdatedBy(operatorId);
        accountRepository.updateById(account);

        // 记录状态变更日志
        logStatusChange(accountId, account.getStatus(), 0, "账号删除", 1, operatorId, "系统管理员", tenantId);

        log.info("删除企微账号成功: accountId={}, operator={}", accountId, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String loginAccount(String accountId, String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        Integer oldStatus = account.getStatus();
        
        // 更新账号状态为等待扫码
        updateAccountStatus(accountId, 5, "手动登录", null, operatorId);

        // TODO: 这里应该调用企微API获取登录二维码
        String qrCodeUrl = generateQrCodeUrl(account);
        
        // 更新二维码URL
        account.setQrCodeUrl(qrCodeUrl);
        accountRepository.updateById(account);

        log.info("企微账号开始登录: accountId={}, operator={}", accountId, operatorId);

        return qrCodeUrl;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void logoutAccount(String accountId, String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // 更新账号状态为离线
        updateAccountStatus(accountId, 2, "手动登出", null, operatorId);

        // 清空访问令牌和二维码
        account.setAccessToken(null);
        account.setAccessTokenExpireTime(null);
        account.setQrCodeUrl(null);
        accountRepository.updateById(account);

        log.info("企微账号登出成功: accountId={}, operator={}", accountId, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void restartAccount(String accountId, String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // 重置重试次数
        account.setRetryCount(0);
        account.setErrorMsg(null);
        accountRepository.updateById(account);

        // 更新账号状态为初始化中
        updateAccountStatus(accountId, 4, "手动重启", null, operatorId);

        log.info("企微账号重启成功: accountId={}, operator={}", accountId, operatorId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String syncContacts(String accountId, String tenantId, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null || !account.getTenantId().equals(tenantId)) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        if (account.getStatus() != 1) {
            throw new BusinessException(ResultCode.BAD_REQUEST, "账号未在线，无法同步联系人");
        }

        // TODO: 这里应该调用企微API同步联系人
        // 模拟同步过程
        String taskId = UUID.randomUUID().toString();

        log.info("开始同步联系人: accountId={}, taskId={}, operator={}", accountId, taskId, operatorId);

        return taskId;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateAccountStatus(String accountId, Integer newStatus, String reason, 
                                  String errorMsg, String operatorId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            log.warn("账号不存在，无法更新状态: accountId={}", accountId);
            return;
        }

        Integer oldStatus = account.getStatus();
        if (oldStatus.equals(newStatus)) {
            return; // 状态未变化
        }

        // 更新账号状态
        accountRepository.updateAccountStatus(accountId, newStatus, errorMsg, operatorId);

        // 记录状态变更日志
        logStatusChange(accountId, oldStatus, newStatus, reason, 2, operatorId, "系统", account.getTenantId());

        log.info("账号状态更新: accountId={}, {} -> {}, reason={}", 
                accountId, oldStatus, newStatus, reason);
    }

    @Override
    public boolean heartbeat(String accountId) {
        try {
            WeWorkAccount account = accountRepository.selectById(accountId);
            if (account == null || account.getStatus() != 1) {
                return false;
            }

            // TODO: 这里应该调用企微API进行心跳检测
            // 模拟心跳检测
            boolean isOnline = checkAccountOnlineStatus(account);

            if (isOnline) {
                // 更新心跳时间
                accountRepository.updateHeartbeatTime(accountId);
                return true;
            } else {
                // 账号离线，更新状态
                updateAccountStatus(accountId, 2, "心跳检测失败", "心跳检测无响应", "system");
                return false;
            }
        } catch (Exception e) {
            log.error("心跳检测异常: accountId={}", accountId, e);
            updateAccountStatus(accountId, 3, "心跳检测异常", e.getMessage(), "system");
            return false;
        }
    }

    @Override
    public List<String> batchHeartbeat(String tenantId) {
        List<WeWorkAccount> accounts = accountRepository.findByStatus(1, tenantId);
        List<String> offlineAccounts = new ArrayList<>();

        for (WeWorkAccount account : accounts) {
            if (!heartbeat(account.getId())) {
                offlineAccounts.add(account.getId());
            }
        }

        log.info("批量心跳检测完成: tenantId={}, 检测数量={}, 离线数量={}", 
                tenantId, accounts.size(), offlineAccounts.size());

        return offlineAccounts;
    }

    @Override
    public AccountStatisticsDTO getAccountStatistics(String tenantId) {
        WeWorkAccountRepository.AccountStatistics stats = accountRepository.getAccountStatistics(tenantId);
        
        AccountStatisticsDTO dto = new AccountStatisticsDTO();
        dto.setTotalAccounts(stats.getTotal());
        dto.setOnlineAccounts(stats.getOnline());
        dto.setOfflineAccounts(stats.getOffline());
        dto.setErrorAccounts(stats.getError());

        // 计算在线率
        if (stats.getTotal() > 0) {
            dto.setOnlineRate((double) stats.getOnline() / stats.getTotal() * 100);
        } else {
            dto.setOnlineRate(0.0);
        }

        // TODO: 添加联系人统计、状态分布、趋势分析等

        return dto;
    }

    @Override
    public List<WeWorkAccount> getAccountsNeedHeartbeat(int minutes) {
        return accountRepository.findAccountsNeedHeartbeat(minutes);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<String> autoRecoverErrorAccounts(String tenantId) {
        List<WeWorkAccount> errorAccounts = accountRepository.findByStatus(3, tenantId);
        List<String> recoveredAccounts = new ArrayList<>();

        for (WeWorkAccount account : errorAccounts) {
            if (account.getAutoReconnect() && account.getRetryCount() < 3) {
                try {
                    // 尝试恢复账号
                    updateAccountStatus(account.getId(), 8, "自动恢复", null, "system");
                    
                    // 增加重试次数
                    account.setRetryCount(account.getRetryCount() + 1);
                    accountRepository.updateById(account);
                    
                    recoveredAccounts.add(account.getId());
                    
                    log.info("自动恢复异常账号: accountId={}, retryCount={}", 
                            account.getId(), account.getRetryCount());
                } catch (Exception e) {
                    log.error("自动恢复账号失败: accountId={}", account.getId(), e);
                }
            }
        }

        return recoveredAccounts;
    }

    @Override
    public boolean isCorpIdExists(String corpId, String tenantId, String excludeAccountId) {
        WeWorkAccount account = accountRepository.findByCorpId(corpId, tenantId);
        if (account == null) {
            return false;
        }
        
        return excludeAccountId == null || !excludeAccountId.equals(account.getId());
    }

    @Override
    public String getAccessToken(String accountId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // TODO: 检查访问令牌是否过期，如果过期则刷新
        return account.getAccessToken();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String refreshAccessToken(String accountId) {
        WeWorkAccount account = accountRepository.selectById(accountId);
        if (account == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "账号不存在");
        }

        // TODO: 调用企微API刷新访问令牌
        String newAccessToken = generateAccessToken(account);
        String expireTime = calculateExpireTime();

        // 更新访问令牌
        accountRepository.updateAccessToken(accountId, newAccessToken, expireTime);

        log.info("刷新访问令牌成功: accountId={}", accountId);

        return newAccessToken;
    }

    // 私有辅助方法

    private WeWorkAccountDTO convertToAccountDTO(WeWorkAccount account) {
        WeWorkAccountDTO dto = new WeWorkAccountDTO();
        BeanUtils.copyProperties(account, dto);

        // 设置状态描述
        dto.setStatusDesc(getStatusDescription(account.getStatus()));

        // 获取联系人统计
        WeWorkContactRepository.ContactStatistics contactStats = 
                contactRepository.getContactStatistics(account.getId());
        if (contactStats != null) {
            WeWorkAccountDTO.ContactStats stats = new WeWorkAccountDTO.ContactStats();
            stats.setTotal(contactStats.getTotal());
            stats.setInternal(contactStats.getInternal());
            stats.setExternal(contactStats.getExternal());
            stats.setGroups(contactStats.getGroups());
            dto.setContactStats(stats);
        }

        return dto;
    }

    private void logStatusChange(String accountId, Integer oldStatus, Integer newStatus, 
                               String reason, Integer operationType, String operatorId, 
                               String operatorName, String tenantId) {
        AccountStatusLog statusLog = new AccountStatusLog();
        statusLog.setId(UUID.randomUUID().toString());
        statusLog.setAccountId(accountId);
        statusLog.setOldStatus(oldStatus);
        statusLog.setNewStatus(newStatus);
        statusLog.setReason(reason);
        statusLog.setOperationType(operationType);
        statusLog.setOperatorId(operatorId);
        statusLog.setOperatorName(operatorName);
        statusLog.setTenantId(tenantId);
        statusLog.setCreatedAt(LocalDateTime.now());

        statusLogRepository.insert(statusLog);
    }

    private String getStatusDescription(Integer status) {
        switch (status) {
            case 1: return "在线";
            case 2: return "离线";
            case 3: return "异常";
            case 4: return "初始化中";
            case 5: return "等待扫码";
            case 6: return "等待确认";
            case 7: return "验证中";
            case 8: return "恢复中";
            case 0: return "禁用";
            default: return "未知";
        }
    }

    private String generateQrCodeUrl(WeWorkAccount account) {
        // TODO: 调用企微API生成二维码
        return "https://api.wework.com/qr/" + UUID.randomUUID().toString();
    }

    private boolean checkAccountOnlineStatus(WeWorkAccount account) {
        // TODO: 调用企微API检查账号在线状态
        // 模拟检测结果
        return Math.random() > 0.1; // 90%概率在线
    }

    private String generateAccessToken(WeWorkAccount account) {
        // TODO: 调用企微API获取访问令牌
        return "ACCESS_TOKEN_" + UUID.randomUUID().toString();
    }

    private String calculateExpireTime() {
        // TODO: 计算访问令牌过期时间
        return String.valueOf(System.currentTimeMillis() + 7200000); // 2小时后过期
    }
}