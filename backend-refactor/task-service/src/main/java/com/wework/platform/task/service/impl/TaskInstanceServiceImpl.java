package com.wework.platform.task.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageQuery;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.exception.BusinessException;
import com.wework.platform.common.exception.ErrorCode;
import com.wework.platform.common.utils.BeanCopyUtils;
import com.wework.platform.task.dto.TaskInstanceDTO;
import com.wework.platform.task.entity.TaskInstance;
import com.wework.platform.task.repository.TaskInstanceRepository;
import com.wework.platform.task.service.TaskInstanceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 任务实例服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TaskInstanceServiceImpl implements TaskInstanceService {

    private final TaskInstanceRepository taskInstanceRepository;

    @Override
    @Transactional
    public TaskInstance createTaskInstance(String tenantId, String taskDefinitionId, String executionParams) {
        TaskInstance taskInstance = new TaskInstance();
        taskInstance.setTenantId(tenantId);
        taskInstance.setTaskDefinitionId(taskDefinitionId);
        taskInstance.setExecutionStatus("PENDING");
        taskInstance.setExecutionParams(executionParams);
        taskInstance.setRetryCount(0);
        taskInstance.setMaxRetryCount(3); // 默认最大重试次数
        taskInstance.setCreatedAt(LocalDateTime.now());
        taskInstance.setUpdatedAt(LocalDateTime.now());

        taskInstanceRepository.insert(taskInstance);

        log.debug("创建任务实例成功: tenantId={}, taskDefinitionId={}, instanceId={}", 
                 tenantId, taskDefinitionId, taskInstance.getId());

        return taskInstance;
    }

    @Override
    public TaskInstanceDTO getTaskInstance(String tenantId, String instanceId) {
        TaskInstance taskInstance = getTaskInstanceEntity(tenantId, instanceId);
        return convertToDTO(taskInstance);
    }

    @Override
    public PageResult<TaskInstanceDTO> getTaskInstances(String tenantId, String taskDefinitionId, 
                                                       String status, PageQuery pageQuery) {
        LambdaQueryWrapper<TaskInstance> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskInstance::getTenantId, tenantId)
                   .eq(StringUtils.hasText(taskDefinitionId), TaskInstance::getTaskDefinitionId, taskDefinitionId)
                   .eq(StringUtils.hasText(status), TaskInstance::getExecutionStatus, status)
                   .orderByDesc(TaskInstance::getCreatedAt);

        IPage<TaskInstance> page = new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize());
        IPage<TaskInstance> result = taskInstanceRepository.selectPage(page, queryWrapper);

        List<TaskInstanceDTO> records = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return PageResult.of(records, result.getTotal(), pageQuery.getPageNum(), pageQuery.getPageSize());
    }

    @Override
    @Transactional
    public boolean updateTaskInstanceStatus(String instanceId, String status, String result, String errorMessage) {
        TaskInstance taskInstance = taskInstanceRepository.selectById(instanceId);
        if (taskInstance == null) {
            return false;
        }

        taskInstance.setExecutionStatus(status);
        if (StringUtils.hasText(result)) {
            taskInstance.setExecutionResult(result);
        }
        if (StringUtils.hasText(errorMessage)) {
            taskInstance.setErrorMessage(errorMessage);
        }
        taskInstance.setUpdatedAt(LocalDateTime.now());

        return taskInstanceRepository.updateById(taskInstance) > 0;
    }

    @Override
    @Transactional
    public boolean markTaskStart(String instanceId, String executionNode) {
        TaskInstance taskInstance = taskInstanceRepository.selectById(instanceId);
        if (taskInstance == null) {
            return false;
        }

        taskInstance.setExecutionStatus("RUNNING");
        taskInstance.setStartTime(LocalDateTime.now());
        taskInstance.setExecutionNode(executionNode);
        taskInstance.setUpdatedAt(LocalDateTime.now());

        return taskInstanceRepository.updateById(taskInstance) > 0;
    }

    @Override
    @Transactional
    public boolean markTaskComplete(String instanceId, String status, String result, 
                                  String errorMessage, String errorStack) {
        TaskInstance taskInstance = taskInstanceRepository.selectById(instanceId);
        if (taskInstance == null) {
            return false;
        }

        LocalDateTime endTime = LocalDateTime.now();
        taskInstance.setExecutionStatus(status);
        taskInstance.setEndTime(endTime);
        
        if (taskInstance.getStartTime() != null) {
            // 计算执行耗时
            long duration = java.time.Duration.between(taskInstance.getStartTime(), endTime).toMillis();
            taskInstance.setExecutionDuration(duration);
        }
        
        if (StringUtils.hasText(result)) {
            taskInstance.setExecutionResult(result);
        }
        if (StringUtils.hasText(errorMessage)) {
            taskInstance.setErrorMessage(errorMessage);
        }
        if (StringUtils.hasText(errorStack)) {
            taskInstance.setErrorStack(errorStack);
        }
        taskInstance.setUpdatedAt(LocalDateTime.now());

        return taskInstanceRepository.updateById(taskInstance) > 0;
    }

    @Override
    @Transactional
    public boolean incrementRetryCount(String instanceId, LocalDateTime nextRetryTime) {
        TaskInstance taskInstance = taskInstanceRepository.selectById(instanceId);
        if (taskInstance == null) {
            return false;
        }

        taskInstance.setRetryCount(taskInstance.getRetryCount() + 1);
        taskInstance.setNextRetryTime(nextRetryTime);
        taskInstance.setExecutionStatus("PENDING"); // 重置为待执行状态
        taskInstance.setUpdatedAt(LocalDateTime.now());

        return taskInstanceRepository.updateById(taskInstance) > 0;
    }

    @Override
    public List<TaskInstance> getPendingTaskInstances(int limit) {
        LambdaQueryWrapper<TaskInstance> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskInstance::getExecutionStatus, "PENDING")
                   .orderByAsc(TaskInstance::getCreatedAt)
                   .last("LIMIT " + limit);

        return taskInstanceRepository.selectList(queryWrapper);
    }

    @Override
    public List<TaskInstance> getRetryTaskInstances(int limit) {
        LambdaQueryWrapper<TaskInstance> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskInstance::getExecutionStatus, "PENDING")
                   .gt(TaskInstance::getRetryCount, 0)
                   .le(TaskInstance::getNextRetryTime, LocalDateTime.now())
                   .orderByAsc(TaskInstance::getNextRetryTime)
                   .last("LIMIT " + limit);

        return taskInstanceRepository.selectList(queryWrapper);
    }

    @Override
    @Transactional
    public int cleanExpiredInstances(LocalDateTime beforeTime) {
        LambdaQueryWrapper<TaskInstance> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(TaskInstance::getExecutionStatus, "SUCCESS", "FAILED", "CANCELLED")
                   .lt(TaskInstance::getUpdatedAt, beforeTime);

        List<TaskInstance> expiredInstances = taskInstanceRepository.selectList(queryWrapper);
        
        if (!expiredInstances.isEmpty()) {
            for (TaskInstance instance : expiredInstances) {
                instance.setDeletedAt(LocalDateTime.now());
                taskInstanceRepository.updateById(instance);
            }
            
            log.info("清理过期任务实例 {} 个", expiredInstances.size());
            return expiredInstances.size();
        }
        
        return 0;
    }

    @Override
    @Transactional
    public boolean cancelTaskInstance(String tenantId, String instanceId) {
        TaskInstance taskInstance = getTaskInstanceEntity(tenantId, instanceId);
        
        // 只能取消待执行或执行中的任务
        if (!"PENDING".equals(taskInstance.getExecutionStatus()) && 
            !"RUNNING".equals(taskInstance.getExecutionStatus())) {
            throw new BusinessException(ErrorCode.BUSINESS_ERROR, "该状态的任务实例不能取消");
        }

        taskInstance.setExecutionStatus("CANCELLED");
        taskInstance.setEndTime(LocalDateTime.now());
        taskInstance.setUpdatedAt(LocalDateTime.now());

        boolean result = taskInstanceRepository.updateById(taskInstance) > 0;
        
        if (result) {
            log.info("取消任务实例成功: tenantId={}, instanceId={}", tenantId, instanceId);
        }
        
        return result;
    }

    @Override
    public TaskInstanceStatistics getTaskInstanceStatistics(String tenantId, String taskDefinitionId, 
                                                          LocalDateTime startTime, LocalDateTime endTime) {
        LambdaQueryWrapper<TaskInstance> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskInstance::getTenantId, tenantId);
        
        if (StringUtils.hasText(taskDefinitionId)) {
            queryWrapper.eq(TaskInstance::getTaskDefinitionId, taskDefinitionId);
        }
        if (startTime != null) {
            queryWrapper.ge(TaskInstance::getCreatedAt, startTime);
        }
        if (endTime != null) {
            queryWrapper.le(TaskInstance::getCreatedAt, endTime);
        }

        List<TaskInstance> instances = taskInstanceRepository.selectList(queryWrapper);
        
        TaskInstanceStatistics statistics = new TaskInstanceStatistics();
        statistics.setTotalCount((long) instances.size());
        
        long successCount = instances.stream().mapToLong(i -> "SUCCESS".equals(i.getExecutionStatus()) ? 1 : 0).sum();
        long failedCount = instances.stream().mapToLong(i -> "FAILED".equals(i.getExecutionStatus()) ? 1 : 0).sum();
        long runningCount = instances.stream().mapToLong(i -> "RUNNING".equals(i.getExecutionStatus()) ? 1 : 0).sum();
        long pendingCount = instances.stream().mapToLong(i -> "PENDING".equals(i.getExecutionStatus()) ? 1 : 0).sum();
        
        statistics.setSuccessCount(successCount);
        statistics.setFailedCount(failedCount);
        statistics.setRunningCount(runningCount);
        statistics.setPendingCount(pendingCount);
        
        // 计算成功率
        if (statistics.getTotalCount() > 0) {
            statistics.setSuccessRate((double) successCount / statistics.getTotalCount() * 100);
        } else {
            statistics.setSuccessRate(0.0);
        }
        
        // 计算平均执行时间
        long avgExecutionTime = instances.stream()
                .filter(i -> i.getExecutionDuration() != null)
                .mapToLong(TaskInstance::getExecutionDuration)
                .sum();
        if (successCount > 0) {
            statistics.setAvgExecutionTime(avgExecutionTime / successCount);
        } else {
            statistics.setAvgExecutionTime(0L);
        }

        return statistics;
    }

    /**
     * 获取任务实例实体（包含权限验证）
     */
    private TaskInstance getTaskInstanceEntity(String tenantId, String instanceId) {
        TaskInstance taskInstance = taskInstanceRepository.selectById(instanceId);
        if (taskInstance == null || taskInstance.getDeletedAt() != null) {
            throw new BusinessException(ErrorCode.NOT_FOUND, "任务实例不存在");
        }
        if (!tenantId.equals(taskInstance.getTenantId())) {
            throw new BusinessException(ErrorCode.FORBIDDEN, "无权限访问该任务实例");
        }
        return taskInstance;
    }

    /**
     * 转换为DTO
     */
    private TaskInstanceDTO convertToDTO(TaskInstance taskInstance) {
        TaskInstanceDTO dto = new TaskInstanceDTO();
        BeanCopyUtils.copyProperties(taskInstance, dto);
        return dto;
    }
}