#!/bin/bash

# =================================================================
# WeWork Platform - Gateway服务临时启动脚本（跳过Nacos注册）
# =================================================================

set -e

echo "🚀 启动Gateway服务（跳过Nacos注册）..."

# 项目配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_PATH="$PROJECT_ROOT/backend"

cd "$BACKEND_PATH/gateway-service"

# 检查JAR文件
if [ ! -f "target/gateway-service-1.0.0.jar" ]; then
    echo "❌ JAR文件不存在，请先构建服务"
    echo "   执行: ./scripts/manage-services.sh build gateway"
    exit 1
fi

echo "🎯 启动Gateway服务在18080端口..."
echo "   服务地址: http://localhost:18080"
echo "   健康检查: http://localhost:18080/api/health"
echo ""
echo "📝 使用 Ctrl+C 停止服务"
echo ""

# 启动服务（禁用Nacos注册）
java -Xms512m -Xmx1024m \
    -Dspring.profiles.active=dev \
    -Dspring.cloud.nacos.discovery.enabled=false \
    -Dspring.cloud.nacos.config.enabled=false \
    -Dspring.cloud.service-registry.auto-registration.enabled=false \
    -Dserver.port=18080 \
    -jar target/gateway-service-1.0.0.jar