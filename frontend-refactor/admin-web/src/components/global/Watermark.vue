<template>
  <div v-if="visible" class="watermark" ref="watermarkRef">
    <canvas ref="canvasRef" :style="canvasStyle"></canvas>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'

interface Props {
  text?: string
  fontSize?: number
  fontColor?: string
  fontFamily?: string
  angle?: number
  spacing?: number
  opacity?: number
  zIndex?: number
}

const props = withDefaults(defineProps<Props>(), {
  text: 'WeWork Platform',
  fontSize: 16,
  fontColor: '#000',
  fontFamily: 'Arial',
  angle: -20,
  spacing: 100,
  opacity: 0.1,
  zIndex: 1000
})

const watermarkRef = ref<HTMLElement>()
const canvasRef = ref<HTMLCanvasElement>()
const visible = ref(true)

const canvasStyle = ref({
  position: 'fixed',
  top: '0',
  left: '0',
  width: '100%',
  height: '100%',
  pointerEvents: 'none',
  zIndex: props.zIndex,
  opacity: props.opacity
})

const drawWatermark = () => {
  const canvas = canvasRef.value
  if (!canvas) return

  const ctx = canvas.getContext('2d')
  if (!ctx) return

  // 设置画布大小
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  // 设置字体样式
  ctx.font = `${props.fontSize}px ${props.fontFamily}`
  ctx.fillStyle = props.fontColor
  ctx.textAlign = 'center'
  ctx.textBaseline = 'middle'

  // 计算文字尺寸
  const textMetrics = ctx.measureText(props.text)
  const textWidth = textMetrics.width
  const textHeight = props.fontSize

  // 计算网格间距
  const xSpacing = textWidth + props.spacing
  const ySpacing = textHeight + props.spacing

  // 绘制水印网格
  for (let x = 0; x < canvas.width + xSpacing; x += xSpacing) {
    for (let y = 0; y < canvas.height + ySpacing; y += ySpacing) {
      ctx.save()
      ctx.translate(x, y)
      ctx.rotate((props.angle * Math.PI) / 180)
      ctx.fillText(props.text, 0, 0)
      ctx.restore()
    }
  }
}

const handleResize = () => {
  nextTick(() => {
    drawWatermark()
  })
}

onMounted(() => {
  nextTick(() => {
    drawWatermark()
  })
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})

// 监听属性变化重新绘制
watch(() => [props.text, props.fontSize, props.fontColor, props.angle], () => {
  nextTick(() => {
    drawWatermark()
  })
})

defineOptions({
  name: 'Watermark'
})
</script>

<style lang="scss" scoped>
.watermark {
  position: relative;
}
</style>