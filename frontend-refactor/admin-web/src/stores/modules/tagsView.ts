/**
 * 标签视图相关状态管理
 */
import { defineStore } from "pinia";
import { ref, computed } from "vue";
import type { RouteLocationNormalized } from "vue-router";

export interface TagView {
  name?: string;
  path: string;
  title: string;
  fullPath: string;
  meta?: any;
  query?: Record<string, any>;
  params?: Record<string, any>;
  affix?: boolean; // 是否固定标签
}

export const useTagsViewStore = defineStore("tagsView", () => {
  // 状态
  const visitedViews = ref<TagView[]>([]);
  const cachedViews = ref<string[]>([]);

  // 计算属性
  const visitedViewsCount = computed(() => visitedViews.value.length);
  const hasCachedViews = computed(() => cachedViews.value.length > 0);

  // 方法
  const addView = (view: TagView) => {
    addVisitedView(view);
    addCachedView(view);
  };

  const addVisitedView = (view: TagView) => {
    const existingIndex = visitedViews.value.findIndex((v) => v.path === view.path);
    if (existingIndex > -1) {
      // 更新现有视图
      visitedViews.value[existingIndex] = { ...visitedViews.value[existingIndex], ...view };
    } else {
      // 添加新视图
      visitedViews.value.push({
        name: view.name,
        path: view.path,
        title: view.title || view.meta?.title || "未命名页面",
        fullPath: view.fullPath,
        meta: view.meta,
        query: view.query,
        params: view.params,
        affix: view.affix || view.meta?.affix || false,
      });
    }
  };

  const addCachedView = (view: TagView) => {
    if (view.name && !cachedViews.value.includes(view.name)) {
      if (view.meta?.keepAlive !== false) {
        cachedViews.value.push(view.name);
      }
    }
  };

  const delView = (view: TagView): Promise<{ visitedViews: TagView[]; cachedViews: string[] }> => {
    return new Promise((resolve) => {
      delVisitedView(view);
      delCachedView(view);
      resolve({
        visitedViews: visitedViews.value,
        cachedViews: cachedViews.value,
      });
    });
  };

  const delVisitedView = (view: TagView): Promise<TagView[]> => {
    return new Promise((resolve) => {
      const index = visitedViews.value.findIndex((v) => v.path === view.path);
      if (index > -1) {
        visitedViews.value.splice(index, 1);
      }
      resolve(visitedViews.value);
    });
  };

  const delCachedView = (view: TagView): Promise<string[]> => {
    return new Promise((resolve) => {
      if (view.name) {
        const index = cachedViews.value.indexOf(view.name);
        if (index > -1) {
          cachedViews.value.splice(index, 1);
        }
      }
      resolve(cachedViews.value);
    });
  };

  const delOthersViews = (view: TagView): Promise<{ visitedViews: TagView[]; cachedViews: string[] }> => {
    return new Promise((resolve) => {
      delOthersVisitedViews(view);
      delOthersCachedViews(view);
      resolve({
        visitedViews: visitedViews.value,
        cachedViews: cachedViews.value,
      });
    });
  };

  const delOthersVisitedViews = (view: TagView): Promise<TagView[]> => {
    return new Promise((resolve) => {
      visitedViews.value = visitedViews.value.filter((v) => {
        return v.affix || v.path === view.path;
      });
      resolve(visitedViews.value);
    });
  };

  const delOthersCachedViews = (view: TagView): Promise<string[]> => {
    return new Promise((resolve) => {
      if (view.name) {
        cachedViews.value = cachedViews.value.filter((name) => name === view.name);
      } else {
        cachedViews.value = [];
      }
      resolve(cachedViews.value);
    });
  };

  const delAllViews = (): Promise<{ visitedViews: TagView[]; cachedViews: string[] }> => {
    return new Promise((resolve) => {
      delAllVisitedViews();
      delAllCachedViews();
      resolve({
        visitedViews: visitedViews.value,
        cachedViews: cachedViews.value,
      });
    });
  };

  const delAllVisitedViews = (): Promise<TagView[]> => {
    return new Promise((resolve) => {
      visitedViews.value = visitedViews.value.filter((view) => view.affix);
      resolve(visitedViews.value);
    });
  };

  const delAllCachedViews = (): Promise<string[]> => {
    return new Promise((resolve) => {
      cachedViews.value = [];
      resolve(cachedViews.value);
    });
  };

  const updateVisitedView = (view: TagView) => {
    const index = visitedViews.value.findIndex((v) => v.path === view.path);
    if (index > -1) {
      visitedViews.value[index] = { ...visitedViews.value[index], ...view };
    }
  };

  const addRouteView = (route: RouteLocationNormalized) => {
    const view: TagView = {
      name: route.name as string,
      path: route.path,
      title: (route.meta?.title as string) || route.name as string || "未命名页面",
      fullPath: route.fullPath,
      meta: route.meta,
      query: route.query,
      params: route.params,
      affix: route.meta?.affix as boolean,
    };
    addView(view);
  };

  const delRouteView = (route: RouteLocationNormalized) => {
    const view: TagView = {
      name: route.name as string,
      path: route.path,
      title: (route.meta?.title as string) || route.name as string || "未命名页面",
      fullPath: route.fullPath,
      meta: route.meta,
      query: route.query,
      params: route.params,
    };
    return delView(view);
  };

  // 获取标签索引
  const getViewIndex = (view: TagView): number => {
    return visitedViews.value.findIndex((v) => v.path === view.path);
  };

  // 判断是否为活跃标签
  const isActive = (view: TagView, currentPath: string): boolean => {
    return view.path === currentPath;
  };

  // 移动到指定位置
  const moveToTarget = (currentTag: TagView, targetIndex: number) => {
    const currentIndex = getViewIndex(currentTag);
    if (currentIndex > -1 && targetIndex !== currentIndex) {
      const currentView = visitedViews.value.splice(currentIndex, 1)[0];
      visitedViews.value.splice(targetIndex, 0, currentView);
    }
  };

  // 初始化固定标签
  const initAffixTags = (routes: TagView[]) => {
    const affixTags = routes.filter((route) => route.affix);
    affixTags.forEach((tag) => {
      if (tag.name) {
        addVisitedView(tag);
      }
    });
  };

  return {
    // 状态
    visitedViews,
    cachedViews,

    // 计算属性
    visitedViewsCount,
    hasCachedViews,

    // 方法
    addView,
    addVisitedView,
    addCachedView,
    delView,
    delVisitedView,
    delCachedView,
    delOthersViews,
    delOthersVisitedViews,
    delOthersCachedViews,
    delAllViews,
    delAllVisitedViews,
    delAllCachedViews,
    updateVisitedView,
    addRouteView,
    delRouteView,
    getViewIndex,
    isActive,
    moveToTarget,
    initAffixTags,
  };
});