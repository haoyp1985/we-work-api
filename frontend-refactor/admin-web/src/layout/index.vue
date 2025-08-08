<script setup lang="ts">
import { computed } from "vue";
import { useAppStore } from "@/stores/modules/app";
import AppHeader from "./components/AppHeader.vue";
import AppSidebar from "./components/AppSidebar.vue";

const appStore = useAppStore();

// 侧边栏宽度（统一从 appStore 计算值拼接 px）
const sidebarWidth = computed(() => `${appStore.sidebarWidth}px`);
</script>

<template>
  <div class="app-layout">
    <el-container>
      <!-- 侧边栏 -->
      <el-aside :width="sidebarWidth" class="sidebar">
        <AppSidebar />
      </el-aside>

      <!-- 主要内容区域 -->
      <el-container>
        <!-- 顶部导航栏 -->
        <el-header height="60px" class="header">
          <AppHeader />
        </el-header>

        <!-- 内容区域 -->
        <el-main class="main-content">
          <router-view v-slot="{ Component }">
            <transition name="fade-transform" mode="out-in">
              <component :is="Component" />
            </transition>
          </router-view>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<style lang="scss" scoped>
@import "@/styles/variables.scss";

.app-layout {
  height: 100vh;
  overflow: hidden;

  .el-container {
    height: 100%;
  }

  .sidebar {
    background: #001529;
    transition: width 0.3s ease;
    overflow-x: hidden;
    border-right: 1px solid $border-color-light;
  }

  .header {
    background: #ffffff;
    border-bottom: 1px solid $border-color-light;
    padding: 0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    z-index: 99;
  }

  .main-content {
    background: $bg-color-page;
    overflow: auto;
    position: relative;
  }
}

// 页面切换动画
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.3s ease;
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}
</style>
