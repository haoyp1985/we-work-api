<template>
  <div v-if="!item.meta?.hidden" class="sidebar-item">
    <!-- 如果有子菜单且子菜单数量大于1，显示为子菜单 -->
    <el-sub-menu 
      v-if="hasChildren" 
      :index="resolvePath"
      :popper-append-to-body="false"
      :teleported="false"
    >
      <template #title>
        <el-icon v-if="item.meta?.icon">
          <component :is="item.meta.icon" />
        </el-icon>
        <span class="menu-title">{{ item.meta?.title }}</span>
      </template>
      
      <SidebarItem
        v-for="child in visibleChildren"
        :key="child.path"
        :item="child"
        :base-path="resolvePath"
      />
    </el-sub-menu>
    
    <!-- 如果只有一个子菜单或没有子菜单，显示为菜单项 -->
    <el-menu-item 
      v-else
      :index="resolvePath"
      @click="handleMenuClick"
    >
      <el-icon v-if="onlyOneChild?.meta?.icon || item.meta?.icon">
        <component :is="onlyOneChild?.meta?.icon || item.meta?.icon" />
      </el-icon>
      <template #title>
        <span class="menu-title">
          {{ onlyOneChild?.meta?.title || item.meta?.title }}
        </span>
      </template>
    </el-menu-item>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
// Element Plus 组件通过自动导入
import { useAppStore } from '@/stores'

interface Props {
  item: RouteRecordRaw
  basePath: string
}

const props = defineProps<Props>()
const router = useRouter()
const appStore = useAppStore()

// 解析完整路径
const resolvePath = computed(() => {
  if (props.item.path.startsWith('/')) {
    return props.item.path
  }
  return `${props.basePath}/${props.item.path}`.replace(/\/+/g, '/')
})

// 可见的子路由
const visibleChildren = computed(() => {
  return props.item.children?.filter(child => !child.meta?.hidden) || []
})

// 是否有子菜单
const hasChildren = computed(() => {
  return visibleChildren.value.length > 1
})

// 唯一子路由
const onlyOneChild = computed(() => {
  const children = visibleChildren.value
  if (children.length === 1) {
    return children[0]
  }
  return null
})

// 处理菜单点击
const handleMenuClick = () => {
  const targetPath = onlyOneChild.value 
    ? `${resolvePath.value}/${onlyOneChild.value.path}`.replace(/\/+/g, '/')
    : resolvePath.value
  
  // 如果是外部链接
  if (targetPath.startsWith('http')) {
    window.open(targetPath, '_blank')
    return
  }
  
  // 内部路由跳转
  router.push(targetPath)
  
  // 移动端点击后收起侧边栏
  if (appStore.device === 'mobile') {
    appStore.closeSidebar()
  }
}
</script>

<style lang="scss" scoped>
.sidebar-item {
  .menu-title {
    display: inline-block;
    vertical-align: middle;
  }
  
  .el-menu-item {
    &.is-active {
      background-color: rgba(64, 158, 255, 0.15) !important;
      
      &::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 3px;
        background-color: var(--el-color-primary);
      }
    }
    
    &:hover {
      background-color: rgba(255, 255, 255, 0.1) !important;
    }
  }
  
  .el-submenu {
    .el-submenu__title {
      &:hover {
        background-color: rgba(255, 255, 255, 0.1) !important;
      }
    }
  }
}

// 深色主题适配
[data-theme="dark"] {
  .sidebar-item {
    .el-menu-item {
      &:hover {
        background-color: rgba(255, 255, 255, 0.05) !important;
      }
    }
    
    .el-submenu {
      .el-submenu__title {
        &:hover {
          background-color: rgba(255, 255, 255, 0.05) !important;
        }
      }
    }
  }
}
</style>