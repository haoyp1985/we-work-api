/**
 * 消息状态管理模块
 * WeWork Management Platform - Frontend
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { messageApi } from "@/api/message";
import type {
  Message,
  MessageTemplate,
  MessageBatch,
  MessageSearchForm,
  MessageSendForm,
  MessageStatistics,
  PageResult,
} from "@/types/message";

export const useMessageStore = defineStore("message", () => {
  // ===== State =====
  const messageList = ref<Message[]>([]);
  const templateList = ref<MessageTemplate[]>([]);
  const batchList = ref<MessageBatch[]>([]);
  const currentMessage = ref<Message | null>(null);
  const currentTemplate = ref<MessageTemplate | null>(null);
  const loading = ref<boolean>(false);
  const sendLoading = ref<boolean>(false);

  // 分页信息
  const messagePagination = ref({
    total: 0,
    pageNum: 1,
    pageSize: 20,
    pages: 0,
  });

  const templatePagination = ref({
    total: 0,
    pageNum: 1,
    pageSize: 20,
    pages: 0,
  });

  // 统计信息
  const statistics = ref<MessageStatistics>({
    totalCount: 0,
    sentCount: 0,
    failedCount: 0,
    pendingCount: 0,
    todayCount: 0,
    successRate: 0,
    dailyStats: [],
  });

  // 搜索条件
  const searchForm = ref<MessageSearchForm>({
    content: "",
    status: "",
    accountId: "",
    startDate: "",
    endDate: "",
    pageNum: 1,
    pageSize: 20,
  });

  // ===== Getters =====
  const sentMessages = computed(() =>
    messageList.value.filter((message) => message.status === "SENT"),
  );

  const failedMessages = computed(() =>
    messageList.value.filter((message) => message.status === "FAILED"),
  );

  const pendingMessages = computed(() =>
    messageList.value.filter((message) => message.status === "PENDING"),
  );

  const statusDistribution = computed(() => {
    const distribution = {
      SENT: 0,
      FAILED: 0,
      PENDING: 0,
      SENDING: 0,
    };

    messageList.value.forEach((message) => {
      if (distribution.hasOwnProperty(message.status)) {
        distribution[message.status as keyof typeof distribution]++;
      }
    });

    return distribution;
  });

  const templateOptions = computed(() =>
    templateList.value.map((template) => ({
      label: template.templateName,
      value: template.id,
      content: template.content,
    })),
  );

  // ===== Actions =====

  /**
   * 获取消息列表
   */
  const fetchMessageList = async (
    params?: Partial<MessageSearchForm>,
  ): Promise<PageResult<Message>> => {
    loading.value = true;
    try {
      const queryParams = { ...searchForm.value, ...params };
      const response = await messageApi.getMessageList(queryParams);

      if (response.code === 200) {
        messageList.value = response.data.records;
        messagePagination.value = {
          total: response.data.total,
          pageNum: response.data.pageNum,
          pageSize: response.data.pageSize,
          pages: response.data.pages,
        };
        return response.data;
      } else {
        throw new Error(response.message || "获取消息列表失败");
      }
    } catch (error) {
      console.error("获取消息列表失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 获取消息模板列表
   */
  const fetchTemplateList = async (
    params?: any,
  ): Promise<PageResult<MessageTemplate>> => {
    loading.value = true;
    try {
      const response = await messageApi.getTemplateList(params);

      if (response.code === 200) {
        templateList.value = response.data.records;
        templatePagination.value = {
          total: response.data.total,
          pageNum: response.data.pageNum,
          pageSize: response.data.pageSize,
          pages: response.data.pages,
        };
        return response.data;
      } else {
        throw new Error(response.message || "获取模板列表失败");
      }
    } catch (error) {
      console.error("获取模板列表失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 发送消息
   */
  const sendMessage = async (
    messageData: MessageSendForm,
  ): Promise<Message> => {
    sendLoading.value = true;
    try {
      const response = await messageApi.sendMessage(messageData);

      if (response.code === 200) {
        // 添加到消息列表
        messageList.value.unshift(response.data);
        messagePagination.value.total += 1;
        return response.data;
      } else {
        throw new Error(response.message || "发送消息失败");
      }
    } catch (error) {
      console.error("发送消息失败:", error);
      throw error;
    } finally {
      sendLoading.value = false;
    }
  };

  /**
   * 批量发送消息
   */
  const batchSendMessage = async (batchData: any): Promise<MessageBatch> => {
    sendLoading.value = true;
    try {
      const response = await messageApi.batchSendMessage(batchData);

      if (response.code === 200) {
        // 添加到批次列表
        batchList.value.unshift(response.data);
        return response.data;
      } else {
        throw new Error(response.message || "批量发送消息失败");
      }
    } catch (error) {
      console.error("批量发送消息失败:", error);
      throw error;
    } finally {
      sendLoading.value = false;
    }
  };

  /**
   * 获取消息详情
   */
  const fetchMessageById = async (id: string): Promise<Message> => {
    try {
      const response = await messageApi.getMessageById(id);

      if (response.code === 200) {
        currentMessage.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取消息详情失败");
      }
    } catch (error) {
      console.error("获取消息详情失败:", error);
      throw error;
    }
  };

  /**
   * 创建消息模板
   */
  const createTemplate = async (
    templateData: any,
  ): Promise<MessageTemplate> => {
    try {
      const response = await messageApi.createTemplate(templateData);

      if (response.code === 200) {
        // 添加到模板列表
        templateList.value.unshift(response.data);
        templatePagination.value.total += 1;
        return response.data;
      } else {
        throw new Error(response.message || "创建模板失败");
      }
    } catch (error) {
      console.error("创建模板失败:", error);
      throw error;
    }
  };

  /**
   * 更新消息模板
   */
  const updateTemplate = async (
    id: string,
    templateData: any,
  ): Promise<MessageTemplate> => {
    try {
      const response = await messageApi.updateTemplate(id, templateData);

      if (response.code === 200) {
        // 更新本地数据
        const index = templateList.value.findIndex(
          (template) => template.id === id,
        );
        if (index !== -1) {
          templateList.value[index] = {
            ...templateList.value[index],
            ...response.data,
          };
        }

        // 更新当前模板
        if (currentTemplate.value && currentTemplate.value.id === id) {
          currentTemplate.value = {
            ...currentTemplate.value,
            ...response.data,
          };
        }

        return response.data;
      } else {
        throw new Error(response.message || "更新模板失败");
      }
    } catch (error) {
      console.error("更新模板失败:", error);
      throw error;
    }
  };

  /**
   * 删除消息模板
   */
  const deleteTemplate = async (id: string): Promise<void> => {
    try {
      const response = await messageApi.deleteTemplate(id);

      if (response.code === 200) {
        // 从本地列表中移除
        const index = templateList.value.findIndex(
          (template) => template.id === id,
        );
        if (index !== -1) {
          templateList.value.splice(index, 1);
          templatePagination.value.total -= 1;
        }

        // 如果删除的是当前模板，清空
        if (currentTemplate.value && currentTemplate.value.id === id) {
          currentTemplate.value = null;
        }
      } else {
        throw new Error(response.message || "删除模板失败");
      }
    } catch (error) {
      console.error("删除模板失败:", error);
      throw error;
    }
  };

  /**
   * 重发消息
   */
  const resendMessage = async (id: string): Promise<Message> => {
    try {
      const response = await messageApi.resendMessage(id);

      if (response.code === 200) {
        // 更新消息状态
        const index = messageList.value.findIndex(
          (message) => message.id === id,
        );
        if (index !== -1) {
          messageList.value[index] = response.data;
        }

        return response.data;
      } else {
        throw new Error(response.message || "重发消息失败");
      }
    } catch (error) {
      console.error("重发消息失败:", error);
      throw error;
    }
  };

  /**
   * 获取消息统计
   */
  const fetchMessageStatistics = async (): Promise<MessageStatistics> => {
    try {
      const response = await messageApi.getMessageStatistics();

      if (response.code === 200) {
        statistics.value = response.data;
        return response.data;
      } else {
        throw new Error(response.message || "获取消息统计失败");
      }
    } catch (error) {
      console.error("获取消息统计失败:", error);
      throw error;
    }
  };

  /**
   * 搜索消息
   */
  const searchMessages = async (
    searchParams: Partial<MessageSearchForm>,
  ): Promise<void> => {
    searchForm.value = { ...searchForm.value, ...searchParams, pageNum: 1 };
    await fetchMessageList(searchForm.value);
  };

  /**
   * 重置搜索条件
   */
  const resetSearch = async (): Promise<void> => {
    searchForm.value = {
      content: "",
      status: "",
      accountId: "",
      startDate: "",
      endDate: "",
      pageNum: 1,
      pageSize: 20,
    };
    await fetchMessageList();
  };

  /**
   * 获取批次详情
   */
  const fetchBatchById = async (id: string): Promise<MessageBatch> => {
    try {
      const response = await messageApi.getBatchById(id);

      if (response.code === 200) {
        return response.data;
      } else {
        throw new Error(response.message || "获取批次详情失败");
      }
    } catch (error) {
      console.error("获取批次详情失败:", error);
      throw error;
    }
  };

  /**
   * 获取批次列表
   */
  const fetchBatchList = async (
    params?: any,
  ): Promise<PageResult<MessageBatch>> => {
    loading.value = true;
    try {
      const response = await messageApi.getBatchList(params);

      if (response.code === 200) {
        batchList.value = response.data.records;
        return response.data;
      } else {
        throw new Error(response.message || "获取批次列表失败");
      }
    } catch (error) {
      console.error("获取批次列表失败:", error);
      throw error;
    } finally {
      loading.value = false;
    }
  };

  /**
   * 清空数据
   */
  const clearData = (): void => {
    messageList.value = [];
    templateList.value = [];
    batchList.value = [];
    currentMessage.value = null;
    currentTemplate.value = null;
    messagePagination.value = { total: 0, pageNum: 1, pageSize: 20, pages: 0 };
    templatePagination.value = { total: 0, pageNum: 1, pageSize: 20, pages: 0 };
  };

  /**
   * 设置当前消息
   */
  const setCurrentMessage = (message: Message | null): void => {
    currentMessage.value = message;
  };

  /**
   * 设置当前模板
   */
  const setCurrentTemplate = (template: MessageTemplate | null): void => {
    currentTemplate.value = template;
  };

  return {
    // State
    messageList,
    templateList,
    batchList,
    currentMessage,
    currentTemplate,
    loading,
    sendLoading,
    messagePagination,
    templatePagination,
    statistics,
    searchForm,

    // Getters
    sentMessages,
    failedMessages,
    pendingMessages,
    statusDistribution,
    templateOptions,

    // Actions
    fetchMessageList,
    fetchTemplateList,
    sendMessage,
    batchSendMessage,
    fetchMessageById,
    createTemplate,
    updateTemplate,
    deleteTemplate,
    resendMessage,
    fetchMessageStatistics,
    searchMessages,
    resetSearch,
    fetchBatchById,
    fetchBatchList,
    clearData,
    setCurrentMessage,
    setCurrentTemplate,
  };
});
