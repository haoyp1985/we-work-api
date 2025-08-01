import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { MenuItem } from '@/types'
import { getMenus } from '@/api/menu'
import { constantRoutes, asyncRoutes } from '@/router/routes'
import type { RouteRecordRaw } from 'vue-router'

export const usePermissionStore = defineStore('permission', () => {
  // 状态
  const routes = ref<RouteRecordRaw[]>([])
  const addRoutes = ref<RouteRecordRaw[]>([])
  const menuList = ref<MenuItem[]>([])

  // 生成路由
  const generateRoutes = async (roles: string[]): Promise<RouteRecordRaw[]> => {
    try {
      // 获取用户菜单
      const response = await getMenus()
      menuList.value = response.data
      
      // 根据角色过滤路由
      let accessedRoutes: RouteRecordRaw[]
      
      if (roles.includes('admin')) {
        // 管理员拥有所有路由权限
        accessedRoutes = asyncRoutes
      } else {
        // 根据角色过滤路由
        accessedRoutes = filterAsyncRoutes(asyncRoutes, roles)
      }
      
      addRoutes.value = accessedRoutes
      routes.value = constantRoutes.concat(accessedRoutes)
      
      return accessedRoutes
    } catch (error) {
      console.error('Generate routes error:', error)
      return []
    }
  }

  // 根据角色过滤异步路由
  const filterAsyncRoutes = (routes: RouteRecordRaw[], roles: string[]): RouteRecordRaw[] => {
    const filteredRoutes: RouteRecordRaw[] = []
    
    routes.forEach(route => {
      const temp = { ...route }
      
      if (hasPermission(roles, temp)) {
        if (temp.children) {
          temp.children = filterAsyncRoutes(temp.children, roles)
        }
        filteredRoutes.push(temp)
      }
    })
    
    return filteredRoutes
  }

  // 检查是否有权限访问路由
  const hasPermission = (roles: string[], route: RouteRecordRaw): boolean => {
    if (route.meta?.roles) {
      return roles.some(role => route.meta!.roles!.includes(role))
    }
    return true
  }

  // 重置路由
  const resetRoutes = () => {
    routes.value = []
    addRoutes.value = []
    menuList.value = []
  }

  // 检查菜单权限
  const checkMenuPermission = (menuPath: string, userRoles: string[]): boolean => {
    const findMenu = (menus: MenuItem[], path: string): MenuItem | null => {
      for (const menu of menus) {
        if (menu.path === path) {
          return menu
        }
        if (menu.children) {
          const found = findMenu(menu.children, path)
          if (found) return found
        }
      }
      return null
    }

    const menu = findMenu(menuList.value, menuPath)
    if (!menu || !menu.meta?.roles) {
      return true
    }
    
    return userRoles.some(role => menu.meta!.roles!.includes(role))
  }

  return {
    // 状态
    routes,
    addRoutes,
    menuList,
    
    // Actions
    generateRoutes,
    resetRoutes,
    checkMenuPermission
  }
})