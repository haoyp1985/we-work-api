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
     * 统计租户账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE tenant_id = #{tenantId}")
    int countByTenantId(@Param("tenantId") String tenantId);

    /**
     * 统计租户在线账号数量
     */
    @Select("SELECT COUNT(*) FROM wework_accounts WHERE tenant_id = #{tenantId} AND status = 'online'")
    int countOnlineByTenantId(@Param("tenantId") String tenantId);
}