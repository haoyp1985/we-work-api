/**
 * 认证相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  LoginRequest, 
  LoginResponse, 
  UserInfo,
  ApiResult 
} from '@/types/api'

/**
 * 用户登录
 */
export function login(data: LoginRequest): Promise<ApiResult<LoginResponse>> {
  return httpClient.post<LoginResponse>('/auth/login', data, {
    skipAuth: true,
    showSuccessMessage: true
  })
}

/**
 * 用户登出
 */
export function logout(): Promise<ApiResult<void>> {
  return httpClient.post<void>('/auth/logout')
}

/**
 * 获取当前用户信息
 */
export function getCurrentUser(): Promise<ApiResult<UserInfo>> {
  return httpClient.get<UserInfo>('/auth/user-info')
}

/**
 * 刷新访问令牌
 */
export function refreshToken(refreshToken: string): Promise<ApiResult<string>> {
  return httpClient.post<string>('/auth/refresh', null, {
    params: { refreshToken },
    skipAuth: true
  })
}

/**
 * 修改密码
 */
export function changePassword(data: {
  oldPassword: string
  newPassword: string
}): Promise<ApiResult<void>> {
  return httpClient.post<void>('/auth/change-password', data, {
    showSuccessMessage: true
  })
}

/**
 * 重置密码（发送重置邮件）
 */
export function resetPassword(email: string): Promise<ApiResult<void>> {
  return httpClient.post<void>('/auth/reset-password', {
    email
  }, {
    skipAuth: true,
    showSuccessMessage: true
  })
}

/**
 * 确认重置密码
 */
export function confirmResetPassword(data: {
  token: string
  newPassword: string
}): Promise<ApiResult<void>> {
  return httpClient.post<void>('/auth/confirm-reset-password', data, {
    skipAuth: true,
    showSuccessMessage: true
  })
}

/**
 * 更新用户资料
 */
export function updateProfile(data: {
  realName?: string
  email?: string
  phone?: string
  avatar?: string
}): Promise<ApiResult<UserInfo>> {
  return httpClient.put<UserInfo>('/auth/profile', data, {
    showSuccessMessage: true
  })
}

/**
 * 获取验证码
 */
export function getCaptcha(): Promise<ApiResult<{
  captchaId: string
  captchaImage: string
}>> {
  return httpClient.get('/auth/captcha', {}, {
    skipAuth: true
  })
}

/**
 * 验证token有效性
 */
export function validateToken(): Promise<ApiResult<{
  valid: boolean
  expiresIn: number
}>> {
  return httpClient.get('/auth/validate')
}

/**
 * 获取用户权限列表
 */
export function getUserPermissions(): Promise<ApiResult<string[]>> {
  return httpClient.get<string[]>('/auth/permissions')
}

/**
 * 获取用户菜单权限
 */
export function getUserMenus(): Promise<ApiResult<any[]>> {
  return httpClient.get<any[]>('/auth/menus')
}

/**
 * 启用/禁用二次验证
 */
export function toggleTwoFactorAuth(enabled: boolean): Promise<ApiResult<{
  qrCode?: string
  backupCodes?: string[]
}>> {
  return httpClient.post('/auth/2fa/toggle', {
    enabled
  }, {
    showSuccessMessage: true
  })
}

/**
 * 验证二次验证码
 */
export function verifyTwoFactorCode(code: string): Promise<ApiResult<void>> {
  return httpClient.post<void>('/auth/2fa/verify', {
    code
  })
}
