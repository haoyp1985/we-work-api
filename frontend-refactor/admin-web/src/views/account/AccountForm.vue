<script setup lang="ts">
import { ref, onMounted } from "vue";

// 页面数据
const _loading = ref(false);

onMounted(() => {
  console.log("AccountForm component mounted");
});
</script>

<template>
  <div class="account-form-container">
    <el-card>
      <template #header>
        <h2>账号表单</h2>
      </template>
      <div class="placeholder-content">
        <el-icon :size="48"
color="#c0c4cc">
          <Edit />
        </el-icon>
        <p>账号表单功能开发中...</p>
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.account-form-container {
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
