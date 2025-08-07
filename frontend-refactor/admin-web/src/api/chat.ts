/**
 * 聊天交互相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  ApiResult, 
  Message 
} from '@/types/api'

// 聊天请求
export interface ChatRequest {
  agentId: string
  conversationId?: string
  userId?: string
  content: string
  type?: 'TEXT' | 'IMAGE' | 'FILE'
  attachments?: Array<{
    id: string
    name: string
    type: string
    size: number
    url: string
  }>
}

// 聊天响应
export interface ChatResponse {
  messageId: string
  conversationId: string
  content: string
  type: 'TEXT' | 'IMAGE' | 'FILE'
  status: 'SUCCESS' | 'FAILED'
  tokens?: number
  cost?: number
  createdAt: string
}

/**
 * 发送聊天消息
 */
export function sendMessage(data: ChatRequest): Promise<ApiResult<ChatResponse>> {
  return httpClient.post<ChatResponse>('/api/v1/chat/send', data, {
    showSuccessMessage: false
  })
}

/**
 * 发送会话消息
 */
export function sendConversationMessage(conversationId: string, data: Omit<ChatRequest, 'conversationId'>): Promise<ApiResult<ChatResponse>> {
  return httpClient.post<ChatResponse>(`/api/v1/chat/conversations/${conversationId}/send`, data, {
    showSuccessMessage: false
  })
}

/**
 * 流式发送聊天消息
 */
export function sendMessageStream(
  data: ChatRequest,
  onMessage: (chunk: string) => void,
  onComplete: (message: ChatResponse) => void,
  onError: (error: any) => void
): void {
  const params = new URLSearchParams({
    agentId: data.agentId,
    content: data.content,
    type: data.type || 'TEXT'
  })
  
  if (data.conversationId) {
    params.append('conversationId', data.conversationId)
  }

  const eventSource = new EventSource(
    `/api/v1/chat/stream?${params.toString()}`,
    {
      withCredentials: true
    }
  )

  eventSource.onmessage = (event) => {
    try {
      const response = JSON.parse(event.data)
      
      if (response.type === 'chunk') {
        onMessage(response.content)
      } else if (response.type === 'complete') {
        onComplete(response.message)
        eventSource.close()
      } else if (response.type === 'error') {
        onError(new Error(response.error))
        eventSource.close()
      }
    } catch (error) {
      onError(error)
      eventSource.close()
    }
  }

  eventSource.onerror = (error) => {
    onError(error)
    eventSource.close()
  }
}

/**
 * 停止生成
 */
export function stopGeneration(conversationId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/api/v1/chat/conversations/${conversationId}/stop`)
}

/**
 * 重新生成消息
 */
export function regenerateMessage(messageId: string): Promise<ApiResult<ChatResponse>> {
  return httpClient.post<ChatResponse>(`/api/v1/chat/messages/${messageId}/regenerate`)
}

/**
 * 获取消息历史
 */
export function getMessageHistory(conversationId: string, params?: {
  pageNum?: number
  pageSize?: number
  beforeMessageId?: string
}): Promise<ApiResult<{
  messages: Message[]
  hasMore: boolean
  total: number
}>> {
  return httpClient.get(`/api/v1/chat/conversations/${conversationId}/messages`, { params })
}

/**
 * 删除消息
 */
export function deleteMessage(messageId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/api/v1/chat/messages/${messageId}`, {
    showSuccessMessage: true
  })
}

/**
 * 标记消息为有用/无用
 */
export function rateMessage(messageId: string, rating: 'positive' | 'negative', feedback?: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/api/v1/chat/messages/${messageId}/rate`, {
    rating,
    feedback
  }, {
    showSuccessMessage: true
  })
}

/**
 * 获取聊天建议
 */
export function getChatSuggestions(conversationId: string): Promise<ApiResult<string[]>> {
  return httpClient.get<string[]>(`/api/v1/chat/conversations/${conversationId}/suggestions`)
}

/**
 * 获取对话上下文
 */
export function getConversationContext(conversationId: string): Promise<ApiResult<{
  messages: Message[]
  summary: string
  keyPoints: string[]
  sentiment: 'positive' | 'neutral' | 'negative'
}>> {
  return httpClient.get(`/api/v1/chat/conversations/${conversationId}/context`)
}