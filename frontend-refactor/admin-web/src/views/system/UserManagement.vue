<script setup lang="ts">
import { ref, onMounted } from "vue";

const _loading = ref(false);

onMounted(() => {
  console.log("UserManagement component mounted");
});
</script>

<template>
  <div class="user-management-container">
    <el-card>
      <template #header>
        <h2>用户管理</h2>
      </template>
      <div class="placeholder-content">
        <el-icon :size="48"
color="#c0c4cc">
          <User />
        </el-icon>
        <p>用户管理功能开发中...</p>
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.user-management-container {
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
