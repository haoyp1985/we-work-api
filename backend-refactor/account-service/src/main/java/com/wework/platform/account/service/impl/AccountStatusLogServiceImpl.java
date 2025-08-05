package com.wework.platform.account.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.account.dto.AccountStatusLogDTO;
import com.wework.platform.account.entity.AccountStatusLog;
import com.wework.platform.account.repository.AccountStatusLogRepository;
import com.wework.platform.account.service.AccountStatusLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 账号状态日志服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AccountStatusLogServiceImpl implements AccountStatusLogService {

    private final AccountStatusLogRepository statusLogRepository;

    @Override
    public PageResult<AccountStatusLogDTO> getStatusLogList(String tenantId, String accountId, Integer fromStatus, 
                                                           Integer toStatus, Integer pageNum, Integer pageSize) {
        Page<AccountStatusLog> page = new Page<>(pageNum, pageSize);
        
        LambdaQueryWrapper<AccountStatusLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AccountStatusLog::getTenantId, tenantId);
        
        if (StringUtils.hasText(accountId)) {
            wrapper.eq(AccountStatusLog::getAccountId, accountId);
        }
        
        if (fromStatus != null) {
            wrapper.eq(AccountStatusLog::getOldStatus, fromStatus);
        }
        
        if (toStatus != null) {
            wrapper.eq(AccountStatusLog::getNewStatus, toStatus);
        }
        
        wrapper.orderByDesc(AccountStatusLog::getCreatedAt);
        
        IPage<AccountStatusLog> result = statusLogRepository.selectPage(page, wrapper);
        
        List<AccountStatusLogDTO> dtoList = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return PageResult.of(dtoList, result.getTotal(), pageNum.longValue(), pageSize.longValue());
    }

    @Override
    public List<AccountStatusLogDTO> getStatusLogsByAccountId(String accountId, Integer limit) {
        LambdaQueryWrapper<AccountStatusLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AccountStatusLog::getAccountId, accountId)
                .orderByDesc(AccountStatusLog::getCreatedAt)
                .last("LIMIT " + limit);
        
        List<AccountStatusLog> logs = statusLogRepository.selectList(wrapper);
        return logs.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    public AccountStatusLogDTO getStatusLogById(String logId) {
        AccountStatusLog log = statusLogRepository.selectById(logId);
        if (log == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "状态日志不存在");
        }
        return convertToDTO(log);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String recordStatusChange(String accountId, Integer fromStatus, Integer toStatus, 
                                   String changeReason, String operatorId) {
        AccountStatusLog statusLog = new AccountStatusLog();
        statusLog.setId(UUID.randomUUID().toString());
        statusLog.setAccountId(accountId);
        statusLog.setOldStatus(fromStatus);
        statusLog.setNewStatus(toStatus);
        statusLog.setReason(changeReason);
        statusLog.setOperatorId(operatorId);
        statusLog.setCreatedAt(LocalDateTime.now());
        
        statusLogRepository.insert(statusLog);
        
        log.info("记录账号状态变更日志, accountId: {}, {}->{}，原因: {}", 
                accountId, fromStatus, toStatus, changeReason);
        
        return statusLog.getId();
    }

    @Override
    public StatusChangeStatistics getStatusChangeStatistics(String tenantId, String accountId, 
                                                           Long startTime, Long endTime) {
        return statusLogRepository.getStatusChangeStatistics(tenantId, accountId, startTime, endTime);
    }

    @Override
    public List<StatusTrend> getStatusTrends(String tenantId, String accountId, Long startTime, 
                                           Long endTime, String interval) {
        return statusLogRepository.getStatusTrends(tenantId, accountId, startTime, endTime, interval);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cleanupOldLogs(String tenantId, Integer keepDays) {
        LocalDateTime cutoffTime = LocalDateTime.now().minusDays(keepDays);
        
        LambdaQueryWrapper<AccountStatusLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AccountStatusLog::getTenantId, tenantId)
                .lt(AccountStatusLog::getCreatedAt, cutoffTime);
        
        int deletedCount = statusLogRepository.delete(wrapper);
        
        log.info("清理租户历史状态日志, tenantId: {}, keepDays: {}, deletedCount: {}", 
                tenantId, keepDays, deletedCount);
        
        return deletedCount;
    }

    /**
     * 实体转DTO
     */
    private AccountStatusLogDTO convertToDTO(AccountStatusLog entity) {
        if (entity == null) {
            return null;
        }
        
        AccountStatusLogDTO dto = new AccountStatusLogDTO();
        BeanUtils.copyProperties(entity, dto);
        
        // 时间字段已经通过BeanUtils.copyProperties自动复制
        
        return dto;
    }

    /**
     * DTO转实体
     */
    private AccountStatusLog convertToEntity(AccountStatusLogDTO dto) {
        if (dto == null) {
            return null;
        }
        
        AccountStatusLog entity = new AccountStatusLog();
        BeanUtils.copyProperties(dto, entity);
        
        // 时间字段已经通过BeanUtils.copyProperties自动复制
        
        return entity;
    }
}