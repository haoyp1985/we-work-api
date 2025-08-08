# PostgreSQL 数据库配置说明

## 概述

WeWork平台已集成PostgreSQL 15数据库，作为MySQL的补充数据库系统。PostgreSQL提供了更好的JSON支持、更强大的查询功能和更好的并发性能。

## 配置信息

### 连接信息
- **主机**: localhost
- **端口**: 25432
- **用户名**: wework
- **密码**: wework123456
- **默认数据库**: wework_platform

### 容器信息
- **容器名称**: wework-postgresql
- **镜像**: postgres:15-alpine
- **数据卷**: postgresql_data

## 数据库结构

### 主要数据库
1. **wework_platform** - 主数据库
2. **saas_unified_core** - SaaS统一核心数据库
3. **ai_agent_platform** - AI智能体平台数据库
4. **wework_platform_wechat** - 企微平台数据库
5. **health_management** - 健康管理数据库
6. **core_business** - 核心业务数据库
7. **customer_management** - 客户管理数据库
8. **monitor_analytics** - 监控分析数据库
9. **task_management** - 任务管理数据库

### SaaS统一核心数据库表结构

#### 1. 核心身份管理层
- `saas_tenants` - 租户主表
- `saas_users` - 用户主表
- `saas_roles` - 角色管理表
- `saas_permissions` - 权限管理表
- `saas_user_roles` - 用户角色关联表
- `saas_role_permissions` - 角色权限关联表

#### 2. 安全审计层
- `saas_api_keys` - API密钥管理表
- `saas_user_sessions` - 用户会话管理表
- `saas_unified_audit_logs` - 统一审计日志表（分区表）
- `saas_login_attempts` - 登录尝试记录表

#### 3. 配额计费层
- `saas_tenant_quotas` - 租户配额管理表
- `saas_usage_statistics` - 使用统计表
- `saas_real_time_quota_usage` - 实时配额使用表

#### 4. 系统管理层
- `saas_unified_configurations` - 统一配置管理表
- `saas_unified_alerts` - 统一告警管理表
- `saas_monitoring_rules` - 监控规则表
- `saas_system_metrics` - 系统指标表
- `saas_health_checks` - 健康检查表
- `saas_message_templates` - 消息模板表
- `saas_internal_notifications` - 站内通知表
- `saas_message_sending_records` - 消息发送记录表
- `saas_file_storage` - 文件存储表
- `saas_file_sharing` - 文件分享表

## 启动和初始化

### 1. 启动基础设施
```bash
./scripts/start-infrastructure.sh
```

### 2. 初始化PostgreSQL数据
```bash
./scripts/init-postgresql.sh
```

### 3. 测试连接
```bash
./scripts/test-postgresql.sh
```

## 管理命令

### 连接到PostgreSQL
```bash
# 连接到主数据库
docker exec -it wework-postgresql psql -U wework -d wework_platform

# 连接到SaaS统一核心数据库
docker exec -it wework-postgresql psql -U wework -d saas_unified_core
```

### 常用查询
```sql
-- 查看所有数据库
\l

-- 查看当前数据库的所有表
\dt

-- 查看表结构
\d table_name

-- 查看分区表
SELECT schemaname, tablename FROM pg_tables WHERE tablename LIKE 'saas_unified_audit_logs%';
```

### 备份和恢复
```bash
# 备份数据库
docker exec wework-postgresql pg_dump -U wework wework_platform > backup.sql

# 恢复数据库
docker exec -i wework-postgresql psql -U wework wework_platform < backup.sql
```

## 性能优化

### 配置优化
PostgreSQL配置文件位于 `infrastructure/docker/database/conf/postgresql.conf`，包含以下优化：

- **内存设置**: shared_buffers = 256MB, effective_cache_size = 1GB
- **查询优化**: random_page_cost = 1.1, effective_io_concurrency = 200
- **写入性能**: wal_buffers = 16MB, checkpoint_completion_target = 0.9
- **自动清理**: autovacuum = on, autovacuum_max_workers = 3

### 索引策略
- 为所有外键创建索引
- 为常用查询字段创建复合索引
- 为时间字段创建索引以支持分区查询

### 分区策略
- `saas_unified_audit_logs` 表按时间分区
- 每月一个分区，便于数据管理和查询优化

## 监控和维护

### 健康检查
PostgreSQL容器配置了健康检查：
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U wework -d wework_platform"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 30s
```

### 日志配置
- 日志级别: 记录慢查询（>1秒）
- 日志轮转: 每日轮转，最大100MB
- 日志位置: 容器内 /var/lib/postgresql/data/log/

### 扩展支持
PostgreSQL支持以下扩展：
- `uuid-ossp` - UUID生成
- `pgcrypto` - 加密功能
- `pg_stat_statements` - 查询统计

## 安全配置

### 认证方式
- 使用SCRAM-SHA-256密码认证
- 支持SSL连接（开发环境关闭）

### 访问控制
- 限制最大连接数: 200
- 保留超级用户连接: 3
- 支持IP白名单配置

## 故障排除

### 常见问题

1. **连接被拒绝**
   - 检查容器是否运行: `docker ps | grep postgresql`
   - 检查端口映射: `docker port wework-postgresql`

2. **认证失败**
   - 确认用户名密码正确
   - 检查pg_hba.conf配置

3. **性能问题**
   - 检查慢查询日志
   - 分析查询执行计划
   - 优化索引配置

### 日志查看
```bash
# 查看PostgreSQL日志
docker logs wework-postgresql

# 实时查看日志
docker logs -f wework-postgresql
```

## 与MySQL的对比

| 特性 | PostgreSQL | MySQL |
|------|------------|-------|
| JSON支持 | 原生JSONB，性能优秀 | JSON类型，功能有限 |
| 并发性能 | 优秀，支持MVCC | 良好 |
| 查询功能 | 强大，支持复杂查询 | 基础功能 |
| 扩展性 | 丰富的扩展生态 | 相对有限 |
| 事务支持 | ACID完整支持 | ACID支持 |
| 分区表 | 原生支持 | 有限支持 |

## 迁移指南

### 从MySQL迁移到PostgreSQL
1. 使用工具如pgloader进行数据迁移
2. 调整SQL语法差异
3. 优化索引和查询
4. 测试应用兼容性

### 双数据库架构
- MySQL: 主要业务数据
- PostgreSQL: 分析、报表、复杂查询
- 通过数据同步保持一致性
