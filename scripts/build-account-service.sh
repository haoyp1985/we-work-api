#!/bin/bash

# 账号管理服务构建脚本

set -e

echo "🚀 开始构建账号管理服务..."

# 进入账号服务目录
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

echo "📦 编译整个项目..."
mvn compile -DskipTests

# echo "🧪 运行测试..."
# mvn test -pl account-service

echo "📦 打包服务..."
mvn package -DskipTests -pl account-service

# 检查构建结果
if [ -f "account-service/target/account-service.jar" ]; then
    echo "✅ 账号服务构建成功！"
    echo "📄 构建产物: account-service/target/account-service.jar"
    
    # 显示jar文件信息
    ls -lh account-service/target/account-service.jar
    
    echo ""
    echo "🎯 下一步操作："
    echo "   1. 启动基础设施: ./scripts/start-infrastructure.sh"
    echo "   2. 运行服务: cd backend-refactor/account-service && mvn spring-boot:run"
    echo "   3. 构建Docker镜像: cd backend-refactor/account-service && docker build -t wework/account-service:1.0.0 ."
    
else
    echo "❌ 账号服务构建失败！"
    exit 1
fi