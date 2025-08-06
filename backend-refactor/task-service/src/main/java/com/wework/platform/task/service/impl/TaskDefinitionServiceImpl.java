package com.wework.platform.task.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageQuery;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.exception.ResourceNotFoundException;
import com.wework.platform.common.enums.ErrorCode;
import com.wework.platform.common.enums.TaskStatus;
import com.wework.platform.common.utils.BeanCopyUtils;
import com.wework.platform.task.dto.CreateTaskDefinitionRequest;
import com.wework.platform.task.dto.TaskDefinitionDTO;
import com.wework.platform.task.dto.UpdateTaskDefinitionRequest;
import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.repository.TaskDefinitionRepository;
import com.wework.platform.task.service.TaskDefinitionService;
import com.wework.platform.task.service.TaskSchedulingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 任务定义服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TaskDefinitionServiceImpl implements TaskDefinitionService {

    private final TaskDefinitionRepository taskDefinitionRepository;
    private final TaskSchedulingService taskSchedulingService;

    @Override
    @Transactional
    public TaskDefinitionDTO createTaskDefinition(String tenantId, CreateTaskDefinitionRequest request) {
        // 验证任务名称唯一性
        if (existsByName(tenantId, request.getTaskName())) {
            throw new BusinessException(Integer.parseInt(ErrorCode.BUSINESS_ERROR.getCode()), "任务名称已存在");
        }

        // 验证Cron表达式
        if ("CRON".equals(request.getScheduleType()) && !isValidCronExpression(request.getCronExpression())) {
            throw new BusinessException(Integer.parseInt(ErrorCode.PARAM_ERROR.getCode()), "Cron表达式格式不正确");
        }

        TaskDefinition taskDefinition = new TaskDefinition();
        BeanCopyUtils.copyProperties(request, taskDefinition);
        taskDefinition.setTenantId(tenantId);
        taskDefinition.setStatus(TaskStatus.ENABLED);
        taskDefinition.setCreatedAt(LocalDateTime.now());
        taskDefinition.setUpdatedAt(LocalDateTime.now());

        taskDefinitionRepository.insert(taskDefinition);

        // 如果任务启用，添加到调度器
        if ("ENABLED".equals(taskDefinition.getStatus())) {
            taskSchedulingService.scheduleTask(taskDefinition);
        }

        log.info("创建任务定义成功: tenantId={}, taskName={}, taskId={}", 
                tenantId, request.getTaskName(), taskDefinition.getId());

        return convertToDTO(taskDefinition);
    }

    @Override
    public TaskDefinitionDTO getTaskDefinition(String tenantId, String taskDefinitionId) {
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, taskDefinitionId);
        return convertToDTO(taskDefinition);
    }

    @Override
    public PageResult<TaskDefinitionDTO> getTaskDefinitions(String tenantId, String taskName, 
                                                           String status, PageQuery pageQuery) {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .like(StringUtils.hasText(taskName), TaskDefinition::getTaskName, taskName)
                   .eq(StringUtils.hasText(status), TaskDefinition::getStatus, status)
                   .orderByDesc(TaskDefinition::getCreatedAt);

        IPage<TaskDefinition> page = new Page<>(pageQuery.getPageNum(), pageQuery.getPageSize());
        IPage<TaskDefinition> result = taskDefinitionRepository.selectPage(page, queryWrapper);

        List<TaskDefinitionDTO> records = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return PageResult.of(records, result.getTotal(), pageQuery.getPageNum(), pageQuery.getPageSize());
    }

    @Override
    @Transactional
    public TaskDefinitionDTO updateTaskDefinition(String tenantId, String taskDefinitionId, 
                                                 UpdateTaskDefinitionRequest request) {
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, taskDefinitionId);

        // 检查任务名称唯一性（排除当前任务）
        if (StringUtils.hasText(request.getTaskName()) && 
            !request.getTaskName().equals(taskDefinition.getTaskName()) &&
            existsByName(tenantId, request.getTaskName())) {
            throw new BusinessException(Integer.parseInt(ErrorCode.BUSINESS_ERROR.getCode()), "任务名称已存在");
        }

        // 验证Cron表达式
        if ("CRON".equals(request.getScheduleType()) && 
            StringUtils.hasText(request.getCronExpression()) &&
            !isValidCronExpression(request.getCronExpression())) {
            throw new BusinessException(Integer.parseInt(ErrorCode.PARAM_ERROR.getCode()), "Cron表达式格式不正确");
        }

        // 保存原状态用于判断是否需要重新调度
        String originalStatus = taskDefinition.getStatus();
        
        // 更新字段
        if (StringUtils.hasText(request.getTaskName())) {
            taskDefinition.setTaskName(request.getTaskName());
        }
        if (StringUtils.hasText(request.getDescription())) {
            taskDefinition.setDescription(request.getDescription());
        }
        if (StringUtils.hasText(request.getHandlerName())) {
            taskDefinition.setHandlerName(request.getHandlerName());
        }
        if (StringUtils.hasText(request.getScheduleType())) {
            taskDefinition.setScheduleType(request.getScheduleType());
        }
        if (StringUtils.hasText(request.getCronExpression())) {
            taskDefinition.setCronExpression(request.getCronExpression());
        }
        if (request.getFixedInterval() != null) {
            taskDefinition.setFixedInterval(request.getFixedInterval());
        }
        if (StringUtils.hasText(request.getExecutionParams())) {
            taskDefinition.setExecutionParams(request.getExecutionParams());
        }
        if (request.getTimeout() != null) {
            taskDefinition.setTimeout(request.getTimeout());
        }
        if (request.getMaxRetryCount() != null) {
            taskDefinition.setMaxRetryCount(request.getMaxRetryCount());
        }
        if (StringUtils.hasText(request.getStatus())) {
            taskDefinition.setStatus(TaskStatus.fromCode(request.getStatus()));
        }

        taskDefinition.setUpdatedAt(LocalDateTime.now());
        taskDefinitionRepository.updateById(taskDefinition);

        // 处理调度状态变化
        handleSchedulingStateChange(taskDefinition, originalStatus);

        log.info("更新任务定义成功: tenantId={}, taskId={}", tenantId, taskDefinitionId);

        return convertToDTO(taskDefinition);
    }

    @Override
    @Transactional
    public boolean deleteTaskDefinition(String tenantId, String taskDefinitionId) {
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, taskDefinitionId);

        // 从调度器中移除
        taskSchedulingService.unscheduleTask(taskDefinitionId);

        // 软删除
        taskDefinition.setDeletedAt(LocalDateTime.now());
        taskDefinitionRepository.updateById(taskDefinition);

        log.info("删除任务定义成功: tenantId={}, taskId={}", tenantId, taskDefinitionId);

        return true;
    }

    @Override
    @Transactional
    public boolean enableTaskDefinition(String tenantId, String taskDefinitionId) {
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, taskDefinitionId);
        
        if ("ENABLED".equals(taskDefinition.getStatus())) {
            return true; // 已经启用
        }

        taskDefinition.setStatus(TaskStatus.ENABLED);
        taskDefinition.setUpdatedAt(LocalDateTime.now());
        taskDefinitionRepository.updateById(taskDefinition);

        // 添加到调度器
        taskSchedulingService.scheduleTask(taskDefinition);

        log.info("启用任务定义成功: tenantId={}, taskId={}", tenantId, taskDefinitionId);

        return true;
    }

    @Override
    @Transactional
    public boolean disableTaskDefinition(String tenantId, String taskDefinitionId) {
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, taskDefinitionId);
        
        if ("DISABLED".equals(taskDefinition.getStatus())) {
            return true; // 已经禁用
        }

        taskDefinition.setStatus(TaskStatus.DISABLED);
        taskDefinition.setUpdatedAt(LocalDateTime.now());
        taskDefinitionRepository.updateById(taskDefinition);

        // 从调度器中移除
        taskSchedulingService.unscheduleTask(taskDefinitionId);

        log.info("禁用任务定义成功: tenantId={}, taskId={}", tenantId, taskDefinitionId);

        return true;
    }

    @Override
    public boolean existsByName(String tenantId, String taskName) {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .eq(TaskDefinition::getTaskName, taskName);
        
        return taskDefinitionRepository.selectCount(queryWrapper) > 0;
    }

    @Override
    public List<TaskDefinition> getEnabledTaskDefinitions(String tenantId) {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .eq(TaskDefinition::getStatus, "ENABLED")
                   .orderByAsc(TaskDefinition::getTaskName);
        
        return taskDefinitionRepository.selectList(queryWrapper);
    }

    @Override
    public List<TaskDefinition> getAllEnabledTaskDefinitions() {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getStatus, "ENABLED")
                   .orderByAsc(TaskDefinition::getTenantId, TaskDefinition::getTaskName);
        
        return taskDefinitionRepository.selectList(queryWrapper);
    }

    @Override
    public boolean validateTaskDefinition(CreateTaskDefinitionRequest request) {
        // 验证调度类型和相关参数
        switch (request.getScheduleType()) {
            case "CRON":
                return StringUtils.hasText(request.getCronExpression()) && 
                       isValidCronExpression(request.getCronExpression());
            case "FIXED_INTERVAL":
                return request.getFixedInterval() != null && request.getFixedInterval() > 0;
            case "ONE_TIME":
                return true; // 一次性任务无需额外验证
            default:
                return false;
        }
    }

    /**
     * 获取任务定义实体（包含权限验证）
     */
    private TaskDefinition getTaskDefinitionEntity(String tenantId, String taskDefinitionId) {
        TaskDefinition taskDefinition = taskDefinitionRepository.selectById(taskDefinitionId);
        if (taskDefinition == null || taskDefinition.getDeletedAt() != null) {
            throw new BusinessException(Integer.parseInt(ErrorCode.NOT_FOUND.getCode()), "任务定义不存在");
        }
        if (!tenantId.equals(taskDefinition.getTenantId())) {
            throw new BusinessException(Integer.parseInt(ErrorCode.FORBIDDEN.getCode()), "无权限访问该任务定义");
        }
        return taskDefinition;
    }

    /**
     * 转换为DTO
     */
    private TaskDefinitionDTO convertToDTO(TaskDefinition taskDefinition) {
        TaskDefinitionDTO dto = new TaskDefinitionDTO();
        BeanCopyUtils.copyProperties(taskDefinition, dto);
        return dto;
    }

    /**
     * 处理调度状态变化
     */
    private void handleSchedulingStateChange(TaskDefinition taskDefinition, String originalStatus) {
        String currentStatus = taskDefinition.getStatus().getCode();
        
        if ("ENABLED".equals(currentStatus) && !"ENABLED".equals(originalStatus)) {
            // 从禁用变为启用，添加到调度器
            taskSchedulingService.scheduleTask(taskDefinition);
        } else if (!"ENABLED".equals(currentStatus) && "ENABLED".equals(originalStatus)) {
            // 从启用变为禁用，从调度器移除
            taskSchedulingService.unscheduleTask(taskDefinition.getId());
        } else if ("ENABLED".equals(currentStatus) && "ENABLED".equals(originalStatus)) {
            // 都是启用状态，重新调度（可能调度参数有变化）
            taskSchedulingService.rescheduleTask(taskDefinition);
        }
    }

    /**
     * 验证Cron表达式
     */
    private boolean isValidCronExpression(String cronExpression) {
        try {
            // 使用Spring的CronExpression进行验证
            org.springframework.scheduling.support.CronExpression.parse(cronExpression);
            return true;
        } catch (Exception e) {
            log.debug("无效的Cron表达式: {}", cronExpression, e);
            return false;
        }
    }
}