package com.wework.platform.monitor.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.monitor.dto.CreateMetricRequest;
import com.wework.platform.monitor.dto.SystemMetricDTO;
import com.wework.platform.monitor.entity.SystemMetric;
import com.wework.platform.monitor.repository.SystemMetricRepository;
import com.wework.platform.monitor.service.SystemMetricService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 系统指标服务实现
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SystemMetricServiceImpl implements SystemMetricService {

    private final SystemMetricRepository systemMetricRepository;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<SystemMetricDTO> addMetric(String tenantId, CreateMetricRequest request) {
        try {
            SystemMetric metric = new SystemMetric();
            BeanUtils.copyProperties(request, metric);
            metric.setTenantId(tenantId);
            metric.setCollectedAt(LocalDateTime.now());

            systemMetricRepository.insert(metric);

            SystemMetricDTO dto = convertToDTO(metric);
            return Result.success(dto);

        } catch (Exception e) {
            log.error("添加系统指标失败, tenantId={}, request={}", tenantId, request, e);
            return Result.error("添加系统指标失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Integer> batchAddMetrics(String tenantId, List<CreateMetricRequest> requests) {
        if (CollectionUtils.isEmpty(requests)) {
            return Result.success(0);
        }

        try {
            List<SystemMetric> metrics = requests.stream()
                    .map(request -> {
                        SystemMetric metric = new SystemMetric();
                        BeanUtils.copyProperties(request, metric);
                        metric.setTenantId(tenantId);
                        metric.setCollectedAt(LocalDateTime.now());
                        return metric;
                    })
                    .collect(Collectors.toList());

            // 分批插入，避免单次插入过多数据
            int batchSize = 100;
            int successCount = 0;
            for (int i = 0; i < metrics.size(); i += batchSize) {
                int end = Math.min(i + batchSize, metrics.size());
                List<SystemMetric> batch = metrics.subList(i, end);
                
                for (SystemMetric metric : batch) {
                    systemMetricRepository.insert(metric);
                    successCount++;
                }
            }

            return Result.success(successCount);

        } catch (Exception e) {
            log.error("批量添加系统指标失败, tenantId={}, count={}", tenantId, requests.size(), e);
            return Result.error("批量添加系统指标失败");
        }
    }

    @Override
    public Result<SystemMetricDTO> getMetricById(String tenantId, String metricId) {
        try {
            Optional<SystemMetric> metricOpt = Optional.ofNullable(
                    systemMetricRepository.selectById(metricId));

            if (!metricOpt.isPresent() || !tenantId.equals(metricOpt.get().getTenantId())) {
                return Result.error("系统指标不存在");
            }

            SystemMetricDTO dto = convertToDTO(metricOpt.get());
            return Result.success(dto);

        } catch (Exception e) {
            log.error("获取系统指标失败, tenantId={}, metricId={}", tenantId, metricId, e);
            return Result.error("获取系统指标失败");
        }
    }

    @Override
    public Result<PageResult<SystemMetricDTO>> getMetrics(String tenantId, String serviceName,
                                                         String metricName, LocalDateTime startTime,
                                                         LocalDateTime endTime, Integer pageNum, Integer pageSize) {
        try {
            Page<SystemMetric> page = new Page<>(pageNum, pageSize);
            IPage<SystemMetric> result = systemMetricRepository.selectPageByConditions(
                    page, tenantId, serviceName, metricName, startTime, endTime);

            List<SystemMetricDTO> records = result.getRecords().stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            PageResult<SystemMetricDTO> pageResult = new PageResult<>();
            pageResult.setRecords(records);
            pageResult.setTotal(result.getTotal());
            pageResult.setPageNum(pageNum);
            pageResult.setPageSize(pageSize);
            pageResult.setPages((int) Math.ceil((double) result.getTotal() / pageSize));

            return Result.success(pageResult);

        } catch (Exception e) {
            log.error("分页查询系统指标失败, tenantId={}", tenantId, e);
            return Result.error("分页查询系统指标失败");
        }
    }

    @Override
    public Result<List<SystemMetricDTO>> getLatestMetrics(String tenantId, String serviceName,
                                                         String metricName, Integer limit) {
        try {
            List<SystemMetric> metrics = systemMetricRepository.selectLatestMetrics(
                    tenantId, serviceName, metricName, limit);

            List<SystemMetricDTO> dtos = metrics.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            return Result.success(dtos);

        } catch (Exception e) {
            log.error("获取最新指标失败, tenantId={}, serviceName={}, metricName={}",
                    tenantId, serviceName, metricName, e);
            return Result.error("获取最新指标失败");
        }
    }

    @Override
    public Result<List<String>> getMetricNamesByService(String tenantId, String serviceName) {
        try {
            List<String> metricNames = systemMetricRepository.selectMetricNamesByService(tenantId, serviceName);
            return Result.success(metricNames);

        } catch (Exception e) {
            log.error("获取服务指标名称失败, tenantId={}, serviceName={}", tenantId, serviceName, e);
            return Result.error("获取服务指标名称失败");
        }
    }

    @Override
    public Result<List<String>> getServiceNamesByTenant(String tenantId) {
        try {
            List<String> serviceNames = systemMetricRepository.selectServiceNamesByTenant(tenantId);
            return Result.success(serviceNames);

        } catch (Exception e) {
            log.error("获取租户服务名称失败, tenantId={}", tenantId, e);
            return Result.error("获取租户服务名称失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> deleteMetric(String tenantId, String metricId) {
        try {
            Optional<SystemMetric> metricOpt = Optional.ofNullable(
                    systemMetricRepository.selectById(metricId));

            if (!metricOpt.isPresent() || !tenantId.equals(metricOpt.get().getTenantId())) {
                return Result.error("系统指标不存在");
            }

            systemMetricRepository.deleteById(metricId);
            return Result.success();

        } catch (Exception e) {
            log.error("删除系统指标失败, tenantId={}, metricId={}", tenantId, metricId, e);
            return Result.error("删除系统指标失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Integer> cleanupExpiredMetrics(Integer retentionDays) {
        try {
            LocalDateTime beforeTime = LocalDateTime.now().minusDays(retentionDays);
            int deletedCount = systemMetricRepository.deleteExpiredMetrics(beforeTime);

            log.info("清理过期指标数据完成, 删除数量: {}, 保留天数: {}", deletedCount, retentionDays);
            return Result.success(deletedCount);

        } catch (Exception e) {
            log.error("清理过期指标数据失败, 保留天数: {}", retentionDays, e);
            return Result.error("清理过期指标数据失败");
        }
    }

    @Override
    public Result<Long> getMetricCount(String tenantId, String serviceName,
                                      LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Long count = systemMetricRepository.countByConditions(tenantId, serviceName, startTime, endTime);
            return Result.success(count);

        } catch (Exception e) {
            log.error("获取指标统计失败, tenantId={}, serviceName={}", tenantId, serviceName, e);
            return Result.error("获取指标统计失败");
        }
    }

    private SystemMetricDTO convertToDTO(SystemMetric metric) {
        SystemMetricDTO dto = new SystemMetricDTO();
        BeanUtils.copyProperties(metric, dto);
        return dto;
    }
}