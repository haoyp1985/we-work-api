/**
 * 点击外部指令
 * 用于检测点击元素外部区域
 */
import type { App, DirectiveBinding } from "vue";

/**
 * 点击外部指令实现
 */
const clickOutside = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    if (typeof value !== "function") {
      console.warn("v-click-outside 指令需要一个函数作为参数");
      return;
    }
    
    // 创建点击事件处理函数
    const clickHandler = (event: MouseEvent) => {
      // 检查点击的目标是否在元素内部
      if (!el.contains(event.target as Node)) {
        // 点击在元素外部，调用回调函数
        value(event);
      }
    };
    
    // 延迟添加事件监听器，避免立即触发
    setTimeout(() => {
      document.addEventListener("click", clickHandler);
    }, 0);
    
    // 将处理函数存储在元素上，以便后续移除
    (el as any).__clickOutsideHandler__ = clickHandler;
  },
  
  updated(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    if (typeof value !== "function") {
      console.warn("v-click-outside 指令需要一个函数作为参数");
      return;
    }
    
    // 移除旧的事件监听器
    const oldHandler = (el as any).__clickOutsideHandler__;
    if (oldHandler) {
      document.removeEventListener("click", oldHandler);
    }
    
    // 创建新的点击事件处理函数
    const clickHandler = (event: MouseEvent) => {
      if (!el.contains(event.target as Node)) {
        value(event);
      }
    };
    
    // 添加新的事件监听器
    setTimeout(() => {
      document.addEventListener("click", clickHandler);
    }, 0);
    
    // 更新存储的处理函数
    (el as any).__clickOutsideHandler__ = clickHandler;
  },
  
  unmounted(el: HTMLElement) {
    // 移除事件监听器
    const handler = (el as any).__clickOutsideHandler__;
    if (handler) {
      document.removeEventListener("click", handler);
      delete (el as any).__clickOutsideHandler__;
    }
  }
};

/**
 * 注册点击外部指令
 * @param app Vue应用实例
 */
export function setupClickOutsideDirective(app: App): void {
  app.directive("click-outside", clickOutside);
}