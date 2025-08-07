package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.entity.WeWorkAccount;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 企微账号数据访问层
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface WeWorkAccountRepository extends BaseMapper<WeWorkAccount> {

    /**
     * 根据企业ID查询账号
     * 
     * @param corpId 企业ID
     * @param tenantId 租户ID
     * @return 账号信息
     */
    WeWorkAccount findByCorpId(@Param("corpId") String corpId, @Param("tenantId") String tenantId);

    /**
     * 根据租户ID查询账号列表
     * 
     * @param tenantId 租户ID
     * @return 账号列表
     */
    List<WeWorkAccount> findByTenantId(@Param("tenantId") String tenantId);

    /**
     * 分页查询账号列表
     * 
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param keyword 关键词
     * @param status 状态
     * @return 分页结果
     */
    Page<WeWorkAccount> findAccountsPage(Page<WeWorkAccount> page, 
                                        @Param("tenantId") String tenantId,
                                        @Param("keyword") String keyword, 
                                        @Param("status") Integer status);

    /**
     * 根据状态查询账号列表
     * 
     * @param status 状态
     * @param tenantId 租户ID
     * @return 账号列表
     */
    List<WeWorkAccount> findByStatus(@Param("status") Integer status, @Param("tenantId") String tenantId);

    /**
     * 查询在线账号数量
     * 
     * @param tenantId 租户ID
     * @return 在线账号数量
     */
    int countOnlineAccounts(@Param("tenantId") String tenantId);

    /**
     * 查询离线账号数量
     * 
     * @param tenantId 租户ID
     * @return 离线账号数量
     */
    int countOfflineAccounts(@Param("tenantId") String tenantId);

    /**
     * 查询异常账号数量
     * 
     * @param tenantId 租户ID
     * @return 异常账号数量
     */
    int countErrorAccounts(@Param("tenantId") String tenantId);

    /**
     * 更新账号状态
     * 
     * @param accountId 账号ID
     * @param status 新状态
     * @param errorMsg 错误信息
     * @param operatorId 操作人ID
     * @return 更新行数
     */
    int updateAccountStatus(@Param("accountId") String accountId, 
                           @Param("status") Integer status,
                           @Param("errorMsg") String errorMsg, 
                           @Param("operatorId") String operatorId);

    /**
     * 更新访问令牌
     * 
     * @param accountId 账号ID
     * @param accessToken 访问令牌
     * @param expireTime 过期时间
     * @return 更新行数
     */
    int updateAccessToken(@Param("accountId") String accountId, 
                         @Param("accessToken") String accessToken,
                         @Param("expireTime") String expireTime);

    /**
     * 更新心跳时间
     * 
     * @param accountId 账号ID
     * @return 更新行数
     */
    int updateHeartbeatTime(@Param("accountId") String accountId);

    /**
     * 查询需要心跳检测的账号
     * 
     * @param minutes 多少分钟内未心跳
     * @return 账号列表
     */
    List<WeWorkAccount> findAccountsNeedHeartbeat(@Param("minutes") int minutes);

    /**
     * 查询指定租户的账号统计信息
     * 
     * @param tenantId 租户ID
     * @return 统计信息
     */
    AccountStatistics getAccountStatistics(@Param("tenantId") String tenantId);

    /**
     * 账号统计信息内部类
     */
    class AccountStatistics {
        private Integer total;
        private Integer online;
        private Integer offline;
        private Integer error;

        // Getters and Setters
        public Integer getTotal() { return total; }
        public void setTotal(Integer total) { this.total = total; }
        public Integer getOnline() { return online; }
        public void setOnline(Integer online) { this.online = online; }
        public Integer getOffline() { return offline; }
        public void setOffline(Integer offline) { this.offline = offline; }
        public Integer getError() { return error; }
        public void setError(Integer error) { this.error = error; }
    }
}