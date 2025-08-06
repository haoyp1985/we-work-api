<script setup lang="ts">
import { useRouter } from "vue-router";

const router = useRouter();

const goHome = () => {
  router.push("/dashboard");
};

const goBack = () => {
  router.back();
};

const reload = () => {
  window.location.reload();
};
</script>

<template>
  <div class="error-container">
    <div class="error-content">
      <div class="error-illustration">
        <div class="error-number">500</div>
      </div>
      <h1>服务器错误</h1>
      <p class="error-description">抱歉，服务器出现了错误，请稍后重试。</p>
      <div class="error-actions">
        <el-button type="primary"
size="large" @click="reload">
          重新加载
        </el-button>
        <el-button size="large"
@click="goHome"
>
返回首页
</el-button>
        <el-button size="large"
@click="goBack"
>
返回上页
</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.error-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f56c6c 0%, #e85656 100%);
}

.error-content {
  text-align: center;
  color: white;
}

.error-illustration {
  margin-bottom: 40px;
}

.error-number {
  font-size: 120px;
  font-weight: bold;
  margin-bottom: 20px;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.3);
}

h1 {
  font-size: 36px;
  margin-bottom: 16px;
  color: white;
}

.error-description {
  font-size: 18px;
  margin-bottom: 40px;
  opacity: 0.9;
}

.error-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
}
</style>
