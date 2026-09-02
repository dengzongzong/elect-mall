<template>
  <router-view />
</template>

<script setup>
</script>

<style>
/* 全站字体栈（本地 npm 包，非 CDN，国内访问无需外网）：
   Roboto       —— 拉丁字符与数字，型号/参数辨识度优于雅黑
   Noto Sans SC —— 中文（思源黑体），Roboto 无中文字形会自动回退到它
   两者均按 unicode-range 分片按需加载，首屏只下载页面实际用到的分片。
   后续微软雅黑/苹方仅作为未覆盖字形的兜底。 */

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  /* 统一维护一处字体栈，Element Plus 变量直接复用 */
  --app-font-family: 'Roboto', 'Noto Sans SC', 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, Helvetica, sans-serif;
  /* 覆盖 Element Plus 默认字体变量，使按钮/输入框等组件与正文统一 */
  --el-font-family: var(--app-font-family);
}

html, body, #app {
  height: 100%;
  font-family: var(--app-font-family);
}

/* button/input 等表单控件的浏览器默认字体不继承 body，需显式继承 */
button, input, textarea, select {
  font-family: inherit;
}
</style>