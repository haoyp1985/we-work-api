/**
 * 通用工具函数
 * WeWork Management Platform - Frontend
 */

// ===== 字符串工具 =====

/**
 * 首字母大写
 */
export const capitalize = (str: string): string => {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

/**
 * 驼峰转短横线
 */
export const kebabCase = (str: string): string => {
  return str.replace(/([A-Z])/g, '-$1').toLowerCase()
}

/**
 * 短横线转驼峰
 */
export const camelCase = (str: string): string => {
  return str.replace(/-([a-z])/g, (_, letter) => letter.toUpperCase())
}

/**
 * 生成随机字符串
 */
export const randomString = (length: number = 8): string => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  let result = ''
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return result
}

/**
 * 截取字符串并添加省略号
 */
export const truncate = (str: string, length: number = 100): string => {
  if (str.length <= length) return str
  return str.slice(0, length) + '...'
}

// ===== 数字工具 =====

/**
 * 格式化数字
 */
export const formatNumber = (num: number, locale: string = 'zh-CN'): string => {
  return new Intl.NumberFormat(locale).format(num)
}

/**
 * 格式化文件大小
 */
export const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 B'
  
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return `${parseFloat((bytes / Math.pow(k, i)).toFixed(2))} ${sizes[i]}`
}

/**
 * 生成随机数
 */
export const randomNumber = (min: number = 0, max: number = 100): number => {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

// ===== 日期时间工具 =====

/**
 * 格式化日期
 */
export const formatDate = (date: Date | string | number, format: string = 'YYYY-MM-DD HH:mm:ss'): string => {
  const d = new Date(date)
  
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  const hours = String(d.getHours()).padStart(2, '0')
  const minutes = String(d.getMinutes()).padStart(2, '0')
  const seconds = String(d.getSeconds()).padStart(2, '0')
  
  return format
    .replace('YYYY', String(year))
    .replace('MM', month)
    .replace('DD', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds)
}

/**
 * 相对时间
 */
export const timeAgo = (date: Date | string | number): string => {
  const now = new Date()
  const target = new Date(date)
  const diff = now.getTime() - target.getTime()
  
  const minute = 60 * 1000
  const hour = minute * 60
  const day = hour * 24
  const month = day * 30
  const year = day * 365
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else if (diff < day) {
    return `${Math.floor(diff / hour)}小时前`
  } else if (diff < month) {
    return `${Math.floor(diff / day)}天前`
  } else if (diff < year) {
    return `${Math.floor(diff / month)}个月前`
  } else {
    return `${Math.floor(diff / year)}年前`
  }
}

// ===== 对象工具 =====

/**
 * 深拷贝
 */
export const deepClone = <T>(obj: T): T => {
  if (obj === null || typeof obj !== 'object') return obj
  if (obj instanceof Date) return new Date(obj.getTime()) as unknown as T
  if (obj instanceof Array) return obj.map(item => deepClone(item)) as unknown as T
  if (typeof obj === 'object') {
    const cloned = {} as T
    for (const key in obj) {
      if (obj.hasOwnProperty(key)) {
        cloned[key] = deepClone(obj[key])
      }
    }
    return cloned
  }
  return obj
}

/**
 * 合并对象
 */
export const mergeObjects = <T extends Record<string, any>>(target: T, ...sources: Partial<T>[]): T => {
  return Object.assign({}, target, ...sources)
}

/**
 * 移除对象中的空值
 */
export const removeEmptyValues = (obj: Record<string, any>): Record<string, any> => {
  const result: Record<string, any> = {}
  
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
      const value = obj[key]
      if (value !== null && value !== undefined && value !== '') {
        result[key] = value
      }
    }
  }
  
  return result
}

// ===== 数组工具 =====

/**
 * 数组去重
 */
export const uniqueArray = <T>(arr: T[]): T[] => {
  return [...new Set(arr)]
}

/**
 * 数组分组
 */
export const groupBy = <T>(arr: T[], key: keyof T): Record<string, T[]> => {
  return arr.reduce((groups, item) => {
    const group = String(item[key])
    groups[group] = groups[group] || []
    groups[group].push(item)
    return groups
  }, {} as Record<string, T[]>)
}

/**
 * 数组排序
 */
export const sortBy = <T>(arr: T[], key: keyof T, order: 'asc' | 'desc' = 'asc'): T[] => {
  return [...arr].sort((a, b) => {
    const aVal = a[key]
    const bVal = b[key]
    
    if (aVal < bVal) return order === 'asc' ? -1 : 1
    if (aVal > bVal) return order === 'asc' ? 1 : -1
    return 0
  })
}

// ===== URL工具 =====

/**
 * 解析URL参数
 */
export const parseUrlParams = (url: string = window.location.search): Record<string, string> => {
  const params: Record<string, string> = {}
  const urlParams = new URLSearchParams(url)
  
  for (const [key, value] of urlParams) {
    params[key] = value
  }
  
  return params
}

/**
 * 构建URL参数
 */
export const buildUrlParams = (params: Record<string, any>): string => {
  const urlParams = new URLSearchParams()
  
  for (const key in params) {
    if (params[key] !== null && params[key] !== undefined) {
      urlParams.append(key, String(params[key]))
    }
  }
  
  return urlParams.toString()
}

// ===== 验证工具 =====

/**
 * 邮箱验证
 */
export const isEmail = (email: string): boolean => {
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  return emailRegex.test(email)
}

/**
 * 手机号验证
 */
export const isPhone = (phone: string): boolean => {
  const phoneRegex = /^1[3-9]\d{9}$/
  return phoneRegex.test(phone)
}

/**
 * URL验证
 */
export const isUrl = (url: string): boolean => {
  try {
    new URL(url)
    return true
  } catch {
    return false
  }
}

/**
 * IP地址验证
 */
export const isIP = (ip: string): boolean => {
  const ipRegex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
  return ipRegex.test(ip)
}

// ===== 存储工具 =====

/**
 * localStorage工具
 */
export const storage = {
  get: <T = any>(key: string): T | null => {
    try {
      const item = localStorage.getItem(key)
      return item ? JSON.parse(item) : null
    } catch {
      return null
    }
  },
  
  set: (key: string, value: any): void => {
    try {
      localStorage.setItem(key, JSON.stringify(value))
    } catch (error) {
      console.error('Failed to save to localStorage:', error)
    }
  },
  
  remove: (key: string): void => {
    localStorage.removeItem(key)
  },
  
  clear: (): void => {
    localStorage.clear()
  }
}

/**
 * sessionStorage工具
 */
export const sessionStorage = {
  get: <T = any>(key: string): T | null => {
    try {
      const item = window.sessionStorage.getItem(key)
      return item ? JSON.parse(item) : null
    } catch {
      return null
    }
  },
  
  set: (key: string, value: any): void => {
    try {
      window.sessionStorage.setItem(key, JSON.stringify(value))
    } catch (error) {
      console.error('Failed to save to sessionStorage:', error)
    }
  },
  
  remove: (key: string): void => {
    window.sessionStorage.removeItem(key)
  },
  
  clear: (): void => {
    window.sessionStorage.clear()
  }
}

// ===== DOM工具 =====

/**
 * 设置页面标题
 */
export const setPageTitle = (title: string): void => {
  document.title = title ? `${title} - WeWork Platform` : 'WeWork Platform'
}

/**
 * 添加样式类
 */
export const addClass = (element: HTMLElement, className: string): void => {
  if (!element.classList.contains(className)) {
    element.classList.add(className)
  }
}

/**
 * 移除样式类
 */
export const removeClass = (element: HTMLElement, className: string): void => {
  element.classList.remove(className)
}

/**
 * 切换样式类
 */
export const toggleClass = (element: HTMLElement, className: string): void => {
  element.classList.toggle(className)
}

/**
 * 滚动到顶部
 */
export const scrollToTop = (smooth: boolean = true): void => {
  window.scrollTo({
    top: 0,
    behavior: smooth ? 'smooth' : 'auto'
  })
}

/**
 * 滚动到元素
 */
export const scrollToElement = (element: HTMLElement, smooth: boolean = true): void => {
  element.scrollIntoView({
    behavior: smooth ? 'smooth' : 'auto',
    block: 'start'
  })
}

// ===== 防抖节流 =====

/**
 * 防抖函数
 */
export const debounce = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let timeout: NodeJS.Timeout | null = null
  
  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout)
    timeout = setTimeout(() => func.apply(this, args), wait)
  }
}

/**
 * 节流函数
 */
export const throttle = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let inThrottle = false
  
  return (...args: Parameters<T>) => {
    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => inThrottle = false, wait)
    }
  }
}

// ===== 其他工具 =====

/**
 * 复制到剪贴板
 */
export const copyToClipboard = async (text: string): Promise<boolean> => {
  try {
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(text)
      return true
    } else {
      // 降级方案
      const textArea = document.createElement('textarea')
      textArea.value = text
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      return true
    }
  } catch {
    return false
  }
}

/**
 * 下载文件
 */
export const downloadFile = (blob: Blob, filename: string): void => {
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  window.URL.revokeObjectURL(url)
}

/**
 * 打开新窗口
 */
export const openWindow = (url: string, target: string = '_blank'): void => {
  window.open(url, target)
}

/**
 * 检测是否为移动设备
 */
export const isMobile = (): boolean => {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
    navigator.userAgent
  )
}

/**
 * 获取用户代理信息
 */
export const getUserAgent = (): string => {
  return navigator.userAgent
}

/**
 * 获取浏览器信息
 */
export const getBrowserInfo = (): { name: string; version: string } => {
  const ua = navigator.userAgent
  let name = 'Unknown'
  let version = 'Unknown'
  
  if (ua.indexOf('Chrome') > -1) {
    name = 'Chrome'
    version = ua.match(/Chrome\/(\d+)/)?.[1] || 'Unknown'
  } else if (ua.indexOf('Firefox') > -1) {
    name = 'Firefox'
    version = ua.match(/Firefox\/(\d+)/)?.[1] || 'Unknown'
  } else if (ua.indexOf('Safari') > -1) {
    name = 'Safari'
    version = ua.match(/Version\/(\d+)/)?.[1] || 'Unknown'
  } else if (ua.indexOf('Edge') > -1) {
    name = 'Edge'
    version = ua.match(/Edge\/(\d+)/)?.[1] || 'Unknown'
  }
  
  return { name, version }
}

/**
 * 环境检测
 */
export const isProduction = (): boolean => {
  return import.meta.env.PROD
}

export const isDevelopment = (): boolean => {
  return import.meta.env.DEV
}

/**
 * 错误处理
 */
export const handleError = (error: any, context?: string): void => {
  console.error(`Error ${context ? `in ${context}` : ''}:`, error)
  
  // 在生产环境中可以发送错误到监控服务
  if (isProduction()) {
    // 发送错误到监控服务
    // sendErrorToMonitoring(error, context)
  }
}