package com.wework.platform.task.lock;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.Collections;
import java.util.concurrent.TimeUnit;

/**
 * 基于Redis的分布式锁实现
 * 支持锁的获取、释放、续期等操作
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RedisDistributedLock implements DistributedLock {

    private final RedisTemplate<String, String> redisTemplate;

    /**
     * 锁的键前缀
     */
    private static final String LOCK_PREFIX = "task:lock:";

    /**
     * 释放锁的Lua脚本（确保原子性）
     */
    private static final String UNLOCK_SCRIPT = 
        "if redis.call('get', KEYS[1]) == ARGV[1] then " +
        "return redis.call('del', KEYS[1]) " +
        "else return 0 end";

    /**
     * 续期锁的Lua脚本
     */
    private static final String RENEW_SCRIPT = 
        "if redis.call('get', KEYS[1]) == ARGV[1] then " +
        "return redis.call('expire', KEYS[1], ARGV[2]) " +
        "else return 0 end";

    /**
     * 强制释放锁的脚本
     */
    private static final String FORCE_UNLOCK_SCRIPT = 
        "return redis.call('del', KEYS[1])";

    @Override
    public boolean tryLock(String key, String value, long expireTime, TimeUnit timeUnit) {
        try {
            String lockKey = LOCK_PREFIX + key;
            String lockValue = generateLockValue(value);
            
            Duration duration = Duration.ofMillis(timeUnit.toMillis(expireTime));
            Boolean success = redisTemplate.opsForValue()
                .setIfAbsent(lockKey, lockValue, duration);
            
            boolean result = Boolean.TRUE.equals(success);
            
            if (result) {
                log.debug("成功获取Redis分布式锁: key={}, value={}, expireTime={}{}",
                         key, value, expireTime, timeUnit);
            } else {
                log.debug("获取Redis分布式锁失败: key={}, value={}", key, value);
            }
            
            return result;
            
        } catch (Exception e) {
            log.error("获取Redis分布式锁异常: key={}, value={}", key, value, e);
            return false;
        }
    }

    @Override
    public boolean releaseLock(String key, String value) {
        try {
            String lockKey = LOCK_PREFIX + key;
            String lockValue = generateLockValue(value);
            
            DefaultRedisScript<Long> script = new DefaultRedisScript<>(UNLOCK_SCRIPT, Long.class);
            Long result = redisTemplate.execute(script, 
                Collections.singletonList(lockKey), lockValue);
            
            boolean success = result != null && result > 0;
            
            if (success) {
                log.debug("成功释放Redis分布式锁: key={}, value={}", key, value);
            } else {
                log.debug("释放Redis分布式锁失败: key={}, value={}", key, value);
            }
            
            return success;
            
        } catch (Exception e) {
            log.error("释放Redis分布式锁异常: key={}, value={}", key, value, e);
            return false;
        }
    }

    @Override
    public boolean renewLock(String key, String value, long expireTime, TimeUnit timeUnit) {
        try {
            String lockKey = LOCK_PREFIX + key;
            String lockValue = generateLockValue(value);
            long expireSeconds = timeUnit.toSeconds(expireTime);
            
            DefaultRedisScript<Long> script = new DefaultRedisScript<>(RENEW_SCRIPT, Long.class);
            Long result = redisTemplate.execute(script, 
                Collections.singletonList(lockKey), lockValue, String.valueOf(expireSeconds));
            
            boolean success = result != null && result > 0;
            
            if (success) {
                log.debug("成功续期Redis分布式锁: key={}, value={}, expireTime={}{}",
                         key, value, expireTime, timeUnit);
            } else {
                log.debug("续期Redis分布式锁失败: key={}, value={}", key, value);
            }
            
            return success;
            
        } catch (Exception e) {
            log.error("续期Redis分布式锁异常: key={}, value={}", key, value, e);
            return false;
        }
    }

    @Override
    public boolean isLocked(String key) {
        try {
            String lockKey = LOCK_PREFIX + key;
            Boolean exists = redisTemplate.hasKey(lockKey);
            return Boolean.TRUE.equals(exists);
            
        } catch (Exception e) {
            log.error("检查Redis分布式锁状态异常: key={}", key, e);
            return false;
        }
    }

    @Override
    public String getLockValue(String key) {
        try {
            String lockKey = LOCK_PREFIX + key;
            String value = redisTemplate.opsForValue().get(lockKey);
            
            if (value != null) {
                // 提取原始值（去除时间戳）
                int lastColonIndex = value.lastIndexOf(":");
                if (lastColonIndex > 0) {
                    return value.substring(0, lastColonIndex);
                }
            }
            
            return value;
            
        } catch (Exception e) {
            log.error("获取Redis分布式锁值异常: key={}", key, e);
            return null;
        }
    }

    @Override
    public boolean forceReleaseLock(String key) {
        try {
            String lockKey = LOCK_PREFIX + key;
            
            DefaultRedisScript<Long> script = new DefaultRedisScript<>(FORCE_UNLOCK_SCRIPT, Long.class);
            Long result = redisTemplate.execute(script, Collections.singletonList(lockKey));
            
            boolean success = result != null && result > 0;
            
            if (success) {
                log.warn("强制释放Redis分布式锁: key={}", key);
            }
            
            return success;
            
        } catch (Exception e) {
            log.error("强制释放Redis分布式锁异常: key={}", key, e);
            return false;
        }
    }

    /**
     * 生成锁值
     * 格式: 原始值:时间戳
     * 时间戳用于避免ABA问题
     */
    private String generateLockValue(String originalValue) {
        return originalValue + ":" + System.currentTimeMillis();
    }

    /**
     * 批量释放锁（用于节点下线时清理）
     * 
     * @param nodeId 节点ID
     * @return 释放的锁数量
     */
    public int batchReleaseLocksByNode(String nodeId) {
        try {
            // 这里可以通过Redis的SCAN命令查找该节点的所有锁
            // 然后批量释放，实现细节可以根据需要优化
            log.info("批量释放节点锁: nodeId={}", nodeId);
            return 0;
            
        } catch (Exception e) {
            log.error("批量释放节点锁异常: nodeId={}", nodeId, e);
            return 0;
        }
    }

    /**
     * 获取锁的剩余过期时间
     * 
     * @param key 锁的键
     * @return 剩余秒数，-1表示永不过期，-2表示锁不存在
     */
    public long getLockTTL(String key) {
        try {
            String lockKey = LOCK_PREFIX + key;
            Long ttl = redisTemplate.getExpire(lockKey, TimeUnit.SECONDS);
            return ttl != null ? ttl : -2;
            
        } catch (Exception e) {
            log.error("获取Redis分布式锁TTL异常: key={}", key, e);
            return -2;
        }
    }

    /**
     * 检查锁是否属于指定节点
     * 
     * @param key 锁的键
     * @param nodeId 节点ID
     * @return 是否属于该节点
     */
    public boolean isLockOwnedByNode(String key, String nodeId) {
        String lockValue = getLockValue(key);
        return lockValue != null && lockValue.equals(nodeId);
    }
}