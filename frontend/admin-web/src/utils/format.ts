import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import duration from 'dayjs/plugin/duration'
import 'dayjs/locale/zh-cn'

// 配置dayjs
dayjs.extend(relativeTime)
dayjs.extend(duration)
dayjs.locale('zh-cn')

/**
 * 数字格式化
 */
export const formatNumber = (
  value: number | string | null | undefined,
  options: {
    precision?: number
    unit?: string
    compact?: boolean
    separator?: boolean
  } = {}
): string => {
  if (value === null || value === undefined || value === '') {
    return '-'
  }
  
  const num = typeof value === 'string' ? parseFloat(value) : value
  if (isNaN(num)) return '-'
  
  const { precision = 0, unit = '', compact = false, separator = true } = options
  
  let result: string
  
  if (compact && num >= 1000) {
    if (num >= 1000000000) {
      result = (num / 1000000000).toFixed(1) + 'B'
    } else if (num >= 1000000) {
      result = (num / 1000000).toFixed(1) + 'M'
    } else if (num >= 1000) {
      result = (num / 1000).toFixed(1) + 'K'
    } else {
      result = num.toFixed(precision)
    }
  } else {
    result = num.toFixed(precision)
    
    if (separator && !compact) {
      // 添加千分位分隔符
      const parts = result.split('.')
      parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      result = parts.join('.')
    }
  }
  
  return result + unit
}

/**
 * 百分比格式化
 */
export const formatPercentage = (
  value: number | null | undefined,
  precision: number = 1
): string => {
  if (value === null || value === undefined) return '-'
  return (value * 100).toFixed(precision) + '%'
}

/**
 * 文件大小格式化
 */
export const formatFileSize = (
  bytes: number | null | undefined,
  precision: number = 1
): string => {
  if (bytes === null || bytes === undefined || bytes === 0) return '0 B'
  
  const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB']
  const unitIndex = Math.floor(Math.log(bytes) / Math.log(1024))
  const size = bytes / Math.pow(1024, unitIndex)
  
  return size.toFixed(precision) + ' ' + units[unitIndex]
}

/**
 * 带宽格式化
 */
export const formatBandwidth = (
  bps: number | null | undefined,
  precision: number = 1
): string => {
  if (bps === null || bps === undefined || bps === 0) return '0 bps'
  
  const units = ['bps', 'Kbps', 'Mbps', 'Gbps', 'Tbps']
  const unitIndex = Math.floor(Math.log(bps) / Math.log(1000))
  const bandwidth = bps / Math.pow(1000, unitIndex)
  
  return bandwidth.toFixed(precision) + ' ' + units[unitIndex]
}

/**
 * 时间格式化
 */
export const formatDateTime = (
  value: string | Date | number | null | undefined,
  format: string = 'YYYY-MM-DD HH:mm:ss'
): string => {
  if (!value) return '-'
  return dayjs(value).format(format)
}

/**
 * 相对时间格式化
 */
export const formatRelativeTime = (
  value: string | Date | number | null | undefined
): string => {
  if (!value) return '-'
  return dayjs(value).fromNow()
}

/**
 * 时长格式化
 */
export const formatDuration = (
  seconds: number | null | undefined,
  options: {
    format?: 'short' | 'long'
    precision?: 'second' | 'minute' | 'hour' | 'day'
  } = {}
): string => {
  if (seconds === null || seconds === undefined || seconds < 0) return '-'
  
  const { format = 'short', precision = 'second' } = options
  const dur = dayjs.duration(seconds, 'seconds')
  
  const days = Math.floor(dur.asDays())
  const hours = dur.hours()
  const minutes = dur.minutes()
  const secs = dur.seconds()
  
  if (format === 'long') {
    const parts: string[] = []
    if (days > 0) parts.push(`${days}天`)
    if (hours > 0) parts.push(`${hours}小时`)
    if (minutes > 0 && precision !== 'hour') parts.push(`${minutes}分钟`)
    if (secs > 0 && precision === 'second') parts.push(`${secs}秒`)
    
    return parts.join('') || '0秒'
  } else {
    // 短格式
    if (days > 0) {
      return `${days}d ${hours}h`
    } else if (hours > 0) {
      return `${hours}h ${minutes}m`
    } else if (minutes > 0) {
      return precision === 'second' ? `${minutes}m ${secs}s` : `${minutes}m`
    } else {
      return precision === 'second' ? `${secs}s` : '< 1m'
    }
  }
}

/**
 * 状态文本格式化
 */
export const formatStatus = (
  status: string,
  statusMap: Record<string, { text: string; type?: string }> = {}
): { text: string; type: string } => {
  const statusInfo = statusMap[status]
  
  if (statusInfo) {
    return {
      text: statusInfo.text,
      type: statusInfo.type || 'info'
    }
  }
  
  // 默认状态映射
  const defaultMap: Record<string, { text: string; type: string }> = {
    ONLINE: { text: '在线', type: 'success' },
    OFFLINE: { text: '离线', type: 'danger' },
    ERROR: { text: '错误', type: 'danger' },
    RECOVERING: { text: '恢复中', type: 'warning' },
    WAITING_QR: { text: '等待扫码', type: 'warning' },
    WAITING_CONFIRM: { text: '等待确认', type: 'warning' },
    VERIFYING: { text: '验证中', type: 'info' },
    ACTIVE: { text: '正常', type: 'success' },
    INACTIVE: { text: '未激活', type: 'info' },
    SUSPENDED: { text: '已暂停', type: 'warning' },
    EXPIRED: { text: '已过期', type: 'danger' }
  }
  
  return defaultMap[status] || { text: status, type: 'info' }
}

/**
 * 健康分数格式化
 */
export const formatHealthScore = (
  score: number | null | undefined
): { 
  score: string
  level: string
  color: string
  type: 'excellent' | 'good' | 'fair' | 'poor' | 'unknown'
} => {
  if (score === null || score === undefined) {
    return {
      score: '-',
      level: '未知',
      color: '#909399',
      type: 'unknown'
    }
  }
  
  if (score >= 90) {
    return {
      score: score.toString(),
      level: '优秀',
      color: '#67C23A',
      type: 'excellent'
    }
  } else if (score >= 80) {
    return {
      score: score.toString(),
      level: '良好',
      color: '#409EFF',
      type: 'good'
    }
  } else if (score >= 60) {
    return {
      score: score.toString(),
      level: '一般',
      color: '#E6A23C',
      type: 'fair'
    }
  } else {
    return {
      score: score.toString(),
      level: '较差',
      color: '#F56C6C',
      type: 'poor'
    }
  }
}

/**
 * API响应时间格式化
 */
export const formatResponseTime = (
  ms: number | null | undefined
): string => {
  if (ms === null || ms === undefined) return '-'
  
  if (ms < 1000) {
    return `${ms}ms`
  } else {
    return `${(ms / 1000).toFixed(1)}s`
  }
}

/**
 * 错误率格式化
 */
export const formatErrorRate = (
  rate: number | null | undefined,
  precision: number = 2
): { 
  rate: string
  level: 'excellent' | 'good' | 'warning' | 'danger'
  color: string
} => {
  if (rate === null || rate === undefined) {
    return {
      rate: '-',
      level: 'excellent',
      color: '#67C23A'
    }
  }
  
  const formattedRate = (rate * 100).toFixed(precision) + '%'
  
  if (rate <= 0.01) { // <= 1%
    return {
      rate: formattedRate,
      level: 'excellent',
      color: '#67C23A'
    }
  } else if (rate <= 0.05) { // <= 5%
    return {
      rate: formattedRate,
      level: 'good',
      color: '#409EFF'
    }
  } else if (rate <= 0.1) { // <= 10%
    return {
      rate: formattedRate,
      level: 'warning',
      color: '#E6A23C'
    }
  } else {
    return {
      rate: formattedRate,
      level: 'danger',
      color: '#F56C6C'
    }
  }
}

/**
 * 趋势格式化
 */
export const formatTrend = (
  currentValue: number,
  previousValue: number | null = null,
  unit: string = '%'
): {
  value: string
  type: 'up' | 'down' | 'flat'
  color: string
  isImprovement: boolean
} => {
  if (previousValue === null || previousValue === 0) {
    return {
      value: '-',
      type: 'flat',
      color: '#909399',
      isImprovement: false
    }
  }
  
  const change = currentValue - previousValue
  const percentage = Math.abs(change / previousValue) * 100
  
  if (Math.abs(change) < 0.01) { // 变化很小
    return {
      value: '0' + unit,
      type: 'flat',
      color: '#909399',
      isImprovement: false
    }
  }
  
  const type = change > 0 ? 'up' : 'down'
  const isImprovement = change > 0 // 这里假设增长是好的，具体业务场景可能需要调整
  
  return {
    value: percentage.toFixed(1) + unit,
    type,
    color: isImprovement ? '#67C23A' : '#F56C6C',
    isImprovement
  }
}

/**
 * 金额格式化
 */
export const formatCurrency = (
  amount: number | null | undefined,
  currency: string = '¥',
  precision: number = 2
): string => {
  if (amount === null || amount === undefined) return '-'
  
  const formatted = formatNumber(amount, { precision, separator: true })
  return currency + formatted
}

/**
 * 隐私数据脱敏
 */
export const maskSensitiveData = (
  data: string | null | undefined,
  type: 'phone' | 'email' | 'id' | 'custom',
  maskChar: string = '*',
  customPattern?: { start: number; end: number }
): string => {
  if (!data) return '-'
  
  switch (type) {
    case 'phone':
      return data.length >= 11 
        ? data.slice(0, 3) + '****' + data.slice(-4)
        : data
        
    case 'email':
      const atIndex = data.indexOf('@')
      if (atIndex > 0) {
        const localPart = data.slice(0, atIndex)
        const domainPart = data.slice(atIndex)
        const maskedLocal = localPart.length > 2
          ? localPart.slice(0, 1) + '***' + localPart.slice(-1)
          : localPart
        return maskedLocal + domainPart
      }
      return data
      
    case 'id':
      return data.length > 6
        ? data.slice(0, 3) + '***' + data.slice(-3)
        : data
        
    case 'custom':
      if (customPattern) {
        const { start, end } = customPattern
        const maskLength = data.length - start - end
        if (maskLength > 0) {
          return data.slice(0, start) + 
                 maskChar.repeat(Math.min(maskLength, 6)) + 
                 data.slice(-end)
        }
      }
      return data
      
    default:
      return data
  }
}