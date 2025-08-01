#!/bin/bash

# =================================================================
# WeWork Platform - 网关服务构建脚本
# =================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="gateway-service"
SERVICE_PATH="$PROJECT_ROOT/backend/$SERVICE_NAME"
JAR_NAME="gateway-service-1.0.0.jar"

echo -e "${BLUE}🚀 开始构建 $SERVICE_NAME${NC}"
echo "========================================"
echo "项目根目录: $PROJECT_ROOT"
echo "服务路径: $SERVICE_PATH"
echo "构建时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

# 检查服务目录
if [ ! -d "$SERVICE_PATH" ]; then
    echo -e "${RED}❌ 错误: 服务目录不存在 $SERVICE_PATH${NC}"
    exit 1
fi

cd "$PROJECT_ROOT/backend"

# 清理和编译
echo -e "${YELLOW}🧹 清理项目...${NC}"
mvn clean

echo -e "${YELLOW}📦 编译公共模块...${NC}"
mvn compile -pl common -DskipTests

echo -e "${YELLOW}📦 安装公共模块...${NC}"
mvn install -pl common -DskipTests

echo -e "${YELLOW}📦 编译网关服务...${NC}"
mvn compile -pl $SERVICE_NAME -DskipTests

echo -e "${YELLOW}🧪 运行测试...${NC}"
mvn test -pl $SERVICE_NAME

echo -e "${YELLOW}📦 打包服务...${NC}"
mvn package -pl $SERVICE_NAME -DskipTests

# 检查构建结果
JAR_PATH="$SERVICE_PATH/target/$JAR_NAME"
if [ -f "$JAR_PATH" ]; then
    JAR_SIZE=$(ls -lh "$JAR_PATH" | awk '{print $5}')
    echo -e "${GREEN}✅ 构建成功!${NC}"
    echo "========================================"
    echo "JAR文件: $JAR_PATH"
    echo "文件大小: $JAR_SIZE"
    echo "构建完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================"
else
    echo -e "${RED}❌ 构建失败: JAR文件未生成${NC}"
    exit 1
fi

# 显示下一步操作提示
echo -e "${BLUE}🎯 后续操作:${NC}"
echo "1. 运行服务: ./scripts/run-gateway-service.sh"
echo "2. 查看日志: docker logs wework-gateway"
echo "3. 健康检查: curl http://localhost:8080/health/all"
echo "4. API文档: http://localhost:8080/swagger-ui.html"

echo -e "${GREEN}🎉 网关服务构建完成!${NC}"