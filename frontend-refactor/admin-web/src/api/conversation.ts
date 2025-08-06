/**
 * 对话管理相关 API 服务
 */

import httpClient from '@/utils/request'
import type { 
  Conversation, 
  Message,
  SendMessageRequest,
  ConversationStatus,
  MessageRole,
  PageResult,
  ApiResult
} from '@/types/api'

/**
 * 获取对话列表  
 */
export function getConversations(params?: {
  current?: number
  size?: number
  keyword?: string
  agentId?: string
  userId?: string
  status?: ConversationStatus
  isStarred?: boolean
  isPinned?: boolean
  startDate?: string
  endDate?: string
}): Promise<ApiResult<PageResult<Conversation>>> {
  return httpClient.get<PageResult<Conversation>>('/api/v1/conversations', { params })
}

/**
 * 创建对话
 */
export function createConversation(data: {
  agentId: string
  title?: string
}): Promise<ApiResult<Conversation>> {
  return httpClient.post<Conversation>('/api/v1/conversations', null, {
    params: data,
    showSuccessMessage: true
  })
}

/**
 * 获取用户对话列表
 */
export function getUserConversations(userId: string, params?: {
  pageNum?: number
  pageSize?: number
}): Promise<ApiResult<PageResult<Conversation>>> {
  return httpClient.get<PageResult<Conversation>>(`/api/v1/conversations/user/${userId}`, { params })
}

/**
 * 获取智能体对话列表
 */
export function getAgentConversations(agentId: string, params?: {
  pageNum?: number
  pageSize?: number
}): Promise<ApiResult<PageResult<Conversation>>> {
  return httpClient.get<PageResult<Conversation>>(`/api/v1/conversations/agent/${agentId}`, { params })
}

/**
 * 获取用户活跃对话
 */
export function getActiveConversations(userId: string): Promise<ApiResult<Conversation[]>> {
  return httpClient.get<Conversation[]>(`/api/v1/conversations/user/${userId}/active`)
}

/**
 * 获取对话统计信息
 */
export function getConversationStatistics(): Promise<ApiResult<Record<string, number>>> {
  return httpClient.get<Record<string, number>>('/api/v1/conversations/statistics')
}

/**
 * 获取用户对话数量
 */
export function countUserConversations(userId: string): Promise<ApiResult<number>> {
  return httpClient.get<number>(`/api/v1/conversations/user/${userId}/count`)
}

/**
 * 获取智能体对话数量
 */
export function countAgentConversations(agentId: string): Promise<ApiResult<number>> {
  return httpClient.get<number>(`/api/v1/conversations/agent/${agentId}/count`)
}

/**
 * 获取对话详情
 */
export function getConversation(id: string): Promise<ApiResult<Conversation>> {
  return httpClient.get<Conversation>(`/api/v1/conversations/${id}`)
}

/**
 * 更新对话标题
 */
export function updateConversationTitle(id: string, title: string): Promise<ApiResult<Conversation>> {
  return httpClient.put<Conversation>(`/api/v1/conversations/${id}/title`, null, {
    params: { title },
    showSuccessMessage: true
  })
}

/**
 * 结束对话
 */
export function endConversation(id: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/api/v1/conversations/${id}/end`, null, {
    showSuccessMessage: true
  })
}

/**
 * 删除对话
 */
export function deleteConversation(id: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/api/v1/conversations/${id}`, {
    showSuccessMessage: true
  })
}

/**
 * 批量删除对话
 */
export function batchDeleteConversations(ids: string[]): Promise<ApiResult<void>> {
  return httpClient.post<void>('/conversations/batch-delete', { ids }, {
    showSuccessMessage: true
  })
}

/**
 * 归档对话
 */
export function archiveConversation(id: string): Promise<ApiResult<Conversation>> {
  return httpClient.post<Conversation>(`/conversations/${id}/archive`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 取消归档对话
 */
export function unarchiveConversation(id: string): Promise<ApiResult<Conversation>> {
  return httpClient.post<Conversation>(`/conversations/${id}/unarchive`, {}, {
    showSuccessMessage: true
  })
}

/**
 * 收藏/取消收藏对话
 */
export function toggleConversationStar(id: string, isStarred: boolean): Promise<ApiResult<Conversation>> {
  return httpClient.post<Conversation>(`/conversations/${id}/star`, { isStarred }, {
    showSuccessMessage: true
  })
}

/**
 * 置顶/取消置顶对话
 */
export function toggleConversationPin(id: string, isPinned: boolean): Promise<ApiResult<Conversation>> {
  return httpClient.post<Conversation>(`/conversations/${id}/pin`, { isPinned }, {
    showSuccessMessage: true
  })
}

/**
 * 获取对话消息列表
 */
export function getConversationMessages(conversationId: string, params?: {
  current?: number
  size?: number
  beforeId?: string
  afterId?: string
  messageType?: string
  role?: MessageRole
}): Promise<ApiResult<PageResult<Message>>> {
  return httpClient.get<PageResult<Message>>(`/conversations/${conversationId}/messages`, params)
}

/**
 * 获取消息详情
 */
export function getMessage(messageId: string): Promise<ApiResult<Message>> {
  return httpClient.get<Message>(`/messages/${messageId}`)
}

/**
 * 发送消息
 */
export function sendMessage(data: SendMessageRequest): Promise<ApiResult<Message>> {
  return httpClient.post<Message>('/conversations/messages', data)
}

/**
 * 发送消息（流式响应）
 */
export function sendMessageStream(
  data: SendMessageRequest,
  onMessage: (chunk: string) => void,
  onComplete: (message: Message) => void,
  onError: (error: any) => void
): void {
  const eventSource = new EventSource(
    `/api/conversations/messages/stream?${new URLSearchParams({
      conversationId: data.conversationId || '',
      agentId: data.agentId,
      content: data.content,
      type: data.type || 'TEXT'
    }).toString()}`,
    {
      withCredentials: true
    }
  )

  eventSource.onmessage = (event) => {
    try {
      const data = JSON.parse(event.data)
      
      if (data.type === 'chunk') {
        onMessage(data.content)
      } else if (data.type === 'complete') {
        onComplete(data.message)
        eventSource.close()
      } else if (data.type === 'error') {
        onError(new Error(data.error))
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
 * 重新生成消息
 */
export function regenerateMessage(messageId: string): Promise<ApiResult<Message>> {
  return httpClient.post<Message>(`/messages/${messageId}/regenerate`)
}

/**
 * 编辑消息
 */
export function editMessage(messageId: string, content: string): Promise<ApiResult<Message>> {
  return httpClient.put<Message>(`/messages/${messageId}`, { content }, {
    showSuccessMessage: true
  })
}

/**
 * 删除消息
 */
export function deleteMessage(messageId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/messages/${messageId}`, {
    showSuccessMessage: true
  })
}

/**
 * 批量删除消息
 */
export function batchDeleteMessages(messageIds: string[]): Promise<ApiResult<void>> {
  return httpClient.post<void>('/messages/batch-delete', { messageIds }, {
    showSuccessMessage: true
  })
}

/**
 * 点赞/取消点赞消息
 */
export function toggleMessageReaction(messageId: string, type: 'LIKE' | 'DISLIKE'): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/messages/${messageId}/reactions`, { type })
}

/**
 * 复制消息到新对话
 */
export function copyMessageToConversation(messageId: string, targetConversationId: string): Promise<ApiResult<Message>> {
  return httpClient.post<Message>(`/messages/${messageId}/copy`, { 
    targetConversationId 
  }, {
    showSuccessMessage: true
  })
}

/**
 * 导出对话
 */
export function exportConversation(conversationId: string, format: 'txt' | 'md' | 'json' | 'pdf'): Promise<void> {
  return httpClient.download(`/conversations/${conversationId}/export`, { format }, `conversation-${conversationId}.${format}`)
}

/**
 * 导入对话
 */
export function importConversation(file: File, agentId?: string): Promise<ApiResult<Conversation>> {
  return httpClient.upload<Conversation>('/conversations/import', file, undefined, {
    showSuccessMessage: true
  })
}

/**
 * 清空对话消息
 */
export function clearConversationMessages(conversationId: string): Promise<ApiResult<void>> {
  return httpClient.delete<void>(`/conversations/${conversationId}/messages`, {
    showSuccessMessage: true
  })
}

/**
 * 获取对话统计信息
 */
export function getConversationStats(conversationId: string): Promise<ApiResult<{
  messageCount: number
  tokenCount: number
  cost: number
  duration: number
  firstMessageAt: string
  lastMessageAt: string
  participantCount: number
}>> {
  return httpClient.get(`/conversations/${conversationId}/stats`)
}

/**
 * 搜索消息
 */
export function searchMessages(params: {
  keyword: string
  conversationId?: string
  agentId?: string
  userId?: string
  messageType?: string
  role?: MessageRole
  startDate?: string
  endDate?: string
  current?: number
  size?: number
}): Promise<ApiResult<PageResult<Message>>> {
  return httpClient.get<PageResult<Message>>('/messages/search', params)
}

/**
 * 获取相关消息
 */
export function getRelatedMessages(messageId: string, limit: number = 5): Promise<ApiResult<Message[]>> {
  return httpClient.get<Message[]>(`/messages/${messageId}/related`, { limit })
}

/**
 * 获取消息建议
 */
export function getMessageSuggestions(conversationId: string, limit: number = 3): Promise<ApiResult<string[]>> {
  return httpClient.get<string[]>(`/conversations/${conversationId}/suggestions`, { limit })
}

/**
 * 标记消息为已读
 */
export function markMessageAsRead(messageId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/messages/${messageId}/read`)
}

/**
 * 标记对话所有消息为已读
 */
export function markConversationAsRead(conversationId: string): Promise<ApiResult<void>> {
  return httpClient.post<void>(`/conversations/${conversationId}/read`)
}

/**
 * 获取未读消息数量
 */
export function getUnreadMessageCount(): Promise<ApiResult<{
  total: number
  byConversation: Record<string, number>
}>> {
  return httpClient.get('/messages/unread-count')
}