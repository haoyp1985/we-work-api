import { defineStore } from 'pinia'
import { ref, type Ref } from 'vue'
import type { MenuItem } from '@/types'
import { getMenus } from '@/api/menu'
import { constantRoutes, asyncRoutes } from '@/router/routes'
import type { RouteRecordRaw } from 'vue-router'

export const usePermissionStore = defineStore('permission', (): {
  routes: Ref<RouteRecordRaw[]>
  addRoutes: Ref<RouteRecordRaw[]>
  menuList: Ref<MenuItem[]>
  generateRoutes: (roles: string[]) => Promise<RouteRecordRaw[]>
  resetRoutes: () => void
  checkMenuPermission: (menuPath: string, userRoles: string[]) => boolean
} => {
  // 状态
  const routes = ref<RouteRecordRaw[]>([])
  const addRoutes = ref<RouteRecordRaw[]>([])
  const menuList = ref<MenuItem[]>([])

  // 生成路由
  const generateRoutes = async (roles: string[]): Promise<RouteRecordRaw[]> => {
    try {
      // 开发阶段：直接使用路由配置生成菜单，不依赖后端API
      if (import.meta.env.DEV) {
        console.log('🔄 开始生成路由...', { roles, asyncRoutesCount: asyncRoutes.length })
        
        // 根据角色过滤路由
        let accessedRoutes: RouteRecordRaw[]
        
        if (roles.includes('admin')) {
          // 管理员拥有所有路由权限
          accessedRoutes = asyncRoutes
          console.log('👑 管理员权限：使用所有路由', accessedRoutes.length)
        } else {
          // 根据角色过滤路由
          accessedRoutes = filterAsyncRoutes(asyncRoutes, roles)
          console.log('🔒 普通用户权限：过滤后路由', accessedRoutes.length)
        }
        
        console.log('📋 过滤后的路由:', accessedRoutes.map(r => ({ path: r.path, name: r.name, children: r.children?.length })))
        
        // 从路由配置生成菜单
        menuList.value = generateMenuFromRoutes(accessedRoutes)
        console.log('🍔 生成的菜单:', menuList.value)
        
        addRoutes.value = accessedRoutes
        routes.value = constantRoutes.concat(accessedRoutes)
        
        console.log('✅ 路由生成完成', {
          constantRoutes: constantRoutes.length,
          asyncRoutes: accessedRoutes.length,
          totalRoutes: routes.value.length
        })
        
        return accessedRoutes
      }
      
      // 生产环境：从后端API获取菜单
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
      // 出错时使用默认路由
      const defaultRoutes = filterAsyncRoutes(asyncRoutes, roles)
      menuList.value = generateMenuFromRoutes(defaultRoutes)
      addRoutes.value = defaultRoutes
      routes.value = constantRoutes.concat(defaultRoutes)
      return defaultRoutes
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
    if (route.meta?.roles && Array.isArray(route.meta.roles)) {
      return roles.some(role => (route.meta!.roles as string[]).includes(role))
    }
    return true
  }

  // 从路由配置生成菜单
  const generateMenuFromRoutes = (routes: RouteRecordRaw[]): MenuItem[] => {
    const menus: MenuItem[] = []
    
    routes.forEach(route => {
      // 跳过隐藏的路由和没有子菜单的路由
      if (route.meta?.hidden || !route.children?.length) {
        return
      }
      
      const menu: MenuItem = {
        id: route.name as string || route.path,
        path: route.path,
        name: route.name as string || route.path.replace('/', ''),
        component: route.component?.toString(),
        redirect: route.redirect as string,
        meta: {
          title: (route.meta?.title as string) || '',
          icon: route.meta?.icon as string,
          hidden: route.meta?.hidden as boolean,
          roles: (route.meta?.roles as string[]) || [],
          keepAlive: route.meta?.keepAlive as boolean,
          affix: route.meta?.affix as boolean
        }
      }
      
      // 处理子菜单
      if (route.children) {
        const visibleChildren = route.children.filter(child => !child.meta?.hidden)
        if (visibleChildren.length > 0) {
          menu.children = visibleChildren.map(child => ({
            id: child.name as string || child.path,
            path: child.path.startsWith('/') ? child.path : `${route.path}/${child.path}`,
            name: child.name as string || child.path,
            component: child.component?.toString(),
            meta: {
              title: (child.meta?.title as string) || '',
              icon: child.meta?.icon as string,
              hidden: child.meta?.hidden as boolean,
              roles: (child.meta?.roles as string[]) || [],
              keepAlive: child.meta?.keepAlive as boolean,
              affix: child.meta?.affix as boolean
            }
          }))
        }
      }
      
      menus.push(menu)
    })
    
    return menus
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