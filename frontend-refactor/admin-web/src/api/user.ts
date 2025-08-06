/**
 * 用户管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult, 
  PageResult,
  UserInfo 
} from '@/types/api'

// 用户查询参数
export interface UserQuery {
  pageNum?: number
  pageSize?: number
  keyword?: string
  status?: number
}

// 创建用户请求
export interface CreateUserRequest {
  username: string
  realName: string
  email: string
  phone?: string
  password: string
  roleIds?: string[]
  organizationId?: string
  status?: number
}

// 更新用户请求
export interface UpdateUserRequest {
  realName?: string
  email?: string
  phone?: string
  roleIds?: string[]
  organizationId?: string
  status?: number
}

/**
 * 分页查询用户列表
 */
export function getUserList(params: UserQuery): Promise<ApiResult<PageResult<UserInfo>>> {
  return httpClient.get<PageResult<UserInfo>>('/users', { params })
}

/**
 * 根据ID获取用户详情
 */
export function getUserById(userId: string): Promise<ApiResult<UserInfo>> {
  return httpClient.get<UserInfo>(`/users/${userId}`)
}

/**
 * 创建用户
 */
export function createUser(data: CreateUserRequest): Promise<ApiResult<UserInfo>> {
  return httpClient.post<UserInfo>('/users', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新用户
 */
export function updateUser(userId: string, data: UpdateUserRequest): Promise<ApiResult<UserInfo>> {
  return httpClient.put<UserInfo>(`/users/${userId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除用户
 */
export function deleteUser(userId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/users/${userId}`, {
    showSuccessMessage: true
  })
}

/**
 * 启用/禁用用户
 */
export function updateUserStatus(userId: string, status: number): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/users/${userId}/status`, null, {
    params: { status },
    showSuccessMessage: true
  })
}

/**
 * 分配用户角色
 */
export function assignUserRoles(userId: string, roleIds: string[]): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/users/${userId}/roles`, roleIds, {
    showSuccessMessage: true
  })
}

/**
 * 获取用户权限
 */
export function getUserPermissions(userId: string): Promise<ApiResult<string[]>> {
  return httpClient.get<string[]>(`/users/${userId}/permissions`)
}

/**
 * 检查用户权限
 */
export function checkUserPermission(userId: string, permission: string): Promise<ApiResult<boolean>> {
  return httpClient.get<boolean>(`/users/${userId}/check-permission`, {
    params: { permission }
  })
}

/**
 * 重置用户密码
 */
export function resetUserPassword(userId: string, newPassword: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/users/${userId}/reset-password`, {
    newPassword
  }, {
    showSuccessMessage: true
  })
}

/**
 * 批量导入用户
 */
export function importUsers(file: File): Promise<ApiResult<{
  successCount: number
  failCount: number
  errors?: string[]
}>> {
  const formData = new FormData()
  formData.append('file', file)
  
  return httpClient.post('/users/import', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    showSuccessMessage: true
  })
}

/**
 * 导出用户列表
 */
export function exportUsers(params?: UserQuery): Promise<Blob> {
  return httpClient.get('/users/export', {
    params,
    responseType: 'blob'
  })
}

/**
 * 获取用户在线状态
 */
export function getUserOnlineStatus(userIds: string[]): Promise<ApiResult<Record<string, boolean>>> {
  return httpClient.post<Record<string, boolean>>('/users/online-status', { userIds })
}

/**
 * 强制用户下线
 */
export function forceUserOffline(userId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/users/${userId}/force-offline`, null, {
    showSuccessMessage: true
  })
}