/**
 * 用户相关类型定义
 * WeWork Management Platform - Frontend
 */

import type { BaseEntity, PageQuery } from './index'

// ===== 用户基础类型 =====

/**
 * 用户状态
 */
export type UserStatus = 'active' | 'inactive' | 'locked' | 'expired'

/**
 * 用户性别
 */
export type UserGender = 'male' | 'female' | 'unknown'

/**
 * 权限类型
 */
export type PermissionType = 'MENU' | 'BUTTON' | 'API' | 'DATA'

/**
 * 用户实体
 */
export interface User extends BaseEntity {
  username: string
  nickname: string
  email: string
  phone: string
  avatar: string
  gender?: UserGender
  birthday?: string
  status: UserStatus
  lastLoginAt?: string
  loginCount?: number
  remark?: string
}

/**
 * 角色实体
 */
export interface Role extends BaseEntity {
  roleCode: string
  roleName: string
  description?: string
  status: 'active' | 'inactive'
  sort: number
  permissions?: Permission[]
}

/**
 * 权限实体
 */
export interface Permission extends BaseEntity {
  permissionCode: string
  permissionName: string
  permissionType: PermissionType
  parentId?: string
  path?: string
  component?: string
  icon?: string
  sort: number
  status: 'active' | 'inactive'
  children?: Permission[]
}

// ===== 认证相关 =====

/**
 * 登录表单
 */
export interface LoginForm {
  username: string
  password: string
  captcha?: string
  captchaId?: string
  rememberMe?: boolean
}

/**
 * 登录响应数据
 */
export interface LoginResponse {
  token: string
  refreshToken: string
  expiresIn: number
  userInfo: User
  roles: Role[]
  permissions: Permission[]
}

/**
 * 刷新Token请求
 */
export interface RefreshTokenRequest {
  refreshToken: string
}

/**
 * 刷新Token响应
 */
export interface RefreshTokenResponse {
  token: string
  refreshToken: string
  expiresIn: number
}

/**
 * 修改密码表单
 */
export interface ChangePasswordForm {
  oldPassword: string
  newPassword: string
  confirmPassword: string
}

/**
 * 重置密码表单
 */
export interface ResetPasswordForm {
  email: string
  code: string
  newPassword: string
  confirmPassword: string
}

/**
 * 验证码响应
 */
export interface CaptchaResponse {
  captchaId: string
  captchaImage: string
}

// ===== 用户管理 =====

/**
 * 用户查询表单
 */
export interface UserSearchForm extends PageQuery {
  username?: string
  nickname?: string
  email?: string
  phone?: string
  status?: UserStatus
  startDate?: string
  endDate?: string
  roleId?: string
}

/**
 * 用户创建表单
 */
export interface UserCreateForm {
  username: string
  nickname: string
  email: string
  phone: string
  password: string
  avatar?: string
  gender?: UserGender
  status: UserStatus
  roleIds: string[]
  remark?: string
}

/**
 * 用户更新表单
 */
export interface UserUpdateForm {
  nickname: string
  email: string
  phone: string
  avatar?: string
  gender?: UserGender
  status: UserStatus
  roleIds: string[]
  remark?: string
}

/**
 * 用户资料更新表单
 */
export interface UserProfileForm {
  nickname: string
  email: string
  phone: string
  avatar?: string
  gender?: UserGender
  birthday?: string
}

/**
 * 用户角色关联
 */
export interface UserRole {
  userId: string
  roleId: string
  user?: User
  role?: Role
  assignedAt: string
  assignedBy: string
}

// ===== 角色管理 =====

/**
 * 角色查询表单
 */
export interface RoleSearchForm extends PageQuery {
  roleName?: string
  roleCode?: string
  status?: 'active' | 'inactive'
}

/**
 * 角色创建表单
 */
export interface RoleCreateForm {
  roleCode: string
  roleName: string
  description?: string
  status: 'active' | 'inactive'
  sort: number
  permissionIds: string[]
}

/**
 * 角色更新表单
 */
export interface RoleUpdateForm {
  roleName: string
  description?: string
  status: 'active' | 'inactive'
  sort: number
  permissionIds: string[]
}

/**
 * 角色权限关联
 */
export interface RolePermission {
  roleId: string
  permissionId: string
  role?: Role
  permission?: Permission
  assignedAt: string
  assignedBy: string
}

// ===== 权限管理 =====

/**
 * 权限查询表单
 */
export interface PermissionSearchForm extends PageQuery {
  permissionName?: string
  permissionCode?: string
  permissionType?: PermissionType
  status?: 'active' | 'inactive'
}

/**
 * 权限创建表单
 */
export interface PermissionCreateForm {
  permissionCode: string
  permissionName: string
  permissionType: PermissionType
  parentId?: string
  path?: string
  component?: string
  icon?: string
  sort: number
  status: 'active' | 'inactive'
}

/**
 * 权限更新表单
 */
export interface PermissionUpdateForm {
  permissionName: string
  permissionType: PermissionType
  parentId?: string
  path?: string
  component?: string
  icon?: string
  sort: number
  status: 'active' | 'inactive'
}

/**
 * 权限树节点
 */
export interface PermissionTreeNode {
  id: string
  label: string
  value: string
  type: PermissionType
  disabled?: boolean
  children?: PermissionTreeNode[]
}

// ===== 用户会话 =====

/**
 * 用户会话信息
 */
export interface UserSession {
  id: string
  userId: string
  sessionId: string
  userAgent: string
  ipAddress: string
  location?: string
  loginAt: string
  lastAccessAt: string
  expiresAt: string
  status: 'active' | 'expired' | 'killed'
}

/**
 * 在线用户
 */
export interface OnlineUser {
  userId: string
  username: string
  nickname: string
  avatar: string
  sessionId: string
  ipAddress: string
  location?: string
  loginAt: string
  lastAccessAt: string
}

// ===== 用户日志 =====

/**
 * 登录日志
 */
export interface LoginLog {
  id: string
  userId: string
  username: string
  ipAddress: string
  userAgent: string
  location?: string
  loginAt: string
  status: 'success' | 'failed'
  failReason?: string
}

/**
 * 操作日志
 */
export interface OperationLog {
  id: string
  userId: string
  username: string
  action: string
  resource: string
  resourceId?: string
  method: string
  url: string
  ipAddress: string
  userAgent: string
  params?: any
  result?: any
  status: 'success' | 'failed'
  errorMessage?: string
  duration: number
  createdAt: string
}

// ===== 用户统计 =====

/**
 * 用户统计
 */
export interface UserStatistics {
  totalUsers: number
  activeUsers: number
  inactiveUsers: number
  lockedUsers: number
  newUsersToday: number
  loginUsersToday: number
  onlineUsers: number
  userGrowthChart: Array<{
    date: string
    count: number
  }>
}

/**
 * 角色统计
 */
export interface RoleStatistics {
  totalRoles: number
  activeRoles: number
  userDistribution: Array<{
    roleName: string
    userCount: number
  }>
}

// ===== 用户偏好设置 =====

/**
 * 用户偏好设置
 */
export interface UserPreferences {
  // 界面设置
  theme: 'light' | 'dark' | 'auto'
  language: 'zh-CN' | 'en-US'
  fontSize: 'small' | 'medium' | 'large'
  
  // 通知设置
  emailNotification: boolean
  smsNotification: boolean
  pushNotification: boolean
  
  // 安全设置
  twoFactorAuth: boolean
  sessionTimeout: number
  allowMultipleLogin: boolean
  
  // 个性化设置
  homepage: string
  itemsPerPage: number
  dateFormat: string
  timeFormat: string
  timezone: string
  
  // 其他设置
  [key: string]: any
}

// ===== 第三方登录 =====

/**
 * OAuth提供商
 */
export type OAuthProvider = 'github' | 'google' | 'wechat' | 'dingtalk'

/**
 * 第三方登录信息
 */
export interface OAuthInfo {
  provider: OAuthProvider
  providerId: string
  providerName: string
  avatar?: string
  email?: string
  bindAt: string
}

/**
 * 第三方登录绑定表单
 */
export interface OAuthBindForm {
  provider: OAuthProvider
  code: string
  state: string
}

// ===== 部门组织 =====

/**
 * 部门实体
 */
export interface Department extends BaseEntity {
  departmentCode: string
  departmentName: string
  parentId?: string
  sort: number
  description?: string
  status: 'active' | 'inactive'
  children?: Department[]
}

/**
 * 用户部门关联
 */
export interface UserDepartment {
  userId: string
  departmentId: string
  user?: User
  department?: Department
  position?: string
  isPrimary: boolean
  joinAt: string
}