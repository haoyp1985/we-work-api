package com.wework.platform.account.service;

import com.alibaba.fastjson2.JSONObject;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.enums.AccountStatus;

/**
 * 企微账号生命周期服务接口
 * 
 * @author WeWork Platform Team
 */
public interface AccountLifecycleService {

    /**
     * 创建账号
     * 包含配额检查、权限验证等
     */
    WeWorkAccount createAccount(String tenantId, String accountName, String phone, String tag);

    /**
     * 启动账号登录流程
     */
    JSONObject startLogin(String tenantId, String accountId);

    /**
     * 检查登录状态
     */
    AccountStatus checkLoginStatus(String tenantId, String accountId);

    /**
     * 确认登录
     */
    void confirmLogin(String tenantId, String accountId, String verificationCode);

    /**
     * 停止账号
     */
    void stopAccount(String tenantId, String accountId);

    /**
     * 重启账号
     */
    void restartAccount(String tenantId, String accountId);

    /**
     * 删除账号
     */
    void deleteAccount(String tenantId, String accountId);

    /**
     * 更新账号状态
     */
    void updateAccountStatus(String tenantId, String accountId, AccountStatus status, String reason);

    /**
     * 获取账号详情
     */
    WeWorkAccount getAccountDetail(String tenantId, String accountId);

    /**
     * 验证账号权限
     */
    boolean validateAccountAccess(String tenantId, String accountId);

    /**
     * 自动恢复异常账号
     */
    boolean autoRecoverAccount(String tenantId, String accountId);

    /**
     * 批量操作账号
     */
    void batchOperateAccounts(String tenantId, java.util.List<String> accountIds, String operation);
}