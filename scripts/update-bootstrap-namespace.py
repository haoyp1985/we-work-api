#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
更新所有服务的bootstrap.yml文件以使用haoyp命名空间
"""

import os
import re

# 配置
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAMESPACE_ID = "2e42fb0d-3ea7-47b9-8680-c7c615eb95f0"
NACOS_PORT = "28848"

# 服务列表
services = [
    "gateway-service",
    "account-service", 
    "message-service",
    "monitor-service",
    "task-service",
    "user-service",
    "ai-agent-service"
]

# 端口映射
port_mapping = {
    "gateway-service": "18080",
    "account-service": "18081",
    "message-service": "18082",
    "monitor-service": "18083",
    "task-service": "18084",
    "user-service": "18085",
    "ai-agent-service": "18086"
}

def update_bootstrap_file(service_name):
    """更新服务的bootstrap.yml文件"""
    bootstrap_path = os.path.join(PROJECT_ROOT, "backend-refactor", service_name, "src/main/resources/bootstrap.yml")
    
    if not os.path.exists(bootstrap_path):
        print(f"⚠️  {service_name} 没有 bootstrap.yml 文件")
        return False
    
    print(f"📝 更新 {service_name} 的 bootstrap.yml...")
    
    # 读取文件内容
    with open(bootstrap_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 备份原文件
    backup_path = bootstrap_path + '.bak'
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    # 替换Nacos地址
    content = re.sub(r'localhost:8848', f'localhost:{NACOS_PORT}', content)
    
    # 替换命名空间
    content = re.sub(r'\$\{NACOS_NAMESPACE:dev\}', f'${{NACOS_NAMESPACE:{NAMESPACE_ID}}}', content)
    
    # 替换服务端口
    if service_name in port_mapping:
        old_port_pattern = r'port: \$\{PORT:\d+\}'
        new_port = f'port: ${{PORT:{port_mapping[service_name]}}}'
        content = re.sub(old_port_pattern, new_port, content)
    
    # 写回文件
    with open(bootstrap_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ {service_name} 更新完成")
    return True

def main():
    """主函数"""
    print("🚀 开始更新所有服务的bootstrap.yml文件...")
    print("=" * 50)
    
    success_count = 0
    for service in services:
        if update_bootstrap_file(service):
            success_count += 1
    
    print("=" * 50)
    print(f"🎉 更新完成！成功更新 {success_count}/{len(services)} 个服务")
    print("\n📋 更新内容：")
    print(f"  - Nacos地址: localhost:{NACOS_PORT}")
    print(f"  - 命名空间ID: {NAMESPACE_ID}")
    print("  - 服务端口已更新为18080-18086")

if __name__ == "__main__":
    main()