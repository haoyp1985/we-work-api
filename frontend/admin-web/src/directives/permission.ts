import type { App, Directive } from 'vue'
import { useUserStore, useTenantStore } from '@/stores'

/**
 * 权限指令
 * 用法：
 * v-permission="'user:create'" // 单个权限
 * v-permission="['user:create', 'user:update']" // 多个权限（OR关系）
 * v-permission.all="['user:create', 'user:update']" // 多个权限（AND关系）
 * v-permission.tenant="'account:manage'" // 租户级权限
 * v-permission.admin // 仅超级管理员可见
 */
export const permission: Directive = {
  mounted(el: HTMLElement, binding) {
    checkPermission(el, binding)
  },
  
  updated(el: HTMLElement, binding) {
    checkPermission(el, binding)
  }
}

function checkPermission(el: HTMLElement, binding: any) {
  const { value, modifiers } = binding
  const userStore = useUserStore()
  const tenantStore = useTenantStore()
  
  let hasPermission = false
  
  try {
    // 检查超级管理员权限
    if (modifiers.admin) {
      hasPermission = userStore.hasRole('super_admin')
    }
    // 检查租户级权限
    else if (modifiers.tenant) {
      hasPermission = checkTenantPermission(value, userStore, tenantStore)
    }
    // 检查普通权限
    else if (value) {
      if (Array.isArray(value)) {
        if (modifiers.all) {
          // AND关系：需要拥有所有权限
          hasPermission = value.every(permission => userStore.hasPermission(permission))
        } else {
          // OR关系：拥有任一权限即可
          hasPermission = value.some(permission => userStore.hasPermission(permission))
        }
      } else {
        hasPermission = userStore.hasPermission(value)
      }
    }
    
    // 根据权限结果显示/隐藏元素
    if (!hasPermission) {
      // 移除元素而不是隐藏，避免占用布局空间
      el.style.display = 'none'
      el.setAttribute('data-no-permission', 'true')
    } else {
      el.style.display = ''
      el.removeAttribute('data-no-permission')
    }
    
  } catch (error) {
    console.error('Permission check error:', error)
    // 发生错误时隐藏元素，确保安全
    el.style.display = 'none'
  }
}

function checkTenantPermission(permission: string | string[], userStore: any, tenantStore: any): boolean {
  // 超级管理员始终有权限
  if (userStore.hasRole('super_admin')) {
    return true
  }
  
  // 检查是否有当前租户
  if (!tenantStore.currentTenant) {
    return false
  }
  
  // 检查租户级权限
  if (Array.isArray(permission)) {
    return permission.some(p => userStore.hasPermission(p))
  } else {
    return userStore.hasPermission(permission)
  }
}

/**
 * 角色指令
 * 用法：
 * v-role="'admin'" // 单个角色
 * v-role="['admin', 'manager']" // 多个角色（OR关系）
 * v-role.all="['admin', 'manager']" // 多个角色（AND关系）
 */
export const role: Directive = {
  mounted(el: HTMLElement, binding) {
    checkRole(el, binding)
  },
  
  updated(el: HTMLElement, binding) {
    checkRole(el, binding)
  }
}

function checkRole(el: HTMLElement, binding: any) {
  const { value, modifiers } = binding
  const userStore = useUserStore()
  
  let hasRole = false
  
  try {
    if (value) {
      if (Array.isArray(value)) {
        if (modifiers.all) {
          // AND关系：需要拥有所有角色
          hasRole = value.every(role => userStore.hasRole(role))
        } else {
          // OR关系：拥有任一角色即可
          hasRole = value.some(role => userStore.hasRole(role))
        }
      } else {
        hasRole = userStore.hasRole(value)
      }
    }
    
    // 根据角色结果显示/隐藏元素
    if (!hasRole) {
      el.style.display = 'none'
      el.setAttribute('data-no-role', 'true')
    } else {
      el.style.display = ''
      el.removeAttribute('data-no-role')
    }
    
  } catch (error) {
    console.error('Role check error:', error)
    // 发生错误时隐藏元素，确保安全
    el.style.display = 'none'
  }
}

/**
 * 租户状态指令
 * 用法：
 * v-tenant-status="'ACTIVE'" // 指定状态
 * v-tenant-status="['ACTIVE', 'TRIAL']" // 多个状态
 */
export const tenantStatus: Directive = {
  mounted(el: HTMLElement, binding) {
    checkTenantStatus(el, binding)
  },
  
  updated(el: HTMLElement, binding) {
    checkTenantStatus(el, binding)
  }
}

function checkTenantStatus(el: HTMLElement, binding: any) {
  const { value } = binding
  const tenantStore = useTenantStore()
  
  let statusMatch = false
  
  try {
    const currentStatus = tenantStore.currentTenant?.status
    
    if (currentStatus && value) {
      if (Array.isArray(value)) {
        statusMatch = value.includes(currentStatus)
      } else {
        statusMatch = currentStatus === value
      }
    }
    
    // 根据状态匹配结果显示/隐藏元素
    if (!statusMatch) {
      el.style.display = 'none'
      el.setAttribute('data-tenant-status-mismatch', 'true')
    } else {
      el.style.display = ''
      el.removeAttribute('data-tenant-status-mismatch')
    }
    
  } catch (error) {
    console.error('Tenant status check error:', error)
    el.style.display = 'none'
  }
}

// 注册指令到Vue应用
export function setupPermissionDirectives(app: App) {
  app.directive('permission', permission)
  app.directive('role', role)
  app.directive('tenant-status', tenantStatus)
}

// 导出权限检查函数供组件使用
export function hasPermission(permission: string | string[], requireAll = false): boolean {
  const userStore = useUserStore()
  
  if (Array.isArray(permission)) {
    if (requireAll) {
      return permission.every(p => userStore.hasPermission(p))
    } else {
      return permission.some(p => userStore.hasPermission(p))
    }
  } else {
    return userStore.hasPermission(permission)
  }
}

export function hasRole(role: string | string[], requireAll = false): boolean {
  const userStore = useUserStore()
  
  if (Array.isArray(role)) {
    if (requireAll) {
      return role.every(r => userStore.hasRole(r))
    } else {
      return role.some(r => userStore.hasRole(r))
    }
  } else {
    return userStore.hasRole(role)
  }
}

export function hasTenantPermission(permission: string | string[]): boolean {
  const userStore = useUserStore()
  const tenantStore = useTenantStore()
  
  return checkTenantPermission(permission, userStore, tenantStore)
}

export function isSuperAdmin(): boolean {
  const userStore = useUserStore()
  return userStore.hasRole('super_admin')
}

export function canAccessTenant(tenantId: string): boolean {
  const tenantStore = useTenantStore()
  return tenantStore.canAccessTenant(tenantId)
}