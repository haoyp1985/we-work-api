import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAppStore = defineStore('app', () => {
  // 侧边栏状态
  const sidebarCollapsed = ref<boolean>(false)
  
  // 设备类型
  const device = ref<'desktop' | 'mobile'>('desktop')
  
  // 主题设置
  const theme = ref<'light' | 'dark'>('light')
  
  // 语言设置
  const language = ref<'zh-cn' | 'en'>('zh-cn')
  
  // 页面加载状态
  const pageLoading = ref<boolean>(false)
  
  // 全局组件大小
  const componentSize = ref<'large' | 'default' | 'small'>('default')

  // Actions
  const toggleSidebar = () => {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  const closeSidebar = () => {
    sidebarCollapsed.value = true
  }

  const openSidebar = () => {
    sidebarCollapsed.value = false
  }

  const setDevice = (deviceType: 'desktop' | 'mobile') => {
    device.value = deviceType
    
    // 移动端自动收起侧边栏
    if (deviceType === 'mobile') {
      sidebarCollapsed.value = true
    }
  }

  const setTheme = (newTheme: 'light' | 'dark') => {
    theme.value = newTheme
    
    // 应用主题到document
    document.documentElement.setAttribute('data-theme', newTheme)
    
    // 保存到localStorage
    localStorage.setItem('theme', newTheme)
  }

  const setLanguage = (lang: 'zh-cn' | 'en') => {
    language.value = lang
    localStorage.setItem('language', lang)
  }

  const setPageLoading = (loading: boolean) => {
    pageLoading.value = loading
  }

  const setComponentSize = (size: 'large' | 'default' | 'small') => {
    componentSize.value = size
    localStorage.setItem('componentSize', size)
  }

  // 初始化应用设置
  const initApp = () => {
    // 从localStorage恢复设置
    const savedTheme = localStorage.getItem('theme') as 'light' | 'dark'
    const savedLanguage = localStorage.getItem('language') as 'zh-cn' | 'en'
    const savedComponentSize = localStorage.getItem('componentSize') as 'large' | 'default' | 'small'
    
    if (savedTheme) {
      setTheme(savedTheme)
    }
    
    if (savedLanguage) {
      setLanguage(savedLanguage)
    }
    
    if (savedComponentSize) {
      setComponentSize(savedComponentSize)
    }

    // 检测设备类型
    const checkDevice = () => {
      const width = window.innerWidth
      setDevice(width < 768 ? 'mobile' : 'desktop')
    }
    
    checkDevice()
    window.addEventListener('resize', checkDevice)
  }

  return {
    // 状态
    sidebarCollapsed,
    device,
    theme,
    language,
    pageLoading,
    componentSize,
    
    // Actions
    toggleSidebar,
    closeSidebar,
    openSidebar,
    setDevice,
    setTheme,
    setLanguage,
    setPageLoading,
    setComponentSize,
    initApp
  }
})