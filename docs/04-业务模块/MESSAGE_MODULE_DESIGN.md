# 💬 消息发送模块详细设计
*WeWork Management Platform - Message Sending Module Design*

## 📖 文档目录

1. [模块概述](#模块概述)
2. [业务建模](#业务建模)
3. [消息队列架构](#消息队列架构)
4. [发送策略设计](#发送策略设计)
5. [重试机制设计](#重试机制设计)
6. [限流控制机制](#限流控制机制)
7. [性能优化方案](#性能优化方案)
8. [异常处理机制](#异常处理机制)
9. [监控和指标](#监控和指标)
10. [扩展性设计](#扩展性设计)

---

## 🎯 模块概述

### 业务职责
消息发送模块负责企业微信消息的可靠发送，支持多种消息类型、批量发送、定时发送等功能。

```yaml
核心职责:
  - 消息路由和分发
  - 多类型消息支持
  - 批量发送优化
  - 发送结果跟踪
  - 智能重试机制
  - 流量控制管理

业务价值:
  - 高吞吐量: 支持大规模消息发送
  - 高可靠性: 消息零丢失保证
  - 智能调度: 最优发送策略
  - 实时监控: 发送状态追踪
```

### 技术架构
```yaml
架构模式:
  - 生产者-消费者模式: 解耦发送请求和实际发送
  - 分布式队列: 保证消息可靠性
  - 批处理模式: 提升发送效率
  - 状态机模式: 规范化消息状态管理

核心组件:
  - MessageProducer: 消息生产者
  - MessageQueue: 消息队列
  - MessageConsumer: 消息消费者
  - RetryManager: 重试管理器
  - RateLimiter: 限流控制器
  - StatusTracker: 状态跟踪器
```

---

## 🏗️ 业务建模

### 领域实体设计

#### 1. 消息聚合根(Message Aggregate)
```java
@Entity
@Table(name = "message_records")
@AggregateRoot
public class MessageRecord {
    
    @Id
    private MessageId messageId;
    
    // 基本信息
    private TenantId tenantId;
    private AccountId accountId;
    private ConversationId conversationId;
    
    // 消息内容
    private MessageType messageType;
    private MessageContent content;
    private MessageTemplate template;
    
    // 发送配置
    private SendPriority priority;
    private ScheduledTime scheduledTime;
    private SendOptions options;
    
    // 状态管理
    private MessageStatus status;
    private SendAttempts attempts;
    private LastRetryTime lastRetryTime;
    
    // 结果追踪
    private WeWorkMessageId weWorkMessageId;
    private SendResult sendResult;
    private CallbackTime callbackTime;
    
    // 时间信息
    private CreatedAt createdAt;
    private UpdatedAt updatedAt;
    private SentAt sentAt;
    
    // 业务方法
    public void markAsSending() {
        this.status = MessageStatus.SENDING;
        this.updatedAt = UpdatedAt.now();
        this.publishStatusChangedEvent();
    }
    
    public void markAsSent(WeWorkMessageId weWorkMessageId) {
        this.status = MessageStatus.SENT;
        this.weWorkMessageId = weWorkMessageId;
        this.sentAt = SentAt.now();
        this.publishMessageSentEvent();
    }
    
    public boolean canRetry() {
        return this.attempts.canRetry() && 
               this.status.isRetriable() &&
               !this.isExpired();
    }
}
```

#### 2. 消息内容值对象
```java
@ValueObject
public class MessageContent {
    private final String text;
    private final List<String> imageUrls;
    private final String fileUrl;
    private final String fileName;
    private final List<String> atList;
    private final boolean atAll;
    private final Map<String, Object> extraData;
    
    public static MessageContent text(String text) {
        return new MessageContent(text, null, null, null, null, false, null);
    }
    
    public static MessageContent image(List<String> imageUrls) {
        return new MessageContent(null, imageUrls, null, null, null, false, null);
    }
    
    public int getEstimatedSize() {
        int size = 0;
        if (text != null) size += text.length() * 2; // UTF-8估算
        if (imageUrls != null) size += imageUrls.size() * 100; // URL长度估算
        if (fileUrl != null) size += 100;
        return size;
    }
    
    public boolean isValid() {
        return (text != null && !text.trim().isEmpty()) ||
               (imageUrls != null && !imageUrls.isEmpty()) ||
               (fileUrl != null && !fileUrl.trim().isEmpty());
    }
}
```

---

## 🔄 消息队列架构

### 1. 多级队列设计
```java
@Component
public class MessageQueueManager {
    
    // 高优先级队列
    private final RedisTemplate<String, MessageRecord> highPriorityQueue;
    // 普通优先级队列
    private final RedisTemplate<String, MessageRecord> normalPriorityQueue;
    // 低优先级队列
    private final RedisTemplate<String, MessageRecord> lowPriorityQueue;
    // 延时队列
    private final RedisTemplate<String, MessageRecord> delayedQueue;
    
    /**
     * 智能入队
     */
    public void enqueue(MessageRecord message, SendPriority priority) {
        String queueKey = getQueueKey(priority);
        
        // 1. 序列化消息
        String messageData = serializeMessage(message);
        
        // 2. 计算分数(用于排序)
        double score = calculateScore(message, priority);
        
        // 3. 入队操作
        RedisTemplate<String, MessageRecord> queue = getQueue(priority);
        queue.opsForZSet().add(queueKey, messageData, score);
        
        // 4. 通知消费者
        notifyConsumers(priority);
    }
    
    /**
     * 智能出队
     */
    public Optional<MessageRecord> dequeue(SendPriority priority) {
        String queueKey = getQueueKey(priority);
        RedisTemplate<String, MessageRecord> queue = getQueue(priority);
        
        // 原子性出队操作
        Set<String> messages = queue.opsForZSet().range(queueKey, 0, 0);
        if (messages.isEmpty()) {
            return Optional.empty();
        }
        
        String messageData = messages.iterator().next();
        Long removed = queue.opsForZSet().remove(queueKey, messageData);
        
        if (removed > 0) {
            MessageRecord message = deserializeMessage(messageData);
            updateDequeueStats(priority);
            return Optional.of(message);
        }
        
        return Optional.empty();
    }
    
    /**
     * 延时消息调度
     */
    @Scheduled(fixedDelay = 1000) // 每秒检查一次
    public void processDelayedMessages() {
        String delayedQueueKey = "message:queue:delayed";
        long currentTime = System.currentTimeMillis();
        
        // 获取到期的延时消息
        Set<ZSetOperations.TypedTuple<String>> expiredMessages = 
            delayedQueue.opsForZSet().rangeByScoreWithScores(delayedQueueKey, 0, currentTime);
        
        for (ZSetOperations.TypedTuple<String> tuple : expiredMessages) {
            String messageData = tuple.getValue();
            
            // 移除延时队列中的消息
            delayedQueue.opsForZSet().remove(delayedQueueKey, messageData);
            
            // 反序列化并重新入队
            MessageRecord message = deserializeMessage(messageData);
            enqueue(message, message.getPriority());
        }
    }
}
```

### 2. 分布式消费者设计
```java
@Component
public class MessageConsumerPool {
    
    private final List<MessageConsumer> consumers;
    private final ExecutorService consumerExecutor;
    private final ConsumerBalancer balancer;
    
    @PostConstruct
    public void initializeConsumers() {
        int consumerCount = calculateOptimalConsumerCount();
        this.consumers = new ArrayList<>();
        
        for (int i = 0; i < consumerCount; i++) {
            MessageConsumer consumer = new MessageConsumer(
                "consumer-" + i,
                messageQueueManager,
                messageProcessor,
                this::handleConsumerError
            );
            consumers.add(consumer);
        }
        
        // 启动所有消费者
        consumers.forEach(consumer -> 
            consumerExecutor.submit(consumer::start));
    }
    
    /**
     * 动态调整消费者数量
     */
    @Scheduled(fixedDelay = 60000) // 每分钟检查
    public void balanceConsumers() {
        QueueMetrics metrics = messageQueueManager.getQueueMetrics();
        int optimalCount = balancer.calculateOptimalConsumerCount(metrics);
        int currentCount = consumers.size();
        
        if (optimalCount > currentCount) {
            // 增加消费者
            for (int i = currentCount; i < optimalCount; i++) {
                addConsumer("consumer-" + i);
            }
        } else if (optimalCount < currentCount) {
            // 减少消费者
            for (int i = currentCount - 1; i >= optimalCount; i--) {
                removeConsumer(consumers.get(i));
            }
        }
    }
}
```

---

## 📈 发送策略设计

### 1. 智能发送调度器
```java
@Component
public class MessageSendingScheduler {
    
    /**
     * 智能发送调度
     */
    @Scheduled(fixedDelay = 100) // 每100ms执行一次
    public void scheduleSending() {
        List<WeWorkAccount> availableAccounts = getAvailableAccounts();
        
        for (WeWorkAccount account : availableAccounts) {
            try {
                scheduleAccountSending(account);
            } catch (Exception e) {
                log.error("账号发送调度失败: " + account.getAccountId(), e);
            }
        }
    }
    
    private void scheduleAccountSending(WeWorkAccount account) {
        AccountId accountId = account.getAccountId();
        
        // 1. 计算当前发送速率
        SendingRate currentRate = rateCalculator.getCurrentRate(accountId);
        
        // 2. 计算最优发送速率
        SendingRate optimalRate = calculateOptimalRate(account, currentRate);
        
        // 3. 根据速率调度消息
        int messagesToProcess = optimalRate.getMessagesPerInterval();
        
        for (int i = 0; i < messagesToProcess; i++) {
            Optional<MessageRecord> message = queueManager.dequeueForAccount(accountId);
            if (message.isPresent()) {
                processMessage(message.get());
            } else {
                break; // 队列为空
            }
        }
    }
    
    private SendingRate calculateOptimalRate(WeWorkAccount account, SendingRate currentRate) {
        // 1. 账号健康状态影响
        double healthFactor = account.getHealth().getScore();
        
        // 2. 历史成功率影响
        double successRate = getHistoricalSuccessRate(account.getAccountId());
        
        // 3. 当前负载影响
        double loadFactor = calculateLoadFactor(account);
        
        // 4. 时间段影响(工作时间 vs 非工作时间)
        double timeFactor = calculateTimeFactor();
        
        // 5. 计算综合调整因子
        double adjustmentFactor = healthFactor * successRate * loadFactor * timeFactor;
        
        // 6. 应用调整
        int baseRate = getBaseRate(account);
        int adjustedRate = (int) (baseRate * adjustmentFactor);
        
        return SendingRate.create(adjustedRate, Duration.ofSeconds(1));
    }
}
```

### 2. 批量发送优化
```java
@Component
public class BatchSendingOptimizer {
    
    /**
     * 智能批量组装
     */
    public List<MessageBatch> optimizeBatch(List<MessageRecord> messages) {
        // 1. 按账号分组
        Map<AccountId, List<MessageRecord>> accountGroups = 
            messages.stream().collect(Collectors.groupingBy(MessageRecord::getAccountId));
        
        List<MessageBatch> batches = new ArrayList<>();
        
        for (Map.Entry<AccountId, List<MessageRecord>> entry : accountGroups.entrySet()) {
            AccountId accountId = entry.getKey();
            List<MessageRecord> accountMessages = entry.getValue();
            
            // 2. 按消息类型分组
            Map<MessageType, List<MessageRecord>> typeGroups = 
                accountMessages.stream().collect(Collectors.groupingBy(MessageRecord::getMessageType));
            
            for (Map.Entry<MessageType, List<MessageRecord>> typeEntry : typeGroups.entrySet()) {
                MessageType messageType = typeEntry.getKey();
                List<MessageRecord> typeMessages = typeEntry.getValue();
                
                // 3. 创建优化批次
                List<MessageBatch> typeBatches = createOptimizedBatches(
                    accountId, 
                    messageType, 
                    typeMessages
                );
                
                batches.addAll(typeBatches);
            }
        }
        
        return batches;
    }
    
    private int calculateOptimalBatchSize(AccountId accountId, MessageType messageType) {
        // 根据消息类型调整
        int baseSize = switch (messageType) {
            case TEXT -> 50;        // 文本消息批次较大
            case IMAGE -> 20;       // 图片消息批次中等
            case FILE -> 10;        // 文件消息批次较小
            case VIDEO -> 5;        // 视频消息批次最小
            default -> 30;
        };
        
        // 根据账号性能调整
        AccountPerformanceData performance = performanceAnalyzer.getPerformanceData(accountId);
        double performanceFactor = performance.getSuccessRate() * performance.getSpeedFactor();
        
        return Math.max(1, (int) (baseSize * performanceFactor));
    }
}
```

---

## 🔄 重试机制设计

### 1. 自适应重试策略
```java
@Component
public class AdaptiveRetryManager {
    
    /**
     * 计算重试策略
     */
    public RetryPolicy calculateRetryPolicy(MessageRecord message, Exception lastException) {
        MessageId messageId = message.getMessageId();
        
        // 1. 分析历史重试数据
        RetryHistoryAnalysis history = metricsCollector.analyzeRetryHistory(messageId);
        
        // 2. 分析错误类型
        ErrorType errorType = classifyError(lastException);
        
        // 3. 分析账号状态
        AccountStatus accountStatus = getAccountStatus(message.getAccountId());
        
        // 4. 计算重试参数
        RetryParameters parameters = calculateRetryParameters(history, errorType, accountStatus);
        
        // 5. 创建重试策略
        return policyFactory.createPolicy(parameters);
    }
    
    private RetryParameters calculateRetryParameters(
        RetryHistoryAnalysis history,
        ErrorType errorType,
        AccountStatus accountStatus) {
        
        // 基础重试配置
        int maxRetries = 3;
        Duration initialDelay = Duration.ofSeconds(1);
        double backoffMultiplier = 2.0;
        Duration maxDelay = Duration.ofMinutes(10);
        
        // 根据错误类型调整
        switch (errorType) {
            case NETWORK_TIMEOUT:
                maxRetries = 5;
                initialDelay = Duration.ofSeconds(2);
                break;
            case RATE_LIMITED:
                maxRetries = 10;
                initialDelay = Duration.ofMinutes(1);
                backoffMultiplier = 1.5;
                maxDelay = Duration.ofHours(1);
                break;
            case AUTH_FAILED:
                maxRetries = 1;
                initialDelay = Duration.ofMinutes(5);
                break;
            case BUSINESS_ERROR:
                maxRetries = 0; // 业务错误不重试
                break;
        }
        
        return RetryParameters.builder()
            .maxRetries(maxRetries)
            .initialDelay(initialDelay)
            .backoffMultiplier(backoffMultiplier)
            .maxDelay(maxDelay)
            .jitterEnabled(true)
            .build();
    }
}
```

### 2. 重试队列管理
```java
@Component
public class RetryQueueManager {
    
    /**
     * 添加消息到重试队列
     */
    public void addToRetryQueue(MessageRecord message, Duration delay) {
        String retryQueueKey = "message:retry:queue";
        long executeTime = System.currentTimeMillis() + delay.toMillis();
        
        // 序列化消息ID和重试信息
        RetryQueueItem item = RetryQueueItem.builder()
            .messageId(message.getMessageId())
            .accountId(message.getAccountId())
            .retryAttempt(message.getAttempts().getCount())
            .build();
        
        String itemData = JsonUtils.toJson(item);
        
        // 添加到有序集合，按执行时间排序
        redisTemplate.opsForZSet().add(retryQueueKey, itemData, executeTime);
        
        log.info("消息添加到重试队列: {} - 延迟: {}", message.getMessageId(), delay);
    }
    
    /**
     * 处理到期的重试消息
     */
    @Scheduled(fixedDelay = 5000) // 每5秒检查一次
    public void processRetryQueue() {
        String retryQueueKey = "message:retry:queue";
        long currentTime = System.currentTimeMillis();
        
        // 获取到期的重试消息
        Set<ZSetOperations.TypedTuple<String>> expiredItems = 
            redisTemplate.opsForZSet().rangeByScoreWithScores(retryQueueKey, 0, currentTime);
        
        for (ZSetOperations.TypedTuple<String> tuple : expiredItems) {
            String itemData = tuple.getValue();
            
            try {
                // 移除队列中的项
                redisTemplate.opsForZSet().remove(retryQueueKey, itemData);
                
                // 解析重试项
                RetryQueueItem item = JsonUtils.fromJson(itemData, RetryQueueItem.class);
                
                // 执行重试
                executeRetryItem(item);
                
            } catch (Exception e) {
                log.error("处理重试队列项失败: " + itemData, e);
            }
        }
    }
}
```

---

## 🚦 限流控制机制

### 1. 多维度限流器
```java
@Component
public class MultiDimensionalRateLimiter {
    
    /**
     * 账号级别限流
     */
    public boolean tryAcquireForAccount(AccountId accountId, MessageType messageType) {
        String key = "rate_limit:account:" + accountId.getValue();
        
        AccountLimitConfig config = limitConfigService.getAccountLimitConfig(accountId);
        
        return tryAcquire(key, config.getPerSecondLimit(), Duration.ofSeconds(1)) &&
               tryAcquire(key + ":minute", config.getPerMinuteLimit(), Duration.ofMinutes(1)) &&
               tryAcquire(key + ":hour", config.getPerHourLimit(), Duration.ofHours(1)) &&
               tryAcquire(key + ":day", config.getPerDayLimit(), Duration.ofDays(1));
    }
    
    /**
     * 滑动窗口限流算法
     */
    private boolean tryAcquire(String key, int limit, Duration window) {
        if (limit <= 0) {
            return true; // 无限制
        }
        
        long windowStart = System.currentTimeMillis() - window.toMillis();
        long currentTime = System.currentTimeMillis();
        
        // Lua脚本实现原子性滑动窗口限流
        String luaScript = """
            local key = KEYS[1]
            local window_start = ARGV[1]
            local current_time = ARGV[2]
            local limit = tonumber(ARGV[3])
            
            -- 移除过期的请求记录
            redis.call('ZREMRANGEBYSCORE', key, '-inf', window_start)
            
            -- 获取当前窗口内的请求数量
            local current_count = redis.call('ZCARD', key)
            
            if current_count >= limit then
                return 0  -- 限流
            else
                -- 添加当前请求记录
                redis.call('ZADD', key, current_time, current_time)
                return 1  -- 允许
            end
            """;
        
        List<String> keys = Collections.singletonList(key);
        List<String> args = Arrays.asList(
            String.valueOf(windowStart),
            String.valueOf(currentTime),
            String.valueOf(limit)
        );
        
        Long result = redisTemplate.execute(
            (RedisCallback<Long>) connection -> 
                connection.eval(luaScript.getBytes(), ReturnType.INTEGER, 1, 
                               keys.toArray(new String[0]), 
                               args.toArray(new String[0]))
        );
        
        return result != null && result == 1;
    }
}
```

### 2. 流量整形器
```java
@Component
public class TrafficShaper {
    
    /**
     * 流量整形处理
     */
    public void shapeTraffic(List<MessageRecord> messages) {
        // 1. 按优先级分组
        Map<SendPriority, List<MessageRecord>> priorityGroups = 
            messages.stream().collect(Collectors.groupingBy(MessageRecord::getPriority));
        
        // 2. 为每个优先级分配令牌
        for (Map.Entry<SendPriority, List<MessageRecord>> entry : priorityGroups.entrySet()) {
            SendPriority priority = entry.getKey();
            List<MessageRecord> priorityMessages = entry.getValue();
            
            int availableTokens = tokenBucketManager.getAvailableTokens(priority);
            
            // 3. 根据令牌数量决定处理方式
            if (availableTokens >= priorityMessages.size()) {
                // 令牌充足，直接处理
                tokenBucketManager.consumeTokens(priority, priorityMessages.size());
                for (MessageRecord message : priorityMessages) {
                    queueManager.enqueue(message, priority);
                }
            } else {
                // 令牌不足，部分处理，剩余延后
                List<MessageRecord> immediateMessages = priorityMessages.subList(0, availableTokens);
                List<MessageRecord> delayedMessages = priorityMessages.subList(availableTokens, priorityMessages.size());
                
                // 处理有令牌的消息
                if (!immediateMessages.isEmpty()) {
                    tokenBucketManager.consumeTokens(priority, immediateMessages.size());
                    for (MessageRecord message : immediateMessages) {
                        queueManager.enqueue(message, priority);
                    }
                }
                
                // 延迟处理剩余消息
                for (MessageRecord message : delayedMessages) {
                    Duration delay = calculateDelay(priority, message);
                    queueManager.enqueueDelayed(message, delay);
                }
            }
        }
    }
}
```

---

## 📊 监控和指标

### 1. 消息发送指标收集
```java
@Component
public class MessageMetricsCollector {
    
    private final MeterRegistry meterRegistry;
    
    @PostConstruct
    public void initializeMetrics() {
        // 消息发送计数器
        Counter.builder("message.send.total")
            .description("消息发送总数")
            .tag("type", "all")
            .register(meterRegistry);
        
        // 消息发送成功率
        Gauge.builder("message.send.success.rate")
            .description("消息发送成功率")
            .register(meterRegistry, this, MessageMetricsCollector::calculateSuccessRate);
        
        // 队列深度
        Gauge.builder("message.queue.depth")
            .description("消息队列深度")
            .register(meterRegistry, this, MessageMetricsCollector::getQueueDepth);
        
        // 发送延迟
        Timer.builder("message.send.duration")
            .description("消息发送耗时")
            .register(meterRegistry);
    }
    
    public void recordMessageSent(MessageType messageType, boolean success, Duration duration) {
        // 记录发送总数
        Counter.builder("message.send.total")
            .tag("type", messageType.name())
            .tag("status", success ? "success" : "failure")
            .register(meterRegistry)
            .increment();
        
        // 记录发送耗时
        Timer.builder("message.send.duration")
            .tag("type", messageType.name())
            .register(meterRegistry)
            .record(duration);
    }
    
    private double calculateSuccessRate() {
        // 计算最近1小时的成功率
        return messageRepository.calculateSuccessRateInLastHour();
    }
    
    private double getQueueDepth() {
        return messageQueueManager.getTotalQueueDepth();
    }
}
```

---

## 📋 设计总结

### 核心特性
1. **高可靠性**: 消息零丢失保证机制
2. **高性能**: 智能批处理和并发优化
3. **智能调度**: 自适应发送策略
4. **弹性重试**: 多策略重试机制
5. **流量控制**: 多维度限流保护

### 技术亮点
- 🔄 **分布式队列**: 可靠的消息传递
- 📈 **智能调度**: 最优发送策略
- 🚦 **流量控制**: 多维度限流机制
- 🔁 **弹性重试**: 自适应重试策略
- 📊 **实时监控**: 完整的指标体系

### 性能指标
- **吞吐量**: 支持每秒万级消息处理
- **延迟**: P99延迟小于100ms
- **可用性**: 99.9%服务可用性
- **可靠性**: 消息零丢失保证

---

**文档版本**: v1.0  
**创建日期**: 2025-01-27  
**负责人**: 消息发送团队
