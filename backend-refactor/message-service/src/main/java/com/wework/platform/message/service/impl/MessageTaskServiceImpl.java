package com.wework.platform.message.service.impl;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.common.core.exception.BusinessException;
import com.wework.platform.common.enums.ResultCode;
import com.wework.platform.message.dto.MessageTaskDTO;
import com.wework.platform.message.dto.CreateTaskRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.entity.MessageTask;
import com.wework.platform.message.repository.MessageTaskRepository;
import com.wework.platform.message.repository.MessageRepository;
import com.wework.platform.message.service.MessageTaskService;
import com.wework.platform.message.service.MessageService;
import com.wework.platform.message.event.TaskExecutionEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.support.CronSequenceGenerator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 消息任务服务实现
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MessageTaskServiceImpl implements MessageTaskService {

    private final MessageTaskRepository messageTaskRepository;
    private final MessageRepository messageRepository;
    private final MessageService messageService;
    private final ApplicationEventPublisher eventPublisher;

    @Override
    @Transactional
    public MessageTaskDTO createTask(String tenantId, CreateTaskRequest request) {
        log.info("创建消息任务, tenantId: {}, taskName: {}", tenantId, request.getTaskName());

        // 构建任务实体
        MessageTask task = buildTask(tenantId, request);
        
        // 保存任务
        messageTaskRepository.insert(task);

        // 如果是即时发送，立即执行
        if (request.getTaskType() == 1) {
            executeTaskAsync(task.getId());
        }

        return convertToDTO(task);
    }

    @Override
    @Transactional
    public MessageTaskDTO updateTask(String taskId, CreateTaskRequest request) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        // 只能修改未执行的任务
        if (task.getTaskStatus() != 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只能修改未执行的任务");
        }

        // 更新任务信息
        updateTaskFromRequest(task, request);
        messageTaskRepository.updateById(task);

        return convertToDTO(task);
    }

    @Override
    public PageResult<MessageTaskDTO> getTaskList(String tenantId, Integer taskType, Integer taskStatus,
                                                String keyword, LocalDateTime startTime, LocalDateTime endTime,
                                                Integer pageNum, Integer pageSize) {
        Page<MessageTask> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<MessageTask> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(MessageTask::getTenantId, tenantId)
               .eq(taskType != null, MessageTask::getTaskType, taskType)
               .eq(taskStatus != null, MessageTask::getTaskStatus, taskStatus)
               .like(StringUtils.hasText(keyword), MessageTask::getTaskName, keyword)
               .ge(startTime != null, MessageTask::getCreatedAt, startTime)
               .le(endTime != null, MessageTask::getCreatedAt, endTime)
               .orderByDesc(MessageTask::getCreatedAt);

        IPage<MessageTask> result = messageTaskRepository.selectPage(page, wrapper);
        
        List<MessageTaskDTO> dtoList = result.getRecords().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return PageResult.of(dtoList, result.getTotal(), pageNum, pageSize);
    }

    @Override
    public MessageTaskDTO getTaskById(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }
        return convertToDTO(task);
    }

    @Override
    @Transactional
    public Boolean executeTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        // 检查任务状态
        if (task.getTaskStatus() == 2) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "任务已完成");
        }
        if (task.getTaskStatus() == 3) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "任务已取消");
        }

        // 异步执行任务
        executeTaskAsync(taskId);

        return true;
    }

    @Override
    @Transactional
    public Boolean pauseTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        if (task.getTaskStatus() != 1) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只能暂停执行中的任务");
        }

        // 更新任务状态为暂停
        messageTaskRepository.updateTaskStatus(taskId, 5, null); // 5: 已暂停

        // 暂停相关消息发送
        messageRepository.updateTaskMessagesStatus(taskId, 6); // 6: 已暂停

        return true;
    }

    @Override
    @Transactional
    public Boolean resumeTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        if (task.getTaskStatus() != 5) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只能恢复已暂停的任务");
        }

        // 更新任务状态为执行中
        messageTaskRepository.updateTaskStatus(taskId, 1, null);

        // 恢复相关消息发送
        messageRepository.updateTaskMessagesStatus(taskId, 0); // 0: 待发送

        // 继续执行任务
        executeTaskAsync(taskId);

        return true;
    }

    @Override
    @Transactional
    public Boolean cancelTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        if (task.getTaskStatus() == 2 || task.getTaskStatus() == 3) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "任务已完成或已取消");
        }

        // 更新任务状态
        messageTaskRepository.updateTaskStatus(taskId, 3, null);

        // 取消相关消息发送
        messageRepository.updateTaskMessagesStatus(taskId, 7); // 7: 已取消

        return true;
    }

    @Override
    @Transactional
    public Boolean retryTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        if (task.getTaskStatus() != 4) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "只能重试失败的任务");
        }

        // 重置任务状态
        task.setTaskStatus(0);
        task.setErrorMessage(null);
        messageTaskRepository.updateById(task);

        // 重新执行任务
        executeTaskAsync(taskId);

        return true;
    }

    @Override
    public List<MessageTaskDTO> getPendingTasks(Integer limit) {
        List<MessageTask> tasks = messageTaskRepository.findPendingTasks(limit);
        return tasks.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<MessageTaskDTO> getTasksForRetry(Integer limit) {
        List<MessageTask> tasks = messageTaskRepository.findTasksForRetry(limit);
        return tasks.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<MessageTaskDTO> getPeriodicTasks(Integer limit) {
        List<MessageTask> tasks = messageTaskRepository.findPeriodicTasks(limit);
        return tasks.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void updateTaskProgress(String taskId, Integer progress, Integer sentCount,
                                 Integer successCount, Integer failCount) {
        // 计算任务状态
        Integer taskStatus = null;
        if (progress >= 100) {
            taskStatus = 2; // 已完成
        } else if (failCount > 0 && successCount == 0) {
            taskStatus = 4; // 执行失败
        } else {
            taskStatus = 1; // 执行中
        }

        messageTaskRepository.updateTaskProgress(taskId, taskStatus, progress, 
                                               sentCount, successCount, failCount);
    }

    @Override
    @Transactional
    public Boolean auditTask(String taskId, Integer auditStatus, String auditorId, String auditRemark) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        task.setAuditStatus(auditStatus);
        task.setAuditorId(auditorId);
        task.setAuditTime(System.currentTimeMillis());
        task.setAuditRemark(auditRemark);
        
        return messageTaskRepository.updateById(task) > 0;
    }

    @Override
    public MessageStatisticsDTO.TaskStatistics getTaskStatistics(String tenantId,
                                                               LocalDateTime startTime,
                                                               LocalDateTime endTime) {
        MessageTaskRepository.TaskStatistics stats = messageTaskRepository.getTaskStatistics(
                tenantId, startTime, endTime);
        
        MessageStatisticsDTO.TaskStatistics dto = new MessageStatisticsDTO.TaskStatistics();
        BeanUtils.copyProperties(stats, dto);
        
        return dto;
    }

    @Override
    @Transactional
    public Boolean deleteTask(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            throw new BusinessException(ResultCode.NOT_FOUND, "任务不存在");
        }

        // 执行中的任务不能删除
        if (task.getTaskStatus() == 1) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "执行中的任务不能删除");
        }

        return messageTaskRepository.deleteById(taskId) > 0;
    }

    @Override
    @Transactional
    public Integer batchDeleteTasks(List<String> taskIds) {
        // 检查是否有执行中的任务
        LambdaQueryWrapper<MessageTask> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(MessageTask::getId, taskIds)
               .eq(MessageTask::getTaskStatus, 1);
        
        Long count = messageTaskRepository.selectCount(wrapper);
        if (count > 0) {
            throw new BusinessException(ResultCode.PARAM_ERROR, "包含执行中的任务，不能删除");
        }

        return messageTaskRepository.deleteBatchIds(taskIds);
    }

    @Override
    @Transactional
    public Integer cleanHistoryTasks(String tenantId, Integer beforeDays) {
        LocalDateTime beforeTime = LocalDateTime.now().minusDays(beforeDays);
        
        LambdaQueryWrapper<MessageTask> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MessageTask::getTenantId, tenantId)
               .le(MessageTask::getCreatedAt, beforeTime)
               .in(MessageTask::getTaskStatus, Arrays.asList(2, 3, 4)); // 已完成、已取消、执行失败
        
        return messageTaskRepository.delete(wrapper);
    }

    /**
     * 异步执行任务
     */
    @Async("taskExecutor")
    protected void executeTaskAsync(String taskId) {
        try {
            executeTaskInternal(taskId);
        } catch (Exception e) {
            log.error("执行任务失败, taskId: {}", taskId, e);
            messageTaskRepository.updateTaskStatus(taskId, 4, e.getMessage());
        }
    }

    /**
     * 内部执行任务
     */
    private void executeTaskInternal(String taskId) {
        MessageTask task = messageTaskRepository.selectById(taskId);
        if (task == null) {
            return;
        }

        // 更新任务开始时间
        messageTaskRepository.updateTaskStartTime(taskId);

        // 发布任务开始事件
        eventPublisher.publishEvent(new TaskExecutionEvent(taskId, "STARTED"));

        // 解析接收者列表
        List<String> receiverIds = parseReceivers(task);
        int totalCount = receiverIds.size();
        task.setTotalCount(totalCount);

        // 解析账号列表
        List<String> accountIds = JSON.parseArray(task.getAccountIds(), String.class);
        
        // 分批发送消息
        int batchSize = 100;
        int sentCount = 0;
        int successCount = 0;
        int failCount = 0;

        for (int i = 0; i < receiverIds.size(); i += batchSize) {
            int end = Math.min(i + batchSize, receiverIds.size());
            List<String> batchReceivers = receiverIds.subList(i, end);

            // 为每个账号发送消息
            for (String accountId : accountIds) {
                SendMessageRequest request = buildSendMessageRequest(task, accountId, batchReceivers);
                
                try {
                    messageService.sendMessage(task.getTenantId(), request);
                    successCount++;
                } catch (Exception e) {
                    log.error("发送消息失败, taskId: {}, accountId: {}", taskId, accountId, e);
                    failCount++;
                }
            }

            sentCount += batchReceivers.size();

            // 更新任务进度
            int progress = (int) ((double) sentCount / totalCount * 100);
            updateTaskProgress(taskId, progress, sentCount, successCount, failCount);
        }

        // 更新任务完成时间
        if (failCount == 0) {
            messageTaskRepository.updateTaskCompleteTime(taskId);
        } else {
            messageTaskRepository.updateTaskStatus(taskId, 4, "部分消息发送失败");
        }

        // 处理周期任务
        if (task.getTaskType() == 3 && task.getCronExpression() != null) {
            updateNextExecuteTime(task);
        }

        // 发布任务完成事件
        eventPublisher.publishEvent(new TaskExecutionEvent(taskId, "COMPLETED"));
    }

    /**
     * 构建任务实体
     */
    private MessageTask buildTask(String tenantId, CreateTaskRequest request) {
        MessageTask task = new MessageTask();
        task.setId(UUID.randomUUID().toString());
        task.setTenantId(tenantId);
        task.setTaskName(request.getTaskName());
        task.setTaskType(request.getTaskType());
        task.setSendType(request.getSendType());
        
        // 设置账号列表
        task.setAccountIds(JSON.toJSONString(request.getAccountIds()));
        
        // 设置接收者
        task.setReceivers(JSON.toJSONString(request.getReceivers()));
        
        // 设置消息内容
        if (request.getMessageContent() != null) {
            task.setMessageContent(JSON.toJSONString(request.getMessageContent()));
        }
        
        // 设置模板信息
        if (request.getTemplateConfig() != null) {
            task.setTemplateId(request.getTemplateConfig().getTemplateId());
            task.setTemplateParams(JSON.toJSONString(request.getTemplateConfig().getTemplateParams()));
        }
        
        task.setTaskStatus(0); // 待执行
        
        // 设置计划时间
        if (request.getTaskType() == 2 && request.getScheduleTime() != null) {
            task.setScheduleTime(request.getScheduleTime());
        } else if (request.getTaskType() == 1) {
            task.setScheduleTime(LocalDateTime.now());
        }
        
        // 设置周期配置
        if (request.getTaskType() == 3 && request.getPeriodicConfig() != null) {
            CreateTaskRequest.PeriodicConfig config = request.getPeriodicConfig();
            task.setCronExpression(config.getCronExpression());
            task.setMaxExecuteCount(config.getMaxExecuteCount());
            task.setExecuteCount(0);
            
            // 计算首次执行时间
            LocalDateTime nextTime = calculateNextExecuteTime(config.getCronExpression(), 
                                                            config.getStartTime());
            task.setNextExecuteTime(nextTime);
        }
        
        // 设置发送策略
        if (request.getSendStrategy() != null) {
            task.setSendStrategy(JSON.toJSONString(request.getSendStrategy()));
        }
        
        // 设置回调配置
        if (request.getCallbackConfig() != null) {
            task.setCallbackConfig(JSON.toJSONString(request.getCallbackConfig()));
        }
        
        task.setAuditStatus(0); // 待审核
        task.setRemark(request.getRemark());
        
        return task;
    }

    /**
     * 更新任务信息
     */
    private void updateTaskFromRequest(MessageTask task, CreateTaskRequest request) {
        if (request.getTaskName() != null) {
            task.setTaskName(request.getTaskName());
        }
        if (request.getAccountIds() != null) {
            task.setAccountIds(JSON.toJSONString(request.getAccountIds()));
        }
        if (request.getReceivers() != null) {
            task.setReceivers(JSON.toJSONString(request.getReceivers()));
        }
        if (request.getMessageContent() != null) {
            task.setMessageContent(JSON.toJSONString(request.getMessageContent()));
        }
        if (request.getTemplateConfig() != null) {
            task.setTemplateId(request.getTemplateConfig().getTemplateId());
            task.setTemplateParams(JSON.toJSONString(request.getTemplateConfig().getTemplateParams()));
        }
        if (request.getScheduleTime() != null) {
            task.setScheduleTime(request.getScheduleTime());
        }
        if (request.getPeriodicConfig() != null) {
            CreateTaskRequest.PeriodicConfig config = request.getPeriodicConfig();
            task.setCronExpression(config.getCronExpression());
            task.setMaxExecuteCount(config.getMaxExecuteCount());
        }
        if (request.getSendStrategy() != null) {
            task.setSendStrategy(JSON.toJSONString(request.getSendStrategy()));
        }
        if (request.getCallbackConfig() != null) {
            task.setCallbackConfig(JSON.toJSONString(request.getCallbackConfig()));
        }
        if (request.getRemark() != null) {
            task.setRemark(request.getRemark());
        }
    }

    /**
     * 解析接收者列表
     */
    private List<String> parseReceivers(MessageTask task) {
        CreateTaskRequest.ReceiverConfig receiverConfig = JSON.parseObject(
                task.getReceivers(), CreateTaskRequest.ReceiverConfig.class);
        
        List<String> receiverIds = new ArrayList<>();
        
        if (receiverConfig.getReceiverType() == 1) {
            // 指定用户
            receiverIds.addAll(receiverConfig.getUserIds());
        } else if (receiverConfig.getReceiverType() == 2) {
            // 指定群组
            receiverIds.addAll(receiverConfig.getGroupIds());
        } else {
            // TODO: 实现标签筛选和条件筛选
            log.warn("暂不支持标签筛选和条件筛选");
        }
        
        // 排除特定用户
        if (receiverConfig.getExcludeUserIds() != null) {
            receiverIds.removeAll(receiverConfig.getExcludeUserIds());
        }
        
        return receiverIds;
    }

    /**
     * 构建发送消息请求
     */
    private SendMessageRequest buildSendMessageRequest(MessageTask task, String accountId, List<String> receiverIds) {
        SendMessageRequest request = new SendMessageRequest();
        request.setAccountId(accountId);
        request.setReceiverIds(receiverIds);
        request.setReceiverType(1); // TODO: 根据实际情况设置
        
        if (task.getMessageContent() != null) {
            // 使用自定义消息内容
            SendMessageRequest.MessageContent content = JSON.parseObject(
                    task.getMessageContent(), SendMessageRequest.MessageContent.class);
            request.setContent(content);
            request.setMessageType(determineMessageType(content));
        } else if (task.getTemplateId() != null) {
            // 使用模板
            request.setTemplateId(task.getTemplateId());
            if (task.getTemplateParams() != null) {
                Map<String, Object> params = JSON.parseObject(task.getTemplateParams(), Map.class);
                request.setTemplateParams(params);
            }
            request.setMessageType(1); // 默认文本消息
        }
        
        request.setAsync(true);
        request.setRemark("任务ID: " + task.getId());
        
        return request;
    }

    /**
     * 确定消息类型
     */
    private Integer determineMessageType(SendMessageRequest.MessageContent content) {
        if (content.getMediaId() != null) {
            if (content.getFileName() != null) {
                return 4; // 文件
            } else {
                return 2; // 图片
            }
        } else if (content.getUrl() != null) {
            return 5; // 链接
        } else if (content.getAppId() != null) {
            return 6; // 小程序
        } else {
            return 1; // 文本
        }
    }

    /**
     * 计算下次执行时间
     */
    private LocalDateTime calculateNextExecuteTime(String cronExpression, LocalDateTime startTime) {
        try {
            CronSequenceGenerator generator = new CronSequenceGenerator(cronExpression);
            Date baseTime = startTime != null ? 
                    Date.from(startTime.atZone(java.time.ZoneId.systemDefault()).toInstant()) : new Date();
            Date nextTime = generator.next(baseTime);
            return LocalDateTime.ofInstant(nextTime.toInstant(), java.time.ZoneId.systemDefault());
        } catch (Exception e) {
            log.error("计算CRON表达式失败: {}", cronExpression, e);
            return null;
        }
    }

    /**
     * 更新下次执行时间
     */
    private void updateNextExecuteTime(MessageTask task) {
        LocalDateTime nextTime = calculateNextExecuteTime(task.getCronExpression(), LocalDateTime.now());
        if (nextTime != null) {
            messageTaskRepository.updateNextExecuteTime(task.getId(), nextTime);
        }
    }

    /**
     * 转换为DTO
     */
    private MessageTaskDTO convertToDTO(MessageTask task) {
        MessageTaskDTO dto = new MessageTaskDTO();
        BeanUtils.copyProperties(task, dto);
        
        // 转换时间戳
        dto.setScheduleTime(task.getScheduleTime() != null ? 
                          task.getScheduleTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setStartTime(task.getStartTime() != null ? 
                        task.getStartTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setCompleteTime(task.getCompleteTime() != null ? 
                           task.getCompleteTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setNextExecuteTime(task.getNextExecuteTime() != null ? 
                              task.getNextExecuteTime().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setCreatedAt(task.getCreatedAt() != null ? 
                        task.getCreatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setUpdatedAt(task.getUpdatedAt() != null ? 
                        task.getUpdatedAt().toEpochSecond(java.time.ZoneOffset.ofHours(8)) * 1000 : null);
        dto.setAuditTime(task.getAuditTime());
        
        // 设置类型名称
        dto.setTaskTypeName(getTaskTypeName(task.getTaskType()));
        dto.setSendTypeName(getSendTypeName(task.getSendType()));
        dto.setTaskStatusName(getTaskStatusName(task.getTaskStatus()));
        dto.setAuditStatusName(getAuditStatusName(task.getAuditStatus()));
        
        // 计算成功率
        if (task.getTotalCount() != null && task.getTotalCount() > 0) {
            dto.setSuccessRate((double) task.getSuccessCount() / task.getTotalCount() * 100);
        } else {
            dto.setSuccessRate(0.0);
        }
        
        // 解析账号信息
        if (task.getAccountIds() != null) {
            List<String> accountIds = JSON.parseArray(task.getAccountIds(), String.class);
            List<MessageTaskDTO.AccountInfo> accounts = accountIds.stream()
                    .map(id -> MessageTaskDTO.AccountInfo.builder()
                            .accountId(id)
                            .accountName(id) // TODO: 查询账号名称
                            .status("active")
                            .build())
                    .collect(Collectors.toList());
            dto.setAccounts(accounts);
        }
        
        // 解析接收者信息
        if (task.getReceivers() != null) {
            CreateTaskRequest.ReceiverConfig config = JSON.parseObject(
                    task.getReceivers(), CreateTaskRequest.ReceiverConfig.class);
            MessageTaskDTO.ReceiverInfo receiverInfo = MessageTaskDTO.ReceiverInfo.builder()
                    .totalCount(task.getTotalCount())
                    .userIds(config.getUserIds())
                    .groupIds(config.getGroupIds())
                    .build();
            dto.setReceivers(receiverInfo);
        }
        
        // 解析消息内容
        if (task.getMessageContent() != null) {
            SendMessageRequest.MessageContent content = JSON.parseObject(
                    task.getMessageContent(), SendMessageRequest.MessageContent.class);
            dto.setMessageContent(content);
        }
        
        // 解析模板信息
        if (task.getTemplateId() != null) {
            MessageTaskDTO.TemplateInfo templateInfo = MessageTaskDTO.TemplateInfo.builder()
                    .templateId(task.getTemplateId())
                    .build();
            if (task.getTemplateParams() != null) {
                Map<String, Object> params = JSON.parseObject(task.getTemplateParams(), Map.class);
                templateInfo.setTemplateParams(params);
            }
            dto.setTemplateInfo(templateInfo);
        }
        
        // 设置创建人信息
        MessageTaskDTO.CreatorInfo creator = MessageTaskDTO.CreatorInfo.builder()
                .creatorId(task.getCreatorId())
                .creatorName(task.getCreatorName())
                .build();
        dto.setCreator(creator);
        
        // 设置审核信息
        if (task.getAuditorId() != null) {
            MessageTaskDTO.AuditInfo auditInfo = MessageTaskDTO.AuditInfo.builder()
                    .auditorId(task.getAuditorId())
                    .auditTime(task.getAuditTime())
                    .auditRemark(task.getAuditRemark())
                    .build();
            dto.setAuditInfo(auditInfo);
        }
        
        return dto;
    }

    private String getTaskTypeName(Integer type) {
        if (type == null) return "";
        switch (type) {
            case 1: return "即时发送";
            case 2: return "定时发送";
            case 3: return "周期发送";
            default: return "未知";
        }
    }

    private String getSendTypeName(Integer type) {
        if (type == null) return "";
        switch (type) {
            case 1: return "单发";
            case 2: return "群发";
            case 3: return "朋友圈";
            default: return "未知";
        }
    }

    private String getTaskStatusName(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 0: return "待执行";
            case 1: return "执行中";
            case 2: return "已完成";
            case 3: return "已取消";
            case 4: return "执行失败";
            case 5: return "已暂停";
            default: return "未知";
        }
    }

    private String getAuditStatusName(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核拒绝";
            default: return "未知";
        }
    }
}