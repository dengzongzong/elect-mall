import { createApp } from 'vue'
// 字体本地自托管，替代原 index.html 中的 Google Fonts CDN 外链：
// 仅 Roboto（取自 @fontpkg/roboto 的 TTF），中文由浏览器默认 CJK 字体回退
import './styles/fonts-roboto.css'
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