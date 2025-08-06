/**
 * 性能监控工具
 */
import type { App } from "vue";

/**
 * 性能指标接口
 */
export interface PerformanceMetrics {
  // 页面加载相关
  domContentLoaded?: number;
  loadComplete?: number;
  firstPaint?: number;
  firstContentfulPaint?: number;
  largestContentfulPaint?: number;

  // 用户交互相关
  firstInputDelay?: number;
  cumulativeLayoutShift?: number;

  // 资源加载
  resourceCount?: number;
  totalResourceSize?: number;

  // 内存使用
  jsHeapSizeLimit?: number;
  totalJSHeapSize?: number;
  usedJSHeapSize?: number;

  // 网络信息
  connectionType?: string;
  effectiveType?: string;

  // 时间戳
  timestamp: number;
  url: string;
}

/**
 * 性能监控配置
 */
export interface PerformanceConfig {
  enableConsoleLog: boolean;
  enableReport: boolean;
  reportUrl?: string;
  reportInterval: number; // 上报间隔（毫秒）
  maxMetricsCount: number;
}

/**
 * 默认配置
 */
const DEFAULT_CONFIG: PerformanceConfig = {
  enableConsoleLog: false,
  enableReport: false,
  reportInterval: 30000, // 30秒
  maxMetricsCount: 50,
};

/**
 * 性能监控类
 */
class PerformanceMonitor {
  private config: PerformanceConfig;
  private metrics: PerformanceMetrics[] = [];
  private reportTimer?: NodeJS.Timeout;
  private observer?: PerformanceObserver;

  constructor(config: Partial<PerformanceConfig> = {}) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * 开始监控
   */
  start(): void {
    this.collectPageMetrics();
    this.observeWebVitals();
    this.startReporting();

    if (this.config.enableConsoleLog) {
      console.log("Performance monitoring started");
    }
  }

  /**
   * 停止监控
   */
  stop(): void {
    if (this.reportTimer) {
      clearInterval(this.reportTimer);
    }

    if (this.observer) {
      this.observer.disconnect();
    }

    if (this.config.enableConsoleLog) {
      console.log("Performance monitoring stopped");
    }
  }

  /**
   * 收集页面性能指标
   */
  private collectPageMetrics(): void {
    if (!window.performance) return;

    const navigation = performance.getEntriesByType(
      "navigation",
    )[0] as PerformanceNavigationTiming;
    const paint = performance.getEntriesByType("paint");

    const metrics: PerformanceMetrics = {
      timestamp: Date.now(),
      url: window.location.href,
    };

    // 页面加载时间
    if (navigation) {
      metrics.domContentLoaded =
        navigation.domContentLoadedEventEnd - navigation.navigationStart;
      metrics.loadComplete =
        navigation.loadEventEnd - navigation.navigationStart;
    }

    // 绘制时间
    paint.forEach((entry) => {
      if (entry.name === "first-paint") {
        metrics.firstPaint = entry.startTime;
      } else if (entry.name === "first-contentful-paint") {
        metrics.firstContentfulPaint = entry.startTime;
      }
    });

    // 资源信息
    const resources = performance.getEntriesByType("resource");
    metrics.resourceCount = resources.length;
    metrics.totalResourceSize = resources.reduce((total, resource) => {
      return (
        total + ((resource as PerformanceResourceTiming).transferSize || 0)
      );
    }, 0);

    // 内存信息
    if ("memory" in performance) {
      const memory = (performance as any).memory;
      metrics.jsHeapSizeLimit = memory.jsHeapSizeLimit;
      metrics.totalJSHeapSize = memory.totalJSHeapSize;
      metrics.usedJSHeapSize = memory.usedJSHeapSize;
    }

    // 网络信息
    if ("connection" in navigator) {
      const connection = (navigator as any).connection;
      metrics.connectionType = connection?.type;
      metrics.effectiveType = connection?.effectiveType;
    }

    this.addMetrics(metrics);
  }

  /**
   * 观察Web Vitals指标
   */
  private observeWebVitals(): void {
    if (!window.PerformanceObserver) return;

    try {
      // 观察LCP
      const lcpObserver = new PerformanceObserver((list) => {
        const entries = list.getEntries();
        const lastEntry = entries[entries.length - 1];

        this.updateMetrics({
          largestContentfulPaint: lastEntry.startTime,
        });
      });
      lcpObserver.observe({ entryTypes: ["largest-contentful-paint"] });

      // 观察FID
      const fidObserver = new PerformanceObserver((list) => {
        const entries = list.getEntries();
        entries.forEach((entry) => {
          this.updateMetrics({
            firstInputDelay: (entry as any).processingStart - entry.startTime,
          });
        });
      });
      fidObserver.observe({ entryTypes: ["first-input"] });

      // 观察CLS
      const clsObserver = new PerformanceObserver((list) => {
        const entries = list.getEntries();
        let clsValue = 0;

        entries.forEach((entry) => {
          if (!(entry as any).hadRecentInput) {
            clsValue += (entry as any).value;
          }
        });

        this.updateMetrics({
          cumulativeLayoutShift: clsValue,
        });
      });
      clsObserver.observe({ entryTypes: ["layout-shift"] });
    } catch (error) {
      console.warn("Failed to setup performance observers:", error);
    }
  }

  /**
   * 添加性能指标
   */
  private addMetrics(metrics: PerformanceMetrics): void {
    this.metrics.push(metrics);

    // 限制存储数量
    if (this.metrics.length > this.config.maxMetricsCount) {
      this.metrics = this.metrics.slice(-this.config.maxMetricsCount);
    }

    if (this.config.enableConsoleLog) {
      console.log("Performance metrics collected:", metrics);
    }
  }

  /**
   * 更新最新的性能指标
   */
  private updateMetrics(updates: Partial<PerformanceMetrics>): void {
    if (this.metrics.length === 0) return;

    const lastMetrics = this.metrics[this.metrics.length - 1];
    Object.assign(lastMetrics, updates);

    if (this.config.enableConsoleLog) {
      console.log("Performance metrics updated:", updates);
    }
  }

  /**
   * 开始定时上报
   */
  private startReporting(): void {
    if (!this.config.enableReport || !this.config.reportUrl) return;

    this.reportTimer = setInterval(() => {
      this.reportMetrics();
    }, this.config.reportInterval);
  }

  /**
   * 上报性能数据
   */
  private async reportMetrics(): Promise<void> {
    if (!this.config.reportUrl || this.metrics.length === 0) return;

    try {
      await fetch(this.config.reportUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          metrics: this.metrics,
          userAgent: navigator.userAgent,
          timestamp: Date.now(),
        }),
      });

      // 清空已上报的数据
      this.metrics = [];

      if (this.config.enableConsoleLog) {
        console.log("Performance metrics reported successfully");
      }
    } catch (error) {
      console.warn("Failed to report performance metrics:", error);
    }
  }

  /**
   * 手动记录性能标记
   */
  mark(name: string): void {
    if (window.performance && performance.mark) {
      performance.mark(name);
    }
  }

  /**
   * 测量两个标记之间的时间
   */
  measure(
    name: string,
    startMark: string,
    endMark?: string,
  ): number | undefined {
    if (!window.performance || !performance.measure) return;

    try {
      performance.measure(name, startMark, endMark);
      const measure = performance.getEntriesByName(name, "measure")[0];
      return measure?.duration;
    } catch (error) {
      console.warn(`Failed to measure ${name}:`, error);
    }
  }

  /**
   * 获取性能统计
   */
  getPerformanceStats() {
    if (this.metrics.length === 0) return null;

    const latest = this.metrics[this.metrics.length - 1];
    const average = this.calculateAverageMetrics();

    return {
      latest,
      average,
      count: this.metrics.length,
      timeRange: {
        start: this.metrics[0]?.timestamp,
        end: latest.timestamp,
      },
    };
  }

  /**
   * 计算平均性能指标
   */
  private calculateAverageMetrics(): Partial<PerformanceMetrics> {
    if (this.metrics.length === 0) return {};

    const sum = this.metrics.reduce(
      (acc, metrics) => {
        Object.keys(metrics).forEach((key) => {
          if (typeof metrics[key as keyof PerformanceMetrics] === "number") {
            acc[key] =
              (acc[key] || 0) +
              (metrics[key as keyof PerformanceMetrics] as number);
          }
        });
        return acc;
      },
      {} as Record<string, number>,
    );

    const average: Record<string, number> = {};
    Object.keys(sum).forEach((key) => {
      average[key] = sum[key] / this.metrics.length;
    });

    return average;
  }

  /**
   * 清空性能数据
   */
  clearMetrics(): void {
    this.metrics = [];
  }
}

/**
 * 全局性能监控器实例
 */
export const performanceMonitor = new PerformanceMonitor();

/**
 * 设置性能监控
 */
export function setupPerformanceMonitor(
  app: App,
  config?: Partial<PerformanceConfig>,
): void {
  if (config) {
    Object.assign(performanceMonitor.config, config);
  }

  // 在应用挂载后开始监控
  app.mixin({
    mounted() {
      if (this.$el === document.getElementById("app")) {
        // 等待页面完全加载后开始监控
        setTimeout(() => {
          performanceMonitor.start();
        }, 1000);
      }
    },
  });

  // 在页面卸载时停止监控
  window.addEventListener("beforeunload", () => {
    performanceMonitor.stop();
  });

  console.log("Performance monitor setup completed");
}
