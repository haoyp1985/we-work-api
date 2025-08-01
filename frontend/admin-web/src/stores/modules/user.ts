import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserInfo, LoginRequest, LoginResponse, TenantInfo } from '@/types'
import { TenantStatus, TenantType } from '@/types'
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
      // 开发阶段：使用模拟登录
      if (import.meta.env.DEV) {
        // 简单的模拟登录验证
        if (loginForm.username === 'admin' && loginForm.password === 'admin123') {
          const mockToken = 'mock-jwt-token-' + Date.now()
          const mockUser: UserInfo = {
            id: '1',
            username: 'admin',
            email: 'admin@wework.com',
            nickname: '系统管理员',
            avatar: '',
            phone: '13800138000',
            status: 'ACTIVE',
            roles: ['admin', 'tenant_admin', 'monitor_viewer'],
            permissions: ['system:read', 'system:write', 'monitor:read', 'monitor:write'],
            lastLoginTime: new Date().toISOString(),
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
          }
          
          // 保存token
          token.value = mockToken
          setToken(mockToken)
          
          // 保存用户信息
          userInfo.value = mockUser
          roles.value = mockUser.roles || []
          permissions.value = mockUser.permissions || []
          
          ElMessage.success('登录成功 (开发模式)')
          return true
        } else {
          ElMessage.error('用户名或密码错误 (开发模式: admin/admin123)')
          return false
        }
      }
      
      // 生产环境：调用真实API
      const response = await login(loginForm)
      const { token: accessToken, user } = response.data
      
      // 保存token
      token.value = accessToken
      setToken(accessToken)
      
      // 保存用户信息
      userInfo.value = user
      roles.value = user.roles || []
      permissions.value = user.permissions || []
      
      // 设置租户信息
      if (user.tenantId) {
        await setUserTenant(user.tenantId)
      }
      
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

      // 开发阶段：使用模拟数据
      if (import.meta.env.DEV) {
        const mockUser: UserInfo = {
          id: '1',
          username: 'admin',
          email: 'admin@wework.com',
          nickname: '系统管理员',
          avatar: '',
          phone: '13800138000',
          status: 'ACTIVE',
          roles: ['admin', 'tenant_admin', 'monitor_viewer'],
          permissions: ['system:read', 'system:write', 'monitor:read', 'monitor:write'],
          lastLoginTime: new Date().toISOString(),
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
        
        userInfo.value = mockUser
        roles.value = mockUser.roles || []
        permissions.value = mockUser.permissions || []
        
        return true
      }

      const response = await getUserInfo()
      const user = response.data
      
      userInfo.value = user
      roles.value = user.roles || []
      permissions.value = user.permissions || []
      
      return true
    } catch (error: any) {
      console.error('Get user info error:', error)
      
      // 开发阶段：即使API失败也使用模拟数据
      if (import.meta.env.DEV) {
        const mockUser: UserInfo = {
          id: '1',
          username: 'admin',
          email: 'admin@wework.com',
          nickname: '系统管理员',
          avatar: '',
          phone: '13800138000',
          status: 'ACTIVE',
          roles: ['admin', 'tenant_admin', 'monitor_viewer'],
          permissions: ['system:read', 'system:write', 'monitor:read', 'monitor:write'],
          lastLoginTime: new Date().toISOString(),
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
        
        userInfo.value = mockUser
        roles.value = mockUser.roles || []
        permissions.value = mockUser.permissions || []
        
        return true
      }
      
      // 生产环境：Token可能已过期，清除本地状态
      await logoutAction()
      return false
    }
  }

  const updateUserInfo = (newUserInfo: Partial<UserInfo>) => {
    if (userInfo.value) {
      userInfo.value = { ...userInfo.value, ...newUserInfo }
    }
  }

  const setUserTenant = async (tenantId: string) => {
    try {
      // 导入tenantStore (延迟导入避免循环依赖)
      const { useTenantStore } = await import('./tenant')
      const tenantStore = useTenantStore()
      
      // 根据tenantId创建租户信息 (临时方案，实际应该从API获取)
      const tenantInfo: TenantInfo = {
        id: tenantId,
        name: tenantId === 'default-tenant-id-001' ? '默认租户' : '演示租户', 
        code: tenantId === 'default-tenant-id-001' ? 'DEFAULT' : 'DEMO',
        type: TenantType.ENTERPRISE,
        status: TenantStatus.ACTIVE,
        description: '系统租户',
        logo: '',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
      
      // 设置当前租户
      tenantStore.currentTenant = tenantInfo
      
      // 保存到本地存储
      localStorage.setItem('current-tenant', JSON.stringify(tenantInfo))
      
      console.log('✅ 租户信息设置成功:', tenantInfo)
    } catch (error) {
      console.error('❌ 设置租户信息失败:', error)
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
    setUserTenant,
    resetState
  }
})