package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.entity.TenantUsage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 租户使用统计Repository
 *
 * @author WeWork Platform Team
 */
@Mapper
@Repository
public interface TenantUsageRepository extends BaseMapper<TenantUsage> {

    /**
     * 根据租户ID和日期查询使用量
     */
    @Select("SELECT * FROM tenant_usage WHERE tenant_id = #{tenantId} AND usage_date = #{usageDate}")
    TenantUsage findByTenantIdAndUsageDate(@Param("tenantId") String tenantId, 
                                          @Param("usageDate") LocalDate usageDate);

    /**
     * 根据租户ID查询指定日期范围的使用量
     */
    @Select("SELECT * FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "AND usage_date BETWEEN #{startDate} AND #{endDate} " +
            "ORDER BY usage_date DESC")
    List<TenantUsage> findByTenantIdAndDateRange(@Param("tenantId") String tenantId,
                                                @Param("startDate") LocalDate startDate,
                                                @Param("endDate") LocalDate endDate);

    /**
     * 根据租户ID分页查询使用量历史
     */
    @Select("SELECT * FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "ORDER BY usage_date DESC")
    Page<TenantUsage> findByTenantIdWithPage(Page<TenantUsage> page, @Param("tenantId") String tenantId);

    /**
     * 查询指定日期所有租户的使用量
     */
    @Select("SELECT * FROM tenant_usage WHERE usage_date = #{usageDate} ORDER BY tenant_id")
    List<TenantUsage> findByUsageDate(@Param("usageDate") LocalDate usageDate);

    /**
     * 查询租户月度使用量汇总
     */
    @Select("SELECT " +
            "tenant_id, " +
            "DATE_FORMAT(usage_date, '%Y-%m') as month, " +
            "SUM(account_count) as total_account_count, " +
            "MAX(peak_online_accounts) as max_peak_online, " +
            "SUM(message_count) as total_message_count, " +
            "SUM(message_success_count) as total_message_success, " +
            "SUM(api_call_count) as total_api_calls, " +
            "AVG(avg_response_time) as avg_response_time, " +
            "SUM(alert_count) as total_alerts, " +
            "SUM(critical_alert_count) as total_critical_alerts, " +
            "MAX(storage_used) as max_storage_used, " +
            "SUM(bandwidth_used) as total_bandwidth_used, " +
            "SUM(cost) as total_cost " +
            "FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "AND usage_date BETWEEN #{startDate} AND #{endDate} " +
            "GROUP BY tenant_id, DATE_FORMAT(usage_date, '%Y-%m') " +
            "ORDER BY month DESC")
    List<Map<String, Object>> getMonthlyUsageSummary(@Param("tenantId") String tenantId,
                                                     @Param("startDate") LocalDate startDate,
                                                     @Param("endDate") LocalDate endDate);

    /**
     * 查询租户当月使用量
     */
    @Select("SELECT " +
            "SUM(message_count) as total_messages, " +
            "SUM(message_success_count) as total_success_messages, " +
            "SUM(api_call_count) as total_api_calls, " +
            "AVG(account_count) as avg_accounts, " +
            "MAX(peak_online_accounts) as max_online, " +
            "SUM(alert_count) as total_alerts, " +
            "MAX(storage_used) as max_storage, " +
            "SUM(bandwidth_used) as total_bandwidth, " +
            "SUM(cost) as total_cost " +
            "FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "AND usage_date BETWEEN #{startDate} AND #{endDate}")
    Map<String, Object> getCurrentMonthUsage(@Param("tenantId") String tenantId,
                                            @Param("startDate") LocalDate startDate,
                                            @Param("endDate") LocalDate endDate);

    /**
     * 查询租户昨日使用量
     */
    @Select("SELECT * FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "AND usage_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)")
    TenantUsage getYesterdayUsage(@Param("tenantId") String tenantId);

    /**
     * 查询租户最近N天的使用量
     */
    @Select("SELECT * FROM tenant_usage WHERE tenant_id = #{tenantId} " +
            "AND usage_date >= DATE_SUB(CURDATE(), INTERVAL #{days} DAY) " +
            "ORDER BY usage_date DESC")
    List<TenantUsage> getRecentUsage(@Param("tenantId") String tenantId, @Param("days") int days);

    /**
     * 查询未计费的使用记录
     */
    @Select("SELECT * FROM tenant_usage WHERE billed = false " +
            "AND usage_date <= #{endDate} " +
            "ORDER BY tenant_id, usage_date")
    List<TenantUsage> getUnbilledUsage(@Param("endDate") LocalDate endDate);

    /**
     * 标记为已计费
     */
    @Update("UPDATE tenant_usage SET billed = true, updated_at = NOW() " +
            "WHERE tenant_id = #{tenantId} AND usage_date BETWEEN #{startDate} AND #{endDate}")
    int markAsBilled(@Param("tenantId") String tenantId,
                    @Param("startDate") LocalDate startDate,
                    @Param("endDate") LocalDate endDate);

    /**
     * 查询顶级消费租户
     */
    @Select("SELECT tenant_id, SUM(cost) as total_cost, SUM(message_count) as total_messages " +
            "FROM tenant_usage WHERE usage_date BETWEEN #{startDate} AND #{endDate} " +
            "GROUP BY tenant_id ORDER BY total_cost DESC LIMIT #{limit}")
    List<Map<String, Object>> getTopConsumingTenants(@Param("startDate") LocalDate startDate,
                                                     @Param("endDate") LocalDate endDate,
                                                     @Param("limit") int limit);

    /**
     * 查询系统整体使用量统计
     */
    @Select("SELECT " +
            "COUNT(DISTINCT tenant_id) as active_tenants, " +
            "SUM(account_count) as total_accounts, " +
            "SUM(online_account_count) as total_online_accounts, " +
            "SUM(message_count) as total_messages, " +
            "SUM(message_success_count) as total_success_messages, " +
            "SUM(api_call_count) as total_api_calls, " +
            "AVG(avg_response_time) as system_avg_response_time, " +
            "SUM(alert_count) as total_alerts, " +
            "SUM(storage_used) as total_storage_used, " +
            "SUM(bandwidth_used) as total_bandwidth_used, " +
            "SUM(cost) as total_cost " +
            "FROM tenant_usage WHERE usage_date = #{date}")
    Map<String, Object> getSystemUsageStats(@Param("date") LocalDate date);

    /**
     * 查询配额使用率较高的租户
     */
    @Select("SELECT tu.*, tq.max_accounts, tq.max_daily_messages " +
            "FROM tenant_usage tu " +
            "LEFT JOIN tenant_quotas tq ON tu.tenant_id = tq.tenant_id " +
            "WHERE tu.usage_date = #{date} " +
            "AND (tu.account_count / NULLIF(tq.max_accounts, 0) * 100 >= #{threshold} " +
            "OR tu.message_count / NULLIF(tq.max_daily_messages, 0) * 100 >= #{threshold}) " +
            "ORDER BY (tu.account_count / NULLIF(tq.max_accounts, 0) * 100) DESC")
    List<TenantUsage> getHighUsageTenants(@Param("date") LocalDate date, 
                                         @Param("threshold") double threshold);

    /**
     * 删除过期的使用记录
     */
    @Update("DELETE FROM tenant_usage WHERE usage_date < #{beforeDate}")
    int deleteOldUsageRecords(@Param("beforeDate") LocalDate beforeDate);

    /**
     * 批量更新费用
     */
    @Update("UPDATE tenant_usage SET cost = #{cost}, updated_at = NOW() " +
            "WHERE tenant_id = #{tenantId} AND usage_date = #{usageDate}")
    int updateCost(@Param("tenantId") String tenantId, 
                  @Param("usageDate") LocalDate usageDate, 
                  @Param("cost") java.math.BigDecimal cost);
}