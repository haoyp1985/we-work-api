import { createPinia } from 'pinia'

const pinia = createPinia()

export default pinia

// 导出所有store
export * from './modules/user'
export * from './modules/app'
export * from './modules/permission'
export * from './modules/tenant'
export * from './modules/monitor'
export * from './modules/alert'