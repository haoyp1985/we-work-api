package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.account.service.AlertManager.AlertTrendPoint;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 账号告警Repository
 * 
 * @author WeWork Platform Team
 */
@Mapper
public interface AccountAlertRepository extends BaseMapper<AccountAlert> {

    /**
     * 根据租户ID查询活跃告警
     */
    @Select("SELECT * FROM account_alerts WHERE tenant_id = #{tenantId} AND status = 'ACTIVE' ORDER BY alert_level DESC, created_at DESC")
    List<AccountAlert> findActiveAlertsByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据账号ID查询活跃告警
     */
    @Select("SELECT * FROM account_alerts WHERE tenant_id = #{tenantId} AND account_id = #{accountId} AND status = 'ACTIVE' ORDER BY alert_level DESC, created_at DESC")
    List<AccountAlert> findActiveAlertsByAccountId(@Param("tenantId") String tenantId, @Param("accountId") String accountId);

    /**
     * 统计租户的活跃告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE tenant_id = #{tenantId} AND status = 'ACTIVE'")
    int countActiveAlertsByTenantId(@Param("tenantId") String tenantId);

    /**
     * 统计账号的活跃告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE account_id = #{accountId} AND status = 'ACTIVE'")
    int countActiveAlertsByAccountId(@Param("accountId") String accountId);

    /**
     * 获取账号的最高告警级别
     */
    @Select("SELECT alert_level FROM account_alerts WHERE account_id = #{accountId} AND status = 'ACTIVE' ORDER BY alert_level DESC LIMIT 1")
    AlertLevel getMaxAlertLevelByAccountId(@Param("accountId") String accountId);

    /**
     * 统计租户告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE tenant_id = #{tenantId}")
    int countAlertsByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据租户ID和级别统计告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE tenant_id = #{tenantId} AND alert_level = #{level}")
    int countAlertsByTenantIdAndLevel(@Param("tenantId") String tenantId, @Param("level") AlertLevel level);

    /**
     * 根据租户ID和状态统计告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE tenant_id = #{tenantId} AND status = #{status}")
    int countAlertsByTenantIdAndStatus(@Param("tenantId") String tenantId, @Param("status") AlertStatus status);

    /**
     * 根据时间范围查询告警
     */
    @Select("SELECT * FROM account_alerts WHERE tenant_id = #{tenantId} AND created_at BETWEEN #{startTime} AND #{endTime} ORDER BY created_at DESC")
    List<AccountAlert> findAlertsByTenantIdAndTimeRange(@Param("tenantId") String tenantId, 
                                                       @Param("startTime") LocalDateTime startTime, 
                                                       @Param("endTime") LocalDateTime endTime);

    /**
     * 查找过期的活跃告警
     */
    @Select("SELECT * FROM account_alerts WHERE status = 'ACTIVE' AND created_at < #{expireTime}")
    List<AccountAlert> findExpiredActiveAlerts(@Param("expireTime") LocalDateTime expireTime);

    /**
     * 查找相同类型和账号的活跃告警
     */
    @Select("SELECT * FROM account_alerts WHERE tenant_id = #{tenantId} AND account_id = #{accountId} AND alert_type = #{alertType} AND status = 'ACTIVE' LIMIT 1")
    AccountAlert findActiveAlertByTypeAndAccount(@Param("tenantId") String tenantId, 
                                               @Param("accountId") String accountId, 
                                               @Param("alertType") AlertType alertType);

    /**
     * 统计所有活跃告警数量
     */
    @Select("SELECT COUNT(*) FROM account_alerts WHERE status = 'ACTIVE'")
    int countAllActiveAlerts();

    /**
     * 获取告警趋势数据
     */
    @Select("SELECT DATE_FORMAT(created_at, '%Y-%m-%d %H:00:00') as timestamp, " +
            "COUNT(*) as count, " +
            "SUM(CASE WHEN alert_level = 'CRITICAL' THEN 1 ELSE 0 END) as critical_count, " +
            "SUM(CASE WHEN alert_level = 'ERROR' THEN 1 ELSE 0 END) as error_count, " +
            "SUM(CASE WHEN alert_level = 'WARNING' THEN 1 ELSE 0 END) as warning_count, " +
            "SUM(CASE WHEN alert_level = 'INFO' THEN 1 ELSE 0 END) as info_count " +
            "FROM account_alerts " +
            "WHERE tenant_id = #{tenantId} AND created_at >= #{startTime} " +
            "GROUP BY DATE_FORMAT(created_at, '%Y-%m-%d %H:00:00') " +
            "ORDER BY timestamp")
    List<AlertTrendPoint> getAlertTrendByTenantId(@Param("tenantId") String tenantId, 
                                                @Param("startTime") LocalDateTime startTime);
}