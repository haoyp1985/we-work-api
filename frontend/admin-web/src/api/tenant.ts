import { http } from '@/utils/request'
import type { 
  TenantInfo, 
  TenantQuota, 
  TenantUsage, 
  QuotaCheckResult,
  PageResult 
} from '@/types'

// ==================== 租户管理相关API ====================

/**
 * 获取所有租户列表（超级管理员）
 */
export const getAllTenants = (params?: {
  keyword?: string
  status?: string
  type?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<TenantInfo>>('/tenants', params)
}

/**
 * 获取用户所属租户列表
 */
export const getUserTenants = () => {
  return http.get<TenantInfo[]>('/tenants/user-tenants')
}

/**
 * 获取租户详情
 */
export const getTenantDetail = (tenantId: string) => {
  return http.get<TenantInfo>(`/tenants/${tenantId}`)
}

/**
 * 创建租户
 */
export const createTenant = (tenant: Omit<TenantInfo, 'id' | 'createdAt' | 'updatedAt'>) => {
  return http.post<TenantInfo>('/tenants', tenant)
}

/**
 * 更新租户信息
 */
export const updateTenant = (tenantId: string, tenant: Partial<TenantInfo>) => {
  return http.put<TenantInfo>(`/tenants/${tenantId}`, tenant)
}

/**
 * 删除租户
 */
export const deleteTenant = (tenantId: string) => {
  return http.delete<void>(`/tenants/${tenantId}`)
}

/**
 * 启用/禁用租户
 */
export const toggleTenantStatus = (tenantId: string, status: string) => {
  return http.patch<void>(`/tenants/${tenantId}/status`, { status })
}

// ==================== 租户配额管理相关API ====================

/**
 * 获取租户配额
 */
export const getTenantQuota = (tenantId: string) => {
  return http.get<TenantQuota>(`/tenants/${tenantId}/quota`)
}

/**
 * 设置租户配额
 */
export const setTenantQuota = (tenantId: string, quota: Omit<TenantQuota, 'id' | 'tenantId'>) => {
  return http.post<TenantQuota>(`/tenants/${tenantId}/quota`, quota)
}

/**
 * 更新租户配额
 */
export const updateTenantQuota = (tenantId: string, quota: Partial<TenantQuota>) => {
  return http.put<TenantQuota>(`/tenants/${tenantId}/quota`, quota)
}

/**
 * 检查租户配额
 */
export const checkTenantQuota = (tenantId: string, resourceType: string, requestAmount: number) => {
  return http.post<QuotaCheckResult>(`/tenants/${tenantId}/quota/check`, {
    resourceType,
    requestAmount
  })
}

// ==================== 租户使用量统计相关API ====================

/**
 * 获取租户使用量
 */
export const getTenantUsage = (tenantId: string, period?: string) => {
  return http.get<TenantUsage>(`/tenants/${tenantId}/usage`, { period })
}

/**
 * 获取租户使用量历史
 */
export const getTenantUsageHistory = (tenantId: string, params?: {
  startTime?: string
  endTime?: string
  granularity?: 'HOUR' | 'DAY' | 'MONTH'
}) => {
  return http.get<TenantUsage[]>(`/tenants/${tenantId}/usage/history`, params)
}

/**
 * 获取租户资源使用统计
 */
export const getTenantResourceStats = (tenantId: string) => {
  return http.get<{
    accountUsage: {
      current: number
      limit: number
      percentage: number
    }
    messageUsage: {
      current: number
      limit: number
      percentage: number
    }
    apiUsage: {
      current: number
      limit: number
      percentage: number
    }
    storageUsage: {
      current: number
      limit: number
      percentage: number
    }
    bandwidthUsage: {
      current: number
      limit: number
      percentage: number
    }
    usageTrend: Array<{
      date: string
      accounts: number
      messages: number
      apiCalls: number
      storage: number
      bandwidth: number
    }>
  }>(`/tenants/${tenantId}/resource-stats`)
}

/**
 * 获取租户账单统计
 */
export const getTenantBillingStats = (tenantId: string, params?: {
  startTime?: string
  endTime?: string
}) => {
  return http.get<{
    totalCost: number
    periodCost: number
    costBreakdown: {
      accounts: number
      messages: number
      storage: number
      bandwidth: number
      other: number
    }
    billingHistory: Array<{
      period: string
      cost: number
      accounts: number
      messages: number
      paid: boolean
    }>
  }>(`/tenants/${tenantId}/billing-stats`, params)
}

// ==================== 租户配置管理相关API ====================

/**
 * 获取租户配置
 */
export const getTenantConfig = (tenantId: string) => {
  return http.get<Record<string, any>>(`/tenants/${tenantId}/config`)
}

/**
 * 更新租户配置
 */
export const updateTenantConfig = (tenantId: string, config: Record<string, any>) => {
  return http.put<void>(`/tenants/${tenantId}/config`, config)
}

/**
 * 重置租户配置为默认值
 */
export const resetTenantConfig = (tenantId: string) => {
  return http.post<void>(`/tenants/${tenantId}/config/reset`)
}

/**
 * 获取租户主题配置
 */
export const getTenantTheme = (tenantId: string) => {
  return http.get<{
    primaryColor: string
    secondaryColor: string
    logo?: string
    customCSS?: string
  }>(`/tenants/${tenantId}/theme`)
}

/**
 * 更新租户主题配置
 */
export const updateTenantTheme = (tenantId: string, theme: {
  primaryColor?: string
  secondaryColor?: string
  logo?: string
  customCSS?: string
}) => {
  return http.put<void>(`/tenants/${tenantId}/theme`, theme)
}

// ==================== 租户用户管理相关API ====================

/**
 * 获取租户用户列表
 */
export const getTenantUsers = (tenantId: string, params?: {
  keyword?: string
  role?: string
  status?: string
  page?: number
  size?: number
}) => {
  return http.get<PageResult<{
    id: string
    username: string
    nickname: string
    email: string
    phone: string
    role: string
    status: string
    lastLoginTime: string
    createdAt: string
  }>>(`/tenants/${tenantId}/users`, params)
}

/**
 * 添加用户到租户
 */
export const addUserToTenant = (tenantId: string, userId: string, role: string) => {
  return http.post<void>(`/tenants/${tenantId}/users`, { userId, role })
}

/**
 * 从租户移除用户
 */
export const removeUserFromTenant = (tenantId: string, userId: string) => {
  return http.delete<void>(`/tenants/${tenantId}/users/${userId}`)
}

/**
 * 更新租户用户角色
 */
export const updateTenantUserRole = (tenantId: string, userId: string, role: string) => {
  return http.patch<void>(`/tenants/${tenantId}/users/${userId}/role`, { role })
}