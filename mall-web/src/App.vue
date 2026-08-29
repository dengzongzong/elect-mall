<template>
  <router-view />
  <CustomerService />
</template>

<script setup>
import CustomerService from './components/CustomerService.vue'
</script>

<style>
/* 与 digikey.cn 一致的系统字体栈：英文优先 Roboto/Noto Sans（本机已装才生效），
   中文不加载任何字体文件，回退到系统默认（Windows 为微软雅黑，Mac 为苹方） */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  font-family: Roboto, 'Noto Sans', 'Helvetica Neue', Arial, 'PingFang SC', 'Microsoft YaHei', sans-serif;
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
  --el-font-family: Roboto, 'Noto Sans', 'Helvetica Neue', Arial, 'PingFang SC', 'Microsoft YaHei', sans-serif;
}
</style>
