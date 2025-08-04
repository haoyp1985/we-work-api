import { createApp } from 'vue'
import type { App as AppInstance } from 'vue'

// 导入根组件
import App from './App.vue'

// 导入路由
import router from './router'

// 导入状态管理
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

// 导入Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import zhCn from 'element-plus/es/locale/lang/zh-cn'

// 导入全局样式
import '@/styles/index.scss'

// 导入SVG图标
import 'virtual:svg-icons-register'

// 导入自定义指令
import { setupDirectives } from '@/directives'

// 导入全局组件
import { setupGlobalComponents } from '@/components'

// 导入权限控制
import '@/router/permission'

// 导入工具函数
import { setupErrorHandler } from '@/utils/error-handler'
import { setupPerformanceMonitor } from '@/utils/performance-monitor'

// 创建应用实例
const app: AppInstance = createApp(App)

// 配置Pinia
const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

// 配置Element Plus
app.use(ElementPlus, {
  locale: zhCn,
  size: 'default',
  zIndex: 3000
})

// 注册Element Plus图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 安装插件
app.use(pinia)
app.use(router)

// 安装自定义指令
setupDirectives(app)

// 安装全局组件
setupGlobalComponents(app)

// 配置错误处理
setupErrorHandler(app)

// 配置性能监控
if (import.meta.env.VITE_USE_PERFORMANCE_MONITOR === 'true') {
  setupPerformanceMonitor()
}

// 全局配置
app.config.globalProperties.$ELEMENT = {
  size: 'default',
  zIndex: 3000
}

// 开发环境下的调试信息
if (import.meta.env.DEV) {
  app.config.globalProperties.$version = __VERSION__
  app.config.globalProperties.$buildTime = __BUILD_TIME__
  
  // 输出版本信息
  console.log(`
    %c WeWork Platform Admin %c v${__VERSION__} 
    %c Build Time: ${__BUILD_TIME__}
    %c Environment: ${import.meta.env.MODE}
  `, 
    'background: #409eff; color: white; padding: 2px 4px; border-radius: 3px 0 0 3px;',
    'background: #67c23a; color: white; padding: 2px 4px; border-radius: 0 3px 3px 0;',
    'color: #409eff; font-size: 12px;',
    'color: #909399; font-size: 12px;'
  )
}

// 挂载应用
app.mount('#app')

// 导出应用实例（用于测试）
export default app