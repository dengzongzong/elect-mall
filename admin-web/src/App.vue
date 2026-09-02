<template>
  <router-view />
</template>

<script setup>
</script>

<style>
/* 全站字体栈：仅 Roboto（本地 @fontpkg/roboto 的 TTF，非 CDN）。
   Roboto 不含中文字形，中文由浏览器默认 CJK 字体回退显示，
   但声明字体栈仅保留 Roboto，满足「只支持 Roboto」要求。 */

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  /* 统一维护一处字体栈，仅 Roboto；Element Plus 变量直接复用 */
  --app-font-family: 'Roboto';
  --app-font-weight-base: 500;        /* 正文加粗（Medium），整体界面更醒目 */
  --app-font-weight-bold: 700;        /* 标题/强调 */
  /* 覆盖 Element Plus 默认字体变量，使按钮/输入框等组件与正文统一 */
  --el-font-family: var(--app-font-family);
  --el-font-weight-primary: var(--app-font-weight-base);
}

html, body, #app {
  height: 100%;
  font-family: var(--app-font-family);
  font-weight: var(--app-font-weight-base);
}

/* button/input 等表单控件的浏览器默认字体不继承 body，需显式继承 */
button, input, textarea, select {
  font-family: inherit;
}

/* 标题与强调文字加粗 */
h1, h2, h3, h4, h5, h6 {
  font-weight: var(--app-font-weight-bold);
}
</style>