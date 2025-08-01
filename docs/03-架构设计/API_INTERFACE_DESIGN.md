# 🔌 API接口详细设计
*WeWork Management Platform - API Interface Design*

## 📖 目录

1. [设计概述](#设计概述)
2. [API规范](#api规范)
3. [认证授权](#认证授权)
4. [核心接口设计](#核心接口设计)
5. [数据传输对象](#数据传输对象)
6. [错误处理](#错误处理)
7. [API文档](#api文档)
8. [版本管理](#版本管理)

---

## 🎯 设计概述

### 设计原则
- **RESTful风格**: 使用标准HTTP方法和状态码
- **统一规范**: 统一的请求响应格式
- **版本控制**: 支持API版本演进
- **安全优先**: 完善的认证授权机制
- **性能优化**: 支持分页、过滤、排序

### 技术栈
```yaml
API框架:
  - Spring Boot 3.0
  - Spring WebMVC
  - Spring Security
  - Spring Validation

文档工具:
  - OpenAPI 3.0
  - Swagger UI
  - Redoc

测试工具:
  - JUnit 5
  - MockMvc
  - Testcontainers
```

---

## 📏 API规范

### URL设计规范

#### 1. 资源路径规范
```yaml
路径结构:
  - /api/v{version}/{service}/{resource}
  - /api/v{version}/{service}/{resource}/{id}
  - /api/v{version}/{service}/{resource}/{id}/{sub-resource}

示例:
  - GET /api/v1/accounts/wework-accounts           # 获取企微账号列表
  - GET /api/v1/accounts/wework-accounts/{id}      # 获取单个企微账号
  - POST /api/v1/accounts/wework-accounts          # 创建企微账号
  - PUT /api/v1/accounts/wework-accounts/{id}      # 更新企微账号
  - DELETE /api/v1/accounts/wework-accounts/{id}   # 删除企微账号
  - GET /api/v1/accounts/wework-accounts/{id}/conversations  # 获取账号会话列表

命名规则:
  - 使用小写字母和连字符
  - 资源名使用复数形式
  - 避免深层嵌套 (最多3层)
```

#### 2. HTTP方法规范
```yaml
GET:
  - 用途: 获取资源
  - 幂等: 是
  - 安全: 是
  - 请求体: 无

POST:
  - 用途: 创建资源
  - 幂等: 否
  - 安全: 否
  - 请求体: 有

PUT:
  - 用途: 完整更新资源
  - 幂等: 是
  - 安全: 否
  - 请求体: 有

PATCH:
  - 用途: 部分更新资源
  - 幂等: 是
  - 安全: 否
  - 请求体: 有

DELETE:
  - 用途: 删除资源
  - 幂等: 是
  - 安全: 否
  - 请求体: 无
```

#### 3. 查询参数规范
```yaml
分页参数:
  - page: 页码 (从1开始)
  - size: 每页大小 (默认20，最大100)
  - cursor: 游标分页 (可选)

排序参数:
  - sort: 排序字段
  - order: 排序方向 (asc/desc)
  - 多字段排序: sort=name,asc&sort=createdAt,desc

过滤参数:
  - 精确匹配: field=value
  - 模糊匹配: field_like=value
  - 范围查询: field_gte=value, field_lte=value
  - 时间范围: startTime, endTime

字段选择:
  - fields: 指定返回字段
  - exclude: 排除特定字段

示例:
  GET /api/v1/accounts/wework-accounts?page=1&size=20&sort=createdAt,desc&status=online&name_like=test&fields=id,name,status
```

### 请求响应格式

#### 1. 统一响应格式
```json
{
  "code": 0,
  "message": "success",
  "data": {
    // 具体业务数据
  },
  "timestamp": "2025-01-01T12:00:00Z",
  "requestId": "req_123456789",
  "version": "v1"
}
```

#### 2. 分页响应格式
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "items": [
      // 数据列表
    ],
    "pagination": {
      "page": 1,
      "size": 20,
      "total": 100,
      "totalPages": 5,
      "hasNext": true,
      "hasPrevious": false,
      "cursor": "eyJpZCI6IjEyMyJ9"
    }
  },
  "timestamp": "2025-01-01T12:00:00Z"
}
```

#### 3. 错误响应格式
```json
{
  "code": 40001,
  "message": "参数验证失败",
  "details": [
    {
      "field": "accountName",
      "message": "账号名称不能为空",
      "code": "NotBlank"
    }
  ],
  "timestamp": "2025-01-01T12:00:00Z",
  "requestId": "req_123456789",
  "path": "/api/v1/accounts/wework-accounts"
}
```

---

## 🔐 认证授权

### JWT认证实现

#### 1. Token结构
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user_123",
    "tenant_id": "tenant_456", 
    "username": "admin",
    "roles": ["ADMIN", "OPERATOR"],
    "permissions": ["account:read", "account:write", "message:send"],
    "iat": 1640995200,
    "exp": 1641081600,
    "jti": "jwt_789"
  },
  "signature": "..."
}
```

#### 2. 认证流程
```java
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody @Valid LoginRequest request) {
        // 1. 验证用户名密码
        User user = userService.authenticate(request.getUsername(), request.getPassword());
        
        // 2. 生成JWT Token
        String accessToken = jwtService.generateAccessToken(user);
        String refreshToken = jwtService.generateRefreshToken(user);
        
        // 3. 返回认证结果
        LoginResponse response = LoginResponse.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .tokenType("Bearer")
            .expiresIn(7200)
            .user(UserDTO.from(user))
            .build();
            
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/refresh")
    public ResponseEntity<RefreshTokenResponse> refreshToken(
        @RequestBody @Valid RefreshTokenRequest request) {
        
        // 1. 验证Refresh Token
        Claims claims = jwtService.validateRefreshToken(request.getRefreshToken());
        
        // 2. 生成新的Access Token
        String newAccessToken = jwtService.generateAccessToken(claims);
        
        RefreshTokenResponse response = RefreshTokenResponse.builder()
            .accessToken(newAccessToken)
            .tokenType("Bearer")
            .expiresIn(7200)
            .build();
            
        return ResponseEntity.ok(response);
    }
}
```

#### 3. 权限控制注解
```java
// 方法级权限控制
@RestController
@RequestMapping("/api/v1/accounts")
@PreAuthorize("hasRole('ADMIN') or hasRole('OPERATOR')")
public class AccountController {
    
    @GetMapping
    @PreAuthorize("hasPermission('account', 'read')")
    public ResponseEntity<PageResponse<AccountDTO>> getAccounts(
        @RequestParam(defaultValue = "1") int page,
        @RequestParam(defaultValue = "20") int size) {
        // 获取账号列表
    }
    
    @PostMapping
    @PreAuthorize("hasPermission('account', 'write')")
    public ResponseEntity<AccountDTO> createAccount(@RequestBody @Valid CreateAccountRequest request) {
        // 创建账号
    }
    
    @DeleteMapping("/{accountId}")
    @PreAuthorize("hasPermission(#accountId, 'account', 'delete')")
    public ResponseEntity<Void> deleteAccount(@PathVariable String accountId) {
        // 删除账号
    }
}

// 自定义权限评估器
@Component
public class CustomPermissionEvaluator implements PermissionEvaluator {
    
    @Override
    public boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission) {
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        String permissionStr = (String) permission;
        
        // 检查用户权限
        return principal.getPermissions().contains(permissionStr);
    }
    
    @Override
    public boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission) {
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        String resourceId = (String) targetId;
        String permissionStr = (String) permission;
        
        // 检查资源级权限
        return resourcePermissionService.hasPermission(
            principal.getUserId(), 
            targetType, 
            resourceId, 
            permissionStr
        );
    }
}
```

### API密钥认证 (第三方调用)

#### 1. API Key管理
```java
@Entity
@Table(name = "api_keys")
public class ApiKey {
    @Id
    private String id;
    private String tenantId;
    private String keyName;
    private String keyId;        // 公开的Key ID
    private String secretHash;   // 加密后的Secret
    private String[] scopes;     // 权限范围
    private LocalDateTime expiresAt;
    private boolean isActive;
    private int callCount;
    private int callLimit;
    private LocalDateTime lastUsedAt;
}

@RestController
@RequestMapping("/api/v1/api-keys")
@PreAuthorize("hasRole('ADMIN')")
public class ApiKeyController {
    
    @PostMapping
    public ResponseEntity<CreateApiKeyResponse> createApiKey(
        @RequestBody @Valid CreateApiKeyRequest request) {
        
        ApiKey apiKey = apiKeyService.createApiKey(request);
        
        // 只在创建时返回完整的Secret，后续无法查看
        CreateApiKeyResponse response = CreateApiKeyResponse.builder()
            .keyId(apiKey.getKeyId())
            .secret(apiKey.getSecret())  // 明文Secret，仅此一次
            .scopes(apiKey.getScopes())
            .expiresAt(apiKey.getExpiresAt())
            .build();
            
        return ResponseEntity.ok(response);
    }
}
```

#### 2. API Key认证Filter
```java
@Component
public class ApiKeyAuthenticationFilter extends OncePerRequestFilter {
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
            FilterChain filterChain) throws ServletException, IOException {
        
        String apiKeyId = request.getHeader("X-API-Key-ID");
        String apiSecret = request.getHeader("X-API-Secret");
        String timestamp = request.getHeader("X-Timestamp");
        String signature = request.getHeader("X-Signature");
        
        if (StringUtils.hasText(apiKeyId) && StringUtils.hasText(signature)) {
            try {
                // 1. 验证时间戳 (防重放攻击)
                if (!isValidTimestamp(timestamp)) {
                    throw new AuthenticationException("请求时间戳无效");
                }
                
                // 2. 获取API Key信息
                ApiKey apiKey = apiKeyService.getByKeyId(apiKeyId);
                if (apiKey == null || !apiKey.isActive()) {
                    throw new AuthenticationException("API Key无效");
                }
                
                // 3. 验证签名
                String expectedSignature = calculateSignature(request, apiKey.getSecret(), timestamp);
                if (!signature.equals(expectedSignature)) {
                    throw new AuthenticationException("签名验证失败");
                }
                
                // 4. 检查调用限制
                if (apiKey.getCallCount() >= apiKey.getCallLimit()) {
                    throw new AuthenticationException("API调用次数超限");
                }
                
                // 5. 设置认证上下文
                ApiKeyAuthentication auth = new ApiKeyAuthentication(apiKey);
                SecurityContextHolder.getContext().setAuthentication(auth);
                
                // 6. 更新使用统计
                apiKeyService.updateUsageStats(apiKey.getId());
                
            } catch (AuthenticationException e) {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.getWriter().write("{\"code\":40101,\"message\":\"" + e.getMessage() + "\"}");
                return;
            }
        }
        
        filterChain.doFilter(request, response);
    }
    
    private String calculateSignature(HttpServletRequest request, String secret, String timestamp) {
        String method = request.getMethod();
        String path = request.getRequestURI();
        String query = request.getQueryString();
        String body = getRequestBody(request);
        
        String stringToSign = method + "\n" + path + "\n" + 
                             (query != null ? query : "") + "\n" + 
                             body + "\n" + timestamp;
                             
        return HmacUtils.hmacSha256Hex(secret, stringToSign);
    }
}
```

---

## 🏢 核心接口设计

### 1. 用户管理接口

#### 1.1 用户认证接口
```java
@RestController
@RequestMapping("/api/v1/auth")
@Validated
public class AuthController {
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    @Operation(summary = "用户登录", description = "通过用户名密码进行登录认证")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "登录成功"),
        @ApiResponse(responseCode = "401", description = "用户名或密码错误"),
        @ApiResponse(responseCode = "423", description = "账号已被锁定")
    })
    public ResponseEntity<ApiResponse<LoginResponse>> login(
            @RequestBody @Valid LoginRequest request) {
        
        LoginResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 用户登出
     */
    @PostMapping("/logout")
    @Operation(summary = "用户登出", description = "退出当前登录会话")
    public ResponseEntity<ApiResponse<Void>> logout(
            @RequestHeader("Authorization") String token) {
        
        authService.logout(token);
        return ResponseEntity.ok(ApiResponse.success());
    }
    
    /**
     * 刷新Token
     */
    @PostMapping("/refresh")
    @Operation(summary = "刷新访问令牌", description = "使用刷新令牌获取新的访问令牌")
    public ResponseEntity<ApiResponse<RefreshTokenResponse>> refreshToken(
            @RequestBody @Valid RefreshTokenRequest request) {
        
        RefreshTokenResponse response = authService.refreshToken(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}

// 请求响应DTO
@Data
@Builder
@Schema(description = "登录请求")
public class LoginRequest {
    
    @NotBlank(message = "用户名不能为空")
    @Size(max = 50, message = "用户名长度不能超过50字符")
    @Schema(description = "用户名", example = "admin")
    private String username;
    
    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度必须在6-20字符之间")
    @Schema(description = "密码", example = "123456")
    private String password;
    
    @Schema(description = "验证码", example = "1234")
    private String captcha;
    
    @Schema(description = "验证码Token", example = "captcha_token_123")
    private String captchaToken;
    
    @Schema(description = "是否记住登录", example = "false")
    private Boolean rememberMe = false;
}

@Data
@Builder
@Schema(description = "登录响应")
public class LoginResponse {
    
    @Schema(description = "访问令牌")
    private String accessToken;
    
    @Schema(description = "刷新令牌")
    private String refreshToken;
    
    @Schema(description = "令牌类型", example = "Bearer")
    private String tokenType;
    
    @Schema(description = "过期时间(秒)", example = "7200")
    private Long expiresIn;
    
    @Schema(description = "用户信息")
    private UserDTO user;
    
    @Schema(description = "权限列表")
    private List<String> permissions;
}
```

#### 1.2 用户管理接口
```java
@RestController
@RequestMapping("/api/v1/users")
@PreAuthorize("hasRole('ADMIN')")
@Validated
public class UserController {
    
    /**
     * 获取用户列表
     */
    @GetMapping
    @Operation(summary = "获取用户列表", description = "分页查询用户信息")
    @PreAuthorize("hasPermission('user', 'read')")
    public ResponseEntity<ApiResponse<PageResponse<UserDTO>>> getUsers(
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) UserStatus status,
            @RequestParam(required = false) String roleId,
            @RequestParam(defaultValue = "createdAt") String sort,
            @RequestParam(defaultValue = "desc") SortDirection order) {
        
        UserQueryRequest queryRequest = UserQueryRequest.builder()
            .page(page)
            .size(size)
            .keyword(keyword)
            .status(status)
            .roleId(roleId)
            .sort(sort)
            .order(order)
            .build();
            
        PageResponse<UserDTO> response = userService.getUsers(queryRequest);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 获取用户详情
     */
    @GetMapping("/{userId}")
    @Operation(summary = "获取用户详情", description = "根据用户ID获取详细信息")
    @PreAuthorize("hasPermission(#userId, 'user', 'read')")
    public ResponseEntity<ApiResponse<UserDetailDTO>> getUser(
            @PathVariable @NotBlank String userId) {
        
        UserDetailDTO user = userService.getUserDetail(userId);
        return ResponseEntity.ok(ApiResponse.success(user));
    }
    
    /**
     * 创建用户
     */
    @PostMapping
    @Operation(summary = "创建用户", description = "创建新的用户账号")
    @PreAuthorize("hasPermission('user', 'write')")
    public ResponseEntity<ApiResponse<UserDTO>> createUser(
            @RequestBody @Valid CreateUserRequest request) {
        
        UserDTO user = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(user));
    }
    
    /**
     * 更新用户
     */
    @PutMapping("/{userId}")
    @Operation(summary = "更新用户", description = "更新用户基本信息")
    @PreAuthorize("hasPermission(#userId, 'user', 'write')")
    public ResponseEntity<ApiResponse<UserDTO>> updateUser(
            @PathVariable @NotBlank String userId,
            @RequestBody @Valid UpdateUserRequest request) {
        
        UserDTO user = userService.updateUser(userId, request);
        return ResponseEntity.ok(ApiResponse.success(user));
    }
    
    /**
     * 删除用户
     */
    @DeleteMapping("/{userId}")
    @Operation(summary = "删除用户", description = "软删除用户账号")
    @PreAuthorize("hasPermission(#userId, 'user', 'delete')")
    public ResponseEntity<ApiResponse<Void>> deleteUser(
            @PathVariable @NotBlank String userId) {
        
        userService.deleteUser(userId);
        return ResponseEntity.ok(ApiResponse.success());
    }
    
    /**
     * 重置密码
     */
    @PostMapping("/{userId}/reset-password")
    @Operation(summary = "重置用户密码", description = "管理员重置用户密码")
    @PreAuthorize("hasPermission(#userId, 'user', 'reset-password')")
    public ResponseEntity<ApiResponse<ResetPasswordResponse>> resetPassword(
            @PathVariable @NotBlank String userId,
            @RequestBody @Valid ResetPasswordRequest request) {
        
        ResetPasswordResponse response = userService.resetPassword(userId, request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
```

### 2. 企微账号管理接口

#### 2.1 账号CRUD接口
```java
@RestController
@RequestMapping("/api/v1/accounts/wework-accounts")
@PreAuthorize("hasRole('ADMIN') or hasRole('OPERATOR')")
@Validated
public class WeWorkAccountController {
    
    /**
     * 获取企微账号列表
     */
    @GetMapping
    @Operation(summary = "获取企微账号列表", description = "分页查询企微账号信息")
    @PreAuthorize("hasPermission('account', 'read')")
    public ResponseEntity<ApiResponse<PageResponse<WeWorkAccountDTO>>> getAccounts(
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) AccountStatus status,
            @RequestParam(required = false) String userId,
            @RequestParam(defaultValue = "createdAt") String sort,
            @RequestParam(defaultValue = "desc") SortDirection order) {
        
        AccountQueryRequest queryRequest = AccountQueryRequest.builder()
            .page(page).size(size).keyword(keyword)
            .status(status).userId(userId)
            .sort(sort).order(order)
            .build();
            
        PageResponse<WeWorkAccountDTO> response = accountService.getAccounts(queryRequest);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 创建企微账号
     */
    @PostMapping
    @Operation(summary = "创建企微账号", description = "创建新的企微账号实例")
    @PreAuthorize("hasPermission('account', 'write')")
    public ResponseEntity<ApiResponse<WeWorkAccountDTO>> createAccount(
            @RequestBody @Valid CreateAccountRequest request) {
        
        WeWorkAccountDTO account = accountService.createAccount(request);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(account));
    }
    
    /**
     * 启动账号登录
     */
    @PostMapping("/{accountId}/login")
    @Operation(summary = "启动账号登录", description = "启动企微账号登录流程")
    @PreAuthorize("hasPermission(#accountId, 'account', 'login')")
    public ResponseEntity<ApiResponse<LoginQRCodeResponse>> startLogin(
            @PathVariable @NotBlank String accountId) {
        
        LoginQRCodeResponse response = accountService.startLogin(accountId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 获取账号状态
     */
    @GetMapping("/{accountId}/status")
    @Operation(summary = "获取账号状态", description = "获取企微账号当前状态")
    @PreAuthorize("hasPermission(#accountId, 'account', 'read')")
    public ResponseEntity<ApiResponse<AccountStatusResponse>> getAccountStatus(
            @PathVariable @NotBlank String accountId) {
        
        AccountStatusResponse response = accountService.getAccountStatus(accountId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 获取会话列表
     */
    @GetMapping("/{accountId}/conversations")
    @Operation(summary = "获取会话列表", description = "获取企微账号的会话列表")
    @PreAuthorize("hasPermission(#accountId, 'account', 'read')")
    public ResponseEntity<ApiResponse<PageResponse<ConversationDTO>>> getConversations(
            @PathVariable @NotBlank String accountId,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "50") @Min(1) @Max(100) int size,
            @RequestParam(required = false) ConversationType type,
            @RequestParam(required = false) String keyword) {
        
        ConversationQueryRequest queryRequest = ConversationQueryRequest.builder()
            .accountId(accountId)
            .page(page).size(size)
            .type(type).keyword(keyword)
            .build();
            
        PageResponse<ConversationDTO> response = conversationService.getConversations(queryRequest);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}

// 请求响应DTO
@Data
@Builder
@Schema(description = "创建账号请求")
public class CreateAccountRequest {
    
    @NotBlank(message = "账号名称不能为空")
    @Size(max = 100, message = "账号名称长度不能超过100字符")
    @Schema(description = "账号名称", example = "客服账号01")
    private String accountName;
    
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    @Schema(description = "绑定手机号", example = "13800138000")
    private String phone;
    
    @Email(message = "邮箱格式不正确")
    @Schema(description = "绑定邮箱", example = "user@example.com")
    private String email;
    
    @Schema(description = "绑定用户ID")
    private String userId;
    
    @Schema(description = "账号配置")
    private AccountConfigDTO config;
    
    @Schema(description = "标签列表")
    private List<String> tags;
}

@Data
@Builder
@Schema(description = "企微账号信息")
public class WeWorkAccountDTO {
    
    @Schema(description = "账号ID")
    private String id;
    
    @Schema(description = "租户ID")
    private String tenantId;
    
    @Schema(description = "账号名称")
    private String accountName;
    
    @Schema(description = "绑定手机号")
    private String phone;
    
    @Schema(description = "绑定邮箱")
    private String email;
    
    @Schema(description = "实例GUID")
    private String guid;
    
    @Schema(description = "账号状态")
    private AccountStatus status;
    
    @Schema(description = "用户信息")
    private WeWorkUserInfoDTO userInfo;
    
    @Schema(description = "最后登录时间")
    private LocalDateTime lastLoginTime;
    
    @Schema(description = "最后心跳时间")
    private LocalDateTime lastHeartbeatTime;
    
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;
}
```

### 3. 消息发送接口

#### 3.1 消息发送接口
```java
@RestController
@RequestMapping("/api/v1/messages")
@PreAuthorize("hasRole('OPERATOR') or hasRole('ADMIN')")
@Validated
public class MessageController {
    
    /**
     * 发送单条消息
     */
    @PostMapping("/send")
    @Operation(summary = "发送单条消息", description = "向指定会话发送单条消息")
    @PreAuthorize("hasPermission('message', 'send')")
    public ResponseEntity<ApiResponse<SendMessageResponse>> sendMessage(
            @RequestBody @Valid SendMessageRequest request) {
        
        SendMessageResponse response = messageService.sendMessage(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 批量发送消息
     */
    @PostMapping("/batch-send")
    @Operation(summary = "批量发送消息", description = "批量发送消息到多个会话")
    @PreAuthorize("hasPermission('message', 'batch-send')")
    public ResponseEntity<ApiResponse<BatchSendResponse>> batchSendMessage(
            @RequestBody @Valid BatchSendRequest request) {
        
        BatchSendResponse response = messageService.batchSendMessage(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 获取消息状态
     */
    @GetMapping("/{messageId}/status")
    @Operation(summary = "获取消息状态", description = "查询消息发送状态")
    @PreAuthorize("hasPermission(#messageId, 'message', 'read')")
    public ResponseEntity<ApiResponse<MessageStatusResponse>> getMessageStatus(
            @PathVariable @NotBlank String messageId) {
        
        MessageStatusResponse response = messageService.getMessageStatus(messageId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 获取消息列表
     */
    @GetMapping
    @Operation(summary = "获取消息列表", description = "分页查询消息记录")
    @PreAuthorize("hasPermission('message', 'read')")
    public ResponseEntity<ApiResponse<PageResponse<MessageDTO>>> getMessages(
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size,
            @RequestParam(required = false) String accountId,
            @RequestParam(required = false) String conversationId,
            @RequestParam(required = false) MessageType messageType,
            @RequestParam(required = false) MessageStatus status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        
        MessageQueryRequest queryRequest = MessageQueryRequest.builder()
            .page(page).size(size)
            .accountId(accountId).conversationId(conversationId)
            .messageType(messageType).status(status)
            .startTime(startTime).endTime(endTime)
            .build();
            
        PageResponse<MessageDTO> response = messageService.getMessages(queryRequest);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    /**
     * 取消消息发送
     */
    @PostMapping("/{messageId}/cancel")
    @Operation(summary = "取消消息发送", description = "取消待发送的消息")
    @PreAuthorize("hasPermission(#messageId, 'message', 'cancel')")
    public ResponseEntity<ApiResponse<Void>> cancelMessage(
            @PathVariable @NotBlank String messageId) {
        
        messageService.cancelMessage(messageId);
        return ResponseEntity.ok(ApiResponse.success());
    }
}

// 请求响应DTO
@Data
@Builder
@Schema(description = "发送消息请求")
public class SendMessageRequest {
    
    @NotBlank(message = "账号ID不能为空")
    @Schema(description = "发送账号ID", example = "account_123")
    private String accountId;
    
    @NotBlank(message = "会话ID不能为空")
    @Schema(description = "会话ID", example = "S:1688852792312821")
    private String conversationId;
    
    @NotNull(message = "消息类型不能为空")
    @Schema(description = "消息类型")
    private MessageType messageType;
    
    @NotNull(message = "消息内容不能为空")
    @Valid
    @Schema(description = "消息内容")
    private MessageContentDTO content;
    
    @Schema(description = "模板ID")
    private String templateId;
    
    @Schema(description = "模板变量")
    private Map<String, Object> templateVariables;
    
    @Schema(description = "优先级(1-10)", example = "5")
    @Min(value = 1, message = "优先级最小值为1")
    @Max(value = 10, message = "优先级最大值为10")
    private Integer priority = 5;
    
    @Schema(description = "计划发送时间")
    @Future(message = "计划发送时间必须是未来时间")
    private LocalDateTime scheduledTime;
    
    @Schema(description = "是否需要发送回执", example = "false")
    private Boolean needReceipt = false;
}

@Data
@Builder
@Schema(description = "消息内容")
public class MessageContentDTO {
    
    @Schema(description = "文本内容")
    private String text;
    
    @Schema(description = "图片URL列表")
    private List<String> imageUrls;
    
    @Schema(description = "文件URL")
    private String fileUrl;
    
    @Schema(description = "文件名")
    private String fileName;
    
    @Schema(description = "链接URL")
    private String linkUrl;
    
    @Schema(description = "链接标题")
    private String linkTitle;
    
    @Schema(description = "链接描述")
    private String linkDescription;
    
    @Schema(description = "@成员列表")
    private List<String> atList;
    
    @Schema(description = "是否@所有人")
    private Boolean atAll = false;
    
    @Schema(description = "小程序信息")
    private MiniProgramDTO miniProgram;
}
```

---

## 📦 数据传输对象

### 通用DTO基类

#### 1. 基础响应DTO
```java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "API响应基类")
public class ApiResponse<T> {
    
    @Schema(description = "响应码", example = "0")
    private Integer code;
    
    @Schema(description = "响应消息", example = "success")
    private String message;
    
    @Schema(description = "响应数据")
    private T data;
    
    @Schema(description = "时间戳", example = "2025-01-01T12:00:00Z")
    private String timestamp;
    
    @Schema(description = "请求ID", example = "req_123456789")
    private String requestId;
    
    @Schema(description = "API版本", example = "v1")
    private String version;
    
    public static <T> ApiResponse<T> success(T data) {
        return ApiResponse.<T>builder()
            .code(0)
            .message("success")
            .data(data)
            .timestamp(Instant.now().toString())
            .version("v1")
            .build();
    }
    
    public static <T> ApiResponse<T> success() {
        return success(null);
    }
    
    public static <T> ApiResponse<T> error(Integer code, String message) {
        return ApiResponse.<T>builder()
            .code(code)
            .message(message)
            .timestamp(Instant.now().toString())
            .version("v1")
            .build();
    }
}
```

#### 2. 分页响应DTO
```java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "分页响应")
public class PageResponse<T> {
    
    @Schema(description = "数据列表")
    private List<T> items;
    
    @Schema(description = "分页信息")
    private PaginationInfo pagination;
    
    @Data
    @Builder
    @Schema(description = "分页信息")
    public static class PaginationInfo {
        
        @Schema(description = "当前页码", example = "1")
        private Integer page;
        
        @Schema(description = "每页大小", example = "20")
        private Integer size;
        
        @Schema(description = "总记录数", example = "100")
        private Long total;
        
        @Schema(description = "总页数", example = "5")
        private Integer totalPages;
        
        @Schema(description = "是否有下一页", example = "true")
        private Boolean hasNext;
        
        @Schema(description = "是否有上一页", example = "false")
        private Boolean hasPrevious;
        
        @Schema(description = "游标(用于游标分页)", example = "eyJpZCI6IjEyMyJ9")
        private String cursor;
    }
    
    public static <T> PageResponse<T> of(List<T> items, long total, int page, int size) {
        int totalPages = (int) Math.ceil((double) total / size);
        
        PaginationInfo pagination = PaginationInfo.builder()
            .page(page)
            .size(size)
            .total(total)
            .totalPages(totalPages)
            .hasNext(page < totalPages)
            .hasPrevious(page > 1)
            .build();
            
        return PageResponse.<T>builder()
            .items(items)
            .pagination(pagination)
            .build();
    }
}
```

### 业务DTO定义

#### 1. 用户相关DTO
```java
@Data
@Builder
@Schema(description = "用户基本信息")
public class UserDTO {
    
    @Schema(description = "用户ID")
    private String id;
    
    @Schema(description = "用户名")
    private String username;
    
    @Schema(description = "邮箱")
    private String email;
    
    @Schema(description = "手机号")
    private String phone;
    
    @Schema(description = "真实姓名")
    private String realName;
    
    @Schema(description = "头像URL")
    private String avatarUrl;
    
    @Schema(description = "用户状态")
    private UserStatus status;
    
    @Schema(description = "角色列表")
    private List<RoleDTO> roles;
    
    @Schema(description = "最后登录时间")
    private LocalDateTime lastLoginTime;
    
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;
    
    public static UserDTO from(User user) {
        return UserDTO.builder()
            .id(user.getId())
            .username(user.getUsername())
            .email(user.getEmail())
            .phone(user.getPhone())
            .realName(user.getRealName())
            .avatarUrl(user.getAvatarUrl())
            .status(user.getStatus())
            .lastLoginTime(user.getLastLoginTime())
            .createdAt(user.getCreatedAt())
            .build();
    }
}

@Data
@Builder
@Schema(description = "用户详细信息")
public class UserDetailDTO extends UserDTO {
    
    @Schema(description = "部门信息")
    private DepartmentDTO department;
    
    @Schema(description = "权限列表")
    private List<String> permissions;
    
    @Schema(description = "登录历史")
    private List<LoginHistoryDTO> loginHistory;
    
    @Schema(description = "账号统计")
    private UserStatisticsDTO statistics;
}
```

#### 2. 账号相关DTO
```java
@Data
@Builder
@Schema(description = "企微账号配置")
public class AccountConfigDTO {
    
    @Schema(description = "自动回复是否开启")
    private Boolean autoReplyEnabled = false;
    
    @Schema(description = "自动回复内容")
    private String autoReplyContent;
    
    @Schema(description = "消息发送间隔(毫秒)")
    @Min(value = 1000, message = "发送间隔不能小于1秒")
    private Integer sendInterval = 3000;
    
    @Schema(description = "每日发送限制")
    @Min(value = 1, message = "每日发送限制不能小于1")
    private Integer dailyLimit = 1000;
    
    @Schema(description = "工作时间配置")
    private WorkTimeConfigDTO workTimeConfig;
    
    @Schema(description = "黑名单列表")
    private List<String> blacklist;
    
    @Schema(description = "是否启用消息去重")
    private Boolean deduplicationEnabled = true;
}

@Data
@Builder
@Schema(description = "企微用户信息")
public class WeWorkUserInfoDTO {
    
    @Schema(description = "用户ID")
    private String userId;
    
    @Schema(description = "用户名")
    private String userName;
    
    @Schema(description = "昵称")
    private String nickName;
    
    @Schema(description = "头像URL")
    private String avatarUrl;
    
    @Schema(description = "手机号")
    private String mobile;
    
    @Schema(description = "邮箱")
    private String email;
    
    @Schema(description = "部门列表")
    private List<String> departments;
    
    @Schema(description = "职位")
    private String position;
    
    @Schema(description = "企业信息")
    private EnterpriseInfoDTO enterprise;
}
```

---

## ❌ 错误处理

### 错误码设计

#### 1. 错误码分类
```yaml
错误码格式: XYZAB
  X: 错误级别 (1-9)
    1: 系统级错误
    2: 业务级错误  
    3: 客户端错误
    4: 认证授权错误
    5: 第三方服务错误
    
  Y: 服务模块 (0-9)
    0: 通用
    1: 用户服务
    2: 账号服务
    3: 消息服务
    4: 监控服务
    
  Z: 功能模块 (0-9)
    0: 通用
    1: 登录认证
    2: 权限控制
    3: 数据验证
    
  AB: 具体错误 (01-99)

示例错误码:
  - 10001: 系统内部错误
  - 20001: 业务逻辑错误
  - 30001: 请求参数错误
  - 40101: 用户名或密码错误
  - 40201: 账号不存在
  - 50301: 企微API调用失败
```

#### 2. 错误定义枚举
```java
@Getter
@AllArgsConstructor
public enum ErrorCode {
    
    // 系统级错误 (1xxxx)
    SYSTEM_ERROR(10001, "系统内部错误"),
    DATABASE_ERROR(10002, "数据库连接错误"),
    CACHE_ERROR(10003, "缓存服务错误"),
    MESSAGE_QUEUE_ERROR(10004, "消息队列错误"),
    
    // 业务级错误 (2xxxx)
    BUSINESS_ERROR(20001, "业务逻辑错误"),
    DATA_NOT_FOUND(20002, "数据不存在"),
    DATA_ALREADY_EXISTS(20003, "数据已存在"),
    OPERATION_NOT_ALLOWED(20004, "操作不被允许"),
    
    // 客户端错误 (3xxxx)
    INVALID_REQUEST(30001, "请求参数错误"),
    MISSING_PARAMETER(30002, "缺少必需参数"),
    INVALID_PARAMETER_FORMAT(30003, "参数格式错误"),
    PARAMETER_OUT_OF_RANGE(30004, "参数超出范围"),
    
    // 认证授权错误 (4xxxx)
    UNAUTHORIZED(40001, "未授权访问"),
    INVALID_TOKEN(40002, "无效的访问令牌"),
    TOKEN_EXPIRED(40003, "访问令牌已过期"),
    INSUFFICIENT_PERMISSIONS(40004, "权限不足"),
    
    // 用户相关错误 (41xxx)
    USER_NOT_FOUND(41001, "用户不存在"),
    INVALID_CREDENTIALS(41002, "用户名或密码错误"),
    USER_LOCKED(41003, "用户账号已被锁定"),
    PASSWORD_EXPIRED(41004, "密码已过期"),
    
    // 账号相关错误 (42xxx)
    ACCOUNT_NOT_FOUND(42001, "企微账号不存在"),
    ACCOUNT_NOT_ONLINE(42002, "企微账号未在线"),
    ACCOUNT_LOGIN_FAILED(42003, "企微账号登录失败"),
    ACCOUNT_LIMIT_EXCEEDED(42004, "账号数量超出限制"),
    
    // 消息相关错误 (43xxx)
    MESSAGE_SEND_FAILED(43001, "消息发送失败"),
    INVALID_CONVERSATION(43002, "无效的会话ID"),
    MESSAGE_CONTENT_TOO_LONG(43003, "消息内容过长"),
    DAILY_LIMIT_EXCEEDED(43004, "超出每日发送限制"),
    
    // 第三方服务错误 (5xxxx)
    EXTERNAL_SERVICE_ERROR(50001, "外部服务错误"),
    WEWORK_API_ERROR(50301, "企微API调用失败"),
    WEWORK_API_RATE_LIMIT(50302, "企微API调用频率超限"),
    WEWORK_API_TIMEOUT(50303, "企微API调用超时");
    
    private final Integer code;
    private final String message;
}
```

### 全局异常处理

#### 1. 异常处理器
```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    
    /**
     * 业务异常处理
     */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(
            BusinessException e, HttpServletRequest request) {
        
        log.warn("业务异常: {}, 请求路径: {}", e.getMessage(), request.getRequestURI());
        
        ApiResponse<Void> response = ApiResponse.<Void>builder()
            .code(e.getErrorCode().getCode())
            .message(e.getMessage())
            .timestamp(Instant.now().toString())
            .requestId(RequestContextHolder.getRequestId())
            .version("v1")
            .build();
            
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
    
    /**
     * 参数验证异常处理
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidationException(
            MethodArgumentNotValidException e, HttpServletRequest request) {
        
        List<ValidationError> errors = e.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> ValidationError.builder()
                .field(error.getField())
                .message(error.getDefaultMessage())
                .rejectedValue(error.getRejectedValue())
                .code(error.getCode())
                .build())
            .collect(Collectors.toList());
            
        log.warn("参数验证失败: {}, 请求路径: {}", errors, request.getRequestURI());
        
        ValidationErrorResponse errorResponse = ValidationErrorResponse.builder()
            .code(ErrorCode.INVALID_REQUEST.getCode())
            .message("参数验证失败")
            .details(errors)
            .timestamp(Instant.now().toString())
            .requestId(RequestContextHolder.getRequestId())
            .path(request.getRequestURI())
            .build();
            
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }
    
    /**
     * 认证异常处理
     */
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<Void>> handleAuthenticationException(
            AuthenticationException e, HttpServletRequest request) {
        
        log.warn("认证失败: {}, 请求路径: {}", e.getMessage(), request.getRequestURI());
        
        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.UNAUTHORIZED.getCode(),
            ErrorCode.UNAUTHORIZED.getMessage()
        );
        
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
    }
    
    /**
     * 权限异常处理
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Void>> handleAccessDeniedException(
            AccessDeniedException e, HttpServletRequest request) {
        
        log.warn("权限不足: {}, 请求路径: {}", e.getMessage(), request.getRequestURI());
        
        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.INSUFFICIENT_PERMISSIONS.getCode(),
            ErrorCode.INSUFFICIENT_PERMISSIONS.getMessage()
        );
        
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }
    
    /**
     * 系统异常处理
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleSystemException(
            Exception e, HttpServletRequest request) {
        
        log.error("系统异常: ", e);
        
        // 生产环境不暴露具体错误信息
        String message = "production".equals(environment) ? 
            ErrorCode.SYSTEM_ERROR.getMessage() : e.getMessage();
            
        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.SYSTEM_ERROR.getCode(),
            message
        );
        
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}

// 自定义业务异常
@Getter
public class BusinessException extends RuntimeException {
    
    private final ErrorCode errorCode;
    private final Object[] args;
    
    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.args = null;
    }
    
    public BusinessException(ErrorCode errorCode, Object... args) {
        super(String.format(errorCode.getMessage(), args));
        this.errorCode = errorCode;
        this.args = args;
    }
    
    public BusinessException(ErrorCode errorCode, Throwable cause) {
        super(errorCode.getMessage(), cause);
        this.errorCode = errorCode;
        this.args = null;
    }
}
```

#### 2. 参数验证
```java
// 自定义验证注解
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PhoneValidator.class)
@Documented
public @interface Phone {
    String message() default "手机号格式不正确";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

// 验证器实现
public class PhoneValidator implements ConstraintValidator<Phone, String> {
    
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^1[3-9]\\d{9}$");
    
    @Override
    public boolean isValid(String phone, ConstraintValidatorContext context) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // 空值由@NotBlank验证
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
}

// 分组验证
public interface CreateGroup {}
public interface UpdateGroup {}

@Data
public class UserRequest {
    
    @NotBlank(groups = CreateGroup.class, message = "用户名不能为空")
    @Size(max = 50, message = "用户名长度不能超过50字符")
    private String username;
    
    @NotBlank(groups = CreateGroup.class, message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度必须在6-20字符之间")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@$!%*?&]{6,20}$",
             message = "密码必须包含大小写字母和数字")
    private String password;
    
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @Phone(message = "手机号格式不正确")
    private String phone;
}

// 控制器中使用分组验证
@PostMapping
public ResponseEntity<ApiResponse<UserDTO>> createUser(
        @Validated(CreateGroup.class) @RequestBody UserRequest request) {
    // 创建用户逻辑
}

@PutMapping("/{userId}")
public ResponseEntity<ApiResponse<UserDTO>> updateUser(
        @PathVariable String userId,
        @Validated(UpdateGroup.class) @RequestBody UserRequest request) {
    // 更新用户逻辑
}
```

---

## 📚 API文档

### OpenAPI配置

#### 1. Swagger配置
```java
@Configuration
@EnableOpenApi
public class OpenApiConfig {
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("企业微信管理平台API")
                .description("提供企微账号管理、消息发送、数据分析等功能的RESTful API")
                .version("v1.0.0")
                .contact(new Contact()
                    .name("API支持")
                    .email("api-support@company.com")
                    .url("https://docs.company.com"))
                .license(new License()
                    .name("MIT License")
                    .url("https://opensource.org/licenses/MIT")))
            .servers(Arrays.asList(
                new Server()
                    .url("https://api.wework-platform.com")
                    .description("生产环境"),
                new Server()
                    .url("https://api-staging.wework-platform.com")
                    .description("测试环境"),
                new Server()
                    .url("http://localhost:8080")
                    .description("开发环境")))
            .components(new Components()
                .addSecuritySchemes("bearerAuth", new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
                    .description("JWT认证"))
                .addSecuritySchemes("apiKeyAuth", new SecurityScheme()
                    .type(SecurityScheme.Type.APIKEY)
                    .in(SecurityScheme.In.HEADER)
                    .name("X-API-Key")
                    .description("API密钥认证")))
            .addSecurityItem(new SecurityRequirement()
                .addList("bearerAuth"))
            .addSecurityItem(new SecurityRequirement()
                .addList("apiKeyAuth"));
    }
    
    @Bean
    public GroupedOpenApi userApi() {
        return GroupedOpenApi.builder()
            .group("用户管理")
            .pathsToMatch("/api/v1/auth/**", "/api/v1/users/**")
            .build();
    }
    
    @Bean
    public GroupedOpenApi accountApi() {
        return GroupedOpenApi.builder()
            .group("账号管理")
            .pathsToMatch("/api/v1/accounts/**")
            .build();
    }
    
    @Bean
    public GroupedOpenApi messageApi() {
        return GroupedOpenApi.builder()
            .group("消息管理")
            .pathsToMatch("/api/v1/messages/**", "/api/v1/templates/**")
            .build();
    }
}
```

#### 2. API文档增强
```java
// 控制器级别文档
@RestController
@RequestMapping("/api/v1/accounts")
@Tag(name = "企微账号管理", description = "企业微信账号的创建、登录、监控等操作")
@SecurityRequirement(name = "bearerAuth")
public class WeWorkAccountController {
    
    @GetMapping
    @Operation(
        summary = "获取企微账号列表",
        description = "分页查询当前租户下的企微账号列表，支持按状态、用户等条件过滤",
        tags = {"账号查询"}
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200",
            description = "查询成功",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = PageResponse.class),
                examples = @ExampleObject(
                    name = "账号列表示例",
                    value = """
                        {
                          "code": 0,
                          "message": "success",
                          "data": {
                            "items": [
                              {
                                "id": "account_123",
                                "accountName": "客服账号01",
                                "status": "online",
                                "lastLoginTime": "2025-01-01T12:00:00Z"
                              }
                            ],
                            "pagination": {
                              "page": 1,
                              "size": 20,
                              "total": 100,
                              "hasNext": true
                            }
                          }
                        }
                        """
                )
            )
        ),
        @ApiResponse(
            responseCode = "400",
            description = "请求参数错误",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ApiResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "401",
            description = "未授权访问",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ApiResponse.class)
            )
        )
    })
    @Parameters({
        @Parameter(
            name = "page",
            description = "页码，从1开始",
            example = "1",
            schema = @Schema(type = "integer", minimum = "1")
        ),
        @Parameter(
            name = "size",
            description = "每页大小，最大100",
            example = "20",
            schema = @Schema(type = "integer", minimum = "1", maximum = "100")
        ),
        @Parameter(
            name = "status",
            description = "账号状态过滤",
            schema = @Schema(implementation = AccountStatus.class)
        )
    })
    public ResponseEntity<ApiResponse<PageResponse<WeWorkAccountDTO>>> getAccounts(
            @Parameter(hidden = true) @RequestParam(defaultValue = "1") int page,
            @Parameter(hidden = true) @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) AccountStatus status) {
        // 实现逻辑
    }
}
```

### 接口测试

#### 1. 集成测试
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Testcontainers
class WeWorkAccountControllerIntegrationTest {
    
    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
            .withDatabaseName("test_db")
            .withUsername("test")
            .withPassword("test");
    
    @Container
    static GenericContainer<?> redis = new GenericContainer<>("redis:7")
            .withExposedPorts(6379);
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Autowired
    private WeWorkAccountRepository accountRepository;
    
    @Test
    @DisplayName("创建企微账号 - 成功")
    void createAccount_Success() {
        // Given
        CreateAccountRequest request = CreateAccountRequest.builder()
            .accountName("测试账号")
            .phone("13800138000")
            .email("test@example.com")
            .build();
        
        String token = getAuthToken();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        HttpEntity<CreateAccountRequest> entity = new HttpEntity<>(request, headers);
        
        // When
        ResponseEntity<ApiResponse<WeWorkAccountDTO>> response = restTemplate.exchange(
            "/api/v1/accounts/wework-accounts",
            HttpMethod.POST,
            entity,
            new ParameterizedTypeReference<>() {}
        );
        
        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody().getCode()).isEqualTo(0);
        assertThat(response.getBody().getData().getAccountName()).isEqualTo("测试账号");
        
        // 验证数据库
        Optional<WeWorkAccount> savedAccount = accountRepository.findByAccountName("测试账号");
        assertThat(savedAccount).isPresent();
    }
    
    @Test
    @DisplayName("创建企微账号 - 参数验证失败")
    void createAccount_ValidationFailed() {
        // Given
        CreateAccountRequest request = CreateAccountRequest.builder()
            .accountName("") // 空账号名
            .phone("invalid_phone") // 无效手机号
            .build();
        
        String token = getAuthToken();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        HttpEntity<CreateAccountRequest> entity = new HttpEntity<>(request, headers);
        
        // When
        ResponseEntity<ValidationErrorResponse> response = restTemplate.exchange(
            "/api/v1/accounts/wework-accounts",
            HttpMethod.POST,
            entity,
            ValidationErrorResponse.class
        );
        
        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody().getCode()).isEqualTo(30001);
        assertThat(response.getBody().getDetails()).hasSize(2);
    }
    
    private String getAuthToken() {
        LoginRequest loginRequest = LoginRequest.builder()
            .username("admin")
            .password("admin123")
            .build();
        
        ResponseEntity<ApiResponse<LoginResponse>> loginResponse = restTemplate.postForEntity(
            "/api/v1/auth/login",
            loginRequest,
            new ParameterizedTypeReference<>() {}
        );
        
        return loginResponse.getBody().getData().getAccessToken();
    }
}
```

---

## 🔄 版本管理

### API版本策略

#### 1. 版本管理方案
```yaml
版本管理策略:
  - URI版本控制: /api/v1/, /api/v2/
  - 语义化版本: v{major}.{minor}.{patch}
  - 向后兼容: 保持至少2个主版本
  - 弃用通知: 提前6个月通知废弃

版本发布周期:
  - 主版本: 1年 (破坏性变更)
  - 次版本: 3个月 (新功能)
  - 补丁版本: 2周 (Bug修复)

支持策略:
  - 当前版本: 完整支持
  - 前一版本: 安全更新
  - 更早版本: 不再支持
```

#### 2. 版本控制实现
```java
@RestController
@RequestMapping("/api/v1/accounts")
@ApiVersion("1.0")
public class WeWorkAccountControllerV1 {
    // V1版本实现
}

@RestController
@RequestMapping("/api/v2/accounts")
@ApiVersion("2.0")
public class WeWorkAccountControllerV2 {
    // V2版本实现
}

// 版本控制注解
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ApiVersion {
    String value();
    boolean deprecated() default false;
    String deprecatedSince() default "";
    String removedIn() default "";
}

// 版本信息拦截器
@Component
public class ApiVersionInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, 
            Object handler) throws Exception {
        
        if (handler instanceof HandlerMethod) {
            HandlerMethod method = (HandlerMethod) handler;
            ApiVersion apiVersion = method.getMethodAnnotation(ApiVersion.class);
            
            if (apiVersion == null) {
                apiVersion = method.getBeanType().getAnnotation(ApiVersion.class);
            }
            
            if (apiVersion != null && apiVersion.deprecated()) {
                response.setHeader("X-API-Deprecated", "true");
                response.setHeader("X-API-Deprecated-Since", apiVersion.deprecatedSince());
                response.setHeader("X-API-Removed-In", apiVersion.removedIn());
                
                String warning = String.format(
                    "299 - \"API version %s is deprecated since %s and will be removed in %s\"",
                    apiVersion.value(),
                    apiVersion.deprecatedSince(),
                    apiVersion.removedIn()
                );
                response.setHeader("Warning", warning);
            }
        }
        
        return true;
    }
}
```

---

## 📋 总结

### 设计特点
1. **RESTful规范**: 严格遵循REST设计原则
2. **统一响应**: 标准化的请求响应格式
3. **完善验证**: 多层次的参数验证机制
4. **安全认证**: JWT + API Key双重认证
5. **详细文档**: 完整的OpenAPI文档

### 技术亮点
- 🔐 **多重认证** JWT认证 + API密钥认证
- 📏 **规范统一** 统一的URL设计和响应格式
- ✅ **参数验证** 分组验证和自定义验证器
- 📚 **文档完善** OpenAPI 3.0 + Swagger UI
- 🔄 **版本管理** 语义化版本控制

### 下一步工作
1. 消息队列详细设计
2. 缓存架构详细设计
3. 安全架构详细设计
4. 监控系统详细设计

---

**文档状态**: Phase 1 - 已完成API接口详细设计  
**下一步**: 开始消息队列详细设计  
**负责人**: API设计团队 