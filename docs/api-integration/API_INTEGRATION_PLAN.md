# 前后端接口联调计划

## 🎯 联调目标

实现前后端完整的接口联调，确保：
- 用户认证登录功能正常工作
- 账号管理CRUD操作完整可用
- 监控中心数据实时展示
- 告警管理功能正常响应

## 🔍 当前状态分析

### 前端配置
- **运行端口**: 3000
- **API代理**: `/api` -> `http://localhost:18080`
- **认证方式**: Bearer Token
- **请求拦截器**: 已配置 Authorization header

### 后端配置
- **网关端口**: 8080 ❌ (需要修改为18080)
- **账号服务**: 8081
- **消息服务**: 8082
- **配置中心**: Nacos (28848)

### ⚠️ 发现的问题
1. **端口不匹配**: 前端代理到18080，后端网关运行在8080
2. **服务启动顺序**: 需要先启动Nacos，再启动各个微服务
3. **数据库初始化**: 需要执行SQL脚本创建表结构

## 📋 联调步骤

### Phase 1: 环境准备
- [ ] 修复端口配置不匹配问题
- [ ] 启动基础设施服务(MySQL, Redis, Nacos)
- [ ] 创建数据库和表结构
- [ ] 启动后端微服务

### Phase 2: 认证联调
- [ ] 实现登录接口联调
- [ ] 测试JWT Token验证
- [ ] 验证权限控制功能
- [ ] 测试登出功能

### Phase 3: 核心功能联调
- [ ] 账号管理CRUD接口
- [ ] 监控数据接口
- [ ] 告警管理接口
- [ ] 文件上传接口

### Phase 4: 高级功能联调
- [ ] 实时数据推送(WebSocket)
- [ ] 分页查询优化
- [ ] 批量操作接口
- [ ] 导入导出功能

## 🛠 需要修复的配置

### 1. 网关端口配置
**文件**: `backend/gateway-service/nacos配置`
```yaml
# 修改前
server:
  port: 8080

# 修改后
server:
  port: 18080
```

### 2. 前端API基础地址
**文件**: `frontend/admin-web/src/utils/request.ts`
```typescript
// 当前配置
baseURL: import.meta.env.VITE_APP_BASE_API || '/api'

// Vite代理配置
'/api' -> 'http://localhost:18080'
```

### 3. 跨域配置
**后端网关需要配置**:
```yaml
spring:
  cloud:
    gateway:
      globalcors:
        cors-configurations:
          '[/**]':
            allowedOrigins: "http://localhost:3000"
            allowedMethods: "*"
            allowedHeaders: "*"
            allowCredentials: true
```

## 📊 API接口映射

### 认证相关
| 前端API | 后端路由 | 控制器 | 状态 |
|---------|----------|---------|------|
| `POST /api/auth/login` | `/api/account/auth/login` | AccountController | ✅ 已实现 |
| `POST /api/auth/logout` | `/api/account/auth/logout` | AccountController | ⏳ 待实现 |
| `GET /api/auth/userinfo` | `/api/account/auth/userinfo` | AccountController | ⏳ 待实现 |

### 账号管理
| 前端API | 后端路由 | 控制器 | 状态 |
|---------|----------|---------|------|
| `GET /api/accounts` | `/api/account/accounts` | AccountController | ✅ 已实现 |
| `POST /api/accounts` | `/api/account/accounts` | AccountController | ✅ 已实现 |
| `PUT /api/accounts/{id}` | `/api/account/accounts/{id}` | AccountController | ✅ 已实现 |
| `DELETE /api/accounts/{id}` | `/api/account/accounts/{id}` | AccountController | ✅ 已实现 |

### 监控数据
| 前端API | 后端路由 | 控制器 | 状态 |
|---------|----------|---------|------|
| `GET /api/monitor/statistics` | `/api/account/monitor/statistics` | MonitorController | ⏳ 待实现 |
| `GET /api/monitor/accounts` | `/api/account/monitor/accounts` | MonitorController | ⏳ 待实现 |
| `GET /api/monitor/health` | `/api/account/monitor/health` | MonitorController | ⏳ 待实现 |

### 告警管理
| 前端API | 后端路由 | 控制器 | 状态 |
|---------|----------|---------|------|
| `GET /api/alerts` | `/api/account/alerts` | AlertController | ⏳ 待实现 |
| `POST /api/alerts/handle` | `/api/account/alerts/handle` | AlertController | ⏳ 待实现 |

## 🎮 测试策略

### 1. 单元测试
- 每个API接口的基本功能测试
- 参数验证和错误处理测试
- 权限控制测试

### 2. 集成测试
- 前后端数据流测试
- 认证授权流程测试
- 实时数据更新测试

### 3. 端到端测试
- 用户完整操作流程测试
- 异常情况处理测试
- 性能和并发测试

## 🚀 启动顺序

1. **基础设施**
   ```bash
   # 启动数据库和缓存
   docker-compose up -d mysql redis
   
   # 启动Nacos
   docker-compose up -d nacos
   ```

2. **后端服务**
   ```bash
   # 启动网关服务
   cd backend/gateway-service
   mvn spring-boot:run
   
   # 启动账号服务
   cd backend/account-service  
   mvn spring-boot:run
   ```

3. **前端服务**
   ```bash
   cd frontend/admin-web
   npm run dev
   ```

## 📝 联调记录

| 日期 | 功能模块 | 测试结果 | 问题记录 | 解决方案 |
|------|----------|----------|----------|----------|
| 待填写 | 登录认证 | - | - | - |
| 待填写 | 账号管理 | - | - | - |
| 待填写 | 监控中心 | - | - | - |
| 待填写 | 告警管理 | - | - | - |

## ✅ 验收标准

### 功能验收
- [ ] 用户能正常登录和登出
- [ ] 账号列表能正确显示和分页
- [ ] 可以创建、编辑、删除账号
- [ ] 监控数据能实时更新
- [ ] 告警信息能正确处理

### 性能验收
- [ ] 页面加载时间 < 2秒
- [ ] API响应时间 < 500ms
- [ ] 支持并发用户数 >= 100

### 兼容性验收
- [ ] Chrome浏览器兼容
- [ ] Safari浏览器兼容
- [ ] 移动端响应式布局正常