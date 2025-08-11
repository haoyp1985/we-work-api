#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
企业微信API最小Demo
实现基本登录流程和消息发送功能
"""

import requests
import json
import time
import uuid
from flask import Flask, request, jsonify
import threading
import logging
import qrcode
import io
import os

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class WeWorkAPIDemo:
    def __init__(self, api_base_url="http://192.168.3.122:23456"):
        """
        初始化企微API Demo
        
        Args:
            api_base_url: API服务器地址，默认localhost:8080
        """
        self.api_base_url = api_base_url.rstrip('/')
        self.guid = None  # 实例ID
        self.notify_url = "http://192.168.14.220:15000/webhook"  # 回调地址
        self.session = requests.Session()
        self.is_logged_in = False
        self.user_info = None
        self.waiting_for_verification = False
        
        # 创建Flask应用处理回调
        self.app = Flask(__name__)
        self.setup_webhook_routes()

        # MinIO 对象存储配置（用于先上传文件再走云存储 c2c cdn 上传）
        self.minio_enabled = True
        self.minio_endpoint = os.getenv("MINIO_ENDPOINT", "http://192.168.14.220:29002")
        self.minio_access_key = os.getenv("MINIO_ACCESS_KEY", "wework")
        self.minio_secret_key = os.getenv("MINIO_SECRET_KEY", "wework123456")
        self.minio_bucket = os.getenv("MINIO_BUCKET", "wework-demo")

    def api_request(self, endpoint, data, method='POST'):
        """
        统一API请求方法
        
        Args:
            endpoint: API端点
            data: 请求数据
            method: HTTP方法，默认POST
        
        Returns:
            dict: API响应
        """
        url = f"{self.api_base_url}{endpoint}"
        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        
        try:
            logger.info(f"请求 {method} {endpoint}: {data}")
            
            if method.upper() == 'GET':
                response = self.session.get(url, headers=headers, timeout=30)
            else:
                response = self.session.post(url, json=data, headers=headers, timeout=30)
            
            response.raise_for_status()
            
            result = response.json()
            logger.info(f"响应: {result}")
            return result
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API请求失败: {e}")
            return {"error_code": -1, "error_message": str(e)}
    
    def is_success_response(self, result):
        """
        判断API响应是否成功
        
        Args:
            result: API响应
            
        Returns:
            bool: 是否成功
        """
        if not result or isinstance(result, str):
            return False
            
        # 标准错误格式检查
        if "error_code" in result:
            return result.get("error_code") == 0
            
        # 检查是否包含错误关键词
        result_str = str(result).lower()
        error_keywords = ["error", "fail", "exception", "invalid"]
        if any(keyword in result_str for keyword in error_keywords):
            return False
            
        # 如果没有明确的错误，认为是成功
        return True

    def get_all_clients(self):
        """
        获取所有实例列表
        
        Returns:
            list: 实例列表
        """
        logger.info("=== 获取所有实例列表 ===")
        
        # 尝试多个可能的API端点和方法
        endpoints_to_try = [
            ("/client/all_clients", "POST")
        ]
        
        for endpoint, method in endpoints_to_try:
            logger.info(f"尝试端点: {method} {endpoint}")
            result = self.api_request(endpoint, {}, method)
            
            if self.is_success_response(result):
                # 处理不同的响应格式
                if "data" in result:
                    clients = result.get("data") or []  # 处理data为None的情况
                elif isinstance(result, list):
                    clients = result
                else:
                    clients = [result] if result else []
                
                # 确保clients是列表类型
                if not isinstance(clients, list):
                    clients = []
                
                if clients:
                    logger.info(f"✅ 找到 {len(clients)} 个实例")
                else:
                    logger.info("📋 实例列表为空")
                return clients
            else:
                # 如果不是405错误，记录但继续尝试下一个端点
                if "405" not in str(result):
                    logger.warning(f"端点 {endpoint} 失败: {result}")
        
        logger.error("❌ 所有端点都尝试失败，无法获取实例列表")
        return []

    def get_client_status(self, guid):
        """
        获取实例状态
        
        Args:
            guid: 实例ID
            
        Returns:
            dict: 状态信息
        """
        data = {"guid": guid}
        result = self.api_request("/client/get_client_status", data)
        
        if self.is_success_response(result):
            # 处理不同的响应格式
            if "data" in result:
                status_data = result.get("data", {})
            else:
                status_data = result
                
            status = status_data.get("status", -1)
            status_map = {
                0: "停止",
                1: "运行", 
                2: "在线"
            }
            
            logger.info(f"实例 {guid[:8]}... 状态: {status_map.get(status, '未知')}")
            return {"status": status, "status_text": status_map.get(status, "未知")}
        else:
            logger.error(f"❌ 获取实例状态失败: {result}")
            return {"status": -1, "status_text": "获取失败"}

    def remove_client(self, guid):
        """
        删除实例
        
        Args:
            guid: 实例ID
            
        Returns:
            bool: 是否成功
        """
        logger.info(f"=== 删除实例 {guid[:8]}... ===")
        
        data = {"guid": guid}
        result = self.api_request("/client/remove_client", data)
        
        if self.is_success_response(result):
            logger.info(f"✅ 实例删除成功: {guid[:8]}...")
            return True
        else:
            logger.error(f"❌ 实例删除失败: {result}")
            return False

    def list_instances_interactive(self):
        """
        交互式查看实例列表
        """
        print("\n" + "=" * 60)
        print("📋 实例管理")
        print("=" * 60)
        
        clients = self.get_all_clients()
        
        if not clients:
            print("📋 当前没有任何实例")
            print("💡 提示: 可以通过'开始登录流程'创建新实例")
            return
            
        print(f"\n📊 共找到 {len(clients)} 个实例:")
        print("-" * 80)
        print(f"{'序号':<4} {'GUID':<40} {'状态':<8} {'操作'}")
        print("-" * 80)
        
        for i, client in enumerate(clients):
            if isinstance(client, dict):
                guid = client.get("guid", "未知")
            else:
                guid = str(client)
                
            # 获取状态
            status_info = self.get_client_status(guid)
            status_text = status_info.get("status_text", "未知")
            
            print(f"{i+1:<4} {guid:<40} {status_text:<8} [删除请输入序号]")
        
        print("-" * 80)
        
        # 提供删除选项
        try:
            choice = input("\n💡 输入实例序号删除，或按回车返回: ").strip()
            if choice and choice.isdigit():
                index = int(choice) - 1
                if 0 <= index < len(clients):
                    client = clients[index]
                    if isinstance(client, dict):
                        guid = client.get("guid")
                    else:
                        guid = str(client)
                        
                    confirm = input(f"⚠️  确认删除实例 {guid[:8]}...? (y/N): ").strip().lower()
                    if confirm == 'y':
                        self.remove_client(guid)
                    else:
                        print("❌ 取消删除")
                else:
                    print("❌ 无效的序号")
        except (ValueError, KeyboardInterrupt):
            print("\n👋 返回主菜单")

    def check_current_status(self):
        """
        检查当前demo对象的状态
        """
        print("\n📊 当前状态检查")
        print("=" * 50)
        print(f"🆔 当前GUID: {self.guid or '❌ None'}")
        print(f"🔐 登录状态: {'✅ 已登录' if self.is_logged_in else '❌ 未登录'}")
        
        if self.guid:
            status_info = self.get_client_status(self.guid)
            status = status_info.get("status", -1)
            status_map = {0: "🔴 停止", 1: "🟡 运行中", 2: "🟢 在线"}
            print(f"📱 实例状态: {status_map.get(status, '❓ 未知')}")
        
        # 检查现有实例
        existing_clients = self.get_all_clients()
        if existing_clients:
            print(f"\n🔍 服务器上的实例:")
            for i, client in enumerate(existing_clients):
                # 处理不同的数据格式
                if isinstance(client, dict):
                    guid = client.get('guid')
                elif isinstance(client, str):
                    guid = client
                else:
                    continue
                    
                if not guid:
                    continue
                    
                status_info = self.get_client_status(guid)
                status = status_info.get("status", -1)
                status_map = {0: "🔴 停止", 1: "🟡 运行中", 2: "🟢 在线"}
                current_mark = " ← 当前" if guid == self.guid else ""
                print(f"  {i+1}. {guid} - {status_map.get(status, '❓ 未知')}{current_mark}")
        else:
            print("\n❌ 服务器上没有找到任何实例")
        
        print("=" * 50)

    def select_instance_interactive(self):
        """
        交互式选择实例功能
        """
        print("\n🎯 选择实例")
        print("=" * 60)
        
        # 获取所有现有实例
        existing_clients = self.get_all_clients()
        
        if existing_clients:
            print("🔍 发现以下实例:")
            print("-" * 85)
            print(f"{'序号':<4} {'GUID':<38} {'状态':<15} {'推荐操作'}")
            print("-" * 85)
            
            online_instances = []
            running_instances = []
            stopped_instances = []
            
            for i, client in enumerate(existing_clients):
                # 处理不同的数据格式：字符串GUID 或 字典格式
                if isinstance(client, dict):
                    guid = client.get('guid')
                elif isinstance(client, str):
                    guid = client  # 直接就是GUID字符串
                else:
                    continue  # 跳过无效格式
                
                if not guid:
                    continue
                    
                status_info = self.get_client_status(guid)
                status = status_info.get("status", -1)
                
                if status == 2:  # 在线
                    status_text = "🟢 在线"
                    recommend = "可直接使用"
                    online_instances.append((i+1, guid, status))
                elif status == 1:  # 运行中
                    status_text = "🟡 运行中"
                    recommend = "需要登录"
                    running_instances.append((i+1, guid, status))
                else:  # 停止
                    status_text = "🔴 停止"
                    recommend = "需要启动"
                    stopped_instances.append((i+1, guid, status))
                
                current_mark = " ← 当前" if guid == self.guid else ""
                print(f"{i+1:<4} {guid:<38} {status_text:<15} {recommend}{current_mark}")
            
            print("-" * 85)
            print("💡 选项说明:")
            print("  🟢 在线实例 - 可以直接使用，无需重新登录")
            print("  🟡 运行中实例 - 需要扫码登录")
            print("  🔴 停止实例 - 需要启动并登录")
            print("-" * 80)
            
            print("\n🎯 请选择操作:")
            print("1. 🔗 使用现有在线实例 (推荐)")
            print("2. 🚀 创建新实例")
            print("3. 🔧 手动选择特定实例")
            print("4. 🗑️  删除停止的实例")
            print("5. 🔙 返回主菜单")
            
            choice = input("\n💡 请选择 (1-5): ").strip()
            
            if choice == "1":
                # 自动选择第一个在线实例
                if online_instances:
                    _, guid, status = online_instances[0]
                    self.guid = guid
                    self.is_logged_in = True
                    print(f"✅ 已选择在线实例: {guid}")
                    print("🎉 可以直接使用会话列表和发送消息功能！")
                    return True
                else:
                    print("❌ 没有找到在线的实例")
                    print("💡 请选择其他选项或创建新实例")
                    return False
                    
            elif choice == "2":
                # 创建新实例
                print("\n🚀 开始创建新实例...")
                if self.run_demo():
                    print("✅ 新实例创建并登录成功！")
                    return True
                else:
                    print("❌ 新实例创建失败")
                    return False
                    
            elif choice == "3":
                # 手动选择特定实例
                try:
                    index = int(input(f"请输入实例序号 (1-{len(existing_clients)}): ")) - 1
                    if 0 <= index < len(existing_clients):
                        client = existing_clients[index]
                        
                        # 处理不同的数据格式
                        if isinstance(client, dict):
                            guid = client.get('guid')
                        elif isinstance(client, str):
                            guid = client
                        else:
                            print("❌ 无效的实例格式")
                            return False
                            
                        if not guid:
                            print("❌ 无效的GUID")
                            return False
                            
                        status_info = self.get_client_status(guid)
                        status = status_info.get("status", -1)
                        self.guid = guid
                        
                        if status == 2:  # 在线
                            self.is_logged_in = True
                            print(f"✅ 已选择在线实例: {guid}")
                            print("🎉 可以直接使用！")
                            return True
                        elif status == 1:  # 运行中
                            print(f"🟡 已选择运行中实例: {guid}")
                            print("�� 该实例需要登录，是否现在登录？")
                            login_choice = input("输入 y 开始登录，其他键跳过: ").strip().lower()
                            if login_choice == 'y':
                                # 只执行登录部分，不重新创建实例
                                if self.set_notify_url() and self.set_bridge() and self.get_login_qrcode() and self.wait_for_login():
                                    print("✅ 登录成功！")
                                    return True
                                else:
                                    print("❌ 登录失败")
                                    return False
                            else:
                                print("⚠️ 已选择实例但未登录，部分功能可能不可用")
                                return True
                        else:  # 停止
                            print(f"🔴 已选择停止的实例: {guid}")
                            print("⚠️ 该实例已停止，需要重新启动和登录")
                            return False
                    else:
                        print("❌ 无效的序号")
                        return False
                except (ValueError, KeyboardInterrupt):
                    print("❌ 输入无效")
                    return False
                    
            elif choice == "4":
                # 删除停止的实例
                if stopped_instances:
                    print(f"\n🗑️  删除停止的实例:")
                    for idx, guid, status in stopped_instances:
                        print(f"  {idx}. {guid}")
                    
                    try:
                        del_choice = input("请输入要删除的实例序号 (多个用逗号分隔): ").strip()
                        if del_choice:
                            indices = [int(x.strip()) - 1 for x in del_choice.split(",")]
                            deleted_count = 0
                            for index in indices:
                                if 0 <= index < len(existing_clients):
                                    client = existing_clients[index]
                                    
                                    # 处理不同的数据格式
                                    if isinstance(client, dict):
                                        guid = client.get('guid')
                                    elif isinstance(client, str):
                                        guid = client
                                    else:
                                        continue
                                        
                                    if guid and self.remove_client(guid):
                                        deleted_count += 1
                            
                            print(f"✅ 成功删除 {deleted_count} 个实例")
                            return False  # 重新显示选择界面
                    except (ValueError, KeyboardInterrupt):
                        print("❌ 输入无效")
                        return False
                else:
                    print("❌ 没有找到停止的实例")
                    return False
                    
            elif choice == "5":
                return False
            else:
                print("❌ 无效选择")
                return False
                
        else:
            print("❌ 没有找到任何现有实例")
            print("💡 建议创建新实例")
            create_choice = input("是否现在创建新实例？(y/N): ").strip().lower()
            if create_choice == 'y':
                if self.run_demo():
                    print("✅ 新实例创建并登录成功！")
                    return True
                else:
                    print("❌ 新实例创建失败")
                    return False
            else:
                return False

    def debug_api_endpoints(self):
        """
        调试API端点功能
        """
        print("\n" + "=" * 60)
        print("🔧 API端点调试工具")
        print("=" * 60)
        
        common_endpoints = [
            ("/client/all_clients", "GET"),
            ("/client/all_clients", "POST"),
            ("/client/get_clients", "POST"),
            ("/clients", "GET"),
            ("/client/list", "GET"),
            ("/instance/list", "GET"),
            ("/api/clients", "GET"),
        ]
        
        print("🔍 正在测试常见端点...")
        print("-" * 60)
        
        for endpoint, method in common_endpoints:
            try:
                print(f"测试: {method} {endpoint}")
                result = self.api_request(endpoint, {}, method)
                
                if self.is_success_response(result):
                    print(f"✅ 成功: {endpoint}")
                    print(f"📝 响应: {str(result)[:100]}...")
                elif "405" in str(result):
                    print(f"❌ 方法不允许: {endpoint}")
                elif "404" in str(result):
                    print(f"❌ 端点不存在: {endpoint}")
                else:
                    print(f"⚠️  其他错误: {endpoint} - {str(result)[:50]}...")
                print("-" * 40)
                
            except Exception as e:
                print(f"❌ 异常: {endpoint} - {str(e)[:50]}...")
                print("-" * 40)
        
        # 手动测试功能
        print("\n💡 手动测试端点:")
        while True:
            try:
                endpoint = input("请输入端点 (如 /client/test) 或 'q' 退出: ").strip()
                if endpoint.lower() == 'q':
                    break
                if not endpoint.startswith('/'):
                    endpoint = '/' + endpoint
                    
                method = input("请输入方法 (GET/POST，默认POST): ").strip().upper()
                if not method:
                    method = 'POST'
                    
                result = self.api_request(endpoint, {}, method)
                print(f"📤 请求: {method} {endpoint}")
                print(f"📥 响应: {result}")
                print("-" * 40)
                
            except KeyboardInterrupt:
                break
                
        print("👋 退出调试模式")

    def display_qr_code(self, qr_content):
        """
        在控制台显示二维码
        
        Args:
            qr_content: 二维码内容（通常是URL）
        """
        try:
            # 创建二维码对象
            qr = qrcode.QRCode(
                version=1,
                error_correction=qrcode.constants.ERROR_CORRECT_L,
                box_size=10,
                border=4,
            )
            qr.add_data(qr_content)
            qr.make(fit=True)
            
            # 生成ASCII艺术二维码
            print("\n" + "=" * 60)
            print("📱 企业微信扫码登录")
            print("=" * 60)
            
            # 方法1: 使用qrcode库的print_ascii功能
            try:
                qr.print_ascii(out=None, tty=True, invert=False)
            except:
                # 如果print_ascii不可用，使用备用方法
                self._display_qr_fallback(qr_content)
                
            print("=" * 60)
            print(f"🔗 二维码链接: {qr_content}")
            print("💡 请使用企业微信扫描上方二维码登录")
            print("=" * 60)
            
        except ImportError:
            # 如果qrcode库不可用，显示链接
            print("\n" + "=" * 60)
            print("📱 企业微信扫码登录")
            print("=" * 60)
            print(f"🔗 二维码链接: {qr_content}")
            print("💡 请复制链接到浏览器或使用企业微信扫码登录")
            print("=" * 60)
        except Exception as e:
            # 其他错误，显示链接
            print(f"\n⚠️  二维码显示失败: {e}")
            print(f"🔗 二维码链接: {qr_content}")

    def _display_qr_fallback(self, qr_content):
        """
        备用二维码显示方法 - 使用Unicode块字符
        """
        try:
            qr = qrcode.QRCode(
                version=1,
                error_correction=qrcode.constants.ERROR_CORRECT_L,
                box_size=1,
                border=2,
            )
            qr.add_data(qr_content)
            qr.make(fit=True)
            
            # 获取二维码矩阵
            matrix = qr.get_matrix()
            
            # 使用Unicode块字符显示
            print()
            for row in matrix:
                line = ""
                for module in row:
                    if module:
                        line += "██"  # 黑色块
                    else:
                        line += "  "  # 白色块
                print(line)
            print()
                
        except Exception as e:
            print(f"🔗 请访问: {qr_content}")

    def create_instance(self, client_type=261):
        """
        步骤1: 创建实例
        
        Args:
            client_type: 客户端类型，262=Mac 4.1.36
        
        Returns:
            bool: 是否成功
        """
        logger.info("=== 步骤1: 创建实例 ===")
        
        data = {
            "client_type": client_type,
            "proxy": "",
            "bridge": "", 
            "auto_start": True
        }
        
        result = self.api_request("/client/create_client", data)
        
        # 处理不同的响应格式
        if result.get("error_code") == 0:
            # 标准格式：{'error_code': 0, 'data': 'guid'}
            self.guid = result.get("data")
            logger.info(f"✅ 实例创建成功，GUID: {self.guid}")
            return True
        elif "guid" in result and result.get("guid"):
            # 直接返回格式：{'guid': 'guid值'}
            self.guid = result.get("guid")
            logger.info(f"✅ 实例创建成功，GUID: {self.guid}")
            return True
        else:
            error_msg = result.get('error_message') or result.get('err_msg', '未知错误')
            logger.error(f"❌ 实例创建失败: {error_msg}")
            logger.error(f"服务器响应: {result}")
            
            # 特殊处理"达到上限"的情况
            if "上限" in str(error_msg):
                logger.warning("💡 提示: 实例数量已达上限，请先删除不需要的实例")
                logger.warning("💡 请使用主菜单的'查看实例列表'功能管理现有实例")
            
            return False

    def set_notify_url(self):
        """
        步骤2: 设置回调地址
        
        Returns:
            bool: 是否成功
        """
        logger.info("=== 步骤2: 设置回调地址 ===")
        
        if not self.guid:
            logger.error("❌ 请先创建实例")
            return False
            
        data = {
            "guid": self.guid,
            "notify_url": self.notify_url
        }
        
        result = self.api_request("/global/set_notify_url", data)
        
        # 处理不同的响应格式
        if result.get("error_code") == 0 or (result and "error" not in str(result).lower()):
            logger.info(f"✅ 回调地址设置成功: {self.notify_url}")
            return True
        else:
            logger.error(f"❌ 回调地址设置失败: {result.get('error_message', result)}")
            return False

    def set_bridge(self, bridge_id=""):
        """
        步骤3: 设置本地代理ID
        
        Args:
            bridge_id: 本地代理ID，空字符串表示不使用代理
        
        Returns:
            bool: 是否成功
        """
        logger.info("=== 步骤3: 设置本地代理ID ===")
        
        if not self.guid:
            logger.error("❌ 请先创建实例")
            return False
            
        data = {
            "guid": self.guid,
            "bridge": bridge_id
        }
        
        result = self.api_request("/client/set_bridge", data)
        
        # 处理不同的响应格式
        if result.get("error_code") == 0 or (result and "error" not in str(result).lower()):
            logger.info(f"✅ 本地代理ID设置成功: {bridge_id or '无代理'}")
            return True
        else:
            logger.error(f"❌ 本地代理ID设置失败: {result.get('error_message', result)}")
            return False

    def get_login_qrcode(self):
        """
        步骤4: 获取登录二维码
        
        Returns:
            dict: 二维码信息
        """
        logger.info("=== 步骤4: 获取登录二维码 ===")
        
        if not self.guid:
            logger.error("❌ 请先创建实例")
            return None
            
        data = {
            "guid": self.guid,
            "verify_login": False
        }
        
        result = self.api_request("/login/get_login_qrcode", data)
        
        # 处理不同的响应格式
        if result.get("error_code") == 0:
            # 标准格式：{'error_code': 0, 'data': {...}}
            qr_data = result.get("data", {})
        elif "qrcode" in result or "key" in result:
            # 直接返回格式：{'qrcode': '...', 'key': '...'}
            qr_data = result
        else:
            logger.error(f"❌ 二维码获取失败: {result.get('error_message', result)}")
            return None
            
        logger.info("✅ 二维码获取成功")
        
        # 获取二维码内容
        qr_content = qr_data.get('qrcode_content') or qr_data.get('qrcode')
        qr_key = qr_data.get('key')
        
        if qr_content:
            # 在控制台显示二维码
            self.display_qr_code(qr_content)
            logger.info(f"🔑 Key: {qr_key}")
        else:
            logger.warning("⚠️  未找到二维码内容")
            logger.info(f"📊 原始数据: {qr_data}")
            
        return qr_data

    def get_session_list(self, begin_seq="0", limit=100):
        """
        获取会话列表
        
        Args:
            begin_seq: 开始序列号，默认"0"
            limit: 限制数量，默认100
            
        Returns:
            list: 会话列表
        """
        logger.info("=== 获取会话列表 ===")
        
        # 检查是否已选择实例
        if not self.guid:
            logger.warning("⚠️ 未选择实例，无法获取会话列表")
            print("💡 请先在主菜单选择 '2. 🎯 选择/创建实例'")
            
            # 快速检查是否有在线实例可用
            existing_clients = self.get_all_clients()
            online_count = 0
            if existing_clients:
                for client in existing_clients:
                    if isinstance(client, dict):
                        guid = client.get('guid')
                    elif isinstance(client, str):
                        guid = client
                    else:
                        continue
                        
                    if not guid:
                        continue
                        
                    status_info = self.get_client_status(guid)
                    status = status_info.get("status", -1)
                    if status == 2:  # 在线状态
                        online_count += 1
            
            if online_count > 0:
                print(f"💡 检测到 {online_count} 个在线实例，建议直接选择使用")
            else:
                print("💡 没有检测到在线实例，建议创建新实例")
            
            return []
            
        data = {
            "guid": self.guid,
            "begin_seq": begin_seq,
            "limit": limit
        }
        
        result = self.api_request("/session/get_session_list", data)
        
        if self.is_success_response(result):
            # 处理不同的响应格式
            if "data" in result:
                data = result.get("data", {})
                # 从data中提取真正的会话列表
                if isinstance(data, dict) and "session_list" in data:
                    sessions = data.get("session_list", [])
                elif isinstance(data, list):
                    sessions = data
                else:
                    sessions = []
            elif isinstance(result, list):
                sessions = result
            else:
                sessions = []
                
            logger.info(f"✅ 获取到 {len(sessions)} 个会话")
            return sessions
        else:
            error_msg = result.get('error_message') or result.get('err_msg', '未知错误')
            logger.error(f"❌ 获取会话列表失败: {error_msg}")
            return []

    def display_session_list(self):
        """
        显示会话列表供用户选择
        
        Returns:
            str: 选择的conversation_id，如果取消则返回None
        """
        print("\n" + "=" * 60)
        print("📋 获取会话列表")
        print("=" * 60)
        
        sessions = self.get_session_list()
        
        if not sessions:
            print("❌ 没有找到任何会话")
            print("💡 请先与联系人聊天，或检查登录状态")
            return None
            
        print(f"\n📊 共找到 {len(sessions)} 个会话:")
        print("-" * 80)
        print(f"{'序号':<4} {'会话ID':<25} {'类型':<8} {'名称':<20} {'最后消息时间'}")
        print("-" * 80)
        
        valid_sessions = []
        for i, session in enumerate(sessions):
            try:
                # 解析会话信息
                if isinstance(session, dict):
                    conversation_id = session.get("conversation_id") or session.get("session_id") or session.get("id")
                    name = session.get("name") or session.get("nick_name") or session.get("title", "未知")
                    session_type = "群聊" if conversation_id and conversation_id.startswith("R:") else "私聊"
                    last_time = session.get("last_msg_time", "未知")
                else:
                    # 如果是字符串，可能直接是conversation_id
                    conversation_id = str(session)
                    name = "未知"
                    session_type = "群聊" if conversation_id.startswith("R:") else "私聊"
                    last_time = "未知"
                    
                    # 调试信息
                    logger.info(f"🔍 解析会话: 原始={session} → ID={conversation_id}")
                
                if conversation_id:
                    valid_sessions.append(conversation_id)
                    print(f"{i+1:<4} {conversation_id:<25} {session_type:<8} {name:<20} {last_time}")
                    logger.info(f"📝 添加会话到列表: {conversation_id}")
                
            except Exception as e:
                logger.warning(f"解析会话信息失败: {e}")
                continue
        
        if not valid_sessions:
            print("❌ 没有找到有效的会话ID")
            return None
            
        print("-" * 80)
        print("💡 会话ID格式说明:")
        print("  - S:788xxxxx 或 S:168xxxxx = 私聊")
        print("  - R:10xxxxxxx = 群聊")
        print("-" * 80)
        
        try:
            choice = input("\n💡 输入序号选择会话 (或按回车返回): ").strip()
            if not choice:
                return None
                
            if choice.isdigit():
                index = int(choice) - 1
                if 0 <= index < len(valid_sessions):
                    selected_id = valid_sessions[index]
                    logger.info(f"👆 用户选择序号: {choice} → 索引: {index} → ID: {selected_id}")
                    print(f"✅ 已选择会话: {selected_id}")
                    return selected_id
                else:
                    print("❌ 无效的序号")
                    return None
            else:
                print("❌ 请输入数字")
                return None
                
        except (ValueError, KeyboardInterrupt):
            print("\n👋 取消选择")
            return None

    def send_text_message(self, conversation_id, content):
        """
        发送文本消息
        
        Args:
            conversation_id: 会话ID (私聊: S:788xxxxx, 群聊: R:10xxxxxxx)
            content: 消息内容
        
        Returns:
            bool: 是否成功
        """
        logger.info("=== 发送文本消息 ===")
        
        # 检查是否已选择实例
        if not self.guid:
            logger.warning("⚠️ 未选择实例，无法发送消息")
            print("💡 请先在主菜单选择 '2. 🎯 选择/创建实例'")
            return False
            
        if not self.is_logged_in:
            # 再次检查登录状态
            if self.guid:
                status_info = self.get_client_status(self.guid)
                status = status_info.get("status", -1)
                if status == 2:  # 在线状态
                    self.is_logged_in = True
                    logger.info("✅ 检测到实例已在线，更新登录状态")
                else:
                    logger.error("❌ 实例未登录")
                    logger.warning("💡 请先完成登录流程")
                    return False
            else:
                logger.error("❌ 请先登录")
                return False
            
        # 调试信息
        logger.info(f"📨 准备发送消息: conversation_id={conversation_id}, content={content}")
        
        data = {
            "guid": self.guid,
            "conversation_id": conversation_id,
            "content": content
        }
        
        result = self.api_request("/msg/send_text", data)
        
        # 处理不同的响应格式
        if result.get("error_code") == 0:
            # 标准格式：{'error_code': 0, 'data': {'msg_data': {...}}}
            msg_data = result.get("data", {}).get("msg_data", {})
        elif "msg_data" in result:
            # 直接返回格式：{'msg_data': {...}}
            msg_data = result.get("msg_data", {})
        elif result and "error" not in str(result).lower():
            # 其他成功格式
            msg_data = result
        else:
            logger.error(f"❌ 消息发送失败: {result.get('error_message', result)}")
            return False
            
        logger.info(f"✅ 消息发送成功")
        logger.info(f"📨 消息ID: {msg_data.get('id', '未知')}")
        logger.info(f"📝 内容: {content}")
        return True

    def send_room_at_message(self, conversation_id, content, at_list=None):
        """
        发送群@消息
        
        Args:
            conversation_id: 群聊ID (必须是 R:10xxxxxxx 格式)
            content: 消息内容，可包含 {$@} 占位符调整@位置
            at_list: @的用户列表，传 [0] 表示@全部人
        
        Returns:
            bool: 是否成功
        """
        logger.info("=== 发送群@消息 ===")
        
        # 检查是否已选择实例
        if not self.guid:
            logger.warning("⚠️ 未选择实例，无法发送群@消息")
            print("💡 请先在主菜单选择 '2. 🎯 选择/创建实例'")
            return False
            
        if not self.is_logged_in:
            # 再次检查登录状态
            if self.guid:
                status_info = self.get_client_status(self.guid)
                status = status_info.get("status", -1)
                if status == 2:  # 在线状态
                    self.is_logged_in = True
                    logger.info("✅ 检测到实例已在线，更新登录状态")
                else:
                    logger.error("❌ 实例未登录")
                    logger.warning("💡 请先完成登录流程")
                    return False
            else:
                logger.error("❌ 请先登录")
                return False
            
        if not conversation_id.startswith("R:"):
            logger.error("❌ @消息只能发送到群聊 (conversation_id 必须以 R: 开头)")
            return False
            
        if at_list is None:
            at_list = []
            
        data = {
            "guid": self.guid,
            "conversation_id": conversation_id,
            "content": content,
            "at_list": at_list
        }
        
        result = self.api_request("/msg/send_room_at", data)
        
        if self.is_success_response(result):
            logger.info(f"✅ 群@消息发送成功")
            if at_list == [0]:
                logger.info(f"📢 @全部人")
            elif at_list:
                logger.info(f"🏷️ @了 {len(at_list)} 个人")
            logger.info(f"📝 内容: {content}")
            return True
        else:
            error_msg = result.get('error_message') or result.get('err_msg', '未知错误')
            logger.error(f"❌ 群@消息发送失败: {error_msg}")
            return False

    def send_voice_message(self, conversation_id, file_id, size=0, voice_time=0, aes_key="", md5=""):
        """
        发送语音消息

        Args:
            conversation_id: 会话ID (私聊: S:xxxx, 群聊: R:xxxx)
            file_id: 语音文件ID（由上传接口返回或平台约定的资源ID）
            size: 文件大小(字节)
            voice_time: 语音时长(秒)
            aes_key: AES密钥（若平台需要）
            md5: 文件MD5（若平台需要）

        Returns:
            bool: 是否成功
        """
        logger.info("=== 发送语音消息 ===")

        # 基础校验
        if not self.guid:
            logger.warning("⚠️ 未选择实例，无法发送语音消息")
            print("💡 请先在主菜单选择 '2. 🎯 选择/创建实例'")
            return False

        if not self.is_logged_in:
            if self.guid:
                status_info = self.get_client_status(self.guid)
                if status_info.get("status") == 2:
                    self.is_logged_in = True
                    logger.info("✅ 检测到实例已在线，更新登录状态")
                else:
                    logger.error("❌ 实例未登录")
                    return False
            else:
                logger.error("❌ 请先登录")
                return False

        if not conversation_id:
            logger.error("❌ conversation_id 不能为空")
            return False
        if not file_id:
            logger.error("❌ file_id 不能为空")
            return False

        payload = {
            "guid": self.guid,
            "conversation_id": conversation_id,
            "file_id": file_id,
            "size": int(size) if size else 0,
            "voice_time": int(voice_time) if voice_time else 0,
            "aes_key": aes_key or "",
            "md5": md5 or ""
        }

        logger.info(f"📤 语音入参: {payload}")
        result = self.api_request("/msg/send_voice", payload)

        if self.is_success_response(result):
            logger.info("✅ 语音消息发送成功")
            return True
        else:
            logger.error(f"❌ 语音消息发送失败: {result}")
            return False

    def _compute_md5(self, file_path):
        """计算文件MD5"""
        import hashlib
        md5_obj = hashlib.md5()
        with open(file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(8192), b''):
                md5_obj.update(chunk)
        return md5_obj.hexdigest()

    def _normalize_c2c_response(self, result, defaults=None):
        """
        归一化 C2C 上传返回，抽取 file_id/size/md5/aes_key。

        支持多种字段命名：
        - file_id: file_id, id, fileId, fid
        - size: size, file_size, content_length, length
        - md5: md5, file_md5, hash
        - aes_key: aes_key, aesKey, aeskey, aes
        """
        defaults = defaults or {}
        if not isinstance(result, dict):
            return None

        data_obj = result.get('data') if isinstance(result.get('data'), dict) else result

        def pick(d: dict, keys, default=None):
            for k in keys:
                if k in d and d.get(k) is not None:
                    return d.get(k)
            return default

        file_id = pick(data_obj, ['file_id', 'id', 'fileId', 'fid'])
        size = pick(data_obj, ['size', 'file_size', 'content_length', 'length'], defaults.get('size', 0))
        md5 = pick(data_obj, ['md5', 'file_md5', 'hash'], defaults.get('md5', ''))
        aes_key = pick(data_obj, ['aes_key', 'aesKey', 'aeskey', 'aes'], defaults.get('aes_key', ''))

        if file_id:
            try:
                size = int(size) if size is not None else 0
            except Exception:
                size = defaults.get('size', 0)
            return {
                'file_id': file_id,
                'size': size,
                'md5': md5 or defaults.get('md5', ''),
                'aes_key': aes_key or defaults.get('aes_key', ''),
            }
        return None

    def upload_c2c_file(self, file_path, conversation_id=""):
        """
        将本地文件通过C2C上传，返回 {file_id, size, md5, aes_key}

        会尝试多个常见端点与传输方式（multipart/json），提高兼容性。
        """
        import os
        from urllib.parse import urlparse

        # 判断是否为URL（云存储文档: /cloud/cdn_c2c_upload 需要传 url）
        parsed = urlparse(file_path or "")
        if parsed.scheme in ("http", "https") and parsed.netloc:
            ext = os.path.splitext(parsed.path)[1].lower().strip('.')
            image_ext = {"jpg","jpeg","png","bmp","webp"}
            video_ext = {"mp4","mov","avi","mkv","flv","wmv"}
            if ext in image_ext:
                file_type = 1
            elif ext in video_ext:
                file_type = 4
            else:
                file_type = 5

            try:
                payload = {
                    "guid": self.guid or "",
                    "file_type": file_type,
                    "url": file_path
                }
                result = self.api_request("/cloud/cdn_c2c_upload", payload, method='POST')
                if self.is_success_response(result):
                    data_obj = result.get('data') if isinstance(result, dict) else None
                    if isinstance(data_obj, dict):
                        return {
                            'file_id': data_obj.get('file_id'),
                            'size': data_obj.get('file_size', 0),
                            'md5': data_obj.get('file_md5', ''),
                            'aes_key': data_obj.get('aes_key', ''),
                        }
            except Exception as e:
                logger.warning(f"/cloud/cdn_c2c_upload 上传失败: {e}")
            # 若URL方式失败，继续走本地兼容流程（下面）

        # 本地文件流程
        if not os.path.isfile(file_path):
            logger.error(f"❌ 文件不存在: {file_path}")
            return None

        size = os.path.getsize(file_path) or 0
        md5_val = self._compute_md5(file_path)

        # 优先尝试：上传到 MinIO 生成URL → /cloud/cdn_c2c_upload(url)
        obj_url = None
        if self.minio_enabled:
            try:
                obj_url = self.upload_to_minio(file_path)
            except Exception as e:
                logger.warning(f"MinIO 上传失败，将回退本地直传流程: {e}")
        if obj_url:
            ext = os.path.splitext(file_path)[1].lower().strip('.')
            image_ext = {"jpg","jpeg","png","bmp","webp"}
            video_ext = {"mp4","mov","avi","mkv","flv","wmv"}
            if ext in image_ext:
                file_type = 1
            elif ext in video_ext:
                file_type = 4
            else:
                file_type = 5
            try:
                payload = {
                    "guid": self.guid or "",
                    "file_type": file_type,
                    "url": obj_url
                }
                result = self.api_request("/cloud/cdn_c2c_upload", payload, method='POST')
                if self.is_success_response(result):
                    data_obj = result.get('data') if isinstance(result, dict) else None
                    if isinstance(data_obj, dict):
                        return {
                            'file_id': data_obj.get('file_id'),
                            'size': data_obj.get('file_size', size),
                            'md5': data_obj.get('file_md5', md5_val),
                            'aes_key': data_obj.get('aes_key', ''),
                        }
            except Exception as e:
                logger.warning(f"/cloud/cdn_c2c_upload 失败，回退本地直传: {e}")

        # 先按“云存储”优先使用 /cloud/c2c_upload（JSON），file_type: 图片=1, 视频=4, 文件&GIF=5
        ext = os.path.splitext(file_path)[1].lower().strip('.')
        image_ext = {"jpg","jpeg","png","bmp","webp"}
        video_ext = {"mp4","mov","avi","mkv","flv","wmv"}
        if ext in image_ext:
            file_type = 1
        elif ext in video_ext:
            file_type = 4
        else:
            file_type = 5

        try:
            payload = {
                "guid": self.guid or "",
                "file_type": file_type,
                "file_path": file_path
            }
            # 云存储优先
            result = self.api_request("/cloud/c2c_upload", payload, method='POST')
            if self.is_success_response(result):
                data_obj = result.get('data') if isinstance(result, dict) else None
                if isinstance(data_obj, dict):
                    return {
                        'file_id': data_obj.get('file_id'),
                        'size': data_obj.get('size', size),
                        'md5': data_obj.get('md5', md5_val),
                        'aes_key': data_obj.get('aes_key', ''),
                    }
        except Exception as e:
            logger.warning(f"/cloud/c2c_upload 上传失败: {e}")

        # 回退到 /cdn/c2c_upload（JSON）
        try:
            payload = {
                "guid": self.guid or "",
                "file_type": file_type,
                "file_path": file_path
            }
            result = self.api_request("/cdn/c2c_upload", payload, method='POST')
            if self.is_success_response(result):
                data_obj = result.get('data') if isinstance(result, dict) else None
                if isinstance(data_obj, dict):
                    return {
                        'file_id': data_obj.get('file_id'),
                        'size': data_obj.get('size', size),
                        'md5': data_obj.get('md5', md5_val),
                        'aes_key': data_obj.get('aes_key', ''),
                    }
        except Exception as e:
            logger.warning(f"/cdn/c2c_upload 上传失败: {e}")

        # 可能的端点（根据经验做回退）
        endpoints_to_try = [
            "/cdn/upload_c2c",
            "/cloud/upload_c2c",
            "/file/upload_c2c",
            "/upload/c2c",
        ]

        # 1) 优先尝试 multipart/form-data
        for ep in endpoints_to_try:
            try:
                url = f"{self.api_base_url}{ep}"
                logger.info(f"尝试C2C上传(multipart): POST {ep}")
                files = {
                    'file': (os.path.basename(file_path), open(file_path, 'rb'))
                }
                data = {
                    'guid': self.guid or '',
                    'conversation_id': conversation_id or ''
                }
                resp = self.session.post(url, data=data, files=files, timeout=120)
                try:
                    result = resp.json()
                except Exception:
                    result = { 'status_code': resp.status_code, 'text': resp.text[:200] }
                logger.info(f"C2C上传响应: {result}")

                if self.is_success_response(result):
                    normalized = self._normalize_c2c_response(result, defaults={'size': size, 'md5': md5_val, 'aes_key': ''})
                    if normalized:
                        return normalized
            except Exception as e:
                logger.warning(f"multipart上传失败: {e}")

        # 2) 退化到 application/json base64 方式
        import base64
        with open(file_path, 'rb') as f:
            b64 = base64.b64encode(f.read()).decode('utf-8')
        for ep in endpoints_to_try:
            try:
                logger.info(f"尝试C2C上传(JSON base64): POST {ep}")
                payload = {
                    'guid': self.guid or '',
                    'conversation_id': conversation_id or '',
                    'file_name': os.path.basename(file_path),
                    'file_size': size,
                    'file_md5': md5_val,
                    'file_content': b64,
                }
                result = self.api_request(ep, payload, method='POST')
                if self.is_success_response(result):
                    normalized = self._normalize_c2c_response(result, defaults={'size': size, 'md5': md5_val, 'aes_key': ''})
                    if normalized:
                        return normalized
            except Exception as e:
                logger.warning(f"JSON base64上传失败: {e}")

        logger.error("❌ C2C上传失败，所有端点均不可用")
        return None

    def upload_to_minio(self, file_path, object_name=None):
        """
        上传本地文件到 MinIO 并返回可访问的对象 URL。
        需要安装 boto3: pip install boto3
        """
        try:
            import boto3
            from botocore.client import Config
            from botocore.exceptions import ClientError
        except Exception as e:
            logger.error("未安装 boto3，无法执行 MinIO 上传。请运行: pip install boto3")
            raise e

        if not object_name:
            object_name = os.path.basename(file_path)

        s3 = boto3.client(
            's3',
            endpoint_url=self.minio_endpoint,
            aws_access_key_id=self.minio_access_key,
            aws_secret_access_key=self.minio_secret_key,
            region_name='us-east-1',
            config=Config(signature_version='s3v4')
        )

        # 确保桶存在
        try:
            s3.head_bucket(Bucket=self.minio_bucket)
        except ClientError:
            try:
                s3.create_bucket(Bucket=self.minio_bucket)
                logger.info(f"✅ 已创建 MinIO 桶: {self.minio_bucket}")
            except Exception as e:
                logger.error(f"❌ 创建 MinIO 桶失败: {e}")
                raise e

        # 上传文件
        try:
            s3.upload_file(file_path, self.minio_bucket, object_name)
            logger.info(f"✅ 已上传到 MinIO: {self.minio_bucket}/{object_name}")
        except Exception as e:
            logger.error(f"❌ 上传至 MinIO 失败: {e}")
            raise e

        # 返回可直接访问的 URL（Path-Style）
        url = f"{self.minio_endpoint.rstrip('/')}/{self.minio_bucket}/{object_name}"
        return url
    def setup_webhook_routes(self):
        """
        设置回调路由
        """
        @self.app.route('/webhook', methods=['POST'])
        def handle_webhook():
            try:
                logger.info("🌐 收到webhook请求")
                logger.info(f"📋 请求头: {dict(request.headers)}")
                logger.info(f"📡 请求来源: {request.remote_addr}")
                
                data = request.get_json()
                if data is None:
                    logger.error("❌ 未收到JSON数据")
                    return jsonify({"status": "error", "message": "No JSON data"}), 400
                
                logger.info("✅ 开始处理回调数据")
                self.process_callback(data)
                return jsonify({"status": "ok"})
                
            except Exception as e:
                logger.error(f"❌ 回调处理错误: {e}")
                logger.error(f"📊 错误详情: {str(e)}")
                return jsonify({"status": "error", "message": str(e)}), 500

        @self.app.route('/webhook', methods=['GET'])
        def webhook_test():
            """回调服务器测试端点"""
            return jsonify({
                "status": "ok",
                "message": "回调服务器运行正常",
                "guid": self.guid,
                "timestamp": time.time()
            })

        @self.app.route('/health', methods=['GET'])
        def health_check():
            """健康检查端点"""
            return jsonify({
                "status": "healthy",
                "guid": self.guid,
                "logged_in": self.is_logged_in,
                "waiting_verification": self.waiting_for_verification
            })

    def process_callback(self, data):
        """
        处理回调事件
        
        Args:
            data: 回调数据
        """
        # 先记录所有收到的回调数据用于调试
        logger.info("🔍 收到回调数据:")
        logger.info(f"📊 完整数据: {json.dumps(data, indent=2, ensure_ascii=False)}")
        
        notify_type = data.get("notify_type") or data.get("msg_type")
        guid = data.get("guid")
        
        # 检查是否为我们的实例回调，但更宽松
        if guid and self.guid and guid != self.guid:
            logger.warning(f"⚠️  收到其他实例的回调: {guid} != {self.guid}")
            # 不直接返回，继续处理一些通用回调
            
        logger.info(f"📞 处理回调: notify_type={notify_type}")
        
        # 11002: 二维码变化
        if notify_type == 11002:
            logger.info("🔔 处理二维码状态变化回调")
            self.handle_qrcode_change(data.get("data", {}))
            
        # 11003: 登录成功  
        elif notify_type == 11003:
            logger.info("🔔 处理登录成功回调")
            self.handle_login_success(data.get("data", {}))
            
        # 11004: 退出登录
        elif notify_type == 11004:
            logger.info("🔔 处理退出登录回调")
            self.handle_logout(data.get("data", {}))
            
        # 11010: 新消息
        elif notify_type == 11010:
            logger.info("🔔 处理新消息回调")
            self.handle_new_message(data.get("data", {}))
            
        # 11013: 消息同步回调（新发现）
        elif notify_type == 11013:
            logger.info("🔔 处理消息同步回调")
            self.handle_message_sync(data.get("data", []))
            
        else:
            logger.warning(f"⚠️  未知回调类型: {notify_type}")
            logger.info(f"📊 原始数据: {data}")

    def handle_qrcode_change(self, data):
        """
        处理二维码状态变化
        """
        status = data.get("status")
        status_map = {
            0: "未扫码",
            1: "已扫码，等待确认", 
            2: "登录成功",
            3: "登录失败",
            4: "登录被拒绝",
            5: "微信扫码中",
            6: "微信登录成功",
            7: "微信登录失败", 
            8: "微信登录被拒绝",
            9: "微信授权成功",
            10: "需要验证码"
        }
        logger.info(f"📱 二维码状态: {status_map.get(status, f'未知状态({status})')}")
        
        # 检查是否有新的二维码内容（二维码刷新时）
        qr_content = data.get('qrcode_content') or data.get('qrcode')
        if qr_content and status == 0:  # 未扫码状态且有新的二维码内容
            logger.info("🔄 二维码已刷新，重新显示:")
            self.display_qr_code(qr_content)
            
        # 特殊状态提示
        if status == 1:
            print("\n✅ 已扫码！请在手机上确认登录")
        elif status == 2:
            print("\n🎉 登录成功！")
        elif status == 3:
            print("\n❌ 登录失败，请重试")
        elif status == 4:
            print("\n🚫 登录被拒绝")
        elif status == 10:  # QRCODE_REQUIRE_VERIFY
            print("\n🔐 新设备登录需要验证码！")
            self.handle_verification_required()

    def handle_verification_required(self):
        """
        处理需要验证码的情况
        """
        self.waiting_for_verification = True
        
        print("=" * 60)
        print("🔐 新设备登录安全验证")
        print("=" * 60)
        print("💡 首次在此设备登录需要验证码确认")
        print("📱 请在企业微信中获取验证码")
        print("-" * 60)
        
        # 在新线程中处理验证码输入，避免阻塞回调
        verification_thread = threading.Thread(
            target=self.prompt_for_verification_code,
            daemon=True
        )
        verification_thread.start()

    def prompt_for_verification_code(self):
        """
        提示用户输入验证码
        """
        max_attempts = 3
        attempt = 0
        
        while attempt < max_attempts:
            try:
                attempt += 1
                print(f"\n💭 验证码输入 (第{attempt}次，共{max_attempts}次机会)")
                verification_code = input("🔑 请输入验证码: ").strip()
                
                if not verification_code:
                    print("❌ 验证码不能为空")
                    continue
                    
                if not verification_code.isdigit():
                    print("❌ 验证码只能包含数字")
                    continue
                    
                print(f"📤 正在提交验证码: {verification_code}")
                success = self.verify_login_code(verification_code)
                
                if success:
                    print("✅ 验证码提交成功！请等待登录确认...")
                    self.waiting_for_verification = False
                    break
                else:
                    print(f"❌ 验证码错误或提交失败 (剩余{max_attempts - attempt}次机会)")
                    if attempt < max_attempts:
                        print("💡 请重新输入验证码")
                        
            except KeyboardInterrupt:
                print("\n🚫 验证码输入被取消")
                self.waiting_for_verification = False
                break
            except Exception as e:
                print(f"❌ 验证码输入异常: {e}")
                
        if attempt >= max_attempts:
            print("❌ 验证码输入次数已达上限，请重新扫码登录")
            self.waiting_for_verification = False

    def verify_login_code(self, code):
        """
        提交登录验证码
        
        Args:
            code: 验证码
            
        Returns:
            bool: 是否成功
        """
        logger.info(f"=== 提交登录验证码 ===")
        
        if not self.guid:
            logger.error("❌ 请先创建实例")
            return False
            
        data = {
            "guid": self.guid,
            "code": code
        }
        
        result = self.api_request("/login/verify_login_qrcode", data)
        
        if self.is_success_response(result):
            logger.info("✅ 验证码提交成功")
            return True
        else:
            error_msg = result.get('error_message') or result.get('err_msg', '未知错误')
            logger.error(f"❌ 验证码提交失败: {error_msg}")
            return False

    def handle_login_success(self, data):
        """
        处理登录成功
        """
        self.is_logged_in = True
        self.user_info = data
        self.waiting_for_verification = False  # 确保重置验证码等待状态
        
        logger.info("🎉 登录成功!")
        logger.info(f"👤 用户: {data.get('name')} ({data.get('user_id')})")
        logger.info(f"🏢 企业: {data.get('corp_full_name')}")

    def handle_logout(self, data):
        """
        处理退出登录
        """
        self.is_logged_in = False
        self.user_info = None
        self.waiting_for_verification = False  # 重置验证码等待状态
        
        logger.info("👋 已退出登录")
        logger.info(f"📄 原因: {data.get('error_message')}")

    def handle_new_message(self, data):
        """
        处理新消息
        """
        sender = data.get("sender_name", "未知")
        content = data.get("content", "")
        msg_type = data.get("msg_type")
        
        logger.info(f"💬 收到消息 [类型:{msg_type}]")
        logger.info(f"👤 发送者: {sender}")
        logger.info(f"📝 内容: {content}")

    def handle_message_sync(self, messages):
        """
        处理消息同步回调 (notify_type: 11013)
        
        Args:
            messages: 消息列表，每个消息包含完整的消息信息
        """
        logger.info("📨 处理消息同步")
        
        if not messages:
            logger.warning("⚠️  消息同步回调中没有消息数据")
            return
            
        for msg in messages:
            try:
                # 基本消息信息
                msg_id = msg.get("id", "")
                seq = msg.get("seq", "")
                send_flag = msg.get("send_flag", -1)
                msg_type = msg.get("msg_type", 0)
                content = msg.get("content", "")
                sender_name = msg.get("sender_name", "未知")
                sender = msg.get("sender", "")
                receiver = msg.get("receiver", "")
                roomid = msg.get("roomid", "0")
                
                # 判断消息方向
                direction = ""
                if send_flag == 1:
                    direction = "📤 发送"
                elif send_flag == 0:
                    direction = "📥 接收"
                else:
                    direction = "❓ 未知方向"
                
                # 判断消息类型
                msg_type_desc = ""
                if msg_type == 2:
                    msg_type_desc = "💬 文本消息"
                elif msg_type == 1012:
                    msg_type_desc = "⚙️  系统消息"
                else:
                    msg_type_desc = f"❓ 未知类型({msg_type})"
                
                # 判断会话类型
                chat_type = "私聊" if roomid == "0" else "群聊"
                
                # 格式化输出
                logger.info(f"📨 消息同步 - {direction}")
                logger.info(f"   🆔 ID: {msg_id} | 序号: {seq}")
                logger.info(f"   📝 类型: {msg_type_desc} | 会话: {chat_type}")
                logger.info(f"   👤 发送者: {sender_name} ({sender})")
                logger.info(f"   👥 接收者: {receiver}")
                if content:
                    logger.info(f"   💬 内容: {content}")
                
                # 如果是接收的文本消息，显示更友好的提示
                if send_flag == 0 and msg_type == 2 and content:
                    print(f"\n💬 收到来自 {sender_name} 的消息: {content}")
                    
                # 如果是发送的消息，显示发送确认
                elif send_flag == 1 and msg_type == 2 and content:
                    print(f"\n✅ 消息发送确认: {content}")
                    
            except Exception as e:
                logger.error(f"❌ 处理消息同步数据失败: {e}")
                logger.error(f"📊 问题消息数据: {msg}")

    def start_webhook_server(self):
        """
        启动回调服务器
        """
        def run_server():
            self.app.run(host='0.0.0.0', port=15000, debug=False, use_reloader=False)
            
        webhook_thread = threading.Thread(target=run_server, daemon=True)
        webhook_thread.start()
        logger.info("🌐 回调服务器已启动在 http://localhost:15000")

    def update_cdn_rule(self):
        """
        手工更新CDN信息（建议每6小时调用一次）

        Returns:
            bool: 是否成功
        """
        logger.info("=== 手工更新CDN信息 ===")
        if not self.guid:
            logger.error("❌ 未选择实例，无法更新CDN信息")
            print("💡 请先在主菜单选择 '2. 🎯 选择/创建实例'")
            return False

        payload = {"guid": self.guid}
        result = self.api_request("/cloud/update_cdn_rule", payload, method='POST')

        if self.is_success_response(result):
            logger.info("✅ CDN信息更新成功")
            print("✅ CDN信息更新成功（建议每6小时调用一次）")
            return True
        else:
            logger.error(f"❌ CDN信息更新失败: {result}")
            print("❌ CDN信息更新失败，请稍后重试")
            return False

    def wait_for_login(self, timeout=300):
        """
        等待登录完成
        
        Args:
            timeout: 超时时间(秒)
        
        Returns:
            bool: 是否登录成功
        """
        logger.info(f"⏳ 等待登录完成... (超时: {timeout}秒)")
        
        start_time = time.time()
        verification_notified = False
        
        while time.time() - start_time < timeout:
            if self.is_logged_in:
                return True
                
            # 如果正在等待验证码，给出提示并延长超时时间
            if self.waiting_for_verification and not verification_notified:
                logger.info("🔐 检测到需要验证码，请按提示输入...")
                logger.info("💡 验证码输入过程中，登录超时时间自动延长")
                verification_notified = True
                
            # 如果正在等待验证码，重置超时计时器
            if self.waiting_for_verification:
                start_time = time.time()  # 重置计时器
                
            time.sleep(2)
            
        logger.error("❌ 登录超时")
        return False

    def run_demo(self):
        """
        运行完整demo流程
        """
        logger.info("🚀 开始登录流程")
        logger.info("=" * 50)
        
        try:
            # 执行登录流程
            if not self.create_instance():
                return False
                
            if not self.set_notify_url():
                return False
                
            if not self.set_bridge():
                return False
                
            if not self.get_login_qrcode():
                return False
                
            # 等待用户扫码登录
            if not self.wait_for_login():
                return False
                
            logger.info("=" * 50)
            logger.info("🎉 登录流程完成！现在可以发送消息了")
            
            # 返回登录成功
            return True
                
        except Exception as e:
            logger.error(f"❌ Demo运行出错: {e}")
            return False

def main():
    """
    主函数
    """
    print("🔧 企业微信API最小Demo")
    print("📋 请确保:")
    print("   1. 企微API服务已启动")
    print("   2. 回调地址可访问 (http://IP:15000/webhook)")
    print("   3. 有企业微信扫码")
    print("💡 如遇API问题，请使用'API端点调试'功能检查")
    print("=" * 50)
    
    # 可以修改API服务器地址（增加URL校验与自动修正）
    def sanitize_api_url(user_input: str, default_url: str) -> str:
        from urllib.parse import urlparse
        s = (user_input or "").strip()
        if not s:
            return default_url
        # 误触发输入如“1”等非URL，回退默认
        if s.isdigit():
            logger.warning("检测到非URL输入，回退默认API地址")
            return default_url
        # 自动补全协议
        if not (s.startswith("http://") or s.startswith("https://")):
            s = "http://" + s
        p = urlparse(s)
        if not p.scheme or not p.netloc:
            logger.warning("输入URL不合法，回退默认API地址")
            return default_url
        return s

    user_input_api = input("🌐 API服务器地址 (默认 http://192.168.3.122:23456): ").strip()
    api_url = sanitize_api_url(user_input_api, "http://192.168.3.122:23456")
    
    demo = WeWorkAPIDemo(api_url)
    
    # 启动回调服务器
    demo.start_webhook_server()
    time.sleep(2)
    
    # 显示当前实例状态概览
    print("\n📊 当前实例状态概览:")
    print("-" * 40)
    try:
        clients = demo.get_all_clients()
        if clients:
            print(f"🔢 总实例数: {len(clients)}")
            online_count = 0
            for client in clients:
                try:
                    guid = client.get("guid") if isinstance(client, dict) else str(client)
                    status_info = demo.get_client_status(guid)
                    if status_info.get("status") == 2:  # 在线状态
                        online_count += 1
                except:
                    continue
            print(f"🟢 在线实例: {online_count}")
            print(f"🔴 离线实例: {len(clients) - online_count}")
        else:
            print("📋 当前没有任何实例")
    except Exception as e:
        print("⚠️  无法获取实例状态，请使用调试功能检查API端点")
        print(f"   错误信息: {str(e)[:50]}...")
    print("-" * 40)
    
    # 提供测试消息发送的交互功能
    def test_send_message():
        # if not demo.is_logged_in:
        #     print("❌ 请先完成登录")
        #     return
        
        print("\n💬 消息发送功能")
        print("=" * 50)
        print("1. 📋 从会话列表选择")
        print("2. ✏️  手动输入conversation_id")
        print("3. 🔙 返回主菜单")
        
        choice = input("\n💡 请选择 (1-3): ").strip()
        
        conversation_id = None
        
        if choice == "1":
            # 从会话列表选择
            conversation_id = demo.display_session_list()
            if not conversation_id:
                print("👋 未选择会话，返回主菜单")
                return
                
        elif choice == "2":
            # 手动输入
            print("\n✏️  手动输入conversation_id")
            print("💡 格式说明:")
            print("  - 私聊: S:788xxxxx 或 S:168xxxxx")
            print("  - 群聊: R:10xxxxxxx")
            conversation_id = input("📝 请输入conversation_id: ").strip()
            if not conversation_id:
                print("❌ conversation_id不能为空")
                return
                
            # 验证conversation_id格式
            if not (conversation_id.startswith("S:") or conversation_id.startswith("R:")):
                print("⚠️ 检测到可能的格式问题！")
                print(f"您输入的ID: {conversation_id}")
                print("💡 正确格式应该以 S: 或 R: 开头")
                
                # 智能修复建议
                if conversation_id.isdigit():
                    print("🔧 自动修复建议:")
                    suggestion_s = f"S:{conversation_id}"
                    suggestion_r = f"R:{conversation_id}"
                    print(f"  1. 私聊: {suggestion_s}")
                    print(f"  2. 群聊: {suggestion_r}")
                    print("  3. 手动重新输入")
                    print("  4. 跳过（使用原始输入）")
                    
                    fix_choice = input("\n💡 请选择修复方式 (1-4): ").strip()
                    if fix_choice == "1":
                        conversation_id = suggestion_s
                        print(f"✅ 已修复为私聊ID: {conversation_id}")
                    elif fix_choice == "2":
                        conversation_id = suggestion_r
                        print(f"✅ 已修复为群聊ID: {conversation_id}")
                    elif fix_choice == "3":
                        conversation_id = input("📝 请重新输入conversation_id: ").strip()
                        if not conversation_id:
                            print("❌ conversation_id不能为空")
                            return
                    elif fix_choice == "4":
                        print(f"⚠️ 继续使用原始输入: {conversation_id}")
                    else:
                        print("❌ 无效选择，使用原始输入")
                else:
                    print("💡 建议重新输入正确格式的conversation_id")
                    
            logger.info(f"✏️ 手动输入conversation_id: {conversation_id}")
                
        elif choice == "3":
            return
        else:
            print("❌ 无效选择")
            return
            
        # 选择消息类型
        is_group = conversation_id.startswith("R:")
        print("\n🧭 选择消息类型")
        print("1. 💬 文本消息")
        if is_group:
            print("2. 🏷️ 群@消息")
            print("3. 🎙️ 语音消息")
            type_choice = input("\n💡 请选择 (1-3): ").strip()
        else:
            print("2. 🎙️ 语音消息")
            type_choice = input("\n💡 请选择 (1-2): ").strip()

        success = False
        if type_choice == "1":
            # 文本
            content = input("\n💬 请输入文本内容: ").strip()
            if not content:
                print("❌ 文本内容不能为空")
                return
            success = demo.send_text_message(conversation_id, content)
        elif type_choice == "2" and is_group:
            # 群@消息
            print("\n@ 选项: 1=@特定人员  2=@全部人")
            at_mode = input("请选择 @ 模式 (1-2): ").strip()
            if at_mode == "1":
                user_ids = input("请输入要@的用户ID (多个用逗号分隔): ").strip()
                if not user_ids:
                    print("❌ 用户ID不能为空")
                    return
                at_list = [uid.strip() for uid in user_ids.split(",")]
            else:
                at_list = [0]
            content = input("\n💬 请输入群消息内容: ").strip()
            if not content:
                print("❌ 消息内容不能为空")
                return
            success = demo.send_room_at_message(conversation_id, content, at_list)
        else:
            # 语音（始终先上传以获取 file_id）
            print("\n🎙️ 发送语音消息参数")
            resource = input("请输入资源路径(本地绝对路径或http/https URL): ").strip()
            if not resource:
                print("❌ 资源路径不能为空")
                return
            upload_info = demo.upload_c2c_file(resource, conversation_id)
            if not upload_info or not upload_info.get('file_id'):
                print("❌ 文件上传失败，无法获取 file_id")
                return
            file_id = upload_info.get('file_id')
            # 兼容两类返回字段：cdn_c2c_upload(file_size,file_md5) 与 c2c_upload(size,md5)
            size = int((upload_info.get('size') or upload_info.get('file_size') or 0))
            aes_key = upload_info.get('aes_key') or ""
            md5 = upload_info.get('md5') or upload_info.get('file_md5') or ""
            print(f"✅ 上传成功，file_id={file_id}")
            logger.info(f"📦 上传返回映射: size={size}, md5={md5}, aes_key={aes_key}")

            voice_time_in = input("voice_time(秒，可选，默认0): ").strip()
            try:
                voice_time = int(voice_time_in) if voice_time_in else 0
            except ValueError:
                print("❌ voice_time 必须为数字")
                return

            success = demo.send_voice_message(conversation_id, file_id, size, voice_time, aes_key, md5)
        
        if success:
            print("✅ 消息发送成功！")
        else:
            print("❌ 消息发送失败，请检查参数是否正确")
    
    # 提供实例管理和消息发送功能
    while True:
        try:
            print("\n" + "=" * 50)
            print("🔧 企业微信API Demo - 主菜单")
            print("=" * 50)
            print("1. 📋 查看实例列表")
            print("2. 🎯 选择/创建实例")
            print("3. 📱 查看会话列表")
            print("4. 💬 发送消息")
            print("5. 📊 状态检查")
            print("6. 🔧 API端点调试")
            print("7. 🔄 更新CDN信息")
            print("8. 🚪 退出程序")
            print("=" * 50)

            choice = input("💡 请选择功能 (1-8): ").strip()

            if choice == '1':
                demo.list_instances_interactive()
            elif choice == '2':
                if demo.select_instance_interactive():
                    print("✅ 实例选择/创建完成！")
                else:
                    print("💡 未选择实例，可稍后再试")
            elif choice == '3':
                demo.display_session_list()
            elif choice == '4':
                test_send_message()
            elif choice == '5':
                demo.check_current_status()
            elif choice == '6':
                demo.debug_api_endpoints()
            elif choice == '7':
                demo.update_cdn_rule()
            elif choice == '8':
                print("👋 程序退出")
                break
            else:
                print("❓ 无效选择，请输入 1-8")

        except KeyboardInterrupt:
            print("\n👋 程序退出")
            break

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 程序被用户中断，正在退出...")
    except Exception as e:
        print(f"\n❌ 程序发生异常: {e}")
        print("💡 请检查API服务器是否正常运行")
        print("💡 如需详细调试，请使用'API端点调试'功能") 