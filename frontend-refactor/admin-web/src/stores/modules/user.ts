/**
 * 用户状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import * as authApi from '@/api/auth'
import {
  getToken,
  setToken,
  getRefreshToken,
  setRefreshToken,
  setUserInfoCache,
  clearAuth,
} from '@/utils/auth'
import router from '@/router'
import * as ApiTypes from '@/types/api'

export const useUserStore = defineStore('user', () => {
  const BYPASS_AUTH = import.meta.env.VITE_BYPASS_AUTH === 'true'
  // ===== State =====
  const userInfo = ref<ApiTypes.UserInfo>({
    id: '',
    username: '',
    realName: '',
    email: '',
    phone: '',
    avatar: '',
    status: ApiTypes.UserStatus.ACTIVE,
    roles: [],
    permissions: [],
    tenantId: '',
    organizationId: '',
    createdAt: '',
    updatedAt: '',
    lastLoginAt: '',
  })

  const token = ref<string>(getToken() || '')
  const refreshTokenValue = ref<string>(getRefreshToken() || '')
  const isLoggedIn = ref<boolean>(!!getToken())

  // ===== Getters =====
  const permissionCodes = computed(() => userInfo.value.permissions)

  const roleCodes = computed(() =>
    userInfo.value.roles.map((role) => role.code),
  )

  const isAdmin = computed(() =>
    BYPASS_AUTH ||
    roleCodes.value.includes('SUPER_ADMIN') ||
    roleCodes.value.includes('TENANT_ADMIN'),
  )

  // 删除了单独的menuPermissions和buttonPermissions计算属性
  // 因为权限信息现在直接存储在userInfo中

  // ===== Actions =====

  /**
   * 用户登录
   */
  const login = async (
    loginForm: ApiTypes.LoginRequest,
  ): Promise<ApiTypes.LoginResponse> => {
    try {
      if (BYPASS_AUTH) {
        // 构造一个本地假的登录结果
        const fake: ApiTypes.LoginResponse = {
          token: 'dev-token',
          refreshToken: 'dev-refresh',
          expiresIn: 7200,
          userInfo: {
            id: 'dev-user',
            username: loginForm.username || 'dev',
            realName: 'Developer',
            email: 'dev@example.com',
            phone: '',
            avatar: '',
            status: ApiTypes.UserStatus.ACTIVE,
            roles: [
              { id: 'r-super', code: 'SUPER_ADMIN', name: '超级管理员' } as any,
              { id: 'r-tenant', code: 'TENANT_ADMIN', name: '租户管理员' } as any,
            ],
            permissions: ['*:*'],
            tenantId: import.meta.env.VITE_DEV_TENANT_ID || 'tenant-dev',
            organizationId: '',
            createdAt: '',
            updatedAt: '',
            lastLoginAt: '',
          },
        }
        token.value = fake.token
        refreshTokenValue.value = fake.refreshToken
        setToken(fake.token)
        setRefreshToken(fake.refreshToken)
        userInfo.value = fake.userInfo
        setUserInfoCache(fake.userInfo)
        isLoggedIn.value = true
        return fake
      }

      const response = await authApi.login(loginForm)
      const data = response.data

      // 设置token
      token.value = data.token
      refreshTokenValue.value = data.refreshToken
      setToken(data.token)
      setRefreshToken(data.refreshToken)

      // 设置用户信息
      userInfo.value = data.userInfo
      setUserInfoCache(data.userInfo)
      isLoggedIn.value = true

      return data
    } catch (error) {
      console.error('登录失败:', error)
      throw error
    }
  }

  /**
   * 获取用户信息
   */
  const getUserInfo = async (): Promise<ApiTypes.UserInfo> => {
    try {
      if (BYPASS_AUTH) {
        return userInfo.value
      }
      const response = await authApi.getCurrentUser()
      const userData = response.data

      userInfo.value = userData
      return userData
    } catch (error) {
      console.error('获取用户信息失败:', error)
      // 清除无效token
      logout()
      throw error
    }
  }

  /**
   * 刷新Token
   */
  const _refreshToken = async (): Promise<string> => {
    try {
      const response = await authApi.refreshToken(refreshTokenValue.value)

      if (response.code === 200) {
        const newToken = response.data
        token.value = newToken
        setToken(newToken)
        return newToken
      } else {
        throw new Error('Token刷新失败')
      }
    } catch (error) {
      console.error('Token刷新失败:', error)
      logout()
      throw error
    }
  }

  /**
   * 用户登出
   */
  const logout = async (): Promise<void> => {
    try {
      // 调用后端登出接口
      if (token.value) {
        await authApi.logout()
      }
    } catch (error) {
      console.error('登出接口调用失败:', error)
    } finally {
      // 清除本地状态
      clearUserState()

      // 跳转到登录页
      router.push('/login')
    }
  }

  /**
   * 刷新Token
   */
  const refreshAccessToken = async (): Promise<string> => {
    try {
      const response = await authApi.refreshToken(refreshTokenValue.value)
      const newToken = response.data

      // refreshToken API 返回的是新的 access token 字符串
      token.value = newToken
      setToken(newToken)
      return newToken
    } catch (error) {
      console.error('Token刷新失败:', error)
      // Token刷新失败，清除登录状态
      logout()
      throw error
    }
  }

  /**
   * 清除用户状态
   */
  const clearUserState = (): void => {
    userInfo.value = {
      id: '',
      username: '',
      realName: '',
      email: '',
      phone: '',
      avatar: '',
      status: ApiTypes.UserStatus.ACTIVE,
      roles: [],
      permissions: [],
      tenantId: '',
      organizationId: '',
      createdAt: '',
      updatedAt: '',
      lastLoginAt: '',
    }
    token.value = ''
    refreshTokenValue.value = ''
    isLoggedIn.value = false
    clearAuth()
  }

  /**
   * 检查是否有指定权限
   */
  const hasPermission = (permissionCode: string): boolean => {
    // 开发模式或超级管理员拥有所有权限
    if (BYPASS_AUTH || isAdmin.value) {
      return true
    }

    return permissionCodes.value.includes(permissionCode)
  }

  /**
   * 检查是否有指定角色
   */
  const hasRole = (roleCode: string): boolean => {
    if (BYPASS_AUTH) return true
    return roleCodes.value.includes(roleCode)
  }

  /**
   * 检查是否有任一权限
   */
  const hasAnyPermission = (permissionCodeList: string[]): boolean => {
    if (BYPASS_AUTH || isAdmin.value) {
      return true
    }

    return permissionCodeList.some((code) =>
      permissionCodes.value.includes(code),
    )
  }

  /**
   * 检查是否有任一角色
   */
  const hasAnyRole = (roleCodeList: string[]): boolean => {
    if (BYPASS_AUTH) return true
    return roleCodeList.some((code) => roleCodes.value.includes(code))
  }

  /**
   * 更新用户资料
   */
  const updateProfile = async (
    profileData: Partial<ApiTypes.UserInfo>,
  ): Promise<ApiTypes.UserInfo> => {
    try {
      const response = await authApi.updateProfile(profileData)

      if (response.code === 200) {
        // 更新本地用户信息
        userInfo.value = { ...userInfo.value, ...response.data }
        return response.data
      } else {
        throw new Error(response.message || '更新用户资料失败')
      }
    } catch (error) {
      console.error('更新用户资料失败:', error)
      throw error
    }
  }

  /**
   * 修改密码
   */
  const changePassword = async (
    oldPassword: string,
    newPassword: string,
  ): Promise<void> => {
    try {
      const response = await authApi.changePassword({
        oldPassword,
        newPassword,
      })

      if (response.code !== 200) {
        throw new Error(response.message || '修改密码失败')
      }
    } catch (error) {
      console.error('修改密码失败:', error)
      throw error
    }
  }

  /**
   * 上传头像
   */
  const uploadAvatar = async (file: File): Promise<string> => {
    try {
      const response = await authApi.uploadAvatar(file)

      if (response.code === 200) {
        // 更新用户头像
        userInfo.value.avatar = response.data.avatarUrl
        return response.data.avatarUrl
      } else {
        throw new Error(response.message || '上传头像失败')
      }
    } catch (error) {
      console.error('上传头像失败:', error)
      throw error
    }
  }

  // 初始化时检查token
  const initializeAuth = async (): Promise<void> => {
    const savedToken = getToken()
    if (savedToken) {
      token.value = savedToken
      isLoggedIn.value = true

      try {
        await getUserInfo()
      } catch (error) {
        // 如果获取用户信息失败，清除认证状态
        clearUserState()
      }
    }
  }

  return {
    // State
    userInfo,
    token,
    refreshToken: refreshTokenValue,
    isLoggedIn,

    // Getters
    permissionCodes,
    roleCodes,
    isAdmin,

    // Actions
    login,
    logout,
    getUserInfo,
    refreshAccessToken,
    clearUserState,
    hasPermission,
    hasRole,
    hasAnyPermission,
    hasAnyRole,
    updateProfile,
    changePassword,
    uploadAvatar,
    initializeAuth,
  }
})
