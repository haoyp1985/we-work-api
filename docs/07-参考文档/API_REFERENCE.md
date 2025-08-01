# 🔧 企业微信API参考文档
*基于实际运行日志分析整理*

## 📊 核心API接口

### 1. 实例管理

#### 1.1 获取所有实例列表
```http
GET /client/all_clients
```

**请求参数：**
```json
{}
```

**成功响应：**
```json
{
  "data": ["5b1eb388-a4df-3da5-a49a-507eea46632c"]
}
```

#### 1.2 获取实例状态
```http
POST /client/get_client_status
```

**请求参数：**
```json
{
  "guid": "5b1eb388-a4df-3da5-a49a-507eea46632c"
}
```

**成功响应：**
```json
{
  "error_code": 0,
  "data": {
    "status": 2
  }
}
```

**状态值说明：**
- `0` = 停止状态
- `1` = 运行中（需要登录）
- `2` = 在线状态（可直接使用）

### 2. 会话管理

#### 2.1 获取会话列表
```http
POST /session/get_session_list
```

**请求参数：**
```json
{
  "guid": "5b1eb388-a4df-3da5-a49a-507eea46632c",
  "begin_seq": "0",
  "limit": 100
}
```

**成功响应：**
```json
{
  "error_code": 0,
  "error_message": "ok",
  "data": {
    "session_list": [
      "S:1688852792312821",
      "S:1688857160788209", 
      "R:1970325468984112",
      "R:13102691282047519",
      "R:13102691536807585"
    ],
    "begin_seq": "1000123"
  }
}
```

**会话ID格式：**
- `S:xxxxxxxx` = 私聊会话
- `R:xxxxxxxx` = 群聊会话

### 3. 消息发送

#### 3.1 发送文本消息
```http
POST /msg/send_text
```

**请求参数：**
```json
{
  "guid": "5b1eb388-a4df-3da5-a49a-507eea46632c",
  "conversation_id": "S:1688857160788209",
  "content": "测试一条消息"
}
```

**成功响应：**
```json
{
  "error_code": 0,
  "error_message": "ok",
  "data": {
    "msg_data": {
      "id": "1000127",
      "seq": "14303419",
      "messagetype": 0,
      "sender": "1688856214724417",
      "receiver": "1688857160788209",
      "roomid": "0",
      "contenttype": 2,
      "content": "ChgIABIUChLmtYvor5XkuIDmnaHmtojmga8=",
      "sendtime": 1753785577,
      "flag": 0,
      "devinfo": "131075",
      "appinfo": "Q0FVUTZjbWl4QVlZNk9qeC9JdldyS3NZSVBUcWdQQUw=",
      "sendername": "6YOd5rC45bmz",
      "extra_content": "oj8IuAGS3ZCuhTOqvgFfCiBuArKOQkqHqRjIxABCtsSRByJbhxlBNIfNjBtxQryA8hACGjkI6cmixAYQARogQ0FVUTZjbWl4QVlZNk9qeC9JdldyS3NZSVBUcWdQQUwiAhAAMMG+hdaXgIADOAE=",
      "asid": "0"
    },
    "is_svr_fail": false
  }
}
```

## ❌ 错误代码参考

| 错误代码 | 含义 | 原因 | 解决方案 |
|---------|------|------|----------|
| `0` | 成功 | - | - |
| `-2003` | 参数错误 | conversation_id格式错误（缺少S:或R:前缀） | 验证并修复conversation_id格式 |
| `-4017` | 权限错误 | 对方无外部联系人权限，发送消息失败 | 检查联系人权限或换其他联系人测试 |

**错误响应示例：**
```json
{
  "error_code": -4017,
  "error_message": "head rsp code error, error_msg: 对方无外部联系人权限，发送消息失败",
  "data": {}
}
```

## 🔔 回调类型详解

### 新发现：notify_type: 11013（消息同步回调）

**触发时机：** 发送或接收消息时

**回调数据结构：**
```json
{
  "guid": "5b1eb388-a4df-3da5-a49a-507eea46632c",
  "notify_type": 11013,
  "data": [
    {
      "seq": "14303419",
      "id": "1000127",
      "appinfo": "CAUQ6cmixAYY6Ojx/IvWrKsYIPTqgPAL",
      "sender": "1688856214724417",
      "receiver": "1688857160788209",
      "roomid": "0",
      "sendtime": 1753785577,
      "sender_name": "郝永平",
      "content_type": 2,
      "referid": "0",
      "flag": 0,
      "asid": "0",
      "extra_content": "oj8I...",
      "content": "测试一条消息",
      "at_list": [],
      "quote_content": "",
      "quote_appinfo": "",
      "send_flag": 1,
      "msg_type": 2
    }
  ]
}
```

**关键字段说明：**

| 字段 | 含义 | 可能值 |
|------|------|--------|
| `send_flag` | 发送方向 | `1`=我发送, `0`=我接收 |
| `msg_type` | 消息类型 | `2`=普通文本, `1012`=系统消息 |
| `content_type` | 内容类型 | `2`=文本内容, `2001`=系统内容 |
| `content` | 消息内容 | 文本消息为明文，其他可能是编码 |
| `sender_name` | 发送者姓名 | 中文姓名，便于显示 |
| `roomid` | 房间ID | `"0"`=私聊, 其他=群聊ID |

## 💡 开发建议

### 1. **Conversation ID验证**
```python
def validate_conversation_id(conv_id):
    if not (conv_id.startswith("S:") or conv_id.startswith("R:")):
        # 自动修复
        if conv_id.isdigit():
            return f"S:{conv_id}"  # 默认为私聊
    return conv_id
```

### 2. **错误处理**
```python
def handle_api_error(response):
    error_code = response.get("error_code", 0)
    if error_code == -2003:
        return "参数格式错误，请检查conversation_id格式"
    elif error_code == -4017:
        return "权限不足，无法发送消息到此联系人"
    elif error_code == 0:
        return "成功"
    else:
        return f"未知错误: {error_code}"
```

### 3. **实时消息处理**
```python
def handle_message_callback(data):
    if data.get("notify_type") == 11013:
        messages = data.get("data", [])
        for msg in messages:
            if msg.get("send_flag") == 0:  # 接收的消息
                print(f"收到来自 {msg['sender_name']} 的消息: {msg['content']}")
            elif msg.get("send_flag") == 1:  # 发送的消息
                print(f"消息发送确认: {msg['content']}")
```

### 4. **会话类型判断**
```python
def get_session_type(conversation_id):
    if conversation_id.startswith("S:"):
        return "私聊"
    elif conversation_id.startswith("R:"):
        return "群聊" 
    else:
        return "未知"
```

## 🔍 调试技巧

1. **API调试模式**：启用详细日志记录所有请求响应
2. **回调调试**：设置专门的回调处理器记录所有notify_type
3. **格式验证**：发送消息前验证conversation_id格式
4. **权限测试**：使用不同联系人测试消息发送权限
5. **实例状态监控**：定期检查实例状态确保在线

## 📋 TODO清单

基于此次分析，正式版本建议增加：

- [ ] conversation_id格式自动修复
- [ ] 完整的错误码处理映射
- [ ] notify_type: 11013消息同步处理
- [ ] 实时消息接收和显示
- [ ] 权限检查和友好提示
- [ ] 会话详细信息获取API
- [ ] 消息发送状态确认机制
- [ ] 批量消息发送功能 