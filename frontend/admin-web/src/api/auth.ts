import { http } from '@/utils/request'
import type { LoginRequest, LoginResponse, UserInfo } from '@/types'

/**
 * 用户登录
 */
export const login = (data: LoginRequest) => {
  return http.post<LoginResponse>('/accounts/login', data)
}

/**
 * 用户登出
 */
export const logout = () => {
  return http.post('/accounts/logout')
}

/**
 * 获取用户信息
 */
export const getUserInfo = () => {
  return http.get<UserInfo>('/accounts/profile')
}

/**
 * 获取登录二维码
 */
export const getLoginQrCode = () => {
  return http.get<{ qrCode: string; key: string }>('/accounts/qr-code')
}

/**
 * 验证二维码登录
 */
export const verifyQrCode = (key: string) => {
  return http.post<LoginResponse>('/accounts/qr-verify', { key })
}

/**
 * 刷新Token
 */
export const refreshToken = () => {
  return http.post<{ token: string; refreshToken: string }>('/auth/refresh')
}