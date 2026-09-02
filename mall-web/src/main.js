import { createApp } from 'vue'
// 字体本地自托管，替代原 index.html 中的 Google Fonts CDN 外链：
// Roboto       覆盖拉丁字符、数字、元器件型号；只用 latin 子集，体积极小
// Noto Sans SC 覆盖中文（思源黑体），101 个 unicode-range 分片按需下载
// 字重 400/700 即可覆盖项目实际使用的 400/500/600/700（按 CSS 字重匹配规则，500→400、600→700）
import '@fontsource/roboto/latin-400.css'
import '@fontsource/roboto/latin-500.css'
import '@fontsource/roboto/latin-700.css'
import './styles/fonts-noto-sc.css'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'

const app = createApp(App)

// 注册所有 Element Plus 图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(createPinia())
app.use(router)
app.use(ElementPlus, { locale: zhCn })
app.mount('#app')