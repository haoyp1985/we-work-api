<template>
  <el-menu
    :default-active="activeMenu"
    :collapse="appStore.sidebarCollapsed"
    :unique-opened="false"
    :collapse-transition="false"
    mode="vertical"
    background-color="#304156"
    text-color="#bfcbd9"
    active-text-color="#409eff"
    class="sidebar-menu"
  >
    <SidebarItem 
      v-for="route in routes" 
      :key="route.path" 
      :item="route" 
      :base-path="route.path"
    />
  </el-menu>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
// Element Plus 组件通过自动导入
import { useAppStore, usePermissionStore } from '@/stores'
import SidebarItem from './SidebarItem.vue'

const route = useRoute()
const appStore = useAppStore()
const permissionStore = usePermissionStore()

// 当前激活的菜单
const activeMenu = computed(() => {
  const { meta, path } = route
  if (meta?.activeMenu) {
    return meta.activeMenu as string
  }
  return path
})

// 可访问的路由
const routes = computed(() => {
  return permissionStore.routes.filter(route => 
    !route.meta?.hidden && route.children?.length
  )
})
</script>

<style lang="scss" scoped>
.sidebar-menu {
  border-right: none;
  height: 100%;
  width: 100% !important;
  
  // 收起状态下的菜单样式
  &.el-menu--collapse {
    .sidebar-item {
      > .el-menu-item,
      > .el-submenu > .el-submenu__title {
        padding: 0 !important;
        
        > span {
          height: 0;
          width: 0;
          overflow: hidden;
          visibility: hidden;
          display: inline-block;
        }
      }
    }
  }
}

// 深色主题
[data-theme="dark"] {
  .sidebar-menu {
    background-color: #1f2d3d !important;
  }
}
</style>