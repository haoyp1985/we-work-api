package com.wework.platform.account.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.account.dto.*;
import com.wework.platform.account.entity.WeWorkAccount;

import java.util.List;

/**
 * 企微账号服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface WeWorkAccountService {

    /**
     * 分页查询账号列表
     * 
     * @param tenantId 租户ID
     * @param pageNum 页码
     * @param pageSize 页大小
     * @param keyword 关键词
     * @param status 状态
     * @return 分页结果
     */
    PageResult<WeWorkAccountDTO> getAccountList(String tenantId, Integer pageNum, Integer pageSize, 
                                              String keyword, Integer status);

    /**
     * 根据ID获取账号详情
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @return 账号详情
     */
    WeWorkAccountDTO getAccountById(String accountId, String tenantId);

    /**
     * 创建企微账号
     * 
     * @param request 创建请求
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 账号信息
     */
    WeWorkAccountDTO createAccount(CreateAccountRequest request, String tenantId, String operatorId);

    /**
     * 更新企微账号
     * 
     * @param accountId 账号ID
     * @param request 更新请求
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 账号信息
     */
    WeWorkAccountDTO updateAccount(String accountId, UpdateAccountRequest request, 
                                 String tenantId, String operatorId);

    /**
     * 删除企微账号
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void deleteAccount(String accountId, String tenantId, String operatorId);

    /**
     * 登录企微账号
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 二维码URL或登录状态
     */
    String loginAccount(String accountId, String tenantId, String operatorId);

    /**
     * 登出企微账号
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void logoutAccount(String accountId, String tenantId, String operatorId);

    /**
     * 重启企微账号
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     */
    void restartAccount(String accountId, String tenantId, String operatorId);

    /**
     * 同步联系人
     * 
     * @param accountId 账号ID
     * @param tenantId 租户ID
     * @param operatorId 操作人ID
     * @return 同步结果
     */
    String syncContacts(String accountId, String tenantId, String operatorId);

    /**
     * 更新账号状态
     * 
     * @param accountId 账号ID
     * @param newStatus 新状态
     * @param reason 变更原因
     * @param errorMsg 错误信息
     * @param operatorId 操作人ID
     */
    void updateAccountStatus(String accountId, Integer newStatus, String reason, 
                           String errorMsg, String operatorId);

    /**
     * 心跳检测
     * 
     * @param accountId 账号ID
     * @return 心跳结果
     */
    boolean heartbeat(String accountId);

    /**
     * 批量心跳检测
     * 
     * @param tenantId 租户ID
     * @return 检测结果
     */
    List<String> batchHeartbeat(String tenantId);

    /**
     * 获取账号统计信息
     * 
     * @param tenantId 租户ID
     * @return 统计信息
     */
    AccountStatisticsDTO getAccountStatistics(String tenantId);

    /**
     * 获取需要心跳检测的账号
     * 
     * @param minutes 多少分钟内未心跳
     * @return 账号列表
     */
    List<WeWorkAccount> getAccountsNeedHeartbeat(int minutes);

    /**
     * 自动恢复异常账号
     * 
     * @param tenantId 租户ID
     * @return 恢复结果
     */
    List<String> autoRecoverErrorAccounts(String tenantId);

    /**
     * 检查企业ID是否已存在
     * 
     * @param corpId 企业ID
     * @param tenantId 租户ID
     * @param excludeAccountId 排除的账号ID
     * @return 是否存在
     */
    boolean isCorpIdExists(String corpId, String tenantId, String excludeAccountId);

    /**
     * 获取访问令牌
     * 
     * @param accountId 账号ID
     * @return 访问令牌
     */
    String getAccessToken(String accountId);

    /**
     * 刷新访问令牌
     * 
     * @param accountId 账号ID
     * @return 新的访问令牌
     */
    String refreshAccessToken(String accountId);
}