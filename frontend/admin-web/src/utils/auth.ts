import Cookies from 'js-cookie'

const TokenKey = 'wework-admin-token'
const RefreshTokenKey = 'wework-admin-refresh-token'

/**
 * 获取Token
 */
export function getToken(): string | undefined {
  return Cookies.get(TokenKey)
}

/**
 * 设置Token
 */
export function setToken(token: string): void {
  Cookies.set(TokenKey, token, { expires: 7 })
}

/**
 * 移除Token
 */
export function removeToken(): void {
  Cookies.remove(TokenKey)
  Cookies.remove(RefreshTokenKey)
}

/**
 * 获取刷新Token
 */
export function getRefreshToken(): string | undefined {
  return Cookies.get(RefreshTokenKey)
}

/**
 * 设置刷新Token
 */
export function setRefreshToken(token: string): void {
  Cookies.set(RefreshTokenKey, token, { expires: 30 })
}

/**
 * 检查Token是否过期
 */
export function isTokenExpired(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    const exp = payload.exp * 1000
    return Date.now() >= exp
  } catch {
    return true
  }
}

/**
 * 从Token中获取用户信息
 */
export function parseTokenPayload(token: string): any {
  try {
    return JSON.parse(atob(token.split('.')[1]))
  } catch {
    return null
  }
}