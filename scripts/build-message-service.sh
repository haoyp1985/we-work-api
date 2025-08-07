#!/bin/bash

# 消息发送服务构建脚本

set -e

echo "🚀 开始构建消息发送服务..."

# 进入项目根目录
cd "$(dirname "$0")/../backend-refactor"

# 检查Java和Maven环境
echo "📋 检查构建环境..."

if ! command -v java &> /dev/null; then
    echo "❌ Java未安装或未配置到PATH"
    exit 1
fi

if ! command -v mvn &> /dev/null; then
    echo "❌ Maven未安装或未配置到PATH"
    exit 1
fi

echo "✅ Java版本: $(java -version 2>&1 | head -n 1)"
echo "✅ Maven版本: $(mvn -version | head -n 1)"

# 清理和编译
echo "🧹 清理项目..."
mvn clean

echo "📦 编译公共模块..."
mvn compile -pl common -DskipTests

echo "📦 安装公共模块..."
mvn install -pl common -DskipTests

echo "📦 编译消息服务..."
mvn compile -pl message-service -DskipTests

echo "🧪 运行测试..."
mvn test -pl message-service

echo "📦 打包服务..."
mvn package -pl message-service -DskipTests

# 检查构建结果
if [ -f "message-service/target/message-service.jar" ]; then
    echo "✅ 消息发送服务构建成功！"
    echo "📄 构建产物: message-service/target/message-service.jar"
    
    # 显示jar文件信息
    ls -lh message-service/target/message-service.jar
    
    echo ""
    echo "🎯 下一步操作："
    echo "  1. 启动基础设施: ./scripts/start-infrastructure.sh"
    echo "  2. 运行服务: ./scripts/run-message-service.sh"
    echo "  3. 查看API文档: http://localhost:8082/message/swagger-ui.html"
    echo "  4. 健康检查: http://localhost:8082/message/api/health"
    
else
    echo "❌ 构建失败，未找到目标jar文件"
    exit 1
fi

echo ""
echo "🎉 消息发送服务构建完成！"