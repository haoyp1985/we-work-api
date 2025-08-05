# 🤖 AI智能体管理系统

> 企业级多租户AI智能体统一管理平台，支持Dify、Coze、OpenAI、Claude等多平台集成

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Vue 3](https://img.shields.io/badge/Vue-3.4.0-4FC08D.svg)](https://vuejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0.0-3178C6.svg)](https://www.typescriptlang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🌟 系统特性

### 🎯 核心功能
- **智能体统一管理** - 创建、配置、监控AI智能体生命周期
- **多平台集成** - 支持Dify、Coze、OpenAI、Claude等主流AI平台
- **实时对话交互** - WebSocket实时聊天，支持流式响应
- **调用监控分析** - 详细的API调用记录、性能统计、成本分析
- **可视化监控面板** - ECharts图表展示，实时监控系统状态

### 🏗️ 技术架构
- **后端**: Spring Boot 3.2.0 + Spring Cloud微服务架构
- **前端**: Vue 3 + TypeScript + Element Plus
- **数据库**: MySQL 8.0 + Redis 7.0
- **消息队列**: RocketMQ 5.1
- **监控**: Prometheus + Grafana + Jaeger
- **容器化**: Docker + Docker Compose

### 🚀 系统优势
- **多租户架构** - 完整的租户隔离和权限管理
- **微服务设计** - 独立部署、弹性扩展、故障隔离
- **企业级安全** - JWT认证、RBAC权限、数据加密
- **高可用设计** - 熔断降级、限流保护、健康检查

## 📋 功能模块

### 1. 智能体管理
- 智能体创建与配置
- 参数调优与版本管理
- 状态监控与生命周期管理
- 批量操作与导入导出

### 2. 平台集成管理
- **Dify平台**: 完整的API集成，支持工作流和智能体
- **Coze平台**: 对话机器人配置和管理
- **OpenAI**: GPT系列模型集成
- **Claude**: Anthropic Claude模型支持

### 3. 对话交互
- 实时聊天界面
- 会话历史管理
- 多轮对话上下文
- 流式响应显示

### 4. 监控与分析
- API调用统计
- 性能指标监控
- 成本分析报表
- 错误率跟踪

## 🛠️ 快速开始

### 环境要求
- **Java**: JDK 17+
- **Node.js**: 18.0+
- **Docker**: 20.0+
- **MySQL**: 8.0+
- **Redis**: 7.0+

### 1. 克隆项目
```bash
git clone https://github.com/your-org/we-work-api.git
cd we-work-api
```

### 2. 启动基础设施 (Docker)
```bash
cd infrastructure/docker
docker-compose up -d mysql redis nacos
```

### 3. 初始化数据库
```bash
mysql -h127.0.0.1 -P23306 -uwework -pwework123456 < backend-refactor/ai-agent-service/sql/init-ai-agent-platform.sql
```

### 4. 启动后端服务
```bash
cd backend-refactor/ai-agent-service
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### 5. 启动前端应用
```bash
cd frontend/admin-web
npm install
npm run dev
```

### 6. 访问应用
- **前端应用**: http://localhost:3000
- **API网关**: http://localhost:18080
- **API文档**: http://localhost:18086/swagger-ui.html

## 📖 详细文档

### 用户手册
- [🚀 快速入门指南](docs/01-项目概述/DEPLOYMENT_GUIDE.md)
- [📋 功能使用说明](docs/08-开发工具/user-manual.md)
- [🔧 管理员指南](docs/08-开发工具/admin-guide.md)

### 技术文档  
- [🏗️ 架构设计](docs/03-架构设计/)
- [💾 数据库设计](docs/02-系统设计/database-scripts/)
- [🔌 API接口文档](docs/07-参考文档/API_REFERENCE.md)

### 部署运维
- [🐳 Docker部署指南](docs/06-部署运维/DEPLOYMENT_ARCHITECTURE_DESIGN.md)
- [⚙️ 配置管理](docs/08-开发工具/configuration-guide.md)
- [🔍 故障排除](docs/08-开发工具/troubleshooting-guide.md)

## 🎯 使用场景

### 企业AI助手
```javascript
// 创建企业客服智能体
const agent = await agentAPI.createAgent({
  name: "智能客服",
  description: "7×24小时客户服务助手",
  platformType: "DIFY",
  modelConfig: {
    modelName: "gpt-4",
    temperature: 0.7,
    maxTokens: 2048
  }
});
```

### 多平台管理
```javascript
// 配置多个AI平台
await platformAPI.createPlatformConfig({
  platformType: "DIFY",
  apiKey: "dify-api-key",
  baseUrl: "https://api.dify.ai"
});

await platformAPI.createPlatformConfig({
  platformType: "OPENAI", 
  apiKey: "openai-api-key",
  baseUrl: "https://api.openai.com"
});
```

### 对话交互
```javascript
// 发起对话
const conversation = await conversationAPI.createConversation({
  agentId: "agent-123",
  title: "产品咨询"
});

// 发送消息
const response = await conversationAPI.sendMessage({
  conversationId: conversation.id,
  content: "请介绍一下你们的产品特性"
});
```

## 📊 系统监控

### 关键指标
- **调用量**: 实时API调用统计
- **响应时间**: P95/P99延迟监控
- **成功率**: 错误率和成功率跟踪
- **成本**: 按平台的成本分析

### 监控面板
```bash
# Grafana监控面板
http://localhost:23000
账号: admin / wework123456

# Prometheus指标
http://localhost:29090

# Jaeger链路追踪  
http://localhost:26686
```

## 🤝 贡献指南

### 开发环境设置
1. Fork项目到个人仓库
2. 创建功能分支: `git checkout -b feature/新功能`
3. 提交变更: `git commit -am '添加新功能'`
4. 推送分支: `git push origin feature/新功能`
5. 提交Pull Request

### 代码规范
- **后端**: 遵循Spring Boot最佳实践，使用Checkstyle检查
- **前端**: 遵循Vue.js风格指南，使用ESLint检查
- **文档**: 使用Markdown格式，保持结构清晰

### 测试
```bash
# 后端测试
cd backend-refactor/ai-agent-service
./mvnw test

# 前端测试  
cd frontend/admin-web
npm run test

# 集成测试
./docs/08-开发工具/test-api-endpoints.sh
```

## 📄 许可证

本项目采用 [MIT许可证](LICENSE)。

## 🙏 致谢

感谢以下开源项目：
- [Spring Boot](https://spring.io/projects/spring-boot) - 强大的Java应用框架
- [Vue.js](https://vuejs.org/) - 渐进式JavaScript框架  
- [Element Plus](https://element-plus.org/) - 优秀的Vue UI组件库
- [ECharts](https://echarts.apache.org/) - 专业的数据可视化库

## 📞 联系我们

- **项目地址**: https://github.com/your-org/we-work-api
- **问题反馈**: [GitHub Issues](https://github.com/your-org/we-work-api/issues)
- **邮箱**: support@your-company.com
- **文档**: https://docs.your-company.com

---

⭐ 如果这个项目对你有帮助，请给我们一个星标！