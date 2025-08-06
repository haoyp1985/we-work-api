/**
 * 加载指令
 * 用于在元素上显示加载状态
 */
import type { App, DirectiveBinding } from "vue";

/**
 * 创建加载元素
 * @returns 加载元素
 */
function createLoadingElement(): HTMLElement {
  const loadingEl = document.createElement("div");
  loadingEl.className = "v-loading";
  loadingEl.style.cssText = `
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
  `;
  
  const spinner = document.createElement("div");
  spinner.className = "loading-spinner";
  spinner.style.cssText = `
    width: 32px;
    height: 32px;
    border: 3px solid #f3f3f3;
    border-top: 3px solid #409eff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  `;
  
  loadingEl.appendChild(spinner);
  
  // 添加旋转动画
  if (!document.head.querySelector("#loading-style")) {
    const style = document.createElement("style");
    style.id = "loading-style";
    style.textContent = `
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    `;
    document.head.appendChild(style);
  }
  
  return loadingEl;
}

/**
 * 加载指令实现
 */
const loading = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    if (value) {
      el.style.position = el.style.position || "relative";
      const loadingEl = createLoadingElement();
      el.appendChild(loadingEl);
      el.setAttribute("data-loading", "true");
    }
  },
  
  updated(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    const hasLoading = el.getAttribute("data-loading") === "true";
    
    if (value && !hasLoading) {
      el.style.position = el.style.position || "relative";
      const loadingEl = createLoadingElement();
      el.appendChild(loadingEl);
      el.setAttribute("data-loading", "true");
    } else if (!value && hasLoading) {
      const loadingEl = el.querySelector(".v-loading");
      if (loadingEl) {
        el.removeChild(loadingEl);
        el.removeAttribute("data-loading");
      }
    }
  },
  
  unmounted(el: HTMLElement) {
    const loadingEl = el.querySelector(".v-loading");
    if (loadingEl) {
      el.removeChild(loadingEl);
    }
  }
};

/**
 * 注册加载指令
 * @param app Vue应用实例
 */
export function setupLoadingDirective(app: App): void {
  app.directive("loading", loading);
}