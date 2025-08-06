<template>
  <el-dialog
    v-model="dialogVisible"
    title="灰度发布"
    width="800px"
    @close="handleClose"
  >
    <div class="gray-release">
      <p>灰度发布功能开发中...</p>
      <p>Agent ID: {{ agentId }}</p>
      <p>Version ID: {{ versionId }}</p>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit">
          开始灰度发布
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'

interface Props {
  modelValue: boolean
  agentId: string
  versionId: string
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
  ElMessage.info('灰度发布功能开发中...')
  emit('success')
  handleClose()
}
</script>

<style scoped lang="scss">
.gray-release {
  padding: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>