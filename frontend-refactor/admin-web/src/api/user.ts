/**
 * 用户管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  UserInfo,
  UserStatus,
  Role,
  RoleStatus,
  Permission,
  PermissionType,
  PermissionStatus,
  PageResult,
  ApiResult
} from '@/types/api'

// ==================== 用户管理 ====================

/**
 * 获取用户列表
 */
export function getUsers(params?: {
  current?: number
  size?: number
  keyword?: string
  status?: UserStatus
  roleId?: string
  departmentId?: string
  createdStartDate?: string
  createdEndDate?: string
  lastLoginStartDate?: string
  lastLoginEndDate?: string
}): Promise<ApiResult<PageResult<UserInfo>>> {
  return httpClient.get('/users', params)
}

/**
 * 获取用户详情
 */
export function getUser(userId: string): Promise<ApiResult<{
  user: UserInfo
  roles: Role[]
  permissions: Permission[]
  profile: {
    loginHistory: Array<{
      id: string
      loginTime: string
      loginIp: string
      loginLocation: string
      userAgent: string
      success: boolean
      errorMessage?: string
    }>
    operationLogs: Array<{
      id: string
      action: string
      resource: string
      details: string
      timestamp: string
      ip: string
    }>
    statistics: {
      totalLogins: number
      lastLogin: string
      accountAge: number
      operationCount: number
    }
  }
}>> {
  return httpClient.get(`/users/${userId}`)
}

/**
 * 创建用户
 */
export function createUser(data: {
  username: string
  email: string
  phone?: string
  realName: string
  nickname?: string
  avatar?: string
  departmentId?: string
  jobTitle?: string
  roleIds: string[]
  status: UserStatus
  password: string
  description?: string
}): Promise<ApiResult<{ userId: string }>> {
  return httpClient.post('/users', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新用户
 */
export function updateUser(userId: string, data: Partial<{
  email: string
  phone: string
  realName: string
  nickname: string
  avatar: string
  departmentId: string
  jobTitle: string
  roleIds: string[]
  status: UserStatus
  description: string
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/users/${userId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除用户
 */
export function deleteUser(userId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/users/${userId}`, {
    showSuccessMessage: true
  })
}

/**
 * 批量删除用户
 */
export function batchDeleteUsers(userIds: string[]): Promise<ApiResult<{
  success: number
  failed: number
  errors: Array<{ userId: string; error: string }>
}>> {
  return httpClient.post('/users/batch-delete', { userIds }, {
    showSuccessMessage: true
  })
}

/**
 * 重置用户密码
 */
export function resetUserPassword(userId: string, newPassword: string): Promise<ApiResult<void>> {
  return httpClient.post(`/users/${userId}/reset-password`, { newPassword }, {
    showSuccessMessage: true
  })
}

/**
 * 启用/禁用用户
 */
export function toggleUserStatus(userId: string, status: UserStatus): Promise<ApiResult<void>> {
  return httpClient.post(`/users/${userId}/toggle-status`, { status }, {
    showSuccessMessage: true
  })
}

/**
 * 强制用户下线
 */
export function forceUserLogout(userId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/users/${userId}/force-logout`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 解锁用户账户
 */
export function unlockUser(userId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/users/${userId}/unlock`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 分配用户角色
 */
export function assignUserRoles(userId: string, roleIds: string[]): Promise<ApiResult<void>> {
  return httpClient.post(`/users/${userId}/roles`, { roleIds }, {
    showSuccessMessage: true
  })
}

/**
 * 获取用户权限
 */
export function getUserPermissions(userId: string): Promise<ApiResult<{
  permissions: Permission[]
  effectivePermissions: string[]
  rolePermissions: Array<{
    roleId: string
    roleName: string
    permissions: Permission[]
  }>
}>> {
  return httpClient.get(`/users/${userId}/permissions`)
}

// ==================== 角色管理 ====================

/**
 * 获取角色列表
 */
export function getRoles(params?: {
  current?: number
  size?: number
  keyword?: string
  status?: RoleStatus
  type?: 'SYSTEM' | 'CUSTOM'
}): Promise<ApiResult<PageResult<Role>>> {
  return httpClient.get('/roles', params)
}

/**
 * 获取角色详情
 */
export function getRole(roleId: string): Promise<ApiResult<{
  role: Role
  permissions: Permission[]
  users: Array<{
    userId: string
    username: string
    realName: string
    avatar?: string
    status: UserStatus
  }>
  children?: Role[]
}>> {
  return httpClient.get(`/roles/${roleId}`)
}

/**
 * 创建角色
 */
export function createRole(data: {
  name: string
  code: string
  description?: string
  type: 'SYSTEM' | 'CUSTOM'
  status: RoleStatus
  permissionIds: string[]
  parentId?: string
  sort?: number
}): Promise<ApiResult<{ roleId: string }>> {
  return httpClient.post('/roles', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新角色
 */
export function updateRole(roleId: string, data: Partial<{
  name: string
  description: string
  status: RoleStatus
  permissionIds: string[]
  sort: number
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/roles/${roleId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除角色
 */
export function deleteRole(roleId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/roles/${roleId}`, {
    showSuccessMessage: true
  })
}

/**
 * 获取角色树
 */
export function getRoleTree(): Promise<ApiResult<Role[]>> {
  return httpClient.get('/roles/tree')
}

/**
 * 分配角色权限
 */
export function assignRolePermissions(roleId: string, permissionIds: string[]): Promise<ApiResult<void>> {
  return httpClient.post(`/roles/${roleId}/permissions`, { permissionIds }, {
    showSuccessMessage: true
  })
}

/**
 * 复制角色
 */
export function copyRole(roleId: string, newRoleName: string): Promise<ApiResult<{ roleId: string }>> {
  return httpClient.post(`/roles/${roleId}/copy`, { name: newRoleName }, {
    showSuccessMessage: true
  })
}

// ==================== 权限管理 ====================

/**
 * 获取权限列表
 */
export function getPermissions(params?: {
  current?: number
  size?: number
  keyword?: string
  type?: PermissionType
  status?: PermissionStatus
  parentId?: string
}): Promise<ApiResult<PageResult<Permission>>> {
  return httpClient.get('/permissions', params)
}

/**
 * 获取权限树
 */
export function getPermissionTree(): Promise<ApiResult<Permission[]>> {
  return httpClient.get('/permissions/tree')
}

/**
 * 创建权限
 */
export function createPermission(data: {
  name: string
  code: string
  type: PermissionType
  resource?: string
  action?: string
  description?: string
  parentId?: string
  sort?: number
  icon?: string
  path?: string
  component?: string
  status: PermissionStatus
}): Promise<ApiResult<{ permissionId: string }>> {
  return httpClient.post('/permissions', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新权限
 */
export function updatePermission(permissionId: string, data: Partial<{
  name: string
  description: string
  resource: string
  action: string
  sort: number
  icon: string
  path: string
  component: string
  status: PermissionStatus
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/permissions/${permissionId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除权限
 */
export function deletePermission(permissionId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/permissions/${permissionId}`, {
    showSuccessMessage: true
  })
}

// ==================== 部门管理 ====================

/**
 * 获取部门列表
 */
export function getDepartments(): Promise<ApiResult<Array<{
  id: string
  name: string
  code: string
  parentId?: string
  managerId?: string
  managerName?: string
  description?: string
  sort: number
  status: 'ACTIVE' | 'INACTIVE'
  children?: any[]
  userCount: number
  createdAt: string
}>>> {
  return httpClient.get('/departments')
}

/**
 * 获取部门树
 */
export function getDepartmentTree(): Promise<ApiResult<any[]>> {
  return httpClient.get('/departments/tree')
}

/**
 * 创建部门
 */
export function createDepartment(data: {
  name: string
  code: string
  parentId?: string
  managerId?: string
  description?: string
  sort?: number
}): Promise<ApiResult<{ departmentId: string }>> {
  return httpClient.post('/departments', data, {
    showSuccessMessage: true
  })
}

/**
 * 更新部门
 */
export function updateDepartment(departmentId: string, data: Partial<{
  name: string
  code: string
  managerId: string
  description: string
  sort: number
}>): Promise<ApiResult<void>> {
  return httpClient.put(`/departments/${departmentId}`, data, {
    showSuccessMessage: true
  })
}

/**
 * 删除部门
 */
export function deleteDepartment(departmentId: string): Promise<ApiResult<void>> {
  return httpClient.delete(`/departments/${departmentId}`, {
    showSuccessMessage: true
  })
}

/**
 * 移动部门
 */
export function moveDepartment(departmentId: string, newParentId?: string): Promise<ApiResult<void>> {
  return httpClient.post(`/departments/${departmentId}/move`, { newParentId }, {
    showSuccessMessage: true
  })
}

/**
 * 获取部门用户
 */
export function getDepartmentUsers(departmentId: string, includeChildren: boolean = false): Promise<ApiResult<UserInfo[]>> {
  return httpClient.get(`/departments/${departmentId}/users`, { includeChildren })
}

// ==================== 审计日志 ====================

/**
 * 获取操作日志
 */
export function getOperationLogs(params?: {
  current?: number
  size?: number
  userId?: string
  username?: string
  action?: string
  resource?: string
  startDate?: string
  endDate?: string
  ip?: string
  success?: boolean
}): Promise<ApiResult<PageResult<{
  id: string
  userId: string
  username: string
  realName: string
  action: string
  resource: string
  resourceId?: string
  details: string
  result: 'SUCCESS' | 'FAILURE'
  errorMessage?: string
  ip: string
  userAgent: string
  timestamp: string
  duration: number
}>>> {
  return httpClient.get('/audit/operation-logs', params)
}

/**
 * 获取登录日志
 */
export function getLoginLogs(params?: {
  current?: number
  size?: number
  userId?: string
  username?: string
  startDate?: string
  endDate?: string
  ip?: string
  success?: boolean
  location?: string
}): Promise<ApiResult<PageResult<{
  id: string
  userId: string
  username: string
  realName: string
  loginTime: string
  logoutTime?: string
  ip: string
  location: string
  userAgent: string
  success: boolean
  errorMessage?: string
  sessionDuration?: number
}>>> {
  return httpClient.get('/audit/login-logs', params)
}

/**
 * 获取审计统计
 */
export function getAuditStatistics(timeRange?: {
  startDate: string
  endDate: string
}): Promise<ApiResult<{
  operationStats: {
    total: number
    success: number
    failure: number
    topActions: Array<{
      action: string
      count: number
    }>
    timeline: Array<{
      date: string
      success: number
      failure: number
    }>
  }
  loginStats: {
    total: number
    success: number
    failure: number
    uniqueUsers: number
    topLocations: Array<{
      location: string
      count: number
    }>
    timeline: Array<{
      date: string
      success: number
      failure: number
    }>
  }
  userStats: {
    totalUsers: number
    activeUsers: number
    newUsers: number
    topUsers: Array<{
      userId: string
      username: string
      realName: string
      operationCount: number
      loginCount: number
    }>
  }
  riskEvents: Array<{
    id: string
    type: 'MULTIPLE_FAILED_LOGINS' | 'SUSPICIOUS_OPERATION' | 'UNUSUAL_ACCESS'
    userId: string
    username: string
    description: string
    severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL'
    timestamp: string
    handled: boolean
  }>
}>> {
  return httpClient.get('/audit/statistics', timeRange)
}

/**
 * 导出审计日志
 */
export function exportAuditLogs(params: {
  type: 'OPERATION' | 'LOGIN'
  format: 'EXCEL' | 'CSV'
  startDate?: string
  endDate?: string
  filters?: Record<string, any>
}): Promise<ApiResult<{
  downloadUrl: string
  fileName: string
  fileSize: number
}>> {
  return httpClient.post('/audit/export', params, {
    showSuccessMessage: true
  })
}

// ==================== 在线用户管理 ====================

/**
 * 获取在线用户列表
 */
export function getOnlineUsers(params?: {
  current?: number
  size?: number
  keyword?: string
}): Promise<ApiResult<PageResult<{
  userId: string
  username: string
  realName: string
  avatar?: string
  sessionId: string
  loginTime: string
  lastActiveTime: string
  ip: string
  location: string
  userAgent: string
  deviceType: 'WEB' | 'MOBILE' | 'APP'
  status: 'ACTIVE' | 'IDLE' | 'AWAY'
}>>> {
  return httpClient.get('/users/online', params)
}

/**
 * 强制用户下线
 */
export function forceUserOffline(sessionId: string): Promise<ApiResult<void>> {
  return httpClient.post(`/users/online/${sessionId}/force-offline`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 批量强制用户下线
 */
export function batchForceOffline(sessionIds: string[]): Promise<ApiResult<{
  success: number
  failed: number
}>> {
  return httpClient.post('/users/online/batch-force-offline', { sessionIds }, {
    showSuccessMessage: true
  })
}

/**
 * 发送系统消息给在线用户
 */
export function sendSystemMessage(data: {
  userIds?: string[]
  sessionIds?: string[]
  title: string
  content: string
  type: 'INFO' | 'WARNING' | 'ERROR' | 'SUCCESS'
  urgent: boolean
}): Promise<ApiResult<{
  sentCount: number
  failedCount: number
}>> {
  return httpClient.post('/users/online/send-message', data, {
    showSuccessMessage: true
  })
}

// ==================== 用户导入导出 ====================

/**
 * 获取用户导入模板
 */
export function getUserImportTemplate(): Promise<ApiResult<{
  downloadUrl: string
  fileName: string
}>> {
  return httpClient.get('/users/import-template')
}

/**
 * 导入用户
 */
export function importUsers(file: File): Promise<ApiResult<{
  total: number
  success: number
  failed: number
  errors: Array<{
    row: number
    field: string
    value: string
    error: string
  }>
  importId: string
}>> {
  return httpClient.upload('/users/import', file, undefined, {
    showSuccessMessage: true
  })
}

/**
 * 获取导入结果
 */
export function getImportResult(importId: string): Promise<ApiResult<{
  status: 'PROCESSING' | 'COMPLETED' | 'FAILED'
  total: number
  processed: number
  success: number
  failed: number
  errors: Array<{
    row: number
    field: string
    value: string
    error: string
  }>
  downloadUrl?: string
}>> {
  return httpClient.get(`/users/import/${importId}/result`)
}

/**
 * 导出用户
 */
export function exportUsers(params?: {
  format: 'EXCEL' | 'CSV'
  filters?: {
    keyword?: string
    status?: UserStatus
    roleId?: string
    departmentId?: string
  }
  fields?: string[]
}): Promise<ApiResult<{
  downloadUrl: string
  fileName: string
  fileSize: number
}>> {
  return httpClient.post('/users/export', params, {
    showSuccessMessage: true
  })
}

// ==================== 系统配置 ====================

/**
 * 获取用户管理配置
 */
export function getUserManagementConfig(): Promise<ApiResult<{
  passwordPolicy: {
    minLength: number
    requireUppercase: boolean
    requireLowercase: boolean
    requireNumbers: boolean
    requireSpecialChars: boolean
    expireDays: number
    preventReuse: number
  }
  accountSecurity: {
    maxFailedAttempts: number
    lockoutDuration: number
    sessionTimeout: number
    forcePasswordChange: boolean
    twoFactorRequired: boolean
  }
  registrationSettings: {
    allowSelfRegistration: boolean
    defaultRole: string
    requireEmailVerification: boolean
    requireApproval: boolean
  }
  auditSettings: {
    enableOperationLog: boolean
    enableLoginLog: boolean
    logRetentionDays: number
    sensitiveOperations: string[]
  }
}>> {
  return httpClient.get('/users/config')
}

/**
 * 更新用户管理配置
 */
export function updateUserManagementConfig(config: {
  passwordPolicy?: any
  accountSecurity?: any
  registrationSettings?: any
  auditSettings?: any
}): Promise<ApiResult<void>> {
  return httpClient.put('/users/config', config, {
    showSuccessMessage: true
  })
}