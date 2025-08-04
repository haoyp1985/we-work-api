# 🏗️ 架构设计规则

## 📐 整体架构原则

### 1. 六层架构模式
```
用户接入层 → API网关层 → 业务服务层 → 中台服务层 → 数据存储层 → 基础设施层
```

**规则**:
- 严格按层次调用，不可跨层直接访问
- 每层职责单一，接口清晰
- 下层为上层提供服务，上层不依赖下层实现细节

### 2. 微服务边界划分
```yaml
核心业务域:
  - account-service: 企微账号管理
  - message-service: 消息发送管理  
  - monitor-service: 监控告警管理
  - ai-agent-service: AI智能体管理 [新增]
  - marketing-service: 营销活动管理 [新增]
  - order-service: 服务订单管理 [新增]
  - customer-service: 客户管理 [新增]

中台服务域:
  - gateway-service: API网关
  - callback-service: 回调处理
  - notification-service: 通知服务 [新增]
  - file-service: 文件服务 [新增]
  - config-service: 配置服务 [新增]
```

**规则**:
- 按业务域划分服务边界，高内聚低耦合
- 每个服务独立数据库，避免跨库事务
- 服务间通过API调用，禁止直接访问数据库

## 🔗 服务间通信规则

### 1. 同步调用
```java
// ✅ 正确 - 使用OpenFeign声明式调用
@FeignClient(name = "account-service")
public interface AccountClient {
    @GetMapping("/api/v1/accounts/{id}")
    Result<AccountDTO> getAccount(@PathVariable String id);
}

// ❌ 错误 - 直接HTTP调用
RestTemplate restTemplate = new RestTemplate();
String url = "http://account-service/api/v1/accounts/" + id;
```

**规则**:
- 必须使用OpenFeign进行服务间同步调用
- 启用Hystrix熔断器，设置合理超时时间
- 添加重试机制和降级策略

### 2. 异步通信
```java
// ✅ 正确 - 使用RocketMQ发送事件
@Service
public class AccountEventPublisher {
    
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void publishAccountCreated(AccountCreatedEvent event) {
        rocketMQTemplate.convertAndSend("account-topic:created", event);
    }
}

// ✅ 正确 - 消费事件
@Component
@RocketMQMessageListener(topic = "account-topic", selectorExpression = "created")
public class AccountCreatedListener implements RocketMQListener<AccountCreatedEvent> {
    @Override
    public void onMessage(AccountCreatedEvent event) {
        // 处理账号创建事件
    }
}
```

**规则**:
- 非关键路径使用异步消息通信
- 事件命名规范: {业务域}-{实体}-{动作}
- 消息必须包含租户ID和时间戳
- 确保消息幂等性处理

## 💾 数据架构规则

### 1. 分库分表策略
```yaml
数据库拆分:
  saas_unified_core: 统一核心层(24表) - 身份、权限、配置
  ai_agent_platform: AI智能体平台(20表) - 智能体管理
  wework_platform: 企微平台(15表) - 企微账号管理
  health_management: 健康管理(12表) - 体检预约
  core_business: 核心业务(15表) - 订单、营销
  customer_management: 客户管理(12表) - 客户关系
```

**规则**:
- 按业务域进行数据库拆分
- 每个微服务只能访问自己的数据库
- 跨库查询通过服务调用实现

### 2. 多租户设计
```sql
-- ✅ 正确 - 所有业务表必须包含tenant_id
CREATE TABLE wework_accounts (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,  -- 必须字段
    account_name VARCHAR(100) NOT NULL,
    -- 其他字段...
    INDEX idx_tenant_id (tenant_id)
);

-- ❌ 错误 - 缺少tenant_id字段
CREATE TABLE wework_accounts (
    id VARCHAR(36) PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL
    -- 缺少tenant_id
);
```

**规则**:
- 所有业务表必须包含tenant_id字段
- 查询时必须添加租户隔离条件
- 使用MyBatis-Plus多租户插件自动添加条件

## 🔧 技术栈规则

### 1. Spring Boot配置
```yaml
# application.yml 标准配置
spring:
  application:
    name: ${service.name}
  profiles:
    active: ${PROFILE:dev}
  cloud:
    nacos:
      discovery:
        server-addr: ${NACOS_ADDR:localhost:8848}
        namespace: ${NACOS_NAMESPACE:dev}
      config:
        server-addr: ${NACOS_ADDR:localhost:8848}
        namespace: ${NACOS_NAMESPACE:dev}
        file-extension: yml
        group: ${NACOS_GROUP:DEFAULT_GROUP}

# 统一端口规范
server:
  port: ${PORT:8080}
```

**规则**:
- 统一使用Nacos作为注册中心和配置中心
- 服务端口规范: gateway(8080), account(8081), message(8082)
- 配置外部化，支持多环境部署

### 2. 依赖管理
```xml
<!-- ✅ 正确 - 使用统一BOM管理版本 -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.2.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>2023.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

**规则**:
- 使用parent pom统一管理依赖版本
- 禁止在子模块中指定版本号
- 定期升级依赖版本，解决安全漏洞

## 🚀 部署架构规则

### 1. 容器化部署
```dockerfile
# ✅ 正确 - 多阶段构建
FROM openjdk:17-jdk-slim as builder
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**规则**:
- 使用多阶段构建减小镜像体积
- 基础镜像使用官方JRE镜像
- 镜像标签包含版本号和Git提交哈希

### 2. 服务发现配置
```yaml
# ✅ 正确 - Nacos服务注册配置
spring:
  cloud:
    nacos:
      discovery:
        server-addr: nacos:8848
        heart-beat-timeout: 30000
        ip-delete-timeout: 30000
        instance-enabled: true
        ephemeral: true
        metadata:
          version: ${app.version}
          zone: ${app.zone:default}
```

**规则**:
- 服务启动时自动注册到Nacos
- 设置合理的心跳和超时时间
- 包含必要的元数据信息