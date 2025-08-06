<script setup lang="ts">
import { ref, onMounted } from "vue";

const _loading = ref(false);

onMounted(() => {
  console.log("PermissionManagement component mounted");
});
</script>

<template>
  <div class="permission-management-container">
    <el-card>
      <template #header>
        <h2>权限管理</h2>
      </template>
      <div class="placeholder-content">
        <el-icon :size="48"
color="#c0c4cc">
          <Key />
        </el-icon>
        <p>权限管理功能开发中...</p>
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.permission-management-container {
  padding: 20px;
}

.placeholder-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 200px;
  color: #999;

  p {
    margin-top: 16px;
    font-size: 16px;
  }
}
</style>
