# WeWork Platform 后端服务配置梳理总结

## 📋 项目概述

WeWork Platform 是一个基于微服务架构的企微平台，包含网关服务、账号服务、消息服务等核心组件。

### 🏗️ 技术栈

- **Java**: Java 17
- **Spring Boot**: 3.2.0
- **Spring Cloud**: 2023.0.0 
- **Spring Cloud Alibaba**: 2022.0.0.0
- **MyBatis Plus**: 3.5.12
- **数据库**: MySQL 8.0
- **缓存**: Redis 7.0
- **消息队列**: RocketMQ 5.1
- **服务注册/配置**: Nacos 2.3.2

## 🎯 服务架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Gateway       │    │   Account       │    │   Message       │
│   Service       │───▶│   Service       │───▶│   Service       │
│   (端口: 18080) │    │   (端口: 18081) │    │   (端口: 18082) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     Nacos       │
                    │  (端口: 28848)  │
                    └─────────────────┘
```

## ⚙️ 配置文件结构

### 1. 本地配置文件 (`application.yml`)

各服务的本地配置文件都采用统一的结构：

```yaml
spring:
  application:
    name: {service-name}
  config:
    import:
      - optional:nacos:basic-config-dev.yml      # 基础配置
      - optional:nacos:data-config-dev.yml       # 数据配置(可选)
      - optional:nacos:{service}-dev.yml          # 服务特定配置
  cloud:
    nacos:
      config:
        server-addr: localhost:28848
        group: wework-platform
        file-extension: yml
        username: nacos
        password: nacos
      discovery:
        server-addr: localhost:28848
        username: nacos
        password: nacos
```

### 2. Nacos配置文件分层结构

#### 🔧 `basic-config-dev.yml` - 基础共享配置
```yaml
# 适用于: 所有服务
# 包含内容:
- JWT配置
- 加密配置  
- 监控配置
- 日志配置
```

#### 💾 `data-config-dev.yml` - 数据服务配置
```yaml
# 适用于: account-service, message-service
# 包含内容:
- MySQL数据源配置
- Redis配置
- MyBatis Plus配置
- 缓存配置
```

#### 🔀 `gateway-service-dev.yml` - 网关服务配置
```yaml
# 包含内容:
- 服务端口: 8080
- 路由规则配置
- 跨域配置
- 限流配置
```

#### 👤 `account-service-dev.yml` - 账号服务配置
```yaml
# 包含内容:
- 服务端口: 8081
- RocketMQ配置
- 业务特定配置
```

#### 📨 `message-service-dev.yml` - 消息服务配置
```yaml
# 包含内容:
- 服务端口: 8082
- RocketMQ配置
- WeWork Provider配置
```

## 🚀 启动方式

### 1. 基础设施启动
```bash
# 启动MySQL、Redis、Nacos、RocketMQ等基础设施
./scripts/start-infrastructure.sh
```

### 2. 统一服务管理 (推荐)
```bash
# 构建所有服务
./scripts/manage-services.sh build all

# 启动所有服务 (按顺序: gateway -> account -> message)
./scripts/manage-services.sh start all

# 检查服务状态
./scripts/manage-services.sh status

# 检查健康状态
./scripts/manage-services.sh health

# 停止所有服务
./scripts/manage-services.sh stop all

# 查看特定服务日志
./scripts/manage-services.sh logs gateway

# 重启特定服务
./scripts/manage-services.sh restart account
```

### 3. 单独服务管理
```bash
# 构建单个服务
./scripts/build-gateway-service.sh
./scripts/build-account-service.sh  
./scripts/build-message-service.sh

# 启动单个服务
./scripts/run-gateway-service.sh
./scripts/run-account-service.sh
./scripts/run-message-service.sh
```

## 🔧 重要修复记录

### 1. 技术栈统一
- ✅ 移除了Spring Data JPA，统一使用MyBatis Plus
- ✅ 升级MyBatis Plus到3.5.12，解决Spring Boot 3.x兼容性
- ✅ 移除了所有`bootstrap.yml`文件，使用`spring.config.import`

### 2. 配置清理
- ✅ 清理了Nacos配置中的JPA残留配置
- ✅ 统一了Nacos连接参数和认证信息
- ✅ 优化了配置分层结构，提高可维护性

### 3. 依赖解决
- ✅ 解决了`factoryBeanObjectType`错误
- ✅ 解决了`PaginationInnerInterceptor`找不到的问题
- ✅ 修复了RocketMQ API兼容性问题
- ✅ 修复了Spring WebFlux WebClient API使用问题

## 📊 服务状态检查

### 健康检查端点
- Gateway: http://localhost:18080/api/health
- Account: http://localhost:18081/api/health  
- Message: http://localhost:18082/api/health

### Nacos控制台
- 地址: http://localhost:28848/nacos
- 用户名: nacos
- 密码: nacos

## 📁 项目结构
```
backend/
├── common/                 # 公共模块
├── gateway-service/        # 网关服务
├── account-service/        # 账号服务
├── message-service/        # 消息服务
├── callback-service/       # 回调服务 (未实现)
├── monitor-service/        # 监控服务 (未实现)
└── pom.xml                # 父POM

nacos-configs/             # Nacos配置文件
├── basic-config-dev.yml
├── data-config-dev.yml
├── gateway-service-dev.yml
├── account-service-dev.yml
└── message-service-dev.yml

scripts/                   # 启动脚本
├── start-infrastructure.sh
├── manage-services.sh     # 统一服务管理 (新增)
├── build-*.sh
└── run-*.sh
```

## 🎯 下一步计划

1. **完善监控体系**: 集成Prometheus + Grafana
2. **完善日志体系**: 集成ELK或类似方案
3. **完善测试**: 单元测试和集成测试
4. **容器化部署**: Docker + K8s支持
5. **CI/CD流水线**: 自动化构建和部署

## 🔍 常见问题

### Q1: 服务启动失败，提示Nacos连接失败
A: 检查Nacos容器是否正常运行，端口是否为28848

### Q2: MyBatis Plus分页不生效
A: 确保使用了最新的配置和依赖版本，已在common模块中正确配置

### Q3: RocketMQ连接失败
A: 检查RocketMQ容器状态，确保NameServer端口29876正常

### Q4: 服务注册到Nacos失败
A: 检查Nacos用户名密码配置，确保为nacos/nacos

---

**配置梳理完成时间**: 2025-07-31  
**维护人员**: WeWork Platform Team  
**配置文件版本**: v1.0-stable