#!/bin/bash

# =================================================================
# WeWork Platform - Nacos 配置部署脚本
# 该脚本用于将配置文件批量导入到Nacos配置中心
# =================================================================

# Nacos服务器配置
NACOS_SERVER="http://localhost:28848"
NACOS_USERNAME="nacos"
NACOS_PASSWORD="nacos"
NAMESPACE_ID=""  # 空字符串表示public命名空间
GROUP="wework-platform"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取Nacos访问令牌
get_nacos_token() {
    print_info "获取Nacos访问令牌..."
    
    local response=$(curl -s -X POST \
        "${NACOS_SERVER}/nacos/v1/auth/login" \
        -d "username=${NACOS_USERNAME}&password=${NACOS_PASSWORD}")
    
    if [[ $? -eq 0 ]] && [[ $response == *"accessToken"* ]]; then
        echo $response | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4
    else
        print_error "获取Nacos令牌失败: $response"
        exit 1
    ficd
}

# 发布配置到Nacos
publish_config() {
    local data_id=$1
    local config_file=$2
    local token=$3
    
    if [[ ! -f "$config_file" ]]; then
        print_error "配置文件不存在: $config_file"
        return 1
    fi
    
    print_info "发布配置: $data_id"
    
    local content=$(cat "$config_file")
    local response=$(curl -s -X POST \
        "${NACOS_SERVER}/nacos/v1/cs/configs" \
        -d "dataId=${data_id}" \
        -d "group=${GROUP}" \
        -d "content=${content}" \
        -d "type=yaml" \
        -d "accessToken=${token}")
    
    if [[ "$response" == "true" ]]; then
        print_success "配置发布成功: $data_id"
        return 0
    else
        print_error "配置发布失败: $data_id, 响应: $response"
        return 1
    fi
}

# 检查Nacos连接
check_nacos_connection() {
    print_info "检查Nacos连接..."
    
    local response=$(curl -s -w "%{http_code}" -o /dev/null "${NACOS_SERVER}/nacos/")
    
    if [[ "$response" == "200" ]]; then
        print_success "Nacos连接正常"
        return 0
    else
        print_error "无法连接到Nacos服务器: $NACOS_SERVER"
        print_error "请确保Nacos服务正在运行"
        exit 1
    fi
}

# 主函数
main() {
    echo "========================================"
    echo "    WeWork Platform Nacos 配置部署"
    echo "========================================"
    
    # 检查依赖
    if ! command -v curl &> /dev/null; then
        print_error "curl 命令未找到，请先安装 curl"
        exit 1
    fi
    
    # 检查Nacos连接
    check_nacos_connection
    
    # 获取访问令牌
    TOKEN=$(get_nacos_token)
    if [[ -z "$TOKEN" ]]; then
        print_error "无法获取Nacos访问令牌"
        exit 1
    fi
    print_success "成功获取Nacos访问令牌"
    
    # 配置文件列表
    declare -a config_files=(
        "shared-config-dev.yml"
        "gateway-service-dev.yml"
        "account-service-dev.yml"
        "message-service-dev.yml"
    )
    
    # 发布配置
    local success_count=0
    local total_count=${#config_files[@]}
    
    for config_file in "${config_files[@]}"; do
        config_path="nacos-configs/$config_file"
        if publish_config "$config_file" "$config_path" "$TOKEN"; then
            ((success_count++))
        fi
        echo ""
    done
    
    # 统计结果
    echo "========================================"
    print_info "配置部署完成"
    print_info "成功: $success_count/$total_count"
    
    if [[ $success_count -eq $total_count ]]; then
        print_success "所有配置已成功发布到Nacos!"
        echo ""
        print_info "请访问Nacos控制台查看配置:"
        print_info "URL: ${NACOS_SERVER}/nacos/"
        print_info "用户名: ${NACOS_USERNAME}"
        print_info "密码: ${NACOS_PASSWORD}"
        print_info "命名空间: public"
        print_info "分组: ${GROUP}"
    else
        print_warning "部分配置发布失败，请检查日志"
        exit 1
    fi
}

# 执行主函数
main "$@"