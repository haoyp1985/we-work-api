/**
 * 监控状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { monitorApi } from "@/api/monitor";
import type {
  SystemMetrics,
  ServiceHealth,
  AlertRule,
  AlertRecord,
  PerformanceData,
  LogEntry,
  MonitorStatistics,
} from "@/types/monitor";

export const useMonitorStore = defineStore("monitor", () => {
  // ===== State =====
  const systemMetrics = ref<SystemMetrics>({
    cpu: { usage: 0, cores: 0 },
    memory: { usage: 0, total: 0, used: 0, available: 0 },
    disk: { usage: 0, total: 0, used: 0, available: 0 },
    network: { inbound: 0, outbound: 0 },
    timestamp: Date.now(),
  });

  const serviceHealthList = ref<ServiceHealth[]>([]);
  const alertRules = ref<AlertRule[]>([]);
  const alertRecords = ref<AlertRecord[]>([]);
  const performanceData = ref<PerformanceData[]>([]);
  const logEntries = ref<LogEntry[]>([]);

  const loading = ref<boolean>(false);
  const realTimeEnabled = ref<boolean>(false);
  const autoRefreshInterval = ref<number>(30000); // 30秒

  // 统计信息
  const statistics = ref<MonitorStatistics>({
    totalServices: 0,
    healthyServices: 0,
    unhealthyServices: 0,
    totalAlerts: 0,
    activeAlerts: 0,
    resolvedAlerts: 0,
    avgResponseTime: 0,
    systemUptime: 0,
  });

  // 实时数据定时器
  let refreshTimer: NodeJS.Timeout | null = null;

  // ===== Getters =====
  const healthyServices = computed(() =>
    serviceHealthList.value.filter((service) => service.status === "UP"),
  );

  const unhealthyServices = computed(() =>
    serviceHealthList.value.filter((service) => service.status === "DOWN"),
  );

  const activeAlerts = computed(() =>
    alertRecords.value.filter((alert) => alert.status === "ACTIVE"),
  );

  const resolvedAlerts = computed(() =>
    alertRecords.value.filter((alert) => alert.status === "RESOLVED"),
  );

  const criticalAlerts = computed(() =>
    alertRecords.value.filter(
      (alert) => alert.severity === "CRITICAL" && alert.status === "ACTIVE",
    ),
  );

  const serviceStatusDistribution = computed(() => {
    const distribution = { UP: 0, DOWN: 0, UNKNOWN: 0 };
    serviceHealthList.value.forEach((service) => {
      distribution[service.status] = (distribution[service.status] || 0) + 1;
    });
    return distribution;
  });

  const alertSeverityDistribution = computed(() => {
    const distribution = { CRITICAL: 0, WARNING: 0, INFO: 0 };
    activeAlerts.value.forEach((alert) => {
      distribution[alert.severity] = (distribution[alert.severity] || 0) + 1;
    });
    return distribution;
  });

  // ===== Actions =====

  /**
   * 获取系统指标
   */
  const fetchSystemMetrics = async (): Promise<SystemMetrics> => {
    try {
      const response = await monitorApi.getSystemMetrics();

      if (response.code === 200) {
        systemMetrics.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取系统指标失败");
      }
    } catch (error) {
      console.error("获取系统指标失败:", error);
      throw error;
    }
  };

  /**
   * 获取服务健康状态
   */
  const fetchServiceHealth = async (): Promise<ServiceHealth[]> => {
    try {
      const response = await monitorApi.getServiceHealth();

      if (response.code === 200) {
        serviceHealthList.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取服务健康状态失败");
      }
    } catch (error) {
      console.error("获取服务健康状态失败:", error);
      throw error;
    }
  };

  /**
   * 获取告警规则
   */
  const fetchAlertRules = async (): Promise<AlertRule[]> => {
    loading.value = true;
    try {
      const response = await monitorApi.getAlertRules();

      if (response.code === 200) {
        alertRules.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取告警规则失败");
      }
    } catch (error) {
      console.error("获取告警规则失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 获取告警记录
   */
  const fetchAlertRecords = async (params?: any): Promise<AlertRecord[]> => {
    loading.value = true;
    try {
      const response = await monitorApi.getAlertRecords(params);

      if (response.code === 200) {
        alertRecords.value = response.data.records;
        return response.data.records;
      } else {
        throw new Error(response.message || "获取告警记录失败");
      }
    } catch (error) {
      console.error("获取告警记录失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 获取性能数据
   */
  const fetchPerformanceData = async (
    params?: any,
  ): Promise<PerformanceData[]> => {
    try {
      const response = await monitorApi.getPerformanceData(params);

      if (response.code === 200) {
        performanceData.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取性能数据失败");
      }
    } catch (error) {
      console.error("获取性能数据失败:", error);
      throw error;
    }
  };

  /**
   * 获取日志条目
   */
  const fetchLogEntries = async (params?: any): Promise<LogEntry[]> => {
    loading.value = true;
    try {
      const response = await monitorApi.getLogEntries(params);

      if (response.code === 200) {
        logEntries.value = response.data.records;
        return response.data.records;
      } else {
        throw new Error(response.message || "获取日志失败");
      }
    } catch (error) {
      console.error("获取日志失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 创建告警规则
   */
  const createAlertRule = async (ruleData: any): Promise<AlertRule> => {
    try {
      const response = await monitorApi.createAlertRule(ruleData);

      if (response.code === 200) {
        alertRules.value.unshift(response.data);
        return response.data;
      } else {
        throw new Error(response.message || "创建告警规则失败");
      }
    } catch (error) {
      console.error("创建告警规则失败:", error);
      throw error;
    }
  };

  /**
   * 更新告警规则
   */
  const updateAlertRule = async (
    id: string,
    ruleData: any,
  ): Promise<AlertRule> => {
    try {
      const response = await monitorApi.updateAlertRule(id, ruleData);

      if (response.code === 200) {
        const index = alertRules.value.findIndex((rule) => rule.id === id);
        if (index !== -1) {
          alertRules.value[index] = {
            ...alertRules.value[index],
            ...response.data,
          };
        }
        return response.data;
      } else {
        throw new Error(response.message || "更新告警规则失败");
      }
    } catch (error) {
      console.error("更新告警规则失败:", error);
      throw error;
    }
  };

  /**
   * 删除告警规则
   */
  const deleteAlertRule = async (id: string): Promise<void> => {
    try {
      const response = await monitorApi.deleteAlertRule(id);

      if (response.code === 200) {
        const index = alertRules.value.findIndex((rule) => rule.id === id);
        if (index !== -1) {
          alertRules.value.splice(index, 1);
        }
      } else {
        throw new Error(response.message || "删除告警规则失败");
      }
    } catch (error) {
      console.error("删除告警规则失败:", error);
      throw error;
    }
  };

  /**
   * 确认告警
   */
  const acknowledgeAlert = async (id: string): Promise<void> => {
    try {
      const response = await monitorApi.acknowledgeAlert(id);

      if (response.code === 200) {
        const index = alertRecords.value.findIndex((alert) => alert.id === id);
        if (index !== -1) {
          alertRecords.value[index].status = "ACKNOWLEDGED";
          alertRecords.value[index].acknowledgedAt = new Date().toISOString();
        }
      } else {
        throw new Error(response.message || "确认告警失败");
      }
    } catch (error) {
      console.error("确认告警失败:", error);
      throw error;
    }
  };

  /**
   * 解决告警
   */
  const resolveAlert = async (
    id: string,
    resolution?: string,
  ): Promise<void> => {
    try {
      const response = await monitorApi.resolveAlert(id, { resolution });

      if (response.code === 200) {
        const index = alertRecords.value.findIndex((alert) => alert.id === id);
        if (index !== -1) {
          alertRecords.value[index].status = "RESOLVED";
          alertRecords.value[index].resolvedAt = new Date().toISOString();
          alertRecords.value[index].resolution = resolution;
        }
      } else {
        throw new Error(response.message || "解决告警失败");
      }
    } catch (error) {
      console.error("解决告警失败:", error);
      throw error;
    }
  };

  /**
   * 获取监控统计
   */
  const fetchMonitorStatistics = async (): Promise<MonitorStatistics> => {
    try {
      const response = await monitorApi.getMonitorStatistics();

      if (response.code === 200) {
        statistics.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取监控统计失败");
      }
    } catch (error) {
      console.error("获取监控统计失败:", error);
      throw error;
    }
  };

  /**
   * 启动实时监控
   */
  const startRealTimeMonitoring = (): void => {
    if (realTimeEnabled.value || refreshTimer) {
      return;
    }

    realTimeEnabled.value = true;

    const refresh = async () => {
      try {
        await Promise.all([
          fetchSystemMetrics(),
          fetchServiceHealth(),
          fetchAlertRecords({ limit: 50 }),
        ]);
      } catch (error) {
        console.error("实时监控数据刷新失败:", error);
      }
    };

    // 立即执行一次
    refresh();

    // 设置定时刷新
    refreshTimer = setInterval(refresh, autoRefreshInterval.value);
  };

  /**
   * 停止实时监控
   */
  const stopRealTimeMonitoring = (): void => {
    realTimeEnabled.value = false;

    if (refreshTimer) {
      clearInterval(refreshTimer);
      refreshTimer = null;
    }
  };

  /**
   * 设置自动刷新间隔
   */
  const setAutoRefreshInterval = (interval: number): void => {
    autoRefreshInterval.value = interval;

    // 如果正在实时监控，重新启动以应用新的间隔
    if (realTimeEnabled.value) {
      stopRealTimeMonitoring();
      startRealTimeMonitoring();
    }
  };

  /**
   * 清空数据
   */
  const clearData = (): void => {
    systemMetrics.value = {
      cpu: { usage: 0, cores: 0 },
      memory: { usage: 0, total: 0, used: 0, available: 0 },
      disk: { usage: 0, total: 0, used: 0, available: 0 },
      network: { inbound: 0, outbound: 0 },
      timestamp: Date.now(),
    };
    serviceHealthList.value = [];
    alertRules.value = [];
    alertRecords.value = [];
    performanceData.value = [];
    logEntries.value = [];

    // 停止实时监控
    stopRealTimeMonitoring();
  };

  // 组件卸载时清理定时器
  const cleanup = (): void => {
    stopRealTimeMonitoring();
  };

  return {
    // State
    systemMetrics,
    serviceHealthList,
    alertRules,
    alertRecords,
    performanceData,
    logEntries,
    loading,
    realTimeEnabled,
    autoRefreshInterval,
    statistics,

    // Getters
    healthyServices,
    unhealthyServices,
    activeAlerts,
    resolvedAlerts,
    criticalAlerts,
    serviceStatusDistribution,
    alertSeverityDistribution,

    // Actions
    fetchSystemMetrics,
    fetchServiceHealth,
    fetchAlertRules,
    fetchAlertRecords,
    fetchPerformanceData,
    fetchLogEntries,
    createAlertRule,
    updateAlertRule,
    deleteAlertRule,
    acknowledgeAlert,
    resolveAlert,
    fetchMonitorStatistics,
    startRealTimeMonitoring,
    stopRealTimeMonitoring,
    setAutoRefreshInterval,
    clearData,
    cleanup,
  };
});
