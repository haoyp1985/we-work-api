<template>
  <component 
    :is="tag" 
    v-if="hasAccess"
    v-bind="$attrs"
  >
    <slot />
  </component>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { 
  hasPermission, 
  hasRole, 
  hasTenantPermission, 
  isSuperAdmin,
  canAccessTenant 
} from '@/directives/permission'
import { useTenantStore } from '@/stores'

interface Props {
  // 权限控制
  permission?: string | string[]
  role?: string | string[]
  tenantPermission?: string | string[]
  
  // 控制逻辑
  requireAll?: boolean // 是否需要所有权限/角色
  adminOnly?: boolean  // 仅超级管理员
  tenantRequired?: boolean // 是否需要选择租户
  tenantId?: string // 指定租户ID
  tenantStatus?: string | string[] // 租户状态要求
  
  // 渲染标签
  tag?: string
  
  // 无权限时的处理
  fallback?: 'hidden' | 'disabled' | 'placeholder'
  placeholder?: string
}

const props = withDefaults(defineProps<Props>(), {
  tag: 'div',
  requireAll: false,
  adminOnly: false,
  tenantRequired: false,
  fallback: 'hidden'
})

// Store
const tenantStore = useTenantStore()

// Computed
const hasAccess = computed(() => {
  try {
    // 检查超级管理员权限
    if (props.adminOnly) {
      return isSuperAdmin()
    }
    
    // 检查租户要求
    if (props.tenantRequired && !tenantStore.currentTenant) {
      return false
    }
    
    // 检查指定租户权限
    if (props.tenantId && !canAccessTenant(props.tenantId)) {
      return false
    }
    
    // 检查租户状态
    if (props.tenantStatus && tenantStore.currentTenant) {
      const currentStatus = tenantStore.currentTenant.status
      if (Array.isArray(props.tenantStatus)) {
        if (!props.tenantStatus.includes(currentStatus)) {
          return false
        }
      } else {
        if (currentStatus !== props.tenantStatus) {
          return false
        }
      }
    }
    
    // 检查租户级权限
    if (props.tenantPermission) {
      if (!hasTenantPermission(props.tenantPermission)) {
        return false
      }
    }
    
    // 检查普通权限
    if (props.permission) {
      if (!hasPermission(props.permission, props.requireAll)) {
        return false
      }
    }
    
    // 检查角色
    if (props.role) {
      if (!hasRole(props.role, props.requireAll)) {
        return false
      }
    }
    
    return true
    
  } catch (error) {
    console.error('Permission check error:', error)
    return false
  }
})
</script>

<script lang="ts">
export default {
  name: 'PermissionControl',
  inheritAttrs: false
}
</script>