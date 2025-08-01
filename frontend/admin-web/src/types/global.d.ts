/**
 * 全局类型声明
 */

declare global {
  interface Window {
    __VUE_DEVTOOLS_GLOBAL_HOOK__?: any
    __VUE_ROUTER__?: any
    debugRoutes?: () => void
    debugPermissions?: () => void
  }

  // 扩展ImportMeta类型
  interface ImportMeta {
    env: {
      DEV: boolean
      PROD: boolean
      BASE_URL: string
      MODE: string
      [key: string]: any
    }
  }
}

export {}