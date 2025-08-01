<template>
  <div class="error-page">
    <div class="error-content">
      <div class="error-image">
        <div class="error-placeholder">
          <div class="error-number">403</div>
        </div>
      </div>
      
      <div class="error-info">
        <h1 class="error-code">403</h1>
        <h2 class="error-title">访问被拒绝</h2>
        <p class="error-description">
          抱歉，您没有访问此页面的权限
        </p>
        
        <div class="error-actions">
          <el-button @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            返回上页
          </el-button>
          <el-button type="primary" @click="goHome">
            <el-icon><HomeFilled /></el-icon>
            回到首页
          </el-button>
          <el-button type="warning" @click="contactAdmin">
            <el-icon><Service /></el-icon>
            联系管理员
          </el-button>
        </div>
        
        <div class="error-suggestions">
          <h3>可能的原因：</h3>
          <ul>
            <li>您的账号权限不足</li>
            <li>页面需要特殊权限</li>
            <li>会话已过期，请重新登录</li>
            <li>账号被禁用或限制</li>
          </ul>
        </div>
        
        <div class="error-tips">
          <el-alert
            title="提示"
            description="如果您认为这是一个错误，请联系系统管理员获取帮助"
            type="info"
            :closable="false"
            show-icon
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()

// 返回上一页
const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1)
  } else {
    router.push('/')
  }
}

// 回到首页
const goHome = () => {
  router.push('/')
}

// 联系管理员
const contactAdmin = () => {
  // 这里可以打开客服聊天或显示联系方式
  ElMessage.info('请联系管理员：admin@wework-platform.com')
}
</script>

<style lang="scss" scoped>
.error-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-color-page);
  padding: 20px;
}

.error-content {
  display: flex;
  align-items: center;
  gap: 60px;
  max-width: 900px;
  width: 100%;
}

.error-image {
  flex-shrink: 0;
  
  .error-placeholder {
    width: 300px;
    height: 300px;
    background: linear-gradient(135deg, #e6a23c 0%, #f56c6c 100%);
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .error-number {
      font-size: 80px;
      font-weight: 800;
      color: white;
      text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    }
  }
}

.error-info {
  flex: 1;
  
  .error-code {
    font-size: 72px;
    font-weight: 800;
    color: var(--el-color-warning);
    margin: 0 0 16px 0;
    line-height: 1;
  }
  
  .error-title {
    font-size: 32px;
    font-weight: 600;
    color: var(--text-color-primary);
    margin: 0 0 16px 0;
  }
  
  .error-description {
    font-size: 16px;
    color: var(--text-color-regular);
    margin: 0 0 32px 0;
    line-height: 1.6;
  }
  
  .error-actions {
    display: flex;
    gap: 16px;
    margin-bottom: 32px;
    flex-wrap: wrap;
    
    .el-button {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 20px;
      font-size: 14px;
    }
  }
  
  .error-suggestions {
    margin-bottom: 24px;
    
    h3 {
      font-size: 16px;
      font-weight: 600;
      color: var(--text-color-primary);
      margin: 0 0 12px 0;
    }
    
    ul {
      margin: 0;
      padding-left: 20px;
      
      li {
        color: var(--text-color-regular);
        line-height: 1.8;
        font-size: 14px;
      }
    }
  }
  
  .error-tips {
    :deep(.el-alert) {
      border-radius: 8px;
    }
  }
}

// 响应式适配
@include respond-to(md) {
  .error-content {
    flex-direction: column;
    text-align: center;
    gap: 40px;
  }
  
  .error-image {
    img {
      width: 240px;
    }
  }
  
  .error-info {
    .error-code {
      font-size: 60px;
    }
    
    .error-title {
      font-size: 28px;
    }
    
    .error-actions {
      justify-content: center;
    }
    
    .error-suggestions {
      text-align: left;
    }
  }
}

@include respond-to(sm) {
  .error-page {
    padding: 16px;
  }
  
  .error-image {
    img {
      width: 200px;
    }
  }
  
  .error-info {
    .error-code {
      font-size: 48px;
    }
    
    .error-title {
      font-size: 24px;
    }
    
    .error-actions {
      flex-direction: column;
      
      .el-button {
        width: 100%;
        justify-content: center;
      }
    }
  }
}
</style>