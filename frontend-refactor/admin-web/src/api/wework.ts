/**
 * 企业微信集成相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult,
  PageResult,
  UserInfo
} from '@/types/api'

// 企微配置状态
export type WeWorkConfigStatus = 'ENABLED' | 'DISABLED' | 'CONFIGURING' | 'ERROR'

// 同步状态
export type SyncStatus = 'PENDING' | 'SYNCING' | 'SUCCESS' | 'FAILED'

// 企微应用类型
export type WeWorkAppType = 'INTERNAL' | 'THIRD_PARTY'

// 企微账号绑定状态
export type BindStatus = 'BOUND' | 'UNBOUND' | 'EXPIRED'

// 企微配置信息
export interface WeWorkConfig {
  id: string
  corpId: string
  corpSecret: string
  agentId: string
  appType: WeWorkAppType
  appName: string
  status: WeWorkConfigStatus
  features: {
    ssoEnabled: boolean
    userSyncEnabled: boolean
    orgSyncEnabled: boolean
    messageEnabled: boolean
    approvalEnabled: boolean
  }
  syncSettings: {
    autoSync: boolean
    syncInterval: number // 小时
    lastSyncAt?: string
    syncScope: {
      users: boolean
      departments: boolean
      roles: boolean
    }
  }
  oauthSettings: {
    redirectUri: string
    scope: string[]
    state: string
  }
  webhookSettings: {
    url: string
    token: string
    encodingAESKey: string
    enabled: boolean
  }
  metadata: {
    createdBy: string
    createdAt: string
    updatedBy: string
    updatedAt: string
    lastTestAt?: string
    testResult?: {
      success: boolean
      message: string
      details: Record<string, any>
    }
  }
}

// 企微用户信息
export interface WeWorkUser {
  id: string
  userId: string // 企微用户ID
  name: string
  email: string
  mobile: string
  avatar: string
  position: string
  department: string[]
  departmentIds: number[]
  isLeader: boolean
  status: 'ACTIVE' | 'INACTIVE' | 'UNFOLLOW'
  extAttrs: Record<string, any>
  bindStatus: BindStatus
  systemUserId?: string // 系统用户ID
  bindTime?: string
  lastLoginAt?: string
  syncedAt: string
}

// 企微部门信息
export interface WeWorkDepartment {
  id: number
  name: string
  parentId: number
  order: number
  systemDepartmentId?: string
  memberCount: number
  childCount: number
  syncedAt: string
}

// 企微消息模板
export interface WeWorkMessageTemplate {
  id: string
  name: string
  type: 'TEXT' | 'MARKDOWN' | 'NEWS' | 'TEMPLATE_CARD'
  title: string
  content: string
  variables: Array<{
    name: string
    description: string
    required: boolean
    defaultValue?: string
  }>
  agentId: string
  enabled: boolean
  usageCount: number
  createdAt: string
}

// 同步任务信息
export interface SyncTask {
  id: string
  type: 'USER_SYNC' | 'DEPT_SYNC' | 'FULL_SYNC'
  status: SyncStatus
  progress: number
  total: number
  processed: number
  failed: number
  startTime: string
  endTime?: string
  result?: {
    summary: {
      usersAdded: number
      usersUpdated: number
      usersDeactivated: number
      deptsAdded: number
      deptsUpdated: number
      deptsRemoved: number
    }
    errors: Array<{
      type: 'USER' | 'DEPT'
      id: string
      name: string
      error: string
    }>
  }
  triggeredBy: string
  triggeredAt: string
}

// ==================== 企微配置管理 ====================

/**
 * 获取企微配置
 */
export function getWeWorkConfig(): Promise<ApiResult<WeWorkConfig | null>> {
  return httpClient.get('/wework/config')
}

/**
 * 创建企微配置
 */
export function createWeWorkConfig(data: {
  corpId: string
  corpSecret: string
  agentId: string
  appType: WeWorkAppType
  appName: string
  features: WeWorkConfig['features']
  syncSettings: WeWorkConfig['syncSettings']
  oauthSettings: WeWorkConfig['oauthSettings']
  webhookSettings: WeWorkConfig['webhookSettings']
}): Promise<ApiResult<{ configId: string }>> {
  return httpClient.post('/wework/config', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新企微配置
 */
export function updateWeWorkConfig(data: Partial<{
  corpSecret: string
  agentId: string
  appName: string
  features: WeWorkConfig['features']
  syncSettings: WeWorkConfig['syncSettings']
  oauthSettings: WeWorkConfig['oauthSettings']
  webhookSettings: WeWorkConfig['webhookSettings']
}>): Promise<ApiResult<void>> {
  return httpClient.put('/wework/config', data, {
    showSuccessMessage: true
  })
}

/**
 * 删除企微配置
 */
export function deleteWeWorkConfig(): Promise<ApiResult<void>> {
  return httpClient.delete('/wework/config', {
    showSuccessMessage: true
  })
}

/**
 * 测试企微连接
 */
export function testWeWorkConnection(): Promise<ApiResult<{
  success: boolean
  message: string
  details: {
    corpInfoValid: boolean
    agentInfoValid: boolean
    apiAccessible: boolean
    webhookConfigValid: boolean
  }
}>> {
  return httpClient.post('/wework/config/test')
}

/**
 * 启用/禁用企微集成
 */
export function toggleWeWorkStatus(enabled: boolean): Promise<ApiResult<void>> {
  return httpClient.post('/wework/config/toggle', { enabled }, {
    showSuccessMessage: true
  })
}

/**
 * 获取企微应用信息
 */
export function getWeWorkAppInfo(): Promise<ApiResult<{
  agentId: string
  name: string
  squareLogoUrl: string
  description: string
  redirectDomain: string
  reportLocationFlag: number
  isReportenter: number
  allowUserinfos: {
    user: string[]
  }
  allowPartys: {
    partyid: number[]
  }
  allowTags: {
    tagid: number[]
  }
}>> {
  return httpClient.get('/wework/app-info')
}

// ==================== 用户同步管理 ====================

/**
 * 获取企微用户列表
 */
export function getWeWorkUsers(params?: {
  current?: number
  size?: number
  keyword?: string
  departmentId?: number
  bindStatus?: BindStatus
  status?: 'ACTIVE' | 'INACTIVE' | 'UNFOLLOW'
  syncedAfter?: string
}): Promise<ApiResult<PageResult<WeWorkUser>>> {
  return httpClient.get('/wework/users', params)
}

/**
 * 获取企微用户详情
 */
export function getWeWorkUser(userId: string): Promise<ApiResult<WeWorkUser & {
  systemUser?: UserInfo
  bindHistory: Array<{
    id: string
    action: 'BIND' | 'UNBIND' | 'AUTO_BIND'
    systemUserId?: string
    timestamp: string
    operator: string
    reason?: string
  }>
}>> {
  return httpClient.get(`/wework/users/${userId}`)
}

/**
 * 手动绑定用户
 */
export function bindWeWorkUser(weWorkUserId: string, systemUserId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/users/${weWorkUserId}/bind`, { systemUserId }, {
    showSuccessMessage: true
  })
}

/**
 * 解绑用户
 */
export function unbindWeWorkUser(weWorkUserId: string, reason?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/users/${weWorkUserId}/unbind`, { reason }, {
    showSuccessMessage: true
  })
}

/**
 * 批量绑定用户
 */
export function batchBindUsers(bindings: Array<{
  weWorkUserId: string
  systemUserId: string
}>): Promise<ApiResult<{
  success: number
  failed: number
  errors: Array<{
    weWorkUserId: string
    error: string
  }>
}>> {
  return httpClient.post('/wework/users/batch-bind', { bindings }, {
    showSuccessMessage: true
  })
}

/**
 * 自动匹配并绑定用户
 */
export function autoBindUsers(matchBy: 'EMAIL' | 'MOBILE' | 'NAME'): Promise<ApiResult<{
  matched: number
  bound: number
  conflicts: Array<{
    weWorkUserId: string
    weWorkUserName: string
    possibleMatches: Array<{
      systemUserId: string
      systemUserName: string
      confidence: number
    }>
  }>
}>> {
  return httpClient.post('/wework/users/auto-bind', { matchBy }, {
    showSuccessMessage: true
  })
}

/**
 * 从企微同步单个用户
 */
export function syncWeWorkUser(userId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/users/${userId}/sync`, {}, {
    showSuccessMessage: true
  })
}

// ==================== 部门同步管理 ====================

/**
 * 获取企微部门列表
 */
export function getWeWorkDepartments(): Promise<ApiResult<WeWorkDepartment[]>> {
  return httpClient.get('/wework/departments')
}

/**
 * 获取企微部门树
 */
export function getWeWorkDepartmentTree(): Promise<ApiResult<WeWorkDepartment[]>> {
  return httpClient.get('/wework/departments/tree')
}

/**
 * 获取部门用户
 */
export function getWeWorkDepartmentUsers(departmentId: number, includeChild: boolean = false): Promise<ApiResult<WeWorkUser[]>> {
  return httpClient.get(`/wework/departments/${departmentId}/users`, { includeChild })
}

/**
 * 绑定部门
 */
export function bindWeWorkDepartment(weWorkDeptId: number, systemDeptId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/departments/${weWorkDeptId}/bind`, { systemDeptId }, {
    showSuccessMessage: true
  })
}

/**
 * 解绑部门
 */
export function unbindWeWorkDepartment(weWorkDeptId: number): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/departments/${weWorkDeptId}/unbind`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 从企微同步部门结构
 */
export function syncWeWorkDepartments(): Promise<ApiResult<{ taskId: string }>> {
  return httpClient.post('/wework/departments/sync', {}, {
    showSuccessMessage: true
  })
}

// ==================== 同步任务管理 ====================

/**
 * 开始全量同步
 */
export function startFullSync(options?: {
  syncUsers: boolean
  syncDepartments: boolean
  forceUpdate: boolean
}): Promise<ApiResult<{ taskId: string }>> {
  return httpClient.post('/wework/sync/full', options, {
    showSuccessMessage: true
  })
}

/**
 * 开始增量同步
 */
export function startIncrementalSync(): Promise<ApiResult<{ taskId: string }>> {
  return httpClient.post('/wework/sync/incremental', {}, {
    showSuccessMessage: true
  })
}

/**
 * 获取同步任务列表
 */
export function getSyncTasks(params?: {
  current?: number
  size?: number
  type?: 'USER_SYNC' | 'DEPT_SYNC' | 'FULL_SYNC'
  status?: SyncStatus
  startDate?: string
  endDate?: string
}): Promise<ApiResult<PageResult<SyncTask>>> {
  return httpClient.get('/wework/sync/tasks', params)
}

/**
 * 获取同步任务详情
 */
export function getSyncTask(taskId: string): Promise<ApiResult<SyncTask>> {
  return httpClient.get(`/wework/sync/tasks/${taskId}`)
}

/**
 * 停止同步任务
 */
export function stopSyncTask(taskId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/sync/tasks/${taskId}/stop`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 重试失败的同步任务
 */
export function retrySyncTask(taskId: string): Promise<ApiResult<{ newTaskId: string }>> {
  return httpClient.post(`/wework/sync/tasks/${taskId}/retry`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 获取同步统计
 */
export function getSyncStatistics(): Promise<ApiResult<{
  overview: {
    totalUsers: number
    boundUsers: number
    unboundUsers: number
    totalDepartments: number
    boundDepartments: number
  }
  lastSync: {
    taskId: string
    type: string
    status: SyncStatus
    startTime: string
    endTime?: string
    duration?: number
    usersProcessed: number
    deptsProcessed: number
  }
  trends: Array<{
    date: string
    syncCount: number
    successRate: number
    usersAdded: number
    usersUpdated: number
  }>
}>> {
  return httpClient.get('/wework/sync/statistics')
}

// ==================== 消息推送管理 ====================

/**
 * 获取消息模板列表
 */
export function getMessageTemplates(): Promise<ApiResult<WeWorkMessageTemplate[]>> {
  return httpClient.get('/wework/message-templates')
}

/**
 * 创建消息模板
 */
export function createMessageTemplate(data: {
  name: string
  type: WeWorkMessageTemplate['type']
  title: string
  content: string
  variables: WeWorkMessageTemplate['variables']
  agentId: string
}): Promise<ApiResult<{ templateId: string }>> {
  return httpClient.post('/wework/message-templates', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新消息模板
 */
export function updateMessageTemplate(templateId: string, data: Partial<{
  name: string
  title: string
  content: string
  variables: WeWorkMessageTemplate['variables']
  enabled: boolean
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/wework/message-templates/${templateId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除消息模板
 */
export function deleteMessageTemplate(templateId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/wework/message-templates/${templateId}`, {
    showSuccessMessage: true
  })
}

/**
 * 发送消息
 */
export function sendWeWorkMessage(data: {
  templateId?: string
  recipients: {
    userIds?: string[]
    departmentIds?: number[]
    tagIds?: number[]
    all?: boolean
  }
  message: {
    type: 'TEXT' | 'MARKDOWN' | 'NEWS' | 'TEMPLATE_CARD'
    content: string
    variables?: Record<string, string>
  }
  agentId: string
  safe?: number
}): Promise<ApiResult<{
  messageId: string
  invalidUsers?: string[]
  invalidParties?: number[]
  invalidTags?: number[]
}>> {
  return httpClient.post('/wework/messages/send', data, {
    showSuccessMessage: true
  })
}

/**
 * 获取消息发送记录
 */
export function getMessageHistory(params?: {
  current?: number
  size?: number
  startDate?: string
  endDate?: string
  agentId?: string
  templateId?: string
}): Promise<ApiResult<PageResult<{
  id: string
  templateId?: string
  templateName?: string
  agentId: string
  type: string
  title: string
  content: string
  recipientCount: number
  sentCount: number
  failedCount: number
  sentAt: string
  sentBy: string
  status: 'SENDING' | 'SENT' | 'FAILED'
}>>> {
  return httpClient.get('/wework/messages/history', params)
}

// ==================== OAuth 登录 ====================

/**
 * 获取企微OAuth登录URL
 */
export function getWeWorkOAuthUrl(redirectUri?: string): Promise<ApiResult<{
  authUrl: string
  state: string
}>> {
  return httpClient.get('/wework/oauth/url', { redirectUri })
}

/**
 * 处理OAuth回调
 */
export function handleWeWorkOAuthCallback(code: string, state: string): Promise<ApiResult<{
  accessToken: string
  refreshToken: string
  userInfo: UserInfo
  isNewUser: boolean
}>> {
  return httpClient.post('/wework/oauth/callback', { code, state })
}

/**
 * 获取企微登录配置
 */
export function getWeWorkLoginConfig(): Promise<ApiResult<{
  enabled: boolean
  autoRegister: boolean
  defaultRole: string
  forceBind: boolean
  allowedDomains: string[]
}>> {
  return httpClient.get('/wework/oauth/config')
}

/**
 * 更新企微登录配置
 */
export function updateWeWorkLoginConfig(config: {
  enabled: boolean
  autoRegister: boolean
  defaultRole: string
  forceBind: boolean
  allowedDomains: string[]
}): Promise<ApiResult<void>> {
  return httpClient.put('/wework/oauth/config', config, {
    showSuccessMessage: true
  })
}

// ==================== Webhook 管理 ====================

/**
 * 获取Webhook日志
 */
export function getWebhookLogs(params?: {
  current?: number
  size?: number
  startDate?: string
  endDate?: string
  eventType?: string
  status?: 'SUCCESS' | 'FAILED'
}): Promise<ApiResult<PageResult<{
  id: string
  eventType: string
  timestamp: string
  data: Record<string, any>
  processResult: {
    success: boolean
    message?: string
    action?: string
  }
  responseTime: number
}>>> {
  return httpClient.get('/wework/webhooks/logs', params)
}

/**
 * 重发Webhook事件
 */
export function retryWebhookEvent(logId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/wework/webhooks/logs/${logId}/retry`, {}, {
    showSuccessMessage: true
  })
}