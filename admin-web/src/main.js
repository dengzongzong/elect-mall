import { createApp } from 'vue'
// 字体本地自托管，替代原 index.html 中的 Google Fonts CDN 外链：
// Roboto       覆盖拉丁字符、数字、元器件型号（字体文件取自 @fontpkg/roboto 的 TTF）
// Noto Sans SC 覆盖中文（思源黑体），101 个 unicode-range 分片按需下载
import './styles/fonts-roboto.css'
import './styles/fonts-noto-sc.css'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './api/request'

const app = createApp(App)

// 注册所有 Element Plus 图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(ElementPlus)
app.use(createPinia())
app.use(router)
app.mount('#app')