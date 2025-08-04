# 🤖 AI智能体模块详细设计
*WeWork Management Platform - AI Agent Module Design*

## 📖 文档目录

1. [模块概述](#模块概述)
2. [多平台统一管理](#多平台统一管理)
3. [智能体生命周期](#智能体生命周期)
4. [智能调度系统](#智能调度系统)
5. [知识库管理](#知识库管理)
6. [工具生态系统](#工具生态系统)
7. [对话管理](#对话管理)
8. [性能监控](#性能监控)
9. [安全与合规](#安全与合规)
10. [扩展与集成](#扩展与集成)

---

## 🎯 模块概述

### 业务职责
AI智能体模块提供多AI平台的统一管理、智能调度、性能监控等功能，通过统一的API接口屏蔽底层平台差异，为企业提供稳定、高效的AI服务能力。

```yaml
核心职责:
  - 多AI平台统一接入
  - 智能体全生命周期管理
  - 智能调度与负载均衡
  - 知识库统一管理
  - 工具生态集成
  - 性能监控与优化

业务价值:
  - 降低集成成本: 统一接口减少重复开发
  - 提升可用性: 多平台冗余保障服务稳定
  - 优化性能: 智能调度提升响应效率
  - 增强能力: 丰富的工具和知识库生态
```

### 技术架构
```yaml
架构模式:
  - 适配器模式: 多平台接口适配
  - 策略模式: 调度策略可插拔
  - 工厂模式: 智能体实例创建
  - 观察者模式: 性能监控和事件处理

核心组件:
  - PlatformManager: 平台管理器
  - AgentLifecycleManager: 智能体生命周期管理
  - SchedulingEngine: 调度引擎
  - KnowledgeBaseManager: 知识库管理器
  - ToolRegistry: 工具注册表
  - ConversationManager: 对话管理器
  - PerformanceMonitor: 性能监控器
```

---

## 🌐 多平台统一管理

### AI平台适配器

```java
@Entity
@Table(name = "ai_platforms")
public class AIPlatform {
    private String id;
    private String tenantId;
    private String platformCode;
    private String platformName;
    private PlatformType platformType;
    
    // 连接配置
    private PlatformConnectionConfig connectionConfig;
    private String apiEndpoint;
    private String authType;
    private Map<String, String> credentials;
    
    // 能力配置
    private List<ModelCapability> supportedCapabilities;
    private List<String> supportedModels;
    private ModelLimitations limitations;
    
    // 费用配置
    private PricingModel pricingModel;
    private Map<String, BigDecimal> pricing;
    private BigDecimal dailyBudget;
    private BigDecimal monthlyBudget;
    
    // 状态和监控
    private PlatformStatus status;
    private PlatformHealthMetrics healthMetrics;
    private LocalDateTime lastHealthCheck;
    
    // 质量评估
    private Double qualityScore;
    private Double reliabilityScore;
    private Double responseTimeScore;
    
    public boolean isAvailable() {
        return status == PlatformStatus.ACTIVE
               && healthMetrics.getHealthScore() > 0.7
               && !hasExceededBudget();
    }
    
    public boolean supportsCapability(ModelCapability capability) {
        return supportedCapabilities.contains(capability);
    }
    
    private boolean hasExceededBudget() {
        if (dailyBudget != null) {
            BigDecimal todaySpent = getTodaySpent();
            if (todaySpent.compareTo(dailyBudget) >= 0) {
                return true;
            }
        }
        
        if (monthlyBudget != null) {
            BigDecimal monthSpent = getMonthSpent();
            if (monthSpent.compareTo(monthlyBudget) >= 0) {
                return true;
            }
        }
        
        return false;
    }
}

public interface PlatformAdapter {
    String getPlatformType();
    CompletableFuture<AgentResponse> invoke(AgentRequest request);
    boolean isHealthy();
    PlatformCapabilities getCapabilities();
    List<String> getSupportedModels();
}

@Component
public class DifyPlatformAdapter implements PlatformAdapter {
    
    @Override
    public CompletableFuture<AgentResponse> invoke(AgentRequest request) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // 构建Dify API请求
                DifyApiRequest difyRequest = DifyApiRequest.builder()
                    .inputs(request.getInputs())
                    .query(request.getQuery())
                    .userId(request.getUserId())
                    .conversationId(request.getConversationId())
                    .build();
                
                // 调用Dify API
                DifyApiResponse difyResponse = difyApiClient.chat(difyRequest);
                
                // 转换响应格式
                return AgentResponse.builder()
                    .platformId(request.getPlatformId())
                    .agentId(request.getAgentId())
                    .response(difyResponse.getAnswer())
                    .conversationId(difyResponse.getConversationId())
                    .messageId(difyResponse.getMessageId())
                    .usage(convertUsage(difyResponse.getUsage()))
                    .responseTime(difyResponse.getResponseTime())
                    .build();
                
            } catch (Exception e) {
                throw new PlatformInvocationException("Dify platform error", e);
            }
        });
    }
    
    @Override
    public boolean isHealthy() {
        try {
            DifyHealthResponse health = difyApiClient.health();
            return health.getStatus().equals("healthy");
        } catch (Exception e) {
            return false;
        }
    }
}
```

### 平台管理器

```java
@Service
public class PlatformManager {
    
    private final Map<String, PlatformAdapter> adapters = new ConcurrentHashMap<>();
    
    @PostConstruct
    public void initializeAdapters() {
        // 注册所有平台适配器
        registerAdapter(new DifyPlatformAdapter());
        registerAdapter(new CozePlatformAdapter());
        registerAdapter(new FastGPTPlatformAdapter());
        registerAdapter(new CustomPlatformAdapter());
    }
    
    public void registerAdapter(PlatformAdapter adapter) {
        adapters.put(adapter.getPlatformType(), adapter);
        log.info("Registered platform adapter: {}", adapter.getPlatformType());
    }
    
    public CompletableFuture<AgentResponse> invokeAgent(AgentInvocationRequest request) {
        String platformId = request.getPlatformId();
        AIPlatform platform = platformRepository.findById(platformId);
        
        if (!platform.isAvailable()) {
            throw new PlatformUnavailableException("Platform not available: " + platformId);
        }
        
        PlatformAdapter adapter = adapters.get(platform.getPlatformType().name());
        if (adapter == null) {
            throw new AdapterNotFoundException("No adapter found for platform: " + platform.getPlatformType());
        }
        
        // 记录调用开始
        AgentCallLog callLog = createCallLog(request);
        
        return adapter.invoke(request.toAgentRequest())
            .thenApply(response -> {
                // 记录调用成功
                updateCallLogSuccess(callLog, response);
                
                // 更新平台统计
                updatePlatformMetrics(platform, response);
                
                return response;
            })
            .exceptionally(throwable -> {
                // 记录调用失败
                updateCallLogFailure(callLog, throwable);
                
                // 更新平台健康状态
                updatePlatformHealth(platform, false);
                
                throw new RuntimeException(throwable);
            });
    }
    
    @Scheduled(fixedRate = 300000) // 每5分钟检查
    public void performHealthChecks() {
        List<AIPlatform> platforms = platformRepository.findAllActive();
        
        platforms.parallelStream().forEach(platform -> {
            try {
                PlatformAdapter adapter = adapters.get(platform.getPlatformType().name());
                if (adapter != null) {
                    boolean healthy = adapter.isHealthy();
                    updatePlatformHealthStatus(platform, healthy);
                }
            } catch (Exception e) {
                log.error("Health check failed for platform: {}", platform.getId(), e);
                updatePlatformHealthStatus(platform, false);
            }
        });
    }
    
    public PlatformSelectionResult selectOptimalPlatform(PlatformSelectionCriteria criteria) {
        List<AIPlatform> availablePlatforms = platformRepository
            .findAvailableByCapability(criteria.getRequiredCapability());
        
        if (availablePlatforms.isEmpty()) {
            return PlatformSelectionResult.noPlatformAvailable();
        }
        
        // 根据选择策略排序
        List<PlatformScore> scoredPlatforms = availablePlatforms.stream()
            .map(platform -> calculatePlatformScore(platform, criteria))
            .sorted(Comparator.comparing(PlatformScore::getScore).reversed())
            .collect(Collectors.toList());
        
        PlatformScore bestPlatform = scoredPlatforms.get(0);
        
        return PlatformSelectionResult.builder()
            .selectedPlatform(bestPlatform.getPlatform())
            .score(bestPlatform.getScore())
            .reason(bestPlatform.getReason())
            .alternatives(scoredPlatforms.subList(1, Math.min(3, scoredPlatforms.size())))
            .build();
    }
    
    private PlatformScore calculatePlatformScore(AIPlatform platform, PlatformSelectionCriteria criteria) {
        double score = 0.0;
        StringBuilder reason = new StringBuilder();
        
        // 质量评分 (40%)
        double qualityWeight = 0.4;
        double qualityScore = platform.getQualityScore() != null ? platform.getQualityScore() : 0.5;
        score += qualityScore * qualityWeight;
        reason.append(String.format("质量评分: %.2f ", qualityScore));
        
        // 响应时间评分 (30%)
        double responseTimeWeight = 0.3;
        double responseTimeScore = platform.getResponseTimeScore() != null ? platform.getResponseTimeScore() : 0.5;
        score += responseTimeScore * responseTimeWeight;
        reason.append(String.format("响应时间: %.2f ", responseTimeScore));
        
        // 可靠性评分 (20%)
        double reliabilityWeight = 0.2;
        double reliabilityScore = platform.getReliabilityScore() != null ? platform.getReliabilityScore() : 0.5;
        score += reliabilityScore * reliabilityWeight;
        reason.append(String.format("可靠性: %.2f ", reliabilityScore));
        
        // 成本评分 (10%)
        double costWeight = 0.1;
        double costScore = calculateCostScore(platform, criteria);
        score += costScore * costWeight;
        reason.append(String.format("成本: %.2f", costScore));
        
        return PlatformScore.builder()
            .platform(platform)
            .score(score)
            .reason(reason.toString())
            .build();
    }
}
```

---

## 🔄 智能体生命周期

### 智能体模型

```java
@Entity
@Table(name = "ai_agents")
public class AIAgent {
    private String id;
    private String tenantId;
    private String agentCode;
    private String agentName;
    private String description;
    
    // 基本配置
    private AgentType agentType;
    private String category;
    private List<String> tags;
    private String avatar;
    
    // 模型配置
    private String primaryModel;
    private Map<String, Object> modelParameters;
    private String systemPrompt;
    private List<String> exampleDialogues;
    
    // 能力配置
    private List<AgentCapability> capabilities;
    private List<String> knowledgeBaseIds;
    private List<String> toolIds;
    
    // 部署配置
    private List<AgentDeployment> deployments;
    private LoadBalancingStrategy loadBalancingStrategy;
    private Integer maxConcurrentSessions;
    
    // 版本管理
    private String version;
    private String parentVersionId;
    private VersionStatus versionStatus;
    private String changeLog;
    
    // 状态和统计
    private AgentStatus status;
    private AgentStatistics statistics;
    private LocalDateTime lastDeployedAt;
    
    public boolean canHandleRequest(AgentRequest request) {
        return status == AgentStatus.ACTIVE
               && capabilities.stream().anyMatch(cap -> cap.matches(request.getRequiredCapability()))
               && statistics.getCurrentSessions() < maxConcurrentSessions;
    }
    
    public AgentDeployment selectDeployment(PlatformSelectionCriteria criteria) {
        return deployments.stream()
            .filter(deployment -> deployment.isActive())
            .filter(deployment -> deployment.getPlatform().isAvailable())
            .min(Comparator.comparing(deployment -> deployment.getCurrentLoad()))
            .orElse(null);
    }
}

@Entity
@Table(name = "ai_agent_versions")
public class AIAgentVersion {
    private String id;
    private String agentId;
    private String versionNumber;
    private String description;
    
    // 版本配置
    private AgentConfiguration configuration;
    private String configurationSnapshot;
    
    // 测试结果
    private List<AgentTestResult> testResults;
    private Double performanceScore;
    private Double qualityScore;
    
    // 部署信息
    private VersionStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime deployedAt;
    private String deployedBy;
    
    // A/B测试配置
    private ABTestConfiguration abTestConfig;
    private Double trafficPercentage;
    
    public boolean isReadyForDeployment() {
        return status == VersionStatus.TESTED
               && testResults.stream().allMatch(result -> result.isPassed())
               && performanceScore >= 0.8
               && qualityScore >= 0.8;
    }
}
```

### 智能体生命周期管理

```java
@Service
public class AgentLifecycleManager {
    
    public AgentCreationResult createAgent(AgentCreationRequest request) {
        // 验证创建请求
        validateCreationRequest(request);
        
        // 创建智能体实例
        AIAgent agent = AIAgent.builder()
            .tenantId(request.getTenantId())
            .agentCode(request.getAgentCode())
            .agentName(request.getAgentName())
            .description(request.getDescription())
            .agentType(request.getAgentType())
            .category(request.getCategory())
            .configuration(request.getConfiguration())
            .status(AgentStatus.DRAFT)
            .version("1.0.0")
            .build();
        
        agentRepository.save(agent);
        
        // 创建初始版本
        AIAgentVersion initialVersion = createInitialVersion(agent);
        
        // 初始化统计
        initializeAgentStatistics(agent);
        
        // 发布创建事件
        eventPublisher.publishEvent(new AgentCreatedEvent(agent));
        
        return AgentCreationResult.builder()
            .agent(agent)
            .initialVersion(initialVersion)
            .build();
    }
    
    public AgentDeploymentResult deployAgent(String agentId, List<String> platformIds) {
        AIAgent agent = agentRepository.findById(agentId);
        
        if (!agent.canDeploy()) {
            return AgentDeploymentResult.failed("智能体不满足部署条件");
        }
        
        List<AgentDeployment> deployments = new ArrayList<>();
        List<DeploymentError> errors = new ArrayList<>();
        
        for (String platformId : platformIds) {
            try {
                AIPlatform platform = platformRepository.findById(platformId);
                
                // 创建部署配置
                AgentDeployment deployment = createDeployment(agent, platform);
                
                // 执行部署
                DeploymentResult result = executeDeployment(deployment);
                
                if (result.isSuccess()) {
                    deployment.setStatus(DeploymentStatus.ACTIVE);
                    deployments.add(deployment);
                } else {
                    errors.add(new DeploymentError(platformId, result.getErrorMessage()));
                }
                
            } catch (Exception e) {
                errors.add(new DeploymentError(platformId, e.getMessage()));
            }
        }
        
        if (!deployments.isEmpty()) {
            // 更新智能体状态
            agent.setStatus(AgentStatus.ACTIVE);
            agent.setDeployments(deployments);
            agent.setLastDeployedAt(LocalDateTime.now());
            agentRepository.save(agent);
            
            // 发布部署事件
            eventPublisher.publishEvent(new AgentDeployedEvent(agent, deployments));
        }
        
        return AgentDeploymentResult.builder()
            .agentId(agentId)
            .successfulDeployments(deployments)
            .errors(errors)
            .build();
    }
    
    public AgentVersionResult createNewVersion(String agentId, VersionCreationRequest request) {
        AIAgent agent = agentRepository.findById(agentId);
        
        // 生成新版本号
        String newVersionNumber = generateNextVersionNumber(agent.getVersion());
        
        // 创建新版本
        AIAgentVersion newVersion = AIAgentVersion.builder()
            .agentId(agentId)
            .versionNumber(newVersionNumber)
            .description(request.getDescription())
            .configuration(request.getConfiguration())
            .status(VersionStatus.DRAFT)
            .parentVersionId(agent.getVersion())
            .build();
        
        agentVersionRepository.save(newVersion);
        
        // 执行自动化测试
        AgentTestSuite testSuite = createTestSuite(newVersion);
        AgentTestResult testResult = executeTests(testSuite);
        
        newVersion.setTestResults(Arrays.asList(testResult));
        
        if (testResult.isPassed()) {
            newVersion.setStatus(VersionStatus.TESTED);
            
            // 如果启用自动部署
            if (request.isAutoDeployEnabled()) {
                initiateGradualRollout(newVersion);
            }
        } else {
            newVersion.setStatus(VersionStatus.FAILED);
        }
        
        agentVersionRepository.save(newVersion);
        
        return AgentVersionResult.builder()
            .agentId(agentId)
            .newVersion(newVersion)
            .testResult(testResult)
            .build();
    }
    
    @Scheduled(fixedRate = 600000) // 每10分钟检查
    public void monitorAgentHealth() {
        List<AIAgent> activeAgents = agentRepository.findByStatus(AgentStatus.ACTIVE);
        
        for (AIAgent agent : activeAgents) {
            try {
                // 检查部署健康状态
                for (AgentDeployment deployment : agent.getDeployments()) {
                    boolean healthy = checkDeploymentHealth(deployment);
                    if (!healthy) {
                        handleUnhealthyDeployment(agent, deployment);
                    }
                }
                
                // 检查性能指标
                AgentPerformanceMetrics metrics = getPerformanceMetrics(agent.getId());
                if (metrics.hasPerformanceIssues()) {
                    handlePerformanceIssues(agent, metrics);
                }
                
            } catch (Exception e) {
                log.error("Failed to monitor agent health: {}", agent.getId(), e);
            }
        }
    }
}
```

---

## 🎯 智能调度系统

### 调度策略引擎

```java
public interface SchedulingStrategy {
    String getStrategyName();
    PlatformSelectionResult selectPlatform(List<AIPlatform> availablePlatforms, AgentRequest request);
    double calculatePlatformScore(AIPlatform platform, AgentRequest request);
}

@Component
public class ResponseTimeOptimizedStrategy implements SchedulingStrategy {
    
    @Override
    public String getStrategyName() {
        return "response_time_optimized";
    }
    
    @Override
    public PlatformSelectionResult selectPlatform(List<AIPlatform> availablePlatforms, AgentRequest request) {
        if (availablePlatforms.isEmpty()) {
            return PlatformSelectionResult.noPlatformAvailable();
        }
        
        // 根据历史响应时间排序
        AIPlatform bestPlatform = availablePlatforms.stream()
            .filter(platform -> platform.isAvailable())
            .min(Comparator.comparing(platform -> 
                getAverageResponseTime(platform.getId(), Duration.ofHours(1))))
            .orElse(null);
        
        if (bestPlatform == null) {
            return PlatformSelectionResult.noPlatformAvailable();
        }
        
        double score = calculatePlatformScore(bestPlatform, request);
        
        return PlatformSelectionResult.builder()
            .selectedPlatform(bestPlatform)
            .score(score)
            .reason("基于响应时间优化选择")
            .selectionTime(LocalDateTime.now())
            .build();
    }
    
    @Override
    public double calculatePlatformScore(AIPlatform platform, AgentRequest request) {
        // 响应时间评分 (50%)
        double avgResponseTime = getAverageResponseTime(platform.getId(), Duration.ofHours(1));
        double responseTimeScore = Math.max(0, 1 - (avgResponseTime / 10000)); // 10秒为基准
        
        // 成功率评分 (30%)
        double successRate = getSuccessRate(platform.getId(), Duration.ofHours(1));
        
        // 当前负载评分 (20%)
        double currentLoad = getCurrentLoad(platform.getId());
        double loadScore = Math.max(0, 1 - currentLoad);
        
        return responseTimeScore * 0.5 + successRate * 0.3 + loadScore * 0.2;
    }
}

@Component
public class CostOptimizedStrategy implements SchedulingStrategy {
    
    @Override
    public String getStrategyName() {
        return "cost_optimized";
    }
    
    @Override
    public PlatformSelectionResult selectPlatform(List<AIPlatform> availablePlatforms, AgentRequest request) {
        // 计算每个平台的成本效率
        List<PlatformCostEfficiency> costEfficiencies = availablePlatforms.stream()
            .filter(AIPlatform::isAvailable)
            .map(platform -> calculateCostEfficiency(platform, request))
            .sorted(Comparator.comparing(PlatformCostEfficiency::getEfficiency).reversed())
            .collect(Collectors.toList());
        
        if (costEfficiencies.isEmpty()) {
            return PlatformSelectionResult.noPlatformAvailable();
        }
        
        PlatformCostEfficiency best = costEfficiencies.get(0);
        
        return PlatformSelectionResult.builder()
            .selectedPlatform(best.getPlatform())
            .score(best.getEfficiency())
            .reason(String.format("成本效率最优: %.3f", best.getEfficiency()))
            .build();
    }
    
    private PlatformCostEfficiency calculateCostEfficiency(AIPlatform platform, AgentRequest request) {
        // 估算请求成本
        BigDecimal estimatedCost = estimateRequestCost(platform, request);
        
        // 获取质量评分
        double qualityScore = platform.getQualityScore() != null ? platform.getQualityScore() : 0.5;
        
        // 计算成本效率 (质量/成本)
        double efficiency = estimatedCost.compareTo(BigDecimal.ZERO) > 0 ? 
            qualityScore / estimatedCost.doubleValue() : 0;
        
        return PlatformCostEfficiency.builder()
            .platform(platform)
            .estimatedCost(estimatedCost)
            .qualityScore(qualityScore)
            .efficiency(efficiency)
            .build();
    }
}
```

### 调度引擎

```java
@Service
public class SchedulingEngine {
    
    private final Map<String, SchedulingStrategy> strategies = new ConcurrentHashMap<>();
    
    @PostConstruct
    public void initializeStrategies() {
        registerStrategy(new RoundRobinStrategy());
        registerStrategy(new LeastConnectionsStrategy());
        registerStrategy(new ResponseTimeOptimizedStrategy());
        registerStrategy(new CostOptimizedStrategy());
        registerStrategy(new WeightedStrategy());
        registerStrategy(new CustomStrategy());
    }
    
    public SchedulingResult scheduleRequest(AgentSchedulingRequest request) {
        // 获取可用的智能体部署
        List<AgentDeployment> availableDeployments = getAvailableDeployments(request.getAgentId());
        
        if (availableDeployments.isEmpty()) {
            return SchedulingResult.noDeploymentAvailable();
        }
        
        // 获取调度策略
        SchedulingStrategy strategy = getSchedulingStrategy(request.getStrategyName());
        
        // 转换为平台列表
        List<AIPlatform> platforms = availableDeployments.stream()
            .map(AgentDeployment::getPlatform)
            .filter(AIPlatform::isAvailable)
            .collect(Collectors.toList());
        
        // 执行平台选择
        PlatformSelectionResult selectionResult = strategy.selectPlatform(platforms, request.toAgentRequest());
        
        if (!selectionResult.isSuccess()) {
            return SchedulingResult.selectionFailed(selectionResult.getReason());
        }
        
        // 获取对应的部署
        AgentDeployment selectedDeployment = availableDeployments.stream()
            .filter(deployment -> deployment.getPlatform().getId().equals(selectionResult.getSelectedPlatform().getId()))
            .findFirst()
            .orElse(null);
        
        if (selectedDeployment == null) {
            return SchedulingResult.deploymentNotFound();
        }
        
        // 记录调度决策
        recordSchedulingDecision(request, selectionResult, selectedDeployment);
        
        return SchedulingResult.builder()
            .selectedDeployment(selectedDeployment)
            .selectionResult(selectionResult)
            .schedulingTime(LocalDateTime.now())
            .build();
    }
    
    @Async
    public void handleFailover(String deploymentId, Exception cause) {
        AgentDeployment failedDeployment = deploymentRepository.findById(deploymentId);
        
        // 标记部署为不健康
        failedDeployment.setHealthy(false);
        failedDeployment.setLastFailureTime(LocalDateTime.now());
        failedDeployment.setLastFailureReason(cause.getMessage());
        deploymentRepository.save(failedDeployment);
        
        // 获取同一智能体的其他可用部署
        List<AgentDeployment> alternativeDeployments = deploymentRepository
            .findByAgentIdAndHealthy(failedDeployment.getAgentId(), true);
        
        if (alternativeDeployments.isEmpty()) {
            // 没有可用的替代部署，发送告警
            alertService.sendAlert(AlertType.NO_AVAILABLE_DEPLOYMENT, 
                "Agent " + failedDeployment.getAgentId() + " has no available deployments");
            return;
        }
        
        // 将待处理的请求重定向到健康的部署
        redirectPendingRequests(failedDeployment, alternativeDeployments);
        
        // 尝试自动恢复
        scheduleRecoveryAttempt(failedDeployment);
        
        // 记录故障转移事件
        recordFailoverEvent(failedDeployment, alternativeDeployments, cause);
    }
    
    @Scheduled(fixedRate = 60000) // 每分钟执行
    public void performLoadBalancingOptimization() {
        // 获取所有活跃的智能体
        List<AIAgent> activeAgents = agentRepository.findByStatus(AgentStatus.ACTIVE);
        
        for (AIAgent agent : activeAgents) {
            try {
                optimizeAgentLoadBalancing(agent);
            } catch (Exception e) {
                log.error("Failed to optimize load balancing for agent: {}", agent.getId(), e);
            }
        }
    }
    
    private void optimizeAgentLoadBalancing(AIAgent agent) {
        List<AgentDeployment> deployments = agent.getDeployments();
        
        if (deployments.size() < 2) {
            return; // 无需负载均衡
        }
        
        // 计算当前负载分布
        Map<String, Double> currentLoads = deployments.stream()
            .collect(Collectors.toMap(
                AgentDeployment::getId,
                deployment -> getCurrentLoad(deployment.getId())
            ));
        
        // 检查负载是否平衡
        double maxLoad = currentLoads.values().stream().mapToDouble(Double::doubleValue).max().orElse(0);
        double minLoad = currentLoads.values().stream().mapToDouble(Double::doubleValue).min().orElse(0);
        double loadImbalance = maxLoad - minLoad;
        
        if (loadImbalance > 0.3) { // 30%的不平衡阈值
            // 调整负载分配权重
            adjustLoadBalancingWeights(agent, currentLoads);
        }
    }
}
```

---

## 📚 知识库管理

### 知识库模型

```java
@Entity
@Table(name = "ai_knowledge_bases")
public class AIKnowledgeBase {
    private String id;
    private String tenantId;
    private String kbCode;
    private String kbName;
    private String description;
    
    // 知识库类型和配置
    private KnowledgeBaseType kbType;
    private KnowledgeBaseCategory category;
    private Map<String, Object> configuration;
    
    // 内容配置
    private String dataSource;
    private DataFormat dataFormat;
    private String indexingStrategy;
    private String retrievalStrategy;
    
    // 向量化配置
    private String embeddingModel;
    private Integer embeddingDimension;
    private SimilarityMetric similarityMetric;
    
    // 访问控制
    private List<String> authorizedAgentIds;
    private List<String> authorizedUserIds;
    private PermissionLevel permissionLevel;
    
    // 状态和统计
    private KnowledgeBaseStatus status;
    private KnowledgeBaseStatistics statistics;
    private LocalDateTime lastUpdatedAt;
    private LocalDateTime lastIndexedAt;
    
    public boolean isAccessibleBy(String agentId, String userId) {
        if (permissionLevel == PermissionLevel.PUBLIC) {
            return true;
        }
        
        if (permissionLevel == PermissionLevel.AGENT_RESTRICTED) {
            return authorizedAgentIds.contains(agentId);
        }
        
        if (permissionLevel == PermissionLevel.USER_RESTRICTED) {
            return authorizedUserIds.contains(userId);
        }
        
        return false;
    }
}

@Entity
@Table(name = "ai_knowledge_documents")
public class AIKnowledgeDocument {
    private String id;
    private String knowledgeBaseId;
    private String documentCode;
    private String title;
    private String content;
    
    // 文档元数据
    private DocumentType documentType;
    private String sourceUrl;
    private String author;
    private LocalDateTime createdAt;
    private LocalDateTime lastModified;
    
    // 内容结构
    private List<DocumentSection> sections;
    private Map<String, String> metadata;
    private List<String> tags;
    
    // 向量化信息
    private String embeddingId;
    private List<Double> embedding;
    private Double embeddingScore;
    
    // 质量评估
    private DocumentQuality quality;
    private Double relevanceScore;
    private Integer usageCount;
    
    public List<DocumentChunk> chunkDocument(ChunkingStrategy strategy) {
        return strategy.chunk(this);
    }
    
    public boolean matches(SearchQuery query) {
        // 基于内容和元数据的匹配逻辑
        return content.toLowerCase().contains(query.getQuery().toLowerCase())
               || tags.stream().anyMatch(tag -> tag.toLowerCase().contains(query.getQuery().toLowerCase()))
               || title.toLowerCase().contains(query.getQuery().toLowerCase());
    }
}
```

### 知识库管理器

```java
@Service
public class KnowledgeBaseManager {
    
    public KnowledgeSearchResult search(KnowledgeSearchRequest request) {
        AIKnowledgeBase knowledgeBase = knowledgeBaseRepository.findById(request.getKnowledgeBaseId());
        
        // 验证访问权限
        if (!knowledgeBase.isAccessibleBy(request.getAgentId(), request.getUserId())) {
            throw new AccessDeniedException("No access to knowledge base: " + request.getKnowledgeBaseId());
        }
        
        // 根据知识库类型选择搜索策略
        KnowledgeSearchStrategy strategy = getSearchStrategy(knowledgeBase.getKbType());
        
        // 执行搜索
        List<SearchResult> results = strategy.search(knowledgeBase, request);
        
        // 应用相关性过滤
        List<SearchResult> filteredResults = results.stream()
            .filter(result -> result.getRelevanceScore() >= request.getMinRelevanceScore())
            .limit(request.getMaxResults())
            .collect(Collectors.toList());
        
        // 记录搜索日志
        recordSearchLog(request, filteredResults);
        
        return KnowledgeSearchResult.builder()
            .request(request)
            .results(filteredResults)
            .totalCount(results.size())
            .searchTime(LocalDateTime.now())
            .build();
    }
    
    public DocumentIndexingResult indexDocument(DocumentIndexingRequest request) {
        AIKnowledgeDocument document = knowledgeDocumentRepository.findById(request.getDocumentId());
        AIKnowledgeBase knowledgeBase = knowledgeBaseRepository.findById(document.getKnowledgeBaseId());
        
        try {
            // 文档预处理
            DocumentProcessingResult processed = preprocessDocument(document);
            
            // 向量化
            EmbeddingResult embedding = generateEmbedding(processed.getProcessedContent(), 
                knowledgeBase.getEmbeddingModel());
            
            // 更新文档向量信息
            document.setEmbedding(embedding.getVector());
            document.setEmbeddingScore(embedding.getQualityScore());
            document.setEmbeddingId(embedding.getId());
            
            // 索引到向量数据库
            VectorIndexingResult vectorResult = indexToVectorDatabase(document, embedding);
            
            // 索引到搜索引擎
            SearchIndexingResult searchResult = indexToSearchEngine(document);
            
            // 更新文档状态
            document.setStatus(DocumentStatus.INDEXED);
            document.setLastIndexedAt(LocalDateTime.now());
            knowledgeDocumentRepository.save(document);
            
            // 更新知识库统计
            updateKnowledgeBaseStatistics(knowledgeBase);
            
            return DocumentIndexingResult.builder()
                .documentId(request.getDocumentId())
                .vectorResult(vectorResult)
                .searchResult(searchResult)
                .embedding(embedding)
                .indexingTime(LocalDateTime.now())
                .build();
            
        } catch (Exception e) {
            log.error("Failed to index document: {}", request.getDocumentId(), e);
            
            document.setStatus(DocumentStatus.INDEXING_FAILED);
            document.setLastError(e.getMessage());
            knowledgeDocumentRepository.save(document);
            
            throw new DocumentIndexingException("Failed to index document", e);
        }
    }
    
    @Async
    public void performIncrementalUpdate(String knowledgeBaseId) {
        AIKnowledgeBase knowledgeBase = knowledgeBaseRepository.findById(knowledgeBaseId);
        
        // 获取需要更新的文档
        List<AIKnowledgeDocument> documentsToUpdate = knowledgeDocumentRepository
            .findByKnowledgeBaseIdAndStatus(knowledgeBaseId, DocumentStatus.PENDING_UPDATE);
        
        for (AIKnowledgeDocument document : documentsToUpdate) {
            try {
                // 重新索引文档
                DocumentIndexingRequest request = DocumentIndexingRequest.builder()
                    .documentId(document.getId())
                    .forceReindex(true)
                    .build();
                
                indexDocument(request);
                
            } catch (Exception e) {
                log.error("Failed to update document during incremental update: {}", document.getId(), e);
            }
        }
        
        // 更新知识库的最后更新时间
        knowledgeBase.setLastUpdatedAt(LocalDateTime.now());
        knowledgeBaseRepository.save(knowledgeBase);
    }
    
    public KnowledgeQualityReport assessKnowledgeQuality(String knowledgeBaseId) {
        AIKnowledgeBase knowledgeBase = knowledgeBaseRepository.findById(knowledgeBaseId);
        List<AIKnowledgeDocument> documents = knowledgeDocumentRepository
            .findByKnowledgeBaseId(knowledgeBaseId);
        
        // 评估内容质量
        ContentQualityMetrics contentQuality = assessContentQuality(documents);
        
        // 评估覆盖度
        CoverageMetrics coverage = assessCoverage(documents);
        
        // 评估一致性
        ConsistencyMetrics consistency = assessConsistency(documents);
        
        // 评估时效性
        FreshnessMetrics freshness = assessFreshness(documents);
        
        // 计算整体质量评分
        double overallScore = calculateOverallQualityScore(contentQuality, coverage, consistency, freshness);
        
        return KnowledgeQualityReport.builder()
            .knowledgeBaseId(knowledgeBaseId)
            .assessmentDate(LocalDateTime.now())
            .contentQuality(contentQuality)
            .coverage(coverage)
            .consistency(consistency)
            .freshness(freshness)
            .overallScore(overallScore)
            .recommendations(generateQualityRecommendations(contentQuality, coverage, consistency, freshness))
            .build();
    }
}
```

---

## 🛠️ 工具生态系统

### 工具注册表

```java
@Entity
@Table(name = "ai_tools")
public class AITool {
    private String id;
    private String tenantId;
    private String toolCode;
    private String toolName;
    private String description;
    
    // 工具类型和分类
    private ToolType toolType;
    private ToolCategory category;
    private List<String> tags;
    
    // 工具配置
    private ToolConfiguration configuration;
    private Map<String, Object> parameters;
    private String schemaDefinition;
    
    // 执行配置
    private String executorClass;
    private String apiEndpoint;
    private AuthenticationConfig authConfig;
    private Integer timeoutSeconds;
    
    // 输入输出定义
    private List<ToolParameter> inputParameters;
    private ToolOutputSchema outputSchema;
    private List<String> requiredPermissions;
    
    // 可用性配置
    private List<String> authorizedAgentIds;
    private PermissionLevel permissionLevel;
    private UsageQuota usageQuota;
    
    // 状态和统计
    private ToolStatus status;
    private ToolStatistics statistics;
    private LocalDateTime lastUsedAt;
    
    public boolean canBeUsedBy(String agentId, String userId) {
        if (status != ToolStatus.ACTIVE) {
            return false;
        }
        
        if (permissionLevel == PermissionLevel.PUBLIC) {
            return true;
        }
        
        if (permissionLevel == PermissionLevel.AGENT_RESTRICTED) {
            return authorizedAgentIds.contains(agentId);
        }
        
        return false;
    }
    
    public ToolExecutionResult execute(ToolExecutionContext context) {
        // 验证使用权限
        if (!canBeUsedBy(context.getAgentId(), context.getUserId())) {
            return ToolExecutionResult.accessDenied();
        }
        
        // 检查配额
        if (usageQuota != null && !usageQuota.hasQuota(context.getUserId())) {
            return ToolExecutionResult.quotaExceeded();
        }
        
        // 验证输入参数
        ParameterValidationResult validation = validateParameters(context.getInputParameters());
        if (!validation.isValid()) {
            return ToolExecutionResult.invalidParameters(validation.getErrors());
        }
        
        try {
            // 执行工具
            Object result = executeInternal(context);
            
            // 更新使用统计
            updateUsageStatistics(context);
            
            return ToolExecutionResult.success(result);
            
        } catch (Exception e) {
            log.error("Tool execution failed: {}", this.id, e);
            return ToolExecutionResult.executionFailed(e.getMessage());
        }
    }
}

public interface ToolExecutor {
    String getToolType();
    ToolExecutionResult execute(ToolExecutionContext context);
    boolean isHealthy();
    ToolCapabilities getCapabilities();
}

@Component
public class WebAPIToolExecutor implements ToolExecutor {
    
    @Override
    public String getToolType() {
        return "WEB_API";
    }
    
    @Override
    public ToolExecutionResult execute(ToolExecutionContext context) {
        AITool tool = context.getTool();
        
        try {
            // 构建HTTP请求
            HttpRequest request = buildHttpRequest(tool, context);
            
            // 执行HTTP调用
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            // 处理响应
            Object result = processResponse(response, tool.getOutputSchema());
            
            return ToolExecutionResult.success(result);
            
        } catch (Exception e) {
            return ToolExecutionResult.executionFailed(e.getMessage());
        }
    }
    
    private HttpRequest buildHttpRequest(AITool tool, ToolExecutionContext context) {
        String endpoint = tool.getApiEndpoint();
        Map<String, Object> parameters = context.getInputParameters();
        
        // 替换URL参数
        for (Map.Entry<String, Object> param : parameters.entrySet()) {
            endpoint = endpoint.replace("{" + param.getKey() + "}", String.valueOf(param.getValue()));
        }
        
        HttpRequest.Builder requestBuilder = HttpRequest.newBuilder()
            .uri(URI.create(endpoint))
            .timeout(Duration.ofSeconds(tool.getTimeoutSeconds()));
        
        // 添加认证头
        if (tool.getAuthConfig() != null) {
            addAuthenticationHeaders(requestBuilder, tool.getAuthConfig());
        }
        
        // 设置请求方法和body
        String method = tool.getConfiguration().getHttpMethod();
        if ("POST".equals(method) || "PUT".equals(method)) {
            String body = buildRequestBody(parameters, tool.getConfiguration());
            requestBuilder.method(method, HttpRequest.BodyPublishers.ofString(body));
            requestBuilder.header("Content-Type", "application/json");
        } else {
            requestBuilder.GET();
        }
        
        return requestBuilder.build();
    }
}
```

### 工具管理器

```java
@Service
public class ToolRegistry {
    
    private final Map<String, ToolExecutor> executors = new ConcurrentHashMap<>();
    
    @PostConstruct
    public void initializeExecutors() {
        registerExecutor(new WebAPIToolExecutor());
        registerExecutor(new DatabaseToolExecutor());
        registerExecutor(new FileOperationToolExecutor());
        registerExecutor(new CalculationToolExecutor());
        registerExecutor(new CustomScriptToolExecutor());
    }
    
    public ToolExecutionResult executeTool(ToolExecutionRequest request) {
        AITool tool = toolRepository.findById(request.getToolId());
        
        if (tool == null) {
            return ToolExecutionResult.toolNotFound();
        }
        
        ToolExecutor executor = executors.get(tool.getToolType().name());
        if (executor == null) {
            return ToolExecutionResult.executorNotFound();
        }
        
        ToolExecutionContext context = ToolExecutionContext.builder()
            .tool(tool)
            .agentId(request.getAgentId())
            .userId(request.getUserId())
            .inputParameters(request.getParameters())
            .executionId(UUID.randomUUID().toString())
            .startTime(LocalDateTime.now())
            .build();
        
        // 记录执行开始
        ToolExecutionLog log = createExecutionLog(context);
        
        try {
            // 执行工具
            ToolExecutionResult result = executor.execute(context);
            
            // 更新执行日志
            updateExecutionLog(log, result);
            
            // 更新工具统计
            updateToolStatistics(tool, result);
            
            return result;
            
        } catch (Exception e) {
            log.error("Tool execution error: {}", request.getToolId(), e);
            
            ToolExecutionResult errorResult = ToolExecutionResult.executionFailed(e.getMessage());
            updateExecutionLog(log, errorResult);
            
            return errorResult;
        }
    }
    
    public List<AITool> recommendTools(ToolRecommendationRequest request) {
        String agentId = request.getAgentId();
        String query = request.getQuery();
        ToolUsageContext context = request.getContext();
        
        // 获取智能体可用的工具
        List<AITool> availableTools = toolRepository.findAvailableForAgent(agentId);
        
        // 基于查询内容推荐
        List<ToolRecommendation> recommendations = availableTools.stream()
            .map(tool -> calculateRecommendationScore(tool, query, context))
            .filter(rec -> rec.getScore() > 0.3) // 最低推荐阈值
            .sorted(Comparator.comparing(ToolRecommendation::getScore).reversed())
            .limit(request.getMaxRecommendations())
            .collect(Collectors.toList());
        
        return recommendations.stream()
            .map(ToolRecommendation::getTool)
            .collect(Collectors.toList());
    }
    
    private ToolRecommendation calculateRecommendationScore(AITool tool, String query, ToolUsageContext context) {
        double score = 0.0;
        
        // 名称和描述匹配度 (40%)
        double textSimilarity = calculateTextSimilarity(query, tool.getToolName() + " " + tool.getDescription());
        score += textSimilarity * 0.4;
        
        // 分类匹配度 (20%)
        double categoryMatch = calculateCategoryMatch(tool.getCategory(), context.getExpectedCategory());
        score += categoryMatch * 0.2;
        
        // 历史使用频率 (20%)
        double usageFrequency = calculateUsageFrequency(tool.getId(), context.getAgentId());
        score += usageFrequency * 0.2;
        
        // 成功率 (20%)
        double successRate = tool.getStatistics().getSuccessRate();
        score += successRate * 0.2;
        
        return ToolRecommendation.builder()
            .tool(tool)
            .score(score)
            .reason(generateRecommendationReason(textSimilarity, categoryMatch, usageFrequency, successRate))
            .build();
    }
    
    @Scheduled(fixedRate = 3600000) // 每小时执行
    public void performToolHealthChecks() {
        List<AITool> activeTools = toolRepository.findByStatus(ToolStatus.ACTIVE);
        
        activeTools.parallelStream().forEach(tool -> {
            try {
                ToolExecutor executor = executors.get(tool.getToolType().name());
                if (executor != null) {
                    boolean healthy = executor.isHealthy();
                    updateToolHealthStatus(tool, healthy);
                }
            } catch (Exception e) {
                log.error("Health check failed for tool: {}", tool.getId(), e);
                updateToolHealthStatus(tool, false);
            }
        });
    }
}
```

---

## 💬 对话管理

### 对话管理器

```java
@Service
public class ConversationManager {
    
    public ConversationCreationResult createConversation(ConversationCreationRequest request) {
        AIConversation conversation = AIConversation.builder()
            .id(UUID.randomUUID().toString())
            .tenantId(request.getTenantId())
            .agentId(request.getAgentId())
            .userId(request.getUserId())
            .title(request.getTitle())
            .context(request.getInitialContext())
            .status(ConversationStatus.ACTIVE)
            .createdAt(LocalDateTime.now())
            .build();
        
        conversationRepository.save(conversation);
        
        // 初始化对话上下文
        initializeConversationContext(conversation);
        
        // 发布创建事件
        eventPublisher.publishEvent(new ConversationCreatedEvent(conversation));
        
        return ConversationCreationResult.builder()
            .conversation(conversation)
            .contextInitialized(true)
            .build();
    }
    
    public MessageProcessingResult processMessage(MessageProcessingRequest request) {
        AIConversation conversation = conversationRepository.findById(request.getConversationId());
        
        if (conversation.getStatus() != ConversationStatus.ACTIVE) {
            return MessageProcessingResult.conversationNotActive();
        }
        
        // 创建消息记录
        AIMessage userMessage = AIMessage.builder()
            .id(UUID.randomUUID().toString())
            .conversationId(conversation.getId())
            .messageType(MessageType.USER)
            .content(request.getContent())
            .timestamp(LocalDateTime.now())
            .metadata(request.getMetadata())
            .build();
        
        messageRepository.save(userMessage);
        
        try {
            // 更新对话上下文
            updateConversationContext(conversation, userMessage);
            
            // 构建智能体请求
            AgentInvocationRequest agentRequest = buildAgentRequest(conversation, userMessage, request);
            
            // 调用智能体
            CompletableFuture<AgentResponse> responseFuture = platformManager.invokeAgent(agentRequest);
            
            // 处理响应
            AgentResponse agentResponse = responseFuture.get(30, TimeUnit.SECONDS);
            
            // 创建助手消息
            AIMessage assistantMessage = AIMessage.builder()
                .id(UUID.randomUUID().toString())
                .conversationId(conversation.getId())
                .messageType(MessageType.ASSISTANT)
                .content(agentResponse.getResponse())
                .timestamp(LocalDateTime.now())
                .agentId(conversation.getAgentId())
                .platformId(agentResponse.getPlatformId())
                .usage(agentResponse.getUsage())
                .responseTime(agentResponse.getResponseTime())
                .build();
            
            messageRepository.save(assistantMessage);
            
            // 更新对话统计
            updateConversationStatistics(conversation, userMessage, assistantMessage);
            
            return MessageProcessingResult.builder()
                .userMessage(userMessage)
                .assistantMessage(assistantMessage)
                .agentResponse(agentResponse)
                .processingTime(Duration.between(userMessage.getTimestamp(), assistantMessage.getTimestamp()))
                .build();
            
        } catch (Exception e) {
            log.error("Failed to process message: {}", request.getConversationId(), e);
            
            // 创建错误消息
            AIMessage errorMessage = createErrorMessage(conversation, e);
            messageRepository.save(errorMessage);
            
            return MessageProcessingResult.failed(userMessage, errorMessage, e.getMessage());
        }
    }
    
    private AgentInvocationRequest buildAgentRequest(AIConversation conversation, AIMessage userMessage, MessageProcessingRequest request) {
        // 获取对话历史
        List<AIMessage> recentMessages = getRecentMessages(conversation.getId(), 10);
        
        // 构建上下文
        Map<String, Object> context = new HashMap<>(conversation.getContext());
        context.put("recentMessages", recentMessages);
        context.put("userProfile", getUserProfile(conversation.getUserId()));
        context.put("sessionInfo", getSessionInfo(request.getSessionId()));
        
        return AgentInvocationRequest.builder()
            .agentId(conversation.getAgentId())
            .userId(conversation.getUserId())
            .conversationId(conversation.getId())
            .content(userMessage.getContent())
            .context(context)
            .maxTokens(request.getMaxTokens())
            .temperature(request.getTemperature())
            .build();
    }
    
    public ConversationSummaryResult summarizeConversation(String conversationId) {
        AIConversation conversation = conversationRepository.findById(conversationId);
        List<AIMessage> messages = messageRepository.findByConversationIdOrderByTimestamp(conversationId);
        
        if (messages.size() < 5) {
            return ConversationSummaryResult.tooFewMessages();
        }
        
        // 使用智能体生成对话摘要
        String summaryPrompt = buildSummaryPrompt(messages);
        
        AgentInvocationRequest summaryRequest = AgentInvocationRequest.builder()
            .agentId(getSummaryAgentId())
            .content(summaryPrompt)
            .maxTokens(500)
            .temperature(0.3)
            .build();
        
        try {
            CompletableFuture<AgentResponse> responseFuture = platformManager.invokeAgent(summaryRequest);
            AgentResponse response = responseFuture.get(30, TimeUnit.SECONDS);
            
            // 保存摘要
            ConversationSummary summary = ConversationSummary.builder()
                .conversationId(conversationId)
                .summary(response.getResponse())
                .messageCount(messages.size())
                .createdAt(LocalDateTime.now())
                .build();
            
            conversationSummaryRepository.save(summary);
            
            return ConversationSummaryResult.builder()
                .conversationId(conversationId)
                .summary(summary)
                .messageCount(messages.size())
                .build();
            
        } catch (Exception e) {
            log.error("Failed to summarize conversation: {}", conversationId, e);
            return ConversationSummaryResult.failed(e.getMessage());
        }
    }
    
    @Async
    public void performConversationMaintenance() {
        // 清理过期的对话
        LocalDateTime expirationTime = LocalDateTime.now().minusDays(30);
        List<AIConversation> expiredConversations = conversationRepository
            .findByLastActivityBefore(expirationTime);
        
        for (AIConversation conversation : expiredConversations) {
            if (conversation.getStatus() == ConversationStatus.ACTIVE) {
                // 归档对话
                archiveConversation(conversation);
            }
        }
        
        // 压缩长时间不活跃的对话历史
        compressInactiveConversations();
        
        // 生成对话分析报告
        generateConversationAnalytics();
    }
}
```

---

## 📊 性能监控

### 性能监控器

```java
@Service
public class PerformanceMonitor {
    
    @EventListener
    @Async
    public void handleAgentInvocation(AgentInvocationEvent event) {
        // 记录调用指标
        recordInvocationMetrics(event);
        
        // 更新实时统计
        updateRealtimeStatistics(event);
        
        // 检查性能阈值
        checkPerformanceThresholds(event);
    }
    
    private void recordInvocationMetrics(AgentInvocationEvent event) {
        PlatformMetrics metrics = PlatformMetrics.builder()
            .platformId(event.getPlatformId())
            .agentId(event.getAgentId())
            .requestId(event.getRequestId())
            .responseTime(event.getResponseTime())
            .tokenUsage(event.getTokenUsage())
            .success(event.isSuccess())
            .errorCode(event.getErrorCode())
            .timestamp(event.getTimestamp())
            .build();
        
        platformMetricsRepository.save(metrics);
    }
    
    public PerformanceReport generatePerformanceReport(String agentId, LocalDate fromDate, LocalDate toDate) {
        // 获取性能数据
        List<PlatformMetrics> metrics = platformMetricsRepository
            .findByAgentIdAndDateRange(agentId, fromDate, toDate);
        
        // 计算核心指标
        PerformanceIndicators indicators = calculatePerformanceIndicators(metrics);
        
        // 分析趋势
        PerformanceTrends trends = analyzePerformanceTrends(metrics);
        
        // 识别性能问题
        List<PerformanceIssue> issues = identifyPerformanceIssues(metrics, indicators);
        
        // 生成优化建议
        List<OptimizationRecommendation> recommendations = generateOptimizationRecommendations(issues, trends);
        
        return PerformanceReport.builder()
            .agentId(agentId)
            .reportPeriod(DateRange.of(fromDate, toDate))
            .indicators(indicators)
            .trends(trends)
            .issues(issues)
            .recommendations(recommendations)
            .build();
    }
    
    private PerformanceIndicators calculatePerformanceIndicators(List<PlatformMetrics> metrics) {
        if (metrics.isEmpty()) {
            return PerformanceIndicators.empty();
        }
        
        // 响应时间统计
        DoubleSummaryStatistics responseTimeStats = metrics.stream()
            .mapToDouble(PlatformMetrics::getResponseTime)
            .summaryStatistics();
        
        // 成功率
        long successCount = metrics.stream().mapToLong(m -> m.isSuccess() ? 1 : 0).sum();
        double successRate = (double) successCount / metrics.size();
        
        // Token使用统计
        IntSummaryStatistics tokenStats = metrics.stream()
            .mapToInt(m -> m.getTokenUsage() != null ? m.getTokenUsage().getTotalTokens() : 0)
            .summaryStatistics();
        
        // 并发度统计
        Map<LocalDateTime, Long> concurrencyByHour = metrics.stream()
            .collect(Collectors.groupingBy(
                m -> m.getTimestamp().truncatedTo(ChronoUnit.HOURS),
                Collectors.counting()
            ));
        
        double avgConcurrency = concurrencyByHour.values().stream()
            .mapToDouble(Long::doubleValue)
            .average()
            .orElse(0.0);
        
        return PerformanceIndicators.builder()
            .totalRequests(metrics.size())
            .successRate(successRate)
            .avgResponseTime(responseTimeStats.getAverage())
            .p95ResponseTime(calculatePercentile(metrics, 0.95))
            .p99ResponseTime(calculatePercentile(metrics, 0.99))
            .avgTokenUsage(tokenStats.getAverage())
            .avgConcurrency(avgConcurrency)
            .build();
    }
    
    @Scheduled(fixedRate = 60000) // 每分钟执行
    public void performRealtimeMonitoring() {
        // 监控所有活跃智能体
        List<AIAgent> activeAgents = agentRepository.findByStatus(AgentStatus.ACTIVE);
        
        for (AIAgent agent : activeAgents) {
            try {
                // 检查最近5分钟的性能
                LocalDateTime since = LocalDateTime.now().minusMinutes(5);
                List<PlatformMetrics> recentMetrics = platformMetricsRepository
                    .findByAgentIdAndTimestampAfter(agent.getId(), since);
                
                // 计算实时指标
                RealtimeMetrics realtimeMetrics = calculateRealtimeMetrics(recentMetrics);
                
                // 检查告警条件
                checkAlertConditions(agent, realtimeMetrics);
                
                // 更新实时缓存
                updateRealtimeCache(agent.getId(), realtimeMetrics);
                
            } catch (Exception e) {
                log.error("Failed to monitor agent performance: {}", agent.getId(), e);
            }
        }
    }
    
    private void checkAlertConditions(AIAgent agent, RealtimeMetrics metrics) {
        // 响应时间告警
        if (metrics.getAvgResponseTime() > 10000) { // 10秒
            triggerAlert(AlertType.HIGH_RESPONSE_TIME, agent, 
                "平均响应时间过高: " + metrics.getAvgResponseTime() + "ms");
        }
        
        // 错误率告警
        if (metrics.getErrorRate() > 0.1) { // 10%
            triggerAlert(AlertType.HIGH_ERROR_RATE, agent, 
                "错误率过高: " + (metrics.getErrorRate() * 100) + "%");
        }
        
        // 并发数告警
        if (metrics.getConcurrentRequests() > agent.getMaxConcurrentSessions()) {
            triggerAlert(AlertType.HIGH_CONCURRENCY, agent, 
                "并发请求数过高: " + metrics.getConcurrentRequests());
        }
        
        // Token消耗告警
        if (metrics.getTokenUsageRate() > 1000) { // 每分钟1000 tokens
            triggerAlert(AlertType.HIGH_TOKEN_USAGE, agent, 
                "Token消耗过高: " + metrics.getTokenUsageRate() + " tokens/min");
        }
    }
}
```

---

## 📊 监控指标

### 核心业务指标

```yaml
AI智能体指标:
  可用性指标:
    - 智能体在线率
    - 平台健康状态
    - 服务可用性(SLA)
    - 故障恢复时间(MTTR)
    
  性能指标:
    - 平均响应时间
    - P95/P99响应时间
    - 请求成功率
    - 并发处理能力
    
  质量指标:
    - 回答准确率
    - 用户满意度
    - 对话完成率
    - 知识库命中率
    
  成本指标:
    - Token使用量
    - API调用成本
    - 资源利用率
    - 成本效率比

系统技术指标:
  调度性能:
    - 调度决策时间
    - 负载均衡效果
    - 故障转移成功率
    - 调度准确率
    
  知识库性能:
    - 搜索响应时间
    - 索引更新时间
    - 搜索准确率
    - 缓存命中率
    
  工具执行:
    - 工具调用成功率
    - 工具执行时间
    - 工具可用性
    - 工具使用频率
```

---

**📅 最后更新**: 2025年1月 | **📝 版本**: v1.0 | **🎯 状态**: 设计完成

🎉 **AI智能体模块，构建统一的AI服务能力平台！**