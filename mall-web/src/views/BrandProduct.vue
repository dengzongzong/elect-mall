<template>
  <div class="brand-product-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/brand' }">品牌专区</el-breadcrumb-item>
          <el-breadcrumb-item>{{ brandName }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="brand-header">
        <div class="brand-logo-large">{{ brandName.charAt(0) }}</div>
        <div class="brand-info">
          <h2>{{ brandName }}</h2>
          <p>浏览该品牌下的所有产品</p>
        </div>
      </div>
      <div class="product-grid">
        <div class="product-card" v-for="p in products" :key="p.id" @click="$router.push(`/product/${p.id}`)">
          <div class="p-img"><el-icon><Cpu /></el-icon></div>
          <div class="p-info">
            <h4>{{ p.name }}</h4>
            <p class="p-model">{{ p.model }}</p>
            <p class="p-price">￥{{ p.price }}</p>
          </div>
        </div>
      </div>
      <div class="pagination-wrap">
        <el-pagination background layout="prev, pager, next" :total="60" />
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const route = useRoute()

const brandMap = {
  1: 'ST意法半导体', 2: 'TI德州仪器', 3: 'NXP恩智浦', 4: 'Microchip',
  5: 'Infineon英飞凌', 6: 'ADI亚德诺', 7: 'Maxim美信', 8: 'ON安森美',
  9: 'Renesas瑞萨', 10: 'NVIDIA英伟达', 11: 'Xilinx赛灵思', 12: 'Broadcom博通',
}

const brandName = computed(() => brandMap[route.params.id] || '品牌')

const products = ref([
  { id: 101, name: 'STM32F103C8T6', model: 'ARM Cortex-M3', price: 8.50 },
  { id: 102, name: 'STM32F407VGT6', model: 'ARM Cortex-M4', price: 35.00 },
  { id: 103, name: 'STM32H743XIH6', model: 'ARM Cortex-M7', price: 98.00 },
  { id: 104, name: 'STM32G030F6P6', model: 'ARM Cortex-M0+', price: 3.20 },
  { id: 105, name: 'STM32L151C8T6', model: 'ARM Cortex-M3', price: 12.50 },
  { id: 106, name: 'STM32F030F4P6', model: 'ARM Cortex-M0', price: 2.80 },
  { id: 107, name: 'STM32F746NGH6', model: 'ARM Cortex-M7', price: 65.00 },
  { id: 108, name: 'STM32G474RET6', model: 'ARM Cortex-M4', price: 28.00 },
])
</script>

<style scoped>
.brand-product-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

.breadcrumb {
  padding: 16px 0;
}

.brand-header {
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 30px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 20px;
}

.brand-logo-large {
  width: 80px;
  height: 80px;
  line-height: 80px;
  text-align: center;
  background: var(--theme-color-light);
  color: var(--theme-color);
  font-size: 32px;
  font-weight: 700;
  border-radius: 50%;
  flex-shrink: 0;
}

.brand-info h2 {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin-bottom: 4px;
}

.brand-info p {
  font-size: 14px;
  color: #999;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
}

.product-card {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
}

.product-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 12px rgba(230, 0, 18, 0.08);
}

.p-img {
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
}

.p-img .el-icon {
  font-size: 36px;
  color: #ddd;
}

.p-info {
  padding: 12px;
}

.p-info h4 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.p-model {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}

.p-price {
  font-size: 16px;
  font-weight: 700;
  color: var(--theme-color);
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  padding-bottom: 40px;
}
</style>