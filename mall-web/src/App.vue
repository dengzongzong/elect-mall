<template>
  <router-view />
  <CustomerService />
</template>

<script setup>
import CustomerService from './components/CustomerService.vue'
</script>

<style>
/* 全站字体：Roboto（Google Fonts）优先，负责拉丁字符与数字；
   Roboto 不含中文字形，中文自动回退到微软雅黑（Win）/苹方（Mac）。
   若 Google Fonts 加载失败，整体回退系统字体栈，不影响可读性。 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  font-family: 'Roboto', 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
  color: #333;
  background-color: #f5f5f5;
}

#app {
  height: 100%;
}

a {
  text-decoration: none;
  color: inherit;
}

/* button/input 等表单控件的浏览器默认字体不继承 body，需显式继承 */
button, input, textarea, select {
  font-family: inherit;
}

:root {
  --theme-color: #E60012;
  --theme-color-hover: #cc0010;
  --theme-color-light: #fff1f0;
  /* 覆盖 Element Plus 默认字体变量，使按钮/输入框等组件与正文统一 */
  --el-font-family: 'Roboto', 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
}
</style>
