# 👥 客户管理模块详细设计
*WeWork Management Platform - Customer Management Module Design*

## 📖 文档目录

1. [模块概述](#模块概述)
2. [客户360度视图](#客户360度视图)
3. [智能标签系统](#智能标签系统)
4. [动态分群管理](#动态分群管理)
5. [行为分析引擎](#行为分析引擎)
6. [生命周期管理](#生命周期管理)
7. [价值评估体系](#价值评估体系)
8. [精准营销支持](#精准营销支持)
9. [数据隐私保护](#数据隐私保护)
10. [性能优化方案](#性能优化方案)

---

## 🎯 模块概述

### 业务职责
客户管理模块提供完整的客户全生命周期管理，通过360度客户视图、智能标签系统、动态分群和行为分析，帮助企业深度了解客户，实现精准营销和个性化服务。

```yaml
核心职责:
  - 客户档案统一管理
  - 行为轨迹实时追踪
  - 智能标签自动分配
  - 动态分群实时计算
  - 客户价值评估

业务价值:
  - 客户洞察: 深度了解客户需求和偏好
  - 精准营销: 基于分群的精准营销策略
  - 服务优化: 个性化服务提升客户体验
  - 收益增长: 提升客户生命周期价值
```

### 技术架构
```yaml
架构模式:
  - 领域驱动设计(DDD): 客户领域建模
  - 事件驱动架构: 行为事件实时处理
  - CQRS模式: 读写分离优化查询
  - 流式计算: 实时行为分析

核心组件:
  - CustomerDomainService: 客户领域服务
  - BehaviorAnalysisEngine: 行为分析引擎
  - TaggingEngine: 智能标签引擎
  - SegmentationEngine: 分群计算引擎
  - ValueAssessmentService: 价值评估服务
  - PrivacyProtectionService: 隐私保护服务
```

---

## 🎭 客户360度视图

### 客户档案模型

```java
@Entity
@Table(name = "customers")
public class Customer {
    private String id;
    private String tenantId;
    private String customerCode;
    
    // 基本信息
    private PersonalInfo personalInfo;
    private List<ContactInfo> contactInfos;
    private List<Address> addresses;
    
    // 身份特征
    private CustomerType customerType;
    private CustomerLevel customerLevel;
    private CustomerStatus status;
    private LifecycleStage lifecycleStage;
    
    // 偏好设置
    private CustomerPreferences preferences;
    private Map<String, Object> customAttributes;
    
    // 统计信息
    private CustomerStatistics statistics;
    private BigDecimal totalSpent;
    private Integer orderCount;
    private LocalDateTime lastActivityAt;
    private LocalDateTime lastOrderAt;
    
    // 评估信息
    private BigDecimal lifetimeValue;
    private BigDecimal creditScore;
    private Double loyaltyScore;
    private RiskLevel riskLevel;
    
    public Customer360View build360View() {
        return Customer360View.builder()
            .basicProfile(buildBasicProfile())
            .behaviorProfile(buildBehaviorProfile())
            .transactionProfile(buildTransactionProfile())
            .preferenceProfile(buildPreferenceProfile())
            .valueProfile(buildValueProfile())
            .riskProfile(buildRiskProfile())
            .build();
    }
    
    public void updateLifecycleStage() {
        LifecycleStage newStage = LifecycleStageCalculator.calculate(this);
        if (newStage != this.lifecycleStage) {
            LifecycleStage oldStage = this.lifecycleStage;
            this.lifecycleStage = newStage;
            
            // 发布生命周期变更事件
            DomainEventPublisher.publish(
                new CustomerLifecycleChangedEvent(this, oldStage, newStage)
            );
        }
    }
}
```

### 客户档案聚合

```java
@Service
public class Customer360Service {
    
    public Customer360View getCustomer360View(String customerId) {
        // 基础档案信息
        Customer customer = customerRepository.findById(customerId);
        
        // 并行获取各维度数据
        CompletableFuture<List<CustomerBehavior>> behaviorsFuture = 
            CompletableFuture.supplyAsync(() -> behaviorService.getCustomerBehaviors(customerId));
            
        CompletableFuture<List<Order>> ordersFuture = 
            CompletableFuture.supplyAsync(() -> orderService.getCustomerOrders(customerId));
            
        CompletableFuture<List<CustomerTag>> tagsFuture = 
            CompletableFuture.supplyAsync(() -> tagService.getCustomerTags(customerId));
            
        CompletableFuture<List<MarketingInteraction>> interactionsFuture = 
            CompletableFuture.supplyAsync(() -> marketingService.getCustomerInteractions(customerId));
        
        // 等待所有数据加载完成
        CompletableFuture.allOf(behaviorsFuture, ordersFuture, tagsFuture, interactionsFuture).join();
        
        // 构建360度视图
        return Customer360View.builder()
            .customer(customer)
            .behaviors(behaviorsFuture.join())
            .orders(ordersFuture.join())
            .tags(tagsFuture.join())
            .marketingInteractions(interactionsFuture.join())
            .insights(generateCustomerInsights(customer))
            .recommendations(generateRecommendations(customer))
            .build();
    }
    
    private CustomerInsights generateCustomerInsights(Customer customer) {
        return CustomerInsights.builder()
            .behaviorPatterns(analyzeBehaviorPatterns(customer))
            .purchasePatterns(analyzePurchasePatterns(customer))
            .channelPreferences(analyzeChannelPreferences(customer))
            .seasonalTrends(analyzeSeasonalTrends(customer))
            .riskFactors(analyzeRiskFactors(customer))
            .growthPotential(assessGrowthPotential(customer))
            .build();
    }
}
```

---

## 🏷️ 智能标签系统

### 标签规则引擎

```java
@Entity
@Table(name = "customer_tag_definitions")
public class CustomerTagDefinition {
    private String id;
    private String tenantId;
    private String tagCode;
    private String tagName;
    private String description;
    private TagCategory category;
    private TagType tagType;
    
    // 规则配置
    private TagRule rule;
    private String ruleExpression;
    private Map<String, Object> ruleParameters;
    
    // 执行配置
    private Boolean autoAssign;
    private String cronExpression;
    private Integer priority;
    private Boolean enabled;
    
    // 统计信息
    private Integer customerCount;
    private LocalDateTime lastExecutedAt;
    
    public boolean matches(Customer customer) {
        return rule.evaluate(customer, ruleParameters);
    }
}

public interface TagRule {
    boolean evaluate(Customer customer, Map<String, Object> parameters);
    String getDescription();
}

@Component
public class PurchaseAmountRule implements TagRule {
    
    @Override
    public boolean evaluate(Customer customer, Map<String, Object> parameters) {
        BigDecimal minAmount = (BigDecimal) parameters.get("minAmount");
        BigDecimal maxAmount = (BigDecimal) parameters.get("maxAmount");
        Integer days = (Integer) parameters.get("days");
        
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        BigDecimal totalSpent = orderService.getTotalSpentByCustomer(
            customer.getId(), startDate, LocalDateTime.now()
        );
        
        boolean meetsMin = minAmount == null || totalSpent.compareTo(minAmount) >= 0;
        boolean meetsMax = maxAmount == null || totalSpent.compareTo(maxAmount) <= 0;
        
        return meetsMin && meetsMax;
    }
    
    @Override
    public String getDescription() {
        return "基于购买金额的标签规则";
    }
}
```

### 智能标签引擎

```java
@Service
public class TaggingEngine {
    
    @Scheduled(fixedRate = 300000) // 每5分钟执行
    public void executeAutoTagging() {
        List<CustomerTagDefinition> autoTags = tagDefinitionRepository.findByAutoAssignTrue();
        
        for (CustomerTagDefinition tagDef : autoTags) {
            if (shouldExecuteTagging(tagDef)) {
                executeTagging(tagDef);
            }
        }
    }
    
    @Async
    public void executeTagging(CustomerTagDefinition tagDefinition) {
        // 批量处理客户
        int batchSize = 1000;
        int offset = 0;
        
        while (true) {
            List<Customer> customers = customerRepository.findActivePaged(offset, batchSize);
            if (customers.isEmpty()) {
                break;
            }
            
            List<CustomerTag> newTags = new ArrayList<>();
            List<String> removeTags = new ArrayList<>();
            
            for (Customer customer : customers) {
                boolean shouldHaveTag = tagDefinition.matches(customer);
                boolean currentlyHasTag = hasTag(customer.getId(), tagDefinition.getId());
                
                if (shouldHaveTag && !currentlyHasTag) {
                    // 添加标签
                    CustomerTag tag = CustomerTag.builder()
                        .customerId(customer.getId())
                        .tagDefinitionId(tagDefinition.getId())
                        .assignedAt(LocalDateTime.now())
                        .assignedBy("SYSTEM")
                        .autoAssigned(true)
                        .build();
                    newTags.add(tag);
                    
                } else if (!shouldHaveTag && currentlyHasTag) {
                    // 移除标签
                    removeTags.add(customer.getId());
                }
            }
            
            // 批量更新标签
            if (!newTags.isEmpty()) {
                customerTagRepository.saveAll(newTags);
            }
            
            if (!removeTags.isEmpty()) {
                customerTagRepository.removeTagsFromCustomers(
                    removeTags, tagDefinition.getId()
                );
            }
            
            offset += batchSize;
        }
        
        // 更新标签统计
        updateTagStatistics(tagDefinition);
    }
    
    public TagSuggestionResult suggestTags(String customerId) {
        Customer customer = customerRepository.findById(customerId);
        
        // 基于行为模式推荐标签
        List<TagSuggestion> behaviorBasedTags = suggestTagsBasedOnBehavior(customer);
        
        // 基于相似客户推荐标签
        List<TagSuggestion> similarCustomerTags = suggestTagsBasedOnSimilarCustomers(customer);
        
        // 基于机器学习模型推荐标签
        List<TagSuggestion> mlBasedTags = suggestTagsBasedOnML(customer);
        
        return TagSuggestionResult.builder()
            .customerId(customerId)
            .behaviorBasedSuggestions(behaviorBasedTags)
            .similarCustomerSuggestions(similarCustomerTags)
            .mlBasedSuggestions(mlBasedTags)
            .build();
    }
}
```

---

## 📊 动态分群管理

### 分群定义模型

```java
@Entity
@Table(name = "customer_segments")
public class CustomerSegment {
    private String id;
    private String tenantId;
    private String segmentCode;
    private String segmentName;
    private String description;
    private SegmentType segmentType;
    
    // 分群条件
    private SegmentCondition condition;
    private String conditionExpression;
    private Map<String, Object> conditionParameters;
    
    // 计算配置
    private Boolean realTimeUpdate;
    private String cronExpression;
    private Integer maxSize;
    private Integer ttlHours;
    
    // 统计信息
    private Integer memberCount;
    private LocalDateTime lastCalculatedAt;
    private LocalDateTime lastUpdatedAt;
    
    // 业务属性
    private Boolean marketingEnabled;
    private List<String> availableChannels;
    private Map<String, Object> marketingAttributes;
    
    public boolean matches(Customer customer) {
        return condition.evaluate(customer, conditionParameters);
    }
}

public interface SegmentCondition {
    boolean evaluate(Customer customer, Map<String, Object> parameters);
    Set<String> getRequiredData();
    String getDescription();
}

@Component
public class CompositeSegmentCondition implements SegmentCondition {
    
    @Override
    public boolean evaluate(Customer customer, Map<String, Object> parameters) {
        List<SegmentCondition> conditions = (List<SegmentCondition>) parameters.get("conditions");
        String operator = (String) parameters.get("operator");
        
        if ("AND".equals(operator)) {
            return conditions.stream().allMatch(c -> c.evaluate(customer, parameters));
        } else if ("OR".equals(operator)) {
            return conditions.stream().anyMatch(c -> c.evaluate(customer, parameters));
        }
        
        return false;
    }
}
```

### 分群计算引擎

```java
@Service
public class SegmentationEngine {
    
    @Scheduled(fixedRate = 600000) // 每10分钟执行
    public void calculateSegments() {
        List<CustomerSegment> segments = segmentRepository.findActiveSegments();
        
        for (CustomerSegment segment : segments) {
            if (shouldRecalculate(segment)) {
                calculateSegmentAsync(segment);
            }
        }
    }
    
    @Async
    public void calculateSegmentAsync(CustomerSegment segment) {
        SegmentCalculationContext context = SegmentCalculationContext.builder()
            .segment(segment)
            .startTime(LocalDateTime.now())
            .build();
        
        try {
            if (segment.getRealTimeUpdate()) {
                calculateIncrementalSegment(segment, context);
            } else {
                calculateFullSegment(segment, context);
            }
            
            recordCalculationSuccess(context);
            
        } catch (Exception e) {
            recordCalculationFailure(context, e);
            throw e;
        }
    }
    
    private void calculateFullSegment(CustomerSegment segment, SegmentCalculationContext context) {
        // 获取所有活跃客户
        List<String> allCustomers = customerRepository.findAllActiveCustomerIds();
        
        // 并行计算分群成员
        List<String> segmentMembers = allCustomers.parallelStream()
            .filter(customerId -> {
                Customer customer = customerRepository.findById(customerId);
                return segment.matches(customer);
            })
            .limit(segment.getMaxSize())
            .collect(Collectors.toList());
        
        // 更新分群成员
        updateSegmentMembers(segment.getId(), segmentMembers);
        
        // 更新统计信息
        segment.setMemberCount(segmentMembers.size());
        segment.setLastCalculatedAt(context.getStartTime());
        segmentRepository.save(segment);
        
        // 发布分群更新事件
        eventPublisher.publishEvent(new SegmentUpdatedEvent(segment, segmentMembers));
    }
    
    private void calculateIncrementalSegment(CustomerSegment segment, SegmentCalculationContext context) {
        // 获取自上次计算以来发生变化的客户
        LocalDateTime lastCalculated = segment.getLastCalculatedAt();
        List<String> changedCustomers = customerRepository.findChangedCustomers(lastCalculated);
        
        Set<String> currentMembers = new HashSet<>(
            segmentMemberRepository.findMemberIds(segment.getId())
        );
        
        Set<String> newMembers = new HashSet<>();
        Set<String> removedMembers = new HashSet<>();
        
        for (String customerId : changedCustomers) {
            Customer customer = customerRepository.findById(customerId);
            boolean shouldBeMember = segment.matches(customer);
            boolean currentlyMember = currentMembers.contains(customerId);
            
            if (shouldBeMember && !currentlyMember) {
                newMembers.add(customerId);
            } else if (!shouldBeMember && currentlyMember) {
                removedMembers.add(customerId);
            }
        }
        
        // 批量更新成员关系
        if (!newMembers.isEmpty()) {
            addSegmentMembers(segment.getId(), newMembers);
        }
        
        if (!removedMembers.isEmpty()) {
            removeSegmentMembers(segment.getId(), removedMembers);
        }
        
        // 更新计数
        int memberCount = currentMembers.size() + newMembers.size() - removedMembers.size();
        segment.setMemberCount(memberCount);
        segment.setLastCalculatedAt(context.getStartTime());
        segmentRepository.save(segment);
    }
    
    public SegmentInsightReport generateSegmentInsight(String segmentId) {
        CustomerSegment segment = segmentRepository.findById(segmentId);
        List<String> memberIds = segmentMemberRepository.findMemberIds(segmentId);
        
        // 并行分析分群特征
        CompletableFuture<DemographicProfile> demographicsFuture = 
            CompletableFuture.supplyAsync(() -> analyzeDemographics(memberIds));
            
        CompletableFuture<BehaviorProfile> behaviorFuture = 
            CompletableFuture.supplyAsync(() -> analyzeBehavior(memberIds));
            
        CompletableFuture<TransactionProfile> transactionFuture = 
            CompletableFuture.supplyAsync(() -> analyzeTransactions(memberIds));
        
        // 等待分析完成
        CompletableFuture.allOf(demographicsFuture, behaviorFuture, transactionFuture).join();
        
        return SegmentInsightReport.builder()
            .segment(segment)
            .memberCount(memberIds.size())
            .demographicProfile(demographicsFuture.join())
            .behaviorProfile(behaviorFuture.join())
            .transactionProfile(transactionFuture.join())
            .recommendations(generateSegmentRecommendations(segment, memberIds))
            .build();
    }
}
```

---

## 📈 行为分析引擎

### 行为事件模型

```java
@Entity
@Table(name = "customer_behavior_events")
@PartitionKey("event_date")
public class CustomerBehaviorEvent {
    private String id;
    private String tenantId;
    private String customerId;
    private String sessionId;
    
    // 事件信息
    private String eventType;
    private String eventCategory;
    private String eventAction;
    private String eventLabel;
    private Map<String, Object> eventProperties;
    
    // 上下文信息
    private String channel;
    private String source;
    private String medium;
    private String campaign;
    private String deviceType;
    private String userAgent;
    private String ipAddress;
    private String location;
    
    // 时间信息
    private LocalDateTime eventTime;
    private LocalDate eventDate;
    private Integer eventHour;
    
    // 业务信息
    private String objectType;
    private String objectId;
    private BigDecimal value;
    private String currency;
    
    public BehaviorEventEnriched enrich() {
        return BehaviorEventEnriched.builder()
            .baseEvent(this)
            .timeAnalysis(analyzeTime())
            .locationAnalysis(analyzeLocation())
            .sessionAnalysis(analyzeSession())
            .valueAnalysis(analyzeValue())
            .build();
    }
}
```

### 行为分析引擎

```java
@Service
public class BehaviorAnalysisEngine {
    
    @EventListener
    @Async
    public void processBehaviorEvent(CustomerBehaviorEvent event) {
        // 实时行为处理
        processRealTimeBehavior(event);
        
        // 更新行为统计
        updateBehaviorStatistics(event);
        
        // 触发行为规则
        triggerBehaviorRules(event);
        
        // 更新客户画像
        updateCustomerProfile(event);
    }
    
    private void processRealTimeBehavior(CustomerBehaviorEvent event) {
        // 检测异常行为
        if (isAnomalousBehavior(event)) {
            handleAnomalousBehavior(event);
        }
        
        // 实时推荐更新
        if (isRecommendationTrigger(event)) {
            updateRealtimeRecommendations(event.getCustomerId());
        }
        
        // 营销触发器
        if (isMarketingTrigger(event)) {
            triggerMarketingAction(event);
        }
    }
    
    public CustomerBehaviorProfile buildBehaviorProfile(String customerId, LocalDate fromDate, LocalDate toDate) {
        List<CustomerBehaviorEvent> events = behaviorRepository
            .findByCustomerAndDateRange(customerId, fromDate, toDate);
        
        return CustomerBehaviorProfile.builder()
            .customerId(customerId)
            .analysisTimeRange(DateRange.of(fromDate, toDate))
            .channelUsage(analyzeChannelUsage(events))
            .activityPatterns(analyzeActivityPatterns(events))
            .engagementMetrics(calculateEngagementMetrics(events))
            .conversionFunnel(analyzeConversionFunnel(events))
            .sessionAnalysis(analyzeSessionBehavior(events))
            .loyaltyIndicators(calculateLoyaltyIndicators(events))
            .riskIndicators(calculateRiskIndicators(events))
            .build();
    }
    
    private ChannelUsageAnalysis analyzeChannelUsage(List<CustomerBehaviorEvent> events) {
        Map<String, Long> channelCounts = events.stream()
            .collect(Collectors.groupingBy(
                CustomerBehaviorEvent::getChannel,
                Collectors.counting()
            ));
        
        Map<String, Double> channelPreferences = channelCounts.entrySet().stream()
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                entry -> entry.getValue().doubleValue() / events.size()
            ));
        
        String primaryChannel = channelCounts.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("unknown");
        
        return ChannelUsageAnalysis.builder()
            .totalEvents(events.size())
            .channelDistribution(channelPreferences)
            .primaryChannel(primaryChannel)
            .channelDiversity(channelCounts.size())
            .build();
    }
    
    public BehaviorPredictionResult predictBehavior(String customerId, String eventType, int days) {
        // 获取历史行为数据
        List<CustomerBehaviorEvent> historicalEvents = behaviorRepository
            .findByCustomerAndEventType(customerId, eventType, LocalDate.now().minusDays(90));
        
        if (historicalEvents.size() < 10) {
            return BehaviorPredictionResult.insufficientData();
        }
        
        // 构建时间序列
        Map<LocalDate, Long> dailyCounts = historicalEvents.stream()
            .collect(Collectors.groupingBy(
                CustomerBehaviorEvent::getEventDate,
                Collectors.counting()
            ));
        
        // 简单的趋势预测（可替换为更复杂的ML模型）
        double trend = calculateTrend(dailyCounts);
        double seasonality = calculateSeasonality(dailyCounts);
        double baseline = calculateBaseline(dailyCounts);
        
        double predictedFrequency = Math.max(0, baseline + trend * days + seasonality);
        double confidence = calculatePredictionConfidence(historicalEvents);
        
        return BehaviorPredictionResult.builder()
            .customerId(customerId)
            .eventType(eventType)
            .predictionDays(days)
            .predictedFrequency(predictedFrequency)
            .confidence(confidence)
            .factors(Arrays.asList(
                "trend: " + trend,
                "seasonality: " + seasonality,
                "baseline: " + baseline
            ))
            .build();
    }
}
```

---

## 🔄 生命周期管理

### 客户生命周期阶段

```java
public enum LifecycleStage {
    PROSPECT("潜在客户", "尚未产生首次购买"),
    NEW_CUSTOMER("新客户", "首次购买后30天内"),
    ACTIVE_CUSTOMER("活跃客户", "近30天内有活动"),
    LOYAL_CUSTOMER("忠诚客户", "重复购买且高满意度"),
    AT_RISK("流失风险", "90天内无活动"),
    DORMANT("休眠客户", "180天内无活动"),
    CHURNED("已流失", "365天内无活动"),
    REACTIVATED("重新激活", "休眠后重新活跃");
    
    private final String displayName;
    private final String description;
}

@Component
public class LifecycleStageCalculator {
    
    public static LifecycleStage calculate(Customer customer) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime lastActivity = customer.getLastActivityAt();
        LocalDateTime lastOrder = customer.getLastOrderAt();
        Integer orderCount = customer.getOrderCount();
        
        // 从未下单
        if (orderCount == 0) {
            return LifecycleStage.PROSPECT;
        }
        
        // 首次下单30天内
        if (lastOrder != null && lastOrder.isAfter(now.minusDays(30)) && orderCount == 1) {
            return LifecycleStage.NEW_CUSTOMER;
        }
        
        // 活动时间判断
        if (lastActivity == null) {
            return LifecycleStage.CHURNED;
        }
        
        long daysSinceLastActivity = ChronoUnit.DAYS.between(lastActivity, now);
        
        if (daysSinceLastActivity > 365) {
            return LifecycleStage.CHURNED;
        } else if (daysSinceLastActivity > 180) {
            return LifecycleStage.DORMANT;
        } else if (daysSinceLastActivity > 90) {
            return LifecycleStage.AT_RISK;
        }
        
        // 忠诚客户判断
        if (orderCount >= 5 && customer.getLoyaltyScore() > 0.8) {
            return LifecycleStage.LOYAL_CUSTOMER;
        }
        
        // 重新激活判断
        if (wasInDormantOrChurnedStage(customer) && daysSinceLastActivity <= 30) {
            return LifecycleStage.REACTIVATED;
        }
        
        return LifecycleStage.ACTIVE_CUSTOMER;
    }
}
```

### 生命周期自动化

```java
@Service
public class CustomerLifecycleAutomation {
    
    @EventListener
    public void handleLifecycleStageChange(CustomerLifecycleChangedEvent event) {
        Customer customer = event.getCustomer();
        LifecycleStage newStage = event.getNewStage();
        LifecycleStage oldStage = event.getOldStage();
        
        // 记录生命周期历史
        recordLifecycleHistory(customer, oldStage, newStage);
        
        // 触发对应的自动化流程
        switch (newStage) {
            case NEW_CUSTOMER:
                triggerNewCustomerWelcome(customer);
                break;
            case AT_RISK:
                triggerRetentionCampaign(customer);
                break;
            case DORMANT:
                triggerReactivationCampaign(customer);
                break;
            case CHURNED:
                triggerWinbackCampaign(customer);
                break;
            case LOYAL_CUSTOMER:
                triggerLoyaltyRewards(customer);
                break;
        }
        
        // 更新客户标签
        updateLifecycleTags(customer, newStage);
        
        // 调整营销策略
        adjustMarketingStrategy(customer, newStage);
    }
    
    private void triggerRetentionCampaign(Customer customer) {
        RetentionCampaign campaign = RetentionCampaign.builder()
            .customerId(customer.getId())
            .campaignType("RETENTION")
            .priority(Priority.HIGH)
            .channels(determineOptimalChannels(customer))
            .content(generateRetentionContent(customer))
            .incentives(generateRetentionIncentives(customer))
            .build();
        
        marketingService.launchCampaign(campaign);
    }
    
    @Scheduled(cron = "0 0 2 * * ?") // 每天凌晨2点执行
    public void dailyLifecycleAssessment() {
        // 批量重新评估生命周期阶段
        List<Customer> customers = customerRepository.findNeedsLifecycleReassessment();
        
        customers.parallelStream().forEach(customer -> {
            LifecycleStage currentStage = customer.getLifecycleStage();
            LifecycleStage calculatedStage = LifecycleStageCalculator.calculate(customer);
            
            if (currentStage != calculatedStage) {
                customer.updateLifecycleStage();
                customerRepository.save(customer);
            }
        });
    }
}
```

---

## 💎 价值评估体系

### 客户价值模型

```java
@Service
public class CustomerValueAssessmentService {
    
    public CustomerValueAssessment assessCustomerValue(String customerId) {
        Customer customer = customerRepository.findById(customerId);
        
        // 历史价值计算
        BigDecimal historicalValue = calculateHistoricalValue(customer);
        
        // 当前价值计算
        BigDecimal currentValue = calculateCurrentValue(customer);
        
        // 预测价值计算
        BigDecimal predictedValue = calculatePredictedValue(customer);
        
        // 综合评分
        CustomerValueScore valueScore = calculateValueScore(customer);
        
        return CustomerValueAssessment.builder()
            .customerId(customerId)
            .assessmentDate(LocalDateTime.now())
            .historicalValue(historicalValue)
            .currentValue(currentValue)
            .predictedLifetimeValue(predictedValue)
            .valueScore(valueScore)
            .valueSegment(determineValueSegment(valueScore))
            .recommendations(generateValueRecommendations(customer, valueScore))
            .build();
    }
    
    private BigDecimal calculatePredictedValue(Customer customer) {
        // 基于RFM模型和机器学习的价值预测
        RFMAnalysis rfm = calculateRFM(customer);
        
        // 获取相似客户的价值数据
        List<Customer> similarCustomers = findSimilarCustomers(customer);
        
        // 计算平均生命周期价值
        BigDecimal avgLifetimeValue = similarCustomers.stream()
            .map(Customer::getLifetimeValue)
            .filter(Objects::nonNull)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .divide(BigDecimal.valueOf(similarCustomers.size()), RoundingMode.HALF_UP);
        
        // 根据客户特征调整预测值
        BigDecimal adjustmentFactor = calculateAdjustmentFactor(customer, rfm);
        
        return avgLifetimeValue.multiply(adjustmentFactor);
    }
    
    private CustomerValueScore calculateValueScore(Customer customer) {
        // RFM分析
        RFMAnalysis rfm = calculateRFM(customer);
        
        // 行为价值评分
        double behaviorScore = calculateBehaviorScore(customer);
        
        // 忠诚度评分
        double loyaltyScore = customer.getLoyaltyScore();
        
        // 推荐价值评分
        double referralScore = calculateReferralScore(customer);
        
        // 综合评分（加权平均）
        double totalScore = rfm.getCompositeScore() * 0.4 +
                           behaviorScore * 0.3 +
                           loyaltyScore * 0.2 +
                           referralScore * 0.1;
        
        return CustomerValueScore.builder()
            .rfmScore(rfm.getCompositeScore())
            .behaviorScore(behaviorScore)
            .loyaltyScore(loyaltyScore)
            .referralScore(referralScore)
            .totalScore(totalScore)
            .scoreLevel(determineScoreLevel(totalScore))
            .build();
    }
    
    public RFMAnalysis calculateRFM(Customer customer) {
        LocalDateTime analysisDate = LocalDateTime.now();
        LocalDateTime oneYearAgo = analysisDate.minusYears(1);
        
        // Recency: 最近一次购买距今天数
        long recencyDays = customer.getLastOrderAt() != null ?
            ChronoUnit.DAYS.between(customer.getLastOrderAt(), analysisDate) : 999;
        
        // Frequency: 一年内购买频次
        int frequency = orderService.getOrderCountByCustomer(
            customer.getId(), oneYearAgo, analysisDate
        );
        
        // Monetary: 一年内购买金额
        BigDecimal monetary = orderService.getTotalSpentByCustomer(
            customer.getId(), oneYearAgo, analysisDate
        );
        
        // 计算RFM评分 (1-5分)
        int recencyScore = calculateRecencyScore(recencyDays);
        int frequencyScore = calculateFrequencyScore(frequency);
        int monetaryScore = calculateMonetaryScore(monetary);
        
        // 综合评分
        double compositeScore = (recencyScore + frequencyScore + monetaryScore) / 3.0;
        
        return RFMAnalysis.builder()
            .customerId(customer.getId())
            .recency(recencyDays)
            .frequency(frequency)
            .monetary(monetary)
            .recencyScore(recencyScore)
            .frequencyScore(frequencyScore)
            .monetaryScore(monetaryScore)
            .compositeScore(compositeScore)
            .segment(determineRFMSegment(recencyScore, frequencyScore, monetaryScore))
            .build();
    }
}
```

---

## 🎯 精准营销支持

### 营销推荐引擎

```java
@Service
public class MarketingRecommendationEngine {
    
    public MarketingRecommendation generateRecommendation(String customerId, String campaignType) {
        Customer customer = customerRepository.findById(customerId);
        Customer360View customerView = customer360Service.getCustomer360View(customerId);
        
        return MarketingRecommendation.builder()
            .customerId(customerId)
            .campaignType(campaignType)
            .recommendedChannels(recommendChannels(customerView))
            .recommendedTiming(recommendTiming(customerView))
            .recommendedContent(recommendContent(customerView, campaignType))
            .recommendedOffers(recommendOffers(customerView))
            .expectedResponseRate(predictResponseRate(customerView, campaignType))
            .confidenceScore(calculateConfidence(customerView))
            .build();
    }
    
    private List<MarketingChannel> recommendChannels(Customer360View customerView) {
        Map<String, Double> channelPreferences = customerView.getBehaviorProfile()
            .getChannelUsage().getChannelDistribution();
        
        return channelPreferences.entrySet().stream()
            .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
            .limit(3)
            .map(entry -> MarketingChannel.builder()
                .channel(entry.getKey())
                .preference(entry.getValue())
                .estimatedReachability(calculateReachability(customerView, entry.getKey()))
                .build())
            .collect(Collectors.toList());
    }
    
    private OptimalTiming recommendTiming(Customer360View customerView) {
        ActivityPatterns patterns = customerView.getBehaviorProfile().getActivityPatterns();
        
        return OptimalTiming.builder()
            .bestDayOfWeek(patterns.getMostActiveDayOfWeek())
            .bestHourOfDay(patterns.getMostActiveHourOfDay())
            .timeZone(customerView.getCustomer().getPersonalInfo().getTimeZone())
            .avoidTimes(patterns.getLeastActiveHours())
            .confidence(patterns.getPatternStability())
            .build();
    }
    
    public CampaignTargetingResult targetCampaign(String segmentId, CampaignConfig config) {
        List<String> segmentMembers = segmentMemberRepository.findMemberIds(segmentId);
        
        List<CustomerTarget> targets = segmentMembers.parallelStream()
            .map(customerId -> {
                MarketingRecommendation recommendation = generateRecommendation(
                    customerId, config.getCampaignType()
                );
                
                return CustomerTarget.builder()
                    .customerId(customerId)
                    .recommendation(recommendation)
                    .priority(calculateTargetPriority(recommendation))
                    .build();
            })
            .sorted(Comparator.comparing(CustomerTarget::getPriority).reversed())
            .limit(config.getMaxTargets())
            .collect(Collectors.toList());
        
        return CampaignTargetingResult.builder()
            .segmentId(segmentId)
            .totalSegmentSize(segmentMembers.size())
            .targetedCustomers(targets)
            .expectedReach(calculateExpectedReach(targets))
            .expectedConversion(calculateExpectedConversion(targets))
            .estimatedROI(calculateEstimatedROI(targets, config))
            .build();
    }
}
```

---

## 🔒 数据隐私保护

### 隐私保护服务

```java
@Service
public class PrivacyProtectionService {
    
    @PostMapping("/customer/{customerId}/consent")
    public ConsentResult updateConsent(@PathVariable String customerId, 
                                     @RequestBody ConsentUpdateRequest request) {
        Customer customer = customerRepository.findById(customerId);
        
        // 更新同意设置
        PrivacyConsent consent = PrivacyConsent.builder()
            .customerId(customerId)
            .dataCollection(request.isDataCollection())
            .dataProcessing(request.isDataProcessing())
            .marketingCommunication(request.isMarketingCommunication())
            .thirdPartySharing(request.isThirdPartySharing())
            .consentDate(LocalDateTime.now())
            .ipAddress(request.getIpAddress())
            .userAgent(request.getUserAgent())
            .build();
        
        privacyConsentRepository.save(consent);
        
        // 如果撤销同意，触发数据处理
        if (!request.isDataProcessing()) {
            triggerDataAnonymization(customerId);
        }
        
        return ConsentResult.success(consent);
    }
    
    @GetMapping("/customer/{customerId}/data-export")
    public CustomerDataExport exportCustomerData(@PathVariable String customerId) {
        // 验证客户身份和权限
        validateCustomerAccess(customerId);
        
        // 收集所有相关数据
        Customer customer = customerRepository.findById(customerId);
        List<CustomerBehaviorEvent> behaviors = behaviorRepository.findByCustomerId(customerId);
        List<Order> orders = orderRepository.findByCustomerId(customerId);
        List<CustomerTag> tags = tagRepository.findByCustomerId(customerId);
        
        return CustomerDataExport.builder()
            .customerId(customerId)
            .exportDate(LocalDateTime.now())
            .personalData(customer.getPersonalInfo())
            .transactionData(orders)
            .behaviorData(anonymizeBehaviorData(behaviors))
            .tagData(tags)
            .consentHistory(privacyConsentRepository.findByCustomerId(customerId))
            .build();
    }
    
    @DeleteMapping("/customer/{customerId}/data")
    public DataDeletionResult deleteCustomerData(@PathVariable String customerId,
                                                @RequestBody DataDeletionRequest request) {
        // 验证删除权限
        validateDeletionRequest(customerId, request);
        
        // 软删除客户数据
        Customer customer = customerRepository.findById(customerId);
        customer.markAsDeleted(request.getReason());
        customerRepository.save(customer);
        
        // 匿名化行为数据
        anonymizeCustomerBehaviors(customerId);
        
        // 移除个人标识信息
        removePersonalIdentifiers(customerId);
        
        // 记录删除操作
        DataDeletionRecord record = DataDeletionRecord.builder()
            .customerId(customerId)
            .deletionDate(LocalDateTime.now())
            .reason(request.getReason())
            .dataTypes(request.getDataTypes())
            .operatorId(SecurityContextHolder.getCurrentUserId())
            .build();
        
        dataDeletionRepository.save(record);
        
        return DataDeletionResult.success(record);
    }
    
    private void anonymizeCustomerBehaviors(String customerId) {
        // 批量匿名化行为数据
        behaviorRepository.anonymizeByCustomerId(customerId);
        
        // 保留统计价值但移除个人标识
        List<CustomerBehaviorEvent> events = behaviorRepository.findByCustomerId(customerId);
        for (CustomerBehaviorEvent event : events) {
            event.setCustomerId("ANONYMIZED_" + UUID.randomUUID().toString().substring(0, 8));
            event.setIpAddress(null);
            event.setUserAgent(null);
            event.setLocation(null);
        }
        
        behaviorRepository.saveAll(events);
    }
}
```

---

## ⚡ 性能优化方案

### 查询优化

```java
@Repository
public class CustomerQueryOptimizer {
    
    @Cacheable(value = "customerProfile", key = "#customerId", unless = "#result == null")
    public Customer360View getCustomer360ViewCached(String customerId) {
        return customer360Service.getCustomer360View(customerId);
    }
    
    public Page<Customer> findCustomersOptimized(CustomerSearchCriteria criteria) {
        // 使用复合索引和查询优化
        StringBuilder sql = new StringBuilder("""
            SELECT c.* FROM customers c 
            LEFT JOIN customer_statistics cs ON c.id = cs.customer_id
        """);
        
        List<Object> params = new ArrayList<>();
        boolean hasWhere = false;
        
        // 动态构建WHERE子句
        if (criteria.getLifecycleStage() != null) {
            sql.append(" WHERE c.lifecycle_stage = ?");
            params.add(criteria.getLifecycleStage());
            hasWhere = true;
        }
        
        if (criteria.getMinTotalSpent() != null) {
            sql.append(hasWhere ? " AND" : " WHERE");
            sql.append(" c.total_spent >= ?");
            params.add(criteria.getMinTotalSpent());
            hasWhere = true;
        }
        
        if (criteria.getTagIds() != null && !criteria.getTagIds().isEmpty()) {
            sql.append(hasWhere ? " AND" : " WHERE");
            sql.append(" c.id IN (SELECT DISTINCT ct.customer_id FROM customer_tags ct WHERE ct.tag_definition_id IN (");
            sql.append(String.join(",", Collections.nCopies(criteria.getTagIds().size(), "?")));
            sql.append("))");
            params.addAll(criteria.getTagIds());
            hasWhere = true;
        }
        
        // 地理位置过滤（使用空间索引）
        if (criteria.getLocation() != null && criteria.getRadius() != null) {
            sql.append(hasWhere ? " AND" : " WHERE");
            sql.append(" ST_Distance_Sphere(c.location_point, POINT(?, ?)) <= ?");
            params.add(criteria.getLocation().getLongitude());
            params.add(criteria.getLocation().getLatitude());
            params.add(criteria.getRadius() * 1000);
            hasWhere = true;
        }
        
        // 时间范围过滤
        if (criteria.getLastActivityAfter() != null) {
            sql.append(hasWhere ? " AND" : " WHERE");
            sql.append(" c.last_activity_at >= ?");
            params.add(criteria.getLastActivityAfter());
            hasWhere = true;
        }
        
        // 排序
        sql.append(" ORDER BY ");
        switch (criteria.getSortBy()) {
            case TOTAL_SPENT_DESC:
                sql.append("c.total_spent DESC");
                break;
            case LAST_ACTIVITY_DESC:
                sql.append("c.last_activity_at DESC");
                break;
            case LOYALTY_SCORE_DESC:
                sql.append("c.loyalty_score DESC");
                break;
            default:
                sql.append("c.created_at DESC");
        }
        
        return executePagedQuery(sql.toString(), params, criteria.getPageable());
    }
    
    @Async
    @Retryable(value = {Exception.class}, maxAttempts = 3)
    public CompletableFuture<List<CustomerBehaviorEvent>> getCustomerBehaviorsAsync(String customerId, int days) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        
        // 使用分区表查询优化
        List<CustomerBehaviorEvent> events = behaviorRepository
            .findByCustomerIdAndEventTimeAfter(customerId, startDate);
        
        return CompletableFuture.completedFuture(events);
    }
}
```

### 缓存策略

```java
@Service
public class CustomerCacheManager {
    
    @CacheEvict(value = "customerProfile", key = "#customerId")
    public void evictCustomerProfile(String customerId) {
        // 清除客户档案缓存
    }
    
    @CachePut(value = "customerTags", key = "#customerId")
    public List<CustomerTag> updateCustomerTagsCache(String customerId) {
        return tagRepository.findByCustomerId(customerId);
    }
    
    @Cacheable(value = "segmentMembers", key = "#segmentId")
    public List<String> getSegmentMembersCached(String segmentId) {
        return segmentMemberRepository.findMemberIds(segmentId);
    }
    
    @Scheduled(fixedRate = 3600000) // 每小时执行
    public void warmupCache() {
        // 预热高频访问的客户数据
        List<String> vipCustomers = customerRepository.findVIPCustomerIds();
        
        vipCustomers.parallelStream().forEach(customerId -> {
            try {
                getCustomer360ViewCached(customerId);
            } catch (Exception e) {
                log.warn("Failed to warmup cache for customer: {}", customerId, e);
            }
        });
    }
}
```

---

## 📊 监控指标

### 关键业务指标

```yaml
客户指标:
  获客指标:
    - 新客户获取数量
    - 客户获取成本(CAC)
    - 获客渠道效率
    - 客户激活率
    
  活跃指标:
    - 日活跃客户数(DAU)
    - 月活跃客户数(MAU)
    - 客户活跃度分布
    - 会话时长和频次
    
  价值指标:
    - 客户生命周期价值(CLV)
    - 平均订单价值(AOV)
    - 购买频次
    - 客户满意度分数
    
  留存指标:
    - 客户留存率
    - 流失率和流失原因
    - 重新激活率
    - 推荐转化率

营销指标:
  分群效果:
    - 分群准确率
    - 分群覆盖度
    - 分群稳定性
    - 分群业务价值
    
  标签质量:
    - 标签准确率
    - 标签覆盖度
    - 标签使用率
    - 标签业务效果
    
  营销效果:
    - 营销响应率
    - 转化率
    - ROI/ROAS
    - 客户满意度

技术指标:
  系统性能:
    - 查询响应时间
    - 数据处理延迟
    - 缓存命中率
    - 系统可用性
    
  数据质量:
    - 数据完整性
    - 数据准确性
    - 数据及时性
    - 数据一致性
```

---

**📅 最后更新**: 2025年1月 | **📝 版本**: v1.0 | **🎯 状态**: 设计完成

🎉 **客户管理模块，打造客户全生命周期价值管理体系！**