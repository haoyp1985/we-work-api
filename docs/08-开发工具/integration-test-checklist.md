# AI智能体管理系统 - 集成测试检查清单

## 🔧 基础设施端口映射（Docker模式）

### 数据存储层
- **MySQL**: `23306:3306` → 本地访问端口: `23306`
- **Redis**: `26379:6379` → 本地访问端口: `26379`  
- **InfluxDB**: `28086:8086` → 本地访问端口: `28086`
- **MinIO**: `29002:9000`, `29001:9001` → API: `29002`, Console: `29001`

### 消息队列
- **RocketMQ NameServer**: `29876:9876` → 本地访问端口: `29876`
- **RocketMQ Broker**: `20909:10909`, `20911:10911`
- **RocketMQ Console**: `29877:8080` → Web界面: `29877`

### 服务治理
- **Nacos**: `28848:8848`, `29848:9848`, `28080:8080` → HTTP: `28848`, Console: `28080`

### 监控系统
- **Prometheus**: `29090:9090` → Web界面: `29090`
- **Grafana**: `23000:3000` → Web界面: `23000` (admin/wework123456)
- **Elasticsearch**: `29200:9200`, `29300:9300`
- **Kibana**: `25601:5601` → Web界面: `25601`
- **Jaeger**: `26686:16686` → Web界面: `26686`

## 🎯 应用服务端口（直接映射）
- **网关服务**: `18080:18080`
- **AI智能体服务**: `18086:18086`（需要添加）
- **前端开发服务器**: `3000`（Vite dev server）

## ✅ 集成测试步骤

### 1. 环境准备检查
- [ ] Docker和Docker Compose已安装
- [ ] Java 17环境已配置
- [ ] Node.js和npm/yarn已安装
- [ ] 项目依赖已安装

### 2. 基础设施启动检查
- [ ] 启动Docker基础设施: `docker-compose up -d`
- [ ] 验证MySQL连接: `mysql -h127.0.0.1 -P23306 -uwework -pwework123456`
- [ ] 验证Redis连接: `redis-cli -p 26379`
- [ ] 验证Nacos访问: `http://localhost:28080/nacos`
- [ ] 验证其他监控工具访问

### 3. 数据库初始化检查
- [ ] 执行数据库初始化脚本
- [ ] 验证ai_agent_platform数据库已创建
- [ ] 验证所有表结构正确
- [ ] 验证初始数据已插入

### 4. 后端服务启动检查
- [ ] 网关服务启动: `http://localhost:18080/actuator/health`
- [ ] AI智能体服务启动: `http://localhost:18086/actuator/health`
- [ ] 服务注册到Nacos成功
- [ ] 网关路由配置正确

### 5. 前端应用启动检查
- [ ] 前端开发服务器启动: `http://localhost:3000`
- [ ] API代理配置正确
- [ ] 能够访问主界面
- [ ] 路由跳转正常

### 6. API接口测试
- [ ] 智能体管理API: `/api/v1/agents/**`
- [ ] 平台配置API: `/api/v1/platforms/**`
- [ ] 模型配置API: `/api/v1/models/**`
- [ ] 对话管理API: `/api/v1/conversations/**`
- [ ] 调用记录API: `/api/v1/calls/**`

### 7. 前端功能测试
- [ ] 智能体列表页面
- [ ] 智能体创建/编辑
- [ ] 平台配置管理
- [ ] 模型配置管理
- [ ] 对话聊天界面
- [ ] 监控看板

### 8. 集成场景测试
- [ ] 创建智能体完整流程
- [ ] 配置平台参数
- [ ] 配置模型参数
- [ ] 发起对话测试
- [ ] 查看调用记录
- [ ] 监控数据展示

## 🐛 常见问题排查

### 连接问题
```bash
# 检查容器状态
docker-compose ps

# 检查网络连通性
telnet localhost 23306  # MySQL
telnet localhost 26379  # Redis
telnet localhost 28848  # Nacos
```

### 日志检查
```bash
# 查看容器日志
docker-compose logs mysql
docker-compose logs redis
docker-compose logs nacos

# 查看Java服务日志
tail -f backend-refactor/ai-agent-service/logs/ai-agent-service.log
```

### 配置验证
```bash
# 验证Nacos配置
curl http://localhost:28848/nacos/v1/cs/configs?tenant=wework-platform&group=DEFAULT_GROUP

# 验证服务注册
curl http://localhost:28848/nacos/v1/ns/instance/list?serviceName=ai-agent-service
```