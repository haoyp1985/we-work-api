<template>
  <div class="global-message">
    <!-- 这是一个全局消息组件，Element Plus 已经提供了全局消息功能 -->
  </div>
</template>

<script setup lang="ts">
// 这个组件主要用于全局消息提示的自定义扩展
// Element Plus 的 ElMessage 已经提供了基础功能
// 这里可以添加自定义的消息处理逻辑

defineOptions({
  name: 'GlobalMessage'
})
</script>

<style lang="scss" scoped>
.global-message {
  // 预留样式，Element Plus 消息组件样式由框架处理
}
</style>