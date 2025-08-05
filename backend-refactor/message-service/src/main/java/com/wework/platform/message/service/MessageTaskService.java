package com.wework.platform.message.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.message.dto.MessageTaskDTO;
import com.wework.platform.message.dto.CreateTaskRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息任务服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface MessageTaskService {

    /**
     * 创建任务
     *
     * @param tenantId 租户ID
     * @param request 创建请求
     * @return 任务信息
     */
    MessageTaskDTO createTask(String tenantId, CreateTaskRequest request);

    /**
     * 更新任务
     *
     * @param taskId 任务ID
     * @param request 更新请求
     * @return 任务信息
     */
    MessageTaskDTO updateTask(String taskId, CreateTaskRequest request);

    /**
     * 分页查询任务列表
     *
     * @param tenantId 租户ID
     * @param taskType 任务类型
     * @param taskStatus 任务状态
     * @param keyword 关键词
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<MessageTaskDTO> getTaskList(String tenantId, Integer taskType, Integer taskStatus,
                                          String keyword, LocalDateTime startTime, LocalDateTime endTime,
                                          Integer pageNum, Integer pageSize);

    /**
     * 根据ID获取任务详情
     *
     * @param taskId 任务ID
     * @return 任务信息
     */
    MessageTaskDTO getTaskById(String taskId);

    /**
     * 执行任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean executeTask(String taskId);

    /**
     * 暂停任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean pauseTask(String taskId);

    /**
     * 恢复任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean resumeTask(String taskId);

    /**
     * 取消任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean cancelTask(String taskId);

    /**
     * 重试任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean retryTask(String taskId);

    /**
     * 获取待执行的任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
    List<MessageTaskDTO> getPendingTasks(Integer limit);

    /**
     * 获取需要重试的任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
    List<MessageTaskDTO> getTasksForRetry(Integer limit);

    /**
     * 获取周期性任务
     *
     * @param limit 限制数量
     * @return 任务列表
     */
    List<MessageTaskDTO> getPeriodicTasks(Integer limit);

    /**
     * 更新任务进度
     *
     * @param taskId 任务ID
     * @param progress 进度
     * @param sentCount 已发送数量
     * @param successCount 成功数量
     * @param failCount 失败数量
     */
    void updateTaskProgress(String taskId, Integer progress, Integer sentCount,
                           Integer successCount, Integer failCount);

    /**
     * 审核任务
     *
     * @param taskId 任务ID
     * @param auditStatus 审核状态
     * @param auditorId 审核人ID
     * @param auditRemark 审核备注
     * @return 是否成功
     */
    Boolean auditTask(String taskId, Integer auditStatus, String auditorId, String auditRemark);

    /**
     * 获取任务统计信息
     *
     * @param tenantId 租户ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    MessageStatisticsDTO.TaskStatistics getTaskStatistics(String tenantId,
                                                         LocalDateTime startTime,
                                                         LocalDateTime endTime);

    /**
     * 删除任务
     *
     * @param taskId 任务ID
     * @return 是否成功
     */
    Boolean deleteTask(String taskId);

    /**
     * 批量删除任务
     *
     * @param taskIds 任务ID列表
     * @return 删除数量
     */
    Integer batchDeleteTasks(List<String> taskIds);

    /**
     * 清理历史任务
     *
     * @param tenantId 租户ID
     * @param beforeDays 多少天前的任务
     * @return 清理数量
     */
    Integer cleanHistoryTasks(String tenantId, Integer beforeDays);
}