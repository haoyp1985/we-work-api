import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useUserStore, usePermissionStore } from '@/stores'
import { getToken } from '@/utils/auth'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

// 导入路由配置
import { constantRoutes, asyncRoutes } from './routes'

// 配置进度条
NProgress.configure({ showSpinner: false })

// 创建路由实例
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: constantRoutes,
  scrollBehavior: () => ({ left: 0, top: 0 })
})

// 白名单路由（不需要认证）
const whiteList = ['/login', '/404', '/403']

// 路由前置守卫
router.beforeEach(async (to, from, next) => {
  // 开始进度条
  NProgress.start()

  const userStore = useUserStore()
  const permissionStore = usePermissionStore()
  const hasToken = getToken()

  if (hasToken) {
    if (to.path === '/login') {
      // 已登录状态访问登录页，重定向到首页
      next({ path: '/' })
      NProgress.done()
    } else {
      // 检查是否已获取用户信息
      if (!userStore.userInfo) {
        try {
          // 获取用户信息
          await userStore.getUserInfoAction()
          
          // 生成动态路由
          const accessRoutes = await permissionStore.generateRoutes(userStore.roles)
          
          // 动态添加路由
          accessRoutes.forEach(route => {
            router.addRoute(route)
          })
          
          // 重新导航到目标路由
          next({ ...to, replace: true })
        } catch (error) {
          // 获取用户信息失败，清除token并重定向到登录页
          await userStore.logoutAction()
          next(`/login?redirect=${to.path}`)
          NProgress.done()
        }
      } else {
        // 已有用户信息，检查路由权限
        if (to.meta?.roles) {
          const hasPermission = userStore.roles.some(role => 
            (to.meta!.roles as string[]).includes(role)
          )
          
          if (hasPermission) {
            next()
          } else {
            next('/403')
          }
        } else {
          next()
        }
      }
    }
  } else {
    // 未登录
    if (whiteList.includes(to.path)) {
      // 在白名单中，直接进入
      next()
    } else {
      // 不在白名单，重定向到登录页
      next(`/login?redirect=${to.path}`)
      NProgress.done()
    }
  }
})

// 路由后置守卫
router.afterEach((to) => {
  // 结束进度条
  NProgress.done()
  
  // 设置页面标题
  const title = to.meta?.title as string
  if (title) {
    document.title = `${title} - WeWork Platform`
  } else {
    document.title = 'WeWork Platform - 管理后台'
  }
})

export default router