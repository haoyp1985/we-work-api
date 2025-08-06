<script setup lang="ts">
import { computed } from "vue";
import { useSettingsStore } from "@/stores/modules/settings";

const settingsStore = useSettingsStore();

// 版权配置
const showCopyright = computed(() => settingsStore.showCopyright);

// 当前年份
const currentYear = new Date().getFullYear();

// 版权信息
const copyrightInfo = {
  company: "WeWork Platform",
  startYear: 2024,
  version: "1.0.0",
  website: "https://wework.platform.com",
};

// 年份范围
const yearRange = computed(() => {
  if (copyrightInfo.startYear === currentYear) {
    return currentYear.toString();
  }
  return `${copyrightInfo.startYear}-${currentYear}`;
});

// 版权文本
const copyrightText = computed(() => {
  return `© ${yearRange.value} ${copyrightInfo.company}. All rights reserved.`;
});

// 版本信息
const versionText = computed(() => {
  return `Version ${copyrightInfo.version}`;
});
</script>

<template>
  <div v-if="showCopyright" class="copyright-container">
    <div class="copyright-content">
      <div class="copyright-main">
        <span class="copyright-text">{{ copyrightText }}</span>
        <span class="version-text">{{ versionText }}</span>
      </div>
      
      <div class="copyright-links">
        <a
          :href="copyrightInfo.website"
          target="_blank"
          rel="noopener noreferrer"
          class="copyright-link"
        >
          官方网站
        </a>
        <span class="separator">|</span>
        <a
          href="mailto:support@wework.platform.com"
          class="copyright-link"
        >
          技术支持
        </a>
        <span class="separator">|</span>
        <a
          href="#"
          class="copyright-link"
          @click.prevent="$emit('showPrivacy')"
        >
          隐私政策
        </a>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.copyright-container {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.95);
  border-top: 1px solid #e4e7ed;
  backdrop-filter: blur(10px);
  
  @media (prefers-color-scheme: dark) {
    background: rgba(0, 0, 0, 0.95);
    border-top-color: #363636;
  }
}

.copyright-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 20px;
  max-width: 1200px;
  margin: 0 auto;
  
  @media (max-width: 768px) {
    flex-direction: column;
    gap: 4px;
    padding: 8px 16px;
  }
}

.copyright-main {
  display: flex;
  align-items: center;
  gap: 16px;
  
  @media (max-width: 768px) {
    flex-direction: column;
    gap: 4px;
    text-align: center;
  }
}

.copyright-text {
  font-size: 12px;
  color: #666;
  
  @media (prefers-color-scheme: dark) {
    color: #999;
  }
}

.version-text {
  font-size: 11px;
  color: #999;
  padding: 2px 6px;
  background: #f5f7fa;
  border-radius: 3px;
  
  @media (prefers-color-scheme: dark) {
    background: #2d2d2d;
    color: #ccc;
  }
}

.copyright-links {
  display: flex;
  align-items: center;
  gap: 8px;
  
  @media (max-width: 768px) {
    justify-content: center;
  }
}

.copyright-link {
  font-size: 12px;
  color: #409eff;
  text-decoration: none;
  transition: color 0.3s ease;
  
  &:hover {
    color: #66b1ff;
    text-decoration: underline;
  }
  
  @media (prefers-color-scheme: dark) {
    color: #79bbff;
    
    &:hover {
      color: #a0cfff;
    }
  }
}

.separator {
  font-size: 12px;
  color: #ddd;
  
  @media (prefers-color-scheme: dark) {
    color: #555;
  }
}

// 响应式隐藏
@media (max-height: 600px) {
  .copyright-container {
    display: none;
  }
}

// 打印时隐藏
@media print {
  .copyright-container {
    display: none;
  }
}
</style>