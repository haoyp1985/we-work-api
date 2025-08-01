# WeWork Platform - 企业微信管理平台

一个基于Spring Boot 3.x和Vue 3的现代化企业微信管理平台，提供统一的API网关、消息管理、账号管理和监控功能。

## 🚀 项目架构

### 后端技术栈
- **Spring Boot 3.2.0** - 主框架
- **Spring Cloud Gateway** - API网关
- **Spring Cloud Alibaba** - 微服务框架
- **Nacos** - 服务发现与配置中心
- **MyBatis Plus** - ORM框架
- **MySQL 8.0** - 主数据库
- **Redis** - 缓存数据库
- **RocketMQ** - 消息队列
- **Docker** - 容器化部署

### 前端技术栈
- **Vue 3** - 前端框架
- **Vite** - 构建工具
- **TypeScript** - 类型系统
- **Element Plus** - UI组件库
- **Pinia** - 状态管理
- **Vue Router** - 路由管理
- **ECharts** - 图表库

## 📁 项目结构

```
we-work-api/
├── backend/                    # 后端服务
│   ├── common/                # 公共模块
│   ├── gateway-service/       # 网关服务
│   ├── account-service/       # 账号服务
│   ├── message-service/       # 消息服务
│   └── pom.xml               # Maven父项目配置
├── frontend/                  # 前端项目
│   └── admin-web/            # 管理后台
├── docker/                    # Docker配置
├── nacos-configs/            # Nacos配置文件
├── scripts/                  # 部署和管理脚本
└── docs/                     # 项目文档
```

## 🛠️ 快速开始

### 环境要求
- Java 8+
- Node.js 16+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+
- Docker & Docker Compose

### 1. 启动基础设施
```bash
# 启动Docker服务(Nacos、MySQL、Redis、RocketMQ)
cd docker
docker-compose up -d
```

### 2. 启动后端服务
```bash
# 构建所有服务
cd backend
mvn clean install -Dmaven.test.skip=true

# 启动服务(自动按依赖顺序启动)
cd ..
./scripts/manage-services.sh start all
```

### 3. 启动前端
```bash
cd frontend/admin-web
npm install
npm run dev
```

### 4. 访问应用
- 前端管理后台: http://localhost:3000
- Nacos控制台: http://localhost:8848/nacos (nacos/nacos)
- API网关: http://localhost:18080

## 🔧 服务管理

项目提供了便捷的服务管理脚本：

```bash
# 启动所有服务
./scripts/manage-services.sh start all

# 停止所有服务
./scripts/manage-services.sh stop all

# 重启Gateway服务
./scripts/manage-services.sh restart gateway

# 查看服务状态
./scripts/manage-services.sh status

# 构建特定服务
./scripts/manage-services.sh build account
```

## 📊 功能特性

### ✅ 已完成功能
- [x] 微服务架构设计与实现
- [x] API网关路由与认证
- [x] 用户认证与权限管理
- [x] 响应式仪表盘
- [x] 系统监控与指标展示
- [x] 菜单权限管理
- [x] 前端布局与组件系统

### 🚧 开发中功能
- [ ] 账号管理模块
- [ ] 消息发送与模板管理
- [ ] 提供商集成
- [ ] 详细监控与日志

### 📋 待开发功能
- [ ] 文件上传与管理
- [ ] 数据导入导出
- [ ] 定时任务管理
- [ ] 操作日志与审计

## 🔍 API文档

启动后端服务后，可以通过以下地址查看API文档：

- Gateway服务: http://localhost:18080/swagger-ui.html
- Account服务: http://localhost:18081/swagger-ui.html
- Message服务: http://localhost:18082/swagger-ui.html

## 🐛 问题解决

### 常见问题

1. **服务启动失败**
   ```bash
   # 检查端口占用
   netstat -tulpn | grep :18080
   
   # 查看服务日志
   ./scripts/manage-services.sh logs gateway
   ```

2. **Nacos连接失败**
   ```bash
   # 确保Nacos服务正常运行
   docker ps | grep nacos
   
   # 检查Nacos健康状态
   curl http://localhost:8848/nacos/actuator/health
   ```

3. **前端开发服务器启动失败**
   ```bash
   # 清除缓存重新安装依赖
   cd frontend/admin-web
   rm -rf node_modules package-lock.json
   npm install
   ```

## 📝 开发指南

### 后端开发
1. 添加新的服务模块
2. 配置Nacos服务发现
3. 更新Gateway路由配置
4. 编写API文档

### 前端开发
1. 创建新的页面组件
2. 配置路由和权限
3. 集成API接口
4. 更新菜单配置

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 提交Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

如有问题或建议，请提交Issue或联系项目维护者。

---

⭐ 如果这个项目对你有帮助，请给它一个Star！