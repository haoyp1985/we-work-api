#!/bin/bash

# WeWork Platform - PostgreSQL服务启动脚本
# 使用PostgreSQL数据库配置启动各个微服务

echo "🚀 启动WeWork Platform PostgreSQL服务..."

# 设置环境变量
export SPRING_PROFILES_ACTIVE=postgresql
export NACOS_ADDR=localhost:28848
export NACOS_NAMESPACE=2e42fb0d-3ea7-47b9-8680-c7c615eb95f0
export NACOS_GROUP=DEFAULT_GROUP

# 检查PostgreSQL连接
echo "📊 检查PostgreSQL数据库连接..."
docker exec wework-postgresql pg_isready -U wework -d saas_unified_core
if [ $? -ne 0 ]; then
    echo "❌ PostgreSQL数据库连接失败"
    exit 1
fi

echo "✅ PostgreSQL数据库连接正常"

# 启动服务函数
start_service() {
    local service_name=$1
    local service_dir=$2
    local port=$3
    
    echo "🔄 启动 $service_name 服务 (端口: $port)..."
    cd "$service_dir"
    
    # 清理之前的进程
    pkill -f "$service_name" 2>/dev/null
    
    # 启动服务
    nohup mvn spring-boot:run \
        -Dspring-boot.run.profiles=postgresql \
        -Dspring-boot.run.jvmArguments="-Xms512m -Xmx1024m" \
        > "../logs/$service_name.log" 2>&1 &
    
    local pid=$!
    echo "✅ $service_name 服务已启动 (PID: $pid)"
    echo "📝 日志文件: ../logs/$service_name.log"
    
    # 等待服务启动
    sleep 10
    
    # 检查服务状态
    if curl -s "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
        echo "✅ $service_name 服务健康检查通过"
    else
        echo "⚠️  $service_name 服务健康检查失败，请检查日志"
    fi
}

# 创建日志目录
mkdir -p logs

# 启动各个服务
echo "🔄 开始启动各个微服务..."

# 1. 用户服务 (端口: 18081)
start_service "user-service" "user-service" 18081

# 2. 账户服务 (端口: 18082)
start_service "account-service" "account-service" 18082

# 3. 消息服务 (端口: 18083)
start_service "message-service" "message-service" 18083

# 4. AI智能体服务 (端口: 18086)
start_service "ai-agent-service" "ai-agent-service" 18086

# 5. 监控服务 (端口: 18084)
start_service "monitor-service" "monitor-service" 18084

# 6. 任务服务 (端口: 18085)
start_service "task-service" "task-service" 18085

# 7. 健康管理服务 (端口: 18087)
start_service "health-service" "health-service" 18087

# 8. 核心业务服务 (端口: 18088)
start_service "business-service" "business-service" 18088

# 9. 客户管理服务 (端口: 18089)
start_service "customer-service" "customer-service" 18089

echo ""
echo "🎉 所有服务启动完成！"
echo ""
echo "📊 服务状态:"
echo "  - 用户服务: http://localhost:18081"
echo "  - 账户服务: http://localhost:18082"
echo "  - 消息服务: http://localhost:18083"
echo "  - 监控服务: http://localhost:18084"
echo "  - 任务服务: http://localhost:18085"
echo "  - AI智能体服务: http://localhost:18086"
echo "  - 健康管理服务: http://localhost:18087"
echo "  - 核心业务服务: http://localhost:18088"
echo "  - 客户管理服务: http://localhost:18089"
echo ""
echo "📝 日志文件位置: ./logs/"
echo "🛑 停止所有服务: pkill -f 'spring-boot:run'"
echo ""
