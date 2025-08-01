import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import pinia from './stores'

// Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// 样式
import '@/styles/index.scss'

// NProgress
import 'nprogress/nprogress.css'

// 创建应用实例
const app = createApp(App)

// 注册Element Plus图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 全局配置
app.config.globalProperties.$ELEMENT = {
  size: 'default'
}

// 开发环境配置
if (import.meta.env.DEV) {
  app.config.performance = true
  app.config.globalProperties.$log = console.log
}

// 错误处理
app.config.errorHandler = (err, instance, info) => {
  console.error('Global error:', err)
  console.error('Component instance:', instance)
  console.error('Error info:', info)
}

// 使用插件
app.use(pinia)
app.use(router)
app.use(ElementPlus, {
  size: 'default'
})

// 挂载应用
app.mount('#app')