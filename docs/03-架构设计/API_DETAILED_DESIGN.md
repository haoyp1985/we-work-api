# 🔌 WeWork管理平台API接口详细设计
*WeWork Management Platform - Detailed API Design Specification*

## 📋 设计概述

### 设计目标
- **标准化设计**: 遵循RESTful API设计原则和最佳实践
- **完整性覆盖**: 覆盖所有业务功能的API接口设计
- **高可用性**: 支持高并发、高可用的接口服务
- **安全可靠**: 完善的认证授权和数据安全保护
- **易于使用**: 清晰的接口文档和使用示例

### 设计原则
- **RESTful风格**: 使用标准HTTP方法和状态码
- **统一规范**: 统一的接口命名、参数格式和响应结构
- **版本管理**: 支持API版本演进和向后兼容
- **错误处理**: 标准化的错误响应和错误码
- **性能优化**: 支持分页、缓存、压缩等性能优化

### 技术规范
```yaml
API技术规范:
  协议标准:
    - HTTP/HTTPS协议
    - RESTful架构风格
    - JSON数据格式
    - UTF-8字符编码

  认证方式:
    - OAuth 2.0 + JWT Token
    - API Key认证
    - 请求签名验证

  版本控制:
    - URL路径版本: /api/v1/
    - Header版本: API-Version: v1
    - 向后兼容支持

  限流策略:
    - 用户级别限流
    - 接口级别限流
    - IP级别限流
    - 令牌桶算法
```

## 🏗️ API架构设计

### 整体架构
```yaml
API架构层次:
  1. 接入层 (Gateway Layer)
     - API网关 (Kong/Nginx)
     - 负载均衡
     - SSL终端
     - 限流熔断

  2. 认证层 (Authentication Layer)
     - 身份认证
     - 权限验证
     - Token管理
     - 安全检查

  3. 业务层 (Business Layer)
     - 业务逻辑处理
     - 数据验证
     - 业务规则
     - 事务管理

  4. 数据层 (Data Layer)
     - 数据访问
     - 缓存管理
     - 数据库操作
     - 外部服务调用
```

### URL设计规范
```yaml
URL设计标准:
  基础结构:
    - 协议: https://
    - 域名: api.wework.example.com
    - 版本: /v1/
    - 资源路径: /resources/

  命名规范:
    - 使用小写字母
    - 单词间用短横线分隔
    - 复数形式表示集合
    - 避免动词，使用HTTP方法

  示例:
    - GET /api/v1/instances          # 获取实例列表
    - POST /api/v1/instances         # 创建实例
    - GET /api/v1/instances/{id}     # 获取单个实例
    - PUT /api/v1/instances/{id}     # 更新实例
    - DELETE /api/v1/instances/{id}  # 删除实例
```

## 📊 通用响应格式

### 标准响应结构
```yaml
响应格式设计:
  成功响应:
    {
      "code": 200,
      "message": "操作成功",
      "data": {
        // 具体数据内容
      },
      "meta": {
        "timestamp": "2024-01-01T10:00:00Z",
        "requestId": "uuid-string",
        "version": "v1"
      }
    }

  分页响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        // 数据列表
      ],
      "meta": {
        "pagination": {
          "page": 1,
          "pageSize": 20,
          "total": 100,
          "totalPages": 5
        },
        "timestamp": "2024-01-01T10:00:00Z",
        "requestId": "uuid-string"
      }
    }

  错误响应:
    {
      "code": 400,
      "message": "请求参数错误",
      "error": {
        "type": "ValidationError",
        "details": [
          {
            "field": "email",
            "message": "邮箱格式不正确"
          }
        ]
      },
      "meta": {
        "timestamp": "2024-01-01T10:00:00Z",
        "requestId": "uuid-string"
      }
    }
```

### HTTP状态码规范
```yaml
状态码使用规范:
  成功状态码:
    - 200 OK: 请求成功
    - 201 Created: 资源创建成功
    - 202 Accepted: 请求已接受，处理中
    - 204 No Content: 请求成功，无返回内容

  客户端错误:
    - 400 Bad Request: 请求参数错误
    - 401 Unauthorized: 未认证
    - 403 Forbidden: 无权限
    - 404 Not Found: 资源不存在
    - 409 Conflict: 资源冲突
    - 422 Unprocessable Entity: 数据验证失败
    - 429 Too Many Requests: 请求过多

  服务端错误:
    - 500 Internal Server Error: 服务器内部错误
    - 502 Bad Gateway: 网关错误
    - 503 Service Unavailable: 服务不可用
    - 504 Gateway Timeout: 网关超时
```

## 🔐 认证授权API

### 用户认证接口
```yaml
认证相关API:
  
  # 用户登录
  POST /api/v1/auth/login
  Content-Type: application/json
  
  请求体:
    {
      "username": "admin@example.com",
      "password": "password123",
      "captcha": "abcd",
      "captchaToken": "captcha-token-uuid"
    }
  
  响应:
    {
      "code": 200,
      "message": "登录成功",
      "data": {
        "accessToken": "eyJhbGciOiJIUzI1NiIs...",
        "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
        "expiresIn": 3600,
        "tokenType": "Bearer",
        "user": {
          "id": "user-123",
          "username": "admin",
          "email": "admin@example.com",
          "roles": ["admin"],
          "permissions": ["user:read", "user:write"]
        }
      }
    }

  # 刷新令牌
  POST /api/v1/auth/refresh
  Content-Type: application/json
  
  请求体:
    {
      "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
    }
  
  响应:
    {
      "code": 200,
      "message": "刷新成功",
      "data": {
        "accessToken": "eyJhbGciOiJIUzI1NiIs...",
        "expiresIn": 3600
      }
    }

  # 用户登出
  POST /api/v1/auth/logout
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "登出成功"
    }

  # 获取当前用户信息
  GET /api/v1/auth/profile
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "id": "user-123",
        "username": "admin",
        "email": "admin@example.com",
        "avatar": "https://avatar.url/image.jpg",
        "roles": ["admin"],
        "permissions": ["user:read", "user:write"],
        "lastLoginTime": "2024-01-01T10:00:00Z",
        "lastLoginIp": "192.168.1.100"
      }
    }
```

## 📱 企业微信管理API

### 实例管理接口
```yaml
实例管理API:

  # 获取实例列表
  GET /api/v1/instances
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码 (默认: 1)
    - pageSize: 每页数量 (默认: 20, 最大: 100)
    - status: 状态过滤 (online|offline|error)
    - keyword: 关键词搜索
    - sortBy: 排序字段 (createdAt|updatedAt|name)
    - sortOrder: 排序方向 (asc|desc)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "instance-123",
          "name": "企微实例-01",
          "status": "online",
          "version": "v2.8.0",
          "proxyInfo": {
            "host": "proxy.example.com",
            "port": 8080
          },
          "accountCount": 5,
          "lastHeartbeat": "2024-01-01T10:00:00Z",
          "createdAt": "2024-01-01T08:00:00Z",
          "updatedAt": "2024-01-01T10:00:00Z"
        }
      ],
      "meta": {
        "pagination": {
          "page": 1,
          "pageSize": 20,
          "total": 50,
          "totalPages": 3
        }
      }
    }

  # 创建实例
  POST /api/v1/instances
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "企微实例-02",
      "description": "测试环境实例",
      "proxyConfig": {
        "host": "proxy.example.com",
        "port": 8080,
        "username": "proxy_user",
        "password": "proxy_pass"
      },
      "notificationUrl": "https://webhook.example.com/callback"
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "id": "instance-124",
        "name": "企微实例-02",
        "status": "initializing",
        "qrCode": "data:image/png;base64,iVBORw0KGgoAAAANS...",
        "qrCodeExpiry": "2024-01-01T10:05:00Z"
      }
    }

  # 获取单个实例详情
  GET /api/v1/instances/{instanceId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "id": "instance-123",
        "name": "企微实例-01",
        "description": "生产环境实例",
        "status": "online",
        "version": "v2.8.0",
        "proxyInfo": {
          "host": "proxy.example.com",
          "port": 8080
        },
        "statistics": {
          "accountCount": 5,
          "totalMessages": 1000,
          "todayMessages": 50
        },
        "createdAt": "2024-01-01T08:00:00Z",
        "updatedAt": "2024-01-01T10:00:00Z"
      }
    }

  # 更新实例
  PUT /api/v1/instances/{instanceId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "企微实例-01-更新",
      "description": "更新后的描述",
      "notificationUrl": "https://new-webhook.example.com/callback"
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功",
      "data": {
        "id": "instance-123",
        "name": "企微实例-01-更新",
        "description": "更新后的描述"
      }
    }

  # 启动实例
  POST /api/v1/instances/{instanceId}/start
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "启动成功",
      "data": {
        "status": "starting",
        "message": "实例正在启动中"
      }
    }

  # 停止实例
  POST /api/v1/instances/{instanceId}/stop
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "停止成功",
      "data": {
        "status": "stopping",
        "message": "实例正在停止中"
      }
    }

  # 重启实例
  POST /api/v1/instances/{instanceId}/restart
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "重启成功",
      "data": {
        "status": "restarting",
        "message": "实例正在重启中"
      }
    }

  # 删除实例
  DELETE /api/v1/instances/{instanceId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

### 账号管理接口
```yaml
账号管理API:

  # 获取账号列表
  GET /api/v1/instances/{instanceId}/accounts
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - status: 状态过滤 (online|offline|banned)
    - keyword: 关键词搜索
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "account-123",
          "instanceId": "instance-123",
          "nickname": "张三",
          "avatar": "https://avatar.url/image.jpg",
          "wxid": "wxid_123456",
          "status": "online",
          "isLoggedIn": true,
          "lastLoginTime": "2024-01-01T10:00:00Z",
          "contactCount": 200,
          "groupCount": 50,
          "createdAt": "2024-01-01T08:00:00Z"
        }
      ]
    }

  # 添加账号
  POST /api/v1/instances/{instanceId}/accounts
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "loginMethod": "qrcode", // qrcode | phone
      "phoneNumber": "13800138000", // 手机号登录时必填
      "verificationCode": "123456" // 手机号登录时必填
    }
  
  响应:
    {
      "code": 201,
      "message": "添加成功",
      "data": {
        "id": "account-124",
        "qrCode": "data:image/png;base64,iVBORw0KGgoAAAANS...",
        "qrCodeExpiry": "2024-01-01T10:05:00Z",
        "status": "waiting_scan"
      }
    }

  # 获取账号详情
  GET /api/v1/instances/{instanceId}/accounts/{accountId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "id": "account-123",
        "instanceId": "instance-123",
        "nickname": "张三",
        "avatar": "https://avatar.url/image.jpg",
        "wxid": "wxid_123456",
        "phoneNumber": "138****8000",
        "status": "online",
        "isLoggedIn": true,
        "lastLoginTime": "2024-01-01T10:00:00Z",
        "statistics": {
          "contactCount": 200,
          "groupCount": 50,
          "totalMessages": 5000,
          "todayMessages": 100
        },
        "createdAt": "2024-01-01T08:00:00Z"
      }
    }

  # 账号登出
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/logout
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "登出成功"
    }

  # 删除账号
  DELETE /api/v1/instances/{instanceId}/accounts/{accountId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

### 联系人管理接口
```yaml
联系人管理API:

  # 获取联系人列表
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/contacts
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - type: 类型过滤 (friend|group|official)
    - keyword: 关键词搜索
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "contact-123",
          "wxid": "wxid_contact123",
          "nickname": "李四",
          "remark": "客户-李四",
          "avatar": "https://avatar.url/image.jpg",
          "type": "friend",
          "gender": 1, // 0:未知, 1:男, 2:女
          "signature": "个性签名",
          "region": "广东 深圳",
          "isBlocked": false,
          "tags": ["客户", "重要"],
          "addTime": "2024-01-01T08:00:00Z",
          "lastChatTime": "2024-01-01T09:30:00Z"
        }
      ]
    }

  # 同步联系人
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/contacts/sync
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "同步开始",
      "data": {
        "taskId": "sync-task-123",
        "status": "running",
        "estimatedTime": 30
      }
    }

  # 添加联系人
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/contacts
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "searchType": "wxid", // wxid | phone | qrcode
      "searchValue": "wxid_target123",
      "verifyMessage": "你好，我是XX",
      "tags": ["客户"]
    }
  
  响应:
    {
      "code": 201,
      "message": "添加请求已发送",
      "data": {
        "requestId": "add-request-123",
        "status": "pending"
      }
    }

  # 更新联系人信息
  PUT /api/v1/instances/{instanceId}/accounts/{accountId}/contacts/{contactId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "remark": "重要客户-李四",
      "tags": ["VIP客户", "重要"]
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功",
      "data": {
        "id": "contact-123",
        "remark": "重要客户-李四",
        "tags": ["VIP客户", "重要"]
      }
    }

  # 删除联系人
  DELETE /api/v1/instances/{instanceId}/accounts/{accountId}/contacts/{contactId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

### 群聊管理接口
```yaml
群聊管理API:

  # 获取群聊列表
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/groups
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - keyword: 关键词搜索
    - memberCountMin: 最小成员数
    - memberCountMax: 最大成员数
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "group-123",
          "wxid": "group_wxid_123",
          "name": "产品讨论群",
          "avatar": "https://avatar.url/group.jpg",
          "memberCount": 50,
          "maxMemberCount": 500,
          "isOwner": true,
          "isAdmin": false,
          "notice": "群公告内容",
          "description": "群描述",
          "createdAt": "2024-01-01T08:00:00Z",
          "joinTime": "2024-01-01T08:00:00Z",
          "lastMessageTime": "2024-01-01T09:30:00Z"
        }
      ]
    }

  # 获取群聊详情
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "id": "group-123",
        "wxid": "group_wxid_123",
        "name": "产品讨论群",
        "avatar": "https://avatar.url/group.jpg",
        "memberCount": 50,
        "maxMemberCount": 500,
        "isOwner": true,
        "isAdmin": false,
        "notice": "群公告内容",
        "description": "群描述",
        "settings": {
          "allowMemberInvite": true,
          "allowMemberModifyGroupName": false,
          "requireAdminApproval": true
        },
        "statistics": {
          "totalMessages": 10000,
          "todayMessages": 200,
          "activeMembers": 30
        },
        "createdAt": "2024-01-01T08:00:00Z"
      }
    }

  # 获取群成员列表
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}/members
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - role: 角色过滤 (owner|admin|member)
    - keyword: 关键词搜索
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "member-123",
          "wxid": "wxid_member123",
          "nickname": "王五",
          "groupNickname": "产品经理-王五",
          "avatar": "https://avatar.url/member.jpg",
          "role": "admin", // owner | admin | member
          "joinTime": "2024-01-01T08:00:00Z",
          "lastActiveTime": "2024-01-01T09:30:00Z",
          "messageCount": 500,
          "isBlocked": false
        }
      ]
    }

  # 创建群聊
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/groups
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "新产品讨论群",
      "memberWxids": ["wxid_member1", "wxid_member2", "wxid_member3"]
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "id": "group-124",
        "wxid": "group_wxid_124",
        "name": "新产品讨论群",
        "memberCount": 4,
        "inviteLink": "https://wework.example.com/invite/abc123"
      }
    }

  # 更新群信息
  PUT /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "产品讨论群-V2",
      "notice": "新的群公告内容",
      "description": "更新后的群描述"
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功"
    }

  # 邀请成员入群
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}/members
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "memberWxids": ["wxid_new1", "wxid_new2"],
      "inviteMessage": "邀请你加入产品讨论群"
    }
  
  响应:
    {
      "code": 200,
      "message": "邀请成功",
      "data": {
        "successCount": 2,
        "failCount": 0,
        "results": [
          {
            "wxid": "wxid_new1",
            "status": "invited",
            "message": "邀请成功"
          }
        ]
      }
    }

  # 移除群成员
  DELETE /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}/members/{memberWxid}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "移除成功"
    }

  # 退出群聊
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/groups/{groupId}/leave
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "退出成功"
    }
```

## 💬 消息发送API

### 消息发送接口
```yaml
消息发送API:

  # 发送文本消息
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/messages/text
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "receivers": [
        {
          "type": "contact", // contact | group
          "wxid": "wxid_receiver123"
        }
      ],
      "content": "这是一条文本消息",
      "options": {
        "atMembers": ["wxid_member1"], // 群聊@成员
        "scheduled": "2024-01-01T10:30:00Z", // 定时发送
        "priority": "normal" // low | normal | high
      }
    }
  
  响应:
    {
      "code": 200,
      "message": "发送成功",
      "data": {
        "taskId": "message-task-123",
        "status": "queued",
        "scheduledCount": 1,
        "estimatedTime": 5
      }
    }

  # 发送图片消息
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/messages/image
  Authorization: Bearer {accessToken}
  Content-Type: multipart/form-data
  
  请求参数:
    - image: 图片文件 (支持jpg,png,gif，最大10MB)
    - receivers: JSON字符串格式的接收者列表
    - options: JSON字符串格式的发送选项
  
  响应:
    {
      "code": 200,
      "message": "发送成功",
      "data": {
        "taskId": "message-task-124",
        "imageUrl": "https://cdn.example.com/images/abc123.jpg",
        "status": "queued"
      }
    }

  # 发送文件消息
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/messages/file
  Authorization: Bearer {accessToken}
  Content-Type: multipart/form-data
  
  请求参数:
    - file: 文件 (最大100MB)
    - receivers: JSON字符串格式的接收者列表
    - options: JSON字符串格式的发送选项
  
  响应:
    {
      "code": 200,
      "message": "发送成功",
      "data": {
        "taskId": "message-task-125",
        "fileName": "document.pdf",
        "fileSize": 1024000,
        "fileUrl": "https://cdn.example.com/files/abc123.pdf",
        "status": "queued"
      }
    }

  # 发送链接消息
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/messages/link
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "receivers": [
        {
          "type": "contact",
          "wxid": "wxid_receiver123"
        }
      ],
      "link": {
        "title": "文章标题",
        "description": "文章描述",
        "url": "https://example.com/article",
        "imageUrl": "https://example.com/image.jpg"
      }
    }
  
  响应:
    {
      "code": 200,
      "message": "发送成功",
      "data": {
        "taskId": "message-task-126",
        "status": "queued"
      }
    }

  # 获取发送任务状态
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/messages/tasks/{taskId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "taskId": "message-task-123",
        "status": "completed", // queued | processing | completed | failed | cancelled
        "messageType": "text",
        "totalCount": 10,
        "successCount": 9,
        "failCount": 1,
        "progress": 100,
        "createdAt": "2024-01-01T10:00:00Z",
        "completedAt": "2024-01-01T10:05:00Z",
        "results": [
          {
            "receiver": "wxid_receiver123",
            "status": "success",
            "messageId": "msg-123",
            "sentAt": "2024-01-01T10:00:30Z"
          }
        ]
      }
    }

  # 取消发送任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/messages/tasks/{taskId}/cancel
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "取消成功",
      "data": {
        "taskId": "message-task-123",
        "status": "cancelled",
        "cancelledCount": 5
      }
    }
```

### 群发助手接口
```yaml
群发助手API:

  # 创建群发任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "新年祝福群发",
      "description": "给所有客户发送新年祝福",
      "messageType": "text",
      "content": "祝您新年快乐，身体健康！",
      "receivers": [
        {
          "type": "tag",
          "value": "客户"
        },
        {
          "type": "contact",
          "wxid": "wxid_special123"
        }
      ],
      "settings": {
        "sendInterval": 30, // 发送间隔秒数
        "startTime": "2024-01-01T10:00:00Z",
        "endTime": "2024-01-01T18:00:00Z"
      }
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "broadcastId": "broadcast-123",
        "name": "新年祝福群发",
        "status": "draft",
        "targetCount": 200,
        "estimatedTime": 6000
      }
    }

  # 获取群发任务列表
  GET /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - status: 状态过滤 (draft|scheduled|running|completed|failed|cancelled)
    - startDate: 开始日期
    - endDate: 结束日期
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "broadcast-123",
          "name": "新年祝福群发",
          "description": "给所有客户发送新年祝福",
          "messageType": "text",
          "status": "completed",
          "targetCount": 200,
          "successCount": 195,
          "failCount": 5,
          "progress": 100,
          "createdAt": "2024-01-01T09:00:00Z",
          "startedAt": "2024-01-01T10:00:00Z",
          "completedAt": "2024-01-01T16:40:00Z"
        }
      ]
    }

  # 启动群发任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast/{broadcastId}/start
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "启动成功",
      "data": {
        "broadcastId": "broadcast-123",
        "status": "running",
        "startedAt": "2024-01-01T10:00:00Z"
      }
    }

  # 暂停群发任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast/{broadcastId}/pause
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "暂停成功",
      "data": {
        "broadcastId": "broadcast-123",
        "status": "paused"
      }
    }

  # 恢复群发任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast/{broadcastId}/resume
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "恢复成功",
      "data": {
        "broadcastId": "broadcast-123",
        "status": "running"
      }
    }

  # 取消群发任务
  POST /api/v1/instances/{instanceId}/accounts/{accountId}/broadcast/{broadcastId}/cancel
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "取消成功",
      "data": {
        "broadcastId": "broadcast-123",
        "status": "cancelled",
        "cancelledCount": 50
      }
    }
```

### 消息模板接口
```yaml
消息模板API:

  # 获取模板列表
  GET /api/v1/message-templates
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - category: 分类过滤
    - keyword: 关键词搜索
    - messageType: 消息类型 (text|image|link)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "template-123",
          "name": "新年祝福模板",
          "category": "节日祝福",
          "messageType": "text",
          "content": "祝您{{holiday}}快乐，{{blessing}}！",
          "variables": [
            {
              "name": "holiday",
              "description": "节日名称",
              "required": true,
              "defaultValue": "新年"
            },
            {
              "name": "blessing",
              "description": "祝福语",
              "required": false,
              "defaultValue": "身体健康"
            }
          ],
          "useCount": 50,
          "createdAt": "2024-01-01T08:00:00Z"
        }
      ]
    }

  # 创建模板
  POST /api/v1/message-templates
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "产品推广模板",
      "category": "营销推广",
      "messageType": "text",
      "content": "亲爱的{{customerName}}，我们的新产品{{productName}}现在上线了，{{description}}。详情请访问：{{link}}",
      "variables": [
        {
          "name": "customerName",
          "description": "客户姓名",
          "required": true
        },
        {
          "name": "productName",
          "description": "产品名称",
          "required": true
        },
        {
          "name": "description",
          "description": "产品描述",
          "required": false,
          "defaultValue": "功能强大，价格优惠"
        },
        {
          "name": "link",
          "description": "产品链接",
          "required": true
        }
      ]
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "id": "template-124",
        "name": "产品推广模板",
        "category": "营销推广"
      }
    }

  # 预览模板
  POST /api/v1/message-templates/{templateId}/preview
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "variables": {
        "customerName": "张先生",
        "productName": "智能手机",
        "description": "性能卓越，拍照出色",
        "link": "https://shop.example.com/phone"
      }
    }
  
  响应:
    {
      "code": 200,
      "message": "预览成功",
      "data": {
        "content": "亲爱的张先生，我们的新产品智能手机现在上线了，性能卓越，拍照出色。详情请访问：https://shop.example.com/phone"
      }
    }

  # 更新模板
  PUT /api/v1/message-templates/{templateId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "产品推广模板-V2",
      "content": "尊敬的{{customerName}}，我们的{{productName}}已经上线..."
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功"
    }

  # 删除模板
  DELETE /api/v1/message-templates/{templateId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

## 📊 监控运维API

### 系统监控接口
```yaml
系统监控API:

  # 获取系统状态
  GET /api/v1/monitoring/status
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "overall": "healthy", // healthy | warning | critical
        "services": [
          {
            "name": "API服务",
            "status": "healthy",
            "responseTime": 50,
            "uptime": "99.99%",
            "lastCheck": "2024-01-01T10:00:00Z"
          },
          {
            "name": "数据库",
            "status": "healthy",
            "connections": 10,
            "maxConnections": 100,
            "responseTime": 5
          },
          {
            "name": "Redis缓存",
            "status": "healthy",
            "memoryUsage": "60%",
            "hitRate": "95%"
          },
          {
            "name": "消息队列",
            "status": "warning",
            "queueLength": 1000,
            "maxQueueLength": 5000,
            "processingRate": 100
          }
        ],
        "metrics": {
          "totalInstances": 10,
          "onlineInstances": 9,
          "totalAccounts": 50,
          "onlineAccounts": 45,
          "todayMessages": 5000,
          "queuedTasks": 100
        }
      }
    }

  # 获取性能指标
  GET /api/v1/monitoring/metrics
  Authorization: Bearer {accessToken}
  
  查询参数:
    - startTime: 开始时间 (ISO 8601格式)
    - endTime: 结束时间
    - interval: 时间间隔 (5m|15m|1h|6h|1d)
    - metrics: 指标名称 (cpu|memory|disk|network|api_requests)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "timeRange": {
          "startTime": "2024-01-01T08:00:00Z",
          "endTime": "2024-01-01T10:00:00Z",
          "interval": "5m"
        },
        "metrics": {
          "cpu": [
            {
              "timestamp": "2024-01-01T08:00:00Z",
              "value": 45.2
            },
            {
              "timestamp": "2024-01-01T08:05:00Z",
              "value": 48.7
            }
          ],
          "memory": [
            {
              "timestamp": "2024-01-01T08:00:00Z",
              "value": 68.5
            }
          ],
          "api_requests": [
            {
              "timestamp": "2024-01-01T08:00:00Z",
              "value": 1000
            }
          ]
        }
      }
    }

  # 获取告警列表
  GET /api/v1/monitoring/alerts
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - level: 告警级别 (info|warning|error|critical)
    - status: 状态 (active|resolved|acknowledged)
    - startTime: 开始时间
    - endTime: 结束时间
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "alert-123",
          "title": "API响应时间过高",
          "message": "API平均响应时间超过1秒",
          "level": "warning",
          "status": "active",
          "source": "monitoring",
          "triggeredAt": "2024-01-01T10:00:00Z",
          "acknowledgedAt": null,
          "resolvedAt": null,
          "metadata": {
            "metric": "api_response_time",
            "value": 1200,
            "threshold": 1000,
            "instance": "api-server-01"
          }
        }
      ]
    }

  # 确认告警
  POST /api/v1/monitoring/alerts/{alertId}/acknowledge
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "comment": "已知晓，正在处理中"
    }
  
  响应:
    {
      "code": 200,
      "message": "确认成功",
      "data": {
        "alertId": "alert-123",
        "status": "acknowledged",
        "acknowledgedAt": "2024-01-01T10:05:00Z"
      }
    }

  # 解决告警
  POST /api/v1/monitoring/alerts/{alertId}/resolve
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "comment": "问题已解决，系统恢复正常"
    }
  
  响应:
    {
      "code": 200,
      "message": "解决成功",
      "data": {
        "alertId": "alert-123",
        "status": "resolved",
        "resolvedAt": "2024-01-01T10:15:00Z"
      }
    }
```

### 日志管理接口
```yaml
日志管理API:

  # 查询日志
  GET /api/v1/logs
  Authorization: Bearer {accessToken}
  
  查询参数:
    - startTime: 开始时间
    - endTime: 结束时间
    - level: 日志级别 (debug|info|warn|error|fatal)
    - service: 服务名称
    - keyword: 关键词搜索
    - page: 页码
    - pageSize: 每页数量 (最大1000)
    - sortOrder: 排序 (asc|desc)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "log-123",
          "timestamp": "2024-01-01T10:00:00.123Z",
          "level": "error",
          "service": "api-server",
          "instance": "api-server-01",
          "message": "Database connection failed",
          "metadata": {
            "traceId": "trace-123",
            "userId": "user-456",
            "requestId": "req-789",
            "error": {
              "type": "ConnectionError",
              "stack": "Error stack trace..."
            }
          }
        }
      ],
      "meta": {
        "total": 10000,
        "hasMore": true
      }
    }

  # 导出日志
  POST /api/v1/logs/export
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "startTime": "2024-01-01T00:00:00Z",
      "endTime": "2024-01-01T23:59:59Z",
      "level": "error",
      "service": "api-server",
      "format": "csv", // csv | json | xlsx
      "email": "admin@example.com" // 可选，导出完成后发送邮件
    }
  
  响应:
    {
      "code": 200,
      "message": "导出任务创建成功",
      "data": {
        "taskId": "export-task-123",
        "status": "processing",
        "estimatedTime": 300
      }
    }

  # 获取导出任务状态
  GET /api/v1/logs/export/{taskId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "taskId": "export-task-123",
        "status": "completed", // processing | completed | failed
        "progress": 100,
        "fileUrl": "https://cdn.example.com/exports/logs-20240101.csv",
        "fileSize": 1024000,
        "recordCount": 50000,
        "createdAt": "2024-01-01T10:00:00Z",
        "completedAt": "2024-01-01T10:05:00Z"
      }
    }
```

## 📈 数据分析API

### 统计分析接口
```yaml
统计分析API:

  # 获取概览统计
  GET /api/v1/analytics/overview
  Authorization: Bearer {accessToken}
  
  查询参数:
    - dateRange: 日期范围 (today|yesterday|last7days|last30days|custom)
    - startDate: 开始日期 (dateRange=custom时必填)
    - endDate: 结束日期 (dateRange=custom时必填)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "dateRange": {
          "startDate": "2024-01-01",
          "endDate": "2024-01-07"
        },
        "summary": {
          "totalMessages": 10000,
          "successMessages": 9500,
          "failedMessages": 500,
          "successRate": 95.0,
          "totalBroadcasts": 50,
          "activeBroadcasts": 5,
          "totalReceivers": 2000,
          "activeReceivers": 1800
        },
        "trends": {
          "messageGrowth": 15.5, // 相比上期增长百分比
          "successRateChange": -2.1,
          "receiverGrowth": 8.3
        }
      }
    }

  # 获取消息统计
  GET /api/v1/analytics/messages
  Authorization: Bearer {accessToken}
  
  查询参数:
    - dateRange: 日期范围
    - startDate: 开始日期
    - endDate: 结束日期
    - groupBy: 分组方式 (day|hour|messageType|instance|account)
    - instanceId: 实例ID过滤
    - accountId: 账号ID过滤
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "summary": {
          "totalMessages": 10000,
          "successMessages": 9500,
          "failedMessages": 500,
          "successRate": 95.0
        },
        "breakdown": {
          "byType": [
            {
              "type": "text",
              "count": 7000,
              "percentage": 70.0
            },
            {
              "type": "image",
              "count": 2000,
              "percentage": 20.0
            },
            {
              "type": "file",
              "count": 1000,
              "percentage": 10.0
            }
          ],
          "byInstance": [
            {
              "instanceId": "instance-123",
              "instanceName": "企微实例-01",
              "count": 6000,
              "successRate": 96.0
            }
          ],
          "byTime": [
            {
              "time": "2024-01-01",
              "count": 1500,
              "successCount": 1450,
              "failCount": 50
            }
          ]
        }
      }
    }

  # 获取用户活跃度分析
  GET /api/v1/analytics/user-activity
  Authorization: Bearer {accessToken}
  
  查询参数:
    - dateRange: 日期范围
    - startDate: 开始日期
    - endDate: 结束日期
    - instanceId: 实例ID过滤
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "summary": {
          "totalUsers": 100,
          "activeUsers": 85,
          "newUsers": 5,
          "churnedUsers": 3
        },
        "activityDistribution": [
          {
            "range": "1-10消息",
            "userCount": 20,
            "percentage": 20.0
          },
          {
            "range": "11-50消息",
            "userCount": 40,
            "percentage": 40.0
          },
          {
            "range": "51-100消息",
            "userCount": 25,
            "percentage": 25.0
          },
          {
            "range": "100+消息",
            "userCount": 15,
            "percentage": 15.0
          }
        ],
        "timeDistribution": [
          {
            "hour": 9,
            "messageCount": 500,
            "userCount": 30
          },
          {
            "hour": 10,
            "messageCount": 800,
            "userCount": 45
          }
        ]
      }
    }

  # 获取错误分析
  GET /api/v1/analytics/errors
  Authorization: Bearer {accessToken}
  
  查询参数:
    - dateRange: 日期范围
    - startDate: 开始日期
    - endDate: 结束日期
    - errorType: 错误类型过滤
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "summary": {
          "totalErrors": 500,
          "errorRate": 5.0,
          "criticalErrors": 50,
          "resolvedErrors": 450
        },
        "errorBreakdown": [
          {
            "type": "NETWORK_ERROR",
            "name": "网络连接错误",
            "count": 200,
            "percentage": 40.0,
            "trend": "decreasing"
          },
          {
            "type": "AUTH_ERROR",
            "name": "认证失败",
            "count": 150,
            "percentage": 30.0,
            "trend": "stable"
          },
          {
            "type": "RATE_LIMIT",
            "name": "频率限制",
            "count": 100,
            "percentage": 20.0,
            "trend": "increasing"
          },
          {
            "type": "UNKNOWN_ERROR",
            "name": "未知错误",
            "count": 50,
            "percentage": 10.0,
            "trend": "stable"
          }
        ],
        "timeline": [
          {
            "time": "2024-01-01T00:00:00Z",
            "errorCount": 25,
            "errorRate": 5.2
          }
        ]
      }
    }

  # 生成分析报告
  POST /api/v1/analytics/reports
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "type": "monthly", // daily | weekly | monthly | custom
      "dateRange": {
        "startDate": "2024-01-01",
        "endDate": "2024-01-31"
      },
      "modules": ["overview", "messages", "users", "errors"],
      "format": "pdf", // pdf | excel | json
      "email": "manager@example.com",
      "includeCharts": true
    }
  
  响应:
    {
      "code": 200,
      "message": "报告生成任务创建成功",
      "data": {
        "reportId": "report-123",
        "status": "generating",
        "estimatedTime": 300
      }
    }

  # 获取报告状态
  GET /api/v1/analytics/reports/{reportId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "reportId": "report-123",
        "type": "monthly",
        "status": "completed", // generating | completed | failed
        "progress": 100,
        "fileUrl": "https://cdn.example.com/reports/monthly-report-202401.pdf",
        "fileSize": 2048000,
        "createdAt": "2024-01-01T10:00:00Z",
        "completedAt": "2024-01-01T10:05:00Z"
      }
    }
```

## 🔧 系统管理API

### 用户管理接口
```yaml
用户管理API:

  # 获取用户列表
  GET /api/v1/users
  Authorization: Bearer {accessToken}
  
  查询参数:
    - page: 页码
    - pageSize: 每页数量
    - status: 状态过滤 (active|inactive|banned)
    - role: 角色过滤
    - keyword: 关键词搜索
    - sortBy: 排序字段 (createdAt|lastLoginTime|username)
    - sortOrder: 排序方向 (asc|desc)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "user-123",
          "username": "admin",
          "email": "admin@example.com",
          "nickname": "系统管理员",
          "avatar": "https://avatar.url/admin.jpg",
          "status": "active",
          "roles": ["admin"],
          "permissions": ["user:read", "user:write", "system:config"],
          "lastLoginTime": "2024-01-01T10:00:00Z",
          "lastLoginIp": "192.168.1.100",
          "createdAt": "2024-01-01T08:00:00Z"
        }
      ]
    }

  # 创建用户
  POST /api/v1/users
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "username": "newuser",
      "email": "newuser@example.com",
      "nickname": "新用户",
      "password": "password123",
      "roles": ["operator"],
      "status": "active"
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "id": "user-124",
        "username": "newuser",
        "email": "newuser@example.com",
        "nickname": "新用户",
        "status": "active",
        "roles": ["operator"]
      }
    }

  # 更新用户
  PUT /api/v1/users/{userId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "nickname": "更新后的昵称",
      "email": "updated@example.com",
      "roles": ["operator", "viewer"],
      "status": "active"
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功"
    }

  # 重置用户密码
  POST /api/v1/users/{userId}/reset-password
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "newPassword": "newpassword123",
      "sendEmail": true
    }
  
  响应:
    {
      "code": 200,
      "message": "密码重置成功"
    }

  # 禁用用户
  POST /api/v1/users/{userId}/disable
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "reason": "违规操作"
    }
  
  响应:
    {
      "code": 200,
      "message": "禁用成功"
    }

  # 启用用户
  POST /api/v1/users/{userId}/enable
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "启用成功"
    }

  # 删除用户
  DELETE /api/v1/users/{userId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

### 角色权限管理接口
```yaml
角色权限API:

  # 获取角色列表
  GET /api/v1/roles
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "id": "role-123",
          "name": "admin",
          "displayName": "系统管理员",
          "description": "拥有所有权限的超级管理员",
          "permissions": [
            "user:read", "user:write", "user:delete",
            "system:config", "system:monitor"
          ],
          "userCount": 2,
          "createdAt": "2024-01-01T08:00:00Z"
        },
        {
          "id": "role-124",
          "name": "operator",
          "displayName": "操作员",
          "description": "负责日常操作的工作人员",
          "permissions": [
            "instance:read", "instance:write",
            "message:send", "contact:read"
          ],
          "userCount": 5,
          "createdAt": "2024-01-01T08:00:00Z"
        }
      ]
    }

  # 创建角色
  POST /api/v1/roles
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "name": "viewer",
      "displayName": "查看者",
      "description": "只能查看数据，不能修改",
      "permissions": [
        "instance:read",
        "message:read",
        "contact:read",
        "analytics:read"
      ]
    }
  
  响应:
    {
      "code": 201,
      "message": "创建成功",
      "data": {
        "id": "role-125",
        "name": "viewer",
        "displayName": "查看者"
      }
    }

  # 获取所有权限列表
  GET /api/v1/permissions
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": [
        {
          "module": "用户管理",
          "permissions": [
            {
              "key": "user:read",
              "name": "查看用户",
              "description": "查看用户列表和详情"
            },
            {
              "key": "user:write",
              "name": "编辑用户",
              "description": "创建和修改用户信息"
            },
            {
              "key": "user:delete",
              "name": "删除用户",
              "description": "删除用户账号"
            }
          ]
        },
        {
          "module": "实例管理",
          "permissions": [
            {
              "key": "instance:read",
              "name": "查看实例",
              "description": "查看实例列表和状态"
            },
            {
              "key": "instance:write",
              "name": "管理实例",
              "description": "创建、启动、停止实例"
            }
          ]
        }
      ]
    }

  # 更新角色权限
  PUT /api/v1/roles/{roleId}
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "displayName": "高级操作员",
      "description": "拥有更多权限的操作员",
      "permissions": [
        "instance:read", "instance:write",
        "message:send", "message:read",
        "contact:read", "contact:write"
      ]
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功"
    }

  # 删除角色
  DELETE /api/v1/roles/{roleId}
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 204,
      "message": "删除成功"
    }
```

### 系统配置接口
```yaml
系统配置API:

  # 获取系统配置
  GET /api/v1/system/config
  Authorization: Bearer {accessToken}
  
  查询参数:
    - category: 配置分类 (basic|security|notification|integration)
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "basic": {
          "siteName": "WeWork管理平台",
          "siteDescription": "企业微信管理系统",
          "timezone": "Asia/Shanghai",
          "language": "zh-CN",
          "dateFormat": "YYYY-MM-DD",
          "timeFormat": "HH:mm:ss"
        },
        "security": {
          "passwordMinLength": 8,
          "passwordRequireSpecial": true,
          "sessionTimeout": 3600,
          "maxLoginAttempts": 5,
          "lockoutDuration": 1800,
          "enableTwoFactor": false
        },
        "notification": {
          "emailEnabled": true,
          "smtpHost": "smtp.example.com",
          "smtpPort": 587,
          "smtpUser": "noreply@example.com",
          "webhookEnabled": true,
          "webhookUrl": "https://webhook.example.com/alerts"
        }
      }
    }

  # 更新系统配置
  PUT /api/v1/system/config
  Authorization: Bearer {accessToken}
  Content-Type: application/json
  
  请求体:
    {
      "basic": {
        "siteName": "新的站点名称",
        "timezone": "Asia/Shanghai"
      },
      "security": {
        "sessionTimeout": 7200,
        "enableTwoFactor": true
      }
    }
  
  响应:
    {
      "code": 200,
      "message": "更新成功"
    }

  # 获取系统信息
  GET /api/v1/system/info
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "获取成功",
      "data": {
        "version": "1.0.0",
        "buildTime": "2024-01-01T00:00:00Z",
        "environment": "production",
        "uptime": 86400,
        "serverTime": "2024-01-01T10:00:00Z",
        "database": {
          "type": "MySQL",
          "version": "8.0.25",
          "status": "connected"
        },
        "cache": {
          "type": "Redis",
          "version": "6.2.0",
          "status": "connected"
        },
        "storage": {
          "diskUsage": "45%",
          "availableSpace": "100GB"
        }
      }
    }

  # 系统健康检查
  GET /api/v1/system/health
  Authorization: Bearer {accessToken}
  
  响应:
    {
      "code": 200,
      "message": "系统健康",
      "data": {
        "status": "healthy", // healthy | warning | critical
        "checks": [
          {
            "name": "database",
            "status": "healthy",
            "responseTime": 5,
            "message": "数据库连接正常"
          },
          {
            "name": "cache",
            "status": "healthy",
            "responseTime": 1,
            "message": "缓存服务正常"
          },
          {
            "name": "disk_space",
            "status": "warning",
            "value": 85,
            "threshold": 80,
            "message": "磁盘使用率较高"
          }
        ],
        "timestamp": "2024-01-01T10:00:00Z"
      }
    }
```

## 🧪 测试用例设计

### 接口测试用例
```yaml
测试用例示例:

  认证接口测试:
    - 用例名称: 用户登录成功
      请求方法: POST
      请求地址: /api/v1/auth/login
      请求头: Content-Type: application/json
      请求体:
        {
          "username": "testuser",
          "password": "testpass123",
          "captcha": "abcd",
          "captchaToken": "test-token"
        }
      期望结果:
        状态码: 200
        响应体包含: accessToken, refreshToken, user
      验证点:
        - 响应状态码为200
        - 返回的token格式正确
        - 用户信息包含必要字段

    - 用例名称: 用户登录失败-密码错误
      请求方法: POST
      请求地址: /api/v1/auth/login
      请求体:
        {
          "username": "testuser",
          "password": "wrongpass",
          "captcha": "abcd",
          "captchaToken": "test-token"
        }
      期望结果:
        状态码: 401
        错误信息: 用户名或密码错误

  实例管理测试:
    - 用例名称: 创建实例成功
      前置条件: 用户已登录，具有instance:write权限
      请求方法: POST
      请求地址: /api/v1/instances
      请求头: 
        - Content-Type: application/json
        - Authorization: Bearer {validToken}
      请求体:
        {
          "name": "测试实例",
          "description": "API测试创建的实例"
        }
      期望结果:
        状态码: 201
        响应体包含: id, name, status
      后置操作: 删除创建的测试实例

    - 用例名称: 创建实例失败-无权限
      前置条件: 用户已登录，但无instance:write权限
      请求方法: POST
      请求地址: /api/v1/instances
      请求头: 
        - Authorization: Bearer {limitedToken}
      期望结果:
        状态码: 403
        错误信息: 权限不足

  消息发送测试:
    - 用例名称: 发送文本消息成功
      前置条件: 
        - 实例在线
        - 账号已登录
        - 存在有效接收者
      请求方法: POST
      请求地址: /api/v1/instances/{instanceId}/accounts/{accountId}/messages/text
      请求体:
        {
          "receivers": [
            {
              "type": "contact",
              "wxid": "test_receiver"
            }
          ],
          "content": "这是一条测试消息"
        }
      期望结果:
        状态码: 200
        响应体包含: taskId, status
      验证点:
        - 任务ID有效
        - 状态为queued
```

### 性能测试用例
```yaml
性能测试场景:

  压力测试:
    - 场景: 登录接口并发测试
      并发用户: 100
      持续时间: 60秒
      期望TPS: ≥ 50
      期望响应时间: ≤ 500ms
      期望成功率: ≥ 99%

    - 场景: 消息发送接口负载测试
      并发用户: 50
      消息数量: 1000条/用户
      期望处理速度: ≥ 100条/秒
      期望错误率: ≤ 1%

  稳定性测试:
    - 场景: 长时间运行测试
      运行时间: 24小时
      并发用户: 20
      操作频率: 每分钟10次请求
      监控指标: 内存泄漏、连接数、响应时间

  边界测试:
    - 场景: 大文件上传测试
      文件大小: 100MB
      并发数: 5
      期望成功率: 100%
      期望传输速度: ≥ 1MB/s

    - 场景: 大量数据查询测试
      数据量: 100万条记录
      分页大小: 100条/页
      期望响应时间: ≤ 2秒
```

## 📖 接口文档规范

### 文档结构
```yaml
API文档规范:

  基础信息:
    - API名称和版本
    - 服务器地址
    - 认证方式
    - 通用错误码
    - 变更日志

  接口详情:
    - 接口描述
    - 请求方法和路径
    - 请求参数说明
    - 请求示例
    - 响应格式说明
    - 响应示例
    - 错误码说明

  数据模型:
    - 实体定义
    - 字段说明
    - 约束条件
    - 关联关系

  使用指南:
    - 快速开始
    - 认证流程
    - 最佳实践
    - 常见问题
```

### 自动化文档生成
```yaml
文档工具链:

  OpenAPI规范:
    - 使用OpenAPI 3.0标准
    - 代码注解自动生成
    - 交互式文档界面
    - 客户端SDK生成

  文档部署:
    - Swagger UI界面
    - 在线文档访问
    - 版本切换支持
    - 搜索功能

  更新机制:
    - CI/CD自动更新
    - 版本变更通知
    - 测试用例同步
    - 示例代码更新
```

---

## 📊 API设计总结

| 设计维度 | 核心内容 | 技术方案 | 预期效果 |
|---------|---------|---------|---------|
| 接口规范 | RESTful+统一响应格式 | HTTP标准+JSON | 易于理解和使用 |
| 认证安全 | OAuth2.0+JWT+权限控制 | 多层安全防护 | 安全可靠 |
| 性能优化 | 分页+缓存+限流 | 多种优化策略 | 高并发支持 |
| 文档质量 | OpenAPI+测试用例 | 自动化文档生成 | 开发效率提升 |

**API接口详细设计已完成，可以开始开发实施！** 🚀

这个API设计方案为您的WeWork管理平台提供了完整的接口解决方案，涵盖了所有业务模块的详细接口定义。接下来您可以根据这个设计开始API开发工作，并使用提供的测试用例进行接口验证。 