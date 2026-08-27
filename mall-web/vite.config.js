import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({
  plugins: [
    vue(),
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
  server: {
    port: 8080,
    proxy: {
      '/api': {
        // CRMEB PHP后端地址（PHP内置服务器或Nginx代理）
        target: 'http://localhost:8000',
        changeOrigin: true,
        // 重写路径：/api/xxx -> /api/adapter/xxx
        rewrite: (path) => path.replace(/^\/api\//, '/api/adapter/'),
      },
    },
  },
})