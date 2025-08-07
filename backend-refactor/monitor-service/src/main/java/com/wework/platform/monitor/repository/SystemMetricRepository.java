package com.wework.platform.monitor.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.monitor.entity.SystemMetric;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 系统指标Repository
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Mapper
public interface SystemMetricRepository extends BaseMapper<SystemMetric> {

    /**
     * 分页查询租户的系统指标
     *
     * @param page 分页参数
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param metricName 指标名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 分页结果
     */
        IPage<SystemMetric> selectPageByConditions(
            Page<SystemMetric> page,
            @Param("tenantId") String tenantId,
            @Param("serviceName") String serviceName,
            @Param("metricName") String metricName,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime
    );

    /**
     * 查询最新的系统指标
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param metricName 指标名称
     * @param limit 限制数量
     * @return 指标列表
     */
        List<SystemMetric> selectLatestMetrics(
            @Param("tenantId") String tenantId,
            @Param("serviceName") String serviceName,
            @Param("metricName") String metricName,
            @Param("limit") int limit
    );

    /**
     * 查询服务的所有指标名称
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @return 指标名称列表
     */
        List<String> selectMetricNamesByService(
            @Param("tenantId") String tenantId,
            @Param("serviceName") String serviceName
    );

    /**
     * 查询租户的所有服务名称
     *
     * @param tenantId 租户ID
     * @return 服务名称列表
     */
        List<String> selectServiceNamesByTenant(@Param("tenantId") String tenantId);

    /**
     * 删除过期的指标数据
     *
     * @param beforeTime 时间点
     * @return 删除数量
     */
        int deleteExpiredMetrics(@Param("beforeTime") LocalDateTime beforeTime);

    /**
     * 统计指标数量
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 数量
     */
        Long countByConditions(
            @Param("tenantId") String tenantId,
            @Param("serviceName") String serviceName,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime
    );
}