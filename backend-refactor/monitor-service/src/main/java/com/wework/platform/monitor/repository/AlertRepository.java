package com.wework.platform.monitor.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.entity.Alert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 告警记录Repository
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface AlertRepository extends BaseMapper<Alert> {

    /**
     * 分页查询租户的告警记录
     *
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param ruleId 规则ID
     * @param alertLevel 告警级别
     * @param status 状态
     * @param serviceName 服务名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 分页结果
     */
    @Select("<script>" +
            "SELECT * FROM alerts " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='ruleId != null and ruleId != \"\"'>" +
            "AND rule_id = #{ruleId} " +
            "</if>" +
            "<if test='alertLevel != null'>" +
            "AND alert_level = #{alertLevel} " +
            "</if>" +
            "<if test='status != null'>" +
            "AND status = #{status} " +
            "</if>" +
            "<if test='serviceName != null and serviceName != \"\"'>" +
            "AND service_name = #{serviceName} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND started_at >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND started_at <= #{endTime} " +
            "</if>" +
            "AND deleted_at IS NULL " +
            "ORDER BY started_at DESC" +
            "</script>")
    IPage<Alert> selectPageByConditions(
            Page<Alert> page,
            @Param("tenantId") String tenantId,
            @Param("ruleId") String ruleId,
            @Param("alertLevel") AlertLevel alertLevel,
            @Param("status") AlertStatus status,
            @Param("serviceName") String serviceName,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime
    );

    /**
     * 查询活跃的告警
     *
     * @param tenantId 租户ID
     * @return 告警列表
     */
    @Select("SELECT * FROM alerts " +
            "WHERE tenant_id = #{tenantId} " +
            "AND status IN ('FIRING', 'PENDING') " +
            "AND deleted_at IS NULL " +
            "ORDER BY started_at DESC")
    List<Alert> selectActiveAlerts(@Param("tenantId") String tenantId);

    /**
     * 查询未确认的告警
     *
     * @param tenantId 租户ID
     * @return 告警列表
     */
    @Select("SELECT * FROM alerts " +
            "WHERE tenant_id = #{tenantId} " +
            "AND status IN ('FIRING', 'PENDING') " +
            "AND acknowledged_at IS NULL " +
            "AND deleted_at IS NULL " +
            "ORDER BY started_at DESC")
    List<Alert> selectUnacknowledgedAlerts(@Param("tenantId") String tenantId);

    /**
     * 查询规则的活跃告警
     *
     * @param ruleId 规则ID
     * @return 告警
     */
    @Select("SELECT * FROM alerts " +
            "WHERE rule_id = #{ruleId} " +
            "AND status IN ('FIRING', 'PENDING') " +
            "AND deleted_at IS NULL " +
            "ORDER BY started_at DESC " +
            "LIMIT 1")
    Alert selectActiveAlertByRule(@Param("ruleId") String ruleId);

    /**
     * 确认告警
     *
     * @param id 告警ID
     * @param acknowledgedBy 确认人
     * @param acknowledgedAt 确认时间
     * @return 影响行数
     */
    @Update("UPDATE alerts SET " +
            "acknowledged_by = #{acknowledgedBy}, " +
            "acknowledged_at = #{acknowledgedAt} " +
            "WHERE id = #{id}")
    int acknowledgeAlert(
            @Param("id") String id,
            @Param("acknowledgedBy") String acknowledgedBy,
            @Param("acknowledgedAt") LocalDateTime acknowledgedAt
    );

    /**
     * 更新告警状态
     *
     * @param id 告警ID
     * @param status 状态
     * @param endedAt 结束时间
     * @return 影响行数
     */
    @Update("<script>" +
            "UPDATE alerts SET status = #{status} " +
            "<if test='endedAt != null'>" +
            ", ended_at = #{endedAt} " +
            "</if>" +
            "WHERE id = #{id}" +
            "</script>")
    int updateAlertStatus(
            @Param("id") String id,
            @Param("status") AlertStatus status,
            @Param("endedAt") LocalDateTime endedAt
    );

    /**
     * 更新通知状态
     *
     * @param id 告警ID
     * @param notificationSent 是否已发送
     * @param notifiedAt 通知时间
     * @return 影响行数
     */
    @Update("UPDATE alerts SET " +
            "notification_sent = #{notificationSent}, " +
            "notified_at = #{notifiedAt} " +
            "WHERE id = #{id}")
    int updateNotificationStatus(
            @Param("id") String id,
            @Param("notificationSent") Boolean notificationSent,
            @Param("notifiedAt") LocalDateTime notifiedAt
    );

    /**
     * 统计告警数量
     *
     * @param tenantId 租户ID
     * @param status 状态
     * @param alertLevel 告警级别
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 数量
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM alerts " +
            "WHERE tenant_id = #{tenantId} " +
            "<if test='status != null'>" +
            "AND status = #{status} " +
            "</if>" +
            "<if test='alertLevel != null'>" +
            "AND alert_level = #{alertLevel} " +
            "</if>" +
            "<if test='startTime != null'>" +
            "AND started_at >= #{startTime} " +
            "</if>" +
            "<if test='endTime != null'>" +
            "AND started_at <= #{endTime} " +
            "</if>" +
            "AND deleted_at IS NULL" +
            "</script>")
    Long countByConditions(
            @Param("tenantId") String tenantId,
            @Param("status") AlertStatus status,
            @Param("alertLevel") AlertLevel alertLevel,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime
    );

    /**
     * 删除过期的告警记录
     *
     * @param beforeTime 时间点
     * @return 删除数量
     */
    @Select("DELETE FROM alerts " +
            "WHERE ended_at IS NOT NULL " +
            "AND ended_at < #{beforeTime}")
    int deleteExpiredAlerts(@Param("beforeTime") LocalDateTime beforeTime);
}