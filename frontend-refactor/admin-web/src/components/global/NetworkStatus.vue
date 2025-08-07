<template>
  <Teleport to="body">
    <Transition name="slide-down">
      <div v-if="!isOnline" class="network-status">
        <div class="network-status__content">
          <el-icon class="network-status__icon">
            <Warning />
          </el-icon>
          <span class="network-status__text">网络连接已断开，请检查网络设置</span>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { Warning } from '@element-plus/icons-vue'

const isOnline = ref(navigator.onLine)

const handleOnline = () => {
  isOnline.value = true
}

const handleOffline = () => {
  isOnline.value = false
}

onMounted(() => {
  window.addEventListener('online', handleOnline)
  window.addEventListener('offline', handleOffline)
})

onUnmounted(() => {
  window.removeEventListener('online', handleOnline)
  window.removeEventListener('offline', handleOffline)
})

defineOptions({
  name: 'NetworkStatus'
})
</script>

<style lang="scss" scoped>
.network-status {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 10000;
  background: var(--el-color-warning);
  color: #fff;
  padding: 8px 16px;

  &__content {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
  }

  &__icon {
    font-size: 16px;
  }

  &__text {
    font-size: 14px;
    font-weight: 500;
  }
}

.slide-down-enter-active,
.slide-down-leave-active {
  transition: transform 0.3s ease;
}

.slide-down-enter-from,
.slide-down-leave-to {
  transform: translateY(-100%);
}
</style>