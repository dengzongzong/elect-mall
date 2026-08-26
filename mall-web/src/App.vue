<template>
  <router-view />
  <CustomerService />
</template>

<script setup>
import CustomerService from './components/CustomerService.vue'
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
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