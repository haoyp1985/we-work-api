<script setup lang="ts">
import { ref, computed, onMounted, watch } from "vue";
import { useSettingsStore } from "@/stores/modules/settings";

const settingsStore = useSettingsStore();
const canvasRef = ref<HTMLCanvasElement>();

// 水印配置
const watermarkConfig = computed(() => settingsStore.watermark);

// 创建水印
const createWatermark = () => {
  if (!canvasRef.value || !watermarkConfig.value.enabled) {
    return "";
  }

  const canvas = canvasRef.value;
  const ctx = canvas.getContext("2d");
  if (!ctx) return "";

  const { text, fontSize = 16, color = "#000000", opacity = 0.1 } = watermarkConfig.value;

  // 设置画布尺寸
  canvas.width = 200;
  canvas.height = 100;

  // 设置文字样式
  ctx.font = `${fontSize}px Arial`;
  ctx.fillStyle = color;
  ctx.globalAlpha = opacity;
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";

  // 绘制水印文字
  ctx.fillText(text, canvas.width / 2, canvas.height / 2);

  return canvas.toDataURL();
};

// 水印样式
const watermarkStyle = computed(() => {
  if (!watermarkConfig.value.enabled) {
    return { display: "none" };
  }

  const watermarkUrl = createWatermark();
  return {
    position: "fixed" as const,
    top: 0,
    left: 0,
    width: "100%",
    height: "100%",
    zIndex: 9999,
    pointerEvents: "none" as const,
    backgroundImage: `url(${watermarkUrl})`,
    backgroundRepeat: "repeat",
    backgroundPosition: "0 0",
  };
});

// 监听配置变化
watch(
  () => watermarkConfig.value,
  () => {
    // 水印配置变化时重新创建
  },
  { deep: true }
);

onMounted(() => {
  // 组件挂载时创建水印
  createWatermark();
});
</script>

<template>
  <div>
    <!-- 隐藏的画布用于生成水印 -->
    <canvas ref="canvasRef" style="display: none;" />
    
    <!-- 水印层 -->
    <div
      v-if="watermarkConfig.enabled"
      :style="watermarkStyle"
      class="watermark-overlay"
    />
  </div>
</template>

<style scoped>
.watermark-overlay {
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}
</style>