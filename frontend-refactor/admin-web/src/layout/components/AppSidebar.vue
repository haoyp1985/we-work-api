<script setup lang="ts">
import { computed } from "vue";
import { useRoute } from "vue-router";
import { storeToRefs } from "pinia";
import {
  HomeFilled,
  UserFilled,
  ChatDotRound,
  Monitor,
  User,
  Setting,
  List,
  Plus,
  Promotion,
  Document,
  TrendCharts,
  Odometer,
  DocumentCopy,
  Bell,
  Key,
  Lock,
  Tools,
  FolderOpened,
} from "@element-plus/icons-vue";
import { useAppStore } from "@/stores/modules/app";
import { useUserStore } from "@/stores/modules/user";

const route = useRoute();
const appStore = useAppStore();
const userStore = useUserStore();

const { sidebarOpened } = storeToRefs(appStore);

// 当前激活的菜单
const activeMenu = computed(() => {
  const { path } = route;

  // 处理特殊路径
  if (path === "/") return "/";

  // 匹配子路由到父级菜单
  if (path.startsWith("/accounts")) {
    if (path === "/accounts") return "/accounts";
    if (path.startsWith("/accounts/create")) return "/accounts/create";
    if (path.startsWith("/accounts/settings")) return "/accounts/settings";
  }

  if (path.startsWith("/messages")) {
    if (path === "/messages") return "/messages";
    if (path.startsWith("/messages/send")) return "/messages/send";
    if (path.startsWith("/messages/templates")) return "/messages/templates";
    if (path.startsWith("/messages/statistics")) return "/messages/statistics";
  }

  if (path.startsWith("/monitor")) {
    if (path.startsWith("/monitor/dashboard")) return "/monitor/dashboard";
    if (path.startsWith("/monitor/logs")) return "/monitor/logs";
    if (path.startsWith("/monitor/alerts")) return "/monitor/alerts";
    if (path.startsWith("/monitor/performance")) return "/monitor/performance";
  }

  if (path.startsWith("/users")) {
    if (path === "/users") return "/users";
    if (path.startsWith("/users/roles")) return "/users/roles";
    if (path.startsWith("/users/permissions")) return "/users/permissions";
  }

  if (path.startsWith("/settings")) {
    if (path.startsWith("/settings/general")) return "/settings/general";
    if (path.startsWith("/settings/security")) return "/settings/security";
    if (path.startsWith("/settings/backup")) return "/settings/backup";
  }

  return path;
});

// 检查是否有管理员权限
const hasAdminPermission = computed(() => {
  return (
    userStore.roles.includes("admin") || userStore.roles.includes("super_admin")
  );
});
</script>

<template>
  <div class="app-sidebar">
    <!-- Logo 区域 -->
    <div class="sidebar-logo">
                  <img src="/logo.svg"
alt="Logo" class="logo-image"
/>
      <h2 v-show="sidebarOpened"
class="logo-title"
>
WeWork Platform
</h2>
    </div>

    <!-- 导航菜单 -->
    <el-menu
      :default-active="activeMenu"
      :collapse="!sidebarOpened"
      :unique-opened="false"
      class="sidebar-menu"
      background-color="#001529"
      text-color="#ffffff"
      active-text-color="#1890ff"
      router
    >
      <!-- 首页 -->
      <el-menu-item index="/">
        <el-icon><HomeFilled /></el-icon>
        <template #title>
首页
</template>
      </el-menu-item>

      <!-- 账号管理 -->
      <el-sub-menu index="accounts">
        <template #title>
          <el-icon><UserFilled /></el-icon>
          <span>账号管理</span>
        </template>
        <el-menu-item index="/accounts">
          <el-icon><List /></el-icon>
          <template #title>
账号列表
</template>
        </el-menu-item>
        <el-menu-item index="/accounts/create">
          <el-icon><Plus /></el-icon>
          <template #title>
添加账号
</template>
        </el-menu-item>
        <el-menu-item index="/accounts/settings">
          <el-icon><Setting /></el-icon>
          <template #title>
账号配置
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 消息管理 -->
      <el-sub-menu index="messages">
        <template #title>
          <el-icon><ChatDotRound /></el-icon>
          <span>消息管理</span>
        </template>
        <el-menu-item index="/messages">
          <el-icon><List /></el-icon>
          <template #title>
消息记录
</template>
        </el-menu-item>
        <el-menu-item index="/messages/send">
          <el-icon><Promotion /></el-icon>
          <template #title>
发送消息
</template>
        </el-menu-item>
        <el-menu-item index="/messages/templates">
          <el-icon><Document /></el-icon>
          <template #title>
消息模板
</template>
        </el-menu-item>
        <el-menu-item index="/messages/statistics">
          <el-icon><TrendCharts /></el-icon>
          <template #title>
发送统计
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 监控中心 -->
      <el-sub-menu index="monitor">
        <template #title>
          <el-icon><Monitor /></el-icon>
          <span>监控中心</span>
        </template>
        <el-menu-item index="/monitor/dashboard">
          <el-icon><Odometer /></el-icon>
          <template #title>
监控面板
</template>
        </el-menu-item>
        <el-menu-item index="/monitor/logs">
          <el-icon><DocumentCopy /></el-icon>
          <template #title>
系统日志
</template>
        </el-menu-item>
        <el-menu-item index="/monitor/alerts">
          <el-icon><Bell /></el-icon>
          <template #title>
告警管理
</template>
        </el-menu-item>
        <el-menu-item index="/monitor/performance">
          <el-icon><TrendCharts /></el-icon>
          <template #title>
性能监控
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 用户管理 -->
      <el-sub-menu
v-if="hasAdminPermission" index="users"
>
        <template #title>
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </template>
        <el-menu-item index="/users">
          <el-icon><List /></el-icon>
          <template #title>
用户列表
</template>
        </el-menu-item>
        <el-menu-item index="/users/roles">
          <el-icon><Key /></el-icon>
          <template #title>
角色管理
</template>
        </el-menu-item>
        <el-menu-item index="/users/permissions">
          <el-icon><Lock /></el-icon>
          <template #title>
权限管理
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 系统设置 -->
      <el-sub-menu
v-if="hasAdminPermission" index="settings"
>
        <template #title>
          <el-icon><Setting /></el-icon>
          <span>系统设置</span>
        </template>
        <el-menu-item index="/settings/general">
          <el-icon><Tools /></el-icon>
          <template #title>
基础设置
</template>
        </el-menu-item>
        <el-menu-item index="/settings/security">
          <el-icon><Lock /></el-icon>
          <template #title>
安全设置
</template>
        </el-menu-item>
        <el-menu-item index="/settings/backup">
          <el-icon><FolderOpened /></el-icon>
          <template #title>
备份管理
</template>
        </el-menu-item>
      </el-sub-menu>
    </el-menu>
  </div>
</template>

<style lang="scss" scoped>
@import "@/styles/variables.scss";

.app-sidebar {
  height: 100%;
  display: flex;
  flex-direction: column;

  .sidebar-logo {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 60px;
    padding: 0 20px;
    border-bottom: 1px solid #1e3a5f;
    transition: all 0.3s ease;

    .logo-image {
      width: 32px;
      height: 32px;
      border-radius: 4px;
    }

    .logo-title {
      margin: 0 0 0 12px;
      font-size: 18px;
      font-weight: 600;
      color: #ffffff;
      white-space: nowrap;
    }
  }

  .sidebar-menu {
    flex: 1;
    border: none;
    overflow-y: auto;
    overflow-x: hidden;

    // 自定义滚动条
    &::-webkit-scrollbar {
      width: 6px;
    }

    &::-webkit-scrollbar-track {
      background: #001529;
    }

    &::-webkit-scrollbar-thumb {
      background: #1890ff;
      border-radius: 3px;
    }

    // 菜单项样式调整
    :deep(.el-menu-item) {
      &:hover {
        background-color: #1c3a56 !important;
      }

      &.is-active {
        background-color: #1890ff !important;

        &::before {
          content: "";
          position: absolute;
          left: 0;
          top: 0;
          bottom: 0;
          width: 3px;
          background: #ffffff;
        }
      }
    }

    :deep(.el-sub-menu) {
      .el-sub-menu__title {
        &:hover {
          background-color: #1c3a56 !important;
        }
      }

      .el-menu-item {
        background-color: #0a1929 !important;

        &:hover {
          background-color: #1c3a56 !important;
        }

        &.is-active {
          background-color: #1890ff !important;
        }
      }
    }

    // 折叠状态样式
    &.el-menu--collapse {
      .el-menu-item,
      .el-sub-menu__title {
        padding: 0 20px !important;
        text-align: center;
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .app-sidebar {
    .sidebar-logo {
      padding: 0 15px;

      .logo-title {
        font-size: 16px;
      }
    }
  }
}
</style>
