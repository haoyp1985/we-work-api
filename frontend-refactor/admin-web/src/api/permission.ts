/**
 * 权限管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult, 
  PageResult 
} from '@/types/api'

// 权限信息
export interface Permission {
  id: string
  name: string
  code: string
  type: 'menu' | 'button' | 'api'
  parentId?: string
  path?: string
  icon?: string
  sort?: number
  status: 'enabled' | 'disabled'
  description?: string
  children?: Permission[]
  createdAt: string
  updatedAt?: string
}

// 权限查询参数
export interface PermissionQuery {
  keyword?: string
  type?: 'menu' | 'button' | 'api'
  status?: 'enabled' | 'disabled'
  parentId?: string
}

// 创建权限请求
export interface CreatePermissionRequest {
  name: string
  code: string
  type: 'menu' | 'button' | 'api'
  parentId?: string
  path?: string
  icon?: string
  sort?: number
  status?: 'enabled' | 'disabled'
  description?: string
}

// 更新权限请求
export interface UpdatePermissionRequest {
  name?: string
  description?: string
  path?: string
  icon?: string
  sort?: number
  status?: 'enabled' | 'disabled'
}

/**
 * 获取权限列表（树形结构）
 */
export function getPermissionList(params?: PermissionQuery): Promise<ApiResult<Permission[]>> {
  return httpClient.get<Permission[]>('/permissions', { params })
}

/**
 * 获取权限树
 */
export function getPermissionTree(): Promise<ApiResult<Permission[]>> {
  return httpClient.get<Permission[]>('/permissions/tree')
}

/**
 * 根据ID获取权限详情
 */
export function getPermissionById(permissionId: string): Promise<ApiResult<Permission>> {
  return httpClient.get<Permission>(`/permissions/${permissionId}`)
}

/**
 * 创建权限
 */
export function createPermission(data: CreatePermissionRequest): Promise<ApiResult<Permission>> {
  return httpClient.post<Permission>('/permissions', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新权限
 */
export function updatePermission(permissionId: string, data: UpdatePermissionRequest): Promise<ApiResult<Permission>> {
  return httpClient.put<Permission>(`/permissions/${permissionId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除权限
 */
export function deletePermission(permissionId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/permissions/${permissionId}`, {
    showSuccessMessage: true
  })
}

/**
 * 启用/禁用权限
 */
export function updatePermissionStatus(permissionId: string, status: 'enabled' | 'disabled'): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/permissions/${permissionId}/status`, null, {
    params: { status },
    showSuccessMessage: true
  })
}

/**
 * 获取菜单权限（用于前端菜单渲染）
 */
export function getMenuPermissions(): Promise<ApiResult<Permission[]>> {
  return httpClient.get<Permission[]>('/permissions/menus')
}

/**
 * 检查权限
 */
export function checkPermission(permissionCode: string): Promise<ApiResult<boolean>> {
  return httpClient.get<boolean>('/permissions/check', {
    params: { permission: permissionCode }
  })
}

/**
 * 批量检查权限
 */
export function checkPermissions(permissionCodes: string[]): Promise<ApiResult<Record<string, boolean>>> {
  return httpClient.post<Record<string, boolean>>('/permissions/batch-check', {
    permissions: permissionCodes
  })
}