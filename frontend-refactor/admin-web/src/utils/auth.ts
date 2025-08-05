/**
 * 认证相关工具函数
 */

import { STORAGE_KEYS } from '@/constants';
import type { UserInfo } from '@/types/user';

/**
 * 获取Token
 */
export function getToken(): string | null {
  return localStorage.getItem(STORAGE_KEYS.TOKEN);
}

/**
 * 设置Token
 */
export function setToken(token: string): void {
  localStorage.setItem(STORAGE_KEYS.TOKEN, token);
}

/**
 * 移除Token
 */
export function removeToken(): void {
  localStorage.removeItem(STORAGE_KEYS.TOKEN);
}

/**
 * 获取用户信息
 */
export function getUserInfo(): UserInfo | null {
  const userInfoStr = localStorage.getItem(STORAGE_KEYS.USER_INFO);
  if (userInfoStr) {
    try {
      return JSON.parse(userInfoStr);
    } catch (error) {
      console.error('Failed to parse user info from localStorage:', error);
      removeUserInfo();
      return null;
    }
  }
  return null;
}

/**
 * 设置用户信息
 */
export function setUserInfo(userInfo: UserInfo): void {
  localStorage.setItem(STORAGE_KEYS.USER_INFO, JSON.stringify(userInfo));
}

/**
 * 移除用户信息
 */
export function removeUserInfo(): void {
  localStorage.removeItem(STORAGE_KEYS.USER_INFO);
}

/**
 * 清除所有认证信息
 */
export function clearAuth(): void {
  removeToken();
  removeUserInfo();
}

/**
 * 检查是否已登录
 */
export function isLoggedIn(): boolean {
  const token = getToken();
  const userInfo = getUserInfo();
  return !!(token && userInfo);
}

/**
 * 检查Token是否过期
 */
export function isTokenExpired(): boolean {
  const token = getToken();
  if (!token) return true;

  try {
    // 解析JWT Token的payload部分
    const payload = JSON.parse(atob(token.split('.')[1]));
    const currentTime = Math.floor(Date.now() / 1000);
    
    // 检查exp字段
    if (payload.exp && payload.exp < currentTime) {
      return true;
    }
    
    return false;
  } catch (error) {
    console.error('Failed to parse token:', error);
    return true;
  }
}

/**
 * 获取Token的有效期剩余时间（秒）
 */
export function getTokenRemainingTime(): number {
  const token = getToken();
  if (!token) return 0;

  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    const currentTime = Math.floor(Date.now() / 1000);
    
    if (payload.exp) {
      return Math.max(0, payload.exp - currentTime);
    }
    
    return 0;
  } catch (error) {
    console.error('Failed to parse token:', error);
    return 0;
  }
}

/**
 * 自动刷新Token（如果快要过期）
 */
export function autoRefreshToken(): boolean {
  const remainingTime = getTokenRemainingTime();
  const refreshThreshold = 5 * 60; // 5分钟
  
  if (remainingTime > 0 && remainingTime < refreshThreshold) {
    // 可以在这里调用刷新Token的API
    console.log('Token将在', remainingTime, '秒后过期，建议刷新');
    return true;
  }
  
  return false;
}

/**
 * 检查权限
 */
export function hasPermission(permission: string): boolean {
  const userInfo = getUserInfo();
  if (!userInfo) return false;
  
  // 这里可以根据实际的权限结构进行判断
  // 假设用户信息中有permissions字段
  if ('permissions' in userInfo && Array.isArray(userInfo.permissions)) {
    return userInfo.permissions.includes(permission);
  }
  
  return false;
}

/**
 * 检查角色
 */
export function hasRole(role: string): boolean {
  const userInfo = getUserInfo();
  if (!userInfo) return false;
  
  // 这里可以根据实际的角色结构进行判断
  // 假设用户信息中有roles字段
  if ('roles' in userInfo && Array.isArray(userInfo.roles)) {
    return userInfo.roles.includes(role);
  }
  
  return false;
}

/**
 * 检查是否为管理员
 */
export function isAdmin(): boolean {
  return hasRole('admin') || hasRole('super_admin');
}

/**
 * 格式化权限代码
 */
export function formatPermissionCode(module: string, action: string): string {
  return `${module}:${action}`;
}

/**
 * 检查多个权限（需要全部满足）
 */
export function hasAllPermissions(permissions: string[]): boolean {
  return permissions.every(permission => hasPermission(permission));
}

/**
 * 检查多个权限（满足其中一个即可）
 */
export function hasAnyPermission(permissions: string[]): boolean {
  return permissions.some(permission => hasPermission(permission));
}

/**
 * 检查多个角色（需要全部满足）
 */
export function hasAllRoles(roles: string[]): boolean {
  return roles.every(role => hasRole(role));
}

/**
 * 检查多个角色（满足其中一个即可）
 */
export function hasAnyRole(roles: string[]): boolean {
  return roles.some(role => hasRole(role));
}