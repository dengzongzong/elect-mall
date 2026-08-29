<template>
  <router-view />
  <RightSidebar />
  <CustomerService />
</template>

<script setup>
import RightSidebar from './components/RightSidebar.vue'
import CustomerService from './components/CustomerService.vue'
</script>

<style>
/* 引入鸿蒙黑体 HarmonyOS Sans (本地字体) */
@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('/fonts/HarmonyOS_Sans_SC_Regular.woff2') format('woff2');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('/fonts/HarmonyOS_Sans_SC_Medium.woff2') format('woff2');
  font-weight: 500;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('/fonts/HarmonyOS_Sans_SC_Bold.woff2') format('woff2');
  font-weight: bold;
  font-style: normal;
  font-display: swap;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  font-family: 'HarmonyOS Sans', 'PingFang SC', 'Microsoft YaHei', Arial, Helvetica, sans-serif;
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

/* button/input 等表单控件的浏览器默认字体是 Arial 且不继承 body，需显式继承 */
button, input, textarea, select {
  font-family: inherit;
}

:root {
  --theme-color: #E60012;
  --theme-color-hover: #cc0010;
  --theme-color-light: #fff1f0;
  /* 覆盖 Element Plus 默认字体变量，使按钮/输入框等组件与正文统一使用鸿蒙黑体 */
  --el-font-family: 'HarmonyOS Sans', 'PingFang SC', 'Microsoft YaHei', Arial, Helvetica, sans-serif;
}
</style>