import { http } from '@/utils/request'
import type { 
  SendMessageRequest, 
  BatchSendMessageRequest, 
  SendMessageResponse,
  MessageTemplate,
  PageResult,
  PageParams
} from '@/types'

/**
 * 发送单条消息
 */
export const sendMessage = (data: SendMessageRequest) => {
  return http.post<SendMessageResponse>('/messages/send', data)
}

/**
 * 批量发送消息
 */
export const batchSendMessage = (data: BatchSendMessageRequest) => {
  return http.post<SendMessageResponse[]>('/messages/batch-send', data)
}

/**
 * 获取消息发送记录
 */
export const getMessageHistory = (params: PageParams & {
  providerId?: string
  guid?: string
  status?: string
  startTime?: string
  endTime?: string
}) => {
  return http.get<PageResult<SendMessageResponse>>('/messages/history', params)
}

/**
 * 获取消息模板列表
 */
export const getMessageTemplates = (params: PageParams & {
  templateName?: string
  templateType?: string
  status?: string
}) => {
  return http.get<PageResult<MessageTemplate>>('/messages/templates', params)
}

/**
 * 创建消息模板
 */
export const createMessageTemplate = (data: Partial<MessageTemplate>) => {
  return http.post<MessageTemplate>('/messages/templates', data)
}

/**
 * 更新消息模板
 */
export const updateMessageTemplate = (id: string, data: Partial<MessageTemplate>) => {
  return http.put<MessageTemplate>(`/messages/templates/${id}`, data)
}

/**
 * 删除消息模板
 */
export const deleteMessageTemplate = (id: string) => {
  return http.delete(`/messages/templates/${id}`)
}

/**
 * 获取消息统计
 */
export const getMessageStats = (params?: {
  startTime?: string
  endTime?: string
  providerId?: string
}) => {
  return http.get<{
    totalSent: number
    successCount: number
    failedCount: number
    successRate: number
    dailyStats: Array<{
      date: string
      sent: number
      success: number
      failed: number
    }>
    typeStats: Array<{
      type: string
      count: number
      percentage: number
    }>
  }>('/messages/stats', params)
}