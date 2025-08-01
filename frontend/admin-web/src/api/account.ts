import { http } from '@/utils/request'
import type { 
  WeWorkAccount,
  WeWorkAccountDetail, 
  WeWorkAccountStatus,
  PageResult,
  PageParams 
} from '@/types'

/**
 * 获取账号列表
 */
export const getAccountList = (params: PageParams & {
  name?: string
  status?: string
  wxid?: string
  tenantId?: string
}) => {
  return http.get<PageResult<WeWorkAccountDetail>>('/accounts', params)
}

/**
 * 获取账号详情
 */
export const getAccountDetail = (id: string) => {
  return http.get<WeWorkAccount>(`/accounts/${id}`)
}

/**
 * 创建账号
 */
export const createAccount = (data: Partial<WeWorkAccount>) => {
  return http.post<WeWorkAccount>('/accounts', data)
}

/**
 * 更新账号
 */
export const updateAccount = (id: string, data: Partial<WeWorkAccount>) => {
  return http.put<WeWorkAccount>(`/accounts/${id}`, data)
}

/**
 * 删除账号
 */
export const deleteAccount = (id: string) => {
  return http.delete(`/accounts/${id}`)
}

/**
 * 批量删除账号
 */
export const batchDeleteAccounts = (ids: string[]) => {
  return http.post('/accounts/batch-delete', { ids })
}

/**
 * 获取账号状态
 */
export const getAccountStatus = (id: string) => {
  return http.get<{
    id: string
    status: string
    isOnline: boolean
    lastHeartbeat: string
    deviceInfo?: string
  }>(`/accounts/${id}/status`)
}

/**
 * 重启账号
 */
export const restartAccount = (id: string) => {
  return http.post(`/accounts/${id}/restart`)
}

/**
 * 账号统计
 */
export const getAccountStats = () => {
  return http.get<{
    total: number
    online: number
    offline: number
    active: number
    inactive: number
    suspended: number
    banned: number
  }>('/accounts/stats')
}

// ==================== 企微账号监控扩展功能 ====================

/**
 * 获取账号详细信息（包含监控数据）
 */
export const getAccountDetailWithMonitor = (id: string) => {
  return http.get<WeWorkAccountDetail>(`/accounts/${id}/detail`)
}

/**
 * 批量获取账号状态
 */
export const batchGetAccountStatus = (ids: string[]) => {
  return http.post<Array<{
    id: string
    status: WeWorkAccountStatus
    isOnline: boolean
    healthScore: number
    lastHeartbeatTime?: string
    errorMessage?: string
  }>>('/accounts/batch-status', { ids })
}

/**
 * 启动账号登录
 */
export const startAccountLogin = (id: string) => {
  return http.post<{
    success: boolean
    qrCode?: string
    qrCodeUrl?: string
    message: string
    loginId: string
  }>(`/accounts/${id}/login`)
}

/**
 * 获取账号登录二维码
 */
export const getAccountQRCode = (id: string, loginId: string) => {
  return http.get<{
    qrCode: string
    qrCodeUrl: string
    expiresAt: string
    refreshInterval: number
  }>(`/accounts/${id}/qrcode/${loginId}`)
}

/**
 * 刷新账号登录二维码
 */
export const refreshAccountQRCode = (id: string, loginId: string) => {
  return http.post<{
    qrCode: string
    qrCodeUrl: string
    expiresAt: string
  }>(`/accounts/${id}/qrcode/${loginId}/refresh`)
}

/**
 * 检查账号登录状态
 */
export const checkAccountLoginStatus = (id: string, loginId: string) => {
  return http.get<{
    status: 'WAITING_QR' | 'WAITING_CONFIRM' | 'VERIFYING' | 'SUCCESS' | 'FAILED' | 'EXPIRED'
    message: string
    progress?: number
    guid?: string
  }>(`/accounts/${id}/login/${loginId}/status`)
}

/**
 * 强制下线账号
 */
export const forceLogoutAccount = (id: string) => {
  return http.post<{
    success: boolean
    message: string
  }>(`/accounts/${id}/logout`)
}

/**
 * 设置账号自动重连
 */
export const setAccountAutoReconnect = (id: string, enabled: boolean) => {
  return http.patch<void>(`/accounts/${id}/auto-reconnect`, { enabled })
}

/**
 * 更新账号配置
 */
export const updateAccountConfig = (id: string, config: {
  monitorInterval?: number
  maxRetryCount?: number
  autoReconnect?: boolean
  callbackUrl?: string
  proxyId?: string
  tenantTag?: string
}) => {
  return http.patch<WeWorkAccountDetail>(`/accounts/${id}/config`, config)
}

/**
 * 测试账号连通性
 */
export const testAccountConnection = (id: string) => {
  return http.post<{
    success: boolean
    responseTime: number
    message: string
    details: {
      heartbeatNormal: boolean
      apiReachable: boolean
      proxyWorking: boolean
      callbackWorking: boolean
    }
  }>(`/accounts/${id}/test-connection`)
}

/**
 * 获取账号操作日志
 */
export const getAccountLogs = (id: string, params?: {
  level?: 'DEBUG' | 'INFO' | 'WARN' | 'ERROR'
  startTime?: string
  endTime?: string
  keyword?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<{
    id: string
    timestamp: string
    level: string
    message: string
    operation: string
    userId?: string
    details?: any
  }>>(`/accounts/${id}/logs`, params)
}

/**
 * 清理账号日志
 */
export const clearAccountLogs = (id: string, beforeTime?: string) => {
  return http.delete(`/accounts/${id}/logs`, { beforeTime })
}

// ==================== 账号批量操作 ====================

/**
 * 批量启动账号
 */
export const batchStartAccounts = (ids: string[]) => {
  return http.post<{
    success: number
    failed: number
    results: Array<{
      id: string
      success: boolean
      message: string
      loginId?: string
    }>
  }>('/accounts/batch-start', { ids })
}

/**
 * 批量停止账号
 */
export const batchStopAccounts = (ids: string[]) => {
  return http.post<{
    success: number
    failed: number
    results: Array<{
      id: string
      success: boolean
      message: string
    }>
  }>('/accounts/batch-stop', { ids })
}

/**
 * 批量重启账号
 */
export const batchRestartAccounts = (ids: string[]) => {
  return http.post<{
    success: number
    failed: number
    results: Array<{
      id: string
      success: boolean
      message: string
    }>
  }>('/accounts/batch-restart', { ids })
}

/**
 * 批量更新账号配置
 */
export const batchUpdateAccountConfig = (updates: Array<{
  id: string
  config: Record<string, any>
}>) => {
  return http.post<{
    success: number
    failed: number
    results: Array<{
      id: string
      success: boolean
      message: string
    }>
  }>('/accounts/batch-update-config', { updates })
}

/**
 * 批量设置账号状态
 */
export const batchSetAccountStatus = (ids: string[], status: WeWorkAccountStatus) => {
  return http.post<{
    success: number
    failed: number
    results: Array<{
      id: string
      success: boolean
      message: string
    }>
  }>('/accounts/batch-set-status', { ids, status })
}

// ==================== 账号导入导出 ====================

/**
 * 导入账号
 */
export const importAccounts = (file: File, options?: {
  skipDuplicates?: boolean
  updateExisting?: boolean
  tenantId?: string
}) => {
  const formData = new FormData()
  formData.append('file', file)
  if (options) {
    Object.entries(options).forEach(([key, value]) => {
      formData.append(key, value.toString())
    })
  }
  
  return http.post<{
    total: number
    success: number
    failed: number
    skipped: number
    errors: Array<{
      row: number
      message: string
    }>
  }>('/accounts/import', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 导出账号
 */
export const exportAccounts = (params?: {
  tenantId?: string
  status?: string
  format?: 'EXCEL' | 'CSV' | 'JSON'
  includeConfig?: boolean
  includeMonitorData?: boolean
}) => {
  return http.get('/accounts/export', params, {
    responseType: 'blob'
  })
}

/**
 * 获取导入模板
 */
export const getImportTemplate = (format: 'EXCEL' | 'CSV' = 'EXCEL') => {
  return http.get('/accounts/import-template', { format }, {
    responseType: 'blob'
  })
}

// ==================== 租户账号管理 ====================

/**
 * 获取租户账号列表
 */
export const getTenantAccounts = (tenantId: string, params?: {
  status?: string
  healthScoreRange?: [number, number]
  keyword?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<WeWorkAccountDetail>>(`/tenants/${tenantId}/accounts`, params)
}

/**
 * 获取租户账号统计
 */
export const getTenantAccountStats = (tenantId: string) => {
  return http.get<{
    total: number
    online: number
    offline: number
    error: number
    recovering: number
    onlineRate: number
    avgHealthScore: number
    statusDistribution: Record<string, number>
    healthScoreDistribution: Record<string, number>
    recentChanges: Array<{
      accountId: string
      accountName: string
      oldStatus: string
      newStatus: string
      changeTime: string
    }>
  }>(`/tenants/${tenantId}/accounts/stats`)
}