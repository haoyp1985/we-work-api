/**
 * 通用API响应类型
 */
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  timestamp?: number
}

/**
 * 分页参数
 */
export interface PageParams {
  page: number
  size: number
  total?: number
}

/**
 * 分页响应
 */
export interface PageResult<T> {
  records: T[]
  total: number
  current: number
  size: number
  pages: number
}

/**
 * 用户信息
 */
export interface UserInfo {
  id: string
  username: string
  nickname?: string
  avatar?: string
  email?: string
  phone?: string
  roles: string[]
  permissions: string[]
  createTime: string
  updateTime: string
}

/**
 * 登录请求
 */
export interface LoginRequest {
  username: string
  password: string
  captcha?: string
}

/**
 * 登录响应
 */
export interface LoginResponse {
  token: string
  refreshToken: string
  user: UserInfo
  expiresIn: number
}

/**
 * 企微账号信息
 */
export interface WeWorkAccount {
  id: string
  name: string
  wxid: string
  alias?: string
  avatar?: string
  mobile?: string
  status: AccountStatus
  isOnline: boolean
  lastLoginTime?: string
  deviceInfo?: string
  createTime: string
  updateTime: string
}

/**
 * 账号状态枚举
 */
export enum AccountStatus {
  INACTIVE = 'INACTIVE',
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  BANNED = 'BANNED'
}

/**
 * 消息模板
 */
export interface MessageTemplate {
  id: string
  tenantId: string
  templateName: string
  templateType: MessageTemplateType
  content: string
  status: TemplateStatus
  createTime: string
  updateTime: string
}

/**
 * 消息模板类型
 */
export enum MessageTemplateType {
  TEXT = 'TEXT',
  IMAGE = 'IMAGE',
  VIDEO = 'VIDEO',
  FILE = 'FILE',
  LINK = 'LINK',
  MINI_PROGRAM = 'MINI_PROGRAM',
  CARD = 'CARD'
}

/**
 * 模板状态
 */
export enum TemplateStatus {
  DRAFT = 'DRAFT',
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE'
}

/**
 * WeWork API 提供商
 */
export interface WeWorkProvider {
  id: string
  providerName: string
  providerType: WeWorkProviderType
  baseUrl: string
  apiKey: string
  apiSecret?: string
  status: ProviderStatus
  createTime: string
  updateTime: string
}

/**
 * 提供商类型
 */
export enum WeWorkProviderType {
  GUANGZHOU_GUXING = 'GUANGZHOU_GUXING',
  OTHER_PROVIDER = 'OTHER_PROVIDER'
}

/**
 * 提供商状态
 */
export enum ProviderStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  ERROR = 'ERROR'
}

/**
 * 发送消息请求
 */
export interface SendMessageRequest {
  providerId: string
  guid: string
  conversationId: string
  messageType: MessageTemplateType
  content?: string
  imageUrl?: string
  videoUrl?: string
  fileUrl?: string
  linkUrl?: string
  linkTitle?: string
  linkDescription?: string
  linkImage?: string
}

/**
 * 批量发送消息请求
 */
export interface BatchSendMessageRequest {
  providerId: string
  guid: string
  userIds?: string[]
  roomIds?: string[]
  content: string
  messageType: MessageTemplateType
}

/**
 * 发送消息响应
 */
export interface SendMessageResponse {
  messageId: string
  seq: number
  guid: string
  conversationId: string
  status: string
  errorMessage?: string
  sendTime: string
  providerMessageId?: string
}

/**
 * 系统监控指标
 */
export interface SystemMetrics {
  cpu: {
    usage: number
    cores: number
  }
  memory: {
    used: number
    total: number
    usage: number
  }
  disk: {
    used: number
    total: number
    usage: number
  }
  network: {
    rx: number
    tx: number
  }
  timestamp: string
}

/**
 * 服务健康状态
 */
export interface ServiceHealth {
  serviceName: string
  status: 'UP' | 'DOWN' | 'UNKNOWN'
  details?: Record<string, any>
  timestamp: string
}

/**
 * 路由菜单
 */
export interface MenuItem {
  id: string
  path: string
  name: string
  component?: string
  redirect?: string
  meta?: {
    title: string
    icon?: string
    hidden?: boolean
    roles?: string[]
    keepAlive?: boolean
    affix?: boolean
  }
  children?: MenuItem[]
}

/**
 * 表格列配置
 */
export interface TableColumn {
  prop: string
  label: string
  width?: string | number
  minWidth?: string | number
  sortable?: boolean
  formatter?: (row: any, column: any, cellValue: any) => string
  type?: 'selection' | 'index' | 'expand'
}

/**
 * 表单规则
 */
export interface FormRule {
  required?: boolean
  message?: string
  trigger?: string | string[]
  min?: number
  max?: number
  pattern?: RegExp
  validator?: (rule: any, value: any, callback: any) => void
}