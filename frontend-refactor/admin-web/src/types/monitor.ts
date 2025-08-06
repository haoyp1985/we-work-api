/**
 * 监控相关类型定义
 * WeWork Management Platform - Frontend
 */

import type { BaseEntity, PageQuery } from "./index";

// ===== 系统监控基础类型 =====

/**
 * 服务健康状态
 */
export type HealthStatus = "UP" | "DOWN" | "UNKNOWN";

/**
 * 告警级别
 */
export type AlertSeverity = "CRITICAL" | "WARNING" | "INFO";

/**
 * 告警状态
 */
export type AlertStatus = "ACTIVE" | "ACKNOWLEDGED" | "RESOLVED" | "SUPPRESSED";

/**
 * 监控指标类型
 */
export type MetricType = "COUNTER" | "GAUGE" | "HISTOGRAM" | "SUMMARY";

// ===== 系统指标 =====

/**
 * 系统指标
 */
export interface SystemMetrics {
  cpu: CpuMetrics;
  memory: MemoryMetrics;
  disk: DiskMetrics;
  network: NetworkMetrics;
  timestamp: number;
}

/**
 * CPU指标
 */
export interface CpuMetrics {
  usage: number; // 使用率 (0-100)
  cores: number; // CPU核心数
  loadAverage?: {
    oneMinute: number;
    fiveMinutes: number;
    fifteenMinutes: number;
  };
}

/**
 * 内存指标
 */
export interface MemoryMetrics {
  usage: number; // 使用率 (0-100)
  total: number; // 总内存 (MB)
  used: number; // 已用内存 (MB)
  available: number; // 可用内存 (MB)
  buffers?: number; // 缓冲区 (MB)
  cached?: number; // 缓存 (MB)
}

/**
 * 磁盘指标
 */
export interface DiskMetrics {
  usage: number; // 使用率 (0-100)
  total: number; // 总空间 (GB)
  used: number; // 已用空间 (GB)
  available: number; // 可用空间 (GB)
  iops?: {
    read: number;
    write: number;
  };
}

/**
 * 网络指标
 */
export interface NetworkMetrics {
  inbound: number; // 入站流量 (MB/s)
  outbound: number; // 出站流量 (MB/s)
  connections?: number;
  packets?: {
    inbound: number;
    outbound: number;
    dropped: number;
    errors: number;
  };
}

// ===== 服务健康检查 =====

/**
 * 服务健康状态
 */
export interface ServiceHealth {
  serviceName: string;
  serviceType: string;
  status: HealthStatus;
  uptime: number;
  version?: string;
  endpoints: EndpointHealth[];
  dependencies: DependencyHealth[];
  lastCheckAt: string;
  details?: Record<string, any>;
}

/**
 * 端点健康状态
 */
export interface EndpointHealth {
  name: string;
  url: string;
  status: HealthStatus;
  responseTime: number;
  httpStatus?: number;
  lastCheckAt: string;
  errorMessage?: string;
}

/**
 * 依赖健康状态
 */
export interface DependencyHealth {
  name: string;
  type: "DATABASE" | "CACHE" | "MESSAGE_QUEUE" | "EXTERNAL_API" | "FILE_SYSTEM";
  status: HealthStatus;
  responseTime: number;
  lastCheckAt: string;
  errorMessage?: string;
  details?: Record<string, any>;
}

// ===== 告警管理 =====

/**
 * 告警规则
 */
export interface AlertRule extends BaseEntity {
  ruleName: string;
  ruleCode: string;
  description?: string;
  enabled: boolean;
  severity: AlertSeverity;
  conditions: AlertCondition[];
  actions: AlertAction[];
  cooldown: number; // 冷却时间 (秒)
  repeatInterval: number; // 重复间隔 (秒)
  tags?: string[];
  schedule?: AlertSchedule;
}

/**
 * 告警条件
 */
export interface AlertCondition {
  metric: string;
  operator: "GT" | "GTE" | "LT" | "LTE" | "EQ" | "NEQ";
  threshold: number;
  duration: number; // 持续时间 (秒)
  aggregation?: "AVG" | "MAX" | "MIN" | "SUM" | "COUNT";
}

/**
 * 告警动作
 */
export interface AlertAction {
  type: "EMAIL" | "SMS" | "WEBHOOK" | "DINGTALK" | "WECHAT";
  config: Record<string, any>;
  enabled: boolean;
}

/**
 * 告警调度
 */
export interface AlertSchedule {
  enabled: boolean;
  timezone: string;
  timeRanges: Array<{
    dayOfWeek: number[]; // 0-6 (周日-周六)
    startTime: string; // HH:mm
    endTime: string; // HH:mm
  }>;
}

/**
 * 告警记录
 */
export interface AlertRecord extends BaseEntity {
  alertId: string;
  ruleId: string;
  ruleName: string;
  severity: AlertSeverity;
  status: AlertStatus;
  message: string;
  details?: Record<string, any>;
  triggeredAt: string;
  acknowledgedAt?: string;
  acknowledgedBy?: string;
  resolvedAt?: string;
  resolvedBy?: string;
  resolution?: string;
  notificationsSent: number;
  tags?: string[];
}

// ===== 性能数据 =====

/**
 * 性能数据
 */
export interface PerformanceData {
  timestamp: string;
  serviceName: string;
  metrics: PerformanceMetrics;
}

/**
 * 性能指标
 */
export interface PerformanceMetrics {
  // 响应时间指标
  responseTime: {
    avg: number;
    min: number;
    max: number;
    p50: number;
    p95: number;
    p99: number;
  };

  // 吞吐量指标
  throughput: {
    requestsPerSecond: number;
    errorsPerSecond: number;
    successRate: number;
  };

  // 并发指标
  concurrency: {
    activeConnections: number;
    activeThreads: number;
    queueSize: number;
  };

  // 资源使用指标
  resources: {
    cpuUsage: number;
    memoryUsage: number;
    networkUsage: number;
    diskUsage: number;
  };

  // 业务指标
  business?: {
    accountsOnline: number;
    messagesSent: number;
    apiCalls: number;
    [key: string]: number;
  };
}

// ===== 日志管理 =====

/**
 * 日志级别
 */
export type LogLevel = "TRACE" | "DEBUG" | "INFO" | "WARN" | "ERROR" | "FATAL";

/**
 * 日志条目
 */
export interface LogEntry {
  id: string;
  timestamp: string;
  level: LogLevel;
  logger: string;
  message: string;
  serviceName: string;
  traceId?: string;
  spanId?: string;
  userId?: string;
  accountId?: string;
  exception?: LogException;
  context?: Record<string, any>;
  tags?: string[];
}

/**
 * 日志异常
 */
export interface LogException {
  className: string;
  message: string;
  stackTrace: string[];
  cause?: LogException;
}

/**
 * 日志查询表单
 */
export interface LogSearchForm extends PageQuery {
  keyword?: string;
  level?: LogLevel;
  logger?: string;
  serviceName?: string;
  startTime?: string;
  endTime?: string;
  traceId?: string;
  userId?: string;
  accountId?: string;
  tags?: string[];
}

// ===== 链路追踪 =====

/**
 * 链路追踪
 */
export interface TraceData {
  traceId: string;
  spans: SpanData[];
  duration: number;
  startTime: string;
  endTime: string;
  services: string[];
  status: "SUCCESS" | "ERROR";
  errorCount: number;
}

/**
 * Span数据
 */
export interface SpanData {
  spanId: string;
  parentSpanId?: string;
  traceId: string;
  operationName: string;
  serviceName: string;
  startTime: string;
  endTime: string;
  duration: number;
  status: "SUCCESS" | "ERROR";
  tags: Record<string, any>;
  logs: SpanLog[];
}

/**
 * Span日志
 */
export interface SpanLog {
  timestamp: string;
  fields: Record<string, any>;
}

// ===== 监控统计 =====

/**
 * 监控统计
 */
export interface MonitorStatistics {
  totalServices: number;
  healthyServices: number;
  unhealthyServices: number;
  totalAlerts: number;
  activeAlerts: number;
  resolvedAlerts: number;
  avgResponseTime: number;
  systemUptime: number;
  errorRate: number;
  throughput: number;
  topErrors: Array<{
    error: string;
    count: number;
    percentage: number;
  }>;
  serviceDistribution: Array<{
    serviceName: string;
    status: HealthStatus;
    count: number;
  }>;
  alertTrends: Array<{
    date: string;
    active: number;
    resolved: number;
  }>;
}

// ===== 监控配置 =====

/**
 * 监控配置
 */
export interface MonitorConfig {
  // 数据收集配置
  collection: {
    enabled: boolean;
    interval: number; // 收集间隔 (秒)
    retention: number; // 数据保留天数
    batchSize: number; // 批处理大小
  };

  // 告警配置
  alerting: {
    enabled: boolean;
    globalCooldown: number; // 全局冷却时间
    maxAlertsPerHour: number; // 每小时最大告警数
    escalationEnabled: boolean;
  };

  // 性能配置
  performance: {
    enableAPM: boolean; // 应用性能监控
    enableTracing: boolean; // 链路追踪
    samplingRate: number; // 采样率 (0-1)
    slowThreshold: number; // 慢请求阈值 (ms)
  };

  // 存储配置
  storage: {
    metricsStorage: "MEMORY" | "DISK" | "DATABASE";
    logsStorage: "FILE" | "DATABASE" | "ELASTICSEARCH";
    tracesStorage: "MEMORY" | "DATABASE" | "JAEGER";
    compressionEnabled: boolean;
  };

  // 通知配置
  notification: {
    defaultChannels: string[];
    escalationChannels: string[];
    quietHours: {
      enabled: boolean;
      startTime: string;
      endTime: string;
      timezone: string;
    };
  };
}

// ===== 仪表板 =====

/**
 * 监控仪表板
 */
export interface MonitorDashboard {
  id: string;
  name: string;
  description?: string;
  layout: DashboardLayout;
  widgets: DashboardWidget[];
  refreshInterval: number;
  autoRefresh: boolean;
  isPublic: boolean;
  tags?: string[];
  createdBy: string;
  createdAt: string;
  updatedAt: string;
}

/**
 * 仪表板布局
 */
export interface DashboardLayout {
  columns: number;
  rows: number;
  gap: number;
}

/**
 * 仪表板组件
 */
export interface DashboardWidget {
  id: string;
  type: "CHART" | "TABLE" | "METRIC" | "STATUS" | "LOG" | "ALERT";
  title: string;
  position: {
    x: number;
    y: number;
    width: number;
    height: number;
  };
  config: WidgetConfig;
  dataSource: DataSourceConfig;
}

/**
 * 组件配置
 */
export interface WidgetConfig {
  chartType?: "line" | "bar" | "pie" | "gauge" | "heatmap";
  timeRange?: string;
  refreshInterval?: number;
  thresholds?: Array<{
    value: number;
    color: string;
    label: string;
  }>;
  displayOptions?: Record<string, any>;
}

/**
 * 数据源配置
 */
export interface DataSourceConfig {
  type: "METRICS" | "LOGS" | "TRACES" | "ALERTS";
  query: string;
  filters?: Record<string, any>;
  aggregation?: string;
  groupBy?: string[];
}

// ===== 监控事件 =====

/**
 * 监控事件类型
 */
export type MonitorEventType =
  | "SERVICE_UP"
  | "SERVICE_DOWN"
  | "ALERT_TRIGGERED"
  | "ALERT_RESOLVED"
  | "THRESHOLD_EXCEEDED"
  | "PERFORMANCE_DEGRADED"
  | "ERROR_SPIKE";

/**
 * 监控事件
 */
export interface MonitorEvent {
  id: string;
  type: MonitorEventType;
  severity: AlertSeverity;
  title: string;
  description: string;
  source: string;
  tags?: string[];
  metadata?: Record<string, any>;
  timestamp: string;
  resolved?: boolean;
  resolvedAt?: string;
}

// ===== 外部集成 =====

/**
 * 外部监控集成
 */
export interface ExternalMonitorIntegration {
  id: string;
  name: string;
  type: "PROMETHEUS" | "GRAFANA" | "ELASTICSEARCH" | "JAEGER" | "ZIPKIN";
  config: {
    endpoint: string;
    authentication?: {
      type: "BASIC" | "TOKEN" | "OAUTH";
      credentials: Record<string, string>;
    };
    syncEnabled: boolean;
    syncInterval: number;
  };
  status: "CONNECTED" | "DISCONNECTED" | "ERROR";
  lastSyncAt?: string;
  errorMessage?: string;
}
