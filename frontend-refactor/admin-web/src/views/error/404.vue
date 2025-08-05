<template>
  <div class="error-page">
    <div class="error-container">
      <div class="error-illustration">
        <div class="error-code">404</div>
        <div class="error-image">
          <svg viewBox="0 0 200 200" class="svg-404">
            <defs>
              <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
                <stop offset="100%" style="stop-color:#764ba2;stop-opacity:1" />
              </linearGradient>
            </defs>
            <circle cx="100" cy="100" r="80" fill="url(#grad1)" opacity="0.1" />
            <circle cx="100" cy="100" r="60" fill="url(#grad1)" opacity="0.2" />
            <circle cx="100" cy="100" r="40" fill="url(#grad1)" opacity="0.3" />
            <text x="100" y="110" text-anchor="middle" font-size="24" font-weight="bold" fill="url(#grad1)">
              ?
            </text>
          </svg>
        </div>
      </div>
      
      <div class="error-content">
        <h1 class="error-title">页面未找到</h1>
        <p class="error-description">
          抱歉，您访问的页面不存在或已被移除。
        </p>
        <p class="error-suggestion">
          请检查URL是否正确，或点击下方按钮返回主页。
        </p>
        
        <div class="error-actions">
          <el-button type="primary" size="large" @click="goHome">
            <el-icon><HomeFilled /></el-icon>
            返回首页
          </el-button>
          <el-button size="large" @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            返回上页
          </el-button>
        </div>
        
        <!-- 搜索建议 -->
        <div class="search-suggestion">
          <el-divider content-position="center">或者尝试搜索</el-divider>
          <el-input
            v-model="searchKeyword"
            placeholder="搜索功能或页面..."
            class="search-input"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #append>
              <el-button @click="handleSearch">
                <el-icon><Search /></el-icon>
              </el-button>
            </template>
          </el-input>
        </div>
        
        <!-- 常用链接 -->
        <div class="quick-links">
          <h3>常用功能</h3>
          <div class="links-grid">
            <router-link to="/dashboard" class="quick-link">
              <el-icon><Odometer /></el-icon>
              <span>仪表板</span>
            </router-link>
            <router-link to="/account/list" class="quick-link">
              <el-icon><UserFilled /></el-icon>
              <span>账号管理</span>
            </router-link>
            <router-link to="/message/send" class="quick-link">
              <el-icon><ChatDotRound /></el-icon>
              <span>发送消息</span>
            </router-link>
            <router-link to="/monitor/performance" class="quick-link">
              <el-icon><TrendCharts /></el-icon>
              <span>性能监控</span>
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { 
  HomeFilled, 
  ArrowLeft, 
  Search, 
  Odometer, 
  UserFilled, 
  ChatDotRound, 
  TrendCharts 
} from '@element-plus/icons-vue';
import { setPageTitle } from '@/utils';

const router = useRouter();

// 搜索关键词
const searchKeyword = ref('');

// 返回首页
const goHome = () => {
  router.push('/dashboard');
};

// 返回上一页
const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1);
  } else {
    goHome();
  }
};

// 处理搜索
const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    ElMessage.info(`搜索功能开发中：${searchKeyword.value}`);
    // 这里可以实现具体的搜索逻辑
  }
};

// 设置页面标题
setPageTitle('页面未找到');
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.error-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.error-container {
  max-width: 800px;
  width: 100%;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
    max-width: 500px;
  }
}

.error-illustration {
  background: linear-gradient(135deg, #f8f9ff 0%, #e8efff 100%);
  padding: 60px 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  
  .error-code {
    font-size: 120px;
    font-weight: 900;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    line-height: 1;
    margin-bottom: 20px;
  }
  
  .error-image {
    .svg-404 {
      width: 120px;
      height: 120px;
    }
  }
}

.error-content {
  padding: 60px 40px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  
  .error-title {
    font-size: 32px;
    font-weight: 700;
    color: $text-color-primary;
    margin: 0 0 16px 0;
    line-height: 1.2;
  }
  
  .error-description {
    font-size: 16px;
    color: $text-color-regular;
    margin: 0 0 12px 0;
    line-height: 1.6;
  }
  
  .error-suggestion {
    font-size: 14px;
    color: $text-color-secondary;
    margin: 0 0 32px 0;
    line-height: 1.5;
  }
  
  .error-actions {
    display: flex;
    gap: 16px;
    margin-bottom: 40px;
    
    .el-button {
      flex: 1;
      
      @media (max-width: 480px) {
        flex: none;
        width: 100%;
      }
    }
    
    @media (max-width: 480px) {
      flex-direction: column;
    }
  }
  
  .search-suggestion {
    margin-bottom: 40px;
    
    .search-input {
      margin-top: 16px;
    }
  }
  
  .quick-links {
    h3 {
      font-size: 16px;
      font-weight: 600;
      color: $text-color-primary;
      margin: 0 0 16px 0;
    }
    
    .links-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 12px;
      
      @media (max-width: 480px) {
        grid-template-columns: 1fr;
      }
    }
    
    .quick-link {
      display: flex;
      align-items: center;
      padding: 12px 16px;
      border: 1px solid $border-color-light;
      border-radius: 8px;
      color: $text-color-regular;
      text-decoration: none;
      transition: all 0.2s ease;
      
      &:hover {
        border-color: $primary-color;
        color: $primary-color;
        background: lighten($primary-color, 45%);
      }
      
      .el-icon {
        margin-right: 8px;
        font-size: 16px;
      }
      
      span {
        font-size: 14px;
      }
    }
  }
}

// 响应式调整
@media (max-width: 768px) {
  .error-page {
    padding: 16px;
  }
  
  .error-illustration {
    padding: 40px 20px;
    
    .error-code {
      font-size: 80px;
    }
    
    .svg-404 {
      width: 80px !important;
      height: 80px !important;
    }
  }
  
  .error-content {
    padding: 40px 20px;
    
    .error-title {
      font-size: 24px;
    }
    
    .error-description {
      font-size: 14px;
    }
  }
}

@media (max-width: 480px) {
  .error-illustration {
    .error-code {
      font-size: 60px;
    }
  }
  
  .error-content {
    .error-title {
      font-size: 20px;
    }
  }
}
</style>