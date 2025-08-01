# Gateway Service - API网关服务

## 📖 服务简介

API网关服务是WeWork Platform的统一入口，提供路由转发、认证鉴权、限流熔断、跨域处理等功能。

## 🚀 核心功能

### 1. 路由管理
- **智能路由**: 基于路径、请求头、参数的动态路由
- **负载均衡**: 集成Spring Cloud LoadBalancer
- **服务发现**: 自动发现Nacos注册的服务
- **路径重写**: 支持路径前缀处理

### 2. 认证鉴权
- **JWT认证**: 无状态Token认证机制
- **自动鉴权**: 自动验证用户身份和权限
- **白名单**: 支持跳过认证的路径配置
- **用户上下文**: 自动注入用户信息到下游服务

### 3. 安全防护
- **CORS处理**: 跨域资源共享配置
- **限流保护**: Redis分布式限流
- **熔断降级**: 集成Sentinel熔断器
- **请求过滤**: 恶意请求拦截

### 4. 监控运维
- **健康检查**: 多维度健康状态监控
- **链路追踪**: 分布式请求链路跟踪
- **指标收集**: Prometheus指标暴露
- **日志记录**: 结构化访问日志

## 🏗️ 技术架构

### 核心技术栈
- **Spring Cloud Gateway 4.0**: 响应式网关框架
- **Spring Boot 3.0**: 基础应用框架
- **Nacos 2.2+**: 服务发现与配置中心
- **Redis 7.0**: 分布式缓存与限流
- **JWT**: 无状态认证Token
- **Sentinel**: 流量控制与熔断
- **Micrometer**: 监控指标收集

### 架构特点
- **响应式编程**: 基于WebFlux的非阻塞I/O
- **云原生**: 支持容器化和Kubernetes部署
- **高性能**: 毫秒级响应时间
- **高可用**: 无状态设计，支持水平扩展

## 📋 API接口

### 健康检查接口

| 接口路径 | 方法 | 描述 | 响应示例 |
|---------|------|------|----------|
| `/health/gateway` | GET | 网关服务状态 | `{"service":"gateway-service","status":"UP"}` |
| `/health/discovery` | GET | 服务发现状态 | `{"status":"UP","services":["account-service"]}` |
| `/health/redis` | GET | Redis连接状态 | `{"status":"UP","connection":"正常"}` |
| `/health/all` | GET | 综合健康检查 | `{"overallStatus":"UP","gateway":{...}}` |

### 路由规则

| 路径模式 | 目标服务 | 认证要求 | 限流配置 |
|---------|----------|----------|----------|
| `/api/accounts/**` | account-service | JWT认证 | 10req/s |
| `/api/messages/**` | message-service | JWT认证 | 100req/s |
| `/api/providers/**` | message-service | JWT认证 | 100req/s |
| `/api/callbacks/**` | message-service | 无需认证 | 100req/s |
| `/api/monitor/**` | monitor-service | JWT认证 | 50req/s |
| `/health/**` | 本地处理 | 无需认证 | 无限制 |

## 🔧 配置说明

### 环境变量

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `SERVER_PORT` | 8080 | 服务端口 |
| `NACOS_SERVER_ADDR` | localhost:8848 | Nacos服务地址 |
| `REDIS_HOST` | localhost | Redis主机地址 |
| `REDIS_PORT` | 6379 | Redis端口 |
| `JWT_SECRET` | wework-platform-gateway-secret-key-2024 | JWT密钥 |
| `JWT_EXPIRATION` | 86400 | JWT过期时间(秒) |

### 核心配置项

```yaml
# 限流配置
spring.cloud.gateway.filter.request-rate-limiter:
  replenishRate: 10  # 令牌桶填充速率
  burstCapacity: 20  # 突发容量
  requestedTokens: 1 # 每次请求消耗令牌数

# CORS配置
spring.cloud.gateway.globalcors:
  cors-configurations:
    '[/**]':
      allowedOriginPatterns: "*"
      allowedMethods: [GET,POST,PUT,DELETE,OPTIONS]
      allowCredentials: true
```

## 🚀 快速启动

### 本地开发

```bash
# 1. 启动基础设施
cd infrastructure/docker
docker-compose up -d nacos redis

# 2. 编译服务
cd backend
mvn clean compile -pl gateway-service

# 3. 运行服务
mvn spring-boot:run -pl gateway-service
```

### Docker运行

```bash
# 构建镜像
docker build -t wework-gateway:latest .

# 运行容器
docker run -d \
  --name wework-gateway \
  -p 8080:8080 \
  -e NACOS_SERVER_ADDR=nacos:8848 \
  -e REDIS_HOST=redis \
  wework-gateway:latest
```

## 📊 监控指标

### 关键指标

- **请求吞吐量**: `gateway_requests_total`
- **响应时间**: `gateway_request_duration_seconds`
- **错误率**: `gateway_errors_total`
- **限流计数**: `gateway_ratelimit_total`
- **JWT验证**: `gateway_jwt_validation_total`

### 监控面板

访问 Grafana: http://localhost:3000
- 网关监控面板: Dashboard ID 12345
- 实时流量监控: Dashboard ID 12346

## 🔍 故障排查

### 常见问题

1. **服务发现失败**
   ```bash
   # 检查Nacos连接
   curl http://localhost:8848/nacos/v1/ns/operator/servers
   ```

2. **JWT认证失败**
   ```bash
   # 检查token格式
   echo "your-jwt-token" | base64 -d
   ```

3. **Redis连接异常**
   ```bash
   # 检查Redis连接
   redis-cli -h localhost -p 6379 ping
   ```

### 日志级别调整

```yaml
logging:
  level:
    com.wework.platform.gateway: DEBUG
    org.springframework.cloud.gateway: INFO
    reactor.netty: TRACE
```

## 📈 性能优化

### JVM调优

```bash
# 生产环境JVM参数
-Xms1g -Xmx2g
-XX:+UseG1GC
-XX:G1HeapRegionSize=16m
-XX:+UseStringDeduplication
-XX:+UseCompressedOops
```

### 网关调优

```yaml
# 连接池配置
spring.cloud.gateway.httpclient:
  pool:
    max-connections: 1000
    max-idle-time: 30s
  connect-timeout: 3000
  response-timeout: 30s
```

## 🛡️ 安全最佳实践

1. **JWT密钥管理**: 使用环境变量或密钥管理服务
2. **HTTPS配置**: 生产环境启用TLS
3. **限流策略**: 根据业务场景调整限流参数
4. **日志脱敏**: 敏感信息不记录到日志
5. **定期轮换**: 定期更换JWT密钥

## 📞 技术支持

- **项目地址**: https://github.com/wework-platform/gateway-service
- **问题反馈**: https://github.com/wework-platform/gateway-service/issues
- **技术文档**: https://docs.wework-platform.com/gateway
- **联系方式**: tech-support@wework-platform.com