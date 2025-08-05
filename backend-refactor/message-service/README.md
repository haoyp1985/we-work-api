# Message Service - 消息发送服务

## 概述

消息发送服务是WeWork平台的核心服务之一，负责处理所有消息的发送、管理和统计功能。

## 功能特性

### 🚀 核心功能
- **消息发送**: 支持文本、图片、文件、链接、小程序等多种消息类型
- **模板管理**: 支持消息模板的创建、编辑、删除和预览
- **任务调度**: 支持定时消息发送、批量消息处理
- **统计分析**: 提供详细的消息发送统计和分析报告

### 🛡️ 企业级特性
- **高可用性**: 支持集群部署，提供故障转移能力
- **高性能**: 异步消息处理，支持高并发场景
- **可扩展性**: 微服务架构，支持水平扩展
- **可观测性**: 完整的监控、日志和链路追踪

### 🔧 技术特性
- **消息去重**: 防止重复发送消息
- **失败重试**: 智能重试机制，支持多种退避策略
- **限流保护**: 多级别限流，保护系统稳定性
- **缓存优化**: 多级缓存，提升性能

## 技术架构

### 技术栈
- **Java 17**: 运行时环境
- **Spring Boot 3.2.0**: 应用框架
- **Spring Cloud 2023.0.0**: 微服务框架
- **MyBatis-Plus**: 数据访问层
- **MySQL 8.0**: 主数据库
- **Redis 7.0**: 缓存和队列
- **Nacos**: 服务发现和配置中心

### 架构层次
```
┌─────────────────────────────────────┐
│           Controller Layer           │  API接口层
├─────────────────────────────────────┤
│            Service Layer            │  业务逻辑层
├─────────────────────────────────────┤
│          Repository Layer           │  数据访问层
├─────────────────────────────────────┤
│           Database Layer            │  数据存储层
└─────────────────────────────────────┘
```

## 项目结构

```
message-service/
├── src/main/java/com/wework/platform/message/
│   ├── MessageServiceApplication.java          # 启动类
│   ├── config/                                # 配置类
│   │   └── MessageServiceConfig.java
│   ├── controller/                            # 控制器层
│   │   ├── MessageController.java
│   │   ├── MessageTemplateController.java
│   │   └── MessageTaskController.java
│   ├── service/                               # 服务层
│   │   ├── MessageService.java
│   │   ├── MessageTemplateService.java
│   │   ├── MessageTaskService.java
│   │   └── impl/                             # 服务实现
│   ├── repository/                           # 数据访问层
│   │   ├── MessageRepository.java
│   │   ├── MessageTemplateRepository.java
│   │   └── MessageTaskRepository.java
│   ├── entity/                               # 实体类
│   │   ├── Message.java
│   │   ├── MessageTemplate.java
│   │   └── MessageTask.java
│   ├── dto/                                  # 数据传输对象
│   │   ├── MessageDTO.java
│   │   ├── SendMessageRequest.java
│   │   └── ...
│   ├── client/                               # 外部服务客户端
│   │   └── WeWorkClient.java
│   └── event/                                # 事件处理
│       ├── MessageSentEvent.java
│       └── TaskExecutionEvent.java
├── src/main/resources/
│   ├── application.yml                        # 应用配置
│   ├── bootstrap.yml                          # Nacos配置
│   └── logback-spring.xml                     # 日志配置
├── Dockerfile                                 # Docker镜像构建
├── pom.xml                                    # Maven配置
└── README.md                                  # 项目说明
```

## 数据模型

### 核心实体

#### Message (消息记录)
- `id`: 消息ID
- `tenant_id`: 租户ID
- `message_type`: 消息类型 (0:文本, 1:图片, 2:文件, 3:链接, 4:小程序, 5:富文本)
- `content`: 消息内容
- `sender_id`: 发送者ID
- `receiver_id`: 接收者ID
- `status`: 消息状态 (0:待发送, 1:发送中, 2:发送成功, 3:发送失败, 4:已撤回)
- `sent_at`: 发送时间
- `created_at`: 创建时间
- `updated_at`: 更新时间

#### MessageTemplate (消息模板)
- `id`: 模板ID
- `tenant_id`: 租户ID
- `template_name`: 模板名称
- `message_type`: 消息类型
- `template_content`: 模板内容
- `description`: 模板描述
- `enabled`: 是否启用
- `created_at`: 创建时间
- `updated_at`: 更新时间

#### MessageTask (消息任务)
- `id`: 任务ID
- `tenant_id`: 租户ID
- `task_name`: 任务名称
- `template_id`: 模板ID
- `receiver_type`: 接收者类型
- `receiver_list`: 接收者列表
- `scheduled_time`: 计划发送时间
- `status`: 任务状态
- `executed_at`: 实际执行时间
- `created_at`: 创建时间
- `updated_at`: 更新时间

## API接口

### 消息管理 (/messages)
- `POST /send` - 发送消息
- `POST /batch-send` - 批量发送消息
- `GET /` - 分页查询消息列表
- `GET /{messageId}` - 获取消息详情
- `POST /{messageId}/resend` - 重新发送消息
- `POST /{messageId}/recall` - 撤回消息
- `GET /statistics` - 获取消息统计

### 模板管理 (/templates)
- `GET /` - 分页查询模板列表
- `POST /` - 创建消息模板
- `PUT /{templateId}` - 更新消息模板
- `DELETE /{templateId}` - 删除消息模板
- `POST /{templateId}/preview` - 预览模板内容
- `GET /enabled` - 获取启用的模板

### 任务管理 (/tasks)
- `GET /` - 分页查询任务列表
- `POST /` - 创建消息任务
- `POST /{taskId}/cancel` - 取消任务
- `POST /{taskId}/pause` - 暂停任务
- `POST /{taskId}/resume` - 恢复任务
- `GET /statistics` - 获取任务统计

## 配置说明

### 环境变量
- `PROFILE`: 运行环境 (dev/test/prod)
- `PORT`: 服务端口 (默认: 18082)
- `NACOS_ADDR`: Nacos地址
- `MYSQL_HOST`: MySQL主机
- `MYSQL_PORT`: MySQL端口
- `MYSQL_DATABASE`: 数据库名称
- `MYSQL_USERNAME`: 数据库用户名
- `MYSQL_PASSWORD`: 数据库密码
- `REDIS_HOST`: Redis主机
- `REDIS_PORT`: Redis端口
- `REDIS_PASSWORD`: Redis密码

### 核心配置
```yaml
app:
  message:
    weWork:
      apiBaseUrl: https://qyapi.weixin.qq.com
      connectTimeout: PT10S
      readTimeout: PT30S
    send:
      maxBatchSize: 100
      asyncEnabled: true
      asyncThreadPoolSize: 10
    retry:
      enabled: true
      maxAttempts: 3
      retryInterval: PT30S
    rateLimit:
      enabled: true
      maxRequestsPerSecond: 100
```

## 部署运行

### 本地开发
```bash
# 1. 启动依赖服务 (MySQL, Redis, Nacos)
cd infrastructure/docker
docker-compose up -d mysql redis nacos

# 2. 启动应用
cd backend-refactor/message-service
mvn spring-boot:run

# 3. 访问服务
# API文档: http://localhost:18082/message-service/swagger-ui.html
# 健康检查: http://localhost:18082/message-service/actuator/health
```

### Docker部署
```bash
# 1. 构建镜像
mvn clean package dockerfile:build

# 2. 运行容器
docker run -d \
  --name message-service \
  --network wework-network \
  -p 18082:18082 \
  -e PROFILE=prod \
  -e NACOS_ADDR=nacos:8848 \
  -e MYSQL_HOST=mysql \
  -e REDIS_HOST=redis \
  wework-platform/message-service:2.0.0

# 3. 查看日志
docker logs -f message-service
```

### Kubernetes部署
```bash
# 1. 应用配置
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

# 2. 部署服务
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# 3. 配置Ingress
kubectl apply -f k8s/ingress.yaml

# 4. 查看状态
kubectl get pods -l app=message-service
```

## 监控告警

### 健康检查
- **端点**: `/actuator/health`
- **指标**: 数据库连接、Redis连接、磁盘空间
- **频率**: 30秒检查一次

### 性能指标
- **JVM指标**: 内存使用、GC情况、线程数
- **应用指标**: 请求QPS、响应时间、错误率
- **业务指标**: 消息发送量、成功率、失败原因

### 日志监控
- **应用日志**: `/app/logs/message-service.log`
- **GC日志**: `/app/logs/gc.log`
- **审计日志**: 重要操作记录

## 故障排查

### 常见问题

#### 1. 服务启动失败
```bash
# 检查依赖服务
docker ps | grep -E "(mysql|redis|nacos)"

# 检查配置
kubectl get configmap message-service-config -o yaml

# 查看启动日志
kubectl logs -f deployment/message-service
```

#### 2. 消息发送失败
```bash
# 查看错误日志
grep ERROR /app/logs/message-service.log

# 检查企微API连接
curl -v https://qyapi.weixin.qq.com

# 检查数据库连接
kubectl exec -it mysql-pod -- mysql -u root -p
```

#### 3. 性能问题
```bash
# 查看JVM状态
jstat -gc <pid>

# 查看线程状态
jstack <pid>

# 查看系统资源
top -p <pid>
```

## 开发指南

### 代码规范
- 遵循阿里巴巴Java开发手册
- 使用CheckStyle进行代码检查
- 测试覆盖率要求 > 80%

### 提交规范
- 提交信息格式: `type(scope): description`
- 类型: feat, fix, docs, style, refactor, test, chore
- 范围: controller, service, repository, config, etc.

### 版本管理
- 主分支: `main`
- 开发分支: `develop`
- 特性分支: `feature/xxx`
- 修复分支: `hotfix/xxx`

## 许可证

Copyright © 2024 WeWork Platform Team. All rights reserved.