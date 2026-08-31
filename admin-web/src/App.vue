<template>
  <router-view />
</template>

<script setup>
</script>

<style>
/* 全站字体：Roboto（Google Fonts，index.html 中引入）优先，负责拉丁字符与数字；
   Roboto 不含中文字形，中文自动回退到微软雅黑（Win）/苹方（Mac）。
   若 Google Fonts 加载失败，整体回退系统字体栈，不影响可读性。 */

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  /* 覆盖 Element Plus 默认字体变量，使按钮/输入框等组件与正文统一 */
  --el-font-family: 'Roboto', 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, Helvetica, sans-serif;
}

html, body, #app {
  height: 100%;
  font-family: 'Roboto', 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, Helvetica, sans-serif;
}

/* button/input 等表单控件的浏览器默认字体不继承 body，需显式继承 */
button, input, textarea, select {
  font-family: inherit;
}
</style>