#!/bin/bash

# 企业微信管理平台基础设施停止脚本

set -e

echo "🛑 停止企业微信管理平台基础设施..."

# 设置项目名称前缀，与启动脚本保持一致
PROJECT_NAME="wework-platform"

# 进入Docker配置目录
cd "$(dirname "$0")/../infrastructure/docker"

# 检查是否有运行的容器
echo "🔍 检查运行中的容器..."
RUNNING_CONTAINERS=$(docker compose -p $PROJECT_NAME ps -q)

if [ -z "$RUNNING_CONTAINERS" ]; then
    echo "ℹ️  没有找到运行中的 $PROJECT_NAME 容器"
    exit 0
fi

# 显示即将停止的容器
echo "📋 即将停止以下容器："
docker compose -p $PROJECT_NAME ps

echo ""
read -p "确认停止所有 $PROJECT_NAME 容器？[y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "⏹️  停止所有容器..."
    docker compose -p $PROJECT_NAME down
    
    # 询问是否删除数据卷
    echo ""
    read -p "是否同时删除数据卷（将丢失所有数据）？[y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  删除数据卷..."
        docker compose -p $PROJECT_NAME down -v
        echo "✅ 所有容器和数据卷已删除"
    else
        echo "✅ 容器已停止，数据卷已保留"
    fi
    
    # 清理未使用的网络
    echo "🧹 清理未使用的Docker网络..."
    docker network prune -f
    
    echo ""
    echo "🎉 基础设施已完全停止！"
    echo ""
    echo "💡 提示："
    echo "   - 要重新启动，请运行: ./scripts/start-infrastructure.sh"
    echo "   - 数据已保留在Docker卷中（除非选择了删除）"
else
    echo "❌ 操作已取消"
fi