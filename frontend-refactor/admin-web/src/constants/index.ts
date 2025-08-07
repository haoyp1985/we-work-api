/**
 * 应用常量定义
 * WeWork Management Platform - Frontend
 */

// ===== 应用信息 =====
export const APP_INFO = {
  NAME: 'WeWork Platform',
  VERSION: '2.0.0',
  DESCRIPTION: '企业微信管理平台',
  COMPANY: 'WeWork Inc.',
  WEBSITE: 'https://wework.example.com'
} as const

// ===== 应用配置 =====
export const APP_CONFIG = {
  // 应用信息
  APP_NAME: 'WeWork Management Platform',
  APP_VERSION: '2.0.0',
  APP_DESCRIPTION: '企业微信管理平台',
  
  // 公司信息
  COMPANY_NAME: 'WeWork Platform',
  COMPANY_WEBSITE: 'https://wework.example.com',
  
  // 技术支持
  SUPPORT_EMAIL: 'support@wework.example.com',
  SUPPORT_PHONE: '400-000-0000',
  
  // API配置
  API_BASE_URL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:18080',
  API_TIMEOUT: 30000,
  
  // 分页配置
  DEFAULT_PAGE_SIZE: 20,
  PAGE_SIZE_OPTIONS: [10, 20, 50, 100],
  
  // 上传配置
  MAX_FILE_SIZE: 10 * 1024 * 1024, // 10MB
  ALLOWED_FILE_TYPES: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf'],
  
  // 缓存配置
  TOKEN_STORAGE_KEY: 'wework_token',
  USER_INFO_STORAGE_KEY: 'wework_user_info',
  REFRESH_TOKEN_STORAGE_KEY: 'wework_refresh_token',
  
  // 主题配置
  DEFAULT_THEME: 'light',
  THEME_STORAGE_KEY: 'wework_theme',
  
  // 语言配置
  DEFAULT_LOCALE: 'zh-CN',
  LOCALE_STORAGE_KEY: 'wework_locale',
  
  // 路由配置
  LOGIN_PATH: '/login',
  HOME_PATH: '/dashboard',
  LOGOUT_REDIRECT_PATH: '/login',
} as const

// ===== 业务常量 =====

// 用户状态
export const USER_STATUS = {
  ACTIVE: 'ACTIVE',
  INACTIVE: 'INACTIVE',
  LOCKED: 'LOCKED',
  EXPIRED: 'EXPIRED'
} as const

// 账号状态
export const ACCOUNT_STATUS = {
  ONLINE: 'ONLINE',
  OFFLINE: 'OFFLINE',
  ERROR: 'ERROR',
  CREATED: 'CREATED',
  INITIALIZING: 'INITIALIZING',
  WAITING_QR: 'WAITING_QR',
  WAITING_CONFIRM: 'WAITING_CONFIRM',
  VERIFYING: 'VERIFYING',
  RECOVERING: 'RECOVERING'
} as const

// 消息状态
export const MESSAGE_STATUS = {
  SENDING: 'SENDING',
  SENT: 'SENT',
  DELIVERED: 'DELIVERED',
  FAILED: 'FAILED',
  READ: 'READ'
} as const

// 平台类型
export const PLATFORM_TYPE = {
  OPENAI: 'OPENAI',
  ANTHROPIC_CLAUDE: 'ANTHROPIC_CLAUDE',
  BAIDU_WENXIN: 'BAIDU_WENXIN',
  COZE: 'COZE',
  DIFY: 'DIFY'
} as const

// 智能体状态
export const AGENT_STATUS = {
  DRAFT: 'DRAFT',
  PUBLISHED: 'PUBLISHED',
  DISABLED: 'DISABLED'
} as const

// ===== UI常量 =====

// 主题类型
export const THEME_TYPE = {
  LIGHT: 'light',
  DARK: 'dark',
  AUTO: 'auto'
} as const

// 语言类型
export const LOCALE_TYPE = {
  ZH_CN: 'zh-CN',
  EN_US: 'en-US'
} as const

// 性别类型
export const GENDER_TYPE = {
  MALE: 'male',
  FEMALE: 'female',
  UNKNOWN: 'unknown'
} as const

// 布局类型
export const LAYOUT_TYPE = {
  SIDE: 'side',
  TOP: 'top',
  MIX: 'mix'
} as const

// ===== 正则表达式 =====
export const REGEX = {
  // 用户名：字母、数字、下划线，3-20位
  USERNAME: /^[a-zA-Z0-9_]+$/,
  
  // 密码：至少包含字母和数字，6-20位
  PASSWORD: /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,20}$/,
  
  // 邮箱
  EMAIL: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
  
  // 手机号
  PHONE: /^1[3-9]\d{9}$/,
  
  // 身份证号
  ID_CARD: /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/,
  
  // 中文姓名
  CHINESE_NAME: /^[\u4e00-\u9fa5]{2,10}$/,
  
  // URL
  URL: /^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$/,
  
  // IP地址
  IP: /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
} as const

// ===== 表单验证规则 =====

// 用户名规则
export const USERNAME_RULES = {
  MIN_LENGTH: 3,
  MAX_LENGTH: 20,
  PATTERN: /^[a-zA-Z0-9_-]+$/,
  MESSAGE: '用户名只能包含字母、数字、下划线和短横线，长度3-20位'
}

// 密码规则
export const PASSWORD_RULES = {
  MIN_LENGTH: 6,
  MAX_LENGTH: 20,
  PATTERN: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,20}$/,
  MESSAGE: '密码必须包含大小写字母和数字，长度6-20位'
}

// 邮箱规则
export const EMAIL_RULES = {
  PATTERN: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
  MESSAGE: '请输入有效的邮箱地址'
}

// 手机号规则
export const PHONE_RULES = {
  PATTERN: /^1[3-9]\d{9}$/,
  MESSAGE: '请输入有效的手机号码'
}

// ===== 错误消息 =====

export const ERROR_MESSAGES = {
  // 网络错误
  NETWORK_ERROR: '网络连接失败，请检查网络设置',
  REQUEST_TIMEOUT: '请求超时，请稍后重试',
  SERVER_ERROR: '服务器错误，请稍后重试',
  
  // 认证错误
  UNAUTHORIZED: '登录已过期，请重新登录',
  FORBIDDEN: '权限不足，无法访问',
  TOKEN_EXPIRED: 'Token已过期，请重新登录',
  
  // 业务错误
  USER_NOT_FOUND: '用户不存在',
  PASSWORD_ERROR: '密码错误',
  ACCOUNT_LOCKED: '账号已被锁定',
  CAPTCHA_ERROR: '验证码错误',
  
  // 表单验证错误
  REQUIRED_FIELD: '此字段为必填项',
  INVALID_FORMAT: '格式不正确',
  PASSWORD_MISMATCH: '两次输入的密码不一致',
  
  // 上传错误
  FILE_TOO_LARGE: '文件大小超出限制',
  FILE_TYPE_ERROR: '文件类型不支持',
  UPLOAD_FAILED: '文件上传失败'
} as const

// ===== 成功消息 =====

export const SUCCESS_MESSAGES = {
  SAVE_SUCCESS: '保存成功',
  UPDATE_SUCCESS: '更新成功',
  DELETE_SUCCESS: '删除成功',
  UPLOAD_SUCCESS: '上传成功',
  LOGIN_SUCCESS: '登录成功',
  LOGOUT_SUCCESS: '退出成功',
  SEND_SUCCESS: '发送成功'
} as const

// ===== 路由元信息 =====

export const ROUTE_META = {
  // 页面标题
  TITLES: {
    DASHBOARD: '仪表盘',
    ACCOUNT_LIST: '账号列表',
    ACCOUNT_DETAIL: '账号详情',
    MESSAGE_LIST: '消息列表',
    USER_LIST: '用户列表',
    ROLE_LIST: '角色列表',
    PERMISSION_LIST: '权限列表',
    SYSTEM_SETTINGS: '系统设置',
    PROFILE: '个人资料',
    LOGIN: '用户登录'
  },
  
  // 页面图标
  ICONS: {
    DASHBOARD: 'dashboard',
    ACCOUNT: 'user',
    MESSAGE: 'message',
    USER: 'user-group',
    ROLE: 'shield',
    PERMISSION: 'key',
    SETTINGS: 'setting',
    PROFILE: 'user-circle'
  }
} as const

// ===== 日期时间格式 =====

export const DATE_FORMATS = {
  DATE: 'YYYY-MM-DD',
  DATETIME: 'YYYY-MM-DD HH:mm:ss',
  TIME: 'HH:mm:ss',
  MONTH: 'YYYY-MM',
  YEAR: 'YYYY'
} as const

// ===== 数据状态 =====

export const DATA_STATUS = {
  LOADING: 'loading',
  SUCCESS: 'success',
  ERROR: 'error',
  EMPTY: 'empty'
} as const

// ===== 操作类型 =====

export const OPERATION_TYPE = {
  CREATE: 'create',
  UPDATE: 'update',
  DELETE: 'delete',
  VIEW: 'view',
  EXPORT: 'export',
  IMPORT: 'import'
} as const

// ===== 存储键名 =====

export const STORAGE_KEYS = {
  // Token相关
  ACCESS_TOKEN: 'access_token',
  REFRESH_TOKEN: 'refresh_token',
  
  // 用户信息
  USER_INFO: 'user_info',
  USER_PERMISSIONS: 'user_permissions',
  
  // 登录相关
  REMEMBER_PASSWORD: 'remember_password',
  LAST_LOGIN_USERNAME: 'last_login_username',
  
  // 偏好设置
  THEME: 'theme',
  LOCALE: 'locale',
  SIDEBAR_COLLAPSED: 'sidebar_collapsed',
  
  // 缓存数据
  MENU_CACHE: 'menu_cache',
  DICT_CACHE: 'dict_cache'
} as const

// ===== 默认值 =====

export const DEFAULT_VALUES = {
  // 分页
  PAGE_SIZE: 20,
  PAGE_NUM: 1,
  
  // 排序
  SORT_ORDER: 'desc',
  SORT_FIELD: 'createdAt',
  
  // 用户头像
  DEFAULT_AVATAR: '/images/default-avatar.png',
  
  // 空数据文本
  EMPTY_TEXT: '暂无数据',
  
  // 加载文本
  LOADING_TEXT: '加载中...'
} as const