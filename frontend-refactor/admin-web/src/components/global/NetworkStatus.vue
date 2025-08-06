<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";
import { ElNotification } from "element-plus";
import { Link } from "@element-plus/icons-vue";

// 网络状态
const isOnline = ref(navigator.onLine);
const connectionType = ref("unknown");

// 网络状态变化处理
const handleOnline = () => {
  isOnline.value = true;
  ElNotification({
    title: "网络连接",
    message: "网络连接已恢复",
    type: "success",
    duration: 3000,
  });
};

const handleOffline = () => {
  isOnline.value = false;
  ElNotification({
    title: "网络断开",
    message: "网络连接已断开，请检查网络设置",
    type: "error",
    duration: 0, // 一直显示直到网络恢复
  });
};

// 获取连接类型
const updateConnectionInfo = () => {
  if ("connection" in navigator) {
    const connection = (navigator as any).connection;
    if (connection) {
      connectionType.value = connection.effectiveType || connection.type || "unknown";
    }
  }
};

// 定期检查网络状态
const checkNetworkStatus = async () => {
  try {
    // 尝试发送一个小的请求来检查网络连通性
    const response = await fetch("/favicon.ico", {
      method: "HEAD",
      cache: "no-cache",
    });
    
    if (!isOnline.value && response.ok) {
      handleOnline();
    }
  } catch (error) {
    if (isOnline.value) {
      handleOffline();
    }
  }
};

let statusCheckInterval: NodeJS.Timeout;

onMounted(() => {
  // 监听网络状态变化
  window.addEventListener("online", handleOnline);
  window.addEventListener("offline", handleOffline);
  
  // 监听连接信息变化
  if ("connection" in navigator) {
    const connection = (navigator as any).connection;
    if (connection) {
      connection.addEventListener("change", updateConnectionInfo);
    }
  }
  
  // 初始化连接信息
  updateConnectionInfo();
  
  // 定期检查网络状态（每30秒）
  statusCheckInterval = setInterval(checkNetworkStatus, 30000);
  
  // 初始检查
  if (!isOnline.value) {
    handleOffline();
  }
});

onUnmounted(() => {
  window.removeEventListener("online", handleOnline);
  window.removeEventListener("offline", handleOffline);
  
  if ("connection" in navigator) {
    const connection = (navigator as any).connection;
    if (connection) {
      connection.removeEventListener("change", updateConnectionInfo);
    }
  }
  
  if (statusCheckInterval) {
    clearInterval(statusCheckInterval);
  }
});

// 手动刷新网络状态
const refreshNetworkStatus = () => {
  checkNetworkStatus();
  updateConnectionInfo();
};
</script>

<template>
  <div class="network-status">
    <!-- 网络状态指示器 -->
    <div
      v-if="!isOnline"
      class="network-indicator offline"
      @click="refreshNetworkStatus"
    >
      <el-icon>
        <Link />
      </el-icon>
      <span>离线</span>
    </div>
    
    <!-- 开发环境下显示详细信息 -->
    <div
      v-if="isOnline && process.env.NODE_ENV === 'development'"
      class="network-indicator online"
      :title="`连接类型: ${connectionType}`"
    >
      <el-icon>
        <Link />
      </el-icon>
      <span>{{ connectionType }}</span>
    </div>
  </div>
</template>

<style scoped lang="scss">
.network-status {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 9998;
}

.network-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  
  &.online {
    background-color: rgba(103, 194, 58, 0.1);
    color: #67c23a;
    border: 1px solid rgba(103, 194, 58, 0.2);
    
    &:hover {
      background-color: rgba(103, 194, 58, 0.2);
    }
  }
  
  &.offline {
    background-color: rgba(245, 108, 108, 0.1);
    color: #f56c6c;
    border: 1px solid rgba(245, 108, 108, 0.2);
    animation: pulse 2s infinite;
    
    &:hover {
      background-color: rgba(245, 108, 108, 0.2);
    }
  }
}

@keyframes pulse {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
  100% {
    opacity: 1;
  }
}
</style>