/**
 * 调试工具 - 分析菜单和路由问题
 */

export const debugRoutes = () => {
  console.group('🔍 路由调试信息')
  
  // 1. 检查当前用户信息
  const userStore = JSON.parse(localStorage.getItem('userStore') || '{}')
  console.log('👤 用户信息:', userStore)
  
  // 2. 检查权限store状态
  if (typeof window !== 'undefined' && (window as any).__VUE_DEVTOOLS_GLOBAL_HOOK__) {
    console.log('🔑 使用Vue DevTools查看权限store状态')
  }
  
  // 3. 检查当前路由
  console.log('🗺️ 当前路由:', window.location.pathname)
  
  // 4. 检查Vue Router实例
  const router = (window as any).__VUE_ROUTER__
  if (router) {
    console.log('📍 Router实例存在')
    console.log('📋 已注册路由:', router.getRoutes())
  } else {
    console.warn('⚠️ 未找到Router实例')
  }
  
  console.groupEnd()
}

export const debugPermissions = () => {
  console.group('🔒 权限调试信息')
  
  // 检查本地存储
  const stores = Object.keys(localStorage).filter(key => key.includes('store'))
  stores.forEach(key => {
    try {
      console.log(`💾 ${key}:`, JSON.parse(localStorage.getItem(key) || '{}'))
    } catch (error) {
      console.warn(`⚠️ 解析${key}失败:`, error)
    }
  })
  
  console.groupEnd()
}

// 全局暴露调试函数
if (import.meta.env.DEV) {
  try {
    // 确保window对象存在
    if (typeof window !== 'undefined') {
      // 使用更安全的方式设置全局属性
      Object.assign(window, {
        debugRoutes,
        debugPermissions
      })
      console.log('🐛 调试函数已全局暴露: debugRoutes(), debugPermissions()')
    }
  } catch (error) {
    console.warn('⚠️ 调试函数暴露失败:', error)
  }
}