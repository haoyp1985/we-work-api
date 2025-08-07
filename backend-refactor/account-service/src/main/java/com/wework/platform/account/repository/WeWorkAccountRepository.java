package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.account.entity.WeWorkAccount;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
    @Select("SELECT * FROM wework_accounts WHERE corp_id = #{corpId} AND tenant_id = #{tenantId} AND deleted_at IS NULL")
    WeWorkAccount findByCorpId(@Param("corpId") String corpId, @Param("tenantId") String tenantId);

    /**
     * 根据租户ID查询账号列表
     * 
     * @param tenantId 租户ID
     * @return 账号列表
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} AND deleted_at IS NULL ORDER BY created_at DESC")
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
    @Select("<script>" +
            "SELECT * FROM wework_accounts " +
            "WHERE tenant_id = #{tenantId} AND deleted_at IS NULL " +
            "<if test='keyword != null and keyword != &quot;&quot;'>" +
            "  AND (corp_name LIKE CONCAT('%', #{keyword}, '%') OR corp_id LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "<if test='status != null'>" +
            "  AND status = #{status} " +
            "</if>" +
            "ORDER BY created_at DESC" +
            "</script>")
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
    @Select("SELECT * FROM wework_accounts WHERE status = #{status} AND tenant_id = #{tenantId} AND deleted_at IS NULL")
    List<WeWorkAccount> findByStatus(@Param("status") Integer status, @Param("tenantId") String tenantId);

    /**
     * 查询在线账号数量
     * 
     * @param tenantId 租户ID
     * @return 在线账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE status = 1 AND tenant_id = #{tenantId} AND deleted_at IS NULL")
    int countOnlineAccounts(@Param("tenantId") String tenantId);

    /**
     * 查询离线账号数量
     * 
     * @param tenantId 租户ID
     * @return 离线账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE status = 2 AND tenant_id = #{tenantId} AND deleted_at IS NULL")
    int countOfflineAccounts(@Param("tenantId") String tenantId);

    /**
     * 查询异常账号数量
     * 
     * @param tenantId 租户ID
     * @return 异常账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE status = 3 AND tenant_id = #{tenantId} AND deleted_at IS NULL")
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
    @Update("UPDATE wework_accounts SET status = #{status}, error_msg = #{errorMsg}, " +
            "updated_at = NOW(), updated_by = #{operatorId} " +
            "WHERE id = #{accountId}")
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
    @Update("UPDATE wework_accounts SET access_token = #{accessToken}, " +
            "access_token_expire_time = #{expireTime}, updated_at = NOW() " +
            "WHERE id = #{accountId}")
    int updateAccessToken(@Param("accountId") String accountId, 
                         @Param("accessToken") String accessToken,
                         @Param("expireTime") String expireTime);

    /**
     * 更新心跳时间
     * 
     * @param accountId 账号ID
     * @return 更新行数
     */
    @Update("UPDATE wework_accounts SET last_heartbeat_time = NOW() WHERE id = #{accountId}")
    int updateHeartbeatTime(@Param("accountId") String accountId);

    /**
     * 查询需要心跳检测的账号
     * 
     * @param minutes 多少分钟内未心跳
     * @return 账号列表
     */
    @Select("SELECT * FROM wework_accounts " +
            "WHERE status = 1 AND deleted_at IS NULL " +
            "AND (last_heartbeat_time IS NULL OR last_heartbeat_time < DATE_SUB(NOW(), INTERVAL #{minutes} MINUTE))")
    List<WeWorkAccount> findAccountsNeedHeartbeat(@Param("minutes") int minutes);

    /**
     * 查询指定租户的账号统计信息
     * 
     * @param tenantId 租户ID
     * @return 统计信息
     */
    @Select("SELECT " +
            "COUNT(*) as total, " +
            "SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as online, " +
            "SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) as offline, " +
            "SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) as error " +
            "FROM wework_accounts WHERE tenant_id = #{tenantId} AND deleted_at IS NULL")
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