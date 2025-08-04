# 📝 代码编写规范

## 📐 基础编码规范

### 1. 命名规范
```java
// ✅ 正确的命名规范

// 类名：大驼峰命名法(PascalCase)
public class WeWorkAccountService { }
public class MessageTemplateController { }
public class UserPermissionDTO { }

// 方法名、变量名：小驼峰命名法(camelCase)
public AccountDTO getAccountById(String accountId) { }
private boolean isAccountActive;
private List<MessageDTO> messageList;

// 常量：全大写+下划线
public static final String DEFAULT_STATUS = "ACTIVE";
public static final int MAX_RETRY_COUNT = 3;
private static final String CONFIG_PREFIX = "app.wework";

// 包名：全小写+点分隔
com.wework.platform.account.service
com.wework.platform.message.controller
com.wework.platform.common.utils

// ❌ 错误的命名
public class weworkAccountService { }        // 类名应该大驼峰
public void GetAccount() { }                 // 方法名应该小驼峰
private String account_name;                 // Java变量不使用下划线
public static final String defaultStatus;   // 常量应该全大写
```

**规则**:
- 类名使用名词，方法名使用动词
- 布尔类型变量以is/has/can等开头
- 集合类型变量以List/Map/Set结尾
- 避免使用中文拼音命名
- 禁止使用保留字和关键字

### 2. 代码格式规范
```java
// ✅ 正确的代码格式
@Service
@Slf4j
@RequiredArgsConstructor
public class AccountService {
    
    private final AccountMapper accountMapper;
    private final TenantService tenantService;
    private final MessageService messageService;
    
    /**
     * 创建企微账号
     * 
     * @param tenantId 租户ID
     * @param request 创建请求
     * @return 账号信息
     * @throws BusinessException 业务异常
     */
    @Transactional(rollbackFor = Exception.class)
    public AccountDTO createAccount(String tenantId, CreateAccountRequest request) {
        // 1. 参数验证
        validateCreateRequest(tenantId, request);
        
        // 2. 检查配额
        tenantService.checkAccountQuota(tenantId);
        
        // 3. 创建账号
        WeWorkAccount account = buildAccount(tenantId, request);
        accountMapper.insert(account);
        
        // 4. 记录日志
        log.info("账号创建成功, tenantId={}, accountId={}", tenantId, account.getId());
        
        return convertToDTO(account);
    }
    
    private void validateCreateRequest(String tenantId, CreateAccountRequest request) {
        if (StringUtils.isBlank(tenantId)) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "租户ID不能为空");
        }
        if (StringUtils.isBlank(request.getAccountName())) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "账号名称不能为空");
        }
    }
}
```

**规则**:
- 使用4个空格缩进，不使用Tab
- 行长度不超过120字符
- 左花括号不换行，右花括号独占一行
- 操作符前后加空格
- 逗号后面加空格
- 方法之间空一行分隔

## 🏗️ 类和方法设计规范

### 1. 类设计原则
```java
// ✅ 正确的类设计
@Entity
@Table(name = "wework_accounts")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeWorkAccount {
    
    @Id
    private String id;
    
    @Column(name = "tenant_id", nullable = false)
    private String tenantId;
    
    @Column(name = "account_name", length = 100, nullable = false)
    private String accountName;
    
    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private AccountStatus status;
    
    @Column(name = "config", columnDefinition = "JSON")
    @TypeHandler(JacksonTypeHandler.class)
    private AccountConfig config;
    
    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}

// 业务状态枚举
public enum AccountStatus {
    CREATED("已创建"),
    INITIALIZING("初始化中"),
    WAITING_QR("等待扫码"),
    WAITING_CONFIRM("等待确认"),
    VERIFYING("验证中"),
    ONLINE("在线"),
    OFFLINE("离线"),
    ERROR("异常"),
    RECOVERING("恢复中");
    
    private final String description;
    
    AccountStatus(String description) {
        this.description = description;
    }
    
    public String getDescription() {
        return description;
    }
}
```

### 2. 方法设计规则
```java
// ✅ 正确的方法设计
@Service
public class MessageService {
    
    /**
     * 发送消息
     * 
     * @param tenantId 租户ID，不能为空
     * @param request 发送请求，不能为空
     * @return 消息发送结果
     * @throws BusinessException 当租户不存在或配额不足时抛出
     */
    public MessageSendResult sendMessage(String tenantId, SendMessageRequest request) {
        // 参数校验
        Assert.hasText(tenantId, "租户ID不能为空");
        Assert.notNull(request, "发送请求不能为空");
        
        // 业务逻辑
        return doSendMessage(tenantId, request);
    }
    
    // 私有方法：具体实现
    private MessageSendResult doSendMessage(String tenantId, SendMessageRequest request) {
        try {
            // 1. 检查配额
            checkMessageQuota(tenantId);
            
            // 2. 构建消息
            Message message = buildMessage(tenantId, request);
            
            // 3. 发送消息
            String messageId = weWorkClient.sendMessage(message);
            
            // 4. 保存记录
            saveMessageRecord(message, messageId);
            
            return MessageSendResult.success(messageId);
            
        } catch (WeWorkException e) {
            log.error("企微消息发送失败, tenantId={}, error={}", tenantId, e.getMessage());
            return MessageSendResult.failure(e.getErrorCode(), e.getMessage());
        }
    }
    
    // 方法职责单一
    private void checkMessageQuota(String tenantId) {
        TenantQuota quota = tenantService.getTenantQuota(tenantId);
        if (quota.getUsedMessages() >= quota.getMaxMessages()) {
            throw new BusinessException(ErrorCode.QUOTA_EXCEEDED, "消息配额已用完");
        }
    }
}

// ❌ 错误的方法设计
public class BadService {
    
    // 方法过长，职责不单一
    public String processData(String data) {
        // 100+ 行代码
        // 包含多个职责：验证、转换、保存、发送通知等
    }
    
    // 参数过多
    public void updateAccount(String id, String name, String email, String phone, 
                            String address, boolean active, String config) {
        // 应该使用对象封装参数
    }
    
    // 返回null，应该使用Optional
    public Account findAccount(String id) {
        return accountMapper.selectById(id); // 可能返回null
    }
}
```

**规则**:
- 类职责单一，不超过500行代码
- 方法职责单一，不超过50行代码
- 参数不超过5个，多参数用对象封装
- 避免返回null，使用Optional或空对象
- 公共方法必须写JavaDoc注释

## 🔧 异常处理规范

### 1. 自定义异常
```java
// ✅ 业务异常定义
@Data
@EqualsAndHashCode(callSuper = true)
public class BusinessException extends RuntimeException {
    
    private final ErrorCode errorCode;
    private final String message;
    private final Object[] args;
    
    public BusinessException(ErrorCode errorCode) {
        this.errorCode = errorCode;
        this.message = errorCode.getMessage();
        this.args = null;
    }
    
    public BusinessException(ErrorCode errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
        this.args = null;
    }
    
    public BusinessException(ErrorCode errorCode, Object... args) {
        this.errorCode = errorCode;
        this.message = MessageFormat.format(errorCode.getMessage(), args);
        this.args = args;
    }
}

// 错误码枚举
public enum ErrorCode {
    SUCCESS(200, "操作成功"),
    PARAM_ERROR(400, "参数错误"),
    UNAUTHORIZED(401, "未认证"),
    FORBIDDEN(403, "无权限"),
    NOT_FOUND(404, "资源不存在"),
    
    // 业务错误码 (40000-49999)
    ACCOUNT_NOT_FOUND(40001, "账号不存在"),
    ACCOUNT_QUOTA_EXCEEDED(40002, "账号配额已满"),
    MESSAGE_SEND_FAILED(40003, "消息发送失败：{0}"),
    TENANT_NOT_FOUND(40004, "租户不存在"),
    
    // 系统错误码 (50000-59999)
    SYSTEM_ERROR(50000, "系统错误"),
    DATABASE_ERROR(50001, "数据库错误"),
    EXTERNAL_SERVICE_ERROR(50002, "外部服务调用失败");
    
    private final Integer code;
    private final String message;
    
    ErrorCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
}
```

### 2. 异常处理最佳实践
```java
// ✅ 正确的异常处理
@Service
@Slf4j
public class AccountService {
    
    public AccountDTO getAccount(String tenantId, String accountId) {
        try {
            // 参数验证
            if (StringUtils.isBlank(tenantId)) {
                throw new BusinessException(ErrorCode.PARAM_ERROR, "租户ID不能为空");
            }
            
            // 查询账号
            WeWorkAccount account = accountMapper.selectByTenantAndId(tenantId, accountId);
            if (account == null) {
                throw new BusinessException(ErrorCode.ACCOUNT_NOT_FOUND);
            }
            
            return convertToDTO(account);
            
        } catch (BusinessException e) {
            // 业务异常直接抛出
            throw e;
        } catch (Exception e) {
            // 系统异常记录日志并转换
            log.error("获取账号信息失败, tenantId={}, accountId={}", tenantId, accountId, e);
            throw new BusinessException(ErrorCode.SYSTEM_ERROR, "获取账号信息失败");
        }
    }
    
    public void updateAccountStatus(String tenantId, String accountId, AccountStatus status) {
        // 使用断言进行参数检查
        Assert.hasText(tenantId, "租户ID不能为空");
        Assert.hasText(accountId, "账号ID不能为空");
        Assert.notNull(status, "账号状态不能为空");
        
        WeWorkAccount account = getAccountEntity(tenantId, accountId);
        
        // 状态变更校验
        if (!isValidStatusTransition(account.getStatus(), status)) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, 
                String.format("不允许从%s状态变更为%s状态", 
                             account.getStatus().getDescription(), 
                             status.getDescription()));
        }
        
        // 执行更新
        account.setStatus(status);
        account.setUpdatedAt(LocalDateTime.now());
        accountMapper.updateById(account);
        
        log.info("账号状态更新成功, tenantId={}, accountId={}, status={}", 
                tenantId, accountId, status);
    }
    
    private WeWorkAccount getAccountEntity(String tenantId, String accountId) {
        WeWorkAccount account = accountMapper.selectByTenantAndId(tenantId, accountId);
        if (account == null) {
            throw new BusinessException(ErrorCode.ACCOUNT_NOT_FOUND);
        }
        return account;
    }
}

// ❌ 错误的异常处理
public class BadService {
    
    public Account getAccount(String id) {
        try {
            return accountMapper.selectById(id);
        } catch (Exception e) {
            // 吞掉异常，不记录日志
            return null;
        }
    }
    
    public void updateAccount(Account account) {
        try {
            accountMapper.updateById(account);
        } catch (Exception e) {
            // 记录异常但继续执行
            e.printStackTrace();
        }
    }
}
```

## 📋 日志记录规范

### 1. 日志级别使用
```java
// ✅ 正确的日志使用
@Service
@Slf4j
public class MessageService {
    
    public MessageSendResult sendMessage(String tenantId, SendMessageRequest request) {
        // DEBUG: 调试信息，生产环境不输出
        log.debug("开始发送消息, tenantId={}, messageType={}", tenantId, request.getType());
        
        try {
            // 业务逻辑处理
            String messageId = doSendMessage(tenantId, request);
            
            // INFO: 关键业务节点，生产环境输出
            log.info("消息发送成功, tenantId={}, messageId={}, recipient={}", 
                    tenantId, messageId, request.getRecipient());
            
            return MessageSendResult.success(messageId);
            
        } catch (QuotaExceededException e) {
            // WARN: 预期的业务异常
            log.warn("消息发送失败-配额不足, tenantId={}, currentQuota={}", 
                    tenantId, e.getCurrentQuota());
            throw new BusinessException(ErrorCode.QUOTA_EXCEEDED, e.getMessage());
            
        } catch (WeWorkApiException e) {
            // ERROR: 非预期的系统异常，包含堆栈信息
            log.error("企微API调用失败, tenantId={}, apiUrl={}, errorCode={}", 
                     tenantId, e.getApiUrl(), e.getErrorCode(), e);
            throw new BusinessException(ErrorCode.EXTERNAL_SERVICE_ERROR, e.getMessage());
        }
    }
    
    // 性能监控日志
    @Around("@annotation(PerformanceMonitor)")
    public Object logPerformance(ProceedingJoinPoint point) throws Throwable {
        String methodName = point.getSignature().getName();
        long startTime = System.currentTimeMillis();
        
        try {
            Object result = point.proceed();
            long executionTime = System.currentTimeMillis() - startTime;
            
            if (executionTime > 1000) {
                // WARN: 性能预警
                log.warn("方法执行时间过长, method={}, executionTime={}ms", 
                        methodName, executionTime);
            } else {
                // DEBUG: 正常性能记录
                log.debug("方法执行完成, method={}, executionTime={}ms", 
                         methodName, executionTime);
            }
            
            return result;
        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;
            log.error("方法执行异常, method={}, executionTime={}ms", 
                     methodName, executionTime, e);
            throw e;
        }
    }
}
```

### 2. 结构化日志
```java
// ✅ 结构化日志记录
@Component
public class AuditLogger {
    
    private final Logger auditLog = LoggerFactory.getLogger("AUDIT");
    
    public void logAccountCreated(String tenantId, String accountId, String operator) {
        MDC.put("action", "ACCOUNT_CREATED");
        MDC.put("tenantId", tenantId);
        MDC.put("accountId", accountId);
        MDC.put("operator", operator);
        MDC.put("timestamp", Instant.now().toString());
        
        auditLog.info("账号创建审计, tenantId={}, accountId={}, operator={}", 
                     tenantId, accountId, operator);
        
        MDC.clear();
    }
    
    public void logMessageSent(String tenantId, String messageId, String recipient) {
        Map<String, Object> auditData = new HashMap<>();
        auditData.put("action", "MESSAGE_SENT");
        auditData.put("tenantId", tenantId);
        auditData.put("messageId", messageId);
        auditData.put("recipient", recipient);
        auditData.put("timestamp", Instant.now());
        
        // 结构化JSON日志
        auditLog.info("消息发送审计 {}", JSON.toJSONString(auditData));
    }
}
```

## 💡 代码质量规范

### 1. 单元测试规范
```java
// ✅ 正确的单元测试
@ExtendWith(MockitoExtension.class)
class AccountServiceTest {
    
    @Mock
    private AccountMapper accountMapper;
    
    @Mock
    private TenantService tenantService;
    
    @InjectMocks
    private AccountService accountService;
    
    @Test
    @DisplayName("创建账号成功")
    void createAccount_Success() {
        // Given
        String tenantId = "tenant-123";
        CreateAccountRequest request = CreateAccountRequest.builder()
                .accountName("测试账号")
                .weWorkGuid("wx-123")
                .build();
        
        when(tenantService.checkAccountQuota(tenantId)).thenReturn(true);
        when(accountMapper.insert(any(WeWorkAccount.class))).thenReturn(1);
        
        // When
        AccountDTO result = accountService.createAccount(tenantId, request);
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.getAccountName()).isEqualTo("测试账号");
        assertThat(result.getStatus()).isEqualTo(AccountStatus.CREATED);
        
        verify(tenantService).checkAccountQuota(tenantId);
        verify(accountMapper).insert(any(WeWorkAccount.class));
    }
    
    @Test
    @DisplayName("创建账号失败-配额不足")
    void createAccount_QuotaExceeded() {
        // Given
        String tenantId = "tenant-123";
        CreateAccountRequest request = CreateAccountRequest.builder()
                .accountName("测试账号")
                .build();
        
        when(tenantService.checkAccountQuota(tenantId))
                .thenThrow(new BusinessException(ErrorCode.ACCOUNT_QUOTA_EXCEEDED));
        
        // When & Then
        BusinessException exception = assertThrows(BusinessException.class, () -> 
                accountService.createAccount(tenantId, request));
        
        assertThat(exception.getErrorCode()).isEqualTo(ErrorCode.ACCOUNT_QUOTA_EXCEEDED);
        verify(accountMapper, never()).insert(any());
    }
}
```

### 2. 代码检查规则
```java
// ✅ 使用工具进行代码检查

// 1. 使用@NonNull/@Nullable注解
public AccountDTO getAccount(@NonNull String tenantId, @NonNull String accountId) {
    // 方法实现
}

// 2. 使用Optional避免null返回
public Optional<AccountDTO> findAccount(String tenantId, String accountId) {
    WeWorkAccount account = accountMapper.selectByTenantAndId(tenantId, accountId);
    return Optional.ofNullable(account).map(this::convertToDTO);
}

// 3. 使用Builder模式构建复杂对象
public WeWorkAccount buildAccount(String tenantId, CreateAccountRequest request) {
    return WeWorkAccount.builder()
            .id(UUID.randomUUID().toString())
            .tenantId(tenantId)
            .accountName(request.getAccountName())
            .weWorkGuid(request.getWeWorkGuid())
            .status(AccountStatus.CREATED)
            .config(request.getConfig())
            .createdAt(LocalDateTime.now())
            .build();
}

// 4. 使用Stream API进行集合操作
public List<AccountDTO> getActiveAccounts(String tenantId) {
    return accountMapper.selectByTenantId(tenantId)
            .stream()
            .filter(account -> AccountStatus.ONLINE.equals(account.getStatus()))
            .map(this::convertToDTO)
            .collect(Collectors.toList());
}
```

**规则总结**:
- 严格遵循命名规范和代码格式
- 类和方法保持单一职责
- 统一使用自定义异常和错误码
- 合理使用日志级别，关键操作记录审计日志
- 编写充分的单元测试
- 使用现代Java特性提升代码质量