/**
 * 通用API响应类型
 */
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  timestamp?: number
}

/**
 * 分页参数
 */
export interface PageParams {
  page: number
  size: number
  total?: number
}

/**
 * 分页响应
 */
export interface PageResult<T> {
  records: T[]
  total: number
  current: number
  size: number
  pages: number
}

/**
 * 用户信息
 */
export interface UserInfo {
  id: string
  username: string
  nickname?: string
  avatar?: string
  email?: string
  phone?: string
  status?: string
  roles: string[]
  permissions: string[]
  lastLoginTime?: string
  createdAt: string
  updatedAt: string
}

/**
 * 登录请求
 */
export interface LoginRequest {
  username: string
  password: string
  captcha?: string
}

/**
 * 登录响应
 */
export interface LoginResponse {
  token: string
  refreshToken: string
  user: UserInfo
  expiresIn: number
}

/**
 * 企微账号信息
 */
export interface WeWorkAccount {
  id: string
  name: string
  wxid: string
  alias?: string
  avatar?: string
  mobile?: string
  status: AccountStatus
  isOnline: boolean
  lastLoginTime?: string
  deviceInfo?: string
  createTime: string
  updateTime: string
}

/**
 * 账号状态枚举
 */
export enum AccountStatus {
  INACTIVE = 'INACTIVE',
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  BANNED = 'BANNED'
}

/**
 * 消息模板
 */
export interface MessageTemplate {
  id: string
  tenantId: string
  templateName: string
  templateType: MessageTemplateType
  content: string
  status: TemplateStatus
  createTime: string
  updateTime: string
}

/**
 * 消息模板类型
 */
export enum MessageTemplateType {
  TEXT = 'TEXT',
  IMAGE = 'IMAGE',
  VIDEO = 'VIDEO',
  FILE = 'FILE',
  LINK = 'LINK',
  MINI_PROGRAM = 'MINI_PROGRAM',
  CARD = 'CARD'
}

/**
 * 模板状态
 */
export enum TemplateStatus {
  DRAFT = 'DRAFT',
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE'
}

/**
 * WeWork API 提供商
 */
export interface WeWorkProvider {
  id: string
  providerName: string
  providerType: WeWorkProviderType
  baseUrl: string
  apiKey: string
  apiSecret?: string
  status: ProviderStatus
  createTime: string
  updateTime: string
}

/**
 * 提供商类型
 */
export enum WeWorkProviderType {
  GUANGZHOU_GUXING = 'GUANGZHOU_GUXING',
  OTHER_PROVIDER = 'OTHER_PROVIDER'
}

/**
 * 提供商状态
 */
export enum ProviderStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  ERROR = 'ERROR'
}

/**
 * 发送消息请求
 */
export interface SendMessageRequest {
  providerId: string
  guid: string
  conversationId: string
  messageType: MessageTemplateType
  content?: string
  imageUrl?: string
  videoUrl?: string
  fileUrl?: string
  linkUrl?: string
  linkTitle?: string
  linkDescription?: string
  linkImage?: string
}

/**
 * 批量发送消息请求
 */
export interface BatchSendMessageRequest {
  providerId: string
  guid: string
  userIds?: string[]
  roomIds?: string[]
  content: string
  messageType: MessageTemplateType
}

/**
 * 发送消息响应
 */
export interface SendMessageResponse {
  messageId: string
  seq: number
  guid: string
  conversationId: string
  status: string
  errorMessage?: string
  sendTime: string
  providerMessageId?: string
}

/**
 * 系统监控指标
 */
export interface SystemMetrics {
  cpu: {
    usage: number
    cores: number
  }
  memory: {
    used: number
    total: number
    usage: number
  }
  disk: {
    used: number
    total: number
    usage: number
  }
  network: {
    rx: number
    tx: number
  }
  timestamp: string
}

/**
 * 服务健康状态
 */
export interface ServiceHealth {
  serviceName: string
  status: 'UP' | 'DOWN' | 'UNKNOWN'
  details?: Record<string, any>
  timestamp: string
}

/**
 * 路由菜单
 */
export interface MenuItem {
  id: string
  path: string
  name: string
  component?: string
  redirect?: string
  meta?: {
    title: string
    icon?: string
    hidden?: boolean
    roles?: string[]
    keepAlive?: boolean
    affix?: boolean
  }
  children?: MenuItem[]
}

/**
 * 表格列配置
 */
export interface TableColumn {
  prop: string
  label: string
  width?: string | number
  minWidth?: string | number
  sortable?: boolean
  formatter?: (row: any, column: any, cellValue: any) => string
  type?: 'selection' | 'index' | 'expand'
}

/**
 * 表单规则
 */
export interface FormRule {
  required?: boolean
  message?: string
  trigger?: string | string[]
  min?: number
  max?: number
  pattern?: RegExp
  validator?: (rule: any, value: any, callback: any) => void
}

// ==================== 多租户相关类型 ====================

/**
 * 租户信息
 */
export interface TenantInfo {
  id: string
  name: string
  code: string
  type: TenantType
  status: TenantStatus
  contactName: string
  contactEmail: string
  contactPhone: string
  themeColor?: string
  secondaryColor?: string
  logo?: string
  description?: string
  createdAt: string
  updatedAt: string
}

/**
 * 租户类型
 */
export enum TenantType {
  TRIAL = 'TRIAL',        // 试用版
  STANDARD = 'STANDARD',  // 标准版
  PREMIUM = 'PREMIUM',    // 高级版
  ENTERPRISE = 'ENTERPRISE' // 企业版
}

/**
 * 租户状态
 */
export enum TenantStatus {
  ACTIVE = 'ACTIVE',      // 活跃
  INACTIVE = 'INACTIVE',  // 未激活
  SUSPENDED = 'SUSPENDED', // 暂停
  EXPIRED = 'EXPIRED'     // 过期
}

// ==================== 企微账号监控相关类型 ====================

/**
 * 企微账号详细信息（扩展现有WeWorkAccount）
 */
export interface WeWorkAccountDetail extends Omit<WeWorkAccount, 'status'> {
  tenantId: string
  accountName: string
  weWorkGuid: string
  proxyId?: string
  phone?: string
  callbackUrl?: string
  status: WeWorkAccountStatus
  healthScore?: number
  lastLoginTime?: string
  lastHeartbeatTime?: string
  autoReconnect?: boolean
  monitorInterval?: number
  maxRetryCount?: number
  retryCount?: number
  tenantTag?: string
  autoRecoveryAttempts?: number
  lastAutoRecoveryTime?: string
  createdAt: string
  updatedAt: string
}

/**
 * 企微账号状态（扩展为更详细的状态）
 */
export enum WeWorkAccountStatus {
  CREATED = 'CREATED',
  INITIALIZING = 'INITIALIZING',
  WAITING_QR = 'WAITING_QR',
  WAITING_CONFIRM = 'WAITING_CONFIRM',
  VERIFYING = 'VERIFYING',
  ONLINE = 'ONLINE',
  OFFLINE = 'OFFLINE',
  ERROR = 'ERROR',
  RECOVERING = 'RECOVERING'
}

/**
 * 账号健康报告
 */
export interface AccountHealthReport {
  accountId: string
  tenantId: string
  accountName: string
  status: WeWorkAccountStatus
  healthScore: number
  previousHealthScore?: number
  healthTrend: 'IMPROVING' | 'STABLE' | 'DECLINING' | 'CRITICAL'
  lastHeartbeatTime?: string
  heartbeatInterval?: number
  heartbeatNormal: boolean
  apiResponseTime?: number
  apiSuccessRate?: number
  retryCount: number
  maxRetryCount: number
  onlineDuration?: number
  offlineDuration?: number
  errorCount: number
  recoveryCount: number
  alertLevel?: string
  activeAlertCount: number
  healthCheckItems: HealthCheckItem[]
  recommendedActions: string[]
  riskAssessment: string
  checkTime: string
  dataValidSeconds: number
}

/**
 * 健康检查项
 */
export interface HealthCheckItem {
  checkName: string
  checkType: string
  passed: boolean
  result: string
  message: string
  value?: any
  threshold?: any
  severity: string
}

/**
 * 监控统计
 */
export interface MonitorStatistics {
  tenantId?: string
  statisticsTime: string
  periodSeconds: number
  totalAccounts: number
  onlineAccounts: number
  offlineAccounts: number
  errorAccounts: number
  recoveringAccounts: number
  onlineRate: number
  avgHealthScore: number
  healthyAccounts: number
  attentionNeededAccounts: number
  criticalAccounts: number
  activeAlerts: number
  criticalAlerts: number
  errorAlerts: number
  warningAlerts: number
  infoAlerts: number
  newAlerts: number
  resolvedAlerts: number
  alertResolutionRate: number
  avgResolutionTime: number
  avgApiResponseTime: number
  apiSuccessRate: number
  totalApiCalls: number
  successfulApiCalls: number
  failedApiCalls: number
  heartbeatNormalRate: number
  avgHeartbeatInterval: number
  healthScoreTrend: TrendPoint[]
  onlineRateTrend: TrendPoint[]
  alertCountTrend: TrendPoint[]
  statusDistribution: Record<string, number>
  healthScoreDistribution: Record<string, number>
  alertTypeDistribution: Record<string, number>
}

/**
 * 趋势点数据
 */
export interface TrendPoint {
  timestamp: string
  value: number
  label?: string
}

// ==================== 告警管理相关类型 ====================

/**
 * 告警信息
 */
export interface AlertInfo {
  id: string
  tenantId: string
  accountId: string
  ruleId?: string
  alertType: AlertType
  alertLevel: AlertLevel
  alertMessage: string
  alertData?: any
  status: AlertStatus
  firstOccurredAt: string
  lastOccurredAt: string
  occurrenceCount: number
  acknowledgedBy?: string
  acknowledgedAt?: string
  resolvedBy?: string
  resolvedAt?: string
  resolution?: string
  autoRecoveryAttempts: number
  // 前端显示用的额外字段
  accountName?: string
  levelText?: string
  typeText?: string
  statusText?: string
}

/**
 * 告警类型
 */
export enum AlertType {
  ACCOUNT_OFFLINE = 'ACCOUNT_OFFLINE',
  HEARTBEAT_TIMEOUT = 'HEARTBEAT_TIMEOUT',
  CONNECTION_ERROR = 'CONNECTION_ERROR',
  API_CALL_FAILED = 'API_CALL_FAILED',
  STATUS_MISMATCH = 'STATUS_MISMATCH',
  LOGIN_FAILED = 'LOGIN_FAILED',
  AUTO_RECOVER_FAILED = 'AUTO_RECOVER_FAILED',
  RETRY_LIMIT_REACHED = 'RETRY_LIMIT_REACHED',
  QUOTA_EXCEEDED = 'QUOTA_EXCEEDED',
  RESPONSE_TIME_HIGH = 'RESPONSE_TIME_HIGH',
  MESSAGE_SEND_FAILED = 'MESSAGE_SEND_FAILED',
  SYSTEM_RESOURCE_LOW = 'SYSTEM_RESOURCE_LOW',
  NETWORK_ERROR = 'NETWORK_ERROR',
  CALLBACK_ERROR = 'CALLBACK_ERROR',
  DATABASE_ERROR = 'DATABASE_ERROR',
  CACHE_ERROR = 'CACHE_ERROR',
  QUEUE_BACKLOG = 'QUEUE_BACKLOG'
}

/**
 * 告警级别
 */
export enum AlertLevel {
  CRITICAL = 'CRITICAL',
  ERROR = 'ERROR',
  WARNING = 'WARNING',
  INFO = 'INFO'
}

/**
 * 告警状态
 */
export enum AlertStatus {
  ACTIVE = 'ACTIVE',
  ACKNOWLEDGED = 'ACKNOWLEDGED',
  RESOLVED = 'RESOLVED',
  SUPPRESSED = 'SUPPRESSED',
  EXPIRED = 'EXPIRED'
}

/**
 * 告警查询参数
 */
export interface AlertQueryParams extends PageParams {
  tenantId?: string
  accountId?: string
  level?: AlertLevel
  status?: AlertStatus
  type?: AlertType
  startTime?: string
  endTime?: string
  keyword?: string
}

/**
 * 告警处理操作
 */
export interface AlertOperationRequest {
  alertId: string
  operation: 'acknowledge' | 'resolve' | 'suppress'
  userId: string
  reason?: string
  suppressMinutes?: number
}

/**
 * 批量告警操作
 */
export interface BatchAlertOperationRequest {
  alertIds: string[]
  operation: 'acknowledge' | 'resolve' | 'suppress'
  userId: string
  reason?: string
  suppressMinutes?: number
}

// ==================== 监控规则相关类型 ====================

/**
 * 监控规则
 */
export interface MonitorRule {
  id: string
  tenantId: string
  ruleName: string
  ruleDescription?: string
  ruleExpression: string
  alertMessage: string
  priority: number
  description?: string
  alertType: AlertType
  ruleType: MonitorRuleType
  alertLevel: AlertLevel
  enabled: boolean
  createdAt: string
  updatedAt: string
}

/**
 * 监控规则类型
 */
export enum MonitorRuleType {
  HEARTBEAT = 'HEARTBEAT',
  API_FAILURE_RATE = 'API_FAILURE_RATE',
  RESPONSE_TIME = 'RESPONSE_TIME',
  LOGIN_TIMEOUT = 'LOGIN_TIMEOUT',
  OFFLINE_DURATION = 'OFFLINE_DURATION',
  RETRY_COUNT = 'RETRY_COUNT',
  HEALTH_SCORE = 'HEALTH_SCORE',
  MESSAGE_FAILURE_RATE = 'MESSAGE_FAILURE_RATE',
  QUEUE_LENGTH = 'QUEUE_LENGTH',
  MEMORY_USAGE = 'MEMORY_USAGE',
  CPU_USAGE = 'CPU_USAGE',
  DISK_USAGE = 'DISK_USAGE',
  CONNECTION_COUNT = 'CONNECTION_COUNT',
  CACHE_HIT_RATE = 'CACHE_HIT_RATE',
  BUILTIN = 'BUILTIN',
  CUSTOM = 'CUSTOM'
}

// ==================== 自动运维相关类型 ====================

/**
 * 故障诊断结果
 */
export interface FaultDiagnosis {
  faultType: string
  faultCause: string
  severity: 'HIGH' | 'MEDIUM' | 'LOW'
  symptoms: string[]
  recommendations: string[]
  diagnosticData: Record<string, any>
}

/**
 * 恢复策略
 */
export interface RecoveryStrategy {
  id: string
  name: string
  description: string
  type: string
  priority: number
  parameters: Record<string, any>
  automatic: boolean
  estimatedTime: string
  successRate: string
}

/**
 * 自动运维统计
 */
export interface AutoOpsStatistics {
  totalAutoRecoveryAttempts: number
  successfulAutoRecoveries: number
  autoRecoverySuccessRate: number
  preventiveMaintenanceCount: number
  faultDiagnosisCount: number
  recoveryStrategyUsage: Record<string, number>
  topFaultTypes: Array<{
    faultType: string
    count: number
    successRate: number
  }>
}

// ==================== 租户配额相关类型 ====================

/**
 * 租户配额
 */
export interface TenantQuota {
  id: string
  tenantId: string
  maxAccounts: number
  maxDailyMessages: number
  maxApiCalls: number
  maxStorageGB: number
  maxBandwidthMBPS: number
  quotaPeriod: 'DAILY' | 'MONTHLY' | 'YEARLY'
  effectiveFrom: string
  effectiveUntil?: string
  enabled: boolean
}

/**
 * 租户使用量
 */
export interface TenantUsage {
  id: string
  tenantId: string
  usagePeriod: string
  accountCount: number
  messagesSent: number
  apiCallsCount: number
  storageUsedGB: number
  bandwidthUsedMB: number
  avgResponseTime: number
  successRate: number
  peakOnlineAccounts: number
  billed: boolean
}

/**
 * 配额检查结果
 */
export interface QuotaCheckResult {
  passed: boolean
  message: string
  currentUsage?: number
  quotaLimit?: number
  usagePercentage?: number
}

// ==================== AI智能体相关类型导出 ====================
export * from './agent'