# Monitor Service

监控告警服务，负责系统指标收集、告警规则管理和告警通知。

## 功能特性

### 系统指标监控
- 系统指标数据收集和存储
- 支持多维度指标查询
- 指标数据清理和压缩
- 实时指标监控

### 告警规则管理
- 灵活的告警规则配置
- 支持多种比较操作符
- 规则启用/禁用管理
- 规则复制和测试

### 告警记录管理
- 告警记录查询和统计
- 告警确认和解决
- 告警抑制和批量操作
- 告警历史记录

### 通知系统
- 多渠道通知支持（邮件、短信、Webhook、企微）
- 通知重试机制
- 通知模板配置
- 恢复通知

## 技术架构

### 技术栈
- **框架**: Spring Boot 3.2.0
- **服务发现**: Nacos
- **数据库**: MySQL 8.0 + MyBatis-Plus
- **缓存**: Redis 7.0
- **监控**: Prometheus + Grafana
- **文档**: OpenAPI 3.0

### 核心组件
```
monitor-service/
├── entity/           # 实体类
│   ├── SystemMetric   # 系统指标
│   ├── AlertRule      # 告警规则
│   └── Alert          # 告警记录
├── repository/       # 数据访问层
├── service/          # 业务逻辑层
├── controller/       # 控制器层
├── dto/             # 数据传输对象
└── config/          # 配置类
```

## 接口说明

### 系统指标API
```
POST   /api/v1/monitor/metrics          # 添加指标
POST   /api/v1/monitor/metrics/batch    # 批量添加指标
GET    /api/v1/monitor/metrics          # 分页查询指标
GET    /api/v1/monitor/metrics/{id}     # 获取指标详情
GET    /api/v1/monitor/metrics/latest   # 获取最新指标
DELETE /api/v1/monitor/metrics/{id}     # 删除指标
```

### 告警规则API
```
POST   /api/v1/monitor/alert-rules           # 创建规则
PUT    /api/v1/monitor/alert-rules/{id}      # 更新规则
GET    /api/v1/monitor/alert-rules           # 查询规则
GET    /api/v1/monitor/alert-rules/{id}      # 获取规则详情
POST   /api/v1/monitor/alert-rules/{id}/enable   # 启用规则
POST   /api/v1/monitor/alert-rules/{id}/disable  # 禁用规则
DELETE /api/v1/monitor/alert-rules/{id}      # 删除规则
```

### 告警记录API
```
GET    /api/v1/monitor/alerts           # 查询告警
GET    /api/v1/monitor/alerts/{id}      # 获取告警详情
GET    /api/v1/monitor/alerts/active    # 获取活跃告警
POST   /api/v1/monitor/alerts/{id}/acknowledge  # 确认告警
POST   /api/v1/monitor/alerts/{id}/resolve      # 解决告警
DELETE /api/v1/monitor/alerts/{id}      # 删除告警
```

### 监控管理API
```
GET    /api/v1/monitor/statistics       # 获取统计信息
POST   /api/v1/monitor/evaluate-rules   # 执行规则评估
GET    /api/v1/monitor/health           # 健康检查
POST   /api/v1/monitor/cleanup          # 清理过期数据
```

## 数据模型

### 系统指标 (SystemMetric)
```sql
CREATE TABLE system_metrics (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    metric_name VARCHAR(200) NOT NULL,
    metric_value DECIMAL(20,6) NOT NULL,
    metric_unit VARCHAR(50),
    metric_tags JSON,
    collected_at TIMESTAMP NOT NULL,
    INDEX idx_tenant_service (tenant_id, service_name),
    INDEX idx_metric_time (metric_name, collected_at)
);
```

### 告警规则 (AlertRule)
```sql
CREATE TABLE alert_rules (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    rule_name VARCHAR(100) NOT NULL,
    metric_name VARCHAR(200) NOT NULL,
    comparison_operator VARCHAR(10) NOT NULL,
    threshold_value DECIMAL(20,6) NOT NULL,
    alert_level ENUM('INFO', 'WARNING', 'CRITICAL'),
    status ENUM('ENABLED', 'DISABLED'),
    duration_minutes INT NOT NULL,
    evaluation_interval INT NOT NULL,
    notification_channels JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 告警记录 (Alert)
```sql
CREATE TABLE alerts (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    rule_id VARCHAR(36) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    alert_level ENUM('INFO', 'WARNING', 'CRITICAL'),
    status ENUM('ACTIVE', 'ACKNOWLEDGED', 'RESOLVED', 'SUPPRESSED'),
    trigger_value DECIMAL(20,6),
    acknowledged BOOLEAN DEFAULT FALSE,
    acknowledged_by VARCHAR(100),
    acknowledged_at TIMESTAMP NULL,
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_rule_time (rule_id, created_at)
);
```

## 配置说明

### 应用配置
```yaml
app:
  monitor:
    metric:
      retention-days: 30        # 指标保留天数
      batch-size: 100          # 批量插入大小
      max-query-limit: 1000    # 最大查询记录数
    alert:
      retention-days: 90       # 告警保留天数
      evaluation-interval: 60  # 评估间隔(秒)
      enable-auto-evaluation: true  # 自动评估
    notification:
      enable-email: true       # 邮件通知
      enable-webhook: true     # Webhook通知
      enable-wework: true      # 企微通知
```

### 环境变量
```bash
# 服务配置
PORT=8083
PROFILE=dev

# 数据库配置
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=wework_platform
MYSQL_USERNAME=root
MYSQL_PASSWORD=123456

# Redis配置
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DATABASE=2

# Nacos配置
NACOS_SERVER=localhost:8848
NACOS_NAMESPACE=dev
NACOS_GROUP=DEFAULT_GROUP
```

## 部署指南

### Docker部署
```bash
# 构建镜像
docker build -t wework/monitor-service:2.0.0 .

# 运行容器
docker run -d \
  --name monitor-service \
  -p 8083:8083 \
  -e PROFILE=prod \
  -e MYSQL_HOST=mysql \
  -e REDIS_HOST=redis \
  -e NACOS_SERVER=nacos:8848 \
  wework/monitor-service:2.0.0
```

### Kubernetes部署
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: monitor-service
spec:
  replicas: 2
  selector:
    matchLabels:
      app: monitor-service
  template:
    metadata:
      labels:
        app: monitor-service
    spec:
      containers:
      - name: monitor-service
        image: wework/monitor-service:2.0.0
        ports:
        - containerPort: 8083
        env:
        - name: PROFILE
          value: "prod"
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
```

### 本地开发
```bash
# 启动依赖服务
docker-compose up -d mysql redis nacos

# 启动应用
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

## 监控配置

### Prometheus指标
```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'monitor-service'
    static_configs:
      - targets: ['monitor-service:8083']
    metrics_path: '/monitor/actuator/prometheus'
    scrape_interval: 15s
```

### Grafana仪表板
- 系统指标监控面板
- 告警统计面板
- 服务性能面板
- 系统健康状况面板

## 使用示例

### 添加系统指标
```bash
curl -X POST "http://localhost:8083/monitor/api/v1/monitor/metrics" \
  -H "Content-Type: application/json" \
  -H "X-Tenant-Id: tenant-123" \
  -d '{
    "serviceName": "user-service",
    "metricName": "cpu_usage_percent",
    "metricValue": 75.5,
    "metricUnit": "percent",
    "metricTags": "{\"instance\":\"user-service-1\"}"
  }'
```

### 创建告警规则
```bash
curl -X POST "http://localhost:8083/monitor/api/v1/monitor/alert-rules" \
  -H "Content-Type: application/json" \
  -H "X-Tenant-Id: tenant-123" \
  -d '{
    "ruleName": "CPU使用率告警",
    "description": "当CPU使用率超过80%时触发告警",
    "metricName": "cpu_usage_percent",
    "comparisonOperator": ">",
    "thresholdValue": 80.0,
    "alertLevel": "WARNING",
    "durationMinutes": 5,
    "evaluationInterval": 1,
    "notificationChannels": "[\"email\", \"webhook\"]"
  }'
```

### 查询告警记录
```bash
curl -X GET "http://localhost:8083/monitor/api/v1/monitor/alerts?status=ACTIVE&pageNum=1&pageSize=20" \
  -H "X-Tenant-Id: tenant-123"
```

## 故障排除

### 常见问题
1. **指标数据未显示**: 检查数据库连接和指标收集配置
2. **告警规则不生效**: 确认规则状态为启用，检查评估间隔配置
3. **通知发送失败**: 检查通知渠道配置和网络连接
4. **性能问题**: 检查数据库索引，优化查询条件

### 日志配置
```yaml
logging:
  level:
    com.wework.platform.monitor: debug
    org.springframework.web: info
```

### 健康检查
```bash
# 检查服务状态
curl http://localhost:8083/monitor/actuator/health

# 检查指标
curl http://localhost:8083/monitor/actuator/metrics

# 检查配置
curl http://localhost:8083/monitor/actuator/configprops
```

## 版本信息
- **当前版本**: 2.0.0
- **构建时间**: 2024-01-15
- **最低JDK版本**: 17
- **Spring Boot版本**: 3.2.0