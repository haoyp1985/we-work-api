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
    component: () => import("@/views/auth/login.vue"),
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
          requiresAuth: true,
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
      requiresAuth: true,
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
      {
        path: "detail/:id",
        name: "AccountDetail",
        component: () => import("@/views/account/AccountDetail.vue"),
        meta: {
          title: "账号详情",
          permissions: ["account:read"],
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
      requiresAuth: true,
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
      requiresAuth: true,
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
    path: "/ai-agent",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "AI智能体管理",
      icon: "robot",
      order: 5,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "AgentList",
        component: () => import("@/views/ai-agent/AgentList.vue"),
        meta: {
          title: "智能体列表",
          permissions: ["ai-agent:read"],
        },
      },
      {
        path: "create",
        name: "AgentCreate",
        component: () => import("@/views/ai-agent/AgentForm.vue"),
        meta: {
          title: "创建智能体",
          permissions: ["ai-agent:create"],
          hideInMenu: true,
        },
      },
      {
        path: "edit/:id",
        name: "AgentEdit",
        component: () => import("@/views/ai-agent/AgentForm.vue"),
        meta: {
          title: "编辑智能体",
          permissions: ["ai-agent:update"],
          hideInMenu: true,
        },
      },
      {
        path: "detail/:id",
        name: "AgentDetail",
        component: () => import("@/views/ai-agent/AgentDetail.vue"),
        meta: {
          title: "智能体详情",
          permissions: ["ai-agent:read"],
          hideInMenu: true,
        },
      },
      {
        path: ":id/versions",
        name: "AgentVersions",
        component: () => import("@/views/ai-agent/AgentVersions.vue"),
        meta: {
          title: "版本管理",
          permissions: ["ai-agent:version"],
          hideInMenu: true,
        },
      },
    ],
  },
  {
    path: "/monitoring",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "监控大屏",
      icon: "monitor",
      order: 4,
      requiresAuth: true,
    },
    children: [
      {
        path: "dashboard",
        name: "MonitoringDashboard",
        component: () => import("@/views/monitoring/MonitoringDashboard.vue"),
        meta: {
          title: "监控大屏",
          permissions: ["monitor:read"],
        },
      },
      {
        path: "alerts",
        name: "MonitoringAlertCenter",
        component: () => import("@/views/monitoring/AlertCenter.vue"),
        meta: {
          title: "告警中心",
          permissions: ["monitor:read"],
        },
      },
    ],
  },
  {
    path: "/conversation",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "对话管理",
      icon: "chat",
      order: 6,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "ConversationList",
        component: () => import("@/views/conversation/ConversationList.vue"),
        meta: {
          title: "会话列表",
          permissions: ["conversation:read"],
        },
      },
      {
        path: "chat/:agentId?",
        name: "ChatInterface",
        component: () => import("@/views/conversation/ChatInterface.vue"),
        meta: {
          title: "AI对话",
          permissions: ["conversation:chat"],
          hideInMenu: true,
        },
      },
    ],
  },
  {
    path: "/platform",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "平台集成",
      icon: "connection",
      order: 7,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "PlatformConfigList",
        component: () => import("@/views/platform/PlatformConfigList.vue"),
        meta: {
          title: "平台配置",
          permissions: ["platform:read"],
        },
      },
      {
        path: "model-config",
        name: "ModelConfigList",
        component: () => import("@/views/model-config/ModelConfigList.vue"),
        meta: {
          title: "模型配置",
          permissions: ["model:read"],
        },
      },
    ],
  },
  {
    path: "/ai-analytics",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "AI数据分析",
      icon: "chart",
      order: 8,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "AIAnalyticsDashboard",
        component: () => import("@/views/ai-analytics/AIAnalyticsDashboard.vue"),
        meta: {
          title: "数据概览",
          permissions: ["analytics:read"],
        },
      },
      {
        path: "agent/:agentId",
        name: "AgentAnalytics",
        component: () => import("@/views/ai-analytics/AgentAnalytics.vue"),
        meta: {
          title: "智能体分析",
          permissions: ["analytics:read"],
          hideInMenu: true,
        },
      },
    ],
  },
  {
    path: "/user-management",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "用户管理",
      icon: "user",
      order: 9,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "UserList",
        component: () => import("@/views/user/UserList.vue"),
        meta: {
          title: "用户列表",
          permissions: ["user:read"],
        },
      },
      {
        path: "roles",
        name: "RoleList",
        component: () => import("@/views/user/RoleList.vue"),
        meta: {
          title: "角色管理",
          permissions: ["role:read"],
        },
      },
      {
        path: "permissions",
        name: "PermissionList",
        component: () => import("@/views/user/PermissionList.vue"),
        meta: {
          title: "权限管理",
          permissions: ["permission:read"],
        },
      },
      {
        path: "departments",
        name: "DepartmentList",
        component: () => import("@/views/user/DepartmentList.vue"),
        meta: {
          title: "部门管理",
          permissions: ["department:read"],
        },
      },
      {
        path: "audit",
        name: "AuditLog",
        component: () => import("@/views/user/AuditLog.vue"),
        meta: {
          title: "审计日志",
          permissions: ["audit:read"],
        },
      },
      {
        path: "online",
        name: "OnlineUsers",
        component: () => import("@/views/user/OnlineUsers.vue"),
        meta: {
          title: "在线用户",
          permissions: ["user:online"],
        },
      },
    ],
  },
  {
    path: "/system",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "系统设置",
      icon: "setting",
      order: 10,
      requiresAuth: true,
    },
    children: [
      {
        path: "",
        name: "SystemSettings",
        component: () => import("@/views/system/SystemSettings.vue"),
        meta: {
          title: "系统配置",
          permissions: ["system:read"],
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
  if (to.meta.requiresAuth) {
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
