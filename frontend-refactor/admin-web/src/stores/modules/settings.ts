/**
 * 设置相关状态管理
 */
import { defineStore } from "pinia";
import { ref, computed } from "vue";

export interface WatermarkConfig {
  enabled: boolean;
  text: string;
  opacity?: number;
  fontSize?: number;
  color?: string;
}

export interface SettingsState {
  theme: "light" | "dark" | "auto";
  language: string;
  showCopyright: boolean;
  watermark: WatermarkConfig;
  autoSave: boolean;
  autoSaveInterval: number;
}

export const useSettingsStore = defineStore("settings", () => {
  // 状态
  const theme = ref<"light" | "dark" | "auto">("light");
  const language = ref("zh-CN");
  const showCopyright = ref(true);
  const autoSave = ref(true);
  const autoSaveInterval = ref(30000); // 30秒

  // 水印配置
  const watermark = ref<WatermarkConfig>({
    enabled: false,
    text: "WeWork Platform",
    opacity: 0.1,
    fontSize: 16,
    color: "#000000",
  });

  // 计算属性
  const isDarkMode = computed(() => {
    if (theme.value === "auto") {
      return window.matchMedia("(prefers-color-scheme: dark)").matches;
    }
    return theme.value === "dark";
  });

  // 方法
  const setTheme = (newTheme: "light" | "dark" | "auto") => {
    theme.value = newTheme;
    updateThemeClass();
    saveSettings();
  };

  const setLanguage = (newLanguage: string) => {
    language.value = newLanguage;
    saveSettings();
  };

  const setShowCopyright = (show: boolean) => {
    showCopyright.value = show;
    saveSettings();
  };

  const setWatermark = (config: Partial<WatermarkConfig>) => {
    watermark.value = { ...watermark.value, ...config };
    saveSettings();
  };

  const setAutoSave = (enabled: boolean) => {
    autoSave.value = enabled;
    saveSettings();
  };

  const setAutoSaveInterval = (interval: number) => {
    autoSaveInterval.value = interval;
    saveSettings();
  };

  // 主题类更新
  const updateThemeClass = () => {
    const html = document.documentElement;
    if (isDarkMode.value) {
      html.classList.add("dark");
    } else {
      html.classList.remove("dark");
    }
  };

  // 保存设置到localStorage
  const saveSettings = () => {
    const settings: SettingsState = {
      theme: theme.value,
      language: language.value,
      showCopyright: showCopyright.value,
      watermark: watermark.value,
      autoSave: autoSave.value,
      autoSaveInterval: autoSaveInterval.value,
    };
    localStorage.setItem("settings", JSON.stringify(settings));
  };

  // 从localStorage加载设置
  const loadSettings = () => {
    try {
      const saved = localStorage.getItem("settings");
      if (saved) {
        const settings: SettingsState = JSON.parse(saved);
        theme.value = settings.theme || "light";
        language.value = settings.language || "zh-CN";
        showCopyright.value = settings.showCopyright ?? true;
        watermark.value = { ...watermark.value, ...settings.watermark };
        autoSave.value = settings.autoSave ?? true;
        autoSaveInterval.value = settings.autoSaveInterval || 30000;
        updateThemeClass();
      }
    } catch (error) {
      console.error("Failed to load settings:", error);
    }
  };

  // 重置设置
  const resetSettings = () => {
    theme.value = "light";
    language.value = "zh-CN";
    showCopyright.value = true;
    watermark.value = {
      enabled: false,
      text: "WeWork Platform",
      opacity: 0.1,
      fontSize: 16,
      color: "#000000",
    };
    autoSave.value = true;
    autoSaveInterval.value = 30000;
    updateThemeClass();
    saveSettings();
  };

  // 导出全部配置
  const exportSettings = () => {
    const settings: SettingsState = {
      theme: theme.value,
      language: language.value,
      showCopyright: showCopyright.value,
      watermark: watermark.value,
      autoSave: autoSave.value,
      autoSaveInterval: autoSaveInterval.value,
    };
    return settings;
  };

  // 导入配置
  const importSettings = (settings: Partial<SettingsState>) => {
    if (settings.theme) theme.value = settings.theme;
    if (settings.language) language.value = settings.language;
    if (settings.showCopyright !== undefined) showCopyright.value = settings.showCopyright;
    if (settings.watermark) watermark.value = { ...watermark.value, ...settings.watermark };
    if (settings.autoSave !== undefined) autoSave.value = settings.autoSave;
    if (settings.autoSaveInterval) autoSaveInterval.value = settings.autoSaveInterval;
    updateThemeClass();
    saveSettings();
  };

  // 初始化
  loadSettings();

  // 监听系统主题变化
  if (typeof window !== "undefined") {
    window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
      if (theme.value === "auto") {
        updateThemeClass();
      }
    });
  }

  return {
    // 状态
    theme,
    language,
    showCopyright,
    watermark,
    autoSave,
    autoSaveInterval,
    
    // 计算属性
    isDarkMode,
    
    // 方法
    setTheme,
    setLanguage,
    setShowCopyright,
    setWatermark,
    setAutoSave,
    setAutoSaveInterval,
    updateThemeClass,
    saveSettings,
    loadSettings,
    resetSettings,
    exportSettings,
    importSettings,
  };
});