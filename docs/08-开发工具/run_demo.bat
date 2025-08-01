@echo off
chcp 65001 >nul

echo 🚀 企业微信API Demo 启动器
echo ==================================================

REM 检查Python环境
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python 未安装，请先安装Python
    pause
    exit /b 1
)

REM 检查并安装依赖
echo 📦 检查依赖...
if not exist "venv" (
    echo 🔧 创建虚拟环境...
    python -m venv venv
)

echo 🔄 激活虚拟环境...
call venv\Scripts\activate.bat

echo 📥 安装依赖...
pip install -r requirements.txt

echo 🎯 启动Demo...
python demo.py

pause 