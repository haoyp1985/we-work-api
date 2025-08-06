<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import {
  HomeFilled,
  ArrowLeft,
  Search,
  Odometer,
  UserFilled,
  TrendCharts,
} from "@element-plus/icons-vue";
import { setPageTitle } from "@/utils";

const router = useRouter();

// 页面标题设置
setPageTitle("页面未找到");

// 搜索关键词
const searchKeyword = ref("");

// 返回首页
const goHome = () => {
  router.push("/dashboard");
};

// 返回上一页
const goBack = () => {
  if (window.history.length > 1) {
    router.go(-1);
  } else {
    router.push("/dashboard");
  }
};

// 搜索功能
const handleSearch = () => {
  if (!searchKeyword.value.trim()) {
    ElMessage.warning("请输入搜索关键词");
    return;
  }

  // 这里可以跳转到搜索页面或执行搜索逻辑
  ElMessage.info(`搜索功能开发中，关键词：${searchKeyword.value}`);
};

// 快捷链接
const quickLinks = [
  { name: "首页", icon: HomeFilled, path: "/dashboard" },
  { name: "用户管理", icon: UserFilled, path: "/system/user" },
  { name: "系统监控", icon: Odometer, path: "/monitor/performance" },
  { name: "数据统计", icon: TrendCharts, path: "/dashboard" },
];

// 跳转到快捷链接
const navigateTo = (path: string) => {
  router.push(path);
};
</script>

<template>
  <div class="error-page">
    <div class="error-container">
      <div class="error-illustration">
        <div class="error-code">404</div>
        <div class="error-image">
          <svg viewBox="0 0 200 200" class="svg-404">
            <defs>
              <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop
                  offset="0%"
                  style="stop-color: #667eea; stop-opacity: 1"
                />
                <stop
                  offset="100%"
                  style="stop-color: #764ba2; stop-opacity: 1"
                />
              </linearGradient>
            </defs>
            <circle cx="100" cy="100" r="80" fill="url(#grad1)" opacity="0.1" />
            <circle cx="100" cy="100" r="60" fill="url(#grad1)" opacity="0.2" />
            <circle cx="100" cy="100" r="40" fill="url(#grad1)" opacity="0.3" />
            <text
              x="100"
              y="110"
              text-anchor="middle"
              font-size="24"
              font-weight="bold"
              fill="url(#grad1)"
            >
              ?
            </text>
          </svg>
        </div>
      </div>

      <div class="error-content">
        <h1 class="error-title">页面未找到</h1>
        <p class="error-message">
抱歉，您访问的页面不存在或已被移除。
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

        <el-divider>或者尝试搜索</el-divider>

        <div class="search-section">
          <el-input
            v-model="searchKeyword"
            placeholder="输入关键词搜索..."
            size="large"
            class="search-input"
            @keyup.enter="handleSearch"
          >
            <template #append>
              <el-button type="primary" @click="handleSearch">
                <el-icon><Search /></el-icon>
              </el-button>
            </template>
          </el-input>
        </div>

        <div class="quick-links">
          <h3>快速导航</h3>
          <div class="links-grid">
            <div
              v-for="link in quickLinks"
              :key="link.name"
              class="link-item"
              @click="navigateTo(link.path)"
            >
              <el-icon :size="24" class="link-icon">
                <component :is="link.icon" />
              </el-icon>
              <span class="link-text">{{ link.name }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
@import "@/styles/variables.scss";

.error-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.error-container {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  padding: 60px 40px;
  max-width: 600px;
  width: 100%;
  text-align: center;
}

.error-illustration {
  margin-bottom: 40px;
}

.error-code {
  font-size: 120px;
  font-weight: 900;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 20px;
  line-height: 1;
  font-family: "Arial", sans-serif;
}

.error-image {
  .svg-404 {
    width: 200px;
    height: 200px;
    animation: float 3s ease-in-out infinite;
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

.error-content {
  .error-title {
    font-size: 32px;
    color: #333;
    margin-bottom: 16px;
    font-weight: 600;
  }

  .error-message {
    font-size: 16px;
    color: #666;
    margin-bottom: 40px;
    line-height: 1.6;
  }
}

.error-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
  margin-bottom: 40px;
  flex-wrap: wrap;

  .el-button {
    padding: 12px 24px;
    border-radius: 25px;
    font-weight: 500;
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }
  }
}

.search-section {
  margin: 30px 0;

  .search-input {
    max-width: 400px;
    margin: 0 auto;

    :deep(.el-input__wrapper) {
      border-radius: 25px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }

    :deep(.el-input-group__append) {
      .el-button {
        border-radius: 0 25px 25px 0;
        border: none;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
    }
  }
}

.quick-links {
  h3 {
    color: #333;
    margin-bottom: 20px;
    font-size: 18px;
    font-weight: 600;
  }

  .links-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
    gap: 16px;
    margin-top: 20px;
  }

  .link-item {
    padding: 20px 16px;
    background: rgba(255, 255, 255, 0.8);
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid rgba(102, 126, 234, 0.1);

    &:hover {
      background: rgba(102, 126, 234, 0.1);
      transform: translateY(-4px);
      box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
    }

    .link-icon {
      color: #667eea;
      margin-bottom: 8px;
    }

    .link-text {
      display: block;
      color: #333;
      font-size: 14px;
      font-weight: 500;
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .error-container {
    padding: 40px 20px;
    margin: 20px;
  }

  .error-code {
    font-size: 80px;
  }

  .error-content .error-title {
    font-size: 24px;
  }

  .error-actions {
    flex-direction: column;
    align-items: center;

    .el-button {
      width: 200px;
    }
  }

  .quick-links .links-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .error-code {
    font-size: 60px;
  }

  .search-input {
    width: 100%;
  }

  .quick-links .links-grid {
    grid-template-columns: 1fr;
  }
}
</style>
