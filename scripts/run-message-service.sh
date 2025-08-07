#!/bin/bash

# 消息发送服务运行脚本

set -e

echo "🚀 启动消息发送服务..."

# 检查基础设施是否启动
echo "📋 检查基础设施状态..."

# 检查Docker容器
if ! docker ps | grep -q "wework-mysql"; then
    echo "❌ MySQL容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-redis"; then
    echo "❌ Redis容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-rocketmq-nameserver"; then
    echo "❌ RocketMQ NameServer容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-rocketmq-broker"; then
    echo "❌ RocketMQ Broker容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

if ! docker ps | grep -q "wework-nacos"; then
    echo "❌ Nacos容器未运行，请先启动基础设施"
    echo "   执行: ./scripts/start-infrastructure.sh"
    exit 1
fi

echo "✅ 基础设施检查通过"

# 等待服务完全启动
echo "⏳ 等待基础设施完全启动..."
sleep 10

# 检查服务连接性
echo "🔗 检查服务连接性..."

# 检查MySQL连接
if ! nc -z localhost 3306; then
    echo "❌ MySQL连接失败 (localhost:3306)"
    exit 1
fi

# 检查Redis连接
if ! nc -z localhost 6379; then
    echo "❌ Redis连接失败 (localhost:6379)"
    exit 1
fi

# 检查RocketMQ NameServer连接
if ! nc -z localhost 9876; then
    echo "❌ RocketMQ NameServer连接失败 (localhost:9876)"
    exit 1
fi

# 检查Nacos连接
if ! nc -z localhost 8848; then
    echo "❌ Nacos连接失败 (localhost:8848)"
    exit 1
fi

echo "✅ 服务连接性检查通过"

# 检查jar文件是否存在
JAR_FILE="backend-refactor/message-service/target/message-service.jar"
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ 找不到jar文件: $JAR_FILE"
    echo "   请先执行构建: ./scripts/build-message-service.sh"
    exit 1
fi

# 设置JVM参数
export JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -Dspring.profiles.active=dev"

# 设置日志目录
mkdir -p logs

echo "🎯 启动消息发送服务..."
echo "📄 Jar文件: $JAR_FILE"
echo "🔧 JVM参数: $JAVA_OPTS"
echo "📝 日志位置: logs/message-service.log"
echo ""

# 启动服务
java $JAVA_OPTS -jar "$JAR_FILE" 2>&1 | tee logs/message-service.log &

# 获取进程ID
SERVICE_PID=$!
echo "🔄 服务进程ID: $SERVICE_PID"

# 等待服务启动
echo "⏳ 等待服务启动..."
for i in {1..30}; do
    if curl -f http://localhost:8082/message/actuator/health >/dev/null 2>&1; then
        echo "✅ 消息发送服务启动成功！"
        break
    fi
    
    if [ $i -eq 30 ]; then
        echo "❌ 服务启动超时"
        kill $SERVICE_PID 2>/dev/null || true
        exit 1
    fi
    
    echo "   等待中... ($i/30)"
    sleep 3
done

echo ""
echo "🎉 消息发送服务已启动！"
echo ""
echo "📋 服务信息："
echo "  - 服务地址: http://localhost:8082/message"
echo "  - API文档: http://localhost:8082/message/swagger-ui.html"
echo "  - 健康检查: http://localhost:8082/message/api/health"
echo "  - Actuator: http://localhost:8082/message/actuator"
echo "  - 进程ID: $SERVICE_PID"
echo ""
echo "🛠 管理命令："
echo "  - 查看日志: tail -f logs/message-service.log"
echo "  - 停止服务: kill $SERVICE_PID"
echo "  - 重启服务: ./scripts/run-message-service.sh"
echo ""
echo "🧪 测试命令："
echo "  curl http://localhost:8082/message/api/health"
echo ""

# 保存进程ID到文件
echo $SERVICE_PID > logs/message-service.pid
echo "💾 进程ID已保存到: logs/message-service.pid"

# 等待用户中断
echo "按 Ctrl+C 停止服务..."
wait $SERVICE_PID