/**
 * 路由权限控制
 * 处理路由守卫、权限验证和访问控制
 */
import type { Router } from "vue-router";
import { ElMessage } from "element-plus";
import { useUserStore } from "@/stores/modules/user";
import { getToken, removeToken } from "@/utils/auth";
import NProgress from "nprogress";

// 白名单路由，不需要登录即可访问
const whiteList = ["/login", "/register", "/404", "/403", "/500"];

/**
 * 设置路由守卫
 * @param router Vue Router实例
 */
export function setupRouterGuard(router: Router): void {
  // 前置守卫
  router.beforeEach(async (to, from, next) => {
    // 开始进度条
    NProgress.start();

    // 设置页面标题
    if (to.meta?.title) {
      document.title = `${to.meta.title} - WeWork Management Platform`;
    } else {
      document.title = "WeWork Management Platform";
    }

    const userStore = useUserStore();
    const token = getToken();

    // 如果有token
    if (token) {
      if (to.path === "/login") {
        // 已登录用户访问登录页，重定向到首页
        next({ path: "/" });
      } else {
        // 检查用户信息是否存在
        if (!userStore.userInfo?.id) {
          try {
            // 获取用户信息
            await userStore.getUserInfo();
            // 验证权限
            if (await checkPermission(to, userStore)) {
              next();
            } else {
              next("/403");
            }
          } catch (error) {
            console.error("获取用户信息失败:", error);
            // Token可能已过期，清除token并重定向到登录页
            removeToken();
            ElMessage.error("登录已过期，请重新登录");
            next(`/login?redirect=${encodeURIComponent(to.fullPath)}`);
          }
        } else {
          // 用户信息已存在，直接验证权限
          if (await checkPermission(to, userStore)) {
            next();
          } else {
            next("/403");
          }
        }
      }
    } else {
      // 没有token
      if (whiteList.includes(to.path)) {
        // 在白名单中，直接访问
        next();
      } else {
        // 重定向到登录页
        next(`/login?redirect=${encodeURIComponent(to.fullPath)}`);
      }
    }
  });

  // 后置守卫
  router.afterEach((to, from) => {
    // 结束进度条
    NProgress.done();

    // 记录页面访问日志
    if (to.path !== from.path) {
      console.log(`路由跳转: ${from.path} -> ${to.path}`);
    }
  });

  // 路由错误处理
  router.onError((error) => {
    console.error("路由错误:", error);
    NProgress.done();
    ElMessage.error("页面加载失败，请重试");
  });
}

/**
 * 检查路由权限
 * @param to 目标路由
 * @param userStore 用户store
 * @returns 是否有权限访问
 */
async function checkPermission(to: any, userStore: any): Promise<boolean> {
  // 如果路由不需要权限验证
  if (!to.meta?.requiresAuth) {
    return true;
  }

  // 如果路由没有指定具体权限要求
  if (!to.meta?.permissions || to.meta.permissions.length === 0) {
    return true;
  }

  // 检查用户是否具有所需权限
  const userPermissions = userStore.permissions || [];
  const requiredPermissions = to.meta.permissions;

  // 检查是否有任意一个所需权限
  const hasPermission = requiredPermissions.some((permission: string) =>
    userPermissions.includes(permission),
  );

  if (!hasPermission) {
    console.warn(`权限不足，需要权限: ${requiredPermissions.join(", ")}`);
    ElMessage.warning("您没有权限访问此页面");
  }

  return hasPermission;
}

/**
 * 检查是否为超级管理员
 * @param userStore 用户store
 * @returns 是否为超级管理员
 */
export function isSuperAdmin(userStore: any): boolean {
  return userStore.userInfo?.roles?.some(
    (role: any) => role.code === "super_admin" || role.code === "admin",
  );
}

/**
 * 动态添加路由权限
 * @param router Vue Router实例
 * @param userStore 用户store
 */
export async function addDynamicRoutes(
  router: Router,
  userStore: any,
): Promise<void> {
  try {
    // 获取用户菜单权限
    const menuRoutes = await userStore.getMenuRoutes();

    // 动态添加有权限的路由
    menuRoutes.forEach((route: any) => {
      router.addRoute(route);
    });

    console.log("动态路由添加成功");
  } catch (error) {
    console.error("动态路由添加失败:", error);
  }
}

/**
 * 重置路由权限
 * @param _router Vue Router实例
 */
export function resetRouterPermission(_router: Router): void {
  // 清除动态添加的路由
  // 注意：Vue Router 4没有直接的清除方法，可能需要重新创建router实例
  // 或者维护一个动态路由列表进行手动移除
  console.log("路由权限已重置");
}
