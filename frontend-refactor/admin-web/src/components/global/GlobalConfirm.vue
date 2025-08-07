<template>
  <div class="global-confirm">
    <!-- 这是一个全局确认对话框组件，Element Plus 已经提供了确认对话框功能 -->
  </div>
</template>

<script setup lang="ts">
// 这个组件主要用于全局确认对话框的自定义扩展
// Element Plus 的 ElMessageBox 已经提供了基础功能
// 这里可以添加自定义的确认对话框逻辑

defineOptions({
  name: 'GlobalConfirm'
})
</script>

<style lang="scss" scoped>
.global-confirm {
  // 预留样式，Element Plus 对话框样式由框架处理
}
</style>