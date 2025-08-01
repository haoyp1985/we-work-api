<template>
  <div class="sidebar-container">
    <div class="sidebar-logo">
      <router-link to="/" class="sidebar-logo-link">
        <div 
          v-if="!appStore.sidebarCollapsed" 
          class="sidebar-logo-img"
        >
          WP
        </div>
        <h1 v-if="!appStore.sidebarCollapsed" class="sidebar-logo-title">
          WeWork Platform
        </h1>
        <div 
          v-else
          class="sidebar-logo-mini"
        >
          W
        </div>
      </router-link>
    </div>
    
    <el-scrollbar class="sidebar-menu-container">
      <SidebarMenu />
    </el-scrollbar>
  </div>
</template>

<script setup lang="ts">
import { useAppStore } from '@/stores'
import SidebarMenu from './SidebarMenu.vue'

const appStore = useAppStore()
</script>

<style lang="scss" scoped>
.sidebar-container {
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1001;
  width: $sidebar-width;
  background: #304156;
  transition: width $transition-duration-base;
  
  .app-wrapper.sidebar-collapsed & {
    width: $sidebar-collapsed-width;
  }
}

.sidebar-logo {
  height: $header-height;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid #3a4a5c;
  
  .sidebar-logo-link {
    display: flex;
    align-items: center;
    text-decoration: none;
    color: #ffffff;
    padding: 0 16px;
    
    .sidebar-logo-img {
      width: 32px;
      height: 32px;
      margin-right: 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      font-weight: 700;
      color: white;
    }
    
    .sidebar-logo-title {
      font-size: 18px;
      font-weight: 600;
      margin: 0;
      white-space: nowrap;
    }
    
    .sidebar-logo-mini {
      width: 32px;
      height: 32px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      font-weight: 700;
      color: white;
    }
  }
}

.sidebar-menu-container {
  height: calc(100vh - #{$header-height});
  
  :deep(.el-scrollbar__view) {
    height: 100%;
  }
}

// 深色主题
[data-theme="dark"] {
  .sidebar-container {
    background: #1f2d3d;
    
    .sidebar-logo {
      border-bottom-color: #2a3a4c;
    }
  }
}
</style>