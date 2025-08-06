<script setup lang="ts">
import { onMounted, onUnmounted } from "vue";
import { ElMessageBox } from "element-plus";

// 确认对话框配置
interface ConfirmConfig {
  title?: string;
  message: string;
  type?: "warning" | "info" | "success" | "error";
  confirmButtonText?: string;
  cancelButtonText?: string;
  confirmButtonType?: "primary" | "success" | "warning" | "danger" | "info";
  showCancelButton?: boolean;
  showConfirmButton?: boolean;
  callback?: (action: "confirm" | "cancel" | "close") => void;
}

// 默认配置
const defaultConfig: Partial<ConfirmConfig> = {
  title: "确认",
  type: "warning",
  confirmButtonText: "确定",
  cancelButtonText: "取消",
  confirmButtonType: "primary",
  showCancelButton: true,
  showConfirmButton: true,
};

// 显示确认对话框
const showConfirm = async (config: ConfirmConfig): Promise<string> => {
  const finalConfig = { ...defaultConfig, ...config };
  
  try {
    const result = await ElMessageBox.confirm(
      finalConfig.message,
      finalConfig.title,
      {
        type: finalConfig.type,
        confirmButtonText: finalConfig.confirmButtonText,
        cancelButtonText: finalConfig.cancelButtonText,
        confirmButtonClass: `el-button--${finalConfig.confirmButtonType}`,
        showCancelButton: finalConfig.showCancelButton,
        showConfirmButton: finalConfig.showConfirmButton,
        beforeClose: (action, instance, done) => {
          if (finalConfig.callback) {
            finalConfig.callback(action as "confirm" | "cancel" | "close");
          }
          done();
        },
      }
    );
    return result;
  } catch (action) {
    if (finalConfig.callback) {
      finalConfig.callback(action as "confirm" | "cancel" | "close");
    }
    throw action;
  }
};

// 显示警告确认框
const showWarning = (
  message: string,
  title = "警告",
  callback?: (action: "confirm" | "cancel" | "close") => void
): Promise<string> => {
  return showConfirm({
    message,
    title,
    type: "warning",
    confirmButtonType: "warning",
    callback,
  });
};

// 显示删除确认框
const showDelete = (
  message = "此操作将永久删除该数据，是否继续？",
  title = "删除确认",
  callback?: (action: "confirm" | "cancel" | "close") => void
): Promise<string> => {
  return showConfirm({
    message,
    title,
    type: "error",
    confirmButtonType: "danger",
    confirmButtonText: "删除",
    callback,
  });
};

// 显示信息确认框
const showInfo = (
  message: string,
  title = "提示",
  callback?: (action: "confirm" | "cancel" | "close") => void
): Promise<string> => {
  return showConfirm({
    message,
    title,
    type: "info",
    confirmButtonType: "primary",
    callback,
  });
};

// 显示成功确认框
const showSuccess = (
  message: string,
  title = "成功",
  callback?: (action: "confirm" | "cancel" | "close") => void
): Promise<string> => {
  return showConfirm({
    message,
    title,
    type: "success",
    confirmButtonType: "success",
    showCancelButton: false,
    callback,
  });
};

// 监听全局确认事件
const handleGlobalConfirm = async (event: CustomEvent) => {
  const config = event.detail as ConfirmConfig;
  try {
    await showConfirm(config);
  } catch (error) {
    // 用户取消或关闭对话框
    console.log("User cancelled or closed the confirm dialog");
  }
};

onMounted(() => {
  // 监听自定义确认事件
  window.addEventListener("global-confirm", handleGlobalConfirm as EventListener);
  
  // 将确认方法挂载到全局
  (window as any).globalConfirm = {
    show: showConfirm,
    warning: showWarning,
    delete: showDelete,
    info: showInfo,
    success: showSuccess,
  };
});

onUnmounted(() => {
  window.removeEventListener("global-confirm", handleGlobalConfirm as EventListener);
  
  // 清理全局方法
  delete (window as any).globalConfirm;
});

// 导出方法供其他组件使用
defineExpose({
  showConfirm,
  showWarning,
  showDelete,
  showInfo,
  showSuccess,
});
</script>

<template>
  <!-- 全局确认对话框组件不需要渲染任何内容 -->
  <div style="display: none;" />
</template>

<style scoped>
/* 全局确认对话框组件无需样式 */
</style>