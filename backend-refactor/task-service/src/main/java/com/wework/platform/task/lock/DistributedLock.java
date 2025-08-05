package com.wework.platform.task.lock;

import java.util.concurrent.TimeUnit;

/**
 * 分布式锁接口
 * 支持多种分布式锁实现（Redis、数据库等）
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
public interface DistributedLock {

    /**
     * 尝试获取锁
     * 
     * @param key 锁的键
     * @param value 锁的值（通常是节点标识）
     * @param expireTime 过期时间
     * @param timeUnit 时间单位
     * @return 是否获取成功
     */
    boolean tryLock(String key, String value, long expireTime, TimeUnit timeUnit);

    /**
     * 尝试获取锁（默认过期时间30分钟）
     * 
     * @param key 锁的键
     * @param value 锁的值
     * @return 是否获取成功
     */
    default boolean tryLock(String key, String value) {
        return tryLock(key, value, 30, TimeUnit.MINUTES);
    }

    /**
     * 释放锁
     * 
     * @param key 锁的键
     * @param value 锁的值（必须匹配才能释放）
     * @return 是否释放成功
     */
    boolean releaseLock(String key, String value);

    /**
     * 续期锁
     * 
     * @param key 锁的键
     * @param value 锁的值
     * @param expireTime 新的过期时间
     * @param timeUnit 时间单位
     * @return 是否续期成功
     */
    boolean renewLock(String key, String value, long expireTime, TimeUnit timeUnit);

    /**
     * 检查锁是否存在
     * 
     * @param key 锁的键
     * @return 是否存在
     */
    boolean isLocked(String key);

    /**
     * 获取锁的值
     * 
     * @param key 锁的键
     * @return 锁的值，如果不存在返回null
     */
    String getLockValue(String key);

    /**
     * 强制释放锁（管理员操作）
     * 
     * @param key 锁的键
     * @return 是否释放成功
     */
    boolean forceReleaseLock(String key);
}