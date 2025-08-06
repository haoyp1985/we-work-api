<template>
  <el-dialog
    v-model="dialogVisible"
    title="版本详情"
    width="1000px"
    @close="handleClose"
  >
    <div class="version-detail">
      <p>版本详情组件开发中...</p>
      <p>Agent ID: {{ agentId }}</p>
      <p>Version ID: {{ versionId }}</p>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">关闭</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

interface Props {
  modelValue: boolean
  agentId: string
  versionId: string
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const dialogVisible = ref(false)

watch(() => props.modelValue, (val) => {
  dialogVisible.value = val
})

watch(dialogVisible, (val) => {
  emit('update:modelValue', val)
})

const handleClose = () => {
  dialogVisible.value = false
}
</script>

<style scoped lang="scss">
.version-detail {
  padding: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>