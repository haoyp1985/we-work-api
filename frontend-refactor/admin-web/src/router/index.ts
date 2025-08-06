/**
 * Vue Router 4 路由配置
 * WeWork Management Platform - Frontend
 */

import { createRouter, createWebHistory } from "vue-router";
import type { RouteRecordRaw } from "vue-router";
import { useUserStore } from "@/stores/modules/user";
import { getToken } from "@/utils/auth";

// 路由类型定义
declare module "vue-router" {
  interface RouteMeta {
    title?: string;
    requiresAuth?: boolean;
    permissions?: string[];
    hideInMenu?: boolean;
    icon?: string;
    order?: number;
  }
}

// 静态路由
const staticRoutes: RouteRecordRaw[] = [
  {
    path: "/",
    redirect: "/dashboard",
  },
  {
    path: "/login",
    name: "Login",
    component: () => import("@/views/auth/Login.vue"),
    meta: {
      title: "用户登录",
      requiresAuth: false,
      hideInMenu: true,
    },
  },
  {
    path: "/dashboard",
    component: () => import("@/layout/index.vue"),
    children: [
      {
        path: "",
        name: "Dashboard",
        component: () => import("@/views/dashboard/index.vue"),
        meta: {
          title: "仪表板",
          icon: "dashboard",
          order: 1,
        },
      },
    ],
  },
  {
    path: "/account",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "账号管理",
      icon: "account",
      order: 2,
    },
    children: [
      {
        path: "list",
        name: "AccountList",
        component: () => import("@/views/account/AccountList.vue"),
        meta: {
          title: "账号列表",
          permissions: ["account:read"],
        },
      },
      {
        path: "create",
        name: "AccountCreate",
        component: () => import("@/views/account/AccountForm.vue"),
        meta: {
          title: "新增账号",
          permissions: ["account:create"],
          hideInMenu: true,
        },
      },
      {
        path: "edit/:id",
        name: "AccountEdit",
        component: () => import("@/views/account/AccountForm.vue"),
        meta: {
          title: "编辑账号",
          permissions: ["account:update"],
          hideInMenu: true,
        },
      },
    ],
  },
  {
    path: "/message",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "消息管理",
      icon: "message",
      order: 3,
    },
    children: [
      {
        path: "send",
        name: "MessageSend",
        component: () => import("@/views/message/MessageSend.vue"),
        meta: {
          title: "发送消息",
          permissions: ["message:send"],
        },
      },
      {
        path: "template",
        name: "MessageTemplate",
        component: () => import("@/views/message/MessageTemplate.vue"),
        meta: {
          title: "消息模板",
          permissions: ["message:template"],
        },
      },
      {
        path: "history",
        name: "MessageHistory",
        component: () => import("@/views/message/MessageHistory.vue"),
        meta: {
          title: "发送记录",
          permissions: ["message:read"],
        },
      },
    ],
  },
  {
    path: "/monitor",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "系统监控",
      icon: "monitor",
      order: 4,
    },
    children: [
      {
        path: "performance",
        name: "MonitorPerformance",
        component: () => import("@/views/monitor/Performance.vue"),
        meta: {
          title: "性能监控",
          permissions: ["monitor:read"],
        },
      },
      {
        path: "alerts",
        name: "MonitorAlerts",
        component: () => import("@/views/monitor/Alerts.vue"),
        meta: {
          title: "告警管理",
          permissions: ["monitor:alert"],
        },
      },
      {
        path: "logs",
        name: "MonitorLogs",
        component: () => import("@/views/monitor/Logs.vue"),
        meta: {
          title: "日志查看",
          permissions: ["monitor:log"],
        },
      },
    ],
  },
  {
    path: "/system",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "系统管理",
      icon: "system",
      order: 5,
      permissions: ["system:read"],
    },
    children: [
      {
        path: "user",
        name: "SystemUser",
        component: () => import("@/views/system/UserManagement.vue"),
        meta: {
          title: "用户管理",
          permissions: ["system:user"],
        },
      },
      {
        path: "role",
        name: "SystemRole",
        component: () => import("@/views/system/RoleManagement.vue"),
        meta: {
          title: "角色管理",
          permissions: ["system:role"],
        },
      },
      {
        path: "permission",
        name: "SystemPermission",
        component: () => import("@/views/system/PermissionManagement.vue"),
        meta: {
          title: "权限管理",
          permissions: ["system:permission"],
        },
      },
    ],
  },
];

// 错误页面路由
const errorRoutes: RouteRecordRaw[] = [
  {
    path: "/403",
    name: "Forbidden",
    component: () => import("@/views/error/403.vue"),
    meta: {
      title: "403 - 权限不足",
      hideInMenu: true,
    },
  },
  {
    path: "/404",
    name: "NotFound",
    component: () => import("@/views/error/404.vue"),
    meta: {
      title: "404 - 页面不存在",
      hideInMenu: true,
    },
  },
  {
    path: "/500",
    name: "ServerError",
    component: () => import("@/views/error/500.vue"),
    meta: {
      title: "500 - 服务器错误",
      hideInMenu: true,
    },
  },
  {
    path: "/:pathMatch(.*)*",
    redirect: "/404",
  },
];

// 创建路由实例
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [...staticRoutes, ...errorRoutes],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { top: 0 };
    }
  },
});

// 路由守卫
router.beforeEach(async (to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - WeWork Management Platform`;
  } else {
    document.title = "WeWork Management Platform";
  }

  // 检查是否需要认证
  if (to.meta.requiresAuth !== false) {
    const token = getToken();
    if (!token) {
      next({ name: "Login", query: { redirect: to.fullPath } });
      return;
    }

    // 检查用户信息
    const userStore = useUserStore();
    if (!userStore.userInfo.id) {
      try {
        await userStore.getUserInfo();
      } catch (error) {
        // 获取用户信息失败，跳转到登录页
        userStore.logout();
        next({ name: "Login", query: { redirect: to.fullPath } });
        return;
      }
    }

    // 检查权限
    if (to.meta.permissions && to.meta.permissions.length > 0) {
      const hasPermission = to.meta.permissions.some((permission) =>
        userStore.hasPermission(permission),
      );
      if (!hasPermission) {
        next({ name: "Forbidden" });
        return;
      }
    }
  }

  next();
});

router.afterEach((to, from) => {
  // 可以在这里添加路由切换后的逻辑
  console.log(`路由切换: ${from.path} -> ${to.path}`);
});

export default router;
