package com.wework.platform.task.scheduler.impl;

import com.wework.platform.task.entity.TaskDefinition;
import com.wework.platform.task.lock.DistributedLock;
import com.wework.platform.task.scheduler.DistributedTaskScheduler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * 分布式任务调度器实现类
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DistributedTaskSchedulerImpl implements DistributedTaskScheduler {

    private final DistributedLock distributedLock;

    @Override
    public boolean trySchedule(String lockKey, TaskDefinition taskDefinition, LocalDateTime scheduledTime) {
        String lockValue = generateLockValue(taskDefinition, scheduledTime);
        
        try {
            // 尝试获取分布式锁，锁定时间为2分钟
            if (distributedLock.tryLock(lockKey, lockValue, 120)) {
                log.debug("获取调度锁成功: lockKey={}, taskId={}", lockKey, taskDefinition.getId());
                return true;
            } else {
                log.debug("获取调度锁失败，任务可能已被其他节点调度: lockKey={}, taskId={}", 
                         lockKey, taskDefinition.getId());
                return false;
            }
        } catch (Exception e) {
            log.error("尝试获取调度锁异常: lockKey={}, taskId={}", lockKey, taskDefinition.getId(), e);
            return false;
        }
    }

    @Override
    public void releaseScheduleLock(String lockKey, TaskDefinition taskDefinition, LocalDateTime scheduledTime) {
        String lockValue = generateLockValue(taskDefinition, scheduledTime);
        
        try {
            distributedLock.unlock(lockKey, lockValue);
            log.debug("释放调度锁: lockKey={}, taskId={}", lockKey, taskDefinition.getId());
        } catch (Exception e) {
            log.error("释放调度锁异常: lockKey={}, taskId={}", lockKey, taskDefinition.getId(), e);
        }
    }

    @Override
    public boolean isScheduled(String lockKey) {
        try {
            return distributedLock.isLocked(lockKey);
        } catch (Exception e) {
            log.error("检查调度锁状态异常: lockKey={}", lockKey, e);
            return false;
        }
    }

    /**
     * 生成锁值
     */
    private String generateLockValue(TaskDefinition taskDefinition, LocalDateTime scheduledTime) {
        return String.format("%s:%s:%s", 
                           getNodeIdentifier(),
                           taskDefinition.getId(),
                           scheduledTime.toString());
    }

    /**
     * 获取节点标识
     */
    private String getNodeIdentifier() {
        try {
            return java.net.InetAddress.getLocalHost().getHostName();
        } catch (Exception e) {
            return "unknown-node";
        }
    }
}