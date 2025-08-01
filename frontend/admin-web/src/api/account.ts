import { http } from '@/utils/request'
import type { WeWorkAccount, PageResult, PageParams } from '@/types'

/**
 * 获取账号列表
 */
export const getAccountList = (params: PageParams & {
  name?: string
  status?: string
  wxid?: string
}) => {
  return http.get<PageResult<WeWorkAccount>>('/accounts', params)
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