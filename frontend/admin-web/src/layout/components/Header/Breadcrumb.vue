<template>
  <el-breadcrumb class="breadcrumb-container" separator="/">
    <transition-group name="breadcrumb">
      <el-breadcrumb-item
        v-for="(item, index) in breadcrumbList"
        :key="item.path"
        :to="index === breadcrumbList.length - 1 ? undefined : { path: item.redirect || item.path }"
        class="breadcrumb-item"
      >
        <span 
          class="breadcrumb-text"
          :class="{ 'is-link': index !== breadcrumbList.length - 1 }"
        >
          {{ item.meta?.title }}
        </span>
      </el-breadcrumb-item>
    </transition-group>
  </el-breadcrumb>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import type { RouteLocationMatched } from 'vue-router'

const route = useRoute()
const router = useRouter()

// 生成面包屑列表
const breadcrumbList = computed(() => {
  const matched = route.matched.filter(item => {
    return item.meta?.title && !item.meta?.breadcrumb === false
  })
  
  // 如果第一个不是首页，添加首页
  const first = matched[0]
  if (first?.path !== '/dashboard') {
    matched.unshift({
      path: '/dashboard',
      meta: { title: '首页' }
    } as RouteLocationMatched)
  }
  
  return matched
})
</script>

<style lang="scss" scoped>
.breadcrumb-container {
  display: inline-block;
  font-size: 14px;
  line-height: 50px;
  margin-left: 8px;
  
  .breadcrumb-item {
    .breadcrumb-text {
      font-weight: 400;
      color: var(--text-color-regular);
      
      &.is-link {
        color: var(--text-color-secondary);
        cursor: pointer;
        
        &:hover {
          color: var(--el-color-primary);
        }
      }
    }
    
    &:last-child {
      .breadcrumb-text {
        color: var(--text-color-primary);
        font-weight: 500;
      }
    }
  }
}

// 面包屑动画
.breadcrumb-enter-active,
.breadcrumb-leave-active {
  transition: all 0.3s;
}

.breadcrumb-enter-from,
.breadcrumb-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

.breadcrumb-move {
  transition: all 0.3s;
}

// 响应式适配
@include respond-to(md) {
  .breadcrumb-container {
    display: none;
  }
}
</style>