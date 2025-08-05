/**
 * 应用状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { 
  Theme, 
  Language, 
  SidebarState, 
  DeviceType,
  AppSettings 
} from '@/types/app'

export const useAppStore = defineStore('app', () => {
  // ===== State =====
  const theme = ref<Theme>('light')
  const language = ref<Language>('zh-CN')
  const sidebarCollapsed = ref<boolean>(false)
  const sidebarState = ref<SidebarState>('expanded')
  const deviceType = ref<DeviceType>('desktop')
  const loading = ref<boolean>(false)
  const pageLoading = ref<boolean>(false)

  // 应用设置
  const settings = ref<AppSettings>({
    showTabs: true,
    showBreadcrumb: true,
    showFooter: true,
    showSettings: true,
    fixedHeader: true,
    fixedSidebar: true,
    animationEnabled: true,
    watermarkEnabled: false,
    grayMode: false,
    colorWeakMode: false
  })

  // 面包屑导航
  const breadcrumbs = ref<Array<{ name: string; path?: string; meta?: any }>>([])

  // 标签页
  const visitedViews = ref<Array<{ name: string; path: string; title: string; meta?: any }>>([])
  const cachedViews = ref<string[]>([])

  // ===== Getters =====
  const isDarkMode = computed(() => theme.value === 'dark')
  const isMobile = computed(() => deviceType.value === 'mobile')
  const isTablet = computed(() => deviceType.value === 'tablet')
  const isDesktop = computed(() => deviceType.value === 'desktop')

  const sidebarWidth = computed(() => {
    if (isMobile.value) {
      return sidebarCollapsed.value ? 0 : 200
    }
    return sidebarCollapsed.value ? 64 : 200
  })

  // ===== Actions =====

  /**
   * 切换主题
   */
  const toggleTheme = (): void => {
    theme.value = theme.value === 'light' ? 'dark' : 'light'
    updateThemeClass()
  }

  /**
   * 设置主题
   */
  const setTheme = (newTheme: Theme): void => {
    theme.value = newTheme
    updateThemeClass()
  }

  /**
   * 更新主题类名
   */
  const updateThemeClass = (): void => {
    const htmlElement = document.documentElement
    if (theme.value === 'dark') {
      htmlElement.classList.add('dark')
    } else {
      htmlElement.classList.remove('dark')
    }
  }

  /**
   * 设置语言
   */
  const setLanguage = (lang: Language): void => {
    language.value = lang
    document.documentElement.lang = lang
  }

  /**
   * 切换侧边栏
   */
  const toggleSidebar = (): void => {
    sidebarCollapsed.value = !sidebarCollapsed.value
    sidebarState.value = sidebarCollapsed.value ? 'collapsed' : 'expanded'
  }

  /**
   * 设置侧边栏状态
   */
  const setSidebarState = (state: SidebarState): void => {
    sidebarState.value = state
    sidebarCollapsed.value = state === 'collapsed'
  }

  /**
   * 设置设备类型
   */
  const setDeviceType = (type: DeviceType): void => {
    deviceType.value = type
    
    // 移动端自动收起侧边栏
    if (type === 'mobile') {
      setSidebarState('collapsed')
    }
  }

  /**
   * 设置全局加载状态
   */
  const setLoading = (isLoading: boolean): void => {
    loading.value = isLoading
  }

  /**
   * 设置页面加载状态
   */
  const setPageLoading = (isLoading: boolean): void => {
    pageLoading.value = isLoading
  }

  /**
   * 更新应用设置
   */
  const updateSettings = (newSettings: Partial<AppSettings>): void => {
    settings.value = { ...settings.value, ...newSettings }
    applySettings()
  }

  /**
   * 应用设置到DOM
   */
  const applySettings = (): void => {
    const htmlElement = document.documentElement
    
    // 灰色模式
    if (settings.value.grayMode) {
      htmlElement.classList.add('gray-mode')
    } else {
      htmlElement.classList.remove('gray-mode')
    }
    
    // 色弱模式
    if (settings.value.colorWeakMode) {
      htmlElement.classList.add('color-weak-mode')
    } else {
      htmlElement.classList.remove('color-weak-mode')
    }
    
    // 动画
    if (!settings.value.animationEnabled) {
      htmlElement.classList.add('no-animation')
    } else {
      htmlElement.classList.remove('no-animation')
    }
  }

  /**
   * 设置面包屑
   */
  const setBreadcrumbs = (crumbs: Array<{ name: string; path?: string; meta?: any }>): void => {
    breadcrumbs.value = crumbs
  }

  /**
   * 添加访问过的视图
   */
  const addVisitedView = (view: { name: string; path: string; title: string; meta?: any }): void => {
    const existingIndex = visitedViews.value.findIndex(v => v.path === view.path)
    if (existingIndex === -1) {
      visitedViews.value.push(view)
    } else {
      // 更新已存在的视图
      visitedViews.value[existingIndex] = view
    }
    
    // 添加到缓存
    if (view.meta?.keepAlive && !cachedViews.value.includes(view.name)) {
      cachedViews.value.push(view.name)
    }
  }

  /**
   * 删除访问过的视图
   */
  const removeVisitedView = (path: string): void => {
    const index = visitedViews.value.findIndex(v => v.path === path)
    if (index !== -1) {
      const view = visitedViews.value[index]
      visitedViews.value.splice(index, 1)
      
      // 从缓存中移除
      const cacheIndex = cachedViews.value.indexOf(view.name)
      if (cacheIndex !== -1) {
        cachedViews.value.splice(cacheIndex, 1)
      }
    }
  }

  /**
   * 删除其他访问过的视图
   */
  const removeOtherVisitedViews = (currentPath: string): void => {
    const currentView = visitedViews.value.find(v => v.path === currentPath)
    if (currentView) {
      visitedViews.value = [currentView]
      cachedViews.value = currentView.meta?.keepAlive ? [currentView.name] : []
    }
  }

  /**
   * 删除所有访问过的视图
   */
  const removeAllVisitedViews = (): void => {
    visitedViews.value = []
    cachedViews.value = []
  }

  /**
   * 重置应用状态
   */
  const resetAppState = (): void => {
    theme.value = 'light'
    language.value = 'zh-CN'
    sidebarCollapsed.value = false
    sidebarState.value = 'expanded'
    deviceType.value = 'desktop'
    loading.value = false
    pageLoading.value = false
    
    settings.value = {
      showTabs: true,
      showBreadcrumb: true,
      showFooter: true,
      showSettings: true,
      fixedHeader: true,
      fixedSidebar: true,
      animationEnabled: true,
      watermarkEnabled: false,
      grayMode: false,
      colorWeakMode: false
    }
    
    breadcrumbs.value = []
    visitedViews.value = []
    cachedViews.value = []
    
    // 应用重置后的设置
    updateThemeClass()
    applySettings()
  }

  /**
   * 初始化应用
   */
  const initializeApp = (): void => {
    // 检测设备类型
    const checkDeviceType = () => {
      const width = window.innerWidth
      if (width < 768) {
        setDeviceType('mobile')
      } else if (width < 1024) {
        setDeviceType('tablet')
      } else {
        setDeviceType('desktop')
      }
    }
    
    checkDeviceType()
    window.addEventListener('resize', checkDeviceType)
    
    // 应用主题和设置
    updateThemeClass()
    applySettings()
  }

  return {
    // State
    theme,
    language,
    sidebarCollapsed,
    sidebarState,
    deviceType,
    loading,
    pageLoading,
    settings,
    breadcrumbs,
    visitedViews,
    cachedViews,
    
    // Getters
    isDarkMode,
    isMobile,
    isTablet,
    isDesktop,
    sidebarWidth,
    
    // Actions
    toggleTheme,
    setTheme,
    setLanguage,
    toggleSidebar,
    setSidebarState,
    setDeviceType,
    setLoading,
    setPageLoading,
    updateSettings,
    setBreadcrumbs,
    addVisitedView,
    removeVisitedView,
    removeOtherVisitedViews,
    removeAllVisitedViews,
    resetAppState,
    initializeApp
  }
})