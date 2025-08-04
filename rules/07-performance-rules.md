# 🚀 性能优化和监控规则

## 💾 缓存策略规则

### 1. 多级缓存架构
```java
// ✅ 本地缓存配置
@Configuration
@EnableCaching
public class CacheConfig {
    
    @Bean
    public CacheManager localCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .maximumSize(10000)
                .expireAfterWrite(Duration.ofMinutes(30))
                .recordStats());
        return cacheManager;
    }
    
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        
        // 设置序列化器
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
        
        return template;
    }
}

// 缓存使用策略
@Service
@RequiredArgsConstructor
public class ConfigService {
    
    private final ConfigMapper configMapper;
    private final RedisTemplate<String, Object> redisTemplate;
    
    // L1缓存：本地缓存(读频繁的配置)
    @Cacheable(value = "tenant-config", key = "#tenantId", cacheManager = "localCacheManager")
    public TenantConfig getTenantConfig(String tenantId) {
        return configMapper.selectByTenantId(tenantId);
    }
    
    // L2缓存：Redis分布式缓存
    public AccountConfig getAccountConfig(String tenantId, String accountId) {
        String cacheKey = String.format("account:config:%s:%s", tenantId, accountId);
        
        // 先从Redis获取
        AccountConfig config = (AccountConfig) redisTemplate.opsForValue().get(cacheKey);
        if (config != null) {
            return config;
        }
        
        // Redis未命中，查询数据库
        config = configMapper.selectAccountConfig(tenantId, accountId);
        if (config != null) {
            // 写入Redis，设置过期时间
            redisTemplate.opsForValue().set(cacheKey, config, Duration.ofHours(2));
        }
        
        return config;
    }
    
    // 缓存更新策略
    @CacheEvict(value = "tenant-config", key = "#config.tenantId")
    public void updateTenantConfig(TenantConfig config) {
        configMapper.updateByTenantId(config);
        
        // 同时清理相关的二级缓存
        String pattern = String.format("account:config:%s:*", config.getTenantId());
        redisTemplate.delete(redisTemplate.keys(pattern));
    }
}
```

### 2. 缓存预热和更新
```java
// ✅ 缓存预热策略
@Component
@RequiredArgsConstructor
public class CacheWarmupService {
    
    private final ConfigService configService;
    private final TenantService tenantService;
    
    @EventListener(ApplicationReadyEvent.class)
    public void warmupCache() {
        log.info("开始缓存预热...");
        
        // 异步预热，避免阻塞启动
        CompletableFuture.runAsync(this::doWarmup);
    }
    
    private void doWarmup() {
        try {
            // 1. 预热活跃租户配置
            List<String> activeTenants = tenantService.getActiveTenantIds();
            for (String tenantId : activeTenants) {
                configService.getTenantConfig(tenantId);
                Thread.sleep(100); // 避免过快请求
            }
            
            // 2. 预热热点数据
            warmupHotspotData();
            
            log.info("缓存预热完成，预热租户数: {}", activeTenants.size());
            
        } catch (Exception e) {
            log.error("缓存预热失败", e);
        }
    }
    
    private void warmupHotspotData() {
        // 预热系统配置、字典数据等
    }
}

// 缓存刷新策略
@Component
public class CacheRefreshScheduler {
    
    @Scheduled(fixedRate = 300000) // 5分钟刷新一次
    public void refreshHotCache() {
        // 刷新热点数据缓存
    }
    
    @Scheduled(cron = "0 0 2 * * ?") // 每天凌晨2点清理过期缓存
    public void cleanExpiredCache() {
        // 清理过期缓存键
    }
}
```

## 🗄️ 数据库性能优化

### 1. 查询优化
```java
// ✅ 分页查询优化
@Service
public class AccountService {
    
    // 大偏移量优化
    public PageResult<AccountDTO> getAccountsOptimized(String tenantId, int pageNum, int pageSize) {
        // 使用游标分页替代OFFSET
        if (pageNum == 1) {
            return getFirstPageAccounts(tenantId, pageSize);
        } else {
            // 获取上一页最后一条记录的ID
            String lastId = getLastAccountId(tenantId, pageNum - 1, pageSize);
            return getAccountsAfter(tenantId, lastId, pageSize);
        }
    }
    
    private PageResult<AccountDTO> getAccountsAfter(String tenantId, String lastId, int pageSize) {
        List<WeWorkAccount> accounts = accountMapper.selectAfterAccountId(tenantId, lastId, pageSize);
        List<AccountDTO> dtos = accounts.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        
        return PageResult.of(dtos, null, 0, pageSize); // 游标分页不需要总数
    }
    
    // 批量查询优化
    public Map<String, AccountDTO> getAccountsByIds(String tenantId, List<String> accountIds) {
        if (CollectionUtils.isEmpty(accountIds)) {
            return Collections.emptyMap();
        }
        
        // 分批查询，避免IN条件过多
        Map<String, AccountDTO> result = new HashMap<>();
        
        for (List<String> batch : Lists.partition(accountIds, 100)) {
            List<WeWorkAccount> accounts = accountMapper.selectByIds(tenantId, batch);
            accounts.forEach(account -> 
                result.put(account.getId(), convertToDTO(account)));
        }
        
        return result;
    }
    
    // 使用索引优化查询
    public List<AccountDTO> getActiveAccountsByStatus(String tenantId, AccountStatus status) {
        // 确保查询使用了(tenant_id, status, created_at)复合索引
        return accountMapper.selectByTenantAndStatus(tenantId, status)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
}

// MyBatis查询优化
@Mapper
public interface AccountMapper {
    
    // ✅ 使用索引的查询
    @Select("SELECT * FROM wework_accounts " +
            "WHERE tenant_id = #{tenantId} AND status = #{status} " +
            "ORDER BY created_at DESC LIMIT #{limit}")
    List<WeWorkAccount> selectByTenantAndStatus(@Param("tenantId") String tenantId,
                                               @Param("status") AccountStatus status,
                                               @Param("limit") int limit);
    
    // ✅ 游标分页查询
    @Select("SELECT * FROM wework_accounts " +
            "WHERE tenant_id = #{tenantId} AND id > #{lastId} " +
            "ORDER BY id ASC LIMIT #{limit}")
    List<WeWorkAccount> selectAfterAccountId(@Param("tenantId") String tenantId,
                                           @Param("lastId") String lastId,
                                           @Param("limit") int limit);
    
    // ✅ 批量插入优化
    @Insert("<script>" +
            "INSERT INTO wework_accounts (id, tenant_id, account_name, status, created_at) VALUES " +
            "<foreach collection='accounts' item='account' separator=','>" +
            "(#{account.id}, #{account.tenantId}, #{account.accountName}, #{account.status}, #{account.createdAt})" +
            "</foreach>" +
            "</script>")
    int batchInsert(@Param("accounts") List<WeWorkAccount> accounts);
}
```

### 2. 连接池优化
```yaml
# ✅ HikariCP连接池优化配置
spring:
  datasource:
    type: com.zaxxer.hikari.HikariDataSource
    hikari:
      # 连接池大小 = CPU核心数 * 2 + 磁盘数
      maximum-pool-size: 20
      minimum-idle: 5
      # 连接超时时间
      connection-timeout: 30000
      # 连接最大生命周期
      max-lifetime: 1800000
      # 连接空闲超时
      idle-timeout: 600000
      # 连接池名称
      pool-name: WeWorkHikariPool
      # 连接测试查询
      connection-test-query: SELECT 1
      # 连接泄露检测
      leak-detection-threshold: 60000

# 读写分离配置
mybatis-plus:
  configuration:
    # 开启二级缓存
    cache-enabled: true
    # 延迟加载
    lazy-loading-enabled: true
    # 自动映射等级
    auto-mapping-behavior: partial
  global-config:
    # 逻辑删除
    db-config:
      logic-delete-field: deleted_at
      logic-delete-value: now()
      logic-not-delete-value: null
```

## 📊 性能监控规则

### 1. 应用性能监控
```java
// ✅ 性能监控切面
@Aspect
@Component
@RequiredArgsConstructor
public class PerformanceMonitorAspect {
    
    private final MeterRegistry meterRegistry;
    
    @Around("@annotation(PerformanceMonitor)")
    public Object monitor(ProceedingJoinPoint point, PerformanceMonitor annotation) throws Throwable {
        String methodName = point.getSignature().getName();
        String className = point.getTarget().getClass().getSimpleName();
        String operationName = className + "." + methodName;
        
        Timer.Sample sample = Timer.start(meterRegistry);
        
        try {
            Object result = point.proceed();
            
            // 记录成功指标
            Counter.builder("method.execution.total")
                    .tag("class", className)
                    .tag("method", methodName)
                    .tag("status", "success")
                    .register(meterRegistry)
                    .increment();
            
            return result;
            
        } catch (Exception e) {
            // 记录异常指标
            Counter.builder("method.execution.total")
                    .tag("class", className)
                    .tag("method", methodName)
                    .tag("status", "error")
                    .tag("exception", e.getClass().getSimpleName())
                    .register(meterRegistry)
                    .increment();
            
            throw e;
            
        } finally {
            // 记录执行时间
            Timer timer = Timer.builder("method.execution.duration")
                    .tag("operation", operationName)
                    .description("Method execution time")
                    .register(meterRegistry);
            sample.stop(timer);
            
            // 慢方法告警
            long duration = timer.totalTime(TimeUnit.MILLISECONDS);
            if (duration > annotation.slowThreshold()) {
                log.warn("慢方法告警: {} 执行时间: {}ms", operationName, duration);
            }
        }
    }
}

// 性能监控注解
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface PerformanceMonitor {
    long slowThreshold() default 1000; // 慢方法阈值(毫秒)
}

// 自定义性能指标
@Component
@RequiredArgsConstructor
public class CustomMetrics {
    
    private final MeterRegistry meterRegistry;
    private final AtomicLong activeConnections = new AtomicLong(0);
    
    @PostConstruct
    public void initMetrics() {
        // 活跃连接数
        Gauge.builder("app.connections.active")
                .description("Active database connections")
                .register(meterRegistry, activeConnections, AtomicLong::get);
        
        // JVM内存使用率
        Gauge.builder("app.memory.usage.ratio")
                .description("JVM memory usage ratio")
                .register(meterRegistry, this, CustomMetrics::getMemoryUsageRatio);
    }
    
    private double getMemoryUsageRatio() {
        Runtime runtime = Runtime.getRuntime();
        long total = runtime.totalMemory();
        long free = runtime.freeMemory();
        return (double) (total - free) / total;
    }
    
    public void incrementActiveConnections() {
        activeConnections.incrementAndGet();
    }
    
    public void decrementActiveConnections() {
        activeConnections.decrementAndGet();
    }
}
```

### 2. 数据库性能监控
```java
// ✅ SQL执行监控
@Component
public class SqlPerformanceInterceptor implements Interceptor {
    
    private final Timer.Builder sqlTimerBuilder;
    private final Counter.Builder slowSqlCounter;
    
    public SqlPerformanceInterceptor(MeterRegistry meterRegistry) {
        this.sqlTimerBuilder = Timer.builder("sql.execution.duration")
                .description("SQL execution time");
        this.slowSqlCounter = Counter.builder("sql.slow.total")
                .description("Slow SQL count");
    }
    
    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        try {
            Object result = invocation.proceed();
            
            long duration = System.currentTimeMillis() - startTime;
            String sqlType = getSqlType(invocation);
            
            // 记录SQL执行时间
            sqlTimerBuilder.tag("type", sqlType)
                    .register(Metrics.globalRegistry)
                    .record(duration, TimeUnit.MILLISECONDS);
            
            // 慢SQL告警
            if (duration > 1000) {
                String sql = getSql(invocation);
                log.warn("慢SQL告警: 执行时间{}ms, SQL: {}", duration, sql);
                
                slowSqlCounter.tag("type", sqlType)
                        .register(Metrics.globalRegistry)
                        .increment();
            }
            
            return result;
            
        } catch (Exception e) {
            log.error("SQL执行异常", e);
            throw e;
        }
    }
    
    private String getSqlType(Invocation invocation) {
        MappedStatement ms = (MappedStatement) invocation.getArgs()[0];
        return ms.getSqlCommandType().name().toLowerCase();
    }
}
```

## 🔄 异步处理优化

### 1. 线程池配置
```java
// ✅ 线程池配置
@Configuration
@EnableAsync
public class AsyncConfig {
    
    @Bean("taskExecutor")
    public TaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        
        // 核心线程数 = CPU核心数
        executor.setCorePoolSize(Runtime.getRuntime().availableProcessors());
        // 最大线程数 = CPU核心数 * 2
        executor.setMaxPoolSize(Runtime.getRuntime().availableProcessors() * 2);
        // 队列容量
        executor.setQueueCapacity(200);
        // 线程名前缀
        executor.setThreadNamePrefix("task-executor-");
        // 拒绝策略：调用者运行
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 等待所有任务完成后关闭
        executor.setWaitForTasksToCompleteOnShutdown(true);
        // 等待时间
        executor.setAwaitTerminationSeconds(60);
        
        executor.initialize();
        return executor;
    }
    
    @Bean("messageExecutor")
    public TaskExecutor messageExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        
        // 消息发送专用线程池
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(1000);
        executor.setThreadNamePrefix("message-executor-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        
        executor.initialize();
        return executor;
    }
}

// 异步任务监控
@Component
@RequiredArgsConstructor
public class AsyncTaskMonitor {
    
    private final ThreadPoolTaskExecutor taskExecutor;
    private final MeterRegistry meterRegistry;
    
    @PostConstruct
    public void initMonitor() {
        // 监控线程池状态
        Gauge.builder("thread.pool.active")
                .description("Active threads in pool")
                .register(meterRegistry, taskExecutor, ThreadPoolTaskExecutor::getActiveCount);
        
        Gauge.builder("thread.pool.size")
                .description("Current pool size")
                .register(meterRegistry, taskExecutor, ThreadPoolTaskExecutor::getPoolSize);
        
        Gauge.builder("thread.pool.queue.size")
                .description("Queue size")
                .register(meterRegistry, taskExecutor, 
                         exec -> exec.getThreadPoolExecutor().getQueue().size());
    }
}
```

### 2. 异步任务实现
```java
// ✅ 异步任务最佳实践
@Service
@RequiredArgsConstructor
public class MessageService {
    
    @Async("messageExecutor")
    public CompletableFuture<BatchSendResult> batchSendMessagesAsync(String tenantId, 
                                                                   List<SendMessageRequest> requests) {
        try {
            BatchSendResult result = new BatchSendResult();
            
            // 并行发送，控制并发数
            List<CompletableFuture<MessageSendResult>> futures = requests.stream()
                    .map(request -> sendMessageAsync(tenantId, request))
                    .collect(Collectors.toList());
            
            // 等待所有任务完成
            CompletableFuture<Void> allOf = CompletableFuture.allOf(
                    futures.toArray(new CompletableFuture[0]));
            
            allOf.join();
            
            // 收集结果
            for (CompletableFuture<MessageSendResult> future : futures) {
                MessageSendResult messageResult = future.get();
                if (messageResult.isSuccess()) {
                    result.addSuccess(messageResult);
                } else {
                    result.addFailure(messageResult);
                }
            }
            
            return CompletableFuture.completedFuture(result);
            
        } catch (Exception e) {
            log.error("批量发送消息失败, tenantId={}", tenantId, e);
            return CompletableFuture.failedFuture(e);
        }
    }
    
    @Async("messageExecutor")
    public CompletableFuture<MessageSendResult> sendMessageAsync(String tenantId, 
                                                               SendMessageRequest request) {
        try {
            // 限流控制
            if (!rateLimitService.allowRequest("message:" + tenantId, 100, Duration.ofMinutes(1))) {
                return CompletableFuture.completedFuture(
                    MessageSendResult.failure("RATE_LIMITED", "发送频率过快"));
            }
            
            MessageSendResult result = doSendMessage(tenantId, request);
            return CompletableFuture.completedFuture(result);
            
        } catch (Exception e) {
            log.error("发送消息失败, tenantId={}, request={}", tenantId, request, e);
            return CompletableFuture.completedFuture(
                MessageSendResult.failure("SEND_ERROR", e.getMessage()));
        }
    }
}
```

**规则总结**:
- 实现多级缓存架构，本地缓存+Redis分布式缓存
- 数据库查询优化：使用索引、游标分页、批量操作
- 配置合适的连接池参数，避免连接泄露
- 全面的性能监控：方法执行时间、SQL性能、线程池状态
- 合理使用异步处理，配置专用线程池
- 定期进行性能分析和优化