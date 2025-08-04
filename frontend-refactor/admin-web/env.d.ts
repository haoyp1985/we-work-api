/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

interface ImportMetaEnv {
  // 应用配置
  readonly VITE_APP_TITLE: string
  readonly VITE_APP_VERSION: string
  readonly VITE_NODE_ENV: string
  readonly VITE_PORT: string
  readonly VITE_PUBLIC_PATH: string

  // API配置
  readonly VITE_API_BASE_URL: string
  readonly VITE_WS_BASE_URL: string

  // 功能开关
  readonly VITE_USE_MOCK: string
  readonly VITE_USE_PROXY: string
  readonly VITE_USE_PWA: string
  readonly VITE_USE_GZIP: string
  readonly VITE_DROP_CONSOLE: string
  readonly VITE_USE_BUNDLE_ANALYZER: string

  // CDN配置
  readonly VITE_CDN_URL: string

  // 文件配置
  readonly VITE_FILE_SIZE_LIMIT: string

  // 存储配置
  readonly VITE_TOKEN_KEY: string
  readonly VITE_USER_KEY: string
  readonly VITE_THEME_KEY: string
  readonly VITE_LOCALE_KEY: string

  // 业务配置
  readonly VITE_MULTI_TENANT: string
  readonly VITE_DEFAULT_TENANT_ID: string
  readonly VITE_ROUTER_MODE: string
  readonly VITE_HOME_PATH: string
  readonly VITE_LOGIN_PATH: string
  readonly VITE_USE_PAGE_CACHE: string
  readonly VITE_USE_AUTH: string

  // 水印配置
  readonly VITE_USE_WATERMARK: string
  readonly VITE_WATERMARK_TEXT: string

  // 监控配置
  readonly VITE_USE_ERROR_MONITOR: string
  readonly VITE_ERROR_MONITOR_DSN: string
  readonly VITE_USE_PERFORMANCE_MONITOR: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

// 全局类型声明
declare global {
  const __VERSION__: string
  const __BUILD_TIME__: string
}