import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { UserInfo, LoginRequest, LoginResponse } from '@/types'
import { login, logout, getUserInfo } from '@/api/auth'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { ElMessage } from 'element-plus'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref<string>(getToken() || '')
  const userInfo = ref<UserInfo | null>(null)
  const roles = ref<string[]>([])
  const permissions = ref<string[]>([])

  // Getters
  const isLoggedIn = computed(() => !!token.value)
  const hasRole = (role: string) => roles.value.includes(role)
  const hasPermission = (permission: string) => permissions.value.includes(permission)

  // Actions
  const loginAction = async (loginForm: LoginRequest): Promise<boolean> => {
    try {
      const response = await login(loginForm)
      const { token: accessToken, user } = response.data
      
      // 保存token
      token.value = accessToken
      setToken(accessToken)
      
      // 保存用户信息
      userInfo.value = user
      roles.value = user.roles || []
      permissions.value = user.permissions || []
      
      ElMessage.success('登录成功')
      return true
    } catch (error: any) {
      ElMessage.error(error.message || '登录失败')
      return false
    }
  }

  const logoutAction = async (): Promise<void> => {
    try {
      await logout()
    } catch (error) {
      console.error('Logout error:', error)
    } finally {
      // 清除本地状态
      token.value = ''
      userInfo.value = null
      roles.value = []
      permissions.value = []
      removeToken()
      
      ElMessage.success('退出登录成功')
    }
  }

  const getUserInfoAction = async (): Promise<boolean> => {
    try {
      if (!token.value) {
        return false
      }

      const response = await getUserInfo()
      const user = response.data
      
      userInfo.value = user
      roles.value = user.roles || []
      permissions.value = user.permissions || []
      
      return true
    } catch (error: any) {
      console.error('Get user info error:', error)
      // Token可能已过期，清除本地状态
      await logoutAction()
      return false
    }
  }

  const updateUserInfo = (newUserInfo: Partial<UserInfo>) => {
    if (userInfo.value) {
      userInfo.value = { ...userInfo.value, ...newUserInfo }
    }
  }

  const resetState = () => {
    token.value = ''
    userInfo.value = null
    roles.value = []
    permissions.value = []
    removeToken()
  }

  return {
    // 状态
    token,
    userInfo,
    roles,
    permissions,
    
    // Getters
    isLoggedIn,
    hasRole,
    hasPermission,
    
    // Actions
    loginAction,
    logoutAction,
    getUserInfoAction,
    updateUserInfo,
    resetState
  }
})