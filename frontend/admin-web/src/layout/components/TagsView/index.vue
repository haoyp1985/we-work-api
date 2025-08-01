<template>
  <div class="tags-view-container">
    <el-scrollbar class="tags-view-wrapper" ref="scrollbarRef">
      <div class="tags-view-content" ref="contentRef">
        <router-link
          v-for="tag in visitedViews"
          :key="tag.path"
          :to="{ path: tag.path, query: tag.query }"
          class="tags-view-item"
          :class="{
            'is-active': isActive(tag),
            'is-affix': tag.meta?.affix
          }"
          @click.middle="!tag.meta?.affix && closeSelectedTag(tag)"
          @contextmenu.prevent="openContextMenu(tag, $event)"
        >
          <span class="tag-title">{{ tag.title }}</span>
          <el-icon 
            v-if="!tag.meta?.affix" 
            class="tag-close"
            @click.prevent.stop="closeSelectedTag(tag)"
          >
            <Close />
          </el-icon>
        </router-link>
      </div>
    </el-scrollbar>
    
    <!-- 右键菜单 -->
    <ul 
      v-show="contextMenuVisible" 
      class="context-menu"
      :style="{ left: contextMenuLeft + 'px', top: contextMenuTop + 'px' }"
    >
      <li @click="refreshSelectedTag(selectedTag)">刷新页面</li>
      <li v-if="!selectedTag?.meta?.affix" @click="closeSelectedTag(selectedTag)">关闭当前</li>
      <li @click="closeOtherTags">关闭其他</li>
      <li @click="closeAllTags">关闭所有</li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import type { RouteLocationNormalized } from 'vue-router'

interface TagView extends Partial<RouteLocationNormalized> {
  title?: string
}

const route = useRoute()
const router = useRouter()

const scrollbarRef = ref()
const contentRef = ref()
const visitedViews = ref<TagView[]>([])
const contextMenuVisible = ref(false)
const contextMenuLeft = ref(0)
const contextMenuTop = ref(0)
const selectedTag = ref<TagView>()

// 当前激活的标签
const isActive = (tag: TagView) => {
  return tag.path === route.path
}

// 添加标签
const addTag = () => {
  const { name, path, fullPath, params, query, meta } = route
  if (name && path !== '/login') {
    const tag: TagView = {
      name,
      path,
      fullPath,
      params,
      query,
      meta,
      title: (meta?.title as string) || 'Unknown'
    }
    
    // 检查是否已存在
    const existingIndex = visitedViews.value.findIndex(v => v.path === path)
    if (existingIndex !== -1) {
      // 更新现有标签
      visitedViews.value[existingIndex] = { ...visitedViews.value[existingIndex], ...tag }
    } else {
      // 添加新标签
      visitedViews.value.push(tag)
    }
  }
}

// 关闭指定标签
const closeSelectedTag = (tag: TagView) => {
  const index = visitedViews.value.findIndex(v => v.path === tag.path)
  if (index !== -1) {
    visitedViews.value.splice(index, 1)
    
    // 如果关闭的是当前标签，跳转到其他标签
    if (isActive(tag)) {
      toLastView()
    }
  }
  closeContextMenu()
}

// 关闭其他标签
const closeOtherTags = () => {
  visitedViews.value = visitedViews.value.filter(tag => 
    tag.meta?.affix || tag.path === selectedTag.value?.path
  )
  closeContextMenu()
}

// 关闭所有标签
const closeAllTags = () => {
  visitedViews.value = visitedViews.value.filter(tag => tag.meta?.affix)
  toLastView()
  closeContextMenu()
}

// 刷新指定标签
const refreshSelectedTag = (tag: TagView) => {
  if (tag.path === route.path) {
    // 当前页面刷新
    router.replace({
      path: '/redirect' + tag.fullPath
    })
  }
  closeContextMenu()
}

// 跳转到最后一个标签
const toLastView = () => {
  const latestView = visitedViews.value[visitedViews.value.length - 1]
  if (latestView && latestView.path) {
    router.push(latestView.path)
  } else {
    router.push('/')
  }
}

// 打开右键菜单
const openContextMenu = (tag: TagView, e: MouseEvent) => {
  const menuMinWidth = 120
  const offsetLeft = contentRef.value.getBoundingClientRect().left
  const offsetWidth = contentRef.value.offsetWidth
  const maxLeft = offsetWidth - menuMinWidth
  const left = e.clientX - offsetLeft + 15

  contextMenuLeft.value = left > maxLeft ? maxLeft : left
  contextMenuTop.value = e.clientY
  contextMenuVisible.value = true
  selectedTag.value = tag
}

// 关闭右键菜单
const closeContextMenu = () => {
  contextMenuVisible.value = false
}

// 移动到当前标签
const moveToCurrentTag = () => {
  nextTick(() => {
    const activeTag = document.querySelector('.tags-view-item.is-active') as HTMLElement
    if (activeTag && scrollbarRef.value) {
      const container = scrollbarRef.value.$el.querySelector('.el-scrollbar__view')
      const containerWidth = container.offsetWidth
      const tagWidth = activeTag.offsetWidth
      const tagLeft = activeTag.offsetLeft
      
      if (tagLeft < container.scrollLeft) {
        container.scrollLeft = tagLeft
      } else if (tagLeft + tagWidth > container.scrollLeft + containerWidth) {
        container.scrollLeft = tagLeft + tagWidth - containerWidth
      }
    }
  })
}

// 初始化固定标签
const initTags = () => {
  // 添加首页作为固定标签
  visitedViews.value.push({
    path: '/dashboard',
    name: 'Dashboard',
    title: '首页',
    meta: { affix: true }
  })
}

// 监听路由变化
watch(route, () => {
  addTag()
  moveToCurrentTag()
}, { immediate: true })

// 监听点击事件，关闭右键菜单
watch(contextMenuVisible, (visible) => {
  if (visible) {
    document.body.addEventListener('click', closeContextMenu)
  } else {
    document.body.removeEventListener('click', closeContextMenu)
  }
})

onMounted(() => {
  initTags()
  addTag()
})
</script>

<style lang="scss" scoped>
.tags-view-container {
  height: 40px;
  background: var(--bg-color);
  border-bottom: 1px solid var(--border-color-base);
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.12), 0 1px 2px 0 rgba(0, 0, 0, 0.24);
  position: relative;
}

.tags-view-wrapper {
  height: 100%;
  
  :deep(.el-scrollbar__bar) {
    bottom: 0;
  }
  
  :deep(.el-scrollbar__view) {
    height: 100%;
    display: flex;
    align-items: center;
    min-width: 100%;
  }
}

.tags-view-content {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 0 12px;
  min-width: max-content;
}

.tags-view-item {
  display: flex;
  align-items: center;
  position: relative;
  cursor: pointer;
  height: 28px;
  line-height: 28px;
  border: 1px solid var(--border-color-light);
  color: var(--text-color-regular);
  background: var(--bg-color);
  padding: 0 12px;
  font-size: 12px;
  margin-right: 6px;
  border-radius: 3px;
  text-decoration: none;
  transition: all $transition-duration-base;
  
  &:hover {
    color: var(--el-color-primary);
    border-color: var(--el-color-primary);
  }
  
  &.is-active {
    background-color: var(--el-color-primary);
    color: #fff;
    border-color: var(--el-color-primary);
    
    &::before {
      content: '';
      background: #fff;
      display: inline-block;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      position: relative;
      margin-right: 4px;
    }
  }
  
  &.is-affix {
    .tag-close {
      display: none;
    }
  }
  
  .tag-title {
    flex: 1;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  
  .tag-close {
    margin-left: 4px;
    font-size: 12px;
    border-radius: 50%;
    text-align: center;
    transition: all $transition-duration-fast;
    transform-origin: 100% 50%;
    
    &:hover {
      background-color: rgba(0, 0, 0, 0.16);
      color: #fff;
    }
  }
}

.context-menu {
  margin: 0;
  background: var(--bg-color);
  z-index: 3000;
  position: absolute;
  list-style-type: none;
  padding: 5px 0;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 400;
  color: var(--text-color-primary);
  box-shadow: 2px 2px 3px 0 rgba(0, 0, 0, 0.3);
  
  li {
    margin: 0;
    padding: 7px 16px;
    cursor: pointer;
    
    &:hover {
      background: var(--el-color-primary-light-9);
      color: var(--el-color-primary);
    }
  }
}
</style>