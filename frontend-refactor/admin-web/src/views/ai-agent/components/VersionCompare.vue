<template>
  <el-dialog
    v-model="dialogVisible"
    title="版本对比"
    width="1200px"
    @close="handleClose"
  >
    <div class="version-compare">
      <p>版本对比组件开发中...</p>
      <p>Agent ID: {{ agentId }}</p>
      <p>源版本: {{ sourceVersionId }}</p>
      <p>目标版本: {{ targetVersionId }}</p>
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
  sourceVersionId: string
  targetVersionId: string
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
.version-compare {
  padding: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>