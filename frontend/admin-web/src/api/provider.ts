import { http } from '@/utils/request'
import type { WeWorkProvider, PageResult, PageParams } from '@/types'

/**
 * 获取提供商列表
 */
export const getProviderList = (params?: PageParams & {
  providerName?: string
  providerType?: string
  status?: string
}) => {
  return http.get<PageResult<WeWorkProvider>>('/providers', params)
}

/**
 * 获取提供商详情
 */
export const getProviderDetail = (id: string) => {
  return http.get<WeWorkProvider>(`/providers/${id}`)
}

/**
 * 注册提供商
 */
export const registerProvider = (data: Partial<WeWorkProvider>) => {
  return http.post<WeWorkProvider>('/providers', data)
}

/**
 * 更新提供商
 */
export const updateProvider = (id: string, data: Partial<WeWorkProvider>) => {
  return http.put<WeWorkProvider>(`/providers/${id}`, data)
}

/**
 * 删除提供商
 */
export const deleteProvider = (id: string) => {
  return http.delete(`/providers/${id}`)
}

/**
 * 测试提供商连接
 */
export const testProviderConnection = (id: string) => {
  return http.post<{
    success: boolean
    message: string
    responseTime: number
    timestamp: string
  }>(`/providers/${id}/test`)
}

/**
 * 获取提供商统计
 */
export const getProviderStats = () => {
  return http.get<{
    total: number
    active: number
    inactive: number
    error: number
    avgResponseTime: number
    providerTypes: Array<{
      type: string
      count: number
      percentage: number
    }>
  }>('/providers/stats')
}

/**
 * 获取提供商使用情况
 */
export const getProviderUsage = (providerId: string, params?: {
  startTime?: string
  endTime?: string
}) => {
  return http.get<{
    totalRequests: number
    successRequests: number
    failedRequests: number
    avgResponseTime: number
    dailyUsage: Array<{
      date: string
      requests: number
      success: number
      failed: number
      avgResponseTime: number
    }>
  }>(`/providers/${providerId}/usage`, params)
}