package com.wework.platform.monitor.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.monitor.dto.CreateMetricRequest;
import com.wework.platform.monitor.dto.SystemMetricDTO;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 系统指标服务接口
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface SystemMetricService {

    /**
     * 添加系统指标
     *
     * @param tenantId 租户ID
     * @param request 指标请求
     * @return 指标信息
     */
    Result<SystemMetricDTO> addMetric(String tenantId, CreateMetricRequest request);

    /**
     * 批量添加系统指标
     *
     * @param tenantId 租户ID
     * @param requests 指标请求列表
     * @return 成功添加的数量
     */
    Result<Integer> batchAddMetrics(String tenantId, List<CreateMetricRequest> requests);

    /**
     * 获取系统指标详情
     *
     * @param tenantId 租户ID
     * @param metricId 指标ID
     * @return 指标信息
     */
    Result<SystemMetricDTO> getMetricById(String tenantId, String metricId);

    /**
     * 分页查询系统指标
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param metricName 指标名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    Result<PageResult<SystemMetricDTO>> getMetrics(String tenantId, String serviceName, 
                                                  String metricName, LocalDateTime startTime, 
                                                  LocalDateTime endTime, Integer pageNum, Integer pageSize);

    /**
     * 获取最新指标
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param metricName 指标名称
     * @param limit 限制数量
     * @return 指标列表
     */
    Result<List<SystemMetricDTO>> getLatestMetrics(String tenantId, String serviceName, 
                                                  String metricName, Integer limit);

    /**
     * 获取服务的所有指标名称
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @return 指标名称列表
     */
    Result<List<String>> getMetricNamesByService(String tenantId, String serviceName);

    /**
     * 获取租户的所有服务名称
     *
     * @param tenantId 租户ID
     * @return 服务名称列表
     */
    Result<List<String>> getServiceNamesByTenant(String tenantId);

    /**
     * 删除系统指标
     *
     * @param tenantId 租户ID
     * @param metricId 指标ID
     * @return 操作结果
     */
    Result<Void> deleteMetric(String tenantId, String metricId);

    /**
     * 清理过期指标数据
     *
     * @param retentionDays 保留天数
     * @return 清理数量
     */
    Result<Integer> cleanupExpiredMetrics(Integer retentionDays);

    /**
     * 获取指标统计信息
     *
     * @param tenantId 租户ID
     * @param serviceName 服务名称
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    Result<Long> getMetricCount(String tenantId, String serviceName, 
                               LocalDateTime startTime, LocalDateTime endTime);
}