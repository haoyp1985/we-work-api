<template>
  <div id="app" class="app-container">
    <!-- 全局加载条 -->
    <Transition name="loading">
      <div v-if="appStore.isLoading" class="global-loading">
        <div class="loading-content">
          <el-icon class="loading-icon" size="32">
            <Loading />
          </el-icon>
          <div class="loading-text">{{ appStore.loadingText }}</div>
        </div>
      </div>
    </Transition>

    <!-- 路由视图 -->
    <router-view v-slot="{ Component, route }">
      <Transition :name="route.meta.transition || 'fade'" mode="out-in">
        <KeepAlive :include="cachedViews" :max="10">
          <component :is="Component" :key="route.path" />
        </KeepAlive>
      </Transition>
    </router-view>

    <!-- 全局消息提示 -->
    <GlobalMessage />

    <!-- 全局确认对话框 -->
    <GlobalConfirm />

    <!-- 水印组件 -->
    <Watermark v-if="enableWatermark" :text="watermarkText" />

    <!-- 网络状态提示 -->
    <NetworkStatus />

    <!-- 版权信息 -->
    <Copyright v-if="showCopyright" />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted } from 'vue'
import { Loading } from '@element-plus/icons-vue'
import { useAppStore } from '@/stores/modules/app'
import { useSettingsStore } from '@/stores/modules/settings'
import { useTagsViewStore } from '@/stores/modules/tagsView'
import GlobalMessage from '@/components/global/GlobalMessage.vue'
import GlobalConfirm from '@/components/global/GlobalConfirm.vue'
import Watermark from '@/components/global/Watermark.vue'
import NetworkStatus from '@/components/global/NetworkStatus.vue'
import Copyright from '@/components/global/Copyright.vue'

// 存储实例
const appStore = useAppStore()
const settingsStore = useSettingsStore()
const tagsViewStore = useTagsViewStore()

// 计算属性
const cachedViews = computed(() => tagsViewStore.cachedViews)
const enableWatermark = computed(() => settingsStore.watermark.enabled)
const watermarkText = computed(() => settingsStore.watermark.text)
const showCopyright = computed(() => settingsStore.showCopyright)

// 生命周期
onMounted(async () => {
  // 初始化应用
  await appStore.initApp()
  
  // 监听窗口大小变化
  window.addEventListener('resize', handleResize)
  
  // 监听网络状态变化
  window.addEventListener('online', handleOnline)
  window.addEventListener('offline', handleOffline)
  
  // 监听可见性变化
  document.addEventListener('visibilitychange', handleVisibilityChange)
  
  // 检查浏览器兼容性
  checkBrowserCompatibility()
  
  // 初始化主题
  initTheme()
})

onUnmounted(() => {
  // 清理事件监听
  window.removeEventListener('resize', handleResize)
  window.removeEventListener('online', handleOnline)
  window.removeEventListener('offline', handleOffline)
  document.removeEventListener('visibilitychange', handleVisibilityChange)
})

// 事件处理函数
const handleResize = () => {
  appStore.setDevice(window.innerWidth < 768 ? 'mobile' : 'desktop')
}

const handleOnline = () => {
  appStore.setNetworkStatus(true)
  ElMessage.success('网络连接已恢复')
}

const handleOffline = () => {
  appStore.setNetworkStatus(false)
  ElMessage.warning('网络连接已断开')
}

const handleVisibilityChange = () => {
  if (document.hidden) {
    appStore.setPageVisible(false)
  } else {
    appStore.setPageVisible(true)
    // 页面重新可见时刷新数据
    appStore.refreshData()
  }
}

// 检查浏览器兼容性
const checkBrowserCompatibility = () => {
  const isIE = /MSIE|Trident/.test(navigator.userAgent)
  if (isIE) {
    ElMessageBox.alert(
      '检测到您正在使用IE浏览器，建议使用Chrome、Firefox、Safari等现代浏览器以获得更好的体验。',
      '浏览器兼容性提示',
      {
        confirmButtonText: '我知道了',
        type: 'warning'
      }
    )
  }
}

// 初始化主题
const initTheme = () => {
  const theme = settingsStore.theme
  document.documentElement.setAttribute('data-theme', theme)
  
  // 设置CSS变量
  if (theme === 'dark') {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

// 监听设置变化
watch(
  () => settingsStore.theme,
  (newTheme) => {
    document.documentElement.setAttribute('data-theme', newTheme)
    if (newTheme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }
)
</script>

<style lang="scss" scoped>
.app-container {
  min-height: 100vh;
  position: relative;
}

.global-loading {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(2px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;

  .loading-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;

    .loading-icon {
      color: var(--el-color-primary);
      animation: rotate 1s linear infinite;
    }

    .loading-text {
      color: var(--el-text-color-primary);
      font-size: 14px;
      font-weight: 500;
    }
  }
}

// 过渡动画
.loading-enter-active,
.loading-leave-active {
  transition: opacity 0.3s ease;
}

.loading-enter-from,
.loading-leave-to {
  opacity: 0;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-left-enter-active,
.slide-left-leave-active {
  transition: all 0.3s ease;
}

.slide-left-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.slide-left-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

// 暗色主题
:global(.dark) {
  .global-loading {
    background: rgba(0, 0, 0, 0.9);
  }
}
</style>