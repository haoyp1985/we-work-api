/**
 * 通用工具函数
 */

/**
 * 判断是否为空值
 */
export function isEmpty(value: any): boolean {
  if (value == null) return true;
  if (typeof value === "string") return value.trim() === "";
  if (Array.isArray(value)) return value.length === 0;
  if (typeof value === "object") return Object.keys(value).length === 0;
  return false;
}

/**
 * 深度克隆对象
 */
export function deepClone<T>(obj: T): T {
  if (obj === null || typeof obj !== "object") return obj;
  if (obj instanceof Date) return new Date(obj.getTime()) as any;
  if (obj instanceof Array) return obj.map((item) => deepClone(item)) as any;
  if (typeof obj === "object") {
    const clonedObj = {} as { [key in keyof T]: T[key] };
    for (const key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        clonedObj[key] = deepClone(obj[key]);
      }
    }
    return clonedObj;
  }
  return obj;
}

/**
 * 防抖函数
 */
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number = 300,
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout;
  return function executedFunction(...args: Parameters<T>) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

/**
 * 节流函数
 */
export function throttle<T extends (...args: any[]) => any>(
  func: T,
  limit: number = 300,
): (...args: Parameters<T>) => void {
  let inThrottle: boolean;
  return function executedFunction(...args: Parameters<T>) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}

/**
 * 生成UUID
 */
export function generateUUID(): string {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
    const r = (Math.random() * 16) | 0;
    const v = c === "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

/**
 * 获取文件扩展名
 */
export function getFileExtension(filename: string): string {
  return filename.slice(((filename.lastIndexOf(".") - 1) >>> 0) + 2);
}

/**
 * 文件大小格式化
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return "0 Bytes";
  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB", "TB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + " " + sizes[i];
}

/**
 * 数字格式化（添加千分符）
 */
export function formatNumber(num: number): string {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/**
 * 获取URL参数
 */
export function getUrlParams(url?: string): Record<string, string> {
  const searchParams = new URLSearchParams(url || window.location.search);
  const params: Record<string, string> = {};
  for (const [key, value] of searchParams) {
    params[key] = value;
  }
  return params;
}

/**
 * 设置页面标题
 */
export function setPageTitle(title: string): void {
  document.title = `${title} - WeWork Platform`;
}

/**
 * 树形数据处理
 */
export function arrayToTree<T extends { id: string; parentId?: string }>(
  arr: T[],
  rootId: string | null = null,
): T[] {
  const tree: T[] = [];
  const map: Record<string, T & { children?: T[] }> = {};

  // 创建映射
  arr.forEach((item) => {
    map[item.id] = { ...item, children: [] };
  });

  // 构建树
  arr.forEach((item) => {
    const node = map[item.id];
    if (item.parentId === rootId || !item.parentId) {
      tree.push(node);
    } else if (map[item.parentId]) {
      map[item.parentId].children!.push(node);
    }
  });

  return tree;
}

/**
 * 树形数据转平面数组
 */
export function treeToArray<T extends { children?: T[] }>(tree: T[]): T[] {
  const result: T[] = [];

  function traverse(nodes: T[]) {
    nodes.forEach((node) => {
      const { children, ...rest } = node;
      result.push(rest as T);
      if (children && children.length > 0) {
        traverse(children);
      }
    });
  }

  traverse(tree);
  return result;
}
