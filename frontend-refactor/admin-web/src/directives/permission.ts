/**
 * 权限指令
 * 用于根据用户权限控制元素的显示/隐藏
 */
import type { App, DirectiveBinding } from "vue";

/**
 * 检查用户是否有指定权限
 * @param permissions 权限列表
 * @returns 是否有权限
 */
function checkPermission(permissions: string[]): boolean {
  // TODO: 这里应该从store或其他地方获取用户权限
  // 暂时返回true，实际项目中需要实现权限检查逻辑
  return true;
}

/**
 * 权限指令实现
 */
const permission = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    if (value && value instanceof Array && value.length > 0) {
      const hasPermission = checkPermission(value);
      
      if (!hasPermission) {
        el.style.display = "none";
        // 或者直接移除元素
        // el.parentNode?.removeChild(el);
      }
    } else {
      console.warn("v-permission 指令需要权限数组参数");
    }
  },
  
  updated(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    if (value && value instanceof Array && value.length > 0) {
      const hasPermission = checkPermission(value);
      
      if (hasPermission) {
        el.style.display = "";
      } else {
        el.style.display = "none";
      }
    }
  }
};

/**
 * 注册权限指令
 * @param app Vue应用实例
 */
export function setupPermissionDirective(app: App): void {
  app.directive("permission", permission);
}