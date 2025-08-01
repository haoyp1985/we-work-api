import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { TenantInfo } from '@/types'
import { TenantType, TenantStatus } from '@/types'
import { ElMessage } from 'element-plus'
import { useUserStore } from './user'

export const useTenantStore = defineStore('tenant', () => {
  // 状态
  const currentTenant = ref<TenantInfo | null>(null)
  const availableTenants = ref<TenantInfo[]>([])
  const tenantLoading = ref(false)

  // Getters
  const hasTenant = computed(() => !!currentTenant.value)
  const isAdmin = computed(() => {
    // 判断当前用户是否为超级管理员（可以管理所有租户）
    const userStore = useUserStore()
    return userStore.hasRole('super_admin')
  })
  
  const tenantTheme = computed(() => {
    if (!currentTenant.value) return {}
    
    return {
      '--tenant-primary': currentTenant.value.themeColor || '#409EFF',
      '--tenant-secondary': currentTenant.value.secondaryColor || '#E6F7FF'
    }
  })

  // Actions
  const loadTenants = async (): Promise<void> => {
    try {
      tenantLoading.value = true
      
      // 如果是超级管理员，获取所有租户
      // 如果是普通用户，获取用户所属的租户
      const userStore = useUserStore()
      if (userStore.hasRole('super_admin')) {
        // TODO: 调用获取所有租户的API
        // const response = await tenantApi.getAllTenants()
        // availableTenants.value = response.data
        
        // 临时模拟数据
        availableTenants.value = [
          {
            id: 'tenant-1',
            name: '演示租户',
            code: 'DEMO',
            type: TenantType.TRIAL,
            status: TenantStatus.ACTIVE,
            contactName: '张三',
            contactEmail: 'zhangsan@demo.com',
            contactPhone: '13800138000',
            themeColor: '#409EFF',
            secondaryColor: '#E6F7FF',
            description: '这是一个演示租户',
            createdAt: '2023-01-01T00:00:00Z',
            updatedAt: '2023-12-01T00:00:00Z'
          }
        ]
      } else {
        // TODO: 调用获取用户租户的API
        // const response = await tenantApi.getUserTenants()
        // availableTenants.value = response.data
        
        // 临时使用演示数据
        availableTenants.value = [
          {
            id: 'tenant-1',
            name: '演示租户',
            code: 'DEMO',
            type: TenantType.TRIAL,
            status: TenantStatus.ACTIVE,
            contactName: '张三',
            contactEmail: 'zhangsan@demo.com',
            contactPhone: '13800138000',
            themeColor: '#409EFF',
            secondaryColor: '#E6F7FF',
            description: '这是一个演示租户',
            createdAt: '2023-01-01T00:00:00Z',
            updatedAt: '2023-12-01T00:00:00Z'
          }
        ]
      }
      
      // 如果当前没有选中租户，且有可用租户，自动选择第一个
      if (!currentTenant.value && availableTenants.value.length > 0) {
        const firstTenant = availableTenants.value[0]
        if (firstTenant) {
          currentTenant.value = firstTenant
          // 保存到本地存储
          localStorage.setItem('current-tenant', JSON.stringify(currentTenant.value))
        }
      }
      
    } catch (error: any) {
      console.error('Load tenants error:', error)
      ElMessage.error(error.message || '获取租户列表失败')
    } finally {
      tenantLoading.value = false
    }
  }

  const switchTenant = async (tenantId: string): Promise<boolean> => {
    try {
      const targetTenant = availableTenants.value.find(t => t.id === tenantId)
      if (!targetTenant) {
        ElMessage.error('目标租户不存在')
        return false
      }

      // 检查用户是否有权限访问该租户
      if (!canAccessTenant(tenantId)) {
        ElMessage.error('您没有访问该租户的权限')
        return false
      }

      const oldTenant = currentTenant.value
      currentTenant.value = targetTenant
      
      // 保存到本地存储
      localStorage.setItem('current-tenant', JSON.stringify(currentTenant.value))
      
      // 更新CSS变量
      updateThemeVariables()
      
      // 发送租户切换事件，让其他组件刷新数据
      window.dispatchEvent(new CustomEvent('tenant-changed', {
        detail: { 
          oldTenant: oldTenant?.id, 
          newTenant: tenantId 
        }
      }))
      
      ElMessage.success(`已切换到租户：${targetTenant.name}`)
      return true
      
    } catch (error: any) {
      console.error('Switch tenant error:', error)
      ElMessage.error(error.message || '切换租户失败')
      return false
    }
  }

  const canAccessTenant = (tenantId: string): boolean => {
    const userStore = useUserStore()
    
    // 超级管理员可以访问所有租户
    if (userStore.hasRole('super_admin')) {
      return true
    }
    
    // 检查用户是否属于该租户
    const userTenants = userStore.userInfo?.tenants || []
    return userTenants.includes(tenantId)
  }

  const updateThemeVariables = (): void => {
    if (!currentTenant.value) return
    
    const root = document.documentElement
    const theme = tenantTheme.value
    
    Object.entries(theme).forEach(([key, value]) => {
      root.style.setProperty(key, value as string)
    })
  }

  const initTenant = (): void => {
    // 从本地存储恢复租户信息
    const savedTenant = localStorage.getItem('current-tenant')
    if (savedTenant) {
      try {
        currentTenant.value = JSON.parse(savedTenant)
        updateThemeVariables()
      } catch (error) {
        console.error('Parse saved tenant error:', error)
        localStorage.removeItem('current-tenant')
      }
    }
    
    // 加载可用租户列表
    loadTenants()
  }

  const getTenantDisplayText = (tenant: TenantInfo): string => {
    const typeText = {
      [TenantType.TRIAL]: '试用版',
      [TenantType.STANDARD]: '标准版', 
      [TenantType.PREMIUM]: '高级版',
      [TenantType.ENTERPRISE]: '企业版'
    }[tenant.type]
    
    return `${tenant.name} (${typeText})`
  }

  const getTenantStatusColor = (status: TenantStatus): string => {
    return {
      [TenantStatus.ACTIVE]: 'success',
      [TenantStatus.INACTIVE]: 'info',
      [TenantStatus.SUSPENDED]: 'warning',
      [TenantStatus.EXPIRED]: 'danger'
    }[status]
  }

  const getTenantStatusText = (status: TenantStatus): string => {
    return {
      [TenantStatus.ACTIVE]: '正常',
      [TenantStatus.INACTIVE]: '未激活',
      [TenantStatus.SUSPENDED]: '已暂停',
      [TenantStatus.EXPIRED]: '已过期'
    }[status]
  }

  const resetTenant = (): void => {
    currentTenant.value = null
    availableTenants.value = []
    localStorage.removeItem('current-tenant')
    
    // 重置主题变量
    const root = document.documentElement
    root.style.removeProperty('--tenant-primary')
    root.style.removeProperty('--tenant-secondary')
  }

  return {
    // 状态
    currentTenant,
    availableTenants,
    tenantLoading,
    
    // Getters
    hasTenant,
    isAdmin,
    tenantTheme,
    
    // Actions
    loadTenants,
    switchTenant,
    canAccessTenant,
    initTenant,
    getTenantDisplayText,
    getTenantStatusColor,
    getTenantStatusText,
    resetTenant
  }
})

// 扩展UserInfo类型以包含租户信息
declare module '@/types' {
  interface UserInfo {
    tenants?: string[]
  }
}