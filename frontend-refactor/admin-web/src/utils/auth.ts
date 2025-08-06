/**
 * 认证工具函数
 * 处理token的存储、获取和管理
 */

const TOKEN_KEY = 'wework_token'
const REFRESH_TOKEN_KEY = 'wework_refresh_token'
const USER_INFO_KEY = 'wework_user_info'

/**
 * 获取访问令牌
 */
export function getToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_KEY)
  } catch (error) {
    console.error('获取token失败:', error)
    return null
  }
}

/**
 * 设置访问令牌
 */
export function setToken(token: string): void {
  try {
    localStorage.setItem(TOKEN_KEY, token)
  } catch (error) {
    console.error('设置token失败:', error)
  }
}

/**
 * 移除访问令牌
 */
export function removeToken(): void {
  try {
    localStorage.removeItem(TOKEN_KEY)
  } catch (error) {
    console.error('移除token失败:', error)
  }
}

/**
 * 获取刷新令牌
 */
export function getRefreshToken(): string | null {
  try {
    return localStorage.getItem(REFRESH_TOKEN_KEY)
  } catch (error) {
    console.error('获取刷新token失败:', error)
    return null
  }
}

/**
 * 设置刷新令牌
 */
export function setRefreshToken(refreshToken: string): void {
  try {
    localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken)
  } catch (error) {
    console.error('设置刷新token失败:', error)
  }
}

/**
 * 移除刷新令牌
 */
export function removeRefreshToken(): void {
  try {
    localStorage.removeItem(REFRESH_TOKEN_KEY)
  } catch (error) {
    console.error('移除刷新token失败:', error)
  }
}

/**
 * 获取用户信息缓存
 */
export function getUserInfoCache(): any {
  try {
    const userInfo = localStorage.getItem(USER_INFO_KEY)
    return userInfo ? JSON.parse(userInfo) : null
  } catch (error) {
    console.error('获取用户信息缓存失败:', error)
    return null
  }
}

/**
 * 设置用户信息缓存
 */
export function setUserInfoCache(userInfo: any): void {
  try {
    localStorage.setItem(USER_INFO_KEY, JSON.stringify(userInfo))
  } catch (error) {
    console.error('设置用户信息缓存失败:', error)
  }
}

/**
 * 移除用户信息缓存
 */
export function removeUserInfoCache(): void {
  try {
    localStorage.removeItem(USER_INFO_KEY)
  } catch (error) {
    console.error('移除用户信息缓存失败:', error)
  }
}

/**
 * 清除所有认证信息
 */
export function clearAuth(): void {
  removeToken()
  removeRefreshToken() 
  removeUserInfoCache()
}

/**
 * 检查token是否存在
 */
export function hasToken(): boolean {
  return !!getToken()
}

/**
 * 检查token是否即将过期（基于时间戳判断）
 */
export function isTokenExpiringSoon(token: string, thresholdMinutes: number = 5): boolean {
  try {
    // 解析JWT token的payload部分
    const payload = JSON.parse(atob(token.split('.')[1]))
    const expirationTime = payload.exp * 1000 // 转换为毫秒
    const currentTime = Date.now()
    const thresholdTime = thresholdMinutes * 60 * 1000 // 阈值时间（毫秒）
    
    return (expirationTime - currentTime) <= thresholdTime
  } catch (error) {
    console.error('解析token失败:', error)
    return true // 解析失败认为即将过期
  }
}

/**
 * 获取token的过期时间
 */
export function getTokenExpiration(token: string): number | null {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return payload.exp * 1000 // 转换为毫秒时间戳
  } catch (error) {
    console.error('获取token过期时间失败:', error)
    return null
  }
}

/**
 * 获取token中的用户ID
 */
export function getUserIdFromToken(token: string): string | null {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return payload.userId || payload.sub || null
  } catch (error) {
    console.error('从token获取用户ID失败:', error)
    return null
  }
}

/**
 * 检查是否为有效的JWT token格式
 */
export function isValidJWTFormat(token: string): boolean {
  try {
    const parts = token.split('.')
    if (parts.length !== 3) {
      return false
    }
    
    // 尝试解析header和payload
    JSON.parse(atob(parts[0]))
    JSON.parse(atob(parts[1]))
    
    return true
  } catch (error) {
    return false
  }
}
