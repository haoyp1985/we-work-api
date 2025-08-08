/**
 * HTTP 请求工具类
 * 基于 axios 封装，提供统一的请求处理、错误处理和认证机制
 */

import axios, { 
  AxiosInstance, 
  AxiosRequestConfig, 
  AxiosResponse, 
  InternalAxiosRequestConfig 
} from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/modules/user'
import { getToken, removeToken } from '@/utils/auth'
import router from '@/router'

// API响应数据结构
export interface ApiResult<T = any> {
  code: number
  message: string
  data: T
  success: boolean
  timestamp: number
}

// 分页响应结构
export interface PageResult<T = any> {
  current: number
  size: number
  total: number
  pages: number
  records: T[]
}

// 请求配置扩展
export interface RequestConfig extends AxiosRequestConfig {
  skipAuth?: boolean // 跳过认证
  skipErrorHandler?: boolean // 跳过统一错误处理
  showLoading?: boolean // 显示加载状态
  showSuccessMessage?: boolean // 显示成功消息
}

class HttpClient {
  private instance: AxiosInstance
  private baseURL: string
  private timeout: number
  private bypassAuth: boolean
  private devToken: string

  constructor() {
    this.baseURL = import.meta.env.VITE_API_BASE_URL || '/api'
    this.timeout = 30000
    this.bypassAuth = import.meta.env.VITE_BYPASS_AUTH === 'true'
    // 临时令牌（仅用于跳过认证时本地调试）
    this.devToken =
      import.meta.env.VITE_DEV_TOKEN ||
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkZXYtdXNlciIsInVzZXJuYW1lIjoiZGV2IiwidGVuYW50SWQiOiJ0ZW5hbnQtZGV2Iiwicm9sZXMiOltdLCJwZXJtaXNzaW9ucyI6W10sImV4cCI6MTk5OTk5OTk5OX0.h4TjH1o7U0w9w2wYp8d2cQhO0RrZ3U83g1e7J9J0ABc'

    this.instance = axios.create({
      baseURL: this.baseURL,
      timeout: this.timeout,
      headers: {
        'Content-Type': 'application/json',
      },
    })

    this.setupInterceptors()
  }

  /**
   * 设置请求和响应拦截器
   */
  private setupInterceptors(): void {
    // 请求拦截器
    this.instance.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        const customConfig = config as InternalAxiosRequestConfig & RequestConfig

        // 添加认证 token
        if (!customConfig.skipAuth) {
          if (this.bypassAuth) {
            // 跳过认证时，强制注入临时token
            config.headers.Authorization = `Bearer ${this.devToken}`
          } else {
            const token = getToken()
            if (token) {
              config.headers.Authorization = `Bearer ${token}`
            }
          }
        }

        // 添加租户信息
        const userStore = useUserStore()
        if (this.bypassAuth) {
          // 跳过认证时，给定一个固定的开发租户ID
          config.headers['X-Tenant-Id'] = import.meta.env.VITE_DEV_TENANT_ID || 'tenant-dev'
        } else if (userStore.userInfo?.tenantId) {
          config.headers['X-Tenant-Id'] = userStore.userInfo.tenantId
        }

        // 添加请求ID用于追踪
        config.headers['X-Request-Id'] = this.generateRequestId()

        // 添加时间戳防止缓存
        if (config.method === 'get') {
          config.params = {
            ...config.params,
            _t: Date.now(),
          }
        }

        console.log(`🚀 [API Request] ${config.method?.toUpperCase()} ${config.url}`, {
          params: config.params,
          data: config.data,
        })

        return config
      },
      (error) => {
        console.error('❌ [API Request Error]', error)
        return Promise.reject(error)
      }
    )

    // 响应拦截器
    this.instance.interceptors.response.use(
      (response: AxiosResponse<ApiResult>): any => {
        const config = response.config as InternalAxiosRequestConfig & RequestConfig
        const { data } = response

        console.log(`✅ [API Response] ${config.method?.toUpperCase()} ${config.url}`, {
          status: response.status,
          data: data,
        })

        // 显示成功消息
        if (config.showSuccessMessage && data.message) {
          ElMessage.success(data.message)
        }

        // 检查业务状态码
        if (!data.success || data.code !== 200) {
          const errorMessage = data.message || '请求失败'
          
          // 特殊错误码处理
          switch (data.code) {
            case 401:
              if (this.bypassAuth) {
                // 开发模式直接吞掉401，返回一个成功的空数据
                console.warn('[BYPASS_AUTH] 忽略401: ', errorMessage)
                const patched = { ...data, success: true, code: 200 } as ApiResult
                return patched
              }
              this.handleUnauthorized(errorMessage).catch(() => {})
              throw new Error(errorMessage)
            case 403:
              this.handleForbidden(errorMessage)
              throw new Error(errorMessage)
            case 500:
              this.handleServerError(errorMessage)
              throw new Error(errorMessage)
            default:
              if (!config.skipErrorHandler) {
                ElMessage.error(errorMessage)
              }
              throw new Error(errorMessage)
          }

          // 理论上已 return/throw，不会到达这里
        }

        return data
      },
      (error) => {
        const config = error.config as InternalAxiosRequestConfig & RequestConfig

        console.error(`❌ [API Response Error] ${config?.method?.toUpperCase()} ${config?.url}`, error)

        if (!config?.skipErrorHandler) {
          this.handleResponseError(error)
        }

        return Promise.reject(error)
      }
    )
  }

  /**
   * 处理未授权错误 - 尝试刷新token
   */
  private async handleUnauthorized(message: string): Promise<void> {
    const userStore = useUserStore()
    
    // 如果有refreshToken，尝试刷新
    if (userStore.refreshToken) {
      try {
        await userStore.refreshAccessToken()
        ElMessage.success('登录状态已刷新')
        return
      } catch (error) {
        console.error('Token刷新失败:', error)
      }
    }
    
    // 刷新失败或没有refreshToken，提示重新登录
    ElMessageBox.confirm(
      message || '登录状态已过期，请重新登录',
      '登录过期',
      {
        confirmButtonText: '重新登录',
        cancelButtonText: '取消',
        type: 'warning',
      }
    ).then(() => {
      userStore.logout()
      router.push('/login')
    }).catch(() => {
      // 用户取消
    })
  }

  /**
   * 处理权限不足错误
   */
  private handleForbidden(message: string): void {
    ElMessage.error(message || '权限不足，无法访问该资源')
    router.push('/403')
  }

  /**
   * 处理服务器错误
   */
  private handleServerError(message: string): void {
    ElMessage.error(message || '服务器内部错误，请稍后重试')
  }

  /**
   * 处理响应错误
   */
  private handleResponseError(error: any): void {
    if (error.response) {
      const { status, statusText } = error.response
      
      switch (status) {
        case 400:
          ElMessage.error('请求参数错误')
          break
        case 401:
          this.handleUnauthorized('认证失败，请重新登录')
          break
        case 403:
          this.handleForbidden('权限不足')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 405:
          ElMessage.error('请求方法不允许')
          break
        case 408:
          ElMessage.error('请求超时')
          break
        case 500:
          this.handleServerError('服务器内部错误')
          break
        case 502:
          ElMessage.error('网关错误')
          break
        case 503:
          ElMessage.error('服务不可用')
          break
        case 504:
          ElMessage.error('网关超时')
          break
        default:
          ElMessage.error(`请求失败: ${status} ${statusText}`)
      }
    } else if (error.request) {
      ElMessage.error('网络错误，请检查网络连接')
    } else {
      ElMessage.error('请求配置错误')
    }
  }

  /**
   * 生成请求ID
   */
  private generateRequestId(): string {
    return `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  }

  /**
   * GET 请求
   */
  public get<T = any>(
    url: string, 
    params?: any, 
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    return this.instance.get(url, { params, ...config })
  }

  /**
   * POST 请求
   */
  public post<T = any>(
    url: string, 
    data?: any, 
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    return this.instance.post(url, data, config)
  }

  /**
   * PUT 请求
   */
  public put<T = any>(
    url: string, 
    data?: any, 
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    return this.instance.put(url, data, config)
  }

  /**
   * DELETE 请求
   */
  public delete<T = any>(
    url: string, 
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    return this.instance.delete(url, config)
  }

  /**
   * PATCH 请求
   */
  public patch<T = any>(
    url: string, 
    data?: any, 
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    return this.instance.patch(url, data, config)
  }

  /**
   * 上传文件
   */
  public upload<T = any>(
    url: string, 
    file: File, 
    onUploadProgress?: (progressEvent: any) => void,
    config?: RequestConfig
  ): Promise<ApiResult<T>> {
    const formData = new FormData()
    formData.append('file', file)

    return this.instance.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      onUploadProgress,
      ...config,
    })
  }

  /**
   * 下载文件
   */
  public download(
    url: string, 
    params?: any, 
    filename?: string,
    config?: RequestConfig
  ): Promise<void> {
    return this.instance.get(url, {
      params,
      responseType: 'blob',
      ...config,
    }).then((response: any) => {
      const blob = new Blob([response.data])
      const downloadUrl = window.URL.createObjectURL(blob)
      const link = document.createElement('a')
      
      link.href = downloadUrl
      link.download = filename || this.extractFilenameFromResponse(response) || 'download'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      window.URL.revokeObjectURL(downloadUrl)
    })
  }

  /**
   * 从响应头中提取文件名
   */
  private extractFilenameFromResponse(response: AxiosResponse): string | null {
    const contentDisposition = response.headers['content-disposition']
    if (contentDisposition) {
      const filenameMatch = contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/)
      if (filenameMatch && filenameMatch[1]) {
        return filenameMatch[1].replace(/['"]/g, '')
      }
    }
    return null
  }

  /**
   * 取消请求
   */
  public createCancelToken() {
    return axios.CancelToken.source()
  }

  /**
   * 获取实例（用于特殊需求）
   */
  public getInstance(): AxiosInstance {
    return this.instance
  }
}

// 创建全局实例
const httpClient = new HttpClient()

export default httpClient
export { HttpClient }
