<template>
  <div class="system-settings">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-title">
        <h1>系统设置</h1>
        <p>管理系统配置、主题设置、通知设置等</p>
      </div>
    </div>

    <!-- 设置内容 -->
    <el-card class="settings-card" shadow="never">
      <div class="settings-placeholder">
        <el-icon size="64" color="#409eff"><Setting /></el-icon>
        <h3>系统设置模块开发中</h3>
        <p>包含配置管理、主题设置、通知设置、系统维护等功能</p>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { Setting } from '@element-plus/icons-vue'
</script>

<style scoped lang="scss">
.system-settings {
  padding: 20px;

  .page-header {
    margin-bottom: 20px;

    .header-title {
      h1 {
        margin: 0 0 8px 0;
        color: #1f2329;
        font-size: 24px;
        font-weight: 600;
      }

      p {
        margin: 0;
        color: #86909c;
        font-size: 14px;
      }
    }
  }

  .settings-card {
    border-radius: 8px;

    .settings-placeholder {
      text-align: center;
      padding: 60px 20px;

      h3 {
        margin: 20px 0 12px 0;
        color: #1f2329;
        font-size: 20px;
      }

      p {
        margin: 0;
        color: #86909c;
        font-size: 14px;
      }
    }
  }
}
</style>