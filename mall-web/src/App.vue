<template>
  <router-view />
  <CustomerService />
</template>

<script setup>
import CustomerService from './components/CustomerService.vue'
</script>

<style>
/* 默认字体：微软雅黑（Windows 已内置，无需加载字体文件）；
   附带系统字体栈兜底，Mac 回退苹方，英文回退系统无衬线体 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  font-family: 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
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
  --el-font-family: 'Microsoft YaHei', 'PingFang SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}
</style>
