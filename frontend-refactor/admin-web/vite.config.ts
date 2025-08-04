import { defineConfig, loadEnv } from 'vite'
import type { UserConfig, ConfigEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import eslint from 'vite-plugin-eslint'
import { createSvgIconsPlugin } from 'vite-plugin-svg-icons'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import { resolve } from 'path'

export default defineConfig(({ command, mode }: ConfigEnv): UserConfig => {
  const env = loadEnv(mode, process.cwd(), '')
  const isBuild = command === 'build'

  return {
    // 基础配置
    base: env.VITE_PUBLIC_PATH || '/',
    
    // 开发服务器配置
    server: {
      host: '0.0.0.0',
      port: Number(env.VITE_PORT) || 3000,
      open: false,
      cors: true,
      strictPort: false,
      proxy: {
        '/api': {
          target: env.VITE_API_BASE_URL || 'http://localhost:8080',
          changeOrigin: true,
          ws: true,
          rewrite: (path) => path.replace(/^\/api/, '/api'),
          timeout: 20000
        },
        '/ws': {
          target: env.VITE_WS_BASE_URL || 'ws://localhost:8080',
          changeOrigin: true,
          ws: true,
          rewrite: (path) => path.replace(/^\/ws/, '/ws')
        }
      }
    },

    // 预览服务器配置
    preview: {
      port: 4173,
      host: '0.0.0.0',
      cors: true
    },

    // 路径解析
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src'),
        '@/components': resolve(__dirname, 'src/components'),
        '@/views': resolve(__dirname, 'src/views'),
        '@/api': resolve(__dirname, 'src/api'),
        '@/stores': resolve(__dirname, 'src/stores'),
        '@/utils': resolve(__dirname, 'src/utils'),
        '@/types': resolve(__dirname, 'src/types'),
        '@/hooks': resolve(__dirname, 'src/hooks'),
        '@/composables': resolve(__dirname, 'src/composables'),
        '@/constants': resolve(__dirname, 'src/constants'),
        '@/assets': resolve(__dirname, 'src/assets'),
        '@/styles': resolve(__dirname, 'src/styles'),
        '#': resolve(__dirname, 'types')
      }
    },

    // CSS配置
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `
            @import "@/styles/variables.scss";
            @import "@/styles/mixins.scss";
          `,
          charset: false
        }
      },
      postcss: {
        plugins: []
      }
    },

    // 插件配置
    plugins: [
      // Vue支持
      vue({
        script: {
          defineModel: true,
          propsDestructure: true
        }
      }),

      // Vue JSX支持
      vueJsx(),

      // ESLint检查
      eslint({
        include: ['src/**/*.ts', 'src/**/*.vue'],
        exclude: ['node_modules']
      }),

      // SVG图标
      createSvgIconsPlugin({
        iconDirs: [resolve(process.cwd(), 'src/assets/icons')],
        symbolId: 'icon-[dir]-[name]',
        inject: 'body-last',
        customDomId: '__svg__icons__dom__'
      }),

      // 自动导入
      AutoImport({
        imports: [
          'vue',
          'vue-router',
          'pinia',
          '@vueuse/core'
        ],
        resolvers: [ElementPlusResolver()],
        dts: true,
        vueTemplate: true,
        eslintrc: {
          enabled: true,
          filepath: './.eslintrc-auto-import.json',
          globalsPropValue: true
        }
      }),

      // 组件自动导入
      Components({
        resolvers: [
          ElementPlusResolver({
            importStyle: 'sass'
          })
        ],
        dts: true,
        include: [/\\.vue$/, /\\.vue\\?vue/, /\\.tsx$/],
        exclude: [/[\\\\/]node_modules[\\\\/]/, /[\\\\/]\\.git[\\\\/]/, /[\\\\/]\\.nuxt[\\\\/]/]
      })
    ],

    // 构建配置
    build: {
      target: 'es2015',
      cssTarget: 'chrome80',
      outDir: 'dist',
      assetsDir: 'assets',
      minify: 'terser',
      sourcemap: !isBuild,
      chunkSizeWarningLimit: 1500,
      
      // 代码分割
      rollupOptions: {
        output: {
          chunkFileNames: 'assets/js/[name]-[hash].js',
          entryFileNames: 'assets/js/[name]-[hash].js',
          assetFileNames: 'assets/[ext]/[name]-[hash].[ext]',
          manualChunks(id) {
            // 第三方库分包
            if (id.includes('node_modules')) {
              if (id.includes('vue') || id.includes('pinia') || id.includes('vue-router')) {
                return 'vue-vendor'
              }
              if (id.includes('element-plus')) {
                return 'element-plus'
              }
              if (id.includes('echarts')) {
                return 'echarts'
              }
              if (id.includes('axios') || id.includes('socket.io')) {
                return 'network'
              }
              return 'vendor'
            }
          }
        }
      },

      // Terser配置
      terserOptions: {
        compress: {
          drop_console: isBuild,
          drop_debugger: isBuild,
          pure_funcs: isBuild ? ['console.log'] : []
        }
      }
    },

    // 优化配置
    optimizeDeps: {
      include: [
        'vue',
        'vue-router',
        'pinia',
        'element-plus/es',
        'element-plus/es/components/button/style/index',
        'element-plus/es/components/input/style/index',
        'element-plus/es/components/form/style/index',
        'element-plus/es/components/table/style/index',
        'element-plus/es/components/pagination/style/index',
        '@element-plus/icons-vue',
        'axios',
        'dayjs',
        'lodash-es',
        '@vueuse/core'
      ]
    },

    // 定义全局变量
    define: {
      __VUE_OPTIONS_API__: true,
      __VUE_PROD_DEVTOOLS__: false,
      __VERSION__: JSON.stringify(process.env.npm_package_version),
      __BUILD_TIME__: JSON.stringify(new Date().toISOString())
    },

    // 环境变量前缀
    envPrefix: ['VITE_', 'VUE_APP_'],

    // esbuild配置
    esbuild: {
      drop: isBuild ? ['console', 'debugger'] : []
    }
  }
})