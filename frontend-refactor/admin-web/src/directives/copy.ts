/**
 * 复制指令
 * 用于快速复制文本到剪贴板
 */
import type { App, DirectiveBinding } from "vue";
import { ElMessage } from "element-plus";

/**
 * 复制文本到剪贴板
 * @param text 要复制的文本
 */
async function copyToClipboard(text: string): Promise<void> {
  try {
    if (navigator.clipboard && window.isSecureContext) {
      // 现代浏览器使用 Clipboard API
      await navigator.clipboard.writeText(text);
    } else {
      // 回退方案：使用传统的 execCommand
      const textArea = document.createElement("textarea");
      textArea.value = text;
      textArea.style.position = "fixed";
      textArea.style.left = "-999999px";
      textArea.style.top = "-999999px";
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
      
      const successful = document.execCommand("copy");
      document.body.removeChild(textArea);
      
      if (!successful) {
        throw new Error("复制失败");
      }
    }
    
    ElMessage.success("复制成功");
  } catch (error) {
    console.error("复制失败:", error);
    ElMessage.error("复制失败");
  }
}

/**
 * 复制指令实现
 */
const copy = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    const { value } = binding;
    
    el.addEventListener("click", () => {
      const textToCopy = value || el.innerText || el.textContent || "";
      copyToClipboard(textToCopy);
    });
    
    // 添加复制样式提示
    el.style.cursor = "pointer";
    el.title = el.title || "点击复制";
  },
  
  updated(el: HTMLElement, binding: DirectiveBinding) {
    // 如果绑定值发生变化，更新提示文本
    const { value } = binding;
    if (value) {
      el.title = "点击复制: " + value;
    }
  }
};

/**
 * 注册复制指令
 * @param app Vue应用实例
 */
export function setupCopyDirective(app: App): void {
  app.directive("copy", copy);
}