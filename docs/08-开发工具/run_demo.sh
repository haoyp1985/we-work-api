#!/bin/bash

echo "🚀 企业微信API Demo 启动器"
echo "=" * 50

# 检查Python环境
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 未安装，请先安装Python3"
    exit 1
fi

# 检查并安装依赖
echo "📦 检查依赖..."
if [ ! -d "venv" ]; then
    echo "🔧 创建虚拟环境..."
    python3 -m venv venv
fi

echo "🔄 激活虚拟环境..."
source venv/bin/activate

echo "📥 安装依赖..."
pip install -r requirements.txt

echo "🎯 启动Demo..."
python demo.py 