/**
 * 全局类型定义文件
 * WeWork Management Platform - Frontend
 */

declare global {
  // 全局常量
  const __VERSION__: string
  const __BUILD_TIME__: string
  
  // Vite环境变量类型扩展
  interface ImportMetaEnv {
    readonly VITE_APP_TITLE: string
    readonly VITE_API_BASE_URL: string
    readonly VITE_USE_MOCK: string
    readonly VITE_USE_PWA: string
    readonly VITE_USE_PERFORMANCE_MONITOR: string
    readonly VITE_BUILD_TIME: string
    readonly VITE_USE_CDN: string
    readonly VITE_BUILD_ENV: string
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv
  }

  // Vue组件实例类型扩展
  interface ComponentCustomProperties {
    $version: string
    $buildTime: string
    $ELEMENT: any
  }

  // Window对象扩展
  interface Window {
    __INITIAL_STATE__?: any
    process?: {
      env: {
        NODE_ENV: string
        [key: string]: any
      }
    }
  }
}

export {}