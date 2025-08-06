/**
 * 应用相关类型定义
 * WeWork Management Platform - Frontend
 */

// ===== 主题类型 =====

/**
 * 主题模式
 */
export type Theme = "light" | "dark" | "auto";

/**
 * 语言类型
 */
export type Language = "zh-CN" | "en-US" | "ja-JP";

/**
 * 设备类型
 */
export type DeviceType = "desktop" | "tablet" | "mobile";

/**
 * 侧边栏状态
 */
export type SidebarState = "expanded" | "collapsed";

// ===== 应用设置 =====

/**
 * 应用设置
 */
export interface AppSettings {
  // 显示设置
  showTabs: boolean;
  showBreadcrumb: boolean;
  showFooter: boolean;
  showSettings: boolean;

  // 布局设置
  fixedHeader: boolean;
  fixedSidebar: boolean;

  // 功能设置
  animationEnabled: boolean;
  watermarkEnabled: boolean;

  // 主题设置
  grayMode: boolean;
  colorWeakMode: boolean;
}

/**
 * 布局配置
 */
export interface LayoutConfig {
  // 头部配置
  header: {
    height: number;
    fixed: boolean;
    background: string;
  };

  // 侧边栏配置
  sidebar: {
    width: number;
    collapsedWidth: number;
    background: string;
    textColor: string;
    activeBackground: string;
  };

  // 内容区域配置
  content: {
    padding: number;
    background: string;
  };

  // 标签页配置
  tabs: {
    height: number;
    background: string;
    borderColor: string;
  };
}

// ===== 菜单和导航 =====

/**
 * 面包屑项
 */
export interface BreadcrumbItem {
  name: string;
  path?: string;
  title: string;
  meta?: any;
}

/**
 * 标签页项
 */
export interface TabItem {
  name: string;
  path: string;
  title: string;
  closable?: boolean;
  meta?: any;
}

/**
 * 导航菜单项
 */
export interface NavigationItem {
  id: string;
  title: string;
  path: string;
  icon?: string;
  badge?: string | number;
  children?: NavigationItem[];
  meta?: {
    permissions?: string[];
    roles?: string[];
    hidden?: boolean;
    disabled?: boolean;
    external?: boolean;
    target?: "_blank" | "_self";
  };
}

// ===== 通知和消息 =====

/**
 * 通知类型
 */
export type NotificationType = "success" | "warning" | "info" | "error";

/**
 * 通知项
 */
export interface NotificationItem {
  id: string;
  type: NotificationType;
  title: string;
  message: string;
  duration?: number;
  showClose?: boolean;
  onClick?: () => void;
  onClose?: () => void;
}

/**
 * 消息提示选项
 */
export interface MessageOptions {
  type: NotificationType;
  message: string;
  duration?: number;
  showClose?: boolean;
  center?: boolean;
  dangerouslyUseHTMLString?: boolean;
}

// ===== 加载状态 =====

/**
 * 加载状态
 */
export interface LoadingState {
  global: boolean;
  page: boolean;
  component: boolean;
  [key: string]: boolean;
}

/**
 * 加载选项
 */
export interface LoadingOptions {
  text?: string;
  spinner?: string;
  background?: string;
  customClass?: string;
  lock?: boolean;
  target?: string | HTMLElement;
}

// ===== 错误处理 =====

/**
 * 错误信息
 */
export interface ErrorInfo {
  code: number;
  message: string;
  stack?: string;
  timestamp: number;
  url?: string;
  userAgent?: string;
}

/**
 * 错误日志
 */
export interface ErrorLog {
  id: string;
  error: ErrorInfo;
  user?: {
    id: string;
    username: string;
  };
  context?: {
    route: string;
    action: string;
    params?: any;
  };
}

// ===== 系统配置 =====

/**
 * 系统信息
 */
export interface SystemInfo {
  name: string;
  version: string;
  description: string;
  author: string;
  homepage: string;
  repository: string;
  license: string;
  buildTime: string;
  gitCommit?: string;
  gitBranch?: string;
}

/**
 * 环境配置
 */
export interface EnvironmentConfig {
  NODE_ENV: "development" | "production" | "test";
  BASE_URL: string;
  API_BASE_URL: string;
  UPLOAD_URL: string;
  WEBSOCKET_URL: string;

  // 功能开关
  ENABLE_MOCK: boolean;
  ENABLE_PWA: boolean;
  ENABLE_CDN: boolean;
  ENABLE_GZIP: boolean;

  // 第三方服务
  SENTRY_DSN?: string;
  GOOGLE_ANALYTICS_ID?: string;
}

// ===== 性能监控 =====

/**
 * 性能指标
 */
export interface PerformanceMetrics {
  // 页面加载时间
  pageLoadTime: number;

  // 资源加载时间
  resourceLoadTime: number;

  // API响应时间
  apiResponseTime: number;

  // 内存使用
  memoryUsage: {
    used: number;
    total: number;
    percentage: number;
  };

  // 错误统计
  errorCount: number;

  // 用户行为
  userActions: number;

  // 时间戳
  timestamp: number;
}

/**
 * 用户行为事件
 */
export interface UserActionEvent {
  id: string;
  type: "click" | "scroll" | "input" | "navigation" | "error";
  target: string;
  timestamp: number;
  data?: any;
  duration?: number;
}

// ===== 缓存管理 =====

/**
 * 缓存项
 */
export interface CacheItem<T = any> {
  key: string;
  value: T;
  expireTime?: number;
  createTime: number;
  accessTime: number;
  accessCount: number;
}

/**
 * 缓存配置
 */
export interface CacheConfig {
  // 默认过期时间（毫秒）
  defaultExpire: number;

  // 最大缓存数量
  maxSize: number;

  // 清理策略
  cleanupStrategy: "lru" | "fifo" | "ttl";

  // 是否启用持久化
  persistent: boolean;

  // 存储类型
  storage: "memory" | "localStorage" | "sessionStorage";
}

// ===== 快捷键 =====

/**
 * 快捷键配置
 */
export interface ShortcutConfig {
  key: string;
  description: string;
  handler: () => void;
  disabled?: boolean;
  global?: boolean;
}

/**
 * 快捷键组
 */
export interface ShortcutGroup {
  name: string;
  shortcuts: ShortcutConfig[];
}

// ===== 工作区设置 =====

/**
 * 工作区配置
 */
export interface WorkspaceConfig {
  // 当前工作区ID
  currentWorkspace: string;

  // 工作区列表
  workspaces: Array<{
    id: string;
    name: string;
    description?: string;
    avatar?: string;
    settings?: Record<string, any>;
  }>;

  // 个人偏好设置
  preferences: {
    theme: Theme;
    language: Language;
    dateFormat: string;
    timeFormat: string;
    timezone: string;
    currency: string;
  };
}
