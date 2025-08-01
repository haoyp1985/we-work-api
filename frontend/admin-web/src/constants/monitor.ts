import type { 
  WeWorkAccountStatus, 
  AlertLevel, 
  AlertType, 
  AlertStatus,
  TenantStatus,
  TenantType 
} from '@/types'

/**
 * 企微账号状态配置
 */
export const ACCOUNT_STATUS_CONFIG: Record<WeWorkAccountStatus, {
  text: string
  type: 'success' | 'warning' | 'danger' | 'info'
  color: string
  icon?: string
  description?: string
}> = {
  CREATED: {
    text: '已创建',
    type: 'info',
    color: '#909399',
    description: '账号已创建，等待初始化'
  },
  INITIALIZING: {
    text: '初始化中',
    type: 'info',
    color: '#409EFF',
    description: '正在初始化账号配置'
  },
  WAITING_QR: {
    text: '等待扫码',
    type: 'warning',
    color: '#E6A23C',
    description: '等待用户扫描二维码登录'
  },
  WAITING_CONFIRM: {
    text: '等待确认',
    type: 'warning',
    color: '#E6A23C',
    description: '等待用户在手机上确认登录'
  },
  VERIFYING: {
    text: '验证中',
    type: 'info',
    color: '#409EFF',
    description: '正在验证登录信息'
  },
  ONLINE: {
    text: '在线',
    type: 'success',
    color: '#67C23A',
    description: '账号正常在线'
  },
  OFFLINE: {
    text: '离线',
    type: 'danger',
    color: '#F56C6C',
    description: '账号已离线'
  },
  ERROR: {
    text: '异常',
    type: 'danger',
    color: '#F56C6C',
    description: '账号出现异常'
  },
  RECOVERING: {
    text: '恢复中',
    type: 'warning',
    color: '#E6A23C',
    description: '正在尝试自动恢复'
  }
}

/**
 * 告警级别配置
 */
export const ALERT_LEVEL_CONFIG: Record<AlertLevel, {
  text: string
  type: 'success' | 'warning' | 'danger' | 'info'
  color: string
  bgColor: string
  priority: number
  icon?: string
}> = {
  CRITICAL: {
    text: '严重',
    type: 'danger',
    color: '#F56C6C',
    bgColor: 'rgba(245, 108, 108, 0.1)',
    priority: 4,
    icon: 'Warning'
  },
  ERROR: {
    text: '错误',
    type: 'danger',
    color: '#F56C6C',
    bgColor: 'rgba(245, 108, 108, 0.1)',
    priority: 3,
    icon: 'CircleClose'
  },
  WARNING: {
    text: '警告',
    type: 'warning',
    color: '#E6A23C',
    bgColor: 'rgba(230, 162, 60, 0.1)',
    priority: 2,
    icon: 'WarningFilled'
  },
  INFO: {
    text: '信息',
    type: 'info',
    color: '#409EFF',
    bgColor: 'rgba(64, 158, 255, 0.1)',
    priority: 1,
    icon: 'InfoFilled'
  }
}

/**
 * 告警类型配置
 */
export const ALERT_TYPE_CONFIG: Record<AlertType, {
  text: string
  category: '账号' | '性能' | '系统' | '业务'
  description: string
  suggestedActions: string[]
}> = {
  ACCOUNT_OFFLINE: {
    text: '账号离线',
    category: '账号',
    description: '企微账号意外离线',
    suggestedActions: ['检查网络连接', '重新登录账号', '检查账号状态']
  },
  HEARTBEAT_TIMEOUT: {
    text: '心跳超时',
    category: '账号',
    description: '账号心跳检测超时',
    suggestedActions: ['检查网络连接', '重启账号服务', '检查服务器状态']
  },
  CONNECTION_ERROR: {
    text: '连接错误',
    category: '系统',
    description: '网络连接出现错误',
    suggestedActions: ['检查网络配置', '重启网络服务', '联系网络管理员']
  },
  API_CALL_FAILED: {
    text: 'API调用失败',
    category: '系统',
    description: 'API接口调用失败',
    suggestedActions: ['检查API服务状态', '查看错误日志', '重试API调用']
  },
  STATUS_MISMATCH: {
    text: '状态不匹配',
    category: '账号',
    description: '账号状态与预期不符',
    suggestedActions: ['检查账号状态', '同步状态信息', '手动修正状态']
  },
  LOGIN_FAILED: {
    text: '登录失败',
    category: '账号',
    description: '账号登录失败',
    suggestedActions: ['检查登录凭据', '重新扫码登录', '检查账号权限']
  },
  AUTO_RECOVER_FAILED: {
    text: '自动恢复失败',
    category: '系统',
    description: '自动恢复机制执行失败',
    suggestedActions: ['手动干预恢复', '检查恢复策略', '升级恢复流程']
  },
  RETRY_LIMIT_REACHED: {
    text: '重试次数超限',
    category: '系统',
    description: '操作重试次数达到上限',
    suggestedActions: ['重置重试计数', '检查失败原因', '手动执行操作']
  },
  QUOTA_EXCEEDED: {
    text: '配额超限',
    category: '业务',
    description: '租户资源配额超出限制',
    suggestedActions: ['增加配额限制', '清理无用资源', '升级服务套餐']
  },
  RESPONSE_TIME_HIGH: {
    text: '响应时间过高',
    category: '性能',
    description: 'API响应时间超出阈值',
    suggestedActions: ['优化API性能', '增加服务器资源', '检查数据库性能']
  },
  MESSAGE_SEND_FAILED: {
    text: '消息发送失败',
    category: '业务',
    description: '消息发送操作失败',
    suggestedActions: ['重试发送消息', '检查消息格式', '检查接收方状态']
  },
  SYSTEM_RESOURCE_LOW: {
    text: '系统资源不足',
    category: '系统',
    description: '系统资源使用率过高',
    suggestedActions: ['释放系统资源', '扩容服务器', '优化资源使用']
  },
  NETWORK_ERROR: {
    text: '网络错误',
    category: '系统',
    description: '网络通信出现错误',
    suggestedActions: ['检查网络连接', '重启网络服务', '检查防火墙设置']
  },
  CALLBACK_ERROR: {
    text: '回调错误',
    category: '系统',
    description: '回调接口执行失败',
    suggestedActions: ['检查回调配置', '验证回调URL', '检查回调逻辑']
  },
  DATABASE_ERROR: {
    text: '数据库错误',
    category: '系统',
    description: '数据库操作失败',
    suggestedActions: ['检查数据库连接', '优化SQL查询', '重启数据库服务']
  },
  CACHE_ERROR: {
    text: '缓存错误',
    category: '系统',
    description: '缓存操作失败',
    suggestedActions: ['清理缓存数据', '重启缓存服务', '检查缓存配置']
  },
  QUEUE_BACKLOG: {
    text: '队列积压',
    category: '性能',
    description: '消息队列出现积压',
    suggestedActions: ['增加消费者数量', '优化处理逻辑', '清理过期消息']
  }
}

/**
 * 告警状态配置
 */
export const ALERT_STATUS_CONFIG: Record<AlertStatus, {
  text: string
  type: 'success' | 'warning' | 'danger' | 'info'
  color: string
  description: string
}> = {
  ACTIVE: {
    text: '活跃',
    type: 'danger',
    color: '#F56C6C',
    description: '告警正在发生，需要处理'
  },
  ACKNOWLEDGED: {
    text: '已确认',
    type: 'warning',
    color: '#E6A23C',
    description: '告警已被确认，正在处理中'
  },
  RESOLVED: {
    text: '已解决',
    type: 'success',
    color: '#67C23A',
    description: '告警已被解决'
  },
  SUPPRESSED: {
    text: '已抑制',
    type: 'info',
    color: '#909399',
    description: '告警被临时抑制，暂不通知'
  },
  EXPIRED: {
    text: '已过期',
    type: 'info',
    color: '#909399',
    description: '告警已自动过期'
  }
}

/**
 * 租户状态配置
 */
export const TENANT_STATUS_CONFIG: Record<TenantStatus, {
  text: string
  type: 'success' | 'warning' | 'danger' | 'info'
  color: string
  description: string
}> = {
  ACTIVE: {
    text: '正常',
    type: 'success',
    color: '#67C23A',
    description: '租户状态正常，服务可用'
  },
  INACTIVE: {
    text: '未激活',
    type: 'info',
    color: '#909399',
    description: '租户尚未激活，服务不可用'
  },
  SUSPENDED: {
    text: '已暂停',
    type: 'warning',
    color: '#E6A23C',
    description: '租户服务已暂停，请联系管理员'
  },
  EXPIRED: {
    text: '已过期',
    type: 'danger',
    color: '#F56C6C',
    description: '租户服务已过期，请续费'
  }
}

/**
 * 租户类型配置
 */
export const TENANT_TYPE_CONFIG: Record<TenantType, {
  text: string
  type: 'success' | 'warning' | 'danger' | 'info'
  color: string
  description: string
  features: string[]
  limits: {
    maxAccounts: number
    maxDailyMessages: number
    maxApiCalls: number
    maxStorageGB: number
  }
}> = {
  TRIAL: {
    text: '试用版',
    type: 'info',
    color: '#909399',
    description: '免费试用版本，功能有限',
    features: ['基础监控', '5个账号', '1000条消息/天'],
    limits: {
      maxAccounts: 5,
      maxDailyMessages: 1000,
      maxApiCalls: 10000,
      maxStorageGB: 1
    }
  },
  STANDARD: {
    text: '标准版',
    type: 'info',
    color: '#409EFF',
    description: '标准版本，适合中小企业',
    features: ['完整监控', '50个账号', '10000条消息/天', '告警通知'],
    limits: {
      maxAccounts: 50,
      maxDailyMessages: 10000,
      maxApiCalls: 100000,
      maxStorageGB: 10
    }
  },
  PREMIUM: {
    text: '高级版',
    type: 'warning',
    color: '#E6A23C',
    description: '高级版本，适合大型企业',
    features: ['高级监控', '200个账号', '50000条消息/天', '自动运维', '优先支持'],
    limits: {
      maxAccounts: 200,
      maxDailyMessages: 50000,
      maxApiCalls: 500000,
      maxStorageGB: 50
    }
  },
  ENTERPRISE: {
    text: '企业版',
    type: 'success',
    color: '#67C23A',
    description: '企业定制版本，无限制',
    features: ['企业级监控', '无限账号', '无限消息', '定制功能', '专属支持'],
    limits: {
      maxAccounts: -1, // -1 表示无限制
      maxDailyMessages: -1,
      maxApiCalls: -1,
      maxStorageGB: -1
    }
  }
}

/**
 * 健康分数等级配置
 */
export const HEALTH_SCORE_LEVELS = [
  { min: 90, max: 100, level: 'excellent', text: '优秀', color: '#67C23A' },
  { min: 80, max: 89, level: 'good', text: '良好', color: '#409EFF' },
  { min: 60, max: 79, level: 'fair', text: '一般', color: '#E6A23C' },
  { min: 0, max: 59, level: 'poor', text: '较差', color: '#F56C6C' }
]

/**
 * 监控刷新间隔选项
 */
export const REFRESH_INTERVAL_OPTIONS = [
  { value: 5000, label: '5秒', shortLabel: '5s' },
  { value: 10000, label: '10秒', shortLabel: '10s' },
  { value: 30000, label: '30秒', shortLabel: '30s' },
  { value: 60000, label: '1分钟', shortLabel: '1m' },
  { value: 300000, label: '5分钟', shortLabel: '5m' },
  { value: 600000, label: '10分钟', shortLabel: '10m' }
]

/**
 * 分页大小选项
 */
export const PAGE_SIZE_OPTIONS = [10, 20, 50, 100, 200]

/**
 * 默认分页配置
 */
export const DEFAULT_PAGINATION = {
  currentPage: 1,
  pageSize: 20,
  total: 0
}

/**
 * 图表颜色配置
 */
export const CHART_COLORS = {
  primary: ['#409EFF', '#66B1FF', '#8CC5FF', '#B3D8FF'],
  success: ['#67C23A', '#85CE61', '#A4DA89', '#C2E7B0'],
  warning: ['#E6A23C', '#EEBE77', '#F3D19E', '#F7E6C4'],
  danger: ['#F56C6C', '#F78989', '#F9A7A7', '#FBC4C4'],
  info: ['#909399', '#A6A9AD', '#B9BCC0', '#CDCFD4'],
  gradient: [
    'rgba(64, 158, 255, 0.8)',
    'rgba(103, 194, 58, 0.8)',
    'rgba(230, 162, 60, 0.8)',
    'rgba(245, 108, 108, 0.8)',
    'rgba(144, 147, 153, 0.8)'
  ]
}

/**
 * 数据导出格式选项
 */
export const EXPORT_FORMAT_OPTIONS = [
  { value: 'EXCEL', label: 'Excel文件', ext: '.xlsx' },
  { value: 'CSV', label: 'CSV文件', ext: '.csv' },
  { value: 'JSON', label: 'JSON文件', ext: '.json' }
]

/**
 * 时间范围快捷选项
 */
export const TIME_RANGE_OPTIONS = [
  { label: '最近1小时', value: '1h', hours: 1 },
  { label: '最近6小时', value: '6h', hours: 6 },
  { label: '最近24小时', value: '24h', hours: 24 },
  { label: '最近3天', value: '3d', hours: 72 },
  { label: '最近7天', value: '7d', hours: 168 },
  { label: '最近30天', value: '30d', hours: 720 }
]

/**
 * 批量操作选项
 */
export const BATCH_OPERATIONS = {
  accounts: [
    { key: 'start', label: '批量启动', icon: 'VideoPlay', type: 'success' },
    { key: 'stop', label: '批量停止', icon: 'VideoPause', type: 'warning' },
    { key: 'restart', label: '批量重启', icon: 'Refresh', type: 'primary' },
    { key: 'delete', label: '批量删除', icon: 'Delete', type: 'danger' }
  ],
  alerts: [
    { key: 'acknowledge', label: '批量确认', icon: 'Check', type: 'warning' },
    { key: 'resolve', label: '批量解决', icon: 'CircleCheck', type: 'success' },
    { key: 'suppress', label: '批量抑制', icon: 'Mute', type: 'info' }
  ]
}