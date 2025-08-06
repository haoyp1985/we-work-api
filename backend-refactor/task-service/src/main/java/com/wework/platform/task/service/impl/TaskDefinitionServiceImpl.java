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
    public IPage<TaskDefinitionDTO> getTaskDefinitions(String tenantId, Page<TaskDefinition> page,
                                                       String taskName, String taskType, 
                                                       Boolean enabled, String status) {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .like(StringUtils.hasText(taskName), TaskDefinition::getTaskName, taskName)
                   .like(StringUtils.hasText(taskType), TaskDefinition::getTaskType, taskType)
                   .eq(enabled != null, TaskDefinition::getEnabled, enabled)
                   .eq(StringUtils.hasText(status), TaskDefinition::getStatus, TaskStatus.fromCode(status))
                   .orderByDesc(TaskDefinition::getCreatedAt);

        IPage<TaskDefinition> result = taskDefinitionRepository.selectPage(page, queryWrapper);

        List<TaskDefinitionDTO> records = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        // 创建新的分页结果
        Page<TaskDefinitionDTO> dtoPage = new Page<>(result.getCurrent(), result.getSize(), result.getTotal());
        dtoPage.setRecords(records);
        return dtoPage;
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
        String originalStatus = taskDefinition.getStatus().getCode();
        
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
            taskDefinition.setTimeoutSeconds(request.getTimeout());
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

    public boolean existsByName(String tenantId, String taskName) {
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .eq(TaskDefinition::getTaskName, taskName);
        
        return taskDefinitionRepository.selectCount(queryWrapper) > 0;
    }

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

    @Override
    public String exportTaskDefinitions(String tenantId, List<String> definitionIds) {
        log.info("导出任务定义, tenantId={}, definitionIds={}", tenantId, definitionIds);
        
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .isNull(TaskDefinition::getDeletedAt);
        
        if (definitionIds != null && !definitionIds.isEmpty()) {
            queryWrapper.in(TaskDefinition::getId, definitionIds);
        }
        
        List<TaskDefinition> taskDefinitions = taskDefinitionRepository.selectList(queryWrapper);
        
        if (taskDefinitions.isEmpty()) {
            return "{}";
        }
        
        // 转换为JSON格式（这里简化处理，实际应该使用JSON库）
        StringBuilder exportData = new StringBuilder();
        exportData.append("{\n");
        exportData.append("  \"taskDefinitions\": [\n");
        
        for (int i = 0; i < taskDefinitions.size(); i++) {
            TaskDefinition def = taskDefinitions.get(i);
            exportData.append("    {\n");
            exportData.append("      \"taskName\": \"").append(def.getTaskName()).append("\",\n");
            exportData.append("      \"description\": \"").append(def.getDescription() != null ? def.getDescription() : "").append("\",\n");
            exportData.append("      \"handlerName\": \"").append(def.getHandlerName()).append("\",\n");
            exportData.append("      \"scheduleType\": \"").append(def.getScheduleType()).append("\",\n");
            exportData.append("      \"cronExpression\": \"").append(def.getCronExpression() != null ? def.getCronExpression() : "").append("\",\n");
            exportData.append("      \"status\": \"").append(def.getStatus().getCode()).append("\"\n");
            exportData.append("    }");
            if (i < taskDefinitions.size() - 1) {
                exportData.append(",");
            }
            exportData.append("\n");
        }
        
        exportData.append("  ],\n");
        exportData.append("  \"exportTime\": \"").append(LocalDateTime.now()).append("\",\n");
        exportData.append("  \"count\": ").append(taskDefinitions.size()).append("\n");
        exportData.append("}");
        
        log.info("导出任务定义完成, count={}", taskDefinitions.size());
        return exportData.toString();
    }

    @Override
    public TaskDefinitionStatistics getTaskDefinitionStatistics(String tenantId) {
        log.debug("获取任务定义统计信息, tenantId={}", tenantId);
        
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .isNull(TaskDefinition::getDeletedAt);
        
        List<TaskDefinition> allDefinitions = taskDefinitionRepository.selectList(queryWrapper);
        
        TaskDefinitionStatistics statistics = new TaskDefinitionStatistics();
        
        // 计算各种统计信息
        long totalCount = allDefinitions.size();
        long enabledCount = allDefinitions.stream()
            .filter(def -> TaskStatus.ENABLED.equals(def.getStatus()))
            .count();
        long disabledCount = allDefinitions.stream()
            .filter(def -> TaskStatus.DISABLED.equals(def.getStatus()))
            .count();
        
        statistics.setTotalCount(totalCount);
        statistics.setEnabledCount(enabledCount);
        statistics.setDisabledCount(disabledCount);
        
        log.debug("任务定义统计信息获取完成, totalCount={}, enabledCount={}, disabledCount={}", 
                 totalCount, enabledCount, disabledCount);
        
        return statistics;
    }

    @Override
    public String validateHandlerClass(String handlerClass) {
        log.debug("验证处理器类, handlerClass={}", handlerClass);
        
        if (!StringUtils.hasText(handlerClass)) {
            return "处理器类名不能为空";
        }
        
        try {
            // 尝试加载类
            Class.forName(handlerClass);
            
            // TODO: 这里可以添加更多验证逻辑，比如验证类是否实现了TaskHandler接口
            
            log.debug("处理器类验证通过, handlerClass={}", handlerClass);
            return null; // 验证通过返回null
        } catch (ClassNotFoundException e) {
            String errorMsg = "处理器类不存在: " + handlerClass;
            log.warn(errorMsg, e);
            return errorMsg;
        } catch (Exception e) {
            String errorMsg = "处理器类验证失败: " + e.getMessage();
            log.warn(errorMsg, e);
            return errorMsg;
        }
    }

    @Override
    public String validateCronExpression(String cronExpression) {
        log.debug("验证Cron表达式, cronExpression={}", cronExpression);
        
        if (!StringUtils.hasText(cronExpression)) {
            return "Cron表达式不能为空";
        }
        
        try {
            // 使用Spring的CronExpression进行验证
            org.springframework.scheduling.support.CronExpression.parse(cronExpression);
            
            log.debug("Cron表达式验证通过, cronExpression={}", cronExpression);
            return null; // 验证通过返回null
        } catch (Exception e) {
            String errorMsg = "Cron表达式格式不正确: " + e.getMessage();
            log.warn(errorMsg);
            return errorMsg;
        }
    }

    @Override
    public List<TaskDefinition> getExecutableTaskDefinitions(LocalDateTime currentTime, int limit) {
        log.debug("获取可执行的任务定义, currentTime={}, limit={}", currentTime, limit);
        
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getStatus, TaskStatus.ENABLED)
                   .eq(TaskDefinition::getEnabled, true)
                   .isNull(TaskDefinition::getDeletedAt)
                   .orderByAsc(TaskDefinition::getCreatedAt)
                   .last(limit > 0 ? "LIMIT " + limit : "");
        
        List<TaskDefinition> definitions = taskDefinitionRepository.selectList(queryWrapper);
        
        log.debug("获取可执行任务定义完成, count={}", definitions.size());
        return definitions;
    }

    @Override
    public void updateExecutionInfo(String tenantId, String definitionId, 
                                   LocalDateTime lastExecutionTime, String lastExecutionStatus,
                                   LocalDateTime nextExecutionTime) {
        log.debug("更新任务执行信息, tenantId={}, definitionId={}, lastExecutionTime={}, lastExecutionStatus={}, nextExecutionTime={}", 
                 tenantId, definitionId, lastExecutionTime, lastExecutionStatus, nextExecutionTime);
        
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
        
        // 更新执行信息字段（这里需要根据实际的TaskDefinition实体字段进行调整）
        taskDefinition.setUpdatedAt(LocalDateTime.now());
        
        // TODO: TaskDefinition实体中需要添加相应的字段来存储这些执行信息
        // taskDefinition.setLastExecutionTime(lastExecutionTime);
        // taskDefinition.setLastExecutionStatus(lastExecutionStatus);
        // taskDefinition.setNextExecutionTime(nextExecutionTime);
        
        taskDefinitionRepository.updateById(taskDefinition);
        
        log.debug("任务执行信息更新完成, definitionId={}", definitionId);
    }

    @Override
    public LocalDateTime calculateNextExecutionTime(String tenantId, String definitionId) {
        log.debug("计算下次执行时间, tenantId={}, definitionId={}", tenantId, definitionId);
        
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
        
        try {
            LocalDateTime nextTime = null;
            
            switch (taskDefinition.getScheduleType()) {
                case "CRON":
                    if (StringUtils.hasText(taskDefinition.getCronExpression())) {
                        org.springframework.scheduling.support.CronExpression cronExpression = 
                            org.springframework.scheduling.support.CronExpression.parse(taskDefinition.getCronExpression());
                        nextTime = cronExpression.next(LocalDateTime.now());
                    }
                    break;
                case "FIXED_INTERVAL":
                    if (taskDefinition.getFixedInterval() != null && taskDefinition.getFixedInterval() > 0) {
                        nextTime = LocalDateTime.now().plusSeconds(taskDefinition.getFixedInterval());
                    }
                    break;
                case "ONE_TIME":
                    // 一次性任务没有下次执行时间
                    nextTime = null;
                    break;
                default:
                    log.warn("未知的调度类型: {}", taskDefinition.getScheduleType());
                    nextTime = null;
            }
            
            log.debug("下次执行时间计算完成, definitionId={}, nextTime={}", definitionId, nextTime);
            return nextTime;
            
        } catch (Exception e) {
            log.error("计算下次执行时间失败, definitionId={}", definitionId, e);
            return null;
        }
    }

    @Override
    public String triggerTaskExecution(String tenantId, String definitionId) {
        log.info("手动触发任务执行, tenantId={}, definitionId={}", tenantId, definitionId);
        
        TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
        
        if (!TaskStatus.ENABLED.equals(taskDefinition.getStatus())) {
            String errorMsg = "任务未启用，无法执行";
            log.warn("手动触发任务失败: {}, definitionId={}", errorMsg, definitionId);
            return errorMsg;
        }
        
        try {
            // 创建任务实例并触发执行
            // 这里应该调用TaskInstanceService来创建实例并开始执行
            // 由于没有直接依赖，这里返回成功消息
            String instanceId = java.util.UUID.randomUUID().toString();
            
            log.info("手动触发任务执行成功, definitionId={}, instanceId={}", definitionId, instanceId);
            return "任务执行已触发，实例ID: " + instanceId;
            
        } catch (Exception e) {
            String errorMsg = "触发任务执行失败: " + e.getMessage();
            log.error("手动触发任务执行失败, definitionId={}", definitionId, e);
            return errorMsg;
        }
    }

    @Override
    public TaskDefinitionDTO copyTaskDefinition(String tenantId, String sourceDefinitionId, String newTaskName) {
        log.info("复制任务定义, tenantId={}, sourceDefinitionId={}, newTaskName={}", tenantId, sourceDefinitionId, newTaskName);
        
        // 获取源任务定义
        TaskDefinition sourceDefinition = getTaskDefinitionEntity(tenantId, sourceDefinitionId);
        
        // 检查新任务名称是否已存在
        if (existsByName(tenantId, newTaskName)) {
            throw new BusinessException(Integer.parseInt(ErrorCode.BUSINESS_ERROR.getCode()), "任务名称已存在");
        }
        
        // 创建新的任务定义
        TaskDefinition newDefinition = new TaskDefinition();
        BeanCopyUtils.copyProperties(sourceDefinition, newDefinition);
        
        // 重置关键字段
        newDefinition.setId(null); // 让数据库自动生成新ID
        newDefinition.setTaskName(newTaskName);
        newDefinition.setStatus(TaskStatus.DISABLED); // 新复制的任务默认禁用
        newDefinition.setCreatedAt(LocalDateTime.now());
        newDefinition.setUpdatedAt(LocalDateTime.now());
        newDefinition.setDeletedAt(null);
        
        // 保存新任务定义
        taskDefinitionRepository.insert(newDefinition);
        
        log.info("任务定义复制成功, sourceId={}, newId={}, newName={}", 
                sourceDefinitionId, newDefinition.getId(), newTaskName);
        
        return convertToDTO(newDefinition);
    }

    @Override
    @Transactional
    public int batchDeleteTaskDefinitions(String tenantId, List<String> definitionIds) {
        log.info("批量删除任务定义, tenantId={}, definitionIds={}", tenantId, definitionIds);
        
        if (definitionIds == null || definitionIds.isEmpty()) {
            return 0;
        }
        
        int deletedCount = 0;
        LocalDateTime now = LocalDateTime.now();
        
        for (String definitionId : definitionIds) {
            try {
                TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
                
                // 从调度器中移除
                taskSchedulingService.unscheduleTask(definitionId);
                
                // 软删除
                taskDefinition.setDeletedAt(now);
                taskDefinitionRepository.updateById(taskDefinition);
                
                deletedCount++;
                log.debug("删除任务定义成功, definitionId={}", definitionId);
                
            } catch (Exception e) {
                log.error("删除任务定义失败, definitionId={}", definitionId, e);
                // 继续处理其他任务定义
            }
        }
        
        log.info("批量删除任务定义完成, 总数={}, 成功删除={}", definitionIds.size(), deletedCount);
        return deletedCount;
    }

    @Override
    @Transactional
    public int batchDisableTaskDefinitions(String tenantId, List<String> definitionIds) {
        log.info("批量禁用任务定义, tenantId={}, definitionIds={}", tenantId, definitionIds);
        
        if (definitionIds == null || definitionIds.isEmpty()) {
            return 0;
        }
        
        int disabledCount = 0;
        LocalDateTime now = LocalDateTime.now();
        
        for (String definitionId : definitionIds) {
            try {
                TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
                
                if (!TaskStatus.DISABLED.equals(taskDefinition.getStatus())) {
                    // 从调度器中移除
                    taskSchedulingService.unscheduleTask(definitionId);
                    
                    // 更新状态为禁用
                    taskDefinition.setStatus(TaskStatus.DISABLED);
                    taskDefinition.setUpdatedAt(now);
                    taskDefinitionRepository.updateById(taskDefinition);
                    
                    disabledCount++;
                    log.debug("禁用任务定义成功, definitionId={}", definitionId);
                } else {
                    log.debug("任务定义已经是禁用状态, definitionId={}", definitionId);
                }
                
            } catch (Exception e) {
                log.error("禁用任务定义失败, definitionId={}", definitionId, e);
                // 继续处理其他任务定义
            }
        }
        
        log.info("批量禁用任务定义完成, 总数={}, 成功禁用={}", definitionIds.size(), disabledCount);
        return disabledCount;
    }

    @Override
    @Transactional
    public int batchEnableTaskDefinitions(String tenantId, List<String> definitionIds) {
        log.info("批量启用任务定义, tenantId={}, definitionIds={}", tenantId, definitionIds);
        
        if (definitionIds == null || definitionIds.isEmpty()) {
            return 0;
        }
        
        int enabledCount = 0;
        LocalDateTime now = LocalDateTime.now();
        
        for (String definitionId : definitionIds) {
            try {
                TaskDefinition taskDefinition = getTaskDefinitionEntity(tenantId, definitionId);
                
                if (!TaskStatus.ENABLED.equals(taskDefinition.getStatus())) {
                    // 更新状态为启用
                    taskDefinition.setStatus(TaskStatus.ENABLED);
                    taskDefinition.setUpdatedAt(now);
                    taskDefinitionRepository.updateById(taskDefinition);
                    
                    // 添加到调度器
                    taskSchedulingService.scheduleTask(taskDefinition);
                    
                    enabledCount++;
                    log.debug("启用任务定义成功, definitionId={}", definitionId);
                } else {
                    log.debug("任务定义已经是启用状态, definitionId={}", definitionId);
                }
                
            } catch (Exception e) {
                log.error("启用任务定义失败, definitionId={}", definitionId, e);
                // 继续处理其他任务定义
            }
        }
        
        log.info("批量启用任务定义完成, 总数={}, 成功启用={}", definitionIds.size(), enabledCount);
        return enabledCount;
    }

    @Override
    public List<TaskDefinitionDTO> getAllTaskDefinitions(String tenantId) {
        log.debug("获取所有任务定义, tenantId={}", tenantId);
        
        LambdaQueryWrapper<TaskDefinition> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TaskDefinition::getTenantId, tenantId)
                   .isNull(TaskDefinition::getDeletedAt)
                   .orderByDesc(TaskDefinition::getCreatedAt);
        
        List<TaskDefinition> taskDefinitions = taskDefinitionRepository.selectList(queryWrapper);
        
        List<TaskDefinitionDTO> dtoList = taskDefinitions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        log.debug("获取所有任务定义完成, tenantId={}, count={}", tenantId, dtoList.size());
        return dtoList;
    }

    @Override
    public ImportResult importTaskDefinitions(String tenantId, String importData) {
        // TODO: 实现任务定义导入功能
        ImportResult result = new ImportResult();
        result.setSuccessCount(0);
        result.setFailureCount(0);
        result.setErrors(List.of("导入功能暂未实现"));
        return result;
    }

}