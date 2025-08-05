/**
 * 认证相关API
 * WeWork Management Platform - Frontend
 */

import request from '@/utils/request'
import type { 
  ApiResponse,
  LoginForm,
  LoginResponse,
  RefreshTokenResponse,
  User,
  Role,
  Permission,
  ChangePasswordForm,
  UserProfileForm,
  CaptchaResponse
} from '@/types'

/**
 * 认证API接口
 */
export const authApi = {
  /**
   * 用户登录
   */
  login(data: LoginForm): Promise<ApiResponse<LoginResponse>> {
    return request.post('/auth/login', data)
  },

  /**
   * 用户登出
   */
  logout(): Promise<ApiResponse<void>> {
    return request.post('/auth/logout')
  },

  /**
   * 刷新Token
   */
  refreshToken(): Promise<ApiResponse<RefreshTokenResponse>> {
    return request.post('/auth/refresh-token')
  },

  /**
   * 获取用户信息
   */
  getUserInfo(): Promise<ApiResponse<{
    userInfo: User
    roles: Role[]
    permissions: Permission[]
  }>> {
    return request.get('/auth/user-info')
  },

  /**
   * 更新用户资料
   */
  updateProfile(data: UserProfileForm): Promise<ApiResponse<User>> {
    return request.put('/auth/profile', data)
  },

  /**
   * 修改密码
   */
  changePassword(data: ChangePasswordForm): Promise<ApiResponse<void>> {
    return request.put('/auth/change-password', data)
  },

  /**
   * 上传头像
   */
  uploadAvatar(file: File): Promise<ApiResponse<{ avatarUrl: string }>> {
    const formData = new FormData()
    formData.append('avatar', file)
    return request.post('/auth/upload-avatar', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  /**
   * 获取验证码
   */
  getCaptcha(): Promise<ApiResponse<CaptchaResponse>> {
    return request.get('/auth/captcha')
  },

  /**
   * 发送邮箱验证码
   */
  sendEmailCode(email: string): Promise<ApiResponse<void>> {
    return request.post('/auth/send-email-code', { email })
  },

  /**
   * 发送手机验证码
   */
  sendSmsCode(phone: string): Promise<ApiResponse<void>> {
    return request.post('/auth/send-sms-code', { phone })
  },

  /**
   * 验证邮箱验证码
   */
  verifyEmailCode(email: string, code: string): Promise<ApiResponse<void>> {
    return request.post('/auth/verify-email-code', { email, code })
  },

  /**
   * 验证手机验证码
   */
  verifySmsCode(phone: string, code: string): Promise<ApiResponse<void>> {
    return request.post('/auth/verify-sms-code', { phone, code })
  },

  /**
   * 忘记密码 - 发送重置链接
   */
  forgotPassword(email: string): Promise<ApiResponse<void>> {
    return request.post('/auth/forgot-password', { email })
  },

  /**
   * 重置密码
   */
  resetPassword(token: string, password: string): Promise<ApiResponse<void>> {
    return request.post('/auth/reset-password', { token, password })
  },

  /**
   * 绑定第三方账号
   */
  bindOAuth(provider: string, code: string): Promise<ApiResponse<void>> {
    return request.post('/auth/bind-oauth', { provider, code })
  },

  /**
   * 解绑第三方账号
   */
  unbindOAuth(provider: string): Promise<ApiResponse<void>> {
    return request.delete(`/auth/unbind-oauth/${provider}`)
  },

  /**
   * 获取OAuth授权URL
   */
  getOAuthUrl(provider: string, redirectUri?: string): Promise<ApiResponse<{ url: string }>> {
    return request.get(`/auth/oauth-url/${provider}`, {
      params: { redirectUri }
    })
  },

  /**
   * 检查用户名是否可用
   */
  checkUsername(username: string): Promise<ApiResponse<{ available: boolean }>> {
    return request.get('/auth/check-username', {
      params: { username }
    })
  },

  /**
   * 检查邮箱是否可用
   */
  checkEmail(email: string): Promise<ApiResponse<{ available: boolean }>> {
    return request.get('/auth/check-email', {
      params: { email }
    })
  },

  /**
   * 获取登录记录
   */
  getLoginHistory(params?: {
    pageNum?: number
    pageSize?: number
    startDate?: string
    endDate?: string
  }): Promise<ApiResponse<any>> {
    return request.get('/auth/login-history', { params })
  },

  /**
   * 获取在线会话
   */
  getActiveSessions(): Promise<ApiResponse<any[]>> {
    return request.get('/auth/active-sessions')
  },

  /**
   * 踢出指定会话
   */
  killSession(sessionId: string): Promise<ApiResponse<void>> {
    return request.delete(`/auth/sessions/${sessionId}`)
  },

  /**
   * 踢出所有其他会话
   */
  killOtherSessions(): Promise<ApiResponse<void>> {
    return request.delete('/auth/other-sessions')
  },

  /**
   * 启用两步验证
   */
  enableTwoFactor(): Promise<ApiResponse<{
    qrCode: string
    secret: string
    backupCodes: string[]
  }>> {
    return request.post('/auth/enable-2fa')
  },

  /**
   * 确认启用两步验证
   */
  confirmTwoFactor(code: string): Promise<ApiResponse<void>> {
    return request.post('/auth/confirm-2fa', { code })
  },

  /**
   * 禁用两步验证
   */
  disableTwoFactor(password: string): Promise<ApiResponse<void>> {
    return request.post('/auth/disable-2fa', { password })
  },

  /**
   * 验证两步验证代码
   */
  verifyTwoFactor(code: string): Promise<ApiResponse<void>> {
    return request.post('/auth/verify-2fa', { code })
  },

  /**
   * 获取备用恢复代码
   */
  getBackupCodes(): Promise<ApiResponse<{ codes: string[] }>> {
    return request.get('/auth/backup-codes')
  },

  /**
   * 重新生成备用恢复代码
   */
  regenerateBackupCodes(): Promise<ApiResponse<{ codes: string[] }>> {
    return request.post('/auth/regenerate-backup-codes')
  }
}