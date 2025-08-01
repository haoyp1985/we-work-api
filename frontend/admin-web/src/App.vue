<template>
  <div id="app" class="app-container">
    <!-- 全局加载 -->
    <el-config-provider :locale="locale" :size="componentSize">
      <router-view />
    </el-config-provider>

    <!-- 全局提示 -->
    <teleport to="body">
      <div id="global-loading" v-if="appStore.pageLoading" class="global-loading">
        <div class="loading-content">
          <el-icon class="loading-icon" :size="40">
            <Loading />
          </el-icon>
          <p class="loading-text">加载中...</p>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useAppStore } from '@/stores'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import en from 'element-plus/dist/locale/en.mjs'

// 使用stores
const appStore = useAppStore()

// 计算属性
const locale = computed(() => {
  return appStore.language === 'zh-cn' ? zhCn : en
})

const componentSize = computed(() => appStore.componentSize)



// 生命周期
onMounted(() => {
  // 初始化应用设置
  appStore.initApp()
})
</script>

<style lang="scss" scoped>
.app-container {
  height: 100vh;
  overflow: hidden;
}



// 全局加载遮罩
.global-loading {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(2px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;

  .loading-content {
    text-align: center;
    
    .loading-icon {
      color: var(--el-color-primary);
      animation: rotate 1.5s linear infinite;
    }
    
    .loading-text {
      margin-top: 12px;
      color: var(--el-text-color-regular);
      font-size: 14px;
    }
  }
}



// 旋转动画
@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

// 深色主题适配
html[data-theme="dark"] {
  .global-loading {
    background: rgba(0, 0, 0, 0.8);
  }
}
</style>