package com.wework.platform.account.service;

import com.alibaba.fastjson2.JSON;
import com.wework.platform.account.client.WeWorkApiClient;
import com.wework.platform.account.config.AccountConfig;
import com.wework.platform.account.repository.WeWorkAccountRepository;
import com.wework.platform.common.entity.WeWorkAccount;
import com.wework.platform.common.enums.AccountStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 账号监控服务
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AccountMonitorService {

    private final WeWorkAccountRepository accountRepository;
    private final WeWorkApiClient weWorkApiClient;
    private final RabbitTemplate rabbitTemplate;
    private final RedisTemplate<String, Object> redisTemplate;

    @Value("${wework.account.heartbeat-interval:30}")
    private Integer heartbeatInterval;

    private static final String HEARTBEAT_LOCK_PREFIX = "heartbeat:lock:";
    private static final String STATUS_CHECK_LOCK = "status:check:lock";

    /**
     * 心跳检查定时任务 - 每30秒执行一次
     */
    @Scheduled(fixedDelayString = "${wework.account.heartbeat-interval:30}000")
    public void heartbeatCheck() {
        String lockKey = STATUS_CHECK_LOCK + ":" + System.currentTimeMillis() / 30000;
        Boolean acquired = redisTemplate.opsForValue().setIfAbsent(lockKey, "1", 25, TimeUnit.SECONDS);
        
        if (acquired == Boolean.TRUE) {
            try {
                log.debug("开始执行心跳检查任务");
                performHeartbeatCheck();
            } catch (Exception e) {
                log.error("心跳检查任务执行失败", e);
            } finally {
                redisTemplate.delete(lockKey);
            }
        }
    }

    /**
     * 执行心跳检查
     */
    @Async("accountTaskExecutor")
    public void performHeartbeatCheck() {
        LocalDateTime checkTime = LocalDateTime.now().minusSeconds(heartbeatInterval * 2);
        List<WeWorkAccount> accounts = accountRepository.selectNeedHeartbeatCheck(checkTime);
        
        log.debug("需要心跳检查的账号数量: {}", accounts.size());
        
        for (WeWorkAccount account : accounts) {
            checkSingleAccountHeartbeat(account);
        }
    }

    /**
     * 检查单个账号心跳
     */
    @Async("accountTaskExecutor")
    public void checkSingleAccountHeartbeat(WeWorkAccount account) {
        String lockKey = HEARTBEAT_LOCK_PREFIX + account.getId();
        Boolean acquired = redisTemplate.opsForValue().setIfAbsent(lockKey, "1", 30, TimeUnit.SECONDS);
        
        if (acquired != Boolean.TRUE) {
            return; // 其他线程正在处理
        }

        try {
            log.debug("检查账号心跳: {}", account.getId());
            
            if (!StringUtils.hasText(account.getGuid())) {
                log.warn("账号 {} 没有GUID，跳过心跳检查", account.getId());
                return;
            }

            // 调用企微API检查状态
            try {
                var statusData = weWorkApiClient.getInstanceStatus(account.getGuid());
                
                if (statusData != null) {
                    // 更新心跳时间
                    LocalDateTime now = LocalDateTime.now();
                    accountRepository.updateHeartbeat(account.getId(), now, now);
                    
                    // 发送心跳消息
                    publishHeartbeatMessage(account.getId(), account.getGuid(), statusData.toJSONString());
                    
                    log.debug("账号 {} 心跳正常", account.getId());
                } else {
                    // 状态异常，标记为离线
                    handleAccountOffline(account, "心跳检查失败");
                }
                
            } catch (Exception e) {
                log.warn("账号 {} 心跳检查异常: {}", account.getId(), e.getMessage());
                handleAccountOffline(account, "心跳检查异常: " + e.getMessage());
            }
            
        } finally {
            redisTemplate.delete(lockKey);
        }
    }

    /**
     * 处理账号离线
     */
    private void handleAccountOffline(WeWorkAccount account, String reason) {
        log.info("账号 {} 离线，原因: {}", account.getId(), reason);
        
        // 更新账号状态为离线
        accountRepository.updateStatus(account.getId(), AccountStatus.OFFLINE, LocalDateTime.now());
        
        // 发送状态变更通知
        publishStatusChangeMessage(account.getId(), AccountStatus.ONLINE, AccountStatus.OFFLINE, reason);
        
        // 清除相关缓存
        clearAccountCache(account.getId());
    }

    /**
     * 账号状态统计 - 每分钟执行一次
     */
    @Scheduled(fixedRate = 60000)
    public void collectAccountStatistics() {
        try {
            log.debug("开始收集账号统计信息");
            
            // 统计各状态账号数量
            Map<String, Object> statistics = new HashMap<>();
            
            for (AccountStatus status : AccountStatus.values()) {
                // 这里可以添加统计逻辑
                // long count = accountRepository.countByStatus(status);
                // statistics.put(status.getCode(), count);
            }
            
            // 发送统计信息到监控系统
            // publishStatisticsMessage(statistics);
            
        } catch (Exception e) {
            log.error("收集账号统计信息失败", e);
        }
    }

    /**
     * 清理过期缓存 - 每小时执行一次
     */
    @Scheduled(fixedRate = 3600000)
    public void cleanupExpiredCache() {
        try {
            log.debug("开始清理过期缓存");
            
            // 这里可以添加缓存清理逻辑
            // 例如清理长时间未活跃的账号缓存
            
        } catch (Exception e) {
            log.error("清理过期缓存失败", e);
        }
    }

    /**
     * 发送心跳消息
     */
    private void publishHeartbeatMessage(String accountId, String guid, String statusDetails) {
        try {
            Map<String, Object> message = new HashMap<>();
            message.put("accountId", accountId);
            message.put("guid", guid);
            message.put("timestamp", LocalDateTime.now());
            message.put("statusDetails", statusDetails);
            
            rabbitTemplate.convertAndSend(
                    AccountConfig.ACCOUNT_EXCHANGE,
                    AccountConfig.ACCOUNT_HEARTBEAT_ROUTING_KEY,
                    message
            );
            
        } catch (Exception e) {
            log.error("发送心跳消息失败", e);
        }
    }

    /**
     * 发送状态变更消息
     */
    private void publishStatusChangeMessage(String accountId, AccountStatus oldStatus, AccountStatus newStatus, String reason) {
        try {
            Map<String, Object> message = new HashMap<>();
            message.put("accountId", accountId);
            message.put("oldStatus", oldStatus.getCode());
            message.put("newStatus", newStatus.getCode());
            message.put("reason", reason);
            message.put("timestamp", LocalDateTime.now());
            
            rabbitTemplate.convertAndSend(
                    AccountConfig.ACCOUNT_EXCHANGE,
                    AccountConfig.ACCOUNT_STATUS_ROUTING_KEY,
                    message
            );
            
            log.info("账号状态变更: {} {} -> {}, 原因: {}", accountId, oldStatus.getCode(), newStatus.getCode(), reason);
            
        } catch (Exception e) {
            log.error("发送状态变更消息失败", e);
        }
    }

    /**
     * 清除账号缓存
     */
    private void clearAccountCache(String accountId) {
        try {
            redisTemplate.delete("account:" + accountId);
            redisTemplate.delete("account:status:" + accountId);
        } catch (Exception e) {
            log.warn("清除账号缓存失败: {}", e.getMessage());
        }
    }
}