<template>
  <el-dialog
    v-model="dialogVisible"
    title="导出用户"
    width="600px"
    @close="handleClose"
  >
    <div class="user-export">
      <p>用户导出功能开发中...</p>
      <p v-if="selectedUsers.length > 0">
        已选择 {{ selectedUsers.length }} 个用户
      </p>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleExport">
          导出
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import type { UserInfo } from '@/types/api'

interface Props {
  modelValue: boolean
  selectedUsers: UserInfo[]
  searchFilters: any
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

const handleExport = () => {
  ElMessage.info('导出功能开发中...')
  handleClose()
}
</script>

<style scoped lang="scss">
.user-export {
  padding: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
</style>