/**
 * 消息管理相关API
 * WeWork Management Platform - Frontend
 */

import request from '@/utils/request'
import type { 
  ApiResponse,
  PageResult,
  Message,
  MessageTemplate,
  MessageBatch,
  MessageSearchForm,
  MessageSendForm,
  BatchSendForm,
  MessageStatistics
} from '@/types'

/**
 * 消息管理API接口
 */
export const messageApi = {
  /**
   * 获取消息列表
   */
  getMessageList(params: MessageSearchForm): Promise<ApiResponse<PageResult<Message>>> {
    return request.get('/messages', { params })
  },

  /**
   * 获取消息详情
   */
  getMessageById(id: string): Promise<ApiResponse<Message>> {
    return request.get(`/messages/${id}`)
  },

  /**
   * 发送消息
   */
  sendMessage(data: MessageSendForm): Promise<ApiResponse<Message>> {
    return request.post('/messages/send', data)
  },

  /**
   * 批量发送消息
   */
  batchSendMessage(data: BatchSendForm): Promise<ApiResponse<MessageBatch>> {
    return request.post('/messages/batch-send', data)
  },

  /**
   * 取消消息发送
   */
  cancelMessage(id: string): Promise<ApiResponse<void>> {
    return request.post(`/messages/${id}/cancel`)
  },

  /**
   * 重发消息
   */
  resendMessage(id: string): Promise<ApiResponse<Message>> {
    return request.post(`/messages/${id}/resend`)
  },

  /**
   * 删除消息
   */
  deleteMessage(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/messages/${id}`)
  },

  /**
   * 批量删除消息
   */
  batchDeleteMessages(ids: string[]): Promise<ApiResponse<void>> {
    return request.delete('/messages/batch', { data: { ids } })
  },

  /**
   * 获取消息统计
   */
  getMessageStatistics(params?: {
    startDate?: string
    endDate?: string
    accountId?: string
  }): Promise<ApiResponse<MessageStatistics>> {
    return request.get('/messages/statistics', { params })
  },

  /**
   * 获取消息模板列表
   */
  getTemplateList(params?: {
    templateName?: string
    messageType?: string
    category?: string
    status?: string
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<MessageTemplate>>> {
    return request.get('/message-templates', { params })
  },

  /**
   * 获取消息模板详情
   */
  getTemplateById(id: string): Promise<ApiResponse<MessageTemplate>> {
    return request.get(`/message-templates/${id}`)
  },

  /**
   * 创建消息模板
   */
  createTemplate(data: any): Promise<ApiResponse<MessageTemplate>> {
    return request.post('/message-templates', data)
  },

  /**
   * 更新消息模板
   */
  updateTemplate(id: string, data: any): Promise<ApiResponse<MessageTemplate>> {
    return request.put(`/message-templates/${id}`, data)
  },

  /**
   * 删除消息模板
   */
  deleteTemplate(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/message-templates/${id}`)
  },

  /**
   * 批量删除消息模板
   */
  batchDeleteTemplates(ids: string[]): Promise<ApiResponse<void>> {
    return request.delete('/message-templates/batch', { data: { ids } })
  },

  /**
   * 预览消息模板
   */
  previewTemplate(id: string, variables?: Record<string, any>): Promise<ApiResponse<{
    content: any
    renderedContent: string
  }>> {
    return request.post(`/message-templates/${id}/preview`, { variables })
  },

  /**
   * 测试发送模板消息
   */
  testSendTemplate(id: string, data: {
    accountId: string
    recipient: string
    variables?: Record<string, any>
  }): Promise<ApiResponse<Message>> {
    return request.post(`/message-templates/${id}/test-send`, data)
  },

  /**
   * 复制消息模板
   */
  copyTemplate(id: string, templateName: string): Promise<ApiResponse<MessageTemplate>> {
    return request.post(`/message-templates/${id}/copy`, { templateName })
  },

  /**
   * 获取批次列表
   */
  getBatchList(params?: {
    batchName?: string
    status?: string
    startDate?: string
    endDate?: string
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<MessageBatch>>> {
    return request.get('/message-batches', { params })
  },

  /**
   * 获取批次详情
   */
  getBatchById(id: string): Promise<ApiResponse<MessageBatch>> {
    return request.get(`/message-batches/${id}`)
  },

  /**
   * 获取批次消息列表
   */
  getBatchMessages(batchId: string, params?: {
    status?: string
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<Message>>> {
    return request.get(`/message-batches/${batchId}/messages`, { params })
  },

  /**
   * 暂停批次发送
   */
  pauseBatch(id: string): Promise<ApiResponse<void>> {
    return request.post(`/message-batches/${id}/pause`)
  },

  /**
   * 恢复批次发送
   */
  resumeBatch(id: string): Promise<ApiResponse<void>> {
    return request.post(`/message-batches/${id}/resume`)
  },

  /**
   * 取消批次发送
   */
  cancelBatch(id: string): Promise<ApiResponse<void>> {
    return request.post(`/message-batches/${id}/cancel`)
  },

  /**
   * 重试失败消息
   */
  retryFailedMessages(batchId: string): Promise<ApiResponse<void>> {
    return request.post(`/message-batches/${batchId}/retry-failed`)
  },

  /**
   * 导出批次报告
   */
  exportBatchReport(id: string, format: 'EXCEL' | 'CSV' = 'EXCEL'): Promise<ApiResponse<{
    downloadUrl: string
  }>> {
    return request.post(`/message-batches/${id}/export-report`, { format })
  },

  /**
   * 上传媒体文件
   */
  uploadMedia(file: File, type: 'image' | 'video' | 'audio' | 'file'): Promise<ApiResponse<{
    url: string
    fileName: string
    fileSize: number
    fileType: string
  }>> {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('type', type)
    return request.post('/messages/upload-media', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  /**
   * 获取消息队列状态
   */
  getQueueStatus(): Promise<ApiResponse<any>> {
    return request.get('/messages/queue-status')
  },

  /**
   * 清空消息队列
   */
  clearQueue(): Promise<ApiResponse<void>> {
    return request.post('/messages/clear-queue')
  },

  /**
   * 获取发送限制配置
   */
  getSendLimits(): Promise<ApiResponse<{
    dailyLimit: number
    hourlyLimit: number
    minuteLimit: number
    currentUsage: {
      daily: number
      hourly: number
      minute: number
    }
  }>> {
    return request.get('/messages/send-limits')
  },

  /**
   * 更新发送限制配置
   */
  updateSendLimits(data: {
    dailyLimit: number
    hourlyLimit: number
    minuteLimit: number
  }): Promise<ApiResponse<void>> {
    return request.put('/messages/send-limits', data)
  },

  /**
   * 获取黑名单
   */
  getBlacklist(params?: {
    keyword?: string
    type?: 'PHONE' | 'EMAIL' | 'KEYWORD'
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<any>>> {
    return request.get('/messages/blacklist', { params })
  },

  /**
   * 添加到黑名单
   */
  addToBlacklist(data: {
    type: 'PHONE' | 'EMAIL' | 'KEYWORD'
    value: string
    reason?: string
  }): Promise<ApiResponse<void>> {
    return request.post('/messages/blacklist', data)
  },

  /**
   * 从黑名单移除
   */
  removeFromBlacklist(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/messages/blacklist/${id}`)
  },

  /**
   * 批量导入黑名单
   */
  importBlacklist(file: File, type: 'PHONE' | 'EMAIL' | 'KEYWORD'): Promise<ApiResponse<{
    imported: number
    skipped: number
    errors: string[]
  }>> {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('type', type)
    return request.post('/messages/blacklist/import', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  /**
   * 检查是否在黑名单中
   */
  checkBlacklist(value: string, type: 'PHONE' | 'EMAIL' | 'KEYWORD'): Promise<ApiResponse<{
    inBlacklist: boolean
    reason?: string
  }>> {
    return request.get('/messages/blacklist/check', {
      params: { value, type }
    })
  },

  /**
   * 获取消息回调配置
   */
  getCallbackConfig(): Promise<ApiResponse<any>> {
    return request.get('/messages/callback-config')
  },

  /**
   * 更新消息回调配置
   */
  updateCallbackConfig(data: any): Promise<ApiResponse<void>> {
    return request.put('/messages/callback-config', data)
  },

  /**
   * 测试消息回调
   */
  testCallback(url: string): Promise<ApiResponse<{
    success: boolean
    responseTime: number
    statusCode?: number
    errorMessage?: string
  }>> {
    return request.post('/messages/test-callback', { url })
  },

  /**
   * 获取消息审核配置
   */
  getAuditConfig(): Promise<ApiResponse<any>> {
    return request.get('/messages/audit-config')
  },

  /**
   * 更新消息审核配置
   */
  updateAuditConfig(data: any): Promise<ApiResponse<void>> {
    return request.put('/messages/audit-config', data)
  },

  /**
   * 获取待审核消息
   */
  getPendingAuditMessages(params?: {
    pageNum?: number
    pageSize?: number
  }): Promise<ApiResponse<PageResult<any>>> {
    return request.get('/messages/pending-audit', { params })
  },

  /**
   * 审核消息
   */
  auditMessage(id: string, data: {
    action: 'APPROVE' | 'REJECT'
    reason?: string
  }): Promise<ApiResponse<void>> {
    return request.post(`/messages/${id}/audit`, data)
  },

  /**
   * 批量审核消息
   */
  batchAuditMessages(ids: string[], action: 'APPROVE' | 'REJECT', reason?: string): Promise<ApiResponse<void>> {
    return request.post('/messages/batch-audit', { ids, action, reason })
  }
}