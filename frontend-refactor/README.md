# WeWork Platform 前端重构项目

## 🎯 项目概述

企业微信管理平台前端项目，采用Vue 3.4 + TypeScript 5.x + Element Plus 2.4的现代化技术栈，支持多租户SaaS架构。

## 📁 项目结构

```
frontend-refactor/
├── admin-web/                    # 管理后台
│   ├── public/                   # 静态资源
│   ├── src/
│   │   ├── api/                  # API接口层
│   │   │   ├── modules/          # 按业务模块分组
│   │   │   ├── types/            # API类型定义
│   │   │   └── index.ts          # API统一导出
│   │   ├── components/           # 组件库
│   │   │   ├── ui/               # UI基础组件
│   │   │   ├── business/         # 业务组件
│   │   │   └── index.ts          # 组件统一导出
│   │   ├── composables/          # 组合式函数
│   │   ├── constants/            # 常量定义
│   │   ├── directives/           # 自定义指令
│   │   ├── hooks/                # 自定义Hook
│   │   ├── layout/               # 布局组件
│   │   ├── router/               # 路由配置
│   │   ├── stores/               # 状态管理
│   │   ├── styles/               # 样式系统
│   │   ├── types/                # 类型定义
│   │   ├── utils/                # 工具函数
│   │   ├── views/                # 页面组件
│   │   ├── App.vue               # 根组件
│   │   └── main.ts               # 应用入口
│   ├── package.json
│   ├── vite.config.ts
│   └── tsconfig.json
│
├── monitor-dashboard/            # 监控大屏
└── shared/                       # 共享资源
    ├── components/               # 跨项目组件
    ├── types/                    # 共享类型
    └── utils/                    # 共享工具
```

## 🚀 技术栈

- **前端框架**: Vue 3.4.x
- **开发语言**: TypeScript 5.x
- **UI组件库**: Element Plus 2.4.x
- **构建工具**: Vite 5.x
- **状态管理**: Pinia 2.x
- **路由管理**: Vue Router 4.x
- **HTTP客户端**: Axios 1.x
- **样式预处理**: SCSS
- **代码规范**: ESLint + Prettier
- **图表库**: ECharts 5.x
- **工具库**: VueUse

## 🏗️ 架构特性

### 1. 组件化架构
- **原子化设计**: 按照原子设计理论组织组件
- **类型安全**: 完整的TypeScript类型支持
- **按需加载**: 支持组件和路由的懒加载

### 2. 状态管理
- **模块化Store**: 按业务域拆分Store模块
- **响应式**: 完全的响应式状态管理
- **持久化**: 支持状态持久化到LocalStorage

### 3. 样式系统
- **设计令牌**: 统一的设计变量系统
- **主题切换**: 支持明暗主题切换
- **响应式**: 完整的响应式设计

### 4. 开发体验
- **热重载**: 极快的HMR开发体验
- **自动导入**: 组件和API自动导入
- **类型检查**: 实时的TypeScript类型检查

## 📊 核心功能模块

### 1. 用户权限管理
- 多租户用户管理
- 角色权限控制
- 菜单权限动态加载

### 2. 企微账号管理
- 账号状态实时监控
- 批量操作支持
- 生命周期跟踪

### 3. 消息管理
- 消息发送配置
- 模板管理
- 发送统计分析

### 4. 监控大屏
- 实时数据展示
- 多维度数据分析
- 告警管理

## 🔧 开发规范

遵循WeWork Platform前端编码规范和开发规则：
- Vue 3组合式API规范
- TypeScript严格模式
- BEM CSS命名规范
- 统一的API接口设计
- 完善的错误处理机制

## 🚦 开发状态

- [x] 项目架构设计
- [x] 基础配置完成
- [ ] 核心组件开发
- [ ] API接口集成
- [ ] 业务页面开发
- [ ] 测试用例编写

---

**版本**: v2.0.0  
**更新时间**: 2025年1月  
**开发团队**: WeWork Platform Team