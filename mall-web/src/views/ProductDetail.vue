<template>
  <div class="product-detail-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: `/category/1` }">MCU微控制器</el-breadcrumb-item>
          <el-breadcrumb-item>STM32F103C8T6</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div v-if="loading" class="loading-area">
        <el-skeleton :rows="5" animated />
      </div>
      <div v-else-if="!product" class="empty-area">
        <el-empty description="商品不存在" />
      </div>
      <div v-else class="detail-layout">
        <!-- 产品图片 -->
        <div class="product-gallery">
          <div class="main-image">
            <el-icon class="product-img-icon"><Cpu /></el-icon>
          </div>
          <div class="thumb-list">
            <div class="thumb-item active"><el-icon><Cpu /></el-icon></div>
            <div class="thumb-item"><el-icon><Cpu /></el-icon></div>
            <div class="thumb-item"><el-icon><Cpu /></el-icon></div>
            <div class="thumb-item"><el-icon><Cpu /></el-icon></div>
          </div>
        </div>
        <!-- 产品信息 -->
        <div class="product-info">
          <h2 class="product-title">{{ product.name || product.partNo }}</h2>
          <p class="product-desc">{{ product.description || '' }}</p>
          <div class="price-section">
            <div class="price-row">
              <span class="label">零售价：</span>
              <span class="price">￥{{ product.price }}</span>
            </div>
            <div class="price-row" v-if="product.bulkPrice">
              <span class="label">批量价：</span>
              <span class="bulk-price">￥{{ product.bulkPrice }}</span>
            </div>
          </div>
          <div class="info-section">
            <div class="info-row">
              <span class="label">品牌：</span>
              <span class="value">{{ product.brandName || '通用' }}</span>
            </div>
            <div class="info-row" v-if="product.packageType">
              <span class="label">封装：</span>
              <span class="value">{{ product.packageType }}</span>
            </div>
            <div class="info-row">
              <span class="label">库存：</span>
              <span class="value stock">现货 {{ product.stock || 0 }}+ PCS</span>
            </div>
            <div class="info-row">
              <span class="label">起订量：</span>
              <span class="value">{{ product.minOrder || 1 }} PCS</span>
            </div>
          </div>
          <div class="action-section">
            <div class="quantity-row">
              <span class="label">数量：</span>
              <el-input-number v-model="quantity" :min="1" :max="9999" size="large" />
            </div>
            <div class="action-btns">
              <el-button type="danger" size="large" @click="handleAddCart">加入购物车</el-button>
              <el-button type="danger" size="large" plain @click="$router.push('/checkout')">立即购买</el-button>
              <el-button size="large" plain @click="$router.push('/inquiry')">我要询价</el-button>
            </div>
          </div>
        </div>
      </div>
      <!-- 产品详情 -->
      <div class="detail-tabs">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="产品描述" name="desc">
            <div class="tab-content">
              <h4>STM32F103C8T6 技术参数</h4>
              <table class="param-table">
                <tr><td>核心</td><td>ARM Cortex-M3</td></tr>
                <tr><td>主频</td><td>72 MHz</td></tr>
                <tr><td>Flash</td><td>64 KB</td></tr>
                <tr><td>SRAM</td><td>20 KB</td></tr>
                <tr><td>封装</td><td>LQFP-48</td></tr>
                <tr><td>工作电压</td><td>2.0V - 3.6V</td></tr>
                <tr><td>I/O引脚数</td><td>37</td></tr>
                <tr><td>接口</td><td>I2C, SPI, USART, USB, CAN</td></tr>
                <tr><td>ADC</td><td>2 x 12-bit, 10通道</td></tr>
                <tr><td>工作温度</td><td>-40°C ~ +85°C</td></tr>
              </table>
            </div>
          </el-tab-pane>
          <el-tab-pane label="数据手册" name="datasheet">
            <div class="tab-content">
              <p>数据手册正在加载中...</p>
              <el-button type="primary" plain>下载数据手册 (PDF)</el-button>
            </div>
          </el-tab-pane>
          <el-tab-pane label="询价" name="inquiry">
            <div class="tab-content">
              <p>如需批量采购，请提交询价单</p>
              <el-button type="danger" @click="$router.push('/inquiry')">提交询价</el-button>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'
import { getProductDetail } from '../api/product'
import { addToCart } from '../api/cart'

const route = useRoute()
const cartStore = useCartStore()
const quantity = ref(1)
const activeTab = ref('desc')
const product = ref(null)
const loading = ref(true)

async function fetchProduct() {
  try {
    const res = await getProductDetail(route.params.id)
    if (res.data) {
      product.value = res.data
    } else if (res.success !== false) {
      product.value = res
    }
  } catch (e) {
    ElMessage.error('获取商品详情失败')
  } finally {
    loading.value = false
  }
}

async function handleAddCart() {
  if (!product.value) return
  try {
    await addToCart(product.value.id, quantity.value)
  } catch (e) {
    // fallback to local cart
  }
  cartStore.addItem({
    id: product.value.id,
    name: product.value.name,
    price: product.value.price,
    quantity: quantity.value,
    stock: product.value.stock || 0,
    image: '',
  })
  ElMessage.success('已加入购物车')
}

onMounted(() => {
  fetchProduct()
})
</script>

<style scoped>
.product-detail-page {
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

.detail-layout {
  display: flex;
  gap: 40px;
  background: #fff;
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 20px;
}

.product-gallery {
  width: 400px;
  flex-shrink: 0;
}

.main-image {
  height: 360px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border-radius: 8px;
  margin-bottom: 12px;
  border: 1px solid #eee;
}

.product-img-icon {
  font-size: 80px;
  color: #ddd;
}

.thumb-list {
  display: flex;
  gap: 10px;
}

.thumb-item {
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid #eee;
  border-radius: 4px;
  cursor: pointer;
  transition: border-color 0.2s;
}

.thumb-item.active,
.thumb-item:hover {
  border-color: var(--theme-color);
}

.thumb-item .el-icon {
  font-size: 28px;
  color: #ccc;
}

.product-info {
  flex: 1;
}

.product-title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.product-desc {
  font-size: 14px;
  color: #888;
  margin-bottom: 20px;
  line-height: 1.6;
}

.price-section {
  background: var(--theme-color-light);
  padding: 16px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.price-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}

.price-row:last-child {
  margin-bottom: 0;
}

.price-row .label {
  font-size: 14px;
  color: #666;
}

.price {
  font-size: 28px;
  font-weight: 700;
  color: var(--theme-color);
}

.bulk-price {
  font-size: 16px;
  color: var(--theme-color);
}

.info-section {
  margin-bottom: 20px;
}

.info-row {
  display: flex;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #f5f5f5;
}

.info-row .label {
  width: 80px;
  font-size: 14px;
  color: #999;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.info-row .stock {
  color: #52c41a;
  font-weight: 600;
}

.action-section {
  margin-top: 20px;
}

.quantity-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.quantity-row .label {
  font-size: 14px;
  color: #666;
}

.action-btns {
  display: flex;
  gap: 12px;
}

.detail-tabs {
  background: #fff;
  border-radius: 8px;
  padding: 20px 30px;
  margin-bottom: 40px;
}

.tab-content {
  padding: 20px 0;
}

.param-table {
  width: 100%;
  border-collapse: collapse;
}

.param-table td {
  padding: 10px 16px;
  border: 1px solid #f0f0f0;
  font-size: 14px;
}

.param-table td:first-child {
  background: #fafafa;
  color: #999;
  width: 150px;
}

.param-table td:last-child {
  color: #333;
}
</style>