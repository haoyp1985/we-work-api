/**
 * AI智能体模块类型定义
 */

/**
 * 智能体类型枚举
 */
export enum AgentType {
  CHAT_ASSISTANT = 'CHAT_ASSISTANT',    // 聊天助手
  WORKFLOW = 'WORKFLOW',                // 工作流
  CODE_ASSISTANT = 'CODE_ASSISTANT',    // 代码助手
  KNOWLEDGE_QA = 'KNOWLEDGE_QA',        // 知识问答
  CUSTOM = 'CUSTOM'                     // 自定义
}

/**
 * 智能体状态枚举
 */
export enum AgentStatus {
  DRAFT = 'DRAFT',          // 草稿
  PUBLISHED = 'PUBLISHED',  // 已发布
  DELETED = 'DELETED'       // 已删除
}

/**
 * 外部平台类型枚举
 */
export enum PlatformType {
  COZE = 'COZE',                      // 字节跳动Coze
  DIFY = 'DIFY',                      // Dify开源平台
  ALIBABA_DASHSCOPE = 'ALIBABA_DASHSCOPE', // 阿里百炼
  OPENAI = 'OPENAI',                  // OpenAI
  CLAUDE = 'CLAUDE',                  // Claude
  WENXIN_YIYAN = 'WENXIN_YIYAN',     // 文心一言
  CUSTOM = 'CUSTOM'                   // 自定义平台
}

/**
 * 会话状态枚举
 */
export enum ConversationStatus {
  ACTIVE = 'ACTIVE',    // 活跃
  ENDED = 'ENDED',      // 已结束
  TIMEOUT = 'TIMEOUT'   // 超时
}

/**
 * 消息类型枚举
 */
export enum MessageType {
  TEXT = 'TEXT',              // 文本消息
  IMAGE = 'IMAGE',            // 图片消息
  FILE = 'FILE',              // 文件消息
  TOOL_CALL = 'TOOL_CALL',    // 工具调用
  TOOL_RESPONSE = 'TOOL_RESPONSE', // 工具响应
  SYSTEM = 'SYSTEM'           // 系统消息
}

/**
 * 消息状态枚举
 */
export enum MessageStatus {
  SENDING = 'SENDING',    // 发送中
  SENT = 'SENT',          // 已发送
  DELIVERED = 'DELIVERED', // 已送达
  FAILED = 'FAILED'       // 发送失败
}

/**
 * 调用状态枚举
 */
export enum CallStatus {
  SUCCESS = 'SUCCESS',    // 成功
  FAILED = 'FAILED',      // 失败
  TIMEOUT = 'TIMEOUT',    // 超时
  RETRYING = 'RETRYING'   // 重试中
}

/**
 * 智能体DTO
 */
export interface AgentDTO {
  id: string
  tenantId: string
  name: string
  description?: string
  avatar?: string
  type: AgentType
  status: AgentStatus
  platformType?: string
  platformConfigId?: string
  modelConfigId?: string
  systemPrompt?: string
  configJson?: string
  enabled: boolean
  sortOrder?: number
  createdAt: string
  updatedAt: string
  createdBy?: string
  updatedBy?: string
  version: number
  // 扩展信息
  platformConfigName?: string
  modelConfigName?: string
  activeConversations?: number
  totalMessages?: number
  lastUsedAt?: string
}

/**
 * 创建智能体请求
 */
export interface CreateAgentRequest {
  name: string
  description?: string
  avatar?: string
  type: AgentType
  externalPlatformType?: string
  externalAgentId?: string
  platformConfigId?: string
  modelConfigId?: string
  systemPrompt?: string
  welcomeMessage?: string
  configJson?: string
  enabled?: boolean
  isPublic?: boolean
  tags?: string[]
  capabilities?: string[]
  knowledgeBaseIds?: string[]
  toolIds?: string[]
  icon?: string
  color?: string
  sortWeight?: number
  remarks?: string
  temperature?: number
  enableLogging?: boolean
  priority?: number
  timeoutSeconds?: number
  maxTokens?: number
}

/**
 * 更新智能体请求
 */
export interface UpdateAgentRequest {
  name?: string
  description?: string
  avatar?: string
  type?: AgentType
  externalPlatformType?: string
  externalAgentId?: string
  platformConfigId?: string
  modelConfigId?: string
  systemPrompt?: string
  welcomeMessage?: string
  configJson?: string
  enabled?: boolean
  isPublic?: boolean
  tags?: string[]
  capabilities?: string[]
  knowledgeBaseIds?: string[]
  toolIds?: string[]
  icon?: string
  color?: string
  sortWeight?: number
  remarks?: string
}

/**
 * 智能体查询请求
 */
export interface AgentQueryRequest {
  name?: string
  type?: AgentType
  status?: AgentStatus
  pageNum?: number
  pageSize?: number
}

/**
 * 聊天请求
 */
export interface ChatRequest {
  agentId: string
  conversationId?: string
  message: string
  messageType?: MessageType
  context?: Record<string, any>
  stream?: boolean
}

/**
 * 聊天响应
 */
export interface ChatResponse {
  conversationId: string
  messageId: string
  response: string
  messageType: MessageType
  finished: boolean
  tokenUsage?: {
    promptTokens: number
    completionTokens: number
    totalTokens: number
  }
  metadata?: Record<string, any>
}

/**
 * 会话DTO
 */
export interface ConversationDTO {
  id: string
  tenantId: string
  agentId: string
  userId?: string
  title: string
  status: ConversationStatus
  messageCount: number
  lastMessageAt?: string
  metadata?: Record<string, any>
  createdAt: string
  updatedAt: string
  // 扩展信息
  agentName?: string
  userName?: string
  lastMessage?: string
}

/**
 * 消息DTO
 */
export interface MessageDTO {
  id: string
  conversationId: string
  role: 'user' | 'assistant' | 'system' | 'tool'
  content: string
  messageType: MessageType
  status: MessageStatus
  parentId?: string
  metadata?: Record<string, any>
  tokenCount?: number
  createdAt: string
  // 扩展信息
  isStreaming?: boolean
  error?: string
}

/**
 * 平台配置DTO
 */
export interface PlatformConfigDTO {
  id: string
  tenantId: string
  platformName: string
  platformType: PlatformType
  description?: string
  endpoint: string
  apiVersion?: string
  authType: string
  apiKey?: string
  apiKeyName?: string
  accessToken?: string
  clientId?: string
  clientSecret?: string
  authUrl?: string
  tokenUrl?: string
  scopes?: string
  customHeaders?: string
  configParams?: string
  timeoutSeconds: number
  retryCount: number
  priority: number
  enabled: boolean
  enableLogging: boolean
  lastTestTime?: string
  lastTestResult?: string
  lastTestError?: string
  remarks?: string
  createdAt: string
  updatedAt: string
  createdBy?: string
  updatedBy?: string
}

/**
 * 创建平台配置请求
 */
export interface CreatePlatformConfigRequest {
  platformName: string
  platformType: PlatformType
  description?: string
  endpoint: string
  apiVersion?: string
  authType: string
  apiKey?: string
  apiKeyName?: string
  accessToken?: string
  clientId?: string
  clientSecret?: string
  authUrl?: string
  tokenUrl?: string
  scopes?: string
  customHeaders?: string
  configParams?: string
  timeoutSeconds: number
  retryCount: number
  priority: number
  enabled: boolean
  enableLogging: boolean
  remarks?: string
}

/**
 * 平台配置查询请求
 */
export interface PlatformConfigQueryRequest {
  platformName?: string
  platformType?: string
  enabled?: boolean
  current: number
  size: number
}

/**
 * 模型配置DTO
 */
export interface ModelConfigDTO {
  id: string
  tenantId: string
  platformConfigId?: string
  configName: string
  platformType: PlatformType
  modelName: string
  modelVersion?: string
  description?: string
  maxTokens?: number
  temperature?: number
  topP?: number
  frequencyPenalty?: number
  presencePenalty?: number
  stopSequences?: string
  customParams?: string
  configJson?: string
  enabled: boolean
  enableLogging?: boolean
  remarks?: string
  createdAt: string
  updatedAt: string
}

/**
 * 创建模型配置请求
 */
export interface CreateModelConfigRequest {
  configName: string
  platformType: PlatformType
  modelName: string
  modelVersion?: string
  description?: string
  maxTokens?: number
  temperature?: number
  topP?: number
  frequencyPenalty?: number
  presencePenalty?: number
  configJson?: string
  enabled: boolean
  enableLogging?: boolean
  remarks?: string
}

/**
 * 更新模型配置请求
 */
export interface UpdateModelConfigRequest {
  configName?: string
  platformType?: PlatformType
  modelName?: string
  modelVersion?: string
  description?: string
  maxTokens?: number
  temperature?: number
  topP?: number
  frequencyPenalty?: number
  presencePenalty?: number
  configJson?: string
  enabled?: boolean
  enableLogging?: boolean
  remarks?: string
}

/**
 * 模型配置查询请求
 */
export interface ModelConfigQueryRequest {
  configName?: string
  platformType?: string
  modelName?: string
  enabled?: boolean
  current: number
  size: number
}

/**
 * 调用记录DTO
 */
export interface CallRecordDTO {
  id: string
  tenantId: string
  agentId: string
  agentName?: string
  userId?: string
  conversationId?: string
  messageId?: string
  platformType: PlatformType
  callType?: string
  modelName?: string
  
  // 请求信息
  method: string
  requestMethod?: string
  requestUrl: string
  apiEndpoint?: string
  requestHeaders?: Record<string, string>
  requestBody?: string
  requestParams?: any
  
  // 响应信息
  responseStatus: number
  responseHeaders?: Record<string, string>
  responseBody?: string
  responseData?: any
  
  // 状态和性能
  callStatus: CallStatus
  status?: string
  duration: number
  responseTime?: number
  
  // Token和成本
  tokenUsage?: {
    promptTokens: number
    completionTokens: number
    totalTokens: number
  }
  inputTokens?: number
  outputTokens?: number
  totalTokens?: number
  cost?: number
  
  // 错误信息
  errorMessage?: string
  errorDetails?: string
  
  // 配置信息
  modelConfig?: {
    modelName: string
    temperature?: number
    maxTokens?: number
    topP?: number
    topK?: number
    frequencyPenalty?: number
    presencePenalty?: number
  }
  
  // 调用链路信息
  traceInfo?: Array<{
    stage: string
    description: string
    timestamp: number
    duration?: number
  }>
  
  createdAt: string
  updatedAt?: string
}

/**
 * 智能体统计信息
 */
export interface AgentStatistics {
  DRAFT: number
  PUBLISHED: number
  DELETED: number
}

/**
 * 智能体类型选项
 */
export const AGENT_TYPE_OPTIONS = [
  { label: '聊天助手', value: AgentType.CHAT_ASSISTANT, icon: '💬' },
  { label: '工作流', value: AgentType.WORKFLOW, icon: '⚡' },
  { label: '代码助手', value: AgentType.CODE_ASSISTANT, icon: '💻' },
  { label: '知识问答', value: AgentType.KNOWLEDGE_QA, icon: '📚' },
  { label: '自定义', value: AgentType.CUSTOM, icon: '🔧' }
]

/**
 * 智能体状态选项
 */
export const AGENT_STATUS_OPTIONS = [
  { label: '草稿', value: AgentStatus.DRAFT, color: 'warning' },
  { label: '已发布', value: AgentStatus.PUBLISHED, color: 'success' },
  { label: '已删除', value: AgentStatus.DELETED, color: 'danger' }
]

/**
 * 平台类型选项
 */
export const PLATFORM_TYPE_OPTIONS = [
  { label: 'Coze', value: PlatformType.COZE, icon: '🤖' },
  { label: 'Dify', value: PlatformType.DIFY, icon: '🔥' },
  { label: '阿里百炼', value: PlatformType.ALIBABA_DASHSCOPE, icon: '☁️' },
  { label: 'OpenAI', value: PlatformType.OPENAI, icon: '🤖' },
  { label: 'Claude', value: PlatformType.CLAUDE, icon: '🧠' },
  { label: '文心一言', value: PlatformType.WENXIN_YIYAN, icon: '🎯' },
  { label: '自定义', value: PlatformType.CUSTOM, icon: '⚙️' }
]