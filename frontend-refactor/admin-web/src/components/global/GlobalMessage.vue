<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";
import { ElMessage, ElNotification } from "element-plus";

// 全局消息配置
interface MessageConfig {
  type: "success" | "warning" | "error" | "info";
  title?: string;
  message: string;
  duration?: number;
  showClose?: boolean;
}

// 消息队列
const messageQueue = ref<MessageConfig[]>([]);
const isProcessing = ref(false);

// 消息处理函数
const processMessage = async (config: MessageConfig) => {
  const { type, title, message, duration = 3000, showClose = true } = config;

  if (title) {
    // 使用通知
    ElNotification({
      type,
      title,
      message,
      duration,
      showClose,
    });
  } else {
    // 使用消息
    ElMessage({
      type,
      message,
      duration,
      showClose,
    });
  }
};

// 处理消息队列
const processQueue = async () => {
  if (isProcessing.value || messageQueue.value.length === 0) {
    return;
  }

  isProcessing.value = true;
  
  while (messageQueue.value.length > 0) {
    const config = messageQueue.value.shift();
    if (config) {
      await processMessage(config);
      // 避免消息过快显示
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
  }
  
  isProcessing.value = false;
};

// 添加消息到队列
const addMessage = (config: MessageConfig) => {
  messageQueue.value.push(config);
  processQueue();
};

// 全局方法
const showSuccess = (message: string, title?: string, duration = 3000) => {
  addMessage({ type: "success", message, title, duration });
};

const showWarning = (message: string, title?: string, duration = 4000) => {
  addMessage({ type: "warning", message, title, duration });
};

const showError = (message: string, title?: string, duration = 5000) => {
  addMessage({ type: "error", message, title, duration });
};

const showInfo = (message: string, title?: string, duration = 3000) => {
  addMessage({ type: "info", message, title, duration });
};

// 监听全局事件
const handleGlobalMessage = (event: CustomEvent) => {
  const { type, message, title, duration } = event.detail;
  addMessage({ type, message, title, duration });
};

const handleGlobalError = (event: ErrorEvent) => {
  console.error("Global error:", event.error);
  showError("系统发生错误，请稍后重试", "错误提示");
};

const handleUnhandledRejection = (event: PromiseRejectionEvent) => {
  console.error("Unhandled promise rejection:", event.reason);
  showError("系统异常，请稍后重试", "错误提示");
};

onMounted(() => {
  // 监听自定义消息事件
  window.addEventListener("global-message", handleGlobalMessage as EventListener);
  
  // 监听全局错误
  window.addEventListener("error", handleGlobalError);
  window.addEventListener("unhandledrejection", handleUnhandledRejection);
  
  // 将消息方法挂载到全局
  (window as any).globalMessage = {
    success: showSuccess,
    warning: showWarning,
    error: showError,
    info: showInfo,
  };
});

onUnmounted(() => {
  window.removeEventListener("global-message", handleGlobalMessage as EventListener);
  window.removeEventListener("error", handleGlobalError);
  window.removeEventListener("unhandledrejection", handleUnhandledRejection);
  
  // 清理全局方法
  delete (window as any).globalMessage;
});

// 导出方法供其他组件使用
defineExpose({
  showSuccess,
  showWarning,
  showError,
  showInfo,
});
</script>

<template>
  <!-- 全局消息组件不需要渲染任何内容 -->
  <div style="display: none;" />
</template>

<style scoped>
/* 全局消息组件无需样式 */
</style>