package com.wework.platform.monitor.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.monitor.dto.AlertDTO;
import com.wework.platform.monitor.entity.Alert;
import com.wework.platform.monitor.repository.AlertRepository;
import com.wework.platform.monitor.service.AlertService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 告警服务实现
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AlertServiceImpl implements AlertService {

    private final AlertRepository alertRepository;
    private final ApplicationEventPublisher eventPublisher;

    @Override
    public Result<AlertDTO> getAlertById(String tenantId, String alertId) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            AlertDTO dto = convertToDTO(alertOpt.get());
            return Result.success(dto);

        } catch (Exception e) {
            log.error("获取告警记录失败, tenantId={}, alertId={}", tenantId, alertId, e);
            return Result.error("获取告警记录失败");
        }
    }

    @Override
    public Result<PageResult<AlertDTO>> getAlerts(String tenantId, String ruleId, AlertLevel alertLevel,
                                                 AlertStatus status, String serviceName,
                                                 LocalDateTime startTime, LocalDateTime endTime,
                                                 Integer pageNum, Integer pageSize) {
        try {
            Page<Alert> page = new Page<>(pageNum, pageSize);
            IPage<Alert> result = alertRepository.selectPageByConditions(
                    page, tenantId, ruleId, alertLevel, status, serviceName, startTime, endTime);

            List<AlertDTO> records = result.getRecords().stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            PageResult<AlertDTO> pageResult = new PageResult<>();
            pageResult.setRecords(records);
            pageResult.setTotal(result.getTotal());
            pageResult.setPageNum(pageNum);
            pageResult.setPageSize(pageSize);
            pageResult.setPages((int) Math.ceil((double) result.getTotal() / pageSize));

            return Result.success(pageResult);

        } catch (Exception e) {
            log.error("分页查询告警记录失败, tenantId={}", tenantId, e);
            return Result.error("分页查询告警记录失败");
        }
    }

    @Override
    public Result<List<AlertDTO>> getActiveAlerts(String tenantId) {
        try {
            List<Alert> alerts = alertRepository.selectActiveAlerts(tenantId);
            List<AlertDTO> dtos = alerts.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            return Result.success(dtos);

        } catch (Exception e) {
            log.error("获取活跃告警失败, tenantId={}", tenantId, e);
            return Result.error("获取活跃告警失败");
        }
    }

    @Override
    public Result<List<AlertDTO>> getUnacknowledgedAlerts(String tenantId) {
        try {
            List<Alert> alerts = alertRepository.selectUnacknowledgedAlerts(tenantId);
            List<AlertDTO> dtos = alerts.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

            return Result.success(dtos);

        } catch (Exception e) {
            log.error("获取未确认告警失败, tenantId={}", tenantId, e);
            return Result.error("获取未确认告警失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> acknowledgeAlert(String tenantId, String alertId, String acknowledgedBy) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            Alert alert = alertOpt.get();
            alert.setAcknowledged(true);
            alert.setAcknowledgedBy(acknowledgedBy);
            alert.setAcknowledgedAt(LocalDateTime.now());

            alertRepository.updateById(alert);

            log.info("确认告警成功, tenantId={}, alertId={}, acknowledgedBy={}", 
                    tenantId, alertId, acknowledgedBy);

            return Result.success();

        } catch (Exception e) {
            log.error("确认告警失败, tenantId={}, alertId={}, acknowledgedBy={}", 
                    tenantId, alertId, acknowledgedBy, e);
            return Result.error("确认告警失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> batchAcknowledgeAlerts(String tenantId, List<String> alertIds, String acknowledgedBy) {
        if (CollectionUtils.isEmpty(alertIds)) {
            return Result.success();
        }

        try {
            for (String alertId : alertIds) {
                Result<Void> result = acknowledgeAlert(tenantId, alertId, acknowledgedBy);
                if (!result.isSuccess()) {
                    return result;
                }
            }

            return Result.success();

        } catch (Exception e) {
            log.error("批量确认告警失败, tenantId={}, alertIds={}, acknowledgedBy={}", 
                    tenantId, alertIds, acknowledgedBy, e);
            return Result.error("批量确认告警失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> resolveAlert(String tenantId, String alertId) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            Alert alert = alertOpt.get();
            alert.setStatus(AlertStatus.RESOLVED);
            alert.setResolvedAt(LocalDateTime.now());

            alertRepository.updateById(alert);

            return Result.success();

        } catch (Exception e) {
            log.error("解决告警失败, tenantId={}, alertId={}", tenantId, alertId, e);
            return Result.error("解决告警失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> suppressAlert(String tenantId, String alertId) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            Alert alert = alertOpt.get();
            alert.setStatus(AlertStatus.SUPPRESSED);

            alertRepository.updateById(alert);

            return Result.success();

        } catch (Exception e) {
            log.error("抑制告警失败, tenantId={}, alertId={}", tenantId, alertId, e);
            return Result.error("抑制告警失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> deleteAlert(String tenantId, String alertId) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            alertRepository.deleteById(alertId);
            return Result.success();

        } catch (Exception e) {
            log.error("删除告警记录失败, tenantId={}, alertId={}", tenantId, alertId, e);
            return Result.error("删除告警记录失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Void> batchDeleteAlerts(String tenantId, List<String> alertIds) {
        if (CollectionUtils.isEmpty(alertIds)) {
            return Result.success();
        }

        try {
            for (String alertId : alertIds) {
                Result<Void> result = deleteAlert(tenantId, alertId);
                if (!result.isSuccess()) {
                    return result;
                }
            }

            return Result.success();

        } catch (Exception e) {
            log.error("批量删除告警记录失败, tenantId={}, alertIds={}", tenantId, alertIds, e);
            return Result.error("批量删除告警记录失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Integer> cleanupExpiredAlerts(Integer retentionDays) {
        try {
            LocalDateTime beforeTime = LocalDateTime.now().minusDays(retentionDays);
            int deletedCount = alertRepository.deleteExpiredAlerts(beforeTime);

            log.info("清理过期告警记录完成, 删除数量: {}, 保留天数: {}", deletedCount, retentionDays);
            return Result.success(deletedCount);

        } catch (Exception e) {
            log.error("清理过期告警记录失败, 保留天数: {}", retentionDays, e);
            return Result.error("清理过期告警记录失败");
        }
    }

    @Override
    public Result<Long> getAlertCount(String tenantId, AlertStatus status, AlertLevel alertLevel,
                                     LocalDateTime startTime, LocalDateTime endTime) {
        try {
            Long count = alertRepository.countByConditions(tenantId, status, alertLevel, startTime, endTime);
            return Result.success(count);

        } catch (Exception e) {
            log.error("获取告警统计失败, tenantId={}, status={}, alertLevel={}", 
                    tenantId, status, alertLevel, e);
            return Result.error("获取告警统计失败");
        }
    }

    @Override
    public Result<Void> sendNotification(String alertId) {
        try {
            // TODO: 实现通知发送逻辑
            // 1. 获取告警详情
            // 2. 获取通知渠道配置
            // 3. 发送通知（邮件、短信、钉钉、企微等）

            log.info("发送告警通知, alertId={}", alertId);
            return Result.success();

        } catch (Exception e) {
            log.error("发送告警通知失败, alertId={}", alertId, e);
            return Result.error("发送告警通知失败");
        }
    }

    @Override
    public Result<Void> resendNotification(String tenantId, String alertId) {
        try {
            Optional<Alert> alertOpt = Optional.ofNullable(alertRepository.selectById(alertId));
            if (!alertOpt.isPresent() || !tenantId.equals(alertOpt.get().getTenantId())) {
                return Result.error("告警记录不存在");
            }

            return sendNotification(alertId);

        } catch (Exception e) {
            log.error("重新发送告警通知失败, tenantId={}, alertId={}", tenantId, alertId, e);
            return Result.error("重新发送告警通知失败");
        }
    }

    private AlertDTO convertToDTO(Alert alert) {
        AlertDTO dto = new AlertDTO();
        BeanUtils.copyProperties(alert, dto);
        return dto;
    }
}