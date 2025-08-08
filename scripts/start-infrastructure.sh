#!/bin/bash

# 企业微信管理平台基础设施启动脚本

set -e

echo "🚀 启动企业微信管理平台基础设施..."

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker未运行，请先启动Docker"
    exit 1
fi

# 进入Docker配置目录
cd "$(dirname "$0")/../infrastructure/docker"

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p monitoring/grafana/provisioning/{dashboards,datasources}
mkdir -p logs

# 设置项目名称前缀，区分现有容器
PROJECT_NAME="wework-platform"

# 停止已有容器
echo "⏹️  停止现有容器..."
docker compose -p $PROJECT_NAME down --remove-orphans

# 清理网络和卷（可选）
read -p "是否清理现有数据卷？[y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 清理数据卷..."
    docker compose -p $PROJECT_NAME down -v
fi

# 拉取最新镜像
echo "📥 拉取最新镜像..."
docker compose -p $PROJECT_NAME pull

# 启动核心数据库服务
echo "🗄️  启动数据库服务..."
docker compose -p $PROJECT_NAME up -d mysql postgresql redis influxdb

# 等待数据库启动
echo "⏳ 等待数据库启动..."
sleep 30

# 启动消息队列
echo "📨 启动消息队列..."
docker compose -p $PROJECT_NAME up -d rocketmq-nameserver rocketmq-broker rocketmq-console

# 启动对象存储
echo "📁 启动对象存储..."
docker compose -p $PROJECT_NAME up -d minio

# 启动服务注册中心
echo "🏢 启动服务注册中心..."
docker compose -p $PROJECT_NAME up -d nacos

# 启动监控服务
echo "📊 启动监控服务..."
docker compose -p $PROJECT_NAME up -d prometheus grafana

# 启动日志服务
echo "📝 启动日志服务..."
docker compose -p $PROJECT_NAME up -d elasticsearch
sleep 30
docker compose -p $PROJECT_NAME up -d kibana logstash

# 启动链路追踪
echo "🔍 启动链路追踪..."
docker compose -p $PROJECT_NAME up -d jaeger

# 检查所有服务状态
echo "✅ 检查服务状态..."
sleep 10
docker compose -p $PROJECT_NAME ps

echo ""
echo "🎉 基础设施启动完成！"
echo ""
echo "📋 服务访问地址："
echo "   MySQL:        localhost:23306 (用户: wework, 密码: wework123456)"
echo "   PostgreSQL:   localhost:25432 (用户: wework, 密码: wework123456)"
echo "   Redis:        localhost:26379"
echo "   RocketMQ:     http://localhost:29877 (RocketMQ控制台)"
echo "   InfluxDB:     http://localhost:28086 (用户: admin, 密码: wework123456)"
echo "   MinIO API:    http://localhost:29002 (用户: wework, 密码: wework123456)"
echo "   MinIO Console: http://localhost:29001 (用户: wework, 密码: wework123456)"
echo "   Nacos:        http://localhost:28848/nacos (用户: nacos, 密码: nacos)"
echo "   Prometheus:   http://localhost:29090"
echo "   Grafana:      http://localhost:23000 (用户: admin, 密码: wework123456)"
echo "   Kibana:       http://localhost:25601"
echo "   Jaeger:       http://localhost:26686"
echo ""
echo "📦 容器组名称: $PROJECT_NAME (与现有容器区分开)"
echo ""
echo "💡 提示："
echo "   - 首次启动可能需要几分钟时间让所有服务完全就绪"
echo "   - 所有容器名称都带有 '$PROJECT_NAME' 前缀，便于管理"
echo "   - 要停止所有服务，请运行: docker compose -p $PROJECT_NAME down"