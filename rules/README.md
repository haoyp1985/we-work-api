# 📋 WeWork SaaS平台 - Cursor项目规则

## 🎯 规则文档概述

本目录包含了WeWork企业级SaaS平台的完整开发规则和最佳实践，专为Cursor AI编程助手设计，确保代码质量和架构一致性。

## 📚 规则文档结构

| 文档 | 描述 | 核心内容 |
|------|------|----------|
| [00-project-overview.md](./00-project-overview.md) | 📖 项目总览 | 技术栈、模块结构、开发约定 |
| [01-architecture-rules.md](./01-architecture-rules.md) | 🏗️ 架构规则 | 六层架构、微服务边界、服务通信 |
| [02-database-rules.md](./02-database-rules.md) | 💾 数据库规则 | 表设计、分库分表、索引优化 |
| [03-api-rules.md](./03-api-rules.md) | 🔌 API规则 | RESTful设计、认证授权、参数验证 |
| [04-code-standards.md](./04-code-standards.md) | 📝 代码规范 | 命名规范、异常处理、日志记录 |
| [05-microservice-rules.md](./05-microservice-rules.md) | 🏗️ 微服务规则 | 服务拆分、通信、治理、监控 |
| [06-security-rules.md](./06-security-rules.md) | 🔐 安全规范 | 认证授权、数据加密、防护策略 |
| [07-performance-rules.md](./07-performance-rules.md) | 🚀 性能规范 | 缓存策略、查询优化、异步处理 |
| [08-infrastructure-rules.md](./08-infrastructure-rules.md) | 🏗️ 基础设施规范 | Docker编排、监控体系、中间件配置 |
| [09-devops-rules.md](./09-devops-rules.md) | ⚙️ 运维规范 | 脚本开发、服务管理、CI/CD |
| [10-frontend-rules.md](./10-frontend-rules.md) | 🎨 前端规范 | Vue3+TS、组件设计、状态管理 |

## 🎯 使用指南

### 📋 在Cursor中使用

1. **项目初始化**: 首先阅读 `00-project-overview.md` 了解项目整体架构
2. **开发前准备**: 根据模块类型查阅相应规则文档
3. **编码过程**: 严格遵循代码规范和最佳实践
4. **代码审查**: 使用规则检查清单验证代码质量

### 🔍 快速查找规则

```bash
# 🏗️ 架构相关
- 服务拆分策略 → 01-architecture-rules.md
- 数据库设计 → 02-database-rules.md
- 微服务通信 → 05-microservice-rules.md

# 💻 代码质量
- 命名规范 → 04-code-standards.md
- 异常处理 → 04-code-standards.md
- 单元测试 → 04-code-standards.md

# 🔌 API设计
- RESTful规范 → 03-api-rules.md
- 参数验证 → 03-api-rules.md
- 认证授权 → 06-security-rules.md

# 🚀 性能优化
- 缓存策略 → 07-performance-rules.md
- 数据库优化 → 02-database-rules.md
- 异步处理 → 07-performance-rules.md

# 🏗️ 基础设施和运维
- Docker编排 → 08-infrastructure-rules.md
- 监控体系 → 08-infrastructure-rules.md
- 运维脚本 → 09-devops-rules.md
- 服务管理 → 09-devops-rules.md

# 🎨 前端开发
- Vue3组件 → 10-frontend-rules.md
- TypeScript → 10-frontend-rules.md
- 状态管理 → 10-frontend-rules.md
```

## 🔧 核心技术栈

```yaml
后端架构:
  框架: Spring Boot 3.2.0 + Spring Cloud 2023.0.0
  数据库: MySQL 8.0 (6个业务库，98张表)
  缓存: Redis 7.0 + Caffeine
  消息队列: RocketMQ 5.1
  服务治理: Nacos + OpenFeign + Hystrix
  监控: Prometheus + Grafana + Jaeger

前端技术:
  框架: Vue 3 + TypeScript + Element Plus
  构建: Vite + Pinia + SCSS

基础设施:
  容器化: Docker + Docker Compose
  CI/CD: Jenkins + GitLab
  监控: ELK Stack + Prometheus
```

## 📊 架构特征

### 🏗️ 六层架构模式
```
用户接入层 → API网关层 → 业务服务层 → 中台服务层 → 数据存储层 → 基础设施层
```

### 🔄 核心业务模块
```yaml
已实现:
  - account-service: 企微账号管理 ✅
  - message-service: 消息发送管理 ✅
  - gateway-service: API网关服务 ✅
  - monitor-service: 监控告警服务 ✅

待实现:
  - ai-agent-service: AI智能体管理
  - marketing-service: 营销活动管理
  - order-service: 服务订单管理
  - customer-service: 客户关系管理
```

### 💾 数据架构
```yaml
分库策略:
  saas_unified_core: 统一核心层(24表) - 身份权限配置
  ai_agent_platform: AI智能体平台(20表) - 智能体管理
  wework_platform: 企微平台(15表) - 账号状态跟踪
  health_management: 健康管理(12表) - 体检预约
  core_business: 核心业务(15表) - 订单营销
  customer_management: 客户管理(12表) - 客户关系
```

## ⚠️ 关键约束

### 🚫 禁止事项
- **禁止简化**: 核心业务逻辑(企微9状态、AI调度策略)不可简化
- **禁止跨库**: 微服务不能直接访问其他服务的数据库
- **禁止裸SQL**: 必须使用MyBatis-Plus或参数化查询
- **禁止硬编码**: 配置信息必须外部化

### ✅ 必须遵循
- **多租户隔离**: 所有业务表必须包含tenant_id
- **审计完整**: 重要操作必须记录审计日志
- **错误统一**: 使用统一异常处理和错误码
- **权限控制**: API接口必须进行权限验证
- **性能优化**: 查询必须使用索引，大批量操作分批处理

## 📁 完整项目目录结构

```
we-work-api/
├── backend/                    # 🏗️ 后端微服务
│   ├── account-service/        # 账户管理服务 ✅
│   ├── message-service/        # 消息发送服务 ✅
│   ├── gateway-service/        # API网关服务 ✅
│   ├── monitor-service/        # 监控服务 ✅
│   ├── callback-service/       # 回调处理服务 ✅
│   ├── common/                 # 通用模块 ✅
│   ├── pom.xml                 # 父级POM配置
│   └── README-配置梳理总结.md
│
├── frontend/                   # 🎨 前端应用
│   ├── admin-web/              # 管理后台 (Vue3+TS+Element Plus) ✅
│   │   ├── src/
│   │   │   ├── api/            # API接口层
│   │   │   ├── components/     # 通用组件
│   │   │   ├── views/          # 页面组件
│   │   │   ├── stores/         # Pinia状态管理
│   │   │   ├── router/         # Vue Router路由
│   │   │   ├── utils/          # 工具函数
│   │   │   ├── types/          # TypeScript类型
│   │   │   └── styles/         # SCSS样式
│   │   ├── package.json
│   │   └── vite.config.ts
│   └── monitor-dashboard/      # 监控大屏 🚧
│
├── infrastructure/             # 🏗️ 基础设施
│   ├── docker/                 # Docker编排配置
│   │   ├── docker-compose.yml  # 完整基础设施栈
│   │   ├── database/           # 数据库配置
│   │   ├── monitoring/         # 监控配置 (Prometheus, Grafana)
│   │   └── messaging/          # 消息队列配置 (RocketMQ)
│   ├── kubernetes/             # K8s部署配置
│   ├── monitoring/             # 监控体系配置
│   ├── agent_database/         # AI智能体数据库脚本
│   ├── wework_platform_database/ # 企微平台数据库脚本
│   └── bussiness_database/     # 业务数据库脚本
│
├── scripts/                    # ⚙️ 运维脚本
│   ├── manage-services.sh      # 🎯 统一服务管理脚本 (417行)
│   ├── start-infrastructure.sh # 基础设施启动脚本
│   ├── stop-infrastructure.sh  # 基础设施停止脚本
│   ├── check-services.sh       # 服务健康检查脚本
│   ├── build-*.sh             # 各服务构建脚本
│   ├── run-*.sh               # 各服务运行脚本
│   ├── migrate_to_postgresql.sh # 数据库迁移脚本
│   └── pgloader_configs/       # 数据库迁移配置
│
├── docs/                       # 📚 项目文档
│   ├── 01-项目概述/
│   ├── 02-系统设计/
│   │   ├── COMPLETE_BUSINESS_MODULE_DESIGN.md ✅
│   │   ├── TECHNICAL_ARCHITECTURE_ANALYSIS.md ✅
│   │   ├── LIFECYCLE_CLOSED_LOOP_DESIGN.md ✅
│   │   └── database-scripts/   # 完整数据库脚本 (6库98表)
│   ├── 03-架构设计/
│   ├── 04-业务模块/
│   ├── 05-安全性能/
│   ├── 06-部署运维/
│   └── 07-参考文档/
│
├── rules/                      # 📋 Cursor项目规则 ✅
│   ├── 00-project-overview.md  # 项目总览
│   ├── 01-architecture-rules.md # 架构规则
│   ├── 02-database-rules.md    # 数据库规则
│   ├── 03-api-rules.md         # API规则
│   ├── 04-code-standards.md    # 代码规范
│   ├── 05-microservice-rules.md # 微服务规则
│   ├── 06-security-rules.md    # 安全规范
│   ├── 07-performance-rules.md # 性能规范
│   ├── 08-infrastructure-rules.md # 基础设施规范
│   ├── 09-devops-rules.md      # 运维规范
│   ├── 10-frontend-rules.md    # 前端规范
│   └── README.md               # 规则使用指南
│
├── nacos-configs/              # 🔧 Nacos配置文件
│   ├── account-service-dev.yml
│   ├── gateway-service-dev.yml
│   └── data-config-dev.yml
│
├── logs/                       # 📝 日志文件
├── venv/                       # 🐍 Python虚拟环境
├── 企微协议-广州孤星/            # 📡 企微API协议文档
└── README.md                   # 项目说明文档
```

## 🔧 关键脚本说明

### 🎯 核心运维脚本
- **`scripts/manage-services.sh`** (417行): 统一服务管理，支持构建/启动/停止/状态检查
- **`scripts/start-infrastructure.sh`**: 一键启动完整基础设施栈 (MySQL/Redis/RocketMQ/监控)
- **`scripts/check-services.sh`**: 全面健康检查，生成JSON格式报告

### 🏗️ 基础设施栈
- **Docker Compose**: 包含12+个基础设施服务 (数据库/缓存/消息队列/监控)
- **监控体系**: Prometheus + Grafana + ELK + Jaeger 完整可观测性
- **数据库**: MySQL 8.0 + Redis 7.0 + InfluxDB + MongoDB 多模存储

## 🔍 规则检查清单

### 💻 代码提交前检查
- [ ] 命名规范：类名、方法名、变量名符合规范
- [ ] 多租户：业务表包含tenant_id字段
- [ ] 参数验证：API参数使用@Valid注解验证
- [ ] 异常处理：使用统一异常类和错误码
- [ ] 权限控制：敏感操作添加@RequirePermission
- [ ] 日志记录：关键操作记录INFO级别日志
- [ ] 单元测试：覆盖率不低于80%

### 🏗️ 架构设计检查
- [ ] 服务边界：按业务域划分，避免跨域调用
- [ ] 数据隔离：服务独立数据库，避免共享数据
- [ ] 缓存策略：热点数据使用多级缓存
- [ ] 监控完整：关键指标和链路追踪
- [ ] 安全防护：认证授权、输入验证、数据加密

### 🎨 前端开发检查
- [ ] 组件设计：使用Vue 3组合式API和TypeScript
- [ ] 状态管理：Pinia stores采用组合式风格
- [ ] 样式规范：BEM命名 + SCSS变量 + 响应式设计
- [ ] API调用：统一请求拦截器和错误处理
- [ ] 类型定义：完整的TypeScript类型覆盖

### ⚙️ 运维部署检查
- [ ] Docker镜像：多阶段构建，安全用户，健康检查
- [ ] 脚本规范：错误处理，日志记录，参数验证
- [ ] 监控配置：Prometheus指标，Grafana仪表板
- [ ] 环境管理：多环境配置，资源限制

## 📈 持续改进

### 🔄 规则更新机制
- 定期review和更新规则文档
- 根据项目演进调整最佳实践
- 收集团队反馈优化开发流程

### 📊 质量度量
- 代码规范遵循度监控
- 性能指标趋势分析
- 安全漏洞扫描报告
- 架构一致性检查

---

💡 **提示**: 这些规则是项目成功的关键保障，请在开发过程中严格遵循。如有疑问，请参考具体规则文档或联系架构团队。