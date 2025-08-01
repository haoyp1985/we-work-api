<template>
  <div class="error-page">
    <div class="error-content">
      <div class="error-image">
        <div class="error-placeholder">
          <div class="error-number">404</div>
        </div>
      </div>
      
      <div class="error-info">
        <h1 class="error-code">404</h1>
        <h2 class="error-title">页面不存在</h2>
        <p class="error-description">
          抱歉，您访问的页面不存在或已被删除
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
        </div>
        
        <div class="error-suggestions">
          <h3>可能的原因：</h3>
          <ul>
            <li>输入的网址不正确</li>
            <li>页面已被移动或删除</li>
            <li>链接已过期</li>
            <li>您没有访问此页面的权限</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

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
  max-width: 800px;
  width: 100%;
}

.error-image {
  flex-shrink: 0;
  
  .error-placeholder {
    width: 300px;
    height: 300px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
    color: var(--el-color-primary);
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
    margin-bottom: 40px;
    
    .el-button {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 24px;
      font-size: 16px;
    }
  }
  
  .error-suggestions {
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