<script setup lang="ts">
import { ref, computed } from "vue";
import { useRouter, useRoute } from "vue-router";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  Fold,
  Expand,
  Search,
  Bell,
  FullScreen,
  Aim,
  Setting,
  UserFilled,
  ArrowDown,
  User,
  SwitchButton,
} from "@element-plus/icons-vue";
import { storeToRefs } from "pinia";
import { useAppStore } from "@/stores/modules/app";
import { useUserStore } from "@/stores/modules/user";

const router = useRouter();
const route = useRoute();
const appStore = useAppStore();
const userStore = useUserStore();

// 统一使用计算属性：展开=非折叠
const sidebarOpened = computed(() => !appStore.sidebarCollapsed);

// 搜索关键词
const searchKeyword = ref("");

// 未读通知数量
const unreadCount = ref(5);

// 全屏状态
const isFullscreen = ref(false);

// 面包屑导航
const breadcrumbList = computed(() => {
  const matched = route.matched.filter((item) => item.meta && item.meta.title);
  const breadcrumbs = matched.map((item) => ({
    title: item.meta?.title as string,
    path: item.path,
  }));

  // 添加首页
  if (breadcrumbs.length > 0 && breadcrumbs[0].path !== "/") {
    breadcrumbs.unshift({ title: "首页", path: "/" });
  }

  return breadcrumbs;
});

// 切换侧边栏
const toggleSidebar = () => {
  appStore.toggleSidebar();
};

// 搜索功能
const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    ElMessage.info(`搜索功能开发中：${searchKeyword.value}`);
  }
};

// 显示通知
const showNotifications = () => {
  ElMessage.info("通知功能开发中");
};

// 切换全屏
const toggleFullscreen = () => {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen();
    isFullscreen.value = true;
  } else {
    document.exitFullscreen();
    isFullscreen.value = false;
  }
};

// 显示设置
const showSettings = () => {
  ElMessage.info("设置功能开发中");
};

// 处理用户菜单命令
const handleUserCommand = (command: string) => {
  switch (command) {
    case "profile":
      ElMessage.info("个人资料功能开发中");
      break;
    case "settings":
      ElMessage.info("账户设置功能开发中");
      break;
    case "logout":
      handleLogout();
      break;
  }
};

// 退出登录
const handleLogout = async () => {
  try {
    await ElMessageBox.confirm("确定要退出登录吗？", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning",
    });

    await userStore.userLogout();
    ElMessage.success("退出登录成功");
    router.push("/login");
  } catch (error) {
    // 用户取消操作
  }
};
</script>

<template>
  <div class="app-header">
    <!-- 左侧 -->
    <div class="header-left">
      <el-button
        type="text"
        size="large"
        class="sidebar-toggle"
        @click="toggleSidebar"
      >
        <el-icon>
          <Fold v-if="sidebarOpened" />
          <Expand v-else />
        </el-icon>
      </el-button>

      <!-- 面包屑导航 -->
      <el-breadcrumb class="breadcrumb" separator="/">
        <el-breadcrumb-item
          v-for="item in breadcrumbList"
          :key="item.path"
          :to="item.path"
        >
          {{ item.title }}
        </el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <!-- 右侧 -->
    <div class="header-right">
      <!-- 搜索 -->
      <div class="header-search">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索功能..."
          class="search-input"
          clearable
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>

      <!-- 通知 -->
      <el-badge
        :value="unreadCount"
        :hidden="unreadCount === 0"
        class="notification-badge"
      >
        <el-button type="text" size="large" @click="showNotifications">
          <el-icon><Bell /></el-icon>
        </el-button>
      </el-badge>

      <!-- 全屏切换 -->
      <el-button type="text" size="large" @click="toggleFullscreen">
        <el-icon>
          <FullScreen v-if="!isFullscreen" />
          <Aim v-else />
        </el-icon>
      </el-button>

      <!-- 设置 -->
      <el-button type="text" size="large" @click="showSettings">
        <el-icon><Setting /></el-icon>
      </el-button>

      <!-- 用户头像和菜单 -->
      <el-dropdown @command="handleUserCommand">
        <div class="user-avatar">
          <el-avatar
            :size="36"
            :src="userStore.userInfo?.avatar"
            :icon="UserFilled"
          />
          <span class="username">{{
            userStore.userInfo?.nickname || "用户"
          }}</span>
          <el-icon class="arrow-down">
            <ArrowDown />
          </el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="profile">
              <el-icon><User /></el-icon>
              个人资料
            </el-dropdown-item>
            <el-dropdown-item command="settings">
              <el-icon><Setting /></el-icon>
              账户设置
            </el-dropdown-item>
            <el-dropdown-item divided command="logout">
              <el-icon><SwitchButton /></el-icon>
              退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<style lang="scss" scoped>
@import "@/styles/variables.scss";

.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  padding: 0 20px;

  .header-left {
    display: flex;
    align-items: center;

    .sidebar-toggle {
      margin-right: 20px;
      font-size: 18px;
    }

    .breadcrumb {
      font-size: 14px;
    }
  }

  .header-right {
    display: flex;
    align-items: center;
    gap: 16px;

    .header-search {
      .search-input {
        width: 200px;
      }
    }

    .notification-badge {
      .el-button {
        font-size: 18px;
      }
    }

    .user-avatar {
      display: flex;
      align-items: center;
      cursor: pointer;
      padding: 8px 12px;
      border-radius: 6px;
      transition: background-color 0.2s ease;

      &:hover {
        background-color: $bg-color;
      }

      .username {
        margin: 0 8px;
        font-size: 14px;
        color: $text-color-primary;
      }

      .arrow-down {
        font-size: 12px;
        color: $text-color-secondary;
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .app-header {
    padding: 0 12px;

    .header-left {
      .breadcrumb {
        display: none;
      }
    }

    .header-right {
      gap: 8px;

      .header-search {
        display: none;
      }

      .user-avatar {
        .username {
          display: none;
        }
      }
    }
  }
}
</style>
