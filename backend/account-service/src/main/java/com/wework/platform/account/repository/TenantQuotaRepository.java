package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.common.entity.TenantQuota;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * 租户配额Repository
 *
 * @author WeWork Platform Team
 */
@Mapper
@Repository
public interface TenantQuotaRepository extends BaseMapper<TenantQuota> {

    /**
     * 根据租户ID查询配额
     */
    @Select("SELECT * FROM tenant_quotas WHERE tenant_id = #{tenantId} " +
            "AND (effective_to IS NULL OR effective_to >= CURDATE()) " +
            "ORDER BY created_at DESC LIMIT 1")
    TenantQuota findByTenantId(@Param("tenantId") String tenantId);

    /**
     * 根据租户ID查询有效配额
     */
    @Select("SELECT * FROM tenant_quotas WHERE tenant_id = #{tenantId} " +
            "AND (effective_from IS NULL OR effective_from <= #{date}) " +
            "AND (effective_to IS NULL OR effective_to >= #{date}) " +
            "ORDER BY created_at DESC LIMIT 1")
    TenantQuota findEffectiveQuota(@Param("tenantId") String tenantId, @Param("date") LocalDate date);

    /**
     * 查询即将到期的配额
     */
    @Select("SELECT * FROM tenant_quotas WHERE effective_to IS NOT NULL " +
            "AND effective_to BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL #{days} DAY)")
    List<TenantQuota> findExpiringQuotas(@Param("days") int days);

    /**
     * 查询所有有效配额
     */
    @Select("SELECT * FROM tenant_quotas WHERE " +
            "(effective_from IS NULL OR effective_from <= CURDATE()) " +
            "AND (effective_to IS NULL OR effective_to >= CURDATE())")
    List<TenantQuota> findAllEffectiveQuotas();

    /**
     * 根据功能权限查询租户
     */
    @Select("SELECT * FROM tenant_quotas WHERE " +
            "CASE " +
            "  WHEN #{feature} = 'AUTO_RECOVERY' THEN enable_auto_recovery = true " +
            "  WHEN #{feature} = 'CUSTOM_CALLBACK' THEN enable_custom_callback = true " +
            "  WHEN #{feature} = 'ADVANCED_MONITORING' THEN enable_advanced_monitoring = true " +
            "  WHEN #{feature} = 'API_ACCESS' THEN enable_api_access = true " +
            "  ELSE false " +
            "END " +
            "AND (effective_from IS NULL OR effective_from <= CURDATE()) " +
            "AND (effective_to IS NULL OR effective_to >= CURDATE())")
    List<TenantQuota> findByFeatureEnabled(@Param("feature") String feature);

    /**
     * 统计租户配额使用情况
     */
    @Select("SELECT " +
            "COUNT(*) as total_tenants, " +
            "SUM(max_accounts) as total_max_accounts, " +
            "AVG(max_accounts) as avg_max_accounts, " +
            "SUM(max_daily_messages) as total_max_messages, " +
            "AVG(max_daily_messages) as avg_max_messages " +
            "FROM tenant_quotas WHERE " +
            "(effective_from IS NULL OR effective_from <= CURDATE()) " +
            "AND (effective_to IS NULL OR effective_to >= CURDATE())")
    java.util.Map<String, Object> getQuotaStatistics();

    /**
     * 检查租户是否存在有效配额
     */
    @Select("SELECT COUNT(*) > 0 FROM tenant_quotas WHERE tenant_id = #{tenantId} " +
            "AND (effective_from IS NULL OR effective_from <= CURDATE()) " +
            "AND (effective_to IS NULL OR effective_to >= CURDATE())")
    boolean hasEffectiveQuota(@Param("tenantId") String tenantId);
}