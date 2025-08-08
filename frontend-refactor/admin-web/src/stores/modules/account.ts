/**
 * 账号状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { accountApi } from "@/api/account";
import type {
  WeWorkAccount,
  AccountSearchForm,
  AccountCreateForm,
  AccountUpdateForm,
  AccountTotalStatistics,
  PageResult,
} from "@/types/account";

export const useAccountStore = defineStore("account", () => {
  // ===== State =====
  const accountList = ref<WeWorkAccount[]>([]);
  const currentAccount = ref<WeWorkAccount | null>(null);
  const loading = ref<boolean>(false);
  const searchLoading = ref<boolean>(false);

  // 分页信息
  const pagination = ref({
    total: 0,
    pageNum: 1,
    pageSize: 20,
    pages: 0,
  });

  // 统计信息
  const statistics = ref<AccountTotalStatistics>({
    totalCount: 0,
    onlineCount: 0,
    offlineCount: 0,
    errorCount: 0,
    statusDistribution: {},
    dailyStats: [],
    typeDistribution: {},
    performanceStats: {
      avgOnlineTime: 0,
      avgMessageSent: 0,
      successRate: 0,
      errorRate: 0,
    },
  });

  // 搜索条件
  const searchForm = ref<AccountSearchForm>({
    accountName: "",
    status: undefined,
    pageNum: 1,
    pageSize: 20,
  });

  // ===== Getters =====
  const onlineAccounts = computed(() =>
    accountList.value.filter((account) => account.status === "ONLINE"),
  );

  const offlineAccounts = computed(() =>
    accountList.value.filter((account) => account.status === "OFFLINE"),
  );

  const errorAccounts = computed(() =>
    accountList.value.filter((account) => account.status === "ERROR"),
  );

  const statusDistribution = computed(() => {
    const distribution = {
      ONLINE: 0,
      OFFLINE: 0,
      ERROR: 0,
      INITIALIZING: 0,
      WAITING_QR: 0,
      WAITING_CONFIRM: 0,
      VERIFYING: 0,
      RECOVERING: 0,
    };

    accountList.value.forEach((account) => {
      if (distribution.hasOwnProperty(account.status)) {
        distribution[account.status as keyof typeof distribution]++;
      }
    });

    return distribution;
  });

  const accountOptions = computed(() =>
    accountList.value.map((account) => ({
      label: account.accountName,
      value: account.id,
    })),
  );

  // ===== Actions =====

  /**
   * 获取账号列表
   */
  const fetchAccountList = async (
    params?: Partial<AccountSearchForm>,
  ): Promise<PageResult<WeWorkAccount>> => {
    loading.value = true;
    try {
      const queryParams = { ...searchForm.value, ...params };
      const response = await accountApi.getAccountList(queryParams);

      if (response.code === 200) {
        accountList.value = response.data.records;
        pagination.value = {
          total: response.data.total,
          pageNum: response.data.pageNum,
          pageSize: response.data.pageSize,
          pages: response.data.pages,
        };
        return response.data;
      } else {
        throw new Error(response.message || "获取账号列表失败");
      }
    } catch (error) {
      console.error("获取账号列表失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 搜索账号
   */
  const searchAccounts = async (
    searchParams: Partial<AccountSearchForm>,
  ): Promise<void> => {
    searchLoading.value = true;
    try {
      searchForm.value = { ...searchForm.value, ...searchParams, pageNum: 1 };
      await fetchAccountList(searchForm.value);
    } catch (error) {
      console.error("搜索账号失败:", error);
      throw error;
    } finally {
      searchLoading.value = false;
    }
  };

  /**
   * 重置搜索条件
   */
  const resetSearch = async (): Promise<void> => {
    searchForm.value = {
      accountName: "",
      status: undefined,
      pageNum: 1,
      pageSize: 20,
    };
    await fetchAccountList();
  };

  /**
   * 获取账号详情
   */
  const fetchAccountById = async (id: string): Promise<WeWorkAccount> => {
    try {
      const response = await accountApi.getAccountById(id);

      if (response.code === 200) {
        currentAccount.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取账号详情失败");
      }
    } catch (error) {
      console.error("获取账号详情失败:", error);
      throw error;
    }
  };

  /**
   * 创建账号
   */
  const createAccount = async (
    accountData: AccountCreateForm,
  ): Promise<WeWorkAccount> => {
    try {
      const response = await accountApi.createAccount(accountData);

      if (response.code === 200) {
        // 刷新列表
        await fetchAccountList();
        return response.data;
      } else {
        throw new Error(response.message || "创建账号失败");
      }
    } catch (error) {
      console.error("创建账号失败:", error);
      throw error;
    }
  };

  /**
   * 更新账号
   */
  const updateAccount = async (
    id: string,
    accountData: AccountUpdateForm,
  ): Promise<WeWorkAccount> => {
    try {
      const response = await accountApi.updateAccount(id, accountData);

      if (response.code === 200) {
        // 更新本地数据
        const index = accountList.value.findIndex(
          (account) => account.id === id,
        );
        if (index !== -1) {
          accountList.value[index] = {
            ...accountList.value[index],
            ...response.data,
          };
        }

        // 如果是当前账号，也更新currentAccount
        if (currentAccount.value && currentAccount.value.id === id) {
          currentAccount.value = { ...currentAccount.value, ...response.data };
        }

        return response.data;
      } else {
        throw new Error(response.message || "更新账号失败");
      }
    } catch (error) {
      console.error("更新账号失败:", error);
      throw error;
    }
  };

  /**
   * 删除账号
   */
  const deleteAccount = async (id: string): Promise<void> => {
    try {
      const response = await accountApi.deleteAccount(id);

      if (response.code === 200) {
        // 从本地列表中移除
        const index = accountList.value.findIndex(
          (account) => account.id === id,
        );
        if (index !== -1) {
          accountList.value.splice(index, 1);
          pagination.value.total -= 1;
        }

        // 如果删除的是当前账号，清空currentAccount
        if (currentAccount.value && currentAccount.value.id === id) {
          currentAccount.value = null;
        }
      } else {
        throw new Error(response.message || "删除账号失败");
      }
    } catch (error) {
      console.error("删除账号失败:", error);
      throw error;
    }
  };

  /**
   * 批量删除账号
   */
  const batchDeleteAccounts = async (ids: string[]): Promise<void> => {
    try {
      const response = await accountApi.batchDeleteAccounts(ids);

      if (response.code === 200) {
        // 从本地列表中移除
        accountList.value = accountList.value.filter(
          (account) => !ids.includes(account.id),
        );
        pagination.value.total -= ids.length;

        // 如果当前账号被删除，清空
        if (currentAccount.value && ids.includes(currentAccount.value.id)) {
          currentAccount.value = null;
        }
      } else {
        throw new Error(response.message || "批量删除账号失败");
      }
    } catch (error) {
      console.error("批量删除账号失败:", error);
      throw error;
    }
  };

  /**
   * 更新账号状态
   */
  const updateAccountStatus = async (
    id: string,
    status: string,
  ): Promise<void> => {
    try {
      const response = await accountApi.updateAccountStatus(id, status);

      if (response.code === 200) {
        // 更新本地数据中的状态
        const index = accountList.value.findIndex(
          (account) => account.id === id,
        );
        if (index !== -1) {
          accountList.value[index].status = status;
          accountList.value[index].updatedAt = new Date().toISOString();
        }

        // 更新当前账号状态
        if (currentAccount.value && currentAccount.value.id === id) {
          currentAccount.value.status = status;
          currentAccount.value.updatedAt = new Date().toISOString();
        }
      } else {
        throw new Error(response.message || "更新账号状态失败");
      }
    } catch (error) {
      console.error("更新账号状态失败:", error);
      throw error;
    }
  };

  /**
   * 刷新账号状态
   */
  const refreshAccountStatus = async (id: string): Promise<WeWorkAccount> => {
    try {
      const response = await accountApi.refreshAccountStatus(id);

      if (response.code === 200) {
        // 更新本地数据
        const index = accountList.value.findIndex(
          (account) => account.id === id,
        );
        if (index !== -1) {
          accountList.value[index] = response.data;
        }

        // 更新当前账号
        if (currentAccount.value && currentAccount.value.id === id) {
          currentAccount.value = response.data;
        }

        return response.data;
      } else {
        throw new Error(response.message || "刷新账号状态失败");
      }
    } catch (error) {
      console.error("刷新账号状态失败:", error);
      throw error;
    }
  };

  /**
   * 获取账号统计信息
   */
  const fetchAccountStatistics = async (): Promise<AccountTotalStatistics> => {
    try {
      const response = await accountApi.getAccountStatistics();

      if (response.code === 200) {
        statistics.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取账号统计失败");
      }
    } catch (error) {
      console.error("获取账号统计失败:", error);
      throw error;
    }
  };

  /**
   * 清空账号列表
   */
  const clearAccountList = (): void => {
    accountList.value = [];
    pagination.value = { total: 0, pageNum: 1, pageSize: 20, pages: 0 };
  };

  /**
   * 设置当前账号
   */
  const setCurrentAccount = (account: WeWorkAccount | null): void => {
    currentAccount.value = account;
  };

  /**
   * 分页切换
   */
  const changePage = async (pageNum: number): Promise<void> => {
    searchForm.value.pageNum = pageNum;
    await fetchAccountList(searchForm.value);
  };

  /**
   * 页面大小切换
   */
  const changePageSize = async (pageSize: number): Promise<void> => {
    searchForm.value.pageSize = pageSize;
    searchForm.value.pageNum = 1;
    await fetchAccountList(searchForm.value);
  };

  return {
    // State
    accountList,
    currentAccount,
    loading,
    searchLoading,
    pagination,
    statistics,
    searchForm,

    // Getters
    onlineAccounts,
    offlineAccounts,
    errorAccounts,
    statusDistribution,
    accountOptions,

    // Actions
    fetchAccountList,
    searchAccounts,
    resetSearch,
    fetchAccountById,
    createAccount,
    updateAccount,
    deleteAccount,
    batchDeleteAccounts,
    updateAccountStatus,
    refreshAccountStatus,
    fetchAccountStatistics,
    clearAccountList,
    setCurrentAccount,
    changePage,
    changePageSize,
  };
});
