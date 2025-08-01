<template>
  <section class="app-main">
    <router-view v-slot="{ Component, route }">
      <transition name="fade-transform" mode="out-in">
        <keep-alive :include="cachedViews" :max="10">
          <component :is="Component" :key="route.fullPath" />
        </keep-alive>
      </transition>
    </router-view>
  </section>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

// 需要缓存的视图组件名称
const cachedViews = computed(() => {
  // 可以根据路由配置或其他条件来决定哪些组件需要缓存
  const cacheList = [
    'Dashboard',
    'AccountList',
    'MessageHistory',
    'ProviderList',
    'MonitorDashboard'
  ]
  
  // 也可以根据当前路由的 meta.keepAlive 来动态决定
  if (route.meta?.keepAlive) {
    const componentName = route.name as string
    if (componentName && !cacheList.includes(componentName)) {
      cacheList.push(componentName)
    }
  }
  
  return cacheList
})
</script>

<style lang="scss" scoped>
.app-main {
  min-height: calc(100vh - #{$header-height} - 40px); // 减去header和tags-view的高度
  max-height: calc(100vh - #{$header-height} - 40px); // 限制最大高度以启用滚动
  width: 100%;
  position: relative;
  overflow-x: hidden;
  overflow-y: auto;
  background: var(--bg-color-page);
  padding: 20px;
}

// 页面切换动画
.fade-transform-enter-active,
.fade-transform-leave-active {
  transition: all 0.3s;
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

// 响应式适配
@include respond-to(md) {
  .app-main {
    padding: 16px;
    min-height: calc(100vh - #{$header-height});
  }
}

@include respond-to(sm) {
  .app-main {
    padding: 12px;
  }
}
</style>