# WeWork Platform 数据库映射关系

## 概述
本文档描述了WeWork Platform各个微服务与PostgreSQL数据库的映射关系。

## 数据库映射表

| 服务名称 | 服务端口 | 数据库名称 | 配置文件 | 主要功能 |
|---------|---------|-----------|---------|---------|
| user-service | 18081 | saas_unified_core | application-postgresql.yml | 用户管理、权限管理 |
| account-service | 18082 | wework_platform_wechat | application-postgresql.yml | 账户管理、企微集成 |
| message-service | 18083 | wework_platform_wechat | application-postgresql.yml | 消息管理、通知服务 |
| ai-agent-service | 18086 | ai_agent_platform | application-postgresql.yml | AI智能体、对话管理 |
| monitor-service | 18084 | monitor_analytics | application-postgresql.yml | 监控分析、性能指标 |
| task-service | 18085 | task_management | application-postgresql.yml | 任务管理、工作流 |
| health-service | 18087 | health_management | application-postgresql.yml | 健康检查、系统监控 |
| business-service | 18088 | core_business | application-postgresql.yml | 核心业务、工作流 |
| customer-service | 18089 | customer_management | application-postgresql.yml | 客户管理、CRM |

## 数据库表结构

### 1. saas_unified_core (用户统一核心数据库)
- 用户管理表
- 角色权限表
- 租户管理表
- 审计日志表

### 2. wework_platform_wechat (企微平台数据库)
- 企业微信应用配置表
- 企微部门表
- 企微成员表
- 消息模板表
- 客户信息表
- 客户群组表

### 3. ai_agent_platform (AI智能体平台数据库)
- AI智能体管理表
- AI模型配置表
- 对话会话表
- 对话消息表
- 知识库管理表
- 工作流管理表
- 训练管理表

### 4. monitor_analytics (监控分析数据库)
- 监控指标定义表
- 告警规则表
- 告警事件表
- 数据分析任务表
- 趋势分析表
- 异常检测表
- 性能基准表

### 5. task_management (任务管理数据库)
- 任务模板表
- 任务定义表
- 任务实例表
- 任务步骤表
- 任务分配表
- 工作流管理表
- 审批流程表

### 6. health_management (健康管理数据库)
- 健康检查配置表
- 服务监控配置表
- 告警规则表
- 系统日志表
- 应用日志表
- 性能指标表
- 资源监控表

### 7. core_business (核心业务数据库)
- 业务配置表
- 业务规则表
- 工作流定义表
- 业务事件表
- 业务数据表
- 集成配置表
- 报表定义表

### 8. customer_management (客户管理数据库)
- 客户信息表
- 客户联系人表
- 客户关系表
- 客户互动记录表
- 客户服务请求表
- 客户满意度调查表
- 客户分析表

## 启动配置

### 使用PostgreSQL配置启动服务
```bash
# 设置环境变量
export SPRING_PROFILES_ACTIVE=postgresql

# 启动单个服务
cd user-service
mvn spring-boot:run -Dspring-boot.run.profiles=postgresql

# 启动所有服务
./start-postgresql-services.sh
```

### 配置文件说明
每个服务都有对应的 `application-postgresql.yml` 配置文件，包含：
- PostgreSQL数据源配置
- Redis缓存配置
- MyBatis Plus配置
- JPA配置（如需要）

## 数据库连接信息

### PostgreSQL连接参数
- 主机: localhost
- 端口: 25432
- 用户名: wework
- 密码: wework123456
- 连接池: HikariCP

### Redis连接参数
- 主机: localhost
- 端口: 26379
- 数据库: 0-8 (按服务分配)
- 连接池: Lettuce

## 迁移说明

### 从MySQL迁移到PostgreSQL
1. 更新数据源配置
2. 修改SQL语法（如需要）
3. 更新MyBatis Plus配置
4. 测试数据连接和功能

### 注意事项
- PostgreSQL使用UUID作为主键
- 时间戳使用TIMESTAMP类型
- JSON字段使用JSONB类型
- 字符串使用VARCHAR类型

## 监控和维护

### 健康检查
```bash
# 检查服务健康状态
curl http://localhost:18081/actuator/health
curl http://localhost:18082/actuator/health
# ... 其他服务
```

### 日志查看
```bash
# 查看服务日志
tail -f logs/user-service.log
tail -f logs/account-service.log
# ... 其他服务
```

### 数据库连接测试
```bash
# 测试PostgreSQL连接
docker exec wework-postgresql psql -U wework -d saas_unified_core -c "SELECT 1"
```
