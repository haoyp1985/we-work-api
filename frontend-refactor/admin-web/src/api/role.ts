/**
 * 角色管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult, 
  PageResult 
} from '@/types/api'

// 角色信息
export interface Role {
  id: string
  name: string
  code: string
  description?: string
  status: 'enabled' | 'disabled'
  userCount?: number
  permissions?: string[]
  createdAt: string
  updatedAt?: string
}

// 角色查询参数
export interface RoleQuery {
  pageNum?: number
  pageSize?: number
  keyword?: string
}

// 创建角色请求
export interface CreateRoleRequest {
  name: string
  code: string
  description?: string
  status?: 'enabled' | 'disabled'
  permissionIds?: string[]
}

// 更新角色请求
export interface UpdateRoleRequest {
  name?: string
  description?: string
  status?: 'enabled' | 'disabled'
  permissionIds?: string[]
}

/**
 * 分页查询角色列表
 */
export function getRoleList(params: RoleQuery): Promise<ApiResult<PageResult<Role>>> {
  return httpClient.get<PageResult<Role>>('/roles', { params })
}

/**
 * 查询所有角色（不分页）
 */
export function getAllRoles(): Promise<ApiResult<Role[]>> {
  return httpClient.get<Role[]>('/roles/all')
}

/**
 * 根据ID获取角色详情
 */
export function getRoleById(roleId: string): Promise<ApiResult<Role>> {
  return httpClient.get<Role>(`/roles/${roleId}`)
}

/**
 * 创建角色
 */
export function createRole(data: CreateRoleRequest): Promise<ApiResult<Role>> {
  return httpClient.post<Role>('/roles', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新角色
 */
export function updateRole(roleId: string, data: UpdateRoleRequest): Promise<ApiResult<Role>> {
  return httpClient.put<Role>(`/roles/${roleId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除角色
 */
export function deleteRole(roleId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/roles/${roleId}`, {
    showSuccessMessage: true
  })
}

/**
 * 启用/禁用角色
 */
export function updateRoleStatus(roleId: string, status: 'enabled' | 'disabled'): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/roles/${roleId}/status`, null, {
    params: { status },
    showSuccessMessage: true
  })
}

/**
 * 分配角色权限
 */
export function assignRolePermissions(roleId: string, permissionIds: string[]): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/roles/${roleId}/permissions`, permissionIds, {
    showSuccessMessage: true
  })
}

/**
 * 获取角色权限
 */
export function getRolePermissions(roleId: string): Promise<ApiResult<string[]>> {
  return httpClient.get<string[]>(`/roles/${roleId}/permissions`)
}

/**
 * 获取角色用户列表
 */
export function getRoleUsers(roleId: string): Promise<ApiResult<any[]>> {
  return httpClient.get<any[]>(`/roles/${roleId}/users`)
}

/**
 * 复制角色
 */
export function copyRole(roleId: string, newName: string): Promise<ApiResult<Role>> {
  return httpClient.post<Role>(`/roles/${roleId}/copy`, { name: newName }, {
    showSuccessMessage: true
  })
}