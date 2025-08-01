# 账号管理服务 (Account Service)

企业微信管理平台的账号管理微服务，负责企微账号的创建、登录、状态监控等核心功能。

## 🚀 功能特性

### 核心功能
- **账号管理**: 创建、更新、删除企微账号
- **登录管理**: 生成登录二维码、验证登录验证码
- **状态监控**: 实时监控账号在线状态、心跳检测
- **批量操作**: 支持批量获取账号状态
- **缓存优化**: Redis缓存提升性能

### 技术特性
- **微服务架构**: 基于Spring Cloud的微服务设计
- **数据持久化**: MyBatis Plus + MySQL
- **消息队列**: RabbitMQ异步消息处理
- **服务注册**: Nacos服务注册与发现
- **监控告警**: Prometheus + Micrometer指标监控
- **API文档**: OpenAPI 3.0自动生成文档

## 📋 API接口

### 账号管理
- `POST /api/accounts` - 创建账号
- `GET /api/accounts/{accountId}` - 获取账号详情
- `GET /api/accounts` - 分页查询账号
- `PUT /api/accounts/{accountId}` - 更新账号
- `DELETE /api/accounts/{accountId}` - 删除账号

### 登录管理
- `POST /api/accounts/{accountId}/login` - 账号登录
- `POST /api/accounts/{accountId}/logout` - 账号登出
- `POST /api/accounts/{accountId}/verify-code` - 验证登录验证码
- `POST /api/accounts/{accountId}/restart` - 重启账号

### 状态监控
- `GET /api/accounts/{accountId}/status` - 获取账号状态
- `POST /api/accounts/batch/status` - 批量获取账号状态

### 健康检查
- `GET /api/health` - 服务健康检查
- `GET /actuator/health` - Spring Boot健康端点
- `GET /actuator/prometheus` - Prometheus指标端点

## 🛠️ 快速开始

### 前置条件
- Java 17+
- Maven 3.8+
- MySQL 8.0+
- Redis 7.0+
- RabbitMQ 3.11+
- Nacos 2.2+

### 本地开发

1. **启动基础设施**
   ```bash
   # 在项目根目录执行
   ./scripts/start-infrastructure.sh
   ```

2. **配置数据库**
   ```bash
   # 数据库会自动初始化，默认配置：
   # 地址: localhost:3306
   # 数据库: wework_platform
   # 用户名: wework
   # 密码: wework123456
   ```

3. **配置应用**
   ```yaml
   # application-dev.yml
   wework:
     api:
       base-url: http://192.168.3.122:23456  # 企微API地址
     account:
       heartbeat-interval: 30  # 心跳间隔(秒)
   ```

4. **启动服务**
   ```bash
   cd backend/account-service
   mvn spring-boot:run
   ```

5. **访问服务**
   - 服务地址: http://localhost:8081/account
   - API文档: http://localhost:8081/account/swagger-ui.html
   - 健康检查: http://localhost:8081/account/api/health

### Docker部署

1. **构建镜像**
   ```bash
   cd backend/account-service
   docker build -t wework/account-service:1.0.0 .
   ```

2. **启动服务**
   ```bash
   docker-compose up -d
   ```

## 📊 监控指标

### 业务指标
- `account_total` - 账号总数
- `account_online` - 在线账号数
- `account_login_requests` - 登录请求数
- `account_heartbeat_failures` - 心跳失败数

### 技术指标
- `http_requests_total` - HTTP请求总数
- `http_request_duration_seconds` - HTTP请求耗时
- `jvm_memory_used_bytes` - JVM内存使用
- `database_connections_active` - 数据库连接数

## 🔧 配置说明

### 核心配置
```yaml
wework:
  api:
    base-url: http://192.168.3.122:23456  # 企微API基础地址
    timeout: 30000  # API超时时间(毫秒)
  account:
    heartbeat-interval: 30  # 心跳检查间隔(秒)
    max-retry-times: 3  # 最大重试次数
    login-timeout: 300  # 登录超时时间(秒)
  cache:
    account-expire: 3600  # 账号缓存过期时间(秒)
    status-expire: 300  # 状态缓存过期时间(秒)
```

### 数据库配置
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/wework_platform
    username: wework
    password: wework123456
    driver-class-name: com.mysql.cj.jdbc.Driver
```

### Redis配置
```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      database: 0
```

## 🧪 测试

### 单元测试
```bash
mvn test
```

### 集成测试
```bash
mvn verify
```

### API测试
使用Postman或curl测试API：

```bash
# 创建账号
curl -X POST http://localhost:8081/account/api/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "tenantId": "default-tenant-id-001",
    "accountName": "测试账号",
    "phone": "13800138000"
  }'

# 获取账号列表
curl "http://localhost:8081/account/api/accounts?tenantId=default-tenant-id-001&page=1&size=10"
```

## 📝 开发规范

### 代码规范
- 使用Java 17语法特性
- 遵循Spring Boot最佳实践
- 统一异常处理
- 完善的日志记录

### API规范
- RESTful API设计
- 统一响应格式
- 完整的参数校验
- 详细的API文档

### 数据库规范
- 数据库表统一前缀
- 必要的索引优化
- 软删除机制
- 审计字段

## 🔍 故障排查

### 常见问题

1. **服务启动失败**
   - 检查数据库连接配置
   - 确认Redis服务状态
   - 查看Nacos注册中心

2. **账号登录失败**
   - 检查企微API连接性
   - 查看企微实例状态
   - 检查登录超时配置

3. **心跳检查异常**
   - 查看心跳间隔配置
   - 检查企微实例运行状态
   - 查看网络连接

### 日志位置
- 应用日志: `logs/account-service.log`
- 错误日志: `logs/error.log`
- 访问日志: `logs/access.log`

## 📚 相关文档

- [系统设计文档](../../docs/02-系统设计/SYSTEM_DESIGN.md)
- [API接口设计](../../docs/03-架构设计/API_INTERFACE_DESIGN.md)
- [数据库设计](../../docs/03-架构设计/DATABASE_DESIGN.md)
- [部署文档](../../docs/06-部署运维/DEPLOYMENT_ARCHITECTURE_DESIGN.md)