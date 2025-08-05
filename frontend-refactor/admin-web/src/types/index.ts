/**
 * 通用类型定义
 * WeWork Management Platform - Frontend
 */

// ===== 基础类型 =====

/**
 * API响应基础结构
 */
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  timestamp: number
  requestId?: string
}

/**
 * 分页结果
 */
export interface PageResult<T = any> {
  records: T[]
  total: number
  pageNum: number
  pageSize: number
  pages: number
}

/**
 * 分页查询参数
 */
export interface PageQuery {
  pageNum: number
  pageSize: number
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
}

/**
 * 基础实体
 */
export interface BaseEntity {
  id: string
  tenantId: string
  createdAt: string
  updatedAt: string
  createdBy?: string
  updatedBy?: string
}

/**
 * 基础查询表单
 */
export interface BaseSearchForm extends PageQuery {
  [key: string]: any
}

// ===== 枚举类型 =====

/**
 * 通用状态
 */
export type CommonStatus = 'active' | 'inactive' | 'deleted'

/**
 * 操作类型
 */
export type OperationType = 'create' | 'update' | 'delete' | 'read'

/**
 * 数据类型
 */
export type DataType = 'string' | 'number' | 'boolean' | 'date' | 'datetime' | 'array' | 'object'

// ===== 组件Props类型 =====

/**
 * 表格列配置
 */
export interface TableColumn {
  prop: string
  label: string
  width?: number | string
  minWidth?: number | string
  fixed?: boolean | 'left' | 'right'
  sortable?: boolean | 'custom'
  formatter?: (row: any, column: any, cellValue: any, index: number) => string
  slot?: string
  align?: 'left' | 'center' | 'right'
  headerAlign?: 'left' | 'center' | 'right'
  showOverflowTooltip?: boolean
}

/**
 * 表单项配置
 */
export interface FormItem {
  prop: string
  label: string
  type: 'input' | 'password' | 'textarea' | 'select' | 'radio' | 'checkbox' | 'date' | 'datetime' | 'number' | 'switch'
  required?: boolean
  placeholder?: string
  options?: Array<{ label: string; value: any; disabled?: boolean }>
  rules?: any[]
  span?: number
  labelWidth?: string
  disabled?: boolean
  readonly?: boolean
  hidden?: boolean
  extra?: any
}

/**
 * 菜单项
 */
export interface MenuItem {
  id: string
  name: string
  path: string
  component?: string
  icon?: string
  title: string
  hidden?: boolean
  redirect?: string
  children?: MenuItem[]
  meta?: {
    title: string
    icon?: string
    permissions?: string[]
    roles?: string[]
    keepAlive?: boolean
    hideInMenu?: boolean
    order?: number
  }
}

/**
 * 路由元信息
 */
export interface RouteMeta {
  title?: string
  icon?: string
  permissions?: string[]
  roles?: string[]
  requiresAuth?: boolean
  keepAlive?: boolean
  hideInMenu?: boolean
  hideInBreadcrumb?: boolean
  order?: number
}

// ===== 工具类型 =====

/**
 * 使某些属性可选
 */
export type PartialBy<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>

/**
 * 使某些属性必需
 */
export type RequiredBy<T, K extends keyof T> = Omit<T, K> & Required<Pick<T, K>>

/**
 * 深度可选
 */
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P]
}

/**
 * 深度必需
 */
export type DeepRequired<T> = {
  [P in keyof T]-?: T[P] extends object ? DeepRequired<T[P]> : T[P]
}

/**
 * 函数类型
 */
export type Fn<T = any> = (...args: any[]) => T

/**
 * Promise函数类型
 */
export type PromiseFn<T = any> = (...args: any[]) => Promise<T>

// ===== 事件类型 =====

/**
 * 自定义事件
 */
export interface CustomEvent<T = any> {
  type: string
  data: T
  timestamp: number
  source?: string
}

/**
 * 操作确认选项
 */
export interface ConfirmOptions {
  title?: string
  message: string
  type?: 'warning' | 'info' | 'success' | 'error'
  confirmButtonText?: string
  cancelButtonText?: string
  showCancelButton?: boolean
}

// ===== 文件上传 =====

/**
 * 文件上传响应
 */
export interface UploadResponse {
  url: string
  fileName: string
  fileSize: number
  fileType: string
  uploadTime: string
}

/**
 * 文件信息
 */
export interface FileInfo {
  name: string
  size: number
  type: string
  url?: string
  status?: 'uploading' | 'success' | 'error'
  percent?: number
  uid?: string
}

// ===== 错误处理 =====

/**
 * 业务错误
 */
export interface BusinessError {
  code: number
  message: string
  details?: any
}

/**
 * 验证错误
 */
export interface ValidationError {
  field: string
  message: string
  value?: any
}

// ===== 国际化 =====

/**
 * 语言选项
 */
export interface LanguageOption {
  label: string
  value: string
  flag?: string
}

/**
 * 翻译函数类型
 */
export type TranslateFunction = (key: string, params?: Record<string, any>) => string

// ===== 主题 =====

/**
 * 主题色彩
 */
export interface ThemeColors {
  primary: string
  success: string
  warning: string
  danger: string
  info: string
  [key: string]: string
}

/**
 * 主题配置
 */
export interface ThemeConfig {
  colors: ThemeColors
  darkMode: boolean
  borderRadius: number
  fontSize: number
  fontFamily: string
}

// ===== 权限 =====

/**
 * 权限检查函数类型
 */
export type PermissionChecker = (permission: string | string[]) => boolean

/**
 * 角色检查函数类型
 */
export type RoleChecker = (role: string | string[]) => boolean

// ===== 导出所有子模块类型 =====
export * from './app'
export * from './user'
export * from './account'
export * from './message'
export * from './monitor'