/**
 * 文件上传相关 API 服务
 */

import httpClient from '@/utils/request'
import type { ApiResult } from '@/types/api'

/**
 * 上传文件
 */
export function uploadFile(file: File, path?: string): Promise<ApiResult<{
  url: string
  filename: string
  size: number
  type: string
}>> {
  return httpClient.upload('/upload/file', file, undefined, {
    showSuccessMessage: false
  })
}

/**
 * 上传头像
 */
export function uploadAvatar(file: File): Promise<ApiResult<{
  url: string
  filename: string
  size: number
  type: string
}>> {
  return httpClient.upload('/upload/avatar', file, undefined, {
    showSuccessMessage: false
  })
}

/**
 * 上传图片
 */
export function uploadImage(file: File): Promise<ApiResult<{
  url: string
  filename: string
  size: number
  type: string
  width: number
  height: number
}>> {
  return httpClient.upload('/upload/image', file, undefined, {
    showSuccessMessage: false
  })
}

/**
 * 删除文件
 */
export function deleteFile(url: string): Promise<ApiResult<void>> {
  return httpClient.delete('/upload/file', {
    data: { url }
  })
}