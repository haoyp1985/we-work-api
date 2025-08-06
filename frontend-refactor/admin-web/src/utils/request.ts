import axios, {
  AxiosRequestConfig,
  AxiosResponse,
  AxiosError,
  InternalAxiosRequestConfig,
} from "axios";
import { ElMessage, ElLoading } from "element-plus";
import { useUserStore } from "@/stores/modules/user";
import router from "@/router";

// Create axios instance
const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "/api",
  timeout: 10000,
  headers: {
    "Content-Type": "application/json;charset=UTF-8",
  },
});

// Loading instance
let loadingInstance: any = null;

// Request interceptor
service.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // Show loading
    if (!config.hideLoading) {
      loadingInstance = ElLoading.service({
        text: "加载中...",
        background: "rgba(0, 0, 0, 0.7)",
      });
    }

    // Add token
    const userStore = useUserStore();
    if (userStore.token) {
      config.headers["Authorization"] = `Bearer ${userStore.token}`;
    }

    // Add tenant ID if available
    if (userStore.userInfo?.tenantId) {
      config.headers["X-Tenant-Id"] = userStore.userInfo.tenantId;
    }

    return config;
  },
  (error: AxiosError) => {
    if (loadingInstance) {
      loadingInstance.close();
    }
    return Promise.reject(error);
  },
);

// Response interceptor
service.interceptors.response.use(
  (response: AxiosResponse) => {
    if (loadingInstance) {
      loadingInstance.close();
    }

    const { code, message, data: _data } = response.data;

    // Success
    if (code === 200) {
      return response.data;
    }

    // Handle business errors
    if (code === 401) {
      ElMessage.error("登录已过期，请重新登录");
      const userStore = useUserStore();
      userStore.userLogout();
      router.push("/login");
      return Promise.reject(new Error("Unauthorized"));
    }

    if (code === 403) {
      ElMessage.error("权限不足");
      return Promise.reject(new Error("Forbidden"));
    }

    // Other business errors
    ElMessage.error(message || "请求失败");
    return Promise.reject(new Error(message || "Request failed"));
  },
  (error: AxiosError) => {
    if (loadingInstance) {
      loadingInstance.close();
    }

    // Network error
    if (!error.response) {
      ElMessage.error("网络连接失败");
      return Promise.reject(error);
    }

    const { status } = error.response;

    switch (status) {
      case 400:
        ElMessage.error("请求参数错误");
        break;
      case 401: {
        ElMessage.error("登录已过期，请重新登录");
        const userStore = useUserStore();
        userStore.userLogout();
        router.push("/login");
        break;
      }
      case 403:
        ElMessage.error("权限不足");
        break;
      case 404:
        ElMessage.error("请求的资源不存在");
        break;
      case 500:
        ElMessage.error("服务器内部错误");
        break;
      case 502:
        ElMessage.error("网关错误");
        break;
      case 503:
        ElMessage.error("服务不可用");
        break;
      default:
        ElMessage.error("请求失败");
    }

    return Promise.reject(error);
  },
);

// Export default request function
export default function request(config: AxiosRequestConfig) {
  return service(config);
}

// Export service instance for direct use
export { service };
