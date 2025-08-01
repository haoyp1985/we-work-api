package com.wework.platform.account.service;

import com.wework.platform.account.dto.*;
import com.wework.platform.common.dto.PageRequest;
import com.wework.platform.common.dto.PageResponse;

/**
 * 账号管理服务接口
 *
 * @author WeWork Platform Team
 */
public interface AccountService {

    /**
     * 创建账号
     */
    AccountResponse createAccount(AccountCreateRequest request);

    /**
     * 获取账号详情
     */
    AccountResponse getAccount(String accountId);

    /**
     * 分页查询账号
     */
    PageResponse<AccountResponse> listAccounts(String tenantId, PageRequest pageRequest);

    /**
     * 更新账号
     */
    AccountResponse updateAccount(String accountId, AccountCreateRequest request);

    /**
     * 删除账号
     */
    void deleteAccount(String accountId);

    /**
     * 账号登录
     */
    LoginQRCodeResponse loginAccount(AccountLoginRequest request);

    /**
     * 账号登出
     */
    void logoutAccount(String accountId);

    /**
     * 获取账号状态
     */
    AccountStatusResponse getAccountStatus(String accountId);

    /**
     * 重启账号
     */
    void restartAccount(String accountId);

    /**
     * 批量获取账号状态
     */
    java.util.List<AccountStatusResponse> batchGetAccountStatus(java.util.List<String> accountIds);

    /**
     * 验证登录验证码
     */
    void verifyLoginCode(String accountId, String code);
}