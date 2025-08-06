<template>
  <el-dialog
    v-model="dialogVisible"
    :title="isEdit ? '编辑版本' : '创建新版本'"
    width="800px"
    @close="handleClose"
  >
    <div class="version-form">
      <p>版本表单组件开发中...</p>
      <p>Agent ID: {{ agentId }}</p>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit">
          {{ isEdit ? '更新' : '创建' }}
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import type { AgentVersion } from '@/api/agent-version'

interface Props {
  modelValue: boolean
  agentId: string
  versionData?: AgentVersion | null
  isEdit: boolean
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'success'): void
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

const handleSubmit = () => {
  ElMessage.info('版本表单功能开发中...')
  emit('success')
  handleClose()
}
</script>

<style scoped lang="scss">
.version-form {
  padding: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>