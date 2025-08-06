/**
 * 全局组件注册
 */
import type { App } from "vue";

/**
 * 注册全局组件
 * @param _app Vue应用实例
 */
export function setupGlobalComponents(_app: App): void {
  // 这里可以注册全局组件
  // 例如：
  // _app.component('GlobalLoading', GlobalLoading);
  // _app.component('GlobalModal', GlobalModal);

  console.log("全局组件注册完成");
}