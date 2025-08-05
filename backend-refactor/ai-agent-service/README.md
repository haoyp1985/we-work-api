# AI智能体服务 (ai-agent-service)

WeWork平台的AI智能体管理服务，提供智能体配置、对话管理、外部平台集成等核心功能。

## 功能特性

### 🤖 智能体管理
- **智能体配置**: 支持多种智能体类型(聊天助手、工作流等)
- **版本管理**: 智能体配置的版本控制和发布管理
- **状态管理**: 草稿、已发布、已停用等状态流转
- **权限控制**: 基于租户和用户的权限管理

### 🔗 外部平台集成
- **Coze平台**: 集成字节跳动Coze智能体平台
- **Dify平台**: 集成Dify开源AI应用平台
- **阿里百炼**: 直接对接阿里云DashScope大模型服务
- **扩展支持**: 支持其他AI平台的快速集成

### 💬 对话管理
- **多轮对话**: 支持上下文感知的多轮对话
- **会话管理**: 会话创建、维护、清理
- **消息路由**: 智能路由到合适的AI平台或模型
- **实时通信**: 支持流式响应和实时消息

### 📊 监控统计
- **调用记录**: 详细的API调用日志和统计
- **性能监控**: 响应时间、成功率等关键指标
- **成本管控**: 外部平台调用成本跟踪
- **告警机制**: 异常情况的实时告警

## 技术架构

### 核心技术栈
- **框架**: Spring Boot 3.2.0
- **数据库**: MySQL 8.0 + MyBatis-Plus
- **缓存**: Redis 7.0
- **消息队列**: RocketMQ 4.8.0
- **服务发现**: Nacos
- **监控**: Prometheus + Grafana
- **文档**: OpenAPI 3.0 (Swagger)

### 架构层次
```
┌─────────────────┐
│   Controller    │  REST API层
├─────────────────┤
│    Service      │  业务逻辑层
├─────────────────┤
│   Repository    │  数据访问层
├─────────────────┤
│    Entity       │  实体模型层
└─────────────────┘
```

### 外部集成
```
ai-agent-service
├── Coze平台集成
├── Dify平台集成
├── 阿里百炼集成
└── 其他平台扩展
```

## 快速开始

### 环境要求
- Java 17+
- MySQL 8.0+
- Redis 7.0+
- RocketMQ 4.8.0+
- Nacos 2.2.0+

### 数据库初始化
```sql
-- 创建数据库
CREATE DATABASE ai_agent_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER 'ai_agent_user'@'%' IDENTIFIED BY 'ai_agent_password';
GRANT ALL PRIVILEGES ON ai_agent_platform.* TO 'ai_agent_user'@'%';
FLUSH PRIVILEGES;
```

### 本地开发
```bash
# 克隆项目
git clone <repository-url>
cd backend-refactor/ai-agent-service

# 构建项目
mvn clean compile

# 运行服务
mvn spring-boot:run

# 或使用IDE直接运行 AgentServiceApplication.java
```

### Docker部署
```bash
# 构建镜像
docker build -t ai-agent-service:latest .

# 运行容器
docker run -d \
  --name ai-agent-service \
  -p 18086:18086 \
  -e PROFILE=prod \
  -e DB_HOST=mysql \
  -e REDIS_HOST=redis \
  -e NACOS_ADDR=nacos:8848 \
  ai-agent-service:latest
```

## API文档

### 服务地址
- 开发环境: http://localhost:18086
- API文档: http://localhost:18086/swagger-ui.html
- OpenAPI规范: http://localhost:18086/v3/api-docs

### 核心API

#### 智能体管理
```
GET    /api/v1/agents          # 获取智能体列表
POST   /api/v1/agents          # 创建智能体
GET    /api/v1/agents/{id}     # 获取智能体详情
PUT    /api/v1/agents/{id}     # 更新智能体
DELETE /api/v1/agents/{id}     # 删除智能体
```

#### 对话交互
```
POST   /api/v1/chat/send       # 发送消息
GET    /api/v1/chat/history    # 获取对话历史
POST   /api/v1/chat/stream     # 流式对话
```

#### 配置管理
```
GET    /api/v1/platforms       # 获取平台配置
POST   /api/v1/platforms       # 创建平台配置
GET    /api/v1/models          # 获取模型配置
POST   /api/v1/models          # 创建模型配置
```

## 配置说明

### 应用配置
```yaml
app:
  agent:
    platforms:
      coze:
        base-url: https://www.coze.cn
        timeout: 60000
      dify:
        base-url: https://dify.ai
        timeout: 60000
      alibaba-dashscope:
        base-url: https://dashscope.aliyuncs.com
        timeout: 60000
    models:
      default-timeout: 60000
      max-tokens: 4096
      temperature: 0.7
```

### 环境变量
```bash
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ai_agent_platform
DB_USERNAME=ai_agent_user
DB_PASSWORD=ai_agent_password

# Redis配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=6

# Nacos配置
NACOS_ADDR=localhost:8848
NACOS_NAMESPACE=dev
NACOS_GROUP=DEFAULT_GROUP

# 外部平台配置
COZE_BASE_URL=https://www.coze.cn
DIFY_BASE_URL=https://dify.ai
ALIBABA_DASHSCOPE_BASE_URL=https://dashscope.aliyuncs.com
```

## 监控运维

### 健康检查
```bash
# 应用健康状态
curl http://localhost:18086/actuator/health

# 详细指标
curl http://localhost:18086/actuator/metrics

# Prometheus指标
curl http://localhost:18086/actuator/prometheus
```

### 日志管理
```bash
# 查看应用日志
tail -f logs/ai-agent-service.log

# 查看错误日志
tail -f logs/ai-agent-service-error.log

# 查看AI调用日志
tail -f logs/ai-agent-service-ai-call.log
```

### 性能调优
- **数据库连接池**: HikariCP配置优化
- **Redis连接池**: Lettuce连接池调优
- **线程池配置**: AI调用、消息处理专用线程池
- **缓存策略**: 多级缓存提升响应性能

## 开发指南

### 添加新的AI平台集成
1. 在`PlatformType`枚举中添加新平台类型
2. 在`PlatformIntegrationServiceImpl`中实现调用逻辑
3. 在配置文件中添加平台配置项
4. 编写单元测试验证集成

### 扩展智能体类型
1. 在`AgentType`枚举中添加新类型
2. 在`AgentServiceImpl`中添加相应处理逻辑
3. 更新前端界面支持新类型
4. 完善文档和测试用例

## 故障排查

### 常见问题
1. **数据库连接失败**: 检查数据库配置和网络连通性
2. **Redis连接异常**: 确认Redis服务状态和连接参数
3. **外部平台调用超时**: 检查网络和平台服务状态
4. **Nacos注册失败**: 验证Nacos服务和配置

### 日志分析
- 使用结构化日志快速定位问题
- AI调用日志包含完整的请求响应信息
- 错误日志提供详细的异常堆栈

## 贡献指南

1. Fork项目并创建特性分支
2. 编写代码并确保测试通过
3. 遵循代码规范和注释要求
4. 提交Pull Request并描述变更内容

## 版本历史

### v1.0.0 (2024-01-15)
- 初始版本发布
- 支持Coze、Dify、阿里百炼平台集成
- 完整的智能体管理功能
- 基础的监控和日志系统

## 许可证

内部使用项目，版权归WeWork平台团队所有。