/**
 * Pinia Store 主配置
 * WeWork Management Platform - Frontend
 */

import { createPinia } from 'pinia'
import type { App } from 'vue'

// 创建 Pinia 实例
const pinia = createPinia()

// Pinia 插件 - 持久化存储
const persistPlugin = (context: any) => {
  const { store } = context
  
  // 需要持久化的 store
  const persistStores = ['user', 'app']
  
  if (persistStores.includes(store.$id)) {
    // 从 localStorage 恢复状态
    const savedState = localStorage.getItem(`pinia-${store.$id}`)
    if (savedState) {
      try {
        const parsed = JSON.parse(savedState)
        store.$patch(parsed)
      } catch (error) {
        console.error(`Failed to restore state for ${store.$id}:`, error)
      }
    }
    
    // 订阅状态变化并保存到 localStorage
    store.$subscribe((mutation: any, state: any) => {
      try {
        localStorage.setItem(`pinia-${store.$id}`, JSON.stringify(state))
      } catch (error) {
        console.error(`Failed to persist state for ${store.$id}:`, error)
      }
    })
  }
}

// 添加插件
pinia.use(persistPlugin)

// 安装函数
export function setupStore(app: App<Element>) {
  app.use(pinia)
}

export { pinia }
export default pinia

// 导出所有 store
export * from './modules/user'
export * from './modules/app'
export * from './modules/account'
export * from './modules/message'
export * from './modules/monitor'