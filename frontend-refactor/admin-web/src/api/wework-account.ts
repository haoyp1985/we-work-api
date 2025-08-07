/**
 * WeWork账号管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult, 
  PageResult 
} from '@/types/api'

// WeWork账号信息
export interface WeWorkAccount {
  id: string
  name: string
  corpId: string
  agentId: string
  secret: string
  status: 'active' | 'inactive' | 'expired'
  avatar?: string
  description?: string
  lastLoginTime?: string
  isOnline: boolean
  contactCount: number
  groupCount: number
  createdAt: string
  updatedAt?: string
}

// 账号查询参数
export interface AccountQuery {
  pageNum?: number
  pageSize?: number
  keyword?: string
  status?: number
}

// 创建账号请求
export interface CreateAccountRequest {
  name: string
  corpId: string
  agentId: string
  secret: string
  description?: string
}

// 更新账号请求
export interface UpdateAccountRequest {
  name?: string
  description?: string
  status?: number
}

/**
 * 分页查询账号列表
 */
export function getAccountList(params: AccountQuery): Promise<ApiResult<PageResult<WeWorkAccount>>> {
  return httpClient.get<PageResult<WeWorkAccount>>('/accounts', { params })
}

/**
 * 根据ID获取账号详情
 */
export function getAccountById(accountId: string): Promise<ApiResult<WeWorkAccount>> {
  return httpClient.get<WeWorkAccount>(`/accounts/${accountId}`)
}

/**
 * 创建企微账号
 */
export function createAccount(data: CreateAccountRequest): Promise<ApiResult<WeWorkAccount>> {
  return httpClient.post<WeWorkAccount>('/accounts', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新企微账号
 */
export function updateAccount(accountId: string, data: UpdateAccountRequest): Promise<ApiResult<WeWorkAccount>> {
  return httpClient.put<WeWorkAccount>(`/accounts/${accountId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除企微账号
 */
export function deleteAccount(accountId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/accounts/${accountId}`, {
    showSuccessMessage: true
  })
}

/**
 * 登录企微账号
 */
export function loginAccount(accountId: string): Promise<ApiResult<string>> {
  return httpClient.post<string>(`/accounts/${accountId}/login`, null, {
    showSuccessMessage: true
  })
}

/**
 * 登出企微账号
 */
export function logoutAccount(accountId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/accounts/${accountId}/logout`, null, {
    showSuccessMessage: true
  })
}

/**
 * 重启企微账号
 */
export function restartAccount(accountId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/accounts/${accountId}/restart`, null, {
    showSuccessMessage: true
  })
}

/**
 * 获取账号登录二维码
 */
export function getLoginQrCode(accountId: string): Promise<ApiResult<{
  qrCodeUrl: string
  expires: number
}>> {
  return httpClient.get(`/accounts/${accountId}/qrcode`)
}

/**
 * 检查账号在线状态
 */
export function checkAccountStatus(accountId: string): Promise<ApiResult<{
  isOnline: boolean
  lastActiveTime: string
  connectionStatus: 'connected' | 'disconnected' | 'connecting'
}>> {
  return httpClient.get(`/accounts/${accountId}/status`)
}

/**
 * 获取账号统计信息
 */
export function getAccountStats(accountId: string): Promise<ApiResult<{
  contactCount: number
  groupCount: number
  messageCount: number
  dailyActiveUsers: number
  monthlyActiveUsers: number
}>> {
  return httpClient.get(`/accounts/${accountId}/stats`)
}

/**
 * 批量操作账号
 */
export function batchAccountOperation(data: {
  accountIds: string[]
  operation: 'login' | 'logout' | 'restart' | 'delete'
}): Promise<ApiResult<{
  successCount: number
  failCount: number
  errors?: string[]
}>> {
  return httpClient.post('/accounts/batch', data, {
    showSuccessMessage: true
  })
}

/**
 * 导出账号配置
 */
export function exportAccountConfig(accountId: string): Promise<Blob> {
  return httpClient.get(`/accounts/${accountId}/export`, {
    responseType: 'blob'
  })
}

/**
 * 导入账号配置
 */
export function importAccountConfig(file: File): Promise<ApiResult<{
  successCount: number
  failCount: number
  errors?: string[]
}>> {
  const formData = new FormData()
  formData.append('file', file)
  
  return httpClient.post('/accounts/import', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    showSuccessMessage: true
  })
}

/**
 * 测试账号连接
 */
export function testAccountConnection(data: {
  corpId: string
  agentId: string
  secret: string
}): Promise<ApiResult<{
  success: boolean
  message: string
  details?: any
}>> {
  return httpClient.post('/accounts/test', data)
}

/**
 * 获取账号操作日志
 */
export function getAccountLogs(accountId: string, params?: {
  pageNum?: number
  pageSize?: number
  startDate?: string
  endDate?: string
  operation?: string
}): Promise<ApiResult<PageResult<{
  id: string
  operation: string
  result: 'success' | 'failed'
  message: string
  operatorId: string
  operatorName: string
  createdAt: string
}>>> {
  return httpClient.get(`/accounts/${accountId}/logs`, { params })
}