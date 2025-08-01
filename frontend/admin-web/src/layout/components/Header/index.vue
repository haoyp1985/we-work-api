<template>
  <div class="header-container">
    <div class="header-left">
      <!-- 折叠按钮 -->
      <div class="hamburger-container" @click="toggleSidebar">
        <el-icon class="hamburger-icon" :class="{ 'is-active': !appStore.sidebarCollapsed }">
          <component :is="appStore.sidebarCollapsed ? 'Expand' : 'Fold'" />
        </el-icon>
      </div>
      
      <!-- 面包屑导航 -->
      <Breadcrumb />
    </div>
    
    <div class="header-right">
      <!-- 租户切换器 -->
      <div class="tenant-switcher-wrapper">
        <TenantSwitcher @tenant-changed="handleTenantChange" />
      </div>
      
      <!-- 全屏按钮 -->
      <div class="header-item" @click="toggleFullscreen">
        <el-icon>
          <component :is="isFullscreen ? 'Aim' : 'FullScreen'" />
        </el-icon>
      </div>
      
      <!-- 主题切换 -->
      <div class="header-item" @click="toggleTheme">
        <el-icon>
          <component :is="appStore.theme === 'dark' ? 'Sunny' : 'Moon'" />
        </el-icon>
      </div>
      
      <!-- 国际化 -->
      <el-dropdown class="header-item" @command="handleLanguageChange">
        <div class="language-selector">
          <el-icon><component is="Setting" /></el-icon>
          <span class="language-text">{{ currentLanguageText }}</span>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="zh-cn" :disabled="appStore.language === 'zh-cn'">
              简体中文
            </el-dropdown-item>
            <el-dropdown-item command="en" :disabled="appStore.language === 'en'">
              English
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
      
      <!-- 消息通知 -->
      <el-badge :value="notificationCount" :hidden="notificationCount === 0" class="header-item">
        <el-icon><Bell /></el-icon>
      </el-badge>
      
      <!-- 用户信息 -->
      <UserInfo />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useAppStore } from '@/stores'
import { useFullscreen } from '@vueuse/core'
import { ElMessage } from 'element-plus'
import Breadcrumb from './Breadcrumb.vue'
import UserInfo from './UserInfo.vue'
import TenantSwitcher from '@/components/TenantSwitcher.vue'
import type { TenantInfo } from '@/types'

const appStore = useAppStore()
const { isFullscreen, toggle: toggleFullscreen } = useFullscreen()

// 消息通知数量（模拟数据）
const notificationCount = ref(3)

// 当前语言显示文本
const currentLanguageText = computed(() => {
  return appStore.language === 'zh-cn' ? '中文' : 'EN'
})

// 切换侧边栏
const toggleSidebar = () => {
  appStore.toggleSidebar()
}

// 切换主题
const toggleTheme = () => {
  const newTheme = appStore.theme === 'light' ? 'dark' : 'light'
  appStore.setTheme(newTheme)
}

// 处理语言切换
const handleLanguageChange = (language: 'zh-cn' | 'en') => {
  appStore.setLanguage(language)
}

// 处理租户切换
const handleTenantChange = (tenant: TenantInfo) => {
  ElMessage.success(`已切换到租户：${tenant.name}`)
  // 可以在这里添加其他租户切换后的处理逻辑
  // 比如刷新当前页面数据、更新用户权限等
}
</script>

<style lang="scss" scoped>
.header-container {
  height: $header-height;
  background: var(--bg-color);
  border-bottom: 1px solid var(--border-color-base);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  position: relative;
  z-index: 1000;
  @include box-shadow();
}

.header-left {
  display: flex;
  align-items: center;
}

.hamburger-container {
  cursor: pointer;
  margin-right: 20px;
  
  .hamburger-icon {
    font-size: 20px;
    color: var(--text-color-regular);
    transition: transform $transition-duration-base;
    
    &.is-active {
      transform: rotate(180deg);
    }
    
    &:hover {
      color: var(--el-color-primary);
    }
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
  
  .tenant-switcher-wrapper {
    margin-right: 8px;
  }
}

.header-item {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  cursor: pointer;
  border-radius: $border-radius-base;
  color: var(--text-color-regular);
  transition: all $transition-duration-base;
  
  &:hover {
    background-color: rgba(0, 0, 0, 0.05);
    color: var(--el-color-primary);
  }
  
  .el-icon {
    font-size: 18px;
  }
}

.language-selector {
  display: flex;
  align-items: center;
  gap: 4px;
  
  .language-text {
    font-size: 12px;
    color: var(--text-color-regular);
  }
}

// 响应式适配
@include respond-to(md) {
  .header-container {
    padding: 0 16px;
  }
  
  .hamburger-container {
    margin-right: 16px;
  }
  
  .header-right {
    gap: 12px;
    
    .language-selector .language-text {
      display: none;
    }
  }
}

// 深色主题适配
[data-theme="dark"] {
  .header-item {
    &:hover {
      background-color: rgba(255, 255, 255, 0.1);
    }
  }
}
</style>