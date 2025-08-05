import type { RouteRecordRaw } from 'vue-router'
import Layout from '@/layout/index.vue'

// 固定路由（不需要权限控制）
export const constantRoutes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { 
      title: '登录',
      hidden: true 
    }
  },
  {
    path: '/404',
    name: 'NotFound',
    component: () => import('@/views/error/404.vue'),
    meta: { 
      title: '页面不存在',
      hidden: true 
    }
  },
  {
    path: '/403',
    name: 'Forbidden',
    component: () => import('@/views/error/403.vue'),
    meta: { 
      title: '访问被拒绝',
      hidden: true 
    }
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/dashboard/index.vue'),
        meta: { 
          title: '首页',
          icon: 'HomeFilled',
          affix: true
        }
      }
    ]
  }
]

// 动态路由（需要权限控制）
export const asyncRoutes: RouteRecordRaw[] = [
  // 账号管理
  {
    path: '/account',
    component: Layout,
    redirect: '/account/list',
    name: 'Account',
    meta: {
      title: '账号管理',
      icon: 'User',
      roles: ['admin', 'account_manager']
    },
    children: [
      {
        path: 'list',
        name: 'AccountList',
        component: () => import('@/views/account/list-fixed.vue'),
        meta: { 
          title: '账号列表',
          icon: 'UserFilled'
        }
      }
    ]
  },

  // 消息管理
  {
    path: '/message',
    component: Layout,
    redirect: '/message/send',
    name: 'Message',
    meta: {
      title: '消息管理',
      icon: 'ChatLineSquare',
      roles: ['admin', 'message_manager']
    },
    children: [
      {
        path: 'send',
        name: 'MessageSend',
        component: () => import('@/views/message/send.vue'),
        meta: { 
          title: '发送消息',
          icon: 'Promotion'
        }
      }
    ]
  },

  // 提供商管理
  {
    path: '/provider',
    component: Layout,
    redirect: '/provider/list',
    name: 'Provider',
    meta: {
      title: '提供商管理',
      icon: 'Connection',
      roles: ['admin', 'provider_manager']
    },
    children: [
      {
        path: 'list',
        name: 'ProviderList',
        component: () => import('@/views/provider/list.vue'),
        meta: { 
          title: '提供商列表',
          icon: 'List'
        }
      }
    ]
  },

  // 监控中心
  {
    path: '/monitor',
    component: Layout,
    redirect: '/monitor/dashboard',
    name: 'Monitor',
    meta: {
      title: '监控中心',
      icon: 'Monitor',
      roles: ['admin', 'tenant_admin', 'monitor_viewer']
    },
    children: [
      {
        path: 'dashboard',
        name: 'MonitorDashboard',
        component: () => import('@/views/monitor/dashboard.vue'),
        meta: { 
          title: '监控面板',
          icon: 'DataAnalysis',
          keepAlive: true
        }
      },
      {
        path: 'alerts',
        name: 'MonitorAlerts',
        component: () => import('@/views/monitor/alerts.vue'),
        meta: { 
          title: '告警管理',
          icon: 'Bell',
          keepAlive: true
        }
      },
      {
        path: 'accounts',
        name: 'MonitorAccounts',
        component: () => import('@/views/monitor/accounts.vue'),
        meta: { 
          title: '账号监控',
          icon: 'User',
          keepAlive: true
        }
      },
      {
        path: 'rules',
        name: 'MonitorRules',
        component: () => import('@/views/monitor/rules.vue'),
        meta: { 
          title: '监控规则',
          icon: 'SetUp',
          roles: ['admin', 'tenant_admin']
        }
      }
    ]
  },

  // AI智能体管理
  {
    path: '/agent',
    component: Layout,
    redirect: '/agent/list',
    name: 'Agent',
    meta: {
      title: 'AI智能体',
      icon: 'Robot',
      roles: ['admin', 'agent_manager']
    },
    children: [
      {
        path: 'list',
        name: 'AgentList',
        component: () => import('@/views/agent/list.vue'),
        meta: { 
          title: '智能体管理',
          icon: 'Robot',
          keepAlive: true
        }
      },
      {
        path: 'platform',
        name: 'AgentPlatform',
        component: () => import('@/views/agent/platform.vue'),
        meta: { 
          title: '平台配置',
          icon: 'Connection',
          keepAlive: true
        }
      },
      {
        path: 'model',
        name: 'AgentModel',
        component: () => import('@/views/agent/model.vue'),
        meta: { 
          title: '模型配置',
          icon: 'Document',
          keepAlive: true
        }
      },
      {
        path: 'chat/:agentId?',
        name: 'AgentChat',
        component: () => import('@/views/agent/chat.vue'),
        meta: { 
          title: '对话测试',
          icon: 'ChatDotRound',
          hidden: true
        }
      },
      {
        path: 'monitoring',
        name: 'AgentMonitoring',
        component: () => import('@/views/agent/monitoring.vue'),
        meta: { 
          title: '调用监控',
          icon: 'DataAnalysis',
          keepAlive: true
        }
      }
    ]
  },

  // 系统管理
  {
    path: '/system',
    component: Layout,
    redirect: '/system/user',
    name: 'System',
    meta: {
      title: '系统管理',
      icon: 'Setting',
      roles: ['admin']
    },
    children: [
      {
        path: 'user',
        name: 'SystemUser',
        component: () => import('@/views/system/user.vue'),
        meta: { 
          title: '用户管理',
          icon: 'User'
        }
      }
    ]
  },

  // 404页面必须放在最后
  {
    path: '/:pathMatch(.*)*',
    redirect: '/404',
    meta: { hidden: true }
  }
]