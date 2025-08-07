<template>
  <div class="copyright">
    <div class="copyright__content">
      <span class="copyright__text">
        © {{ currentYear }} WeWork Platform. All rights reserved.
      </span>
      <span class="copyright__version">
        v{{ version }}
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const currentYear = computed(() => new Date().getFullYear())
const version = computed(() => import.meta.env.VITE_APP_VERSION || '2.0.0')

defineOptions({
  name: 'Copyright'
})
</script>

<style lang="scss" scoped>
.copyright {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-top: 1px solid var(--el-border-color-light);
  z-index: 1000;

  &__content {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    padding: 8px 16px;
    font-size: 12px;
    color: var(--el-text-color-secondary);
  }

  &__text {
    // 版权文本样式
  }

  &__version {
    color: var(--el-color-primary);
    font-weight: 500;
  }
}

// 暗色主题适配
:global(.dark) {
  .copyright {
    background: rgba(0, 0, 0, 0.95);
  }
}
</style>