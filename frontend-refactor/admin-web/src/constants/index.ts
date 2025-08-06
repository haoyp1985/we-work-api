/**
 * 全局常量定义
 */

// 应用信息
export const APP_INFO = {
  NAME: "WeWork Platform",
  VERSION: "2.0.0",
  DESCRIPTION: "Enterprise WeChat Management Platform",
} as const;

// 存储键名
export const STORAGE_KEYS = {
  TOKEN: "wework_token",
  USER_INFO: "wework_user_info",
  SETTINGS: "wework_settings",
  REMEMBER_PASSWORD: "wework_remember_password",
} as const;

// API响应状态码
export const API_CODE = {
  SUCCESS: 200,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  SERVER_ERROR: 500,
} as const;

// 分页配置
export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 20,
  PAGE_SIZE_OPTIONS: [10, 20, 50, 100],
  MAX_PAGE_SIZE: 100,
} as const;

// 文件上传配置
export const UPLOAD = {
  MAX_SIZE: 10 * 1024 * 1024, // 10MB
  ALLOWED_TYPES: {
    IMAGE: ["jpg", "jpeg", "png", "gif", "webp"],
    DOCUMENT: ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx"],
    ARCHIVE: ["zip", "rar", "7z"],
  },
} as const;

// 正则表达式
export const REGEX = {
  EMAIL: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
  PHONE: /^1[3-9]\d{9}$/,
  PASSWORD: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/,
  USERNAME: /^[a-zA-Z0-9_]{3,20}$/,
  URL: /^https?:\/\/.+/,
  IP: /^(\d{1,3}\.){3}\d{1,3}$/,
} as const;

// 日期格式
export const DATE_FORMAT = {
  DATE: "YYYY-MM-DD",
  TIME: "HH:mm:ss",
  DATETIME: "YYYY-MM-DD HH:mm:ss",
  MONTH: "YYYY-MM",
  YEAR: "YYYY",
} as const;

// 主题配置
export const THEME = {
  LIGHT: "light",
  DARK: "dark",
} as const;

// 语言配置
export const LANGUAGE = {
  ZH_CN: "zh-CN",
  EN_US: "en-US",
} as const;

// 用户状态
export const USER_STATUS = {
  ACTIVE: 1,
  DISABLED: 0,
} as const;

// 账号状态
export const ACCOUNT_STATUS = {
  ACTIVE: 1,
  DISABLED: 0,
  PENDING: 2,
  ERROR: 3,
} as const;

// 消息类型
export const MESSAGE_TYPE = {
  TEXT: "text",
  IMAGE: "image",
  VOICE: "voice",
  VIDEO: "video",
  FILE: "file",
  NEWS: "news",
  MARKDOWN: "markdown",
} as const;

// 消息状态
export const MESSAGE_STATUS = {
  PENDING: "pending",
  SENT: "sent",
  FAILED: "failed",
} as const;

// 日志级别
export const LOG_LEVEL = {
  DEBUG: "DEBUG",
  INFO: "INFO",
  WARN: "WARN",
  ERROR: "ERROR",
} as const;

// 告警级别
export const ALERT_SEVERITY = {
  CRITICAL: "CRITICAL",
  WARNING: "WARNING",
  INFO: "INFO",
} as const;

// 告警状态
export const ALERT_STATUS = {
  FIRING: "FIRING",
  RESOLVED: "RESOLVED",
} as const;

// 权限类型
export const PERMISSION_TYPE = {
  MENU: "menu",
  BUTTON: "button",
  DATA: "data",
} as const;

// 操作类型
export const OPERATION_TYPE = {
  CREATE: "create",
  UPDATE: "update",
  DELETE: "delete",
  VIEW: "view",
} as const;

// 性别
export const GENDER = {
  MALE: 1,
  FEMALE: 2,
  UNKNOWN: 0,
} as const;

// HTTP方法
export const HTTP_METHOD = {
  GET: "GET",
  POST: "POST",
  PUT: "PUT",
  DELETE: "DELETE",
  PATCH: "PATCH",
} as const;

// 排序方向
export const SORT_DIRECTION = {
  ASC: "asc",
  DESC: "desc",
} as const;
