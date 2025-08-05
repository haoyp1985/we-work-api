# 🚀 WeWork平台部署指南

## 📋 部署概述

本文档描述了WeWork管理平台重构后的完整部署流程，基于Docker Compose和现有基础设施进行微服务部署。

## 🏗️ 架构总览

### 基础设施服务
- **MySQL 8.0**: 主数据库，3个独立schema
- **Redis 7.0**: 缓存和会话存储
- **RocketMQ 4.8**: 消息队列中间件
- **Nacos 2.3**: 服务注册和配置中心
- **InfluxDB 2.7**: 时序数据库
- **MinIO**: 对象存储
- **ELK Stack**: 日志收集和分析
- **Prometheus + Grafana**: 监控和可视化
- **Jaeger**: 分布式链路追踪

### 微服务架构
- **gateway-service** (18080): API网关
- **user-service** (18081): 用户权限管理
- **account-service** (18082): 企微账号管理
- **message-service** (18083): 消息发送服务
- **monitor-service** (18084): 系统监控服务
- **admin-web** (18090): 管理后台前端

## 🛠️ 部署前准备

### 1. 环境要求
```bash
# 操作系统要求
- macOS 11+ / Ubuntu 20.04+ / CentOS 8+
- Docker 20.10+
- Docker Compose 2.0+

# 硬件要求
- CPU: 4核心及以上
- 内存: 8GB及以上
- 磁盘: 50GB可用空间
```

### 2. 检查Docker环境
```bash
# 检查Docker版本
docker --version
docker-compose --version

# 检查Docker运行状态
docker info

# 检查可用资源
docker system df
```

## 📦 部署步骤

### 1. 准备代码和配置
```bash
# 确保在项目根目录
cd /path/to/we-work-api

# 检查重要文件存在
ls -la infrastructure/docker/docker-compose.yml
ls -la backend-refactor/
ls -la frontend-refactor/
```

### 2. 启动基础设施服务
```bash
cd infrastructure/docker

# 启动数据库和中间件 (按依赖顺序)
docker-compose up -d mysql redis

# 等待MySQL启动完成 (约1-2分钟)
docker-compose logs -f mysql

# 启动Nacos (依赖MySQL)
docker-compose up -d nacos

# 启动消息队列
docker-compose up -d rocketmq-nameserver rocketmq-broker rocketmq-console

# 启动时序数据库和对象存储
docker-compose up -d influxdb minio

# 启动监控基础设施
docker-compose up -d prometheus grafana elasticsearch kibana logstash jaeger
```

### 3. 验证基础设施服务
```bash
# 检查所有服务状态
docker-compose ps

# 验证关键服务健康状态
curl -f http://localhost:23306  # MySQL (应该拒绝连接，正常)
curl -f http://localhost:26379  # Redis (应该拒绝连接，正常)
curl -f http://localhost:28848/nacos  # Nacos
curl -f http://localhost:29877  # RocketMQ Console
curl -f http://localhost:29090  # Prometheus
curl -f http://localhost:23000  # Grafana
```

### 4. 构建和启动微服务
```bash
# 构建所有微服务镜像
docker-compose build gateway-service user-service account-service message-service monitor-service

# 启动微服务 (按依赖顺序)
docker-compose up -d user-service
docker-compose up -d account-service message-service
docker-compose up -d monitor-service
docker-compose up -d gateway-service

# 等待服务启动和注册 (约2-3分钟)
docker-compose logs -f gateway-service
```

### 5. 构建和启动前端
```bash
# 构建前端应用
docker-compose build admin-web

# 启动前端服务
docker-compose up -d admin-web
```

### 6. 验证整体部署
```bash
# 检查所有服务运行状态
docker-compose ps

# 验证微服务健康状态
curl -f http://localhost:18080/actuator/health  # Gateway
curl -f http://localhost:18081/actuator/health  # User Service
curl -f http://localhost:18082/actuator/health  # Account Service
curl -f http://localhost:18083/actuator/health  # Message Service
curl -f http://localhost:18084/actuator/health  # Monitor Service

# 验证前端应用
curl -f http://localhost:18090  # Admin Web
```

## 🌐 访问地址

### 应用访问
- **管理后台**: http://localhost:18090
- **API网关**: http://localhost:18080

### 基础设施访问
- **Nacos控制台**: http://localhost:28848/nacos (nacos/nacos)
- **RocketMQ控制台**: http://localhost:29877
- **Grafana监控**: http://localhost:23000 (admin/wework123456)
- **Prometheus**: http://localhost:29090
- **Kibana日志**: http://localhost:25601
- **Jaeger链路追踪**: http://localhost:26686
- **MinIO对象存储**: http://localhost:29001 (wework/wework123456)

## 🔧 常见问题排查

### 1. 数据库连接问题
```bash
# 检查数据库状态
docker-compose logs mysql
docker exec -it wework-mysql mysql -uwework -pwework123456 -e "SHOW DATABASES;"

# 验证数据库Schema创建
docker exec -it wework-mysql mysql -uwework -pwework123456 -e "
USE saas_unified_core; SHOW TABLES;
USE wework_platform; SHOW TABLES;
USE monitor_analytics; SHOW TABLES;"
```

### 2. 服务注册问题
```bash
# 检查Nacos状态
curl -X GET "http://localhost:28848/nacos/v1/ns/instance/list?serviceName=gateway-service"

# 查看服务日志
docker-compose logs gateway-service
docker-compose logs user-service
```

### 3. 内存不足问题
```bash
# 检查系统资源使用
docker stats

# 清理不用的镜像和容器
docker system prune -f
docker volume prune -f
```

### 4. 端口冲突问题
```bash
# 检查端口占用
netstat -tulpn | grep :18080
lsof -i :18080

# 修改docker-compose.yml中的端口映射
```

## 🛑 停止和清理

### 优雅停止服务
```bash
cd infrastructure/docker

# 停止微服务
docker-compose stop admin-web gateway-service user-service account-service message-service monitor-service

# 停止基础设施服务
docker-compose stop

# 完全清理 (谨慎操作)
docker-compose down -v  # 删除容器和数据卷
```

### 数据备份
```bash
# 备份数据库
docker exec wework-mysql mysqldump -uwework -pwework123456 --all-databases > backup-$(date +%Y%m%d).sql

# 备份配置
tar -czf config-backup-$(date +%Y%m%d).tar.gz infrastructure/docker/
```

## 📊 监控和日志

### 系统监控
- **Grafana面板**: 系统资源、服务健康度、业务指标
- **Prometheus指标**: 自定义业务指标收集
- **Jaeger链路**: 分布式调用链路分析

### 日志查看
```bash
# 查看特定服务日志
docker-compose logs -f gateway-service
docker-compose logs -f user-service

# 查看所有微服务日志
docker-compose logs -f gateway-service user-service account-service message-service monitor-service

# ELK日志分析
# 访问 http://localhost:25601 查看聚合日志
```

## 🔄 滚动更新

### 更新微服务
```bash
# 重新构建镜像
docker-compose build gateway-service

# 滚动更新 (零停机)
docker-compose up -d gateway-service

# 验证更新
docker-compose logs -f gateway-service
curl -f http://localhost:18080/actuator/health
```

### 配置热更新
```bash
# 通过Nacos配置中心热更新配置
# 访问 http://localhost:28848/nacos 进行配置修改
```

## 📋 部署检查清单

- [ ] Docker和Docker Compose环境正常
- [ ] 系统资源充足 (CPU 4核+ / 内存 8GB+ / 磁盘 50GB+)
- [ ] 所有必需端口未被占用
- [ ] 基础设施服务全部启动成功
- [ ] 数据库Schema正确初始化
- [ ] 微服务全部注册到Nacos
- [ ] 所有微服务健康检查通过
- [ ] 前端应用可正常访问
- [ ] API网关路由配置正确
- [ ] 监控和日志系统正常工作

## ⚡ 性能优化建议

1. **资源配置优化**: 根据实际负载调整容器资源限制
2. **JVM调优**: 优化微服务的JVM参数
3. **数据库优化**: 监控慢查询，优化索引
4. **缓存策略**: 合理配置Redis缓存过期时间
5. **负载均衡**: 生产环境考虑使用Nginx或HAProxy
6. **水平扩展**: 通过增加服务实例数量提升处理能力

---

## 📞 技术支持

如果在部署过程中遇到问题，请：

1. 检查本文档的常见问题排查部分
2. 查看相关服务的日志输出
3. 验证网络连接和防火墙设置
4. 确认系统资源是否充足

完成部署后，您可以开始使用WeWork管理平台的核心功能，包括企微账号管理、消息发送、系统监控等。