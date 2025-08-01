package com.wework.platform.account.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.wework.platform.common.entity.AccountMonitorRule;
import com.wework.platform.common.enums.MonitorRuleType;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 账号监控规则Repository
 * 
 * @author WeWork Platform Team
 */
@Mapper
public interface AccountMonitorRuleRepository extends BaseMapper<AccountMonitorRule> {

    /**
     * 根据租户ID查询监控规则（按优先级排序）
     */
    @Select("SELECT * FROM account_monitor_rules WHERE tenant_id = #{tenantId} ORDER BY priority DESC, created_at ASC")
    List<AccountMonitorRule> findByTenantIdOrderByPriorityDesc(@Param("tenantId") String tenantId);

    /**
     * 根据租户ID和启用状态查询监控规则
     */
    @Select("SELECT * FROM account_monitor_rules WHERE tenant_id = #{tenantId} AND enabled = #{enabled} ORDER BY priority DESC")
    List<AccountMonitorRule> findByTenantIdAndEnabled(@Param("tenantId") String tenantId, @Param("enabled") Boolean enabled);

    /**
     * 根据规则类型查询监控规则
     */
    @Select("SELECT * FROM account_monitor_rules WHERE tenant_id = #{tenantId} AND rule_type = #{ruleType} ORDER BY priority DESC")
    List<AccountMonitorRule> findByTenantIdAndRuleType(@Param("tenantId") String tenantId, @Param("ruleType") MonitorRuleType ruleType);

    /**
     * 统计租户的监控规则数量
     */
    @Select("SELECT COUNT(*) FROM account_monitor_rules WHERE tenant_id = #{tenantId}")
    int countByTenantId(@Param("tenantId") String tenantId);

    /**
     * 统计启用的监控规则数量
     */
    @Select("SELECT COUNT(*) FROM account_monitor_rules WHERE tenant_id = #{tenantId} AND enabled = true")
    int countEnabledByTenantId(@Param("tenantId") String tenantId);
}