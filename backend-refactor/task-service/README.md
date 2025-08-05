# Task Service - 任务调度服务

## 概述

Task Service是WeWork平台的任务调度服务，提供分布式任务调度、执行、监控和管理功能。支持多租户、高可用、高性能的任务处理能力。

## 核心功能

### 1. 任务定义管理
- **任务模板管理**: 支持创建、更新、删除任务定义模板
- **调度策略配置**: 支持Cron表达式、固定间隔、一次性执行等多种调度策略
- **参数化配置**: 支持任务参数、执行环境、权限控制等配置
- **多租户隔离**: 基于租户ID的完全数据隔离

### 2. 任务实例管理
- **实例生命周期**: 任务实例的创建、调度、执行、完成全生命周期管理
- **状态跟踪**: 实时跟踪任务执行状态（等待、运行中、成功、失败、取消等）
- **执行历史**: 完整的任务执行历史记录和日志管理
- **并发控制**: 支持任务并发度控制，避免资源竞争

### 3. 分布式调度引擎
- **分布式锁机制**: 基于Redis + 数据库的混合分布式锁，确保任务不重复执行
- **负载均衡**: 智能的任务分发和负载均衡算法
- **故障容错**: 节点故障自动检测和任务重新调度
- **资源隔离**: 任务执行资源隔离，避免相互影响

### 4. 监控与告警
- **执行监控**: 实时监控任务执行状态、性能指标
- **性能统计**: 任务执行时间、成功率、失败率等统计分析
- **异常告警**: 任务执行异常、超时、失败等告警机制
- **趋势分析**: 任务执行趋势分析和性能优化建议

## 技术架构

### 架构组件
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Controller    │    │     Service     │    │   Repository    │
│    任务API      │───▶│    业务逻辑     │───▶│    数据访问     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Scheduler     │    │   Executor      │    │    Database     │
│   任务调度器    │◀──▶│   任务执行器    │◀──▶│     MySQL       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────┐
│ Distributed Lock│    │     Monitor     │
│   分布式锁      │    │     监控组件    │
└─────────────────┘    └─────────────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────┐
│      Redis      │    │   Prometheus    │
│    缓存&锁      │    │     监控        │
└─────────────────┘    └─────────────────┘
```

### 核心技术栈
- **框架**: Spring Boot 3.2.0, Spring Cloud 2023.0.0
- **数据库**: MySQL 8.0, MyBatis-Plus 3.5.3
- **缓存**: Redis 7.0, Redisson 3.20.0
- **服务治理**: Nacos 2.2.0
- **监控**: Prometheus, Micrometer
- **文档**: SpringDoc OpenAPI 3

## 数据库设计

### 核心表结构

#### 1. 任务定义表 (task_definitions)
```sql
CREATE TABLE task_definitions (
    id VARCHAR(36) PRIMARY KEY COMMENT '任务定义ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    task_name VARCHAR(100) NOT NULL COMMENT '任务名称',
    task_handler VARCHAR(200) NOT NULL COMMENT '任务处理器',
    cron_expression VARCHAR(100) COMMENT 'Cron表达式',
    schedule_type ENUM('CRON', 'FIXED_RATE', 'FIXED_DELAY', 'ONCE') NOT NULL COMMENT '调度类型',
    task_params TEXT COMMENT '任务参数',
    status ENUM('ENABLED', 'DISABLED') DEFAULT 'ENABLED' COMMENT '状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_status (status),
    INDEX idx_schedule_type (schedule_type)
);
```

#### 2. 任务实例表 (task_instances)
```sql
CREATE TABLE task_instances (
    id VARCHAR(36) PRIMARY KEY COMMENT '实例ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    task_definition_id VARCHAR(36) NOT NULL COMMENT '任务定义ID',
    execution_params TEXT COMMENT '执行参数',
    status ENUM('PENDING', 'RUNNING', 'SUCCESS', 'FAILED', 'CANCELLED') NOT NULL COMMENT '执行状态',
    execution_node VARCHAR(100) COMMENT '执行节点',
    start_time TIMESTAMP NULL COMMENT '开始时间',
    end_time TIMESTAMP NULL COMMENT '结束时间',
    execution_duration BIGINT COMMENT '执行时长(毫秒)',
    retry_count INT DEFAULT 0 COMMENT '重试次数',
    error_message TEXT COMMENT '错误信息',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_task_definition_id (task_definition_id),
    INDEX idx_status (status),
    INDEX idx_execution_node (execution_node)
);
```

#### 3. 任务日志表 (task_logs)
```sql
CREATE TABLE task_logs (
    id VARCHAR(36) PRIMARY KEY COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    task_instance_id VARCHAR(36) NOT NULL COMMENT '任务实例ID',
    log_level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR') NOT NULL COMMENT '日志级别',
    log_message TEXT NOT NULL COMMENT '日志内容',
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '日志时间',
    INDEX idx_tenant_id (tenant_id),
    INDEX idx_task_instance_id (task_instance_id),
    INDEX idx_log_level (log_level),
    INDEX idx_log_time (log_time)
);
```

## API接口

### 1. 任务定义管理
- `POST /api/v1/tasks/definitions` - 创建任务定义
- `GET /api/v1/tasks/definitions` - 查询任务定义列表
- `GET /api/v1/tasks/definitions/{id}` - 获取任务定义详情
- `PUT /api/v1/tasks/definitions/{id}` - 更新任务定义
- `DELETE /api/v1/tasks/definitions/{id}` - 删除任务定义
- `POST /api/v1/tasks/definitions/{id}/enable` - 启用任务
- `POST /api/v1/tasks/definitions/{id}/disable` - 禁用任务

### 2. 任务实例管理
- `GET /api/v1/tasks/instances` - 查询任务实例列表
- `GET /api/v1/tasks/instances/{id}` - 获取任务实例详情
- `POST /api/v1/tasks/instances/{id}/cancel` - 取消任务执行
- `POST /api/v1/tasks/instances/{id}/retry` - 重试任务执行
- `GET /api/v1/tasks/instances/{id}/logs` - 获取任务执行日志

### 3. 任务调度管理
- `GET /api/v1/tasks/scheduler/status` - 获取调度器状态
- `POST /api/v1/tasks/scheduler/start` - 启动调度器
- `POST /api/v1/tasks/scheduler/stop` - 停止调度器
- `POST /api/v1/tasks/scheduler/restart` - 重启调度器
- `GET /api/v1/tasks/scheduler/running` - 获取运行中任务列表

## 配置说明

### 应用配置
```yaml
app:
  task:
    executor:
      core-pool-size: 10          # 核心线程池大小
      max-pool-size: 50           # 最大线程池大小
      queue-capacity: 1000        # 队列容量
    scheduler:
      scan-interval: 10000        # 扫描间隔(毫秒)
      batch-size: 100             # 批处理大小
      concurrent-limit: 20        # 并发限制
    distributed-lock:
      redis:
        key-prefix: "task:lock:"  # Redis锁前缀
        default-expire-time: 300000 # 默认过期时间
```

## 部署说明

### Docker部署
```bash
# 构建镜像
docker build -t task-service:1.0.0 .

# 运行容器
docker run -d \
  --name task-service \
  -p 8084:8084 \
  -e PROFILE=prod \
  -e MYSQL_HOST=mysql \
  -e REDIS_HOST=redis \
  -e NACOS_SERVER_ADDR=nacos:8848 \
  task-service:1.0.0
```

### Kubernetes部署
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: task-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: task-service
  template:
    metadata:
      labels:
        app: task-service
    spec:
      containers:
      - name: task-service
        image: task-service:1.0.0
        ports:
        - containerPort: 8084
        env:
        - name: PROFILE
          value: "prod"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
```

## 监控告警

### 关键指标
- **任务执行成功率**: `task_execution_success_rate`
- **任务平均执行时间**: `task_execution_duration_avg`
- **任务排队数量**: `task_queue_size`
- **调度器健康状态**: `scheduler_health_status`

### 告警规则
- 任务执行成功率 < 95%
- 任务平均执行时间 > 5分钟
- 任务排队数量 > 1000
- 调度器离线超过1分钟

## 开发指南

### 自定义任务处理器
```java
@Component("customTaskHandler")
public class CustomTaskHandler implements TaskHandler {
    
    @Override
    public TaskResult execute(TaskContext context) {
        try {
            // 任务逻辑实现
            TaskLogger.info(context, "开始执行自定义任务");
            
            // 业务处理
            String result = processTask(context.getParams());
            
            TaskLogger.info(context, "任务执行完成");
            return TaskResult.success(result);
            
        } catch (Exception e) {
            TaskLogger.error(context, "任务执行失败", e);
            return TaskResult.failure(e.getMessage());
        }
    }
}
```

### 任务定义示例
```json
{
  "taskName": "数据同步任务",
  "taskHandler": "customTaskHandler",
  "scheduleType": "CRON",
  "cronExpression": "0 0 2 * * ?",
  "taskParams": "{\"source\":\"db1\",\"target\":\"db2\"}",
  "description": "每天凌晨2点执行数据同步",
  "enabled": true
}
```

## 版本历史

- **v1.0.0** - 初始版本，提供基础的任务调度功能
- **v1.1.0** - 新增分布式锁机制，提升集群部署稳定性
- **v1.2.0** - 增强监控告警功能，优化性能表现

## 联系方式

- **开发团队**: WeWork Platform Team
- **邮箱**: platform-dev@wework.com
- **文档**: https://docs.wework.com/task-service