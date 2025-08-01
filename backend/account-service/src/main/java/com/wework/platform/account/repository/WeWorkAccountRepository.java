package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.enums.AccountStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 企微账号Repository
 *
 * @author WeWork Platform Team
 */
@Mapper
@Repository
public interface WeWorkAccountRepository extends BaseMapper<WeWorkAccount> {

    /**
     * 根据租户ID分页查询账号
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} " +
            "AND (#{keyword} IS NULL OR account_name LIKE CONCAT('%', #{keyword}, '%')) " +
            "ORDER BY created_at DESC")
    Page<WeWorkAccount> selectByTenantId(Page<WeWorkAccount> page, 
                                        @Param("tenantId") String tenantId,
                                        @Param("keyword") String keyword);

    /**
     * 根据GUID查询账号
     */
    @Select("SELECT * FROM wework_accounts WHERE guid = #{guid}")
    WeWorkAccount selectByGuid(@Param("guid") String guid);

    /**
     * 根据租户ID和状态查询账号
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} AND status = #{status}")
    List<WeWorkAccount> selectByTenantIdAndStatus(@Param("tenantId") String tenantId, 
                                                  @Param("status") AccountStatus status);

        /**
     * 更新账号状态
     */
    @Update("UPDATE wework_accounts SET status = #{status}, updated_at = #{updatedAt} WHERE id = #{id}")
    int updateStatus(@Param("id") String id, 
                    @Param("status") AccountStatus status,
                    @Param("updatedAt") LocalDateTime updatedAt);

    /**
     * 根据租户ID统计账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE tenant_id = #{tenantId}")
    long countByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据租户ID和状态统计账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE tenant_id = #{tenantId} AND status = #{status}")
    long countByTenantIdAndStatus(@Param("tenantId") String tenantId, @Param("status") AccountStatus status);

    /**
     * 获取租户的在线账号列表
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} AND status = 'ONLINE' ORDER BY last_heartbeat_time DESC")
    List<WeWorkAccount> findOnlineAccountsByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据租户ID和健康度范围查询账号
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} " +
            "AND health_score BETWEEN #{minScore} AND #{maxScore} " +
            "ORDER BY health_score DESC")
    List<WeWorkAccount> findByTenantIdAndHealthScoreRange(@Param("tenantId") String tenantId,
                                                         @Param("minScore") Integer minScore,
                                                         @Param("maxScore") Integer maxScore);

    /**
     * 获取租户账号状态统计
     */
    @Select("SELECT status, COUNT(*) as count FROM wework_accounts " +
            "WHERE tenant_id = #{tenantId} GROUP BY status")
    List<Map<String, Object>> getAccountStatusStatsByTenantId(@Param("tenantId") String tenantId);

    /**
     * 查询需要监控的账号（在线状态且超过心跳间隔时间）
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} " +
            "AND status = 'ONLINE' " +
            "AND (last_heartbeat_time IS NULL OR last_heartbeat_time < #{timeThreshold}) " +
            "ORDER BY last_heartbeat_time ASC")
    List<WeWorkAccount> findAccountsNeedingMonitor(@Param("tenantId") String tenantId,
                                                  @Param("timeThreshold") LocalDateTime timeThreshold);

    /**
     * 批量更新账号健康度评分
     */
    @Update("UPDATE wework_accounts SET health_score = #{healthScore}, updated_at = NOW() " +
            "WHERE id = #{accountId}")
    int updateHealthScore(@Param("accountId") String accountId, @Param("healthScore") Integer healthScore);

    /**
     * 更新账号心跳时间
     */
    @Update("UPDATE wework_accounts SET last_heartbeat_time = #{heartbeatTime}, updated_at = NOW() " +
            "WHERE id = #{accountId}")
    int updateHeartbeatTime(@Param("accountId") String accountId, @Param("heartbeatTime") LocalDateTime heartbeatTime);

    /**
     * 查询长时间离线的账号
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} " +
            "AND status = 'OFFLINE' " +
            "AND updated_at < #{timeThreshold} " +
            "ORDER BY updated_at ASC")
    List<WeWorkAccount> findLongOfflineAccounts(@Param("tenantId") String tenantId,
                                               @Param("timeThreshold") LocalDateTime timeThreshold);

    /**
     * 查询异常状态的账号
     */
    @Select("SELECT * FROM wework_accounts WHERE tenant_id = #{tenantId} " +
            "AND (status = 'ERROR' OR health_score < #{minHealthScore}) " +
            "ORDER BY health_score ASC, updated_at ASC")
    List<WeWorkAccount> findProblematicAccounts(@Param("tenantId") String tenantId,
                                               @Param("minHealthScore") Integer minHealthScore);

    /**
     * 更新重试次数
     */
    @Update("UPDATE wework_accounts SET retry_count = #{retryCount}, updated_at = NOW() " +
            "WHERE id = #{accountId}")
    int updateRetryCount(@Param("accountId") String accountId, @Param("retryCount") Integer retryCount);

    /**
     * 重置重试次数
     */
    @Update("UPDATE wework_accounts SET retry_count = 0, updated_at = NOW() " +
            "WHERE tenant_id = #{tenantId} AND status = 'ONLINE'")
    int resetRetryCountForOnlineAccounts(@Param("tenantId") String tenantId);

    /**
     * 更新心跳时间
     */
    @Update("UPDATE wework_accounts SET last_heartbeat_time = #{heartbeatTime}, updated_at = #{updatedAt} WHERE id = #{id}")
    int updateHeartbeat(@Param("id") String id, 
                        @Param("heartbeatTime") LocalDateTime heartbeatTime, 
                        @Param("updatedAt") LocalDateTime updatedAt);

    /**
     * 更新登录信息
     */
    @Update("UPDATE wework_accounts SET guid = #{guid}, status = #{status}, " +
            "last_login_time = #{loginTime}, last_heartbeat_time = #{heartbeatTime}, " +
            "updated_at = #{updatedAt} WHERE id = #{id}")
    int updateLoginInfo(@Param("id") String id,
                        @Param("guid") String guid,
                        @Param("status") AccountStatus status,
                        @Param("loginTime") LocalDateTime loginTime,
                        @Param("heartbeatTime") LocalDateTime heartbeatTime,
                        @Param("updatedAt") LocalDateTime updatedAt);

    /**
     * 查询需要心跳检查的账号（在线状态且超过心跳间隔时间）
     */
    @Select("SELECT * FROM wework_accounts WHERE status = 'online' " +
            "AND (last_heartbeat_time IS NULL OR last_heartbeat_time < #{checkTime})")
    List<WeWorkAccount> selectNeedHeartbeatCheck(@Param("checkTime") LocalDateTime checkTime);

        /**
         * 统计租户在线账号数量
         */
        @Select("SELECT COUNT(*) FROM wework_accounts WHERE tenant_id = #{tenantId} AND status = 'online'")
        int countOnlineByTenantId(@Param("tenantId") String tenantId);

        /**
         * 根据状态查询账号
         */
        @Select("SELECT * FROM wework_accounts WHERE status = #{status}")
        List<WeWorkAccount> selectByStatus(@Param("status") AccountStatus status);
}