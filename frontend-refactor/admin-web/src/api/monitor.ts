/**
 * 监控管理相关API
 * WeWork Management Platform - Frontend
 */

import request from "@/utils/request";
import type {
  ApiResponse,
  PageResult,
  SystemMetrics,
  ServiceHealth,
  AlertRule,
  AlertRecord,
  PerformanceData,
  LogEntry,
  LogSearchForm,
  MonitorStatistics,
} from "@/types";

/**
 * 监控管理API接口
 */
export const monitorApi = {
  /**
   * 获取系统指标
   */
  getSystemMetrics(): Promise<ApiResponse<SystemMetrics>> {
    return request.get("/monitor/system-metrics");
  },

  /**
   * 获取历史系统指标
   */
  getHistoricalSystemMetrics(params: {
    startTime: string;
    endTime: string;
    interval?: string;
  }): Promise<ApiResponse<SystemMetrics[]>> {
    return request.get("/monitor/system-metrics/history", { params });
  },

  /**
   * 获取服务健康状态
   */
  getServiceHealth(): Promise<ApiResponse<ServiceHealth[]>> {
    return request.get("/monitor/service-health");
  },

  /**
   * 获取单个服务健康状态
   */
  getServiceHealthById(
    serviceName: string,
  ): Promise<ApiResponse<ServiceHealth>> {
    return request.get(`/monitor/service-health/${serviceName}`);
  },

  /**
   * 刷新服务健康状态
   */
  refreshServiceHealth(serviceName?: string): Promise<ApiResponse<void>> {
    return request.post("/monitor/service-health/refresh", { serviceName });
  },

  /**
   * 获取告警规则列表
   */
  getAlertRules(params?: {
    ruleName?: string;
    enabled?: boolean;
    severity?: string;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<AlertRule>>> {
    return request.get("/monitor/alert-rules", { params });
  },

  /**
   * 获取告警规则详情
   */
  getAlertRuleById(id: string): Promise<ApiResponse<AlertRule>> {
    return request.get(`/monitor/alert-rules/${id}`);
  },

  /**
   * 创建告警规则
   */
  createAlertRule(data: any): Promise<ApiResponse<AlertRule>> {
    return request.post("/monitor/alert-rules", data);
  },

  /**
   * 更新告警规则
   */
  updateAlertRule(id: string, data: any): Promise<ApiResponse<AlertRule>> {
    return request.put(`/monitor/alert-rules/${id}`, data);
  },

  /**
   * 删除告警规则
   */
  deleteAlertRule(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/monitor/alert-rules/${id}`);
  },

  /**
   * 启用/禁用告警规则
   */
  toggleAlertRule(id: string, enabled: boolean): Promise<ApiResponse<void>> {
    return request.patch(`/monitor/alert-rules/${id}/toggle`, { enabled });
  },

  /**
   * 测试告警规则
   */
  testAlertRule(id: string): Promise<
    ApiResponse<{
      triggered: boolean;
      message?: string;
      conditions: any[];
    }>
  > {
    return request.post(`/monitor/alert-rules/${id}/test`);
  },

  /**
   * 获取告警记录列表
   */
  getAlertRecords(params?: {
    ruleId?: string;
    severity?: string;
    status?: string;
    startTime?: string;
    endTime?: string;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<AlertRecord>>> {
    return request.get("/monitor/alert-records", { params });
  },

  /**
   * 获取告警记录详情
   */
  getAlertRecordById(id: string): Promise<ApiResponse<AlertRecord>> {
    return request.get(`/monitor/alert-records/${id}`);
  },

  /**
   * 确认告警
   */
  acknowledgeAlert(id: string, reason?: string): Promise<ApiResponse<void>> {
    return request.post(`/monitor/alert-records/${id}/acknowledge`, { reason });
  },

  /**
   * 解决告警
   */
  resolveAlert(
    id: string,
    data?: {
      resolution?: string;
      autoResolve?: boolean;
    },
  ): Promise<ApiResponse<void>> {
    return request.post(`/monitor/alert-records/${id}/resolve`, data);
  },

  /**
   * 批量处理告警
   */
  batchProcessAlerts(
    ids: string[],
    action: "ACKNOWLEDGE" | "RESOLVE",
    data?: any,
  ): Promise<ApiResponse<void>> {
    return request.post("/monitor/alert-records/batch-process", {
      ids,
      action,
      ...data,
    });
  },

  /**
   * 获取性能数据
   */
  getPerformanceData(params?: {
    serviceName?: string;
    startTime?: string;
    endTime?: string;
    interval?: string;
    metrics?: string[];
  }): Promise<ApiResponse<PerformanceData[]>> {
    return request.get("/monitor/performance-data", { params });
  },

  /**
   * 获取实时性能数据
   */
  getRealTimePerformanceData(
    serviceName?: string,
  ): Promise<ApiResponse<PerformanceData>> {
    return request.get("/monitor/performance-data/realtime", {
      params: { serviceName },
    });
  },

  /**
   * 获取日志条目
   */
  getLogEntries(
    params: LogSearchForm,
  ): Promise<ApiResponse<PageResult<LogEntry>>> {
    return request.get("/monitor/logs", { params });
  },

  /**
   * 获取日志统计
   */
  getLogStatistics(params?: {
    startTime?: string;
    endTime?: string;
    serviceName?: string;
  }): Promise<
    ApiResponse<{
      totalCount: number;
      levelDistribution: Record<string, number>;
      serviceDistribution: Record<string, number>;
      timeline: Array<{
        timestamp: string;
        count: number;
      }>;
    }>
  > {
    return request.get("/monitor/logs/statistics", { params });
  },

  /**
   * 导出日志
   */
  exportLogs(
    params: LogSearchForm & {
      format: "CSV" | "JSON" | "TXT";
    },
  ): Promise<ApiResponse<{ downloadUrl: string }>> {
    return request.post("/monitor/logs/export", params);
  },

  /**
   * 获取链路追踪数据
   */
  getTraceData(traceId: string): Promise<ApiResponse<any>> {
    return request.get(`/monitor/traces/${traceId}`);
  },

  /**
   * 搜索链路追踪
   */
  searchTraces(params: {
    serviceName?: string;
    operationName?: string;
    startTime: string;
    endTime: string;
    minDuration?: number;
    maxDuration?: number;
    status?: "SUCCESS" | "ERROR";
    tags?: Record<string, string>;
    limit?: number;
  }): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/traces/search", { params });
  },

  /**
   * 获取监控统计
   */
  getMonitorStatistics(params?: {
    startTime?: string;
    endTime?: string;
  }): Promise<ApiResponse<MonitorStatistics>> {
    return request.get("/monitor/statistics", { params });
  },

  /**
   * 获取监控配置
   */
  getMonitorConfig(): Promise<ApiResponse<any>> {
    return request.get("/monitor/config");
  },

  /**
   * 更新监控配置
   */
  updateMonitorConfig(data: any): Promise<ApiResponse<void>> {
    return request.put("/monitor/config", data);
  },

  /**
   * 获取仪表板列表
   */
  getDashboards(params?: {
    name?: string;
    isPublic?: boolean;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<any>>> {
    return request.get("/monitor/dashboards", { params });
  },

  /**
   * 获取仪表板详情
   */
  getDashboardById(id: string): Promise<ApiResponse<any>> {
    return request.get(`/monitor/dashboards/${id}`);
  },

  /**
   * 创建仪表板
   */
  createDashboard(data: any): Promise<ApiResponse<any>> {
    return request.post("/monitor/dashboards", data);
  },

  /**
   * 更新仪表板
   */
  updateDashboard(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/monitor/dashboards/${id}`, data);
  },

  /**
   * 删除仪表板
   */
  deleteDashboard(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/monitor/dashboards/${id}`);
  },

  /**
   * 复制仪表板
   */
  copyDashboard(id: string, name: string): Promise<ApiResponse<any>> {
    return request.post(`/monitor/dashboards/${id}/copy`, { name });
  },

  /**
   * 获取仪表板数据
   */
  getDashboardData(
    id: string,
    params?: {
      timeRange?: string;
      refreshInterval?: number;
    },
  ): Promise<ApiResponse<any>> {
    return request.get(`/monitor/dashboards/${id}/data`, { params });
  },

  /**
   * 获取指标定义
   */
  getMetricDefinitions(): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/metric-definitions");
  },

  /**
   * 获取指标数据
   */
  getMetricData(params: {
    metric: string;
    startTime: string;
    endTime: string;
    interval?: string;
    filters?: Record<string, string>;
    aggregation?: string;
  }): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/metrics/data", { params });
  },

  /**
   * 获取告警通道配置
   */
  getAlertChannels(): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/alert-channels");
  },

  /**
   * 创建告警通道
   */
  createAlertChannel(data: any): Promise<ApiResponse<any>> {
    return request.post("/monitor/alert-channels", data);
  },

  /**
   * 更新告警通道
   */
  updateAlertChannel(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/monitor/alert-channels/${id}`, data);
  },

  /**
   * 删除告警通道
   */
  deleteAlertChannel(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/monitor/alert-channels/${id}`);
  },

  /**
   * 测试告警通道
   */
  testAlertChannel(
    id: string,
    message?: string,
  ): Promise<
    ApiResponse<{
      success: boolean;
      responseTime?: number;
      errorMessage?: string;
    }>
  > {
    return request.post(`/monitor/alert-channels/${id}/test`, { message });
  },

  /**
   * 获取告警静默规则
   */
  getSilenceRules(): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/silence-rules");
  },

  /**
   * 创建告警静默规则
   */
  createSilenceRule(data: any): Promise<ApiResponse<any>> {
    return request.post("/monitor/silence-rules", data);
  },

  /**
   * 更新告警静默规则
   */
  updateSilenceRule(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/monitor/silence-rules/${id}`, data);
  },

  /**
   * 删除告警静默规则
   */
  deleteSilenceRule(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/monitor/silence-rules/${id}`);
  },

  /**
   * 获取外部集成配置
   */
  getExternalIntegrations(): Promise<ApiResponse<any[]>> {
    return request.get("/monitor/external-integrations");
  },

  /**
   * 创建外部集成
   */
  createExternalIntegration(data: any): Promise<ApiResponse<any>> {
    return request.post("/monitor/external-integrations", data);
  },

  /**
   * 更新外部集成
   */
  updateExternalIntegration(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/monitor/external-integrations/${id}`, data);
  },

  /**
   * 删除外部集成
   */
  deleteExternalIntegration(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/monitor/external-integrations/${id}`);
  },

  /**
   * 测试外部集成连接
   */
  testExternalIntegration(id: string): Promise<
    ApiResponse<{
      success: boolean;
      responseTime?: number;
      errorMessage?: string;
    }>
  > {
    return request.post(`/monitor/external-integrations/${id}/test`);
  },

  /**
   * 同步外部集成数据
   */
  syncExternalIntegration(id: string): Promise<ApiResponse<void>> {
    return request.post(`/monitor/external-integrations/${id}/sync`);
  },

  /**
   * 获取系统状态页面
   */
  getStatusPage(): Promise<
    ApiResponse<{
      overallStatus: "OPERATIONAL" | "DEGRADED" | "MAJOR_OUTAGE";
      services: Array<{
        name: string;
        status: "OPERATIONAL" | "DEGRADED" | "MAJOR_OUTAGE";
        description?: string;
      }>;
      incidents: Array<{
        title: string;
        status: "INVESTIGATING" | "IDENTIFIED" | "MONITORING" | "RESOLVED";
        updates: Array<{
          timestamp: string;
          message: string;
        }>;
      }>;
      uptime: {
        overall: number;
        services: Record<string, number>;
      };
    }>
  > {
    return request.get("/monitor/status-page");
  },

  /**
   * 获取监控事件
   */
  getMonitorEvents(params?: {
    type?: string;
    severity?: string;
    startTime?: string;
    endTime?: string;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<any>>> {
    return request.get("/monitor/events", { params });
  },

  /**
   * 创建监控事件
   */
  createMonitorEvent(data: any): Promise<ApiResponse<any>> {
    return request.post("/monitor/events", data);
  },

  /**
   * 更新监控事件
   */
  updateMonitorEvent(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/monitor/events/${id}`, data);
  },
};
