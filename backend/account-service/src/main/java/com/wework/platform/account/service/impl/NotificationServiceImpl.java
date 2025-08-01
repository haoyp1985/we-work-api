package com.wework.platform.account.service.impl;

import com.wework.platform.account.service.NotificationService;
import com.wework.platform.common.entity.AccountAlert;
import com.wework.platform.common.enums.AlertType;
import com.wework.platform.common.enums.AlertLevel;
import com.wework.platform.common.enums.AlertStatus;
import com.wework.platform.common.tenant.TenantRequired;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.MailSender;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * 通知服务实现
 * 
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
@TenantRequired
public class NotificationServiceImpl implements NotificationService {

    private final MailSender mailSender;
    private final WebClient webClient = WebClient.builder().build();

    @Value("${notification.sms.enabled:false}")
    private boolean smsEnabled;

    @Value("${notification.sms.api-url:}")
    private String smsApiUrl;

    @Value("${notification.sms.api-key:}")
    private String smsApiKey;

    @Value("${notification.email.enabled:true}")
    private boolean emailEnabled;

    @Value("${notification.email.from:noreply@wework-platform.com}")
    private String emailFrom;

    @Value("${notification.email.admin:admin@wework-platform.com}")
    private String adminEmail;

    @Value("${notification.wework.enabled:false}")
    private boolean weWorkNotificationEnabled;

    @Value("${notification.wework.webhook-url:}")
    private String weWorkWebhookUrl;

    @Value("${notification.dingtalk.enabled:false}")
    private boolean dingTalkEnabled;

    @Value("${notification.dingtalk.webhook-url:}")
    private String dingTalkWebhookUrl;

    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public void sendSmsNotification(AccountAlert alert) {
        if (!smsEnabled || smsApiUrl.isEmpty()) {
            log.debug("短信通知未启用，跳过发送");
            return;
        }

        try {
            String message = buildSmsMessage(alert);
            
            JSONObject request = new JSONObject();
            request.put("phone", getNotificationPhone(alert.getTenantId()));
            request.put("message", message);
            
            String response = webClient.post()
                    .uri(smsApiUrl)
                    .header("Authorization", "Bearer " + smsApiKey)
                    .header("Content-Type", "application/json")
                    .bodyValue(request.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            log.info("短信通知发送成功: alertId={}, response={}", alert.getId(), response);
            
        } catch (Exception e) {
            log.error("发送短信通知失败: alertId={}, error={}", alert.getId(), e.getMessage(), e);
        }
    }

    @Override
    public void sendEmailNotification(AccountAlert alert) {
        if (!emailEnabled) {
            log.debug("邮件通知未启用，跳过发送");
            return;
        }

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(emailFrom);
            message.setTo(getNotificationEmails(alert.getTenantId()));
            message.setSubject(buildEmailSubject(alert));
            message.setText(buildEmailContent(alert));
            
            mailSender.send(message);
            
            log.info("邮件通知发送成功: alertId={}", alert.getId());
            
        } catch (Exception e) {
            log.error("发送邮件通知失败: alertId={}, error={}", alert.getId(), e.getMessage(), e);
        }
    }

    @Override
    public void sendWeWorkNotification(AccountAlert alert) {
        if (!weWorkNotificationEnabled || weWorkWebhookUrl.isEmpty()) {
            log.debug("企微通知未启用，跳过发送");
            return;
        }

        try {
            JSONObject message = buildWeWorkMessage(alert);
            
            String response = webClient.post()
                    .uri(weWorkWebhookUrl)
                    .header("Content-Type", "application/json")
                    .bodyValue(message.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            log.info("企微通知发送成功: alertId={}, response={}", alert.getId(), response);
            
        } catch (Exception e) {
            log.error("发送企微通知失败: alertId={}, error={}", alert.getId(), e.getMessage(), e);
        }
    }

    @Override
    public void sendDingTalkNotification(AccountAlert alert) {
        if (!dingTalkEnabled || dingTalkWebhookUrl.isEmpty()) {
            log.debug("钉钉通知未启用，跳过发送");
            return;
        }

        try {
            JSONObject message = buildDingTalkMessage(alert);
            
            String response = webClient.post()
                    .uri(dingTalkWebhookUrl)
                    .header("Content-Type", "application/json")
                    .bodyValue(message.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            log.info("钉钉通知发送成功: alertId={}, response={}", alert.getId(), response);
            
        } catch (Exception e) {
            log.error("发送钉钉通知失败: alertId={}, error={}", alert.getId(), e.getMessage(), e);
        }
    }

    @Override
    public void sendWebhookNotification(AccountAlert alert, String webhookUrl) {
        try {
            JSONObject payload = buildWebhookPayload(alert);
            
            String response = webClient.post()
                    .uri(webhookUrl)
                    .header("Content-Type", "application/json")
                    .bodyValue(payload.toJSONString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            log.info("Webhook通知发送成功: alertId={}, url={}, response={}", 
                alert.getId(), webhookUrl, response);
            
        } catch (Exception e) {
            log.error("发送Webhook通知失败: alertId={}, url={}, error={}", 
                alert.getId(), webhookUrl, e.getMessage(), e);
        }
    }

    @Override
    public void sendBatchNotification(AccountAlert alert) {
        log.info("发送批量通知: alertId={}, level={}", alert.getId(), alert.getAlertLevel());
        
        // 根据告警级别决定发送哪些通知
        switch (alert.getAlertLevel()) {
            case CRITICAL:
                sendSmsNotification(alert);
                sendEmailNotification(alert);
                sendWeWorkNotification(alert);
                sendDingTalkNotification(alert);
                break;
            case ERROR:
                sendEmailNotification(alert);
                sendWeWorkNotification(alert);
                break;
            case WARNING:
                sendWeWorkNotification(alert);
                break;
            case INFO:
                // 信息级别告警通常不发送通知
                log.debug("信息级别告警，跳过通知发送");
                break;
        }
    }

    @Override
    public boolean testNotificationConfig(String tenantId, String notificationType) {
        try {
            // 创建测试告警
            AccountAlert testAlert = createTestAlert(tenantId);
            
            switch (notificationType.toLowerCase()) {
                case "sms":
                    sendSmsNotification(testAlert);
                    break;
                case "email":
                    sendEmailNotification(testAlert);
                    break;
                case "wework":
                    sendWeWorkNotification(testAlert);
                    break;
                case "dingtalk":
                    sendDingTalkNotification(testAlert);
                    break;
                default:
                    log.warn("不支持的通知类型: {}", notificationType);
                    return false;
            }
            
            return true;
            
        } catch (Exception e) {
            log.error("测试通知配置失败: tenantId={}, type={}, error={}", 
                tenantId, notificationType, e.getMessage(), e);
            return false;
        }
    }

    // ========== 私有辅助方法 ==========

    /**
     * 构建短信消息
     */
    private String buildSmsMessage(AccountAlert alert) {
        return String.format("【企微监控告警】%s级别告警：%s，时间：%s",
            alert.getAlertLevel().getDisplayName(),
            alert.getAlertMessage(),
            alert.getFirstOccurredAt().format(TIME_FORMATTER));
    }

    /**
     * 构建邮件主题
     */
    private String buildEmailSubject(AccountAlert alert) {
        return String.format("[企微平台] %s级别告警 - %s", 
            alert.getAlertLevel().getDisplayName(),
            alert.getAlertType().getDisplayName());
    }

    /**
     * 构建邮件内容
     */
    private String buildEmailContent(AccountAlert alert) {
        StringBuilder content = new StringBuilder();
        content.append("尊敬的管理员，\n\n");
        content.append("系统检测到以下告警信息：\n\n");
        content.append("告警ID：").append(alert.getId()).append("\n");
        content.append("租户ID：").append(alert.getTenantId()).append("\n");
        content.append("账号ID：").append(alert.getAccountId()).append("\n");
        content.append("告警类型：").append(alert.getAlertType().getDisplayName()).append("\n");
        content.append("告警级别：").append(alert.getAlertLevel().getDisplayName()).append("\n");
        content.append("告警消息：").append(alert.getAlertMessage()).append("\n");
        content.append("首次发生：").append(alert.getFirstOccurredAt().format(TIME_FORMATTER)).append("\n");
        content.append("最后发生：").append(alert.getLastOccurredAt().format(TIME_FORMATTER)).append("\n");
        content.append("发生次数：").append(alert.getOccurrenceCount()).append("\n\n");
        
        if (alert.getAlertData() != null) {
            content.append("详细信息：\n");
            content.append(JSON.toJSONString(alert.getAlertData())).append("\n\n");
        }
        
        content.append("请及时处理此告警。\n\n");
        content.append("企微平台监控系统");
        
        return content.toString();
    }

    /**
     * 构建企微消息
     */
    private JSONObject buildWeWorkMessage(AccountAlert alert) {
        JSONObject message = new JSONObject();
        message.put("msgtype", "markdown");
        
        JSONObject markdown = new JSONObject();
        StringBuilder content = new StringBuilder();
        content.append("## 🚨 企微平台告警通知\n\n");
        content.append("**告警级别：** <font color=\"").append(getLevelColor(alert.getAlertLevel())).append("\">")
               .append(alert.getAlertLevel().getDisplayName()).append("</font>\n\n");
        content.append("**告警类型：** ").append(alert.getAlertType().getDisplayName()).append("\n\n");
        content.append("**告警消息：** ").append(alert.getAlertMessage()).append("\n\n");
        content.append("**账号ID：** ").append(alert.getAccountId()).append("\n\n");
        content.append("**发生时间：** ").append(alert.getFirstOccurredAt().format(TIME_FORMATTER)).append("\n\n");
        content.append("**发生次数：** ").append(alert.getOccurrenceCount()).append("\n\n");
        content.append("> 请及时查看和处理此告警");
        
        markdown.put("content", content.toString());
        message.put("markdown", markdown);
        
        return message;
    }

    /**
     * 构建钉钉消息
     */
    private JSONObject buildDingTalkMessage(AccountAlert alert) {
        JSONObject message = new JSONObject();
        message.put("msgtype", "markdown");
        
        JSONObject markdown = new JSONObject();
        markdown.put("title", "企微平台告警通知");
        
        StringBuilder content = new StringBuilder();
        content.append("## 🚨 企微平台告警通知\n\n");
        content.append("**告警级别：** ").append(alert.getAlertLevel().getDisplayName()).append("\n\n");
        content.append("**告警类型：** ").append(alert.getAlertType().getDisplayName()).append("\n\n");
        content.append("**告警消息：** ").append(alert.getAlertMessage()).append("\n\n");
        content.append("**账号ID：** ").append(alert.getAccountId()).append("\n\n");
        content.append("**发生时间：** ").append(alert.getFirstOccurredAt().format(TIME_FORMATTER)).append("\n\n");
        content.append("**发生次数：** ").append(alert.getOccurrenceCount()).append("\n\n");
        content.append("> 请及时查看和处理此告警");
        
        markdown.put("text", content.toString());
        message.put("markdown", markdown);
        
        return message;
    }

    /**
     * 构建Webhook载荷
     */
    private JSONObject buildWebhookPayload(AccountAlert alert) {
        JSONObject payload = new JSONObject();
        payload.put("alertId", alert.getId());
        payload.put("tenantId", alert.getTenantId());
        payload.put("accountId", alert.getAccountId());
        payload.put("alertType", alert.getAlertType().name());
        payload.put("alertLevel", alert.getAlertLevel().name());
        payload.put("alertMessage", alert.getAlertMessage());
        payload.put("firstOccurredAt", alert.getFirstOccurredAt().toString());
        payload.put("lastOccurredAt", alert.getLastOccurredAt().toString());
        payload.put("occurrenceCount", alert.getOccurrenceCount());
        payload.put("status", alert.getStatus().name());
        payload.put("alertData", alert.getAlertData());
        
        return payload;
    }

    /**
     * 获取告警级别颜色
     */
    private String getLevelColor(com.wework.platform.common.enums.AlertLevel level) {
        switch (level) {
            case CRITICAL: return "red";
            case ERROR: return "orange";
            case WARNING: return "yellow";
            case INFO: return "blue";
            default: return "gray";
        }
    }

    /**
     * 获取通知手机号
     */
    private String getNotificationPhone(String tenantId) {
        // TODO: 从租户配置中获取通知手机号
        // 这里返回默认管理员手机号
        return "13800138000";
    }

    /**
     * 获取通知邮箱
     */
    private String[] getNotificationEmails(String tenantId) {
        // TODO: 从租户配置中获取通知邮箱列表
        // 这里返回默认管理员邮箱
        return new String[]{adminEmail};
    }

    /**
     * 创建测试告警
     */
    private AccountAlert createTestAlert(String tenantId) {
        AccountAlert testAlert = new AccountAlert();
        testAlert.setId("test-alert-" + System.currentTimeMillis());
        testAlert.setTenantId(tenantId);
        testAlert.setAccountId("test-account");
        testAlert.setAlertType(AlertType.ACCOUNT_OFFLINE);
        testAlert.setAlertLevel(AlertLevel.WARNING);
        testAlert.setAlertMessage("这是一条测试告警消息");
        testAlert.setFirstOccurredAt(java.time.LocalDateTime.now());
        testAlert.setLastOccurredAt(java.time.LocalDateTime.now());
        testAlert.setOccurrenceCount(1);
        testAlert.setStatus(AlertStatus.ACTIVE);
        
        return testAlert;
    }
}