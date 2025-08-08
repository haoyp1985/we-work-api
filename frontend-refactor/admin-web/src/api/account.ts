/**
 * 账号管理相关API
 * WeWork Management Platform - Frontend
 */

import request from "@/utils/request";
import type {
  ApiResponse,
  PageResult,
  WeWorkAccount,
  AccountSearchForm,
  AccountCreateForm,
  AccountUpdateForm,
  AccountTotalStatistics,
  AccountOperationLog,
  BatchOperationResult,
  AccountGroup,
} from "@/types";

/**
 * 账号管理API接口
 */
export const accountApi = {
  /**
   * 获取账号列表
   */
  getAccountList(
    params: AccountSearchForm,
  ): Promise<ApiResponse<PageResult<WeWorkAccount>>> {
    return request.get("/accounts", params);
  },
  /**
   * 获取状态日志（分页）
   */
  getStatusLogs(params: {
    accountId?: string;
    fromStatus?: number;
    toStatus?: number;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<any>>> {
    return request.get("/status-logs", params);
  },
  /**
   * 获取某账号最近状态日志
   */
  getStatusLogsByAccountId(accountId: string, limit = 50): Promise<ApiResponse<any[]>> {
    return request.get(`/status-logs/account/${accountId}`, { limit });
  },
  /** 状态变更统计 */
  getStatusChangeStatistics(params: { accountId?: string; startTime?: number; endTime?: number }): Promise<ApiResponse<any>> {
    return request.get("/status-logs/statistics", params);
  },
  /** 状态趋势 */
  getStatusTrends(params: { accountId?: string; startTime: number; endTime: number; interval?: string }): Promise<ApiResponse<any[]>> {
    return request.get("/status-logs/trends", params);
  },

  /**
   * 获取账号详情
   */
  getAccountById(id: string): Promise<ApiResponse<WeWorkAccount>> {
    return request.get(`/accounts/${id}`);
  },

  /**
   * 创建账号
   */
  createAccount(data: AccountCreateForm): Promise<ApiResponse<WeWorkAccount>> {
    return request.post("/accounts", data);
  },

  /**
   * 更新账号
   */
  updateAccount(
    id: string,
    data: AccountUpdateForm,
  ): Promise<ApiResponse<WeWorkAccount>> {
    return request.put(`/accounts/${id}`, data);
  },

  /**
   * 删除账号
   */
  deleteAccount(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/accounts/${id}`);
  },

  /**
   * 批量删除账号
   */
  batchDeleteAccounts(ids: string[]): Promise<ApiResponse<void>> {
    return request.delete("/accounts/batch", { data: { ids } });
  },

  /**
   * 更新账号状态
   */
  updateAccountStatus(id: string, status: string): Promise<ApiResponse<void>> {
    return request.patch(`/accounts/${id}/status`, { status });
  },

  /**
   * 批量更新账号状态
   */
  batchUpdateAccountStatus(
    ids: string[],
    status: string,
  ): Promise<ApiResponse<BatchOperationResult>> {
    return request.patch("/accounts/batch/status", { ids, status });
  },

  /**
   * 刷新账号状态
   */
  refreshAccountStatus(id: string): Promise<ApiResponse<WeWorkAccount>> {
    return request.post(`/accounts/${id}/refresh-status`);
  },

  /**
   * 批量刷新账号状态
   */
  batchRefreshAccountStatus(
    ids: string[],
  ): Promise<ApiResponse<BatchOperationResult>> {
    return request.post("/accounts/batch/refresh-status", { ids });
  },

  /**
   * 重启账号
   */
  restartAccount(id: string): Promise<ApiResponse<void>> {
    return request.post(`/accounts/${id}/restart`);
  },

  /**
   * 批量重启账号
   */
  batchRestartAccounts(
    ids: string[],
  ): Promise<ApiResponse<BatchOperationResult>> {
    return request.post("/accounts/batch/restart", { ids });
  },

  /**
   * 登录账号
   */
  loginAccount(
    id: string,
  ): Promise<ApiResponse<{ qrCode?: string; status: string }>> {
    return request.post(`/accounts/${id}/login`);
  },

  /**
   * 登出账号
   */
  logoutAccount(id: string): Promise<ApiResponse<void>> {
    return request.post(`/accounts/${id}/logout`);
  },

  /**
   * 获取账号二维码
   */
  getAccountQrCode(
    id: string,
  ): Promise<ApiResponse<{ qrCode: string; expiresAt: string }>> {
    return request.get(`/accounts/${id}/qr-code`);
  },

  /**
   * 获取账号统计信息
   */
  getAccountStatistics(): Promise<ApiResponse<AccountTotalStatistics>> {
    return request.get("/accounts/statistics");
  },

  /**
   * 批量心跳检测（对当前租户在线账号批量执行心跳）
   */
  batchHeartbeat(): Promise<ApiResponse<string[]>> {
    return request.post("/accounts/batch-heartbeat");
  },

  /**
   * 自动恢复异常账号
   */
  autoRecoverErrorAccounts(): Promise<ApiResponse<string[]>> {
    return request.post("/accounts/auto-recover");
  },

  /**
   * 获取单个账号统计
   */
  getAccountStatisticsById(
    id: string,
    params?: {
      startDate?: string;
      endDate?: string;
    },
  ): Promise<ApiResponse<any>> {
    return request.get(`/accounts/${id}/statistics`, { params });
  },

  /**
   * 获取账号操作日志
   */
  getAccountOperationLogs(params?: {
    accountId?: string;
    operationType?: string;
    startDate?: string;
    endDate?: string;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<AccountOperationLog>>> {
    return request.get("/accounts/operation-logs", { params });
  },

  /**
   * 更新账号配置
   */
  updateAccountConfig(
    id: string,
    config: any,
  ): Promise<ApiResponse<WeWorkAccount>> {
    return request.put(`/accounts/${id}/config`, config);
  },

  /**
   * 批量更新账号配置
   */
  batchUpdateAccountConfig(
    ids: string[],
    config: any,
  ): Promise<ApiResponse<BatchOperationResult>> {
    return request.put("/accounts/batch/config", { ids, config });
  },

  /**
   * 测试账号连接
   */
  testAccountConnection(id: string): Promise<
    ApiResponse<{
      connected: boolean;
      responseTime: number;
      errorMessage?: string;
    }>
  > {
    return request.post(`/accounts/${id}/test-connection`);
  },

  /**
   * 账号健康检查
   */
  checkAccountHealth(id: string): Promise<ApiResponse<any>> {
    return request.get(`/accounts/${id}/health`);
  },

  /**
   * 批量健康检查
   */
  batchCheckAccountHealth(ids: string[]): Promise<ApiResponse<any[]>> {
    return request.post("/accounts/batch/health-check", { ids });
  },

  /**
   * 导入账号
   */
  importAccounts(
    file: File,
    options?: {
      duplicateStrategy?: "SKIP" | "UPDATE" | "ERROR";
      templateType?: "STANDARD" | "CUSTOM";
    },
  ): Promise<ApiResponse<any>> {
    const formData = new FormData();
    formData.append("file", file);
    if (options) {
      Object.entries(options).forEach(([key, value]) => {
        formData.append(key, value);
      });
    }
    return request.post("/accounts/import", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  },

  /**
   * 导出账号
   */
  exportAccounts(params?: {
    format?: "EXCEL" | "CSV" | "JSON";
    fields?: string[];
    filters?: any;
  }): Promise<ApiResponse<{ downloadUrl: string }>> {
    return request.post("/accounts/export", params);
  },

  /**
   * 获取导入模板
   */
  getImportTemplate(
    templateType: "STANDARD" | "CUSTOM",
  ): Promise<ApiResponse<{ downloadUrl: string }>> {
    return request.get("/accounts/import-template", {
      params: { templateType },
    });
  },

  /**
   * 获取账号分组列表
   */
  getAccountGroups(params?: {
    groupName?: string;
    pageNum?: number;
    pageSize?: number;
  }): Promise<ApiResponse<PageResult<AccountGroup>>> {
    return request.get("/account-groups", { params });
  },

  /**
   * 创建账号分组
   */
  createAccountGroup(data: any): Promise<ApiResponse<AccountGroup>> {
    return request.post("/account-groups", data);
  },

  /**
   * 更新账号分组
   */
  updateAccountGroup(
    id: string,
    data: any,
  ): Promise<ApiResponse<AccountGroup>> {
    return request.put(`/account-groups/${id}`, data);
  },

  /**
   * 删除账号分组
   */
  deleteAccountGroup(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/account-groups/${id}`);
  },

  /**
   * 添加账号到分组
   */
  addAccountsToGroup(
    groupId: string,
    accountIds: string[],
  ): Promise<ApiResponse<void>> {
    return request.post(`/account-groups/${groupId}/accounts`, { accountIds });
  },

  /**
   * 从分组移除账号
   */
  removeAccountsFromGroup(
    groupId: string,
    accountIds: string[],
  ): Promise<ApiResponse<void>> {
    return request.delete(`/account-groups/${groupId}/accounts`, {
      data: { accountIds },
    });
  },

  /**
   * 获取账号标签
   */
  getAccountTags(): Promise<ApiResponse<any[]>> {
    return request.get("/account-tags");
  },

  /**
   * 创建账号标签
   */
  createAccountTag(data: {
    tagName: string;
    tagColor: string;
    description?: string;
  }): Promise<ApiResponse<any>> {
    return request.post("/account-tags", data);
  },

  /**
   * 更新账号标签
   */
  updateAccountTag(id: string, data: any): Promise<ApiResponse<any>> {
    return request.put(`/account-tags/${id}`, data);
  },

  /**
   * 删除账号标签
   */
  deleteAccountTag(id: string): Promise<ApiResponse<void>> {
    return request.delete(`/account-tags/${id}`);
  },

  /**
   * 为账号添加标签
   */
  addTagsToAccount(
    accountId: string,
    tagIds: string[],
  ): Promise<ApiResponse<void>> {
    return request.post(`/accounts/${accountId}/tags`, { tagIds });
  },

  /**
   * 从账号移除标签
   */
  removeTagsFromAccount(
    accountId: string,
    tagIds: string[],
  ): Promise<ApiResponse<void>> {
    return request.delete(`/accounts/${accountId}/tags`, { data: { tagIds } });
  },

  /**
   * 获取账号性能指标
   */
  getAccountPerformanceMetrics(
    id: string,
    params?: {
      startDate?: string;
      endDate?: string;
      interval?: string;
    },
  ): Promise<ApiResponse<any[]>> {
    return request.get(`/accounts/${id}/performance-metrics`, { params });
  },

  /**
   * 获取在线账号列表
   */
  getOnlineAccounts(): Promise<ApiResponse<WeWorkAccount[]>> {
    return request.get("/accounts/online");
  },

  /**
   * 获取离线账号列表
   */
  getOfflineAccounts(): Promise<ApiResponse<WeWorkAccount[]>> {
    return request.get("/accounts/offline");
  },

  /**
   * 获取异常账号列表
   */
  getErrorAccounts(): Promise<ApiResponse<WeWorkAccount[]>> {
    return request.get("/accounts/error");
  },

  /**
   * 重置账号错误状态
   */
  resetAccountError(id: string): Promise<ApiResponse<void>> {
    return request.post(`/accounts/${id}/reset-error`);
  },

  /**
   * 克隆账号配置
   */
  cloneAccountConfig(
    sourceId: string,
    targetIds: string[],
  ): Promise<ApiResponse<BatchOperationResult>> {
    return request.post(`/accounts/${sourceId}/clone-config`, { targetIds });
  },

  /**
   * 获取账号备份
   */
  backupAccount(id: string): Promise<ApiResponse<{ backupUrl: string }>> {
    return request.post(`/accounts/${id}/backup`);
  },

  /**
   * 恢复账号
   */
  restoreAccount(id: string, backupFile: File): Promise<ApiResponse<void>> {
    const formData = new FormData();
    formData.append("backup", backupFile);
    return request.post(`/accounts/${id}/restore`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  },
};
