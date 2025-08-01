#!/bin/bash

# =================================================================
# WeWork Platform - 更新Nacos端口配置脚本
# =================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Nacos配置
NACOS_SERVER="localhost:28848"
NACOS_USERNAME="nacos"
NACOS_PASSWORD="nacos"
NACOS_GROUP="wework-platform"

echo -e "${BLUE}🔧 更新Nacos端口配置...${NC}"
echo "========================================"

# 获取项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NACOS_CONFIGS_DIR="$PROJECT_ROOT/nacos-configs"

# 检查Nacos是否可用
echo -e "${YELLOW}🔍 检查Nacos连接...${NC}"
if ! curl -s "http://$NACOS_SERVER/nacos/v1/ns/operator/servers" >/dev/null 2>&1; then
    echo -e "${RED}❌ Nacos服务不可用 (http://$NACOS_SERVER)${NC}"
    echo -e "${YELLOW}请确保Nacos容器正在运行${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Nacos连接正常${NC}"

# 配置文件列表
declare -a configs=(
    "gateway-service-dev.yml"
    "account-service-dev.yml"
    "message-service-dev.yml"
)

# 更新每个配置文件
for config_file in "${configs[@]}"; do
    echo -e "${YELLOW}📝 更新配置: $config_file${NC}"
    
    config_path="$NACOS_CONFIGS_DIR/$config_file"
    
    if [ ! -f "$config_path" ]; then
        echo -e "${RED}❌ 配置文件不存在: $config_path${NC}"
        continue
    fi
    
    # 读取配置内容
    config_content=$(cat "$config_path")
    
    # 使用curl发布配置到Nacos
    response=$(curl -s -X POST "http://$NACOS_SERVER/nacos/v1/cs/configs" \
        --data-urlencode "dataId=$config_file" \
        --data-urlencode "group=$NACOS_GROUP" \
        --data-urlencode "content=$config_content" \
        --data-urlencode "username=$NACOS_USERNAME" \
        --data-urlencode "password=$NACOS_PASSWORD")
    
    if [ "$response" = "true" ]; then
        echo -e "${GREEN}✅ $config_file 更新成功${NC}"
    else
        echo -e "${RED}❌ $config_file 更新失败: $response${NC}"
    fi
done

echo ""
echo -e "${BLUE}🎯 端口更新完成！${NC}"
echo "========================================"
echo -e "${CYAN}新端口配置:${NC}"
echo "  Gateway:  18080"
echo "  Account:  18081"
echo "  Message:  18082"
echo ""
echo -e "${CYAN}访问地址:${NC}"
echo "  Gateway:  http://localhost:18080"
echo "  Nacos控制台: http://localhost:28848/nacos"
echo ""
echo -e "${YELLOW}🔄 请重启所有后端服务以应用新端口配置${NC}"