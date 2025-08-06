/**
 * 消息相关类型定义
 * WeWork Management Platform - Frontend
 */

import type { BaseEntity, PageQuery } from "./index";

// ===== 消息基础类型 =====

/**
 * 消息状态
 */
export type MessageStatus =
  | "PENDING" // 待发送
  | "SENDING" // 发送中
  | "SENT" // 已发送
  | "DELIVERED" // 已送达
  | "READ" // 已读
  | "FAILED" // 发送失败
  | "CANCELLED"; // 已取消

/**
 * 消息类型
 */
export type MessageType =
  | "TEXT" // 文本消息
  | "IMAGE" // 图片消息
  | "FILE" // 文件消息
  | "VIDEO" // 视频消息
  | "AUDIO" // 音频消息
  | "LINK" // 链接消息
  | "CARD" // 卡片消息
  | "LOCATION" // 位置消息
  | "CONTACT"; // 联系人消息

/**
 * 接收者类型
 */
export type RecipientType = "USER" | "GROUP" | "DEPARTMENT" | "ALL";

/**
 * 消息实体
 */
export interface Message extends BaseEntity {
  messageId: string;
  accountId: string;
  accountName: string;
  messageType: MessageType;
  content: MessageContent;
  recipientType: RecipientType;
  recipients: MessageRecipient[];
  status: MessageStatus;
  scheduledAt?: string;
  sentAt?: string;
  deliveredAt?: string;
  readAt?: string;
  failedAt?: string;
  errorMessage?: string;
  retryCount: number;
  maxRetryCount: number;
  priority: number;
  batchId?: string;
  templateId?: string;
  tags?: string[];
  metadata?: Record<string, any>;
}

/**
 * 消息内容
 */
export interface MessageContent {
  text?: string;
  imageUrl?: string;
  fileUrl?: string;
  fileName?: string;
  fileSize?: number;
  videoUrl?: string;
  audioUrl?: string;
  duration?: number;
  linkUrl?: string;
  linkTitle?: string;
  linkDescription?: string;
  linkImage?: string;
  cardData?: CardData;
  location?: LocationData;
  contact?: ContactData;
}

/**
 * 卡片数据
 */
export interface CardData {
  title: string;
  description?: string;
  imageUrl?: string;
  linkUrl?: string;
  buttons?: Array<{
    text: string;
    action: string;
    url?: string;
  }>;
}

/**
 * 位置数据
 */
export interface LocationData {
  latitude: number;
  longitude: number;
  address?: string;
  name?: string;
}

/**
 * 联系人数据
 */
export interface ContactData {
  name: string;
  phone?: string;
  email?: string;
  avatar?: string;
  company?: string;
  title?: string;
}

/**
 * 消息接收者
 */
export interface MessageRecipient {
  id: string;
  type: RecipientType;
  recipientId: string;
  recipientName: string;
  status: MessageStatus;
  sentAt?: string;
  deliveredAt?: string;
  readAt?: string;
  errorMessage?: string;
  retryCount: number;
}

// ===== 消息模板 =====

/**
 * 消息模板
 */
export interface MessageTemplate extends BaseEntity {
  templateName: string;
  templateCode: string;
  messageType: MessageType;
  content: MessageContent;
  variables: TemplateVariable[];
  category?: string;
  description?: string;
  isSystem: boolean;
  status: "active" | "inactive";
  usageCount: number;
  tags?: string[];
}

/**
 * 模板变量
 */
export interface TemplateVariable {
  name: string;
  label: string;
  type: "TEXT" | "NUMBER" | "DATE" | "BOOLEAN" | "LIST" | "OBJECT";
  required: boolean;
  defaultValue?: any;
  placeholder?: string;
  description?: string;
  validation?: VariableValidation;
}

/**
 * 变量验证规则
 */
export interface VariableValidation {
  minLength?: number;
  maxLength?: number;
  pattern?: string;
  options?: Array<{
    label: string;
    value: any;
  }>;
}

// ===== 批量消息 =====

/**
 * 消息批次
 */
export interface MessageBatch extends BaseEntity {
  batchName: string;
  batchCode: string;
  messageType: MessageType;
  templateId?: string;
  totalCount: number;
  sentCount: number;
  deliveredCount: number;
  failedCount: number;
  status: "PENDING" | "RUNNING" | "COMPLETED" | "FAILED" | "CANCELLED";
  progress: number;
  scheduledAt?: string;
  startedAt?: string;
  completedAt?: string;
  failedAt?: string;
  errorMessage?: string;
  config: BatchConfig;
  statistics?: BatchStatistics;
}

/**
 * 批次配置
 */
export interface BatchConfig {
  // 发送配置
  sendRate: number; // 发送速率（条/秒）
  maxConcurrency: number; // 最大并发数
  retryCount: number; // 重试次数
  retryInterval: number; // 重试间隔（秒）

  // 调度配置
  scheduled: boolean; // 是否定时发送
  scheduledAt?: string; // 定时发送时间
  timezone?: string; // 时区

  // 过滤配置
  duplicateCheck: boolean; // 重复检查
  blacklistCheck: boolean; // 黑名单检查

  // 其他配置
  priority: number; // 优先级
  tags?: string[]; // 标签
}

/**
 * 批次统计
 */
export interface BatchStatistics {
  startTime: string;
  endTime?: string;
  duration?: number;
  avgSendTime: number;
  successRate: number;
  errorRate: number;
  throughput: number;
  statusDistribution: Record<MessageStatus, number>;
  errorDistribution: Record<string, number>;
  timelineData: Array<{
    timestamp: string;
    sent: number;
    failed: number;
    cumulative: number;
  }>;
}

// ===== 查询和表单 =====

/**
 * 消息查询表单
 */
export interface MessageSearchForm extends PageQuery {
  messageId?: string;
  accountId?: string;
  messageType?: MessageType;
  status?: MessageStatus;
  recipientType?: RecipientType;
  content?: string;
  startDate?: string;
  endDate?: string;
  batchId?: string;
  templateId?: string;
  tags?: string[];
}

/**
 * 消息发送表单
 */
export interface MessageSendForm {
  accountId: string;
  messageType: MessageType;
  content: MessageContent;
  recipients: Array<{
    type: RecipientType;
    id: string;
    name: string;
  }>;
  scheduledAt?: string;
  priority?: number;
  templateId?: string;
  templateVariables?: Record<string, any>;
  tags?: string[];
}

/**
 * 批量发送表单
 */
export interface BatchSendForm {
  batchName: string;
  accountId: string;
  messageType: MessageType;
  templateId: string;
  recipientFile?: File;
  recipients?: Array<{
    type: RecipientType;
    id: string;
    name: string;
    variables?: Record<string, any>;
  }>;
  config: BatchConfig;
  tags?: string[];
}

/**
 * 模板表单
 */
export interface TemplateForm {
  templateName: string;
  templateCode: string;
  messageType: MessageType;
  content: MessageContent;
  variables: TemplateVariable[];
  category?: string;
  description?: string;
  status: "active" | "inactive";
  tags?: string[];
}

// ===== 消息统计 =====

/**
 * 消息统计
 */
export interface MessageStatistics {
  totalCount: number;
  sentCount: number;
  deliveredCount: number;
  readCount: number;
  failedCount: number;
  pendingCount: number;
  todayCount: number;
  successRate: number;
  deliveryRate: number;
  readRate: number;
  dailyStats: Array<{
    date: string;
    total: number;
    sent: number;
    delivered: number;
    failed: number;
  }>;
  typeDistribution: Record<MessageType, number>;
  statusDistribution: Record<MessageStatus, number>;
  accountDistribution: Array<{
    accountId: string;
    accountName: string;
    count: number;
  }>;
  performanceMetrics: {
    avgSendTime: number;
    avgDeliveryTime: number;
    throughput: number;
    errorRate: number;
  };
}

/**
 * 账号消息统计
 */
export interface AccountMessageStatistics {
  accountId: string;
  accountName: string;
  totalSent: number;
  totalReceived: number;
  successRate: number;
  avgResponseTime: number;
  dailyStats: Array<{
    date: string;
    sent: number;
    received: number;
  }>;
  typeDistribution: Record<MessageType, number>;
  statusDistribution: Record<MessageStatus, number>;
}

// ===== 消息队列 =====

/**
 * 消息队列状态
 */
export interface MessageQueueStatus {
  queueName: string;
  size: number;
  processing: number;
  processed: number;
  failed: number;
  rate: number;
  avgProcessTime: number;
  lastProcessedAt?: string;
}

/**
 * 消息队列配置
 */
export interface MessageQueueConfig {
  maxSize: number;
  maxConcurrency: number;
  retryCount: number;
  retryDelay: number;
  deadLetterQueue: boolean;
  priorityEnabled: boolean;
  batchProcessing: boolean;
  batchSize: number;
}

// ===== 消息过滤 =====

/**
 * 消息过滤器
 */
export interface MessageFilter {
  id: string;
  name: string;
  type: "BLACKLIST" | "WHITELIST" | "CONTENT" | "FREQUENCY";
  rules: FilterRule[];
  enabled: boolean;
  action: "BLOCK" | "DELAY" | "MODIFY" | "LOG";
  priority: number;
  description?: string;
}

/**
 * 过滤规则
 */
export interface FilterRule {
  field: string;
  operator:
    | "EQUALS"
    | "CONTAINS"
    | "STARTS_WITH"
    | "ENDS_WITH"
    | "REGEX"
    | "GT"
    | "LT";
  value: any;
  caseSensitive?: boolean;
}

// ===== 消息审核 =====

/**
 * 消息审核
 */
export interface MessageAudit {
  id: string;
  messageId: string;
  auditType: "CONTENT" | "FREQUENCY" | "RECIPIENT" | "SECURITY";
  status: "PENDING" | "APPROVED" | "REJECTED" | "ESCALATED";
  result?: AuditResult;
  reviewer?: string;
  reviewedAt?: string;
  comments?: string;
}

/**
 * 审核结果
 */
export interface AuditResult {
  score: number;
  confidence: number;
  risks: Array<{
    type: string;
    level: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
    description: string;
  }>;
  suggestions?: string[];
}

// ===== 消息回调 =====

/**
 * 消息回调配置
 */
export interface MessageCallback {
  url: string;
  events: MessageCallbackEvent[];
  headers?: Record<string, string>;
  timeout: number;
  retryCount: number;
  retryInterval: number;
  secret?: string;
  enabled: boolean;
}

/**
 * 回调事件类型
 */
export type MessageCallbackEvent =
  | "MESSAGE_SENT"
  | "MESSAGE_DELIVERED"
  | "MESSAGE_READ"
  | "MESSAGE_FAILED"
  | "BATCH_STARTED"
  | "BATCH_COMPLETED"
  | "BATCH_FAILED";

/**
 * 回调数据
 */
export interface CallbackData {
  event: MessageCallbackEvent;
  messageId?: string;
  batchId?: string;
  timestamp: string;
  data: any;
}
