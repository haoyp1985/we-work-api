package com.wework.platform.message.service;

import com.wework.platform.common.core.base.PageResult;
import com.wework.platform.message.dto.MessageDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.dto.MessageStatisticsDTO;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 消息服务接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface MessageService {

    /**
     * 发送消息
     *
     * @param tenantId 租户ID
     * @param request 发送请求
     * @return 消息信息
     */
    MessageDTO sendMessage(String tenantId, SendMessageRequest request);

    /**
     * 批量发送消息
     *
     * @param tenantId 租户ID
     * @param requests 发送请求列表
     * @return 消息列表
     */
    List<MessageDTO> batchSendMessages(String tenantId, List<SendMessageRequest> requests);

    /**
     * 分页查询消息列表
     *
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param messageType 消息类型
     * @param sendStatus 发送状态
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @param pageNum 页码
     * @param pageSize 页大小
     * @return 分页结果
     */
    PageResult<MessageDTO> getMessageList(String tenantId, String accountId, Integer messageType,
                                         Integer sendStatus, LocalDateTime startTime, LocalDateTime endTime,
                                         Integer pageNum, Integer pageSize);

    /**
     * 根据ID获取消息详情
     *
     * @param messageId 消息ID
     * @return 消息信息
     */
    MessageDTO getMessageById(String messageId);

    /**
     * 重新发送消息
     *
     * @param messageId 消息ID
     * @return 消息信息
     */
    MessageDTO resendMessage(String messageId);

    /**
     * 撤回消息
     *
     * @param messageId 消息ID
     * @return 是否成功
     */
    Boolean recallMessage(String messageId);

    /**
     * 更新消息状态
     *
     * @param messageId 消息ID
     * @param sendStatus 发送状态
     * @param errorCode 错误码
     * @param errorMessage 错误信息
     */
    void updateMessageStatus(String messageId, Integer sendStatus, String errorCode, String errorMessage);

    /**
     * 获取待重试的消息
     *
     * @param limit 限制数量
     * @return 消息列表
     */
    List<MessageDTO> getMessagesForRetry(Integer limit);

    /**
     * 处理消息重试
     *
     * @param messageId 消息ID
     * @return 是否成功
     */
    Boolean handleMessageRetry(String messageId);

    /**
     * 获取消息统计信息
     *
     * @param tenantId 租户ID
     * @param accountId 账号ID
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    MessageStatisticsDTO getMessageStatistics(String tenantId, String accountId,
                                            LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 删除消息
     *
     * @param messageId 消息ID
     * @return 是否成功
     */
    Boolean deleteMessage(String messageId);

    /**
     * 批量删除消息
     *
     * @param messageIds 消息ID列表
     * @return 删除数量
     */
    Integer batchDeleteMessages(List<String> messageIds);

    /**
     * 清理历史消息
     *
     * @param tenantId 租户ID
     * @param beforeDays 多少天前的消息
     * @return 清理数量
     */
    Integer cleanHistoryMessages(String tenantId, Integer beforeDays);
}