# WeWork Platform - 管理后台

## 📖 项目简介

WeWork Platform 管理后台是基于 Vue 3 + TypeScript + Element Plus 构建的现代化企业级管理系统，为企业微信API管理平台提供完整的Web管理界面。

## 🚀 核心功能

### 1. 账号管理
- **账号列表**: 企微账号的增删改查
- **状态监控**: 实时显示账号在线状态
- **批量操作**: 支持批量删除、状态变更
- **详情查看**: 完整的账号信息展示

### 2. 消息管理
- **消息发送**: 支持文本、图片、视频等多种类型
- **批量发送**: 群发消息功能
- **发送记录**: 完整的消息发送历史
- **消息模板**: 预设消息模板管理

### 3. 提供商管理
- **提供商配置**: 多个WeWork API提供商配置
- **连接测试**: 提供商连接状态检测
- **使用统计**: 提供商使用情况分析
- **错误监控**: 提供商错误日志查看

### 4. 监控中心
- **实时监控**: 系统性能实时监控
- **服务状态**: 各微服务健康状态
- **日志查询**: 结构化日志查询
- **错误分析**: 错误统计和分析

### 5. 系统管理
- **用户管理**: 系统用户管理
- **角色权限**: 基于RBAC的权限控制
- **菜单管理**: 动态菜单配置
- **系统设置**: 全局系统参数配置

## 🏗️ 技术架构

### 核心技术栈
- **Vue 3.4+**: 渐进式JavaScript框架
- **TypeScript 5.0+**: 类型安全的JavaScript超集
- **Vite 5.0+**: 新一代前端构建工具
- **Element Plus 2.4+**: Vue 3组件库
- **Pinia 2.1+**: Vue 3状态管理库
- **Vue Router 4**: 官方路由管理器
- **Axios**: HTTP客户端
- **SCSS**: CSS预处理器

### 架构特点
- **组合式API**: 全面使用Vue 3 Composition API
- **TypeScript**: 完整的类型定义和检查
- **响应式设计**: 适配桌面端和移动端
- **模块化开发**: 组件化和模块化架构
- **PWA支持**: 渐进式Web应用特性

## 📁 项目结构

```
frontend/admin-web/
├── public/                 # 静态资源
├── src/
│   ├── api/               # API接口定义
│   │   ├── auth.ts        # 认证相关
│   │   ├── account.ts     # 账号管理
│   │   ├── message.ts     # 消息管理
│   │   ├── provider.ts    # 提供商管理
│   │   ├── monitor.ts     # 监控相关
│   │   └── menu.ts        # 菜单相关
│   ├── assets/            # 静态资源
│   ├── components/        # 通用组件
│   ├── layout/            # 布局组件
│   ├── router/            # 路由配置
│   │   ├── index.ts       # 路由实例
│   │   └── routes.ts      # 路由配置
│   ├── stores/            # 状态管理
│   │   ├── index.ts       # Store入口
│   │   └── modules/       # Store模块
│   │       ├── user.ts    # 用户状态
│   │       ├── app.ts     # 应用状态
│   │       └── permission.ts # 权限状态
│   ├── styles/            # 全局样式
│   │   ├── index.scss     # 样式入口
│   │   ├── variables.scss # SCSS变量
│   │   ├── mixins.scss    # SCSS混入
│   │   ├── normalize.scss # 重置样式
│   │   ├── common.scss    # 通用样式
│   │   ├── element-ui.scss # Element Plus定制
│   │   └── transitions.scss # 动画样式
│   ├── types/             # TypeScript类型定义
│   │   └── index.ts       # 类型声明
│   ├── utils/             # 工具函数
│   │   ├── index.ts       # 通用工具
│   │   ├── auth.ts        # 认证工具
│   │   └── request.ts     # HTTP请求
│   ├── views/             # 页面组件
│   ├── App.vue            # 根组件
│   └── main.ts            # 应用入口
├── index.html             # HTML模板
├── package.json           # 项目配置
├── tsconfig.json          # TypeScript配置
├── vite.config.ts         # Vite配置
└── README.md              # 项目文档
```

## 🔧 开发环境

### 环境要求
- **Node.js**: >= 18.0.0
- **npm**: >= 8.0.0
- **Modern Browser**: Chrome 90+, Firefox 88+, Safari 14+

### 环境变量

创建 `.env.development` 文件：

```bash
# 应用标题
VITE_APP_TITLE=WeWork Platform

# API基础URL
VITE_APP_BASE_API=http://localhost:18080/api

# 上传URL
VITE_APP_UPLOAD_URL=http://localhost:18080/api/upload

# WebSocket URL
VITE_APP_SOCKET_URL=ws://localhost:18080/ws

# 环境
VITE_APP_ENV=development
```

## 🚀 快速开始

### 安装依赖

```bash
cd frontend/admin-web
npm install
```

### 开发模式

```bash
npm run dev
```

访问: http://localhost:3000

### 构建生产版本

```bash
npm run build
```

### 预览生产版本

```bash
npm run preview
```

### 代码检查

```bash
npm run lint
```

### 代码格式化

```bash
npm run format
```

### 类型检查

```bash
npm run type-check
```

## 📱 功能模块

### 1. 登录认证
- **用户名密码登录**: 传统登录方式
- **二维码登录**: 扫码快捷登录
- **自动登录**: 记住密码功能
- **登录状态保持**: JWT Token管理

### 2. 首页仪表板
- **数据概览**: 关键指标展示
- **实时监控**: 系统状态监控
- **快捷操作**: 常用功能快速入口
- **消息通知**: 系统消息提醒

### 3. 账号管理
```typescript
// 账号列表页面
/account/list
- 账号列表展示
- 搜索和筛选
- 状态实时更新
- 批量操作

// 账号详情页面
/account/detail/:id
- 基本信息展示
- 登录历史记录
- 设备信息查看
- 操作日志

// 账号表单页面
/account/create
/account/edit/:id
- 账号信息编辑
- 表单验证
- 实时预览
```

### 4. 消息管理
```typescript
// 消息发送页面
/message/send
- 单条消息发送
- 消息类型选择
- 实时预览
- 发送状态反馈

// 批量发送页面
/message/batch-send
- 批量消息发送
- 用户群组选择
- 进度显示
- 结果统计

// 发送记录页面
/message/history
- 发送历史查询
- 状态筛选
- 详情查看
- 重新发送

// 消息模板页面
/message/template
- 模板管理
- 模板编辑
- 变量配置
- 预览功能
```

### 5. 提供商管理
```typescript
// 提供商列表页面
/provider/list
- 提供商列表
- 状态监控
- 连接测试
- 使用统计

// 提供商配置页面
/provider/create
/provider/edit/:id
- 提供商配置
- 连接参数设置
- 测试连接
- 权限配置
```

### 6. 监控中心
```typescript
// 监控面板页面
/monitor/dashboard
- 系统概览
- 性能图表
- 实时数据
- 告警信息

// 服务监控页面
/monitor/service
- 服务状态
- 健康检查
- 性能指标
- 依赖关系

// 日志查询页面
/monitor/logs
- 日志检索
- 级别筛选
- 时间范围
- 关键词搜索

// 错误监控页面
/monitor/errors
- 错误统计
- 错误详情
- 趋势分析
- 解决方案
```

## 🎨 UI/UX设计

### 设计原则
- **一致性**: 统一的设计语言和交互模式
- **简洁性**: 简洁明了的界面设计
- **易用性**: 符合用户习惯的操作流程
- **响应式**: 适配不同设备和屏幕尺寸

### 主题系统
- **亮色主题**: 默认主题，适合日常使用
- **深色主题**: 护眼主题，适合暗光环境
- **自定义主题**: 支持主题色自定义
- **高对比度**: 无障碍访问支持

### 组件设计
- **原子化组件**: 可复用的基础组件
- **业务组件**: 特定业务场景组件
- **布局组件**: 页面布局和导航组件
- **表单组件**: 数据录入和验证组件

## 🔒 安全特性

### 认证授权
- **JWT认证**: 无状态Token认证
- **权限控制**: 基于角色的访问控制
- **路由守卫**: 前端路由权限验证
- **API权限**: 接口级别权限控制

### 数据安全
- **输入验证**: 前端表单验证
- **XSS防护**: 内容转义和过滤
- **CSRF防护**: 跨站请求伪造防护
- **敏感信息**: 敏感数据加密存储

## 📊 性能优化

### 打包优化
- **代码分割**: 按路由分割代码
- **Tree Shaking**: 去除无用代码
- **资源压缩**: CSS/JS/图片压缩
- **缓存策略**: 浏览器缓存优化

### 运行时优化
- **懒加载**: 组件和路由懒加载
- **虚拟滚动**: 大列表性能优化
- **缓存策略**: HTTP缓存和内存缓存
- **防抖节流**: 用户交互优化

## 🌐 国际化

### 语言支持
- **中文简体**: 默认语言
- **英文**: 国际化支持
- **语言切换**: 实时语言切换
- **本地化**: 时间、数字、货币格式

### 实现方式
```typescript
// 多语言配置
const messages = {
  'zh-cn': {
    common: {
      confirm: '确认',
      cancel: '取消'
    }
  },
  'en': {
    common: {
      confirm: 'Confirm',
      cancel: 'Cancel'
    }
  }
}
```

## 🧪 测试策略

### 测试类型
- **单元测试**: 组件和工具函数测试
- **集成测试**: 组件集成和API测试
- **E2E测试**: 端到端用户流程测试
- **性能测试**: 加载速度和运行性能测试

### 测试工具
- **Vitest**: 快速的单元测试框架
- **Vue Test Utils**: Vue组件测试工具
- **Cypress**: E2E测试框架
- **Lighthouse**: 性能测试工具

## 📱 移动端适配

### 响应式设计
- **断点设计**: 5个标准断点
- **弹性布局**: Flexbox和Grid布局
- **相对单位**: rem/em/vh/vw单位
- **媒体查询**: CSS媒体查询适配

### 移动端优化
- **触摸优化**: 触摸友好的交互设计
- **性能优化**: 移动端性能优化
- **离线支持**: PWA离线功能
- **推送通知**: 消息推送功能

## 🔧 开发工具

### 代码质量
- **ESLint**: JavaScript/TypeScript代码检查
- **Prettier**: 代码格式化工具
- **Husky**: Git钩子管理
- **lint-staged**: 提交前代码检查

### 开发辅助
- **Vue DevTools**: Vue开发者工具
- **Vite DevTools**: Vite开发工具
- **TypeScript**: 类型检查和智能提示
- **Auto Import**: 自动导入功能

## 📈 监控和分析

### 错误监控
- **错误收集**: 前端错误自动收集
- **错误上报**: 错误信息上报后端
- **错误分析**: 错误统计和分析
- **告警通知**: 错误告警机制

### 性能监控
- **页面性能**: 页面加载性能监控
- **用户行为**: 用户操作行为分析
- **资源监控**: 静态资源加载监控
- **API监控**: 接口调用性能监控

## 🚀 部署方案

### 静态部署
```bash
# 构建生产版本
npm run build

# 部署到Nginx
cp -r dist/* /var/www/html/

# Nginx配置
server {
    listen 80;
    server_name admin.wework-platform.com;
    root /var/www/html;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:8080;
    }
}
```

### Docker部署
```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### CDN部署
- **静态资源**: 上传到CDN服务
- **缓存配置**: 设置合理的缓存策略
- **域名配置**: 配置CDN域名
- **HTTPS**: 启用HTTPS加密

## 📞 技术支持

- **项目地址**: https://github.com/wework-platform/admin-web
- **问题反馈**: https://github.com/wework-platform/admin-web/issues
- **技术文档**: https://docs.wework-platform.com/frontend
- **联系方式**: frontend-team@wework-platform.com

## 📝 更新日志

### v1.0.0 (2024-01-15)
- ✨ 初始版本发布
- 🎉 完整的管理后台功能
- 🚀 Vue 3 + TypeScript架构
- 📱 响应式设计支持
- 🔒 完整的权限控制系统
- 📊 实时监控面板
- 🌐 国际化支持

---

**WeWork Platform Team** © 2024