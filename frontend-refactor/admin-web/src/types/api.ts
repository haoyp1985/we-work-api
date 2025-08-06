/**
 * API 类型定义
 * 定义所有业务实体的 TypeScript 类型接口
 */

// ==================== 基础类型 ====================

// 分页查询参数
export interface PageQuery {
  current: number
  size: number
  keyword?: string
  sortField?: string
  sortOrder?: 'ascend' | 'descend'
}

// 分页响应结果
export interface PageResult<T = any> {
  current: number
  size: number
  total: number
  pages: number
  records: T[]
}

// API 统一响应格式
export interface ApiResult<T = any> {
  code: number
  message: string
  data: T
  success: boolean
  timestamp: number
}

// ==================== 用户相关 ====================

// 用户信息
export interface UserInfo {
  id: string
  username: string
  realName: string
  email: string
  phone?: string
  avatar?: string
  status: UserStatus
  roles: Role[]
  permissions: string[]
  tenantId: string
  organizationId?: string
  createdAt: string
  updatedAt: string
  lastLoginAt?: string
}

// 用户状态
export enum UserStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  LOCKED = 'LOCKED',
  EXPIRED = 'EXPIRED'
}

// 角色信息
export interface Role {
  id: string
  name: string
  code: string
  description?: string
  permissions: Permission[]
  status: RoleStatus
  createdAt: string
  updatedAt: string
}

export enum RoleStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE'
}

// 权限信息
export interface Permission {
  id: string
  name: string
  code: string
  type: PermissionType
  parentId?: string
  path?: string
  component?: string
  icon?: string
  sort: number
  status: PermissionStatus
  children?: Permission[]
}

export enum PermissionType {
  MENU = 'MENU',
  BUTTON = 'BUTTON',
  API = 'API'
}

export enum PermissionStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE'
}

// 登录请求
export interface LoginRequest {
  username: string
  password: string
  captcha?: string
  captchaId?: string
  rememberMe?: boolean
}

// 登录响应
export interface LoginResponse {
  token: string
  refreshToken: string
  expiresIn: number
  userInfo: UserInfo
}

// ==================== AI智能体相关 ====================

// 智能体信息
export interface Agent {
  id: string
  name: string
  description: string
  type: AgentType
  status: AgentStatus
  avatar?: string
  tags: string[]
  platformType: PlatformType
  modelName: string
  systemPrompt: string
  
  // 模型参数
  temperature: number
  maxTokens: number
  topP: number
  frequencyPenalty: number
  presencePenalty: number
  
  // 功能配置
  features: AgentFeatures
  
  // 安全配置
  security: AgentSecurity
  
  // 统计信息
  conversationCount?: number
  messageCount?: number
  rating?: number
  
  // 基础信息
  tenantId: string
  createdBy: string
  createdAt: string
  updatedAt: string
  lastActiveAt?: string
}

// 智能体类型
export enum AgentType {
  CHAT = 'CHAT',           // 聊天助手
  TASK = 'TASK',           // 任务处理
  ANALYSIS = 'ANALYSIS'    // 数据分析
}

// 智能体状态
export enum AgentStatus {
  DRAFT = 'DRAFT',         // 草稿
  PUBLISHED = 'PUBLISHED', // 已发布
  DISABLED = 'DISABLED'    // 已禁用
}

// 平台类型
export enum PlatformType {
  OPENAI = 'OPENAI',
  ANTHROPIC_CLAUDE = 'ANTHROPIC_CLAUDE',
  BAIDU_WENXIN = 'BAIDU_WENXIN',
  COZE = 'COZE',
  DIFY = 'DIFY'
}

// 智能体功能配置
export interface AgentFeatures {
  memoryEnabled: boolean
  contextWindow: number
  streamResponse: boolean
  webSearch: boolean
  codeExecution: boolean
  imageAnalysis: boolean
}

// 智能体安全配置
export interface AgentSecurity {
  contentFilter: boolean
  rateLimitEnabled: boolean
  maxRequestsPerMinute: number
  allowedDomains: string[]
  blockedKeywords: string[]
}

// 创建/更新智能体请求
export interface CreateAgentRequest {
  name: string
  description: string
  type: AgentType
  avatar?: string
  tags: string[]
  platformType: PlatformType
  modelName: string
  systemPrompt: string
  temperature: number
  maxTokens: number
  topP: number
  frequencyPenalty: number
  presencePenalty: number
  features: AgentFeatures
  security: AgentSecurity
}

export interface UpdateAgentRequest extends Partial<CreateAgentRequest> {
  id: string
  status?: AgentStatus
}

// 智能体查询参数
export interface AgentQuery extends PageQuery {
  type?: AgentType
  status?: AgentStatus
  platformType?: PlatformType
  tags?: string[]
  createdBy?: string
  dateRange?: [string, string]
}

// ==================== 对话相关 ====================

// 对话信息
export interface Conversation {
  id: string
  title: string
  agentId: string
  agentName: string
  userId: string
  userName: string
  status: ConversationStatus
  messageCount: number
  lastMessage?: string
  lastMessageAt?: string
  isStarred: boolean
  isPinned: boolean
  tags: string[]
  context: Record<string, any>
  tenantId: string
  createdAt: string
  updatedAt: string
}

// 对话状态
export enum ConversationStatus {
  ACTIVE = 'ACTIVE',
  ARCHIVED = 'ARCHIVED',
  DELETED = 'DELETED'
}

// 消息信息
export interface Message {
  id: string
  conversationId: string
  type: MessageType
  role: MessageRole
  content: string
  metadata?: MessageMetadata
  parentId?: string
  children: Message[]
  tokens?: number
  cost?: number
  duration?: number
  status: MessageStatus
  error?: string
  isRead: boolean
  reactions: MessageReaction[]
  createdAt: string
  updatedAt: string
}

// 消息类型
export enum MessageType {
  TEXT = 'TEXT',
  IMAGE = 'IMAGE',
  FILE = 'FILE',
  AUDIO = 'AUDIO',
  SYSTEM = 'SYSTEM'
}

// 消息角色
export enum MessageRole {
  USER = 'USER',
  ASSISTANT = 'ASSISTANT',
  SYSTEM = 'SYSTEM'
}

// 消息状态
export enum MessageStatus {
  SENDING = 'SENDING',
  SENT = 'SENT',
  DELIVERED = 'DELIVERED',
  FAILED = 'FAILED',
  DELETED = 'DELETED'
}

// 消息元数据
export interface MessageMetadata {
  model?: string
  temperature?: number
  maxTokens?: number
  finishReason?: string
  promptTokens?: number
  completionTokens?: number
  totalTokens?: number
  reasoning?: string[]
  tools?: any[]
  citations?: Citation[]
}

// 引用信息
export interface Citation {
  id: string
  title: string
  url: string
  snippet: string
}

// 消息反应
export interface MessageReaction {
  id: string
  messageId: string
  userId: string
  type: ReactionType
  createdAt: string
}

export enum ReactionType {
  LIKE = 'LIKE',
  DISLIKE = 'DISLIKE',
  LOVE = 'LOVE',
  LAUGH = 'LAUGH',
  SURPRISED = 'SURPRISED',
  ANGRY = 'ANGRY'
}

// 发送消息请求
export interface SendMessageRequest {
  conversationId?: string
  agentId: string
  content: string
  type?: MessageType
  parentId?: string
  context?: Record<string, any>
  attachments?: MessageAttachment[]
}

// 消息附件
export interface MessageAttachment {
  id: string
  name: string
  type: string
  size: number
  url: string
}

// ==================== 平台集成相关 ====================

// 平台配置
export interface PlatformConfig {
  id: string
  name: string
  platformType: PlatformType
  description?: string
  config: PlatformConfigData
  status: PlatformConfigStatus
  isDefault: boolean
  tenantId: string
  createdBy: string
  createdAt: string
  updatedAt: string
  lastTestedAt?: string
  testStatus?: TestStatus
}

// 平台配置状态
export enum PlatformConfigStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  ERROR = 'ERROR'
}

// 测试状态
export enum TestStatus {
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
  TESTING = 'TESTING'
}

// 平台配置数据
export interface PlatformConfigData {
  apiKey: string
  apiUrl?: string
  organizationId?: string
  region?: string
  model?: string
  maxRetries?: number
  timeout?: number
  rateLimit?: RateLimit
  customHeaders?: Record<string, string>
  webhook?: WebhookConfig
}

// 速率限制
export interface RateLimit {
  requests: number
  period: number // 秒
  burst?: number
}

// Webhook配置
export interface WebhookConfig {
  url: string
  secret?: string
  events: string[]
}

// 模型配置
export interface ModelConfig {
  id: string
  name: string
  platformConfigId: string
  platformType: PlatformType
  modelName: string
  displayName: string
  description?: string
  parameters: ModelParameters
  pricing: ModelPricing
  capabilities: ModelCapabilities
  status: ModelConfigStatus
  isDefault: boolean
  tenantId: string
  createdAt: string
  updatedAt: string
}

// 模型配置状态
export enum ModelConfigStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  DEPRECATED = 'DEPRECATED'
}

// 模型参数
export interface ModelParameters {
  maxTokens: number
  temperature: number
  topP: number
  topK?: number
  frequencyPenalty: number
  presencePenalty: number
  stopSequences?: string[]
  streamMode: boolean
}

// 模型定价
export interface ModelPricing {
  inputTokenPrice: number   // 每1K token价格
  outputTokenPrice: number  // 每1K token价格
  currency: string          // 币种
  billingUnit: string       // 计费单位
}

// 模型能力
export interface ModelCapabilities {
  maxContextLength: number
  supportsFunctionCalling: boolean
  supportsImageInput: boolean
  supportsAudioInput: boolean
  supportsVideoInput: boolean
  supportsFileUploads: boolean
  supportsWebSearch: boolean
  supportsCodeExecution: boolean
  languages: string[]
}

// ==================== 统计分析相关 ====================

// 使用统计
export interface UsageStats {
  period: StatsPeriod
  startDate: string
  endDate: string
  
  // 基础指标
  totalConversations: number
  totalMessages: number
  totalUsers: number
  totalTokens: number
  totalCost: number
  
  // 增长指标
  conversationGrowth: number
  messageGrowth: number
  userGrowth: number
  
  // 质量指标
  averageRating: number
  ratingCount: number
  responseTime: number
  successRate: number
  
  // 时间序列数据
  timeSeriesData: TimeSeriesData[]
  
  // 分类统计
  agentStats: AgentStats[]
  platformStats: PlatformStats[]
  userStats: UserStats[]
}

// 统计周期
export enum StatsPeriod {
  HOUR = 'HOUR',
  DAY = 'DAY',
  WEEK = 'WEEK',
  MONTH = 'MONTH',
  QUARTER = 'QUARTER',
  YEAR = 'YEAR'
}

// 时间序列数据
export interface TimeSeriesData {
  date: string
  conversations: number
  messages: number
  users: number
  tokens: number
  cost: number
  avgRating: number
  responseTime: number
}

// 智能体统计
export interface AgentStats {
  agentId: string
  agentName: string
  conversations: number
  messages: number
  tokens: number
  cost: number
  rating: number
  responseTime: number
}

// 平台统计
export interface PlatformStats {
  platformType: PlatformType
  conversations: number
  messages: number
  tokens: number
  cost: number
  responseTime: number
  errorRate: number
}

// 用户统计
export interface UserStats {
  userId: string
  userName: string
  conversations: number
  messages: number
  lastActiveAt: string
}

// ==================== 系统监控相关 ====================

// 系统状态
export interface SystemStatus {
  status: ServiceStatus
  version: string
  uptime: number
  timestamp: string
  
  // 服务状态
  services: ServiceStatusInfo[]
  
  // 资源使用情况
  resources: ResourceUsage
  
  // 性能指标
  performance: PerformanceMetrics
  
  // 错误统计
  errors: ErrorStats
}

// 服务状态
export enum ServiceStatus {
  HEALTHY = 'HEALTHY',
  DEGRADED = 'DEGRADED',
  UNHEALTHY = 'UNHEALTHY',
  UNKNOWN = 'UNKNOWN'
}

// 服务状态信息
export interface ServiceStatusInfo {
  name: string
  status: ServiceStatus
  version: string
  lastCheck: string
  responseTime?: number
  errorMessage?: string
  dependencies: ServiceDependency[]
}

// 服务依赖
export interface ServiceDependency {
  name: string
  status: ServiceStatus
  responseTime?: number
}

// 资源使用情况
export interface ResourceUsage {
  cpu: ResourceMetric
  memory: ResourceMetric
  disk: ResourceMetric
  network: NetworkMetric
}

// 资源指标
export interface ResourceMetric {
  used: number
  total: number
  percentage: number
  unit: string
}

// 网络指标
export interface NetworkMetric {
  bytesIn: number
  bytesOut: number
  packetsIn: number
  packetsOut: number
  errors: number
}

// 性能指标
export interface PerformanceMetrics {
  requestsPerSecond: number
  averageResponseTime: number
  p95ResponseTime: number
  p99ResponseTime: number
  errorRate: number
  throughput: number
}

// 错误统计
export interface ErrorStats {
  total: number
  byType: Record<string, number>
  byEndpoint: Record<string, number>
  recent: ErrorInfo[]
}

// 错误信息
export interface ErrorInfo {
  id: string
  type: string
  message: string
  endpoint: string
  userId?: string
  timestamp: string
  stack?: string
  context?: Record<string, any>
}

// ==================== 通用查询和过滤器 ====================

// 时间范围查询
export interface DateRangeQuery {
  startDate: string
  endDate: string
  timezone?: string
}

// 排序参数
export interface SortParams {
  field: string
  order: 'asc' | 'desc'
}

// 过滤器参数
export interface FilterParams {
  field: string
  operator: FilterOperator
  value: any
}

export enum FilterOperator {
  EQ = 'eq',           // 等于
  NE = 'ne',           // 不等于
  GT = 'gt',           // 大于
  GTE = 'gte',         // 大于等于
  LT = 'lt',           // 小于
  LTE = 'lte',         // 小于等于
  LIKE = 'like',       // 模糊匹配
  IN = 'in',           // 包含
  NOT_IN = 'not_in',   // 不包含
  IS_NULL = 'is_null', // 为空
  NOT_NULL = 'not_null' // 不为空
}

// 批量操作请求
export interface BatchRequest<T = any> {
  ids: string[]
  action: string
  data?: T
}

// 批量操作响应
export interface BatchResponse {
  total: number
  success: number
  failed: number
  errors: BatchError[]
}

// 批量操作错误
export interface BatchError {
  id: string
  error: string
  code?: string
}