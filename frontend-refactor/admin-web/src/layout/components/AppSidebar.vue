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
  Cpu,
  Link
} from "@element-plus/icons-vue";
import { useAppStore } from "@/stores/modules/app";
import { useUserStore } from "@/stores/modules/user";

const route = useRoute();
const appStore = useAppStore();
const userStore = useUserStore();

// 展开状态：依赖 appStore.sidebarCollapsed
const sidebarOpened = computed(() => !appStore.sidebarCollapsed);

// 当前激活的菜单
const activeMenu = computed(() => {
  const { path } = route;

  // 处理特殊路径
  if (path === "/") return "/";

  // 账号管理
  if (path.startsWith("/account")) {
    if (path.startsWith("/account/list")) return "/account/list";
    if (path.startsWith("/account/create")) return "/account/create";
  }

  // 消息管理
  if (path.startsWith("/message")) {
    if (path === "/message") return "/message";
    if (path.startsWith("/message/send")) return "/message/send";
    if (path.startsWith("/message/template")) return "/message/template";
    if (path.startsWith("/message/history")) return "/message/history";
  }

  // 监控中心
  if (path.startsWith("/monitor")) {
    if (path.startsWith("/monitor/performance")) return "/monitor/performance";
    if (path.startsWith("/monitor/logs")) return "/monitor/logs";
    if (path.startsWith("/monitor/alerts")) return "/monitor/alerts";
  }

  // 平台集成
  if (path.startsWith("/platform")) {
    if (path === "/platform") return "/platform";
    if (path.startsWith("/platform/model-config")) return "/platform/model-config";
  }

  // 用户管理
  if (path.startsWith("/user-management")) {
    if (path === "/user-management") return "/user-management";
    if (path.startsWith("/user-management/roles")) return "/user-management/roles";
    if (path.startsWith("/user-management/permissions")) return "/user-management/permissions";
  }

  // 系统设置
  if (path.startsWith("/system")) {
    return "/system";
  }

  return path;
});

// 检查是否有管理员权限（使用 store 的计算属性）
const hasAdminPermission = computed(() => userStore.isAdmin);
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
      <el-sub-menu index="account">
        <template #title>
          <el-icon><UserFilled /></el-icon>
          <span>账号管理</span>
        </template>
        <el-menu-item index="/account/list">
          <el-icon><List /></el-icon>
          <template #title>
账号列表
</template>
        </el-menu-item>
        <el-menu-item index="/account/create">
          <el-icon><Plus /></el-icon>
          <template #title>
添加账号
</template>
        </el-menu-item>
        <el-menu-item index="/system">
          <el-icon><Setting /></el-icon>
          <template #title>
系统设置
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 消息管理 -->
      <el-sub-menu index="message">
        <template #title>
          <el-icon><ChatDotRound /></el-icon>
          <span>消息管理</span>
        </template>
        <el-menu-item index="/message/history">
          <el-icon><List /></el-icon>
          <template #title>
发送记录
</template>
        </el-menu-item>
        <el-menu-item index="/message/send">
          <el-icon><Promotion /></el-icon>
          <template #title>
发送消息
</template>
        </el-menu-item>
        <el-menu-item index="/message/template">
          <el-icon><Document /></el-icon>
          <template #title>
消息模板
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 监控中心 -->
      <el-sub-menu index="monitor">
        <template #title>
          <el-icon><Monitor /></el-icon>
          <span>监控中心</span>
        </template>
        <el-menu-item index="/monitoring/dashboard">
          <el-icon><Odometer /></el-icon>
          <template #title>
监控大屏
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

      <!-- AI 智能体 -->
      <el-sub-menu index="ai-agent">
        <template #title>
          <el-icon><Cpu /></el-icon>
          <span>AI 智能体</span>
        </template>
        <el-menu-item index="/ai-agent">
          <el-icon><List /></el-icon>
          <template #title>
智能体列表
</template>
        </el-menu-item>
        <el-menu-item index="/ai-agent/create">
          <el-icon><Plus /></el-icon>
          <template #title>
创建智能体
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 平台集成 -->
      <el-sub-menu index="platform">
        <template #title>
          <el-icon><Link /></el-icon>
          <span>平台集成</span>
        </template>
        <el-menu-item index="/platform">
          <el-icon><Setting /></el-icon>
          <template #title>
 平台配置
 </template>
        </el-menu-item>
        <el-menu-item index="/platform/model-config">
          <el-icon><Document /></el-icon>
          <template #title>
 模型配置
 </template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 用户管理 -->
      <el-sub-menu v-if="hasAdminPermission" index="user-management">
        <template #title>
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </template>
        <el-menu-item index="/user-management">
          <el-icon><List /></el-icon>
          <template #title>
用户列表
</template>
        </el-menu-item>
        <el-menu-item index="/user-management/roles">
          <el-icon><Key /></el-icon>
          <template #title>
角色管理
</template>
        </el-menu-item>
        <el-menu-item index="/user-management/permissions">
          <el-icon><Lock /></el-icon>
          <template #title>
权限管理
</template>
        </el-menu-item>
      </el-sub-menu>

      <!-- 系统设置 -->
      <el-sub-menu v-if="hasAdminPermission" index="system">
        <template #title>
          <el-icon><Setting /></el-icon>
          <span>系统设置</span>
        </template>
        <el-menu-item index="/system">
          <el-icon><Tools /></el-icon>
          <template #title>
基础设置
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
