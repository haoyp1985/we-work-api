/**
 * 账号相关类型定义
 * WeWork Management Platform - Frontend
 */

import type { BaseEntity, PageQuery } from './index'

// ===== 企微账号基础类型 =====

/**
 * 账号状态枚举
 */
export type AccountStatus = 
  | 'CREATED'          // 已创建
  | 'INITIALIZING'     // 初始化中
  | 'WAITING_QR'       // 等待扫码
  | 'WAITING_CONFIRM'  // 等待确认
  | 'VERIFYING'        // 验证中
  | 'ONLINE'           // 在线
  | 'OFFLINE'          // 离线
  | 'ERROR'            // 异常
  | 'RECOVERING'       // 恢复中

/**
 * 账号类型
 */
export type AccountType = 'PERSONAL' | 'ENTERPRISE' | 'SERVICE'

/**
 * 企微账号实体
 */
export interface WeWorkAccount extends BaseEntity {
  accountName: string
  weWorkGuid: string
  accountType: AccountType
  status: AccountStatus
  avatar?: string
  nickname?: string
  mobile?: string
  email?: string
  qrCode?: string
  deviceInfo?: AccountDeviceInfo
  config?: AccountConfig
  statistics?: AccountStatistics
  lastOnlineAt?: string
  lastOfflineAt?: string
  errorMessage?: string
  tags?: string[]
  remark?: string
}

/**
 * 账号设备信息
 */
export interface AccountDeviceInfo {
  deviceId?: string
  deviceName?: string
  platform?: string
  version?: string
  browser?: string
  userAgent?: string
  ipAddress?: string
  location?: string
}

/**
 * 账号配置
 */
export interface AccountConfig {
  // 消息发送配置
  messageSending: {
    enabled: boolean
    maxPerDay: number
    maxPerHour: number
    maxPerMinute: number
    interval: number
    retryCount: number
  }
  
  // 自动回复配置
  autoReply: {
    enabled: boolean
    replyContent: string
    replyDelay: number
    keywords: string[]
  }
  
  // 好友管理配置
  friendManagement: {
    autoAcceptFriend: boolean
    maxFriendCount: number
    autoGreeting: boolean
    greetingContent: string
  }
  
  // 群组管理配置
  groupManagement: {
    autoJoinGroup: boolean
    maxGroupCount: number
    autoReplyInGroup: boolean
    groupReplyContent: string
  }
  
  // 监控配置
  monitoring: {
    heartbeatInterval: number
    statusCheckInterval: number
    enableScreenshot: boolean
    logLevel: 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
  }
  
  // 安全配置
  security: {
    enableProxy: boolean
    proxyConfig?: ProxyConfig
    enableEncryption: boolean
    maxLoginRetry: number
    loginTimeout: number
  }
}

/**
 * 代理配置
 */
export interface ProxyConfig {
  type: 'HTTP' | 'HTTPS' | 'SOCKS5'
  host: string
  port: number
  username?: string
  password?: string
  enabled: boolean
}

// ===== 账号查询和表单 =====

/**
 * 账号查询表单
 */
export interface AccountSearchForm extends PageQuery {
  accountName?: string
  status?: AccountStatus
  accountType?: AccountType
  weWorkGuid?: string
  tags?: string[]
  startDate?: string
  endDate?: string
  createdBy?: string
}

/**
 * 账号创建表单
 */
export interface AccountCreateForm {
  accountName: string
  accountType: AccountType
  weWorkGuid?: string
  mobile?: string
  email?: string
  config?: Partial<AccountConfig>
  tags?: string[]
  remark?: string
}

/**
 * 账号更新表单
 */
export interface AccountUpdateForm {
  accountName?: string
  nickname?: string
  mobile?: string
  email?: string
  config?: Partial<AccountConfig>
  tags?: string[]
  remark?: string
}

/**
 * 账号状态更新表单
 */
export interface AccountStatusUpdateForm {
  status: AccountStatus
  reason?: string
}

// ===== 账号统计 =====

/**
 * 单个账号统计
 */
export interface AccountStatistics {
  // 消息统计
  messageSent: number
  messageReceived: number
  messageFailed: number
  
  // 好友统计
  friendCount: number
  friendAdded: number
  friendDeleted: number
  
  // 群组统计
  groupCount: number
  groupJoined: number
  groupLeft: number
  
  // 在线统计
  onlineTime: number
  onlineDays: number
  lastOnlineAt?: string
  
  // 错误统计
  errorCount: number
  lastErrorAt?: string
  
  // 日期
  statisticsDate: string
}

/**
 * 账号总体统计
 */
export interface AccountTotalStatistics {
  totalCount: number
  onlineCount: number
  offlineCount: number
  errorCount: number
  statusDistribution: Record<AccountStatus, number>
  typeDistribution: Record<AccountType, number>
  dailyStats: Array<{
    date: string
    total: number
    online: number
    offline: number
    error: number
    created: number
  }>
  performanceStats: {
    avgOnlineTime: number
    avgMessageSent: number
    successRate: number
    errorRate: number
  }
}

// ===== 账号操作 =====

/**
 * 账号操作类型
 */
export type AccountOperationType = 
  | 'LOGIN'          // 登录
  | 'LOGOUT'         // 登出
  | 'RESTART'        // 重启
  | 'RESET'          // 重置
  | 'UPDATE_CONFIG'  // 更新配置
  | 'UPDATE_STATUS'  // 更新状态
  | 'SEND_MESSAGE'   // 发送消息
  | 'ADD_FRIEND'     // 添加好友
  | 'JOIN_GROUP'     // 加入群组

/**
 * 账号操作记录
 */
export interface AccountOperationLog {
  id: string
  accountId: string
  accountName: string
  operationType: AccountOperationType
  operationDetail: string
  status: 'SUCCESS' | 'FAILED' | 'PENDING'
  result?: any
  errorMessage?: string
  operatedBy: string
  operatedAt: string
  duration?: number
}

/**
 * 批量操作结果
 */
export interface BatchOperationResult {
  successCount: number
  failedCount: number
  totalCount: number
  successList: string[]
  failedList: Array<{
    id: string
    reason: string
  }>
  details: AccountOperationLog[]
}

// ===== 账号监控 =====

/**
 * 账号健康检查
 */
export interface AccountHealthCheck {
  accountId: string
  accountName: string
  status: AccountStatus
  isHealthy: boolean
  lastCheckAt: string
  nextCheckAt: string
  checkResult: {
    networkConnectivity: boolean
    serviceAvailability: boolean
    resourceUsage: {
      cpu: number
      memory: number
      disk: number
    }
    errorRate: number
    responseTime: number
  }
}

/**
 * 账号性能指标
 */
export interface AccountPerformanceMetrics {
  accountId: string
  timestamp: string
  metrics: {
    // 响应时间指标
    responseTime: {
      avg: number
      min: number
      max: number
      p95: number
      p99: number
    }
    
    // 吞吐量指标
    throughput: {
      messagesPerSecond: number
      requestsPerSecond: number
    }
    
    // 错误率指标
    errorRate: {
      total: number
      network: number
      timeout: number
      business: number
    }
    
    // 资源使用率
    resourceUsage: {
      cpu: number
      memory: number
      network: number
    }
  }
}

// ===== 账号群组管理 =====

/**
 * 账号分组
 */
export interface AccountGroup extends BaseEntity {
  groupName: string
  description?: string
  color?: string
  icon?: string
  accountIds: string[]
  config?: GroupConfig
  statistics?: GroupStatistics
  tags?: string[]
}

/**
 * 分组配置
 */
export interface GroupConfig {
  autoManagement: boolean
  syncConfig: boolean
  batchOperation: boolean
  sharedResources: boolean
}

/**
 * 分组统计
 */
export interface GroupStatistics {
  accountCount: number
  onlineCount: number
  offlineCount: number
  errorCount: number
  totalMessageSent: number
  avgPerformance: number
}

// ===== 账号标签 =====

/**
 * 账号标签
 */
export interface AccountTag {
  id: string
  tagName: string
  tagColor: string
  description?: string
  accountCount: number
  createdAt: string
  updatedAt: string
}

/**
 * 标签使用统计
 */
export interface TagUsageStatistics {
  tagId: string
  tagName: string
  usageCount: number
  trend: 'up' | 'down' | 'stable'
  lastUsedAt: string
}

// ===== 账号导入导出 =====

/**
 * 账号导入表单
 */
export interface AccountImportForm {
  file: File
  templateType: 'STANDARD' | 'CUSTOM'
  duplicateStrategy: 'SKIP' | 'UPDATE' | 'ERROR'
  mapping?: Record<string, string>
}

/**
 * 账号导入结果
 */
export interface AccountImportResult {
  totalCount: number
  successCount: number
  failedCount: number
  skippedCount: number
  details: Array<{
    row: number
    accountName: string
    status: 'SUCCESS' | 'FAILED' | 'SKIPPED'
    reason?: string
  }>
  downloadErrorReport?: string
}

/**
 * 账号导出表单
 */
export interface AccountExportForm {
  format: 'EXCEL' | 'CSV' | 'JSON'
  fields: string[]
  filters?: AccountSearchForm
  includeStatistics: boolean
  includeConfig: boolean
}

// ===== 账号模板 =====

/**
 * 账号模板
 */
export interface AccountTemplate {
  id: string
  templateName: string
  description?: string
  accountType: AccountType
  defaultConfig: AccountConfig
  requiredFields: string[]
  optionalFields: string[]
  validationRules: ValidationRule[]
  isSystem: boolean
  createdAt: string
  updatedAt: string
}

/**
 * 验证规则
 */
export interface ValidationRule {
  field: string
  type: 'REQUIRED' | 'FORMAT' | 'LENGTH' | 'RANGE' | 'CUSTOM'
  rule: string | RegExp | number[]
  message: string
}