# Nacos haoyp命名空间配置指南

## 配置完成情况

✅ **已完成的配置：**

1. **创建了haoyp命名空间**
   - 命名空间ID: `2e42fb0d-3ea7-47b9-8680-c7c615eb95f0`
   - 命名空间名称: `haoyp`

2. **导入了所有服务配置到Nacos**
   - basic-config-dev.yml (基础共享配置)
   - data-config-dev.yml (数据源配置)
   - gateway-service-dev.yml
   - account-service-dev.yml
   - message-service-dev.yml
   - monitor-service-dev.yml
   - task-service-dev.yml
   - user-service-dev.yml

3. **更新了所有服务的bootstrap.yml**
   - Nacos地址: `localhost:28848`
   - 命名空间: `2e42fb0d-3ea7-47b9-8680-c7c615eb95f0`
   - 服务端口已更新为: 18080-18086

## 服务端口分配

| 服务名称 | 端口号 |
|---------|--------|
| gateway-service | 18080 |
| account-service | 18081 |
| message-service | 18082 |
| monitor-service | 18083 |
| task-service | 18084 |
| user-service | 18085 |
| ai-agent-service | 18086 |

## 如何启动服务

### 1. 确保基础设施正在运行
```bash
# 检查Docker容器状态
docker ps | grep -E "mysql|redis|nacos|prometheus|grafana"
```

### 2. 重启已运行的服务以应用新配置
```bash
# 停止所有服务
bash scripts/manage-services.sh stop all

# 启动服务（会使用新的Nacos配置）
bash scripts/manage-services.sh start gateway
bash scripts/manage-services.sh start account
bash scripts/manage-services.sh start message
```

### 3. 手动启动其他服务
```bash
# 监控服务
cd backend-refactor
nohup java -jar monitor-service/target/monitor-service.jar > monitor-service/logs/monitor.log 2>&1 &

# 任务服务
nohup java -jar task-service/target/task-service.jar > task-service/logs/task.log 2>&1 &

# 用户服务
nohup java -jar user-service/target/user-service.jar > user-service/logs/user.log 2>&1 &
```

## 验证配置

### 1. 访问Nacos控制台
- 地址: http://localhost:28848/nacos
- 用户名: nacos
- 密码: nacos
- 切换到`haoyp`命名空间查看配置

### 2. 检查服务注册情况
在Nacos控制台的"服务管理"->"服务列表"中，切换到`haoyp`命名空间，应该能看到已注册的服务。

### 3. 测试服务连接
```bash
# 测试网关服务
curl http://localhost:18080/actuator/health

# 通过网关访问账户服务
curl http://localhost:18080/api/v1/accounts/health

# 通过网关访问消息服务
curl http://localhost:18080/api/v1/messages/health
```

## 配置文件位置

- 导入脚本: `nacos-configs/import-to-haoyp-simple.sh`
- 更新脚本: `scripts/update-bootstrap-namespace.py`
- 各服务配置: `backend-refactor/{service-name}/src/main/resources/bootstrap.yml`

## 注意事项

1. 所有服务现在都使用`haoyp`命名空间，不再使用默认的`dev`命名空间
2. 如需修改配置，请在Nacos控制台的`haoyp`命名空间中进行
3. 服务启动时会自动从Nacos加载配置，无需手动修改application.yml
4. 确保环境变量没有覆盖默认配置（如NACOS_NAMESPACE）

## 故障排查

如果服务无法启动或无法连接Nacos：

1. 检查Nacos是否正常运行: `docker ps | grep nacos`
2. 检查服务日志: `tail -f backend-refactor/{service-name}/logs/*.log`
3. 确认bootstrap.yml中的配置是否正确
4. 检查网络连接: `telnet localhost 28848`