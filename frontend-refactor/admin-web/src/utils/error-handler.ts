/**
 * 全局错误处理器
 */
import { ElMessage, ElNotification } from "element-plus";
import type { App } from "vue";

/**
 * 错误类型定义
 */
export interface ErrorInfo {
  message: string;
  stack?: string;
  filename?: string;
  lineno?: number;
  colno?: number;
  type: "script" | "resource" | "promise" | "network" | "custom";
  timestamp: number;
  userAgent: string;
  url: string;
}

/**
 * 错误处理配置
 */
export interface ErrorHandlerConfig {
  enableConsoleLog: boolean;
  enableNotification: boolean;
  enableReport: boolean;
  reportUrl?: string;
  maxErrorCount: number;
}

/**
 * 默认配置
 */
const DEFAULT_CONFIG: ErrorHandlerConfig = {
  enableConsoleLog: true,
  enableNotification: false,
  enableReport: false,
  maxErrorCount: 10,
};

/**
 * 错误处理器类
 */
class ErrorHandler {
  private config: ErrorHandlerConfig;
  private errorCount = 0;
  private errors: ErrorInfo[] = [];

  constructor(config: Partial<ErrorHandlerConfig> = {}) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * 处理脚本错误
   */
  handleScriptError = (
    message: string | Event,
    filename?: string,
    lineno?: number,
    colno?: number,
    error?: Error,
  ): boolean => {
    const errorInfo: ErrorInfo = {
      message: typeof message === "string" ? message : "Unknown script error",
      stack: error?.stack,
      filename,
      lineno,
      colno,
      type: "script",
      timestamp: Date.now(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    };

    this.processError(errorInfo);
    return true; // 阻止默认错误处理
  };

  /**
   * 处理资源加载错误
   */
  handleResourceError = (event: Event): void => {
    const target = event.target as HTMLElement;
    const errorInfo: ErrorInfo = {
      message: `Resource load error: ${target.tagName}`,
      type: "resource",
      timestamp: Date.now(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    };

    this.processError(errorInfo);
  };

  /**
   * 处理Promise未捕获的错误
   */
  handlePromiseError = (event: PromiseRejectionEvent): void => {
    const errorInfo: ErrorInfo = {
      message: `Unhandled promise rejection: ${event.reason}`,
      type: "promise",
      timestamp: Date.now(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    };

    this.processError(errorInfo);
    event.preventDefault(); // 阻止默认处理
  };

  /**
   * 处理网络错误
   */
  handleNetworkError = (error: any): void => {
    const errorInfo: ErrorInfo = {
      message: `Network error: ${error.message || "Unknown network error"}`,
      type: "network",
      timestamp: Date.now(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    };

    this.processError(errorInfo);
  };

  /**
   * 处理自定义错误
   */
  handleCustomError = (message: string, extra?: any): void => {
    const errorInfo: ErrorInfo = {
      message,
      stack: extra?.stack,
      type: "custom",
      timestamp: Date.now(),
      userAgent: navigator.userAgent,
      url: window.location.href,
    };

    this.processError(errorInfo);
  };

  /**
   * 处理错误信息
   */
  private processError(errorInfo: ErrorInfo): void {
    // 增加错误计数
    this.errorCount++;
    this.errors.push(errorInfo);

    // 控制台输出
    if (this.config.enableConsoleLog) {
      console.error("Error caught by handler:", errorInfo);
    }

    // 用户通知
    if (this.config.enableNotification && this.errorCount <= 3) {
      this.showErrorNotification(errorInfo);
    }

    // 错误上报
    if (this.config.enableReport) {
      this.reportError(errorInfo);
    }

    // 清理旧错误
    if (this.errors.length > this.config.maxErrorCount) {
      this.errors = this.errors.slice(-this.config.maxErrorCount);
    }
  }

  /**
   * 显示错误通知
   */
  private showErrorNotification(errorInfo: ErrorInfo): void {
    if (errorInfo.type === "network") {
      ElMessage.error("网络连接异常，请检查网络设置");
    } else if (errorInfo.type === "resource") {
      ElMessage.warning("资源加载失败");
    } else {
      ElNotification.error({
        title: "系统错误",
        message: "页面出现异常，请刷新页面重试",
        duration: 5000,
      });
    }
  }

  /**
   * 上报错误
   */
  private async reportError(errorInfo: ErrorInfo): Promise<void> {
    if (!this.config.reportUrl) return;

    try {
      await fetch(this.config.reportUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(errorInfo),
      });
    } catch (error) {
      console.warn("Error reporting failed:", error);
    }
  }

  /**
   * 获取错误统计
   */
  getErrorStats() {
    return {
      totalCount: this.errorCount,
      recentErrors: this.errors,
      errorTypes: this.errors.reduce(
        (acc, error) => {
          acc[error.type] = (acc[error.type] || 0) + 1;
          return acc;
        },
        {} as Record<string, number>,
      ),
    };
  }

  /**
   * 清空错误记录
   */
  clearErrors(): void {
    this.errorCount = 0;
    this.errors = [];
  }
}

/**
 * 全局错误处理器实例
 */
export const errorHandler = new ErrorHandler();

/**
 * 设置全局错误处理
 */
export function setupErrorHandler(
  app: App,
  config?: Partial<ErrorHandlerConfig>,
): void {
  if (config) {
    Object.assign(errorHandler.config, config);
  }

  // 监听脚本错误
  window.addEventListener("error", (event) => {
    errorHandler.handleScriptError(
      event.message,
      event.filename,
      event.lineno,
      event.colno,
      event.error,
    );
  });

  // 监听资源加载错误
  window.addEventListener(
    "error",
    (event) => {
      errorHandler.handleResourceError(event);
    },
    true, // 使用捕获阶段
  );

  // 监听Promise未捕获错误
  window.addEventListener(
    "unhandledrejection",
    errorHandler.handlePromiseError,
  );

  // Vue错误处理
  app.config.errorHandler = (error, instance, info) => {
    errorHandler.handleCustomError(`Vue error: ${error.message}`, {
      stack: error.stack,
      info,
      instance,
    });
  };

  console.log("Error handler setup completed");
}
