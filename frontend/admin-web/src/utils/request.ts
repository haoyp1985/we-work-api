import axios, { type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores'
import { getToken, removeToken } from '@/utils/auth'
import router from '@/router'
import type { ApiResponse } from '@/types'

// 创建axios实例
const service: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API || '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json;charset=utf-8'
  }
})

// 请求拦截器
service.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    // 添加认证token
    const token = getToken()
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`
    }

    // 添加时间戳参数，防止缓存
    if (config.method === 'get') {
      config.params = {
        ...config.params,
        _t: Date.now()
      }
    }

    // 请求日志
    if (import.meta.env.DEV) {
      console.log('🚀 请求发送:', {
        url: config.url,
        method: config.method,
        params: config.params,
        data: config.data
      })
    }

    return config
  },
  (error) => {
    console.error('❌ 请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  (response: AxiosResponse<ApiResponse>) => {
    const { data } = response

    // 响应日志
    if (import.meta.env.DEV) {
      console.log('✅ 响应接收:', {
        url: response.config.url,
        status: response.status,
        data: data
      })
    }

    // 处理业务错误
    if (data.code !== 200) {
      const message = data.message || '请求失败'
      
      // 特殊错误码处理
      switch (data.code) {
        case 401:
          handleUnauthorized()
          break
        case 403:
          ElMessage.error('访问被拒绝，权限不足')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 500:
          ElMessage.error('服务器内部错误')
          break
        default:
          ElMessage.error(message)
      }
      
      return Promise.reject(new Error(message))
    }

    return data
  },
  (error) => {
    console.error('❌ 响应错误:', error)

    let message = '网络错误'
    
    if (error.response) {
      const { status, data } = error.response
      
      switch (status) {
        case 400:
          message = data?.message || '请求参数错误'
          break
        case 401:
          handleUnauthorized()
          return Promise.reject(error)
        case 403:
          message = '访问被拒绝，权限不足'
          break
        case 404:
          message = '请求的接口不存在'
          break
        case 422:
          message = data?.message || '请求参数验证失败'
          break
        case 500:
          message = '服务器内部错误'
          break
        case 502:
          message = '网关错误'
          break
        case 503:
          message = '服务暂时不可用'
          break
        case 504:
          message = '网关超时'
          break
        default:
          message = data?.message || `请求失败 (${status})`
      }
    } else if (error.code === 'ECONNABORTED') {
      message = '请求超时，请稍后重试'
    } else if (error.message.includes('Network Error')) {
      message = '网络连接失败，请检查网络'
    }

    ElMessage.error(message)
    return Promise.reject(error)
  }
)

// 处理未认证错误
let isRefreshing = false
let failedQueue: Array<{ resolve: Function; reject: Function }> = []

const handleUnauthorized = async () => {
  const userStore = useUserStore()
  
  if (isRefreshing) {
    // 如果正在刷新token，将请求加入队列
    return new Promise((resolve, reject) => {
      failedQueue.push({ resolve, reject })
    })
  }

  isRefreshing = true

  try {
    // 尝试刷新token（这里需要实现refreshToken接口）
    // const newToken = await refreshToken()
    // setToken(newToken)
    
    // 处理队列中的请求
    failedQueue.forEach(({ resolve }) => resolve())
    failedQueue = []
    
  } catch (error) {
    // 刷新失败，清除状态并跳转到登录页
    failedQueue.forEach(({ reject }) => reject(error))
    failedQueue = []
    
    userStore.resetState()
    
    ElMessageBox.confirm(
      '登录状态已失效，请重新登录',
      '系统提示',
      {
        confirmButtonText: '重新登录',
        cancelButtonText: '取消',
        type: 'warning'
      }
    ).then(() => {
      router.push('/login')
    }).catch(() => {
      // 用户取消，不做处理
    })
  } finally {
    isRefreshing = false
  }
}

// 导出请求方法
export default service

// 封装常用请求方法
export const http = {
  get<T = any>(url: string, params?: any): Promise<ApiResponse<T>> {
    return service.get(url, { params })
  },

  post<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    return service.post(url, data)
  },

  put<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    return service.put(url, data)
  },

  patch<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    return service.patch(url, data)
  },

  delete<T = any>(url: string, params?: any): Promise<ApiResponse<T>> {
    return service.delete(url, { params })
  },

  upload<T = any>(url: string, formData: FormData): Promise<ApiResponse<T>> {
    return service.post(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  }
}