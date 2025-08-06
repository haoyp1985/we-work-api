/**
 * 全局指令注册
 */
import type { App } from "vue";

// 导入所有自定义指令
import { setupPermissionDirective } from "./permission";
import { setupLoadingDirective } from "./loading";
import { setupCopyDirective } from "./copy";
import { setupClickOutsideDirective } from "./clickOutside";

/**
 * 注册全局指令
 * @param app Vue应用实例
 */
export function setupDirectives(app: App): void {
  // 权限指令
  setupPermissionDirective(app);

  // 加载指令
  setupLoadingDirective(app);

  // 复制指令
  setupCopyDirective(app);

  // 点击外部指令
  setupClickOutsideDirective(app);
}
