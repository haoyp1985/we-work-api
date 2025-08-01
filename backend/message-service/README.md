# 消息发送服务 (Message Service)

企业微信管理平台的消息发送微服务，负责企微消息的发送、管理和回调处理等核心功能。

## 🚀 功能特性

### 核心功能
- **多类型消息发送**: 支持文本、图片、视频、文件、语音、链接、小程序等多种消息类型
- **批量消息发送**: 支持群发助手功能，批量发送消息到多个用户或群聊
- **异步消息发送**: 支持异步发送，提高系统响应速度
- **消息重试机制**: 自动重试失败的消息，确保消息发送成功率
- **回调处理**: 处理企微回调消息，实现消息状态同步

### 技术特性
- **多提供商支持**: 支持多个企微接口提供商，实现负载均衡和故障转移
- **RocketMQ消息队列**: 使用RocketMQ实现异步消息处理
- **Redis缓存**: 缓存消息状态和配置信息
- **微服务架构**: 基于Spring Cloud的微服务设计
- **监控告警**: 集成Prometheus + Micrometer指标监控
- **健康检查**: 完善的健康检查机制

## 📋 API接口

### 消息发送
- `POST /api/messages/send` - 同步发送消息
- `POST /api/messages/send/async` - 异步发送消息
- `POST /api/messages/send/batch` - 批量发送消息
- `POST /api/messages/{messageId}/retry` - 重试发送消息
- `DELETE /api/messages/{guid}/messages/{messageId}` - 撤回消息
- `GET /api/messages/{messageId}/status` - 获取消息状态

### 提供商管理
- `GET /api/providers` - 获取所有提供商
- `GET /api/providers/{providerCode}` - 获取指定提供商信息
- `GET /api/providers/default` - 获取默认提供商
- `GET /api/providers/health` - 提供商健康检查
- `GET /api/providers/stats` - 获取提供商统计

### 回调处理
- `POST /api/callbacks/webhook` - 接收企微回调
- `GET /api/callbacks/{guid}/recent` - 获取最近回调
- `GET /api/callbacks/{guid}/callbacks/{notifyType}` - 获取指定类型回调

### 健康检查
- `GET /api/health` - 服务健康检查
- `GET /actuator/health` - Spring Boot Actuator健康检查

## 🛠 技术栈

### 后端框架
- **Spring Boot 3.0+** - 应用框架
- **Spring Cloud 2023.x** - 微服务框架
- **Spring WebFlux** - 异步Web框架
- **Spring Data JPA** - 数据访问层
- **Spring Cloud Alibaba** - 阿里云微服务套件

### 消息队列
- **Apache RocketMQ 5.1+** - 消息队列
- **RocketMQ Spring Boot Starter** - Spring Boot集成

### 数据存储
- **MySQL 8.0** - 关系数据库
- **Redis 7.0** - 缓存和会话存储
- **MyBatis Plus** - ORM框架

### 监控运维
- **Prometheus** - 指标监控
- **Micrometer** - 指标收集
- **Spring Boot Actuator** - 运维端点
- **SLF4J + Logback** - 日志框架

## 🏗 架构设计

### 多提供商架构
```
MessageController
       ↓
MessageSendService
       ↓
WeWorkProviderManager
       ↓
[GuangzhouGuxingProvider] [BackupProviderA] [BackupProviderB]
       ↓                          ↓               ↓
    API调用                   API调用         API调用
```

### 消息流转架构
```
客户端请求 → MessageController → MessageSendService → 选择提供商 → 发送消息
                    ↓
             RocketMQ异步队列 → AsyncMessageConsumer → 处理消息
                    ↓
           企微回调 → CallbackController → RocketMQ → CallbackMessageConsumer
```

### 故障转移机制
1. **健康检查**: 定期检查提供商健康状态
2. **自动切换**: 主提供商失败时自动切换到备用提供商
3. **重试机制**: 支持自动重试和手动重试
4. **状态缓存**: 缓存消息发送状态，支持状态查询

## 📦 部署指南

### 前置要求
- Java 17+
- Maven 3.8+
- MySQL 8.0+
- Redis 7.0+
- RocketMQ 5.1+
- Nacos 2.2+

### 本地开发

1. **启动基础设施**
```bash
# 启动Docker基础设施
./scripts/start-infrastructure.sh
```

2. **编译项目**
```bash
# 编译整个项目
./scripts/build-message-service.sh
```

3. **启动服务**
```bash
# 启动消息服务
./scripts/run-message-service.sh
```

### Docker部署

1. **构建镜像**
```bash
cd backend/message-service
docker build -t wework-message-service:latest .
```

2. **运行容器**
```bash
docker run -d \
  --name wework-message-service \
  -p 8082:8082 \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/wework_platform \
  -e SPRING_DATA_REDIS_HOST=redis \
  -e ROCKETMQ_NAME_SERVER=rocketmq-nameserver:9876 \
  wework-message-service:latest
```

### Kubernetes部署

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: message-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: message-service
  template:
    metadata:
      labels:
        app: message-service
    spec:
      containers:
      - name: message-service
        image: wework-message-service:latest
        ports:
        - containerPort: 8082
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "k8s"
        resources:
          requests:
            memory: "512Mi"
            cpu: "0.5"
          limits:
            memory: "1Gi"
            cpu: "1"
        livenessProbe:
          httpGet:
            path: /message/api/health
            port: 8082
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /message/actuator/health
            port: 8082
          initialDelaySeconds: 30
          periodSeconds: 10
```

## ⚙️ 配置说明

### 应用配置 (application.yml)

```yaml
# 企微提供商配置
app:
  wework:
    providers:
      guangzhou-guxing:
        enabled: true
        priority: 1
        api-base-url: http://api.wework-provider.com
        timeout-ms: 30000
        retry-count: 3

# 消息配置
  message:
    async:
      enabled: true
      core-pool-size: 10
      max-pool-size: 50
    retry:
      max-attempts: 3
      delay-ms: 1000
    limits:
      max-batch-size: 200
      rate-limit-per-minute: 1000

# RocketMQ配置
rocketmq:
  name-server: localhost:9876
  producer:
    group: message-service-producer
    send-message-timeout: 3000
    retry-times-when-send-failed: 3
```

### 环境变量配置

| 环境变量 | 说明 | 默认值 |
|---------|------|--------|
| `SPRING_PROFILES_ACTIVE` | 激活的配置文件 | `dev` |
| `SPRING_DATASOURCE_URL` | 数据库连接URL | `jdbc:mysql://localhost:3306/wework_platform` |
| `SPRING_DATA_REDIS_HOST` | Redis主机 | `localhost` |
| `ROCKETMQ_NAME_SERVER` | RocketMQ NameServer地址 | `localhost:9876` |
| `APP_WEWORK_PROVIDERS_GUANGZHOU_GUXING_API_BASE_URL` | 广州孤星API地址 | 无 |

## 📊 监控指标

### 业务指标
- 消息发送总数
- 消息发送成功率
- 消息发送耗时
- 各消息类型发送分布
- 提供商使用分布

### 技术指标
- HTTP请求指标（QPS、响应时间、错误率）
- JVM指标（堆内存、GC、线程）
- 数据库连接池指标
- Redis连接指标
- RocketMQ指标

### 告警配置
- 消息发送成功率 < 95%
- 平均响应时间 > 5s
- 错误率 > 1%
- 提供商健康检查失败
- 内存使用率 > 80%

## 🔧 故障排查

### 常见问题

1. **消息发送失败**
   - 检查提供商健康状态：`GET /api/providers/health`
   - 查看错误日志：`logs/message-service.log`
   - 检查网络连通性

2. **异步消息处理慢**
   - 检查RocketMQ状态
   - 查看消费者堆积情况
   - 调整线程池配置

3. **回调处理异常**
   - 检查回调URL配置
   - 查看回调日志：`GET /api/callbacks/{guid}/recent`
   - 验证回调数据格式

### 日志分析

```bash
# 查看错误日志
tail -f logs/message-service.log | grep ERROR

# 查看消息发送日志
tail -f logs/message-service.log | grep "sendMessage"

# 查看回调处理日志
tail -f logs/message-service.log | grep "callback"
```

## 🧪 测试

### 单元测试
```bash
mvn test
```

### 集成测试
```bash
mvn test -P integration
```

### API测试
```bash
# 发送文本消息
curl -X POST http://localhost:8082/message/api/messages/send \
  -H "Content-Type: application/json" \
  -d '{
    "guid": "test-guid",
    "conversationId": "S:12345",
    "messageType": "TEXT",
    "content": "测试消息"
  }'
```

## 📚 更多文档

- [API文档](http://localhost:8082/message/swagger-ui.html)
- [企微协议文档](../../企微协议-广州孤星/)
- [系统设计文档](../../docs/02-系统设计/)
- [部署文档](../../docs/05-部署文档/)

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](../../LICENSE) 文件了解详情。