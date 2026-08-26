<template>
  <div class="checkout-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/cart' }">购物车</el-breadcrumb-item>
          <el-breadcrumb-item>确认订单</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="checkout-layout">
        <div class="checkout-main">
          <!-- 收货地址 -->
          <div class="checkout-section">
            <h4>收货地址</h4>
            <div class="address-list">
              <div class="address-card" :class="{ selected: selectedAddress === 1 }" @click="selectedAddress = 1">
                <div class="address-info">
                  <span class="name">张三</span>
                  <span class="phone">138****8888</span>
                  <span class="tag">默认</span>
                </div>
                <p class="address-detail">广东省深圳市南山区科技园南路100号</p>
              </div>
              <el-button class="add-address-btn" @click="showAddressDialog = true">
                <el-icon><Plus /></el-icon> 新增地址
              </el-button>
            </div>
          </div>

          <!-- 商品清单 -->
          <div class="checkout-section">
            <h4>商品清单</h4>
            <div class="order-items">
              <div class="order-item" v-for="item in cartStore.items" :key="item.id">
                <div class="item-img"><el-icon><Cpu /></el-icon></div>
                <div class="item-info">
                  <h5>{{ item.name }}</h5>
                  <p>x{{ item.quantity }}</p>
                </div>
                <div class="item-price">￥{{ (item.price * item.quantity).toFixed(2) }}</div>
              </div>
            </div>
          </div>

          <!-- 备注 -->
          <div class="checkout-section">
            <h4>订单备注</h4>
            <el-input v-model="remark" type="textarea" :rows="3" placeholder="请填写备注信息（可选）" />
          </div>
        </div>

        <!-- 订单摘要 -->
        <div class="checkout-sidebar">
          <div class="summary-card">
            <h4>订单摘要</h4>
            <div class="summary-row">
              <span>商品数量</span>
              <span>{{ cartStore.count }} 件</span>
            </div>
            <div class="summary-row">
              <span>商品金额</span>
              <span>￥{{ cartStore.total.toFixed(2) }}</span>
            </div>
            <div class="summary-row">
              <span>运费</span>
              <span>￥0.00</span>
            </div>
            <div class="summary-total">
              <span>应付总额</span>
              <span class="total-price">￥{{ cartStore.total.toFixed(2) }}</span>
            </div>
            <el-button type="danger" size="large" class="submit-btn" @click="handleSubmit">提交订单</el-button>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'

const router = useRouter()
const cartStore = useCartStore()
const selectedAddress = ref(1)
const remark = ref('')
const showAddressDialog = ref(false)

function handleSubmit() {
  if (cartStore.items.length === 0) {
    ElMessage.warning('购物车是空的')
    return
  }
  // 模拟提交订单
  const orderNo = 'ORD' + Date.now()
  ElMessage.success('订单提交成功')
  router.push(`/pay/${orderNo}`)
}
</script>

<style scoped>
.checkout-page {
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

.checkout-layout {
  display: flex;
  gap: 24px;
  padding-bottom: 40px;
}

.checkout-main {
  flex: 1;
}

.checkout-section {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 16px;
}

.checkout-section h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.address-list {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.address-card {
  width: 280px;
  padding: 16px;
  border: 2px solid #eee;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.address-card.selected {
  border-color: var(--theme-color);
  background: var(--theme-color-light);
}

.address-card:hover {
  border-color: var(--theme-color);
}

.address-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}

.phone {
  font-size: 13px;
  color: #888;
}

.tag {
  font-size: 11px;
  color: var(--theme-color);
  background: var(--theme-color-light);
  padding: 1px 6px;
  border-radius: 2px;
}

.address-detail {
  font-size: 13px;
  color: #666;
}

.add-address-btn {
  width: 280px;
  height: 80px;
  border: 2px dashed #ddd;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  color: #999;
}

.add-address-btn:hover {
  border-color: var(--theme-color);
  color: var(--theme-color);
}

.order-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
}

.order-item:last-child {
  border-bottom: none;
}

.item-img {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border-radius: 4px;
}

.item-img .el-icon {
  font-size: 24px;
  color: #ddd;
}

.item-info {
  flex: 1;
}

.item-info h5 {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.item-info p {
  font-size: 12px;
  color: #999;
}

.item-price {
  font-size: 15px;
  font-weight: 600;
  color: var(--theme-color);
}

.checkout-sidebar {
  width: 340px;
  flex-shrink: 0;
}

.summary-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  position: sticky;
  top: 100px;
}

.summary-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
}

.summary-total {
  display: flex;
  justify-content: space-between;
  font-size: 15px;
  font-weight: 600;
  color: #333;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
  margin-top: 16px;
  margin-bottom: 20px;
}

.total-price {
  font-size: 24px;
  font-weight: 700;
  color: var(--theme-color);
}

.submit-btn {
  width: 100%;
  height: 44px;
  font-size: 16px;
  font-weight: 600;
}
</style>