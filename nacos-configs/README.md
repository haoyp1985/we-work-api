# WeWork Platform Nacos 配置管理

## 📋 概述

本目录包含WeWork Platform微服务架构的所有Nacos配置文件，实现了配置的集中化管理。

## 📁 配置文件说明

| 文件名 | 描述 | 作用域 |
|--------|------|--------|
| `shared-config-dev.yml` | 共享配置文件 | 所有服务 |
| `gateway-service-dev.yml` | 网关服务配置 | 网关服务 |
| `account-service-dev.yml` | 账号管理服务配置 | 账号服务 |
| `message-service-dev.yml` | 消息服务配置 | 消息服务 |

## 🚀 快速部署

### 1. 自动部署（推荐）

使用提供的自动化脚本一键部署所有配置：

```bash
# 确保Nacos服务正在运行
docker ps | grep nacos

# 执行部署脚本
./nacos-configs/deploy-nacos-configs.sh
```

### 2. 手动部署

如果需要手动管理配置，可以通过Nacos控制台操作：

1. **访问Nacos控制台**
   - URL: http://localhost:28848/nacos/
   - 用户名: nacos
   - 密码: nacos

2. **创建配置**
   - 命名空间: public (默认)
   - 分组: wework-platform
   - 配置格式: YAML

## ⚙️ 配置详情

### 共享配置 (shared-config-dev.yml)

包含所有服务的公共配置：
- 数据库连接配置
- Redis缓存配置
- JWT令牌配置
- 日志配置
- 监控配置

### 网关服务配置 (gateway-service-dev.yml)

包含API网关的专属配置：
- 服务路由规则
- 负载均衡配置
- API文档聚合
- 限流熔断配置

### 账号服务配置 (account-service-dev.yml)

包含账号管理的业务配置：
- 企微API配置
- 账号管理规则
- 数据同步配置
- JPA数据库配置

### 消息服务配置 (message-service-dev.yml)

包含消息处理的业务配置：
- RocketMQ消息队列配置
- 消息发送策略
- 限流配置
- 模板管理配置

## 🔧 本地配置简化

部署Nacos配置后，需要简化本地的application.yml文件，只保留：

### gateway-service/application.yml
```yaml
spring:
  application:
    name: gateway-service
  config:
    import: 
      - optional:nacos:shared-config-dev.yml
      - optional:nacos:gateway-service-dev.yml
  cloud:
    nacos:
      config:
        server-addr: localhost:28848
        group: wework-platform
        file-extension: yml
      discovery:
        server-addr: localhost:28848
```

### account-service/application.yml
```yaml
spring:
  application:
    name: account-service
  config:
    import: 
      - optional:nacos:shared-config-dev.yml
      - optional:nacos:account-service-dev.yml
  cloud:
    nacos:
      config:
        server-addr: localhost:28848
        group: wework-platform
        file-extension: yml
      discovery:
        server-addr: localhost:28848
```

### message-service/application.yml
```yaml
spring:
  application:
    name: message-service
  config:
    import: 
      - optional:nacos:shared-config-dev.yml
      - optional:nacos:message-service-dev.yml
  cloud:
    nacos:
      config:
        server-addr: localhost:28848
        group: wework-platform
        file-extension: yml
      discovery:
        server-addr: localhost:28848
```

## 🔒 安全配置

### 环境变量

建议在生产环境中使用环境变量来管理敏感配置：

```bash
# 企微配置
export WEWORK_CORP_ID="your-corp-id"
export WEWORK_CORP_SECRET="your-corp-secret"
export WEWORK_AGENT_ID="your-agent-id"

# JWT配置
export JWT_SECRET="your-jwt-secret-key"
export PASSWORD_SALT="your-password-salt"
```

### 配置加密

对于敏感配置，建议使用Nacos的配置加密功能：

```yaml
# 使用ENC()包装敏感信息
spring:
  datasource:
    password: ENC(encrypted-password)
```

## 🐛 故障排除

### 常见问题

1. **配置不生效**
   - 检查服务名称是否正确
   - 确认Nacos分组和命名空间
   - 查看配置导入顺序

2. **连接Nacos失败**
   - 确认Nacos服务状态
   - 检查网络连接
   - 验证认证信息

3. **配置冲突**
   - 检查配置优先级
   - 避免同一配置在多个文件中定义
   - 使用spring.config.import控制加载顺序

### 调试命令

```bash
# 检查Nacos状态
curl http://localhost:28848/nacos/actuator/health

# 查看服务配置
curl "http://localhost:28848/nacos/v1/cs/configs?dataId=gateway-service-dev.yml&group=wework-platform"
```

## 📚 参考文档

- [Spring Cloud Alibaba Nacos Config](https://github.com/alibaba/spring-cloud-alibaba/wiki/Nacos-config)
- [Nacos官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)
- [Spring Boot Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)