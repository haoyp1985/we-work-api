package com.wework.platform.account.service;

import com.wework.platform.common.entity.AccountAlert;

/**
 * 通知服务接口
 * 
 * @author WeWork Platform Team
 */
public interface NotificationService {

    /**
     * 发送短信通知
     */
    void sendSmsNotification(AccountAlert alert);

    /**
     * 发送邮件通知
     */
    void sendEmailNotification(AccountAlert alert);

    /**
     * 发送企微通知
     */
    void sendWeWorkNotification(AccountAlert alert);

    /**
     * 发送钉钉通知
     */
    void sendDingTalkNotification(AccountAlert alert);

    /**
     * 发送自定义webhook通知
     */
    void sendWebhookNotification(AccountAlert alert, String webhookUrl);

    /**
     * 批量发送通知
     */
    void sendBatchNotification(AccountAlert alert);

    /**
     * 测试通知配置
     */
    boolean testNotificationConfig(String tenantId, String notificationType);
}