<template>
  <div class="app-wrapper" :class="{ 'sidebar-collapsed': appStore.sidebarCollapsed }">
    <!-- 侧边栏 -->
    <Sidebar />
    
    <!-- 主要内容区域 -->
    <div class="main-container" :class="{ 'sidebar-collapsed': appStore.sidebarCollapsed }">
      <!-- 顶部导航栏 -->
      <Header />
      
      <!-- 标签页导航 -->
      <TagsView v-if="showTagsView" />
      
      <!-- 主要内容 -->
      <AppMain />
    </div>
    
    <!-- 设置面板 -->
    <Settings v-if="showSettings" />
    
    <!-- 调试信息 (仅开发环境) -->
    <DebugInfo v-if="isDev" />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useAppStore } from '@/stores'
import Sidebar from './components/Sidebar/index.vue'
import Header from './components/Header/index.vue'
import TagsView from './components/TagsView/index.vue'
import AppMain from './components/AppMain/index.vue'
import Settings from './components/Settings/index.vue'
import DebugInfo from '@/components/DebugInfo.vue'

const appStore = useAppStore()

// 配置项
const showTagsView = computed(() => true) // 可以从设置中控制
const showSettings = computed(() => false) // 可以从设置中控制
const isDev = import.meta.env.DEV
</script>

<style lang="scss" scoped>
.app-wrapper {
  position: relative;
  height: 100vh;
  width: 100%;
  
  &.sidebar-collapsed {
    .main-container {
      margin-left: $sidebar-collapsed-width;
    }
  }
}

.main-container {
  min-height: 100vh;
  margin-left: $sidebar-width;
  position: relative;
  transition: margin-left $transition-duration-base;
  
  &.sidebar-collapsed {
    margin-left: $sidebar-collapsed-width;
  }
}

// 移动端适配
@include respond-below(md) {
  .app-wrapper {
    .main-container {
      margin-left: 0;
    }
  }
}
</style>