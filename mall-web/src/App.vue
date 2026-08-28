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
/* 引入鸿蒙黑体 HarmonyOS Sans via CDN */
@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('https://cdn.jsdelivr.net/npm/@arietta-studio/webfont-harmony-sans-sc@1.0.3/fonts/HarmonyOS_Sans_SC_Regular.woff2') format('woff2');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('https://cdn.jsdelivr.net/npm/@arietta-studio/webfont-harmony-sans-sc@1.0.3/fonts/HarmonyOS_Sans_SC_Medium.woff2') format('woff2');
  font-weight: 500;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'HarmonyOS Sans';
  src: url('https://cdn.jsdelivr.net/npm/@arietta-studio/webfont-harmony-sans-sc@1.0.3/fonts/HarmonyOS_Sans_SC_Bold.woff2') format('woff2');
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

:root {
  --theme-color: #E60012;
  --theme-color-hover: #cc0010;
  --theme-color-light: #fff1f0;
}
</style>