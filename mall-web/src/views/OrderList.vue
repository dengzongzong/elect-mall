<template>
  <div class="order-list-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>我的订单</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>我的订单</h3>
        <el-tabs v-model="activeTab" class="order-tabs">
          <el-tab-pane label="待审核" name="pending">
            <div class="empty-state" v-if="orders.length === 0">
              <el-icon><Folder /></el-icon>
              <p>暂无待审核订单</p>
            </div>
          </el-tab-pane>
          <el-tab-pane label="待付款" name="unpaid">
            <div class="order-list">
              <div class="order-card" v-for="order in orders" :key="order.id">
                <div class="order-header">
                  <span class="order-no">订单号：{{ order.orderNo }}</span>
                  <span class="order-status unpaid">待付款</span>
                </div>
                <div class="order-body">
                  <div class="order-item" v-for="item in order.items" :key="item.id">
                    <div class="item-img"><el-icon><Cpu /></el-icon></div>
                    <div class="item-info">
                      <h5>{{ item.name }}</h5>
                      <p>x{{ item.qty }}</p>
                    </div>
                    <div class="item-price">￥{{ item.price }}</div>
                  </div>
                </div>
                <div class="order-footer">
                  <span class="order-total">共 {{ order.totalQty }} 件商品 合计：<em>￥{{ order.totalAmount }}</em></span>
                  <div class="order-actions">
                    <el-button type="danger" @click="$router.push(`/pay/${order.orderNo}`)">立即付款</el-button>
                    <el-button @click="$router.push(`/order/${order.id}`)">订单详情</el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          <el-tab-pane label="待发货" name="shipping">
            <div class="empty-state"><el-icon><Folder /></el-icon><p>暂无待发货订单</p></div>
          </el-tab-pane>
          <el-tab-pane label="待收货" name="received">
            <div class="empty-state"><el-icon><Folder /></el-icon><p>暂无待收货订单</p></div>
          </el-tab-pane>
          <el-tab-pane label="全部" name="all">
            <div class="order-list">
              <div class="order-card" v-for="order in orders" :key="order.id">
                <div class="order-header">
                  <span class="order-no">订单号：{{ order.orderNo }}</span>
                  <span class="order-status" :class="order.statusClass">{{ order.statusText }}</span>
                </div>
                <div class="order-body">
                  <div class="order-item" v-for="item in order.items" :key="item.id">
                    <div class="item-img"><el-icon><Cpu /></el-icon></div>
                    <div class="item-info">
                      <h5>{{ item.name }}</h5>
                      <p>x{{ item.qty }}</p>
                    </div>
                    <div class="item-price">￥{{ item.price }}</div>
                  </div>
                </div>
                <div class="order-footer">
                  <span class="order-total">共 {{ order.totalQty }} 件商品 合计：<em>￥{{ order.totalAmount }}</em></span>
                  <div class="order-actions">
                    <el-button @click="$router.push(`/order/${order.id}`)">订单详情</el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const activeTab = ref('unpaid')

const orders = ref([
  {
    id: 1001,
    orderNo: 'ORD20240315001',
    statusText: '待付款',
    statusClass: 'unpaid',
    totalQty: 3,
    totalAmount: '56.00',
    items: [
      { id: 1, name: 'STM32F103C8T6', qty: 2, price: '17.00' },
      { id: 2, name: 'AMS1117-3.3', qty: 10, price: '3.50' },
      { id: 3, name: 'DS18B20', qty: 5, price: '14.00' },
    ],
  },
  {
    id: 1002,
    orderNo: 'ORD20240314002',
    statusText: '待审核',
    statusClass: 'pending',
    totalQty: 5,
    totalAmount: '120.00',
    items: [
      { id: 4, name: 'ESP32-WROOM-32', qty: 5, price: '90.00' },
      { id: 5, name: 'BMP280', qty: 5, price: '22.50' },
    ],
  },
])
</script>

<style scoped>
.order-list-page {
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

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 40px;
}

.page-card h3 {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin-bottom: 20px;
}

.order-tabs :deep(.el-tabs__item) {
  font-size: 15px;
}

.order-tabs :deep(.el-tabs__item.is-active) {
  color: var(--theme-color);
}

.order-tabs :deep(.el-tabs__active-bar) {
  background: var(--theme-color);
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #ccc;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.order-card {
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  margin-bottom: 16px;
  overflow: hidden;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: #fafafa;
  border-bottom: 1px solid #f0f0f0;
}

.order-no {
  font-size: 13px;
  color: #888;
}

.order-status {
  font-size: 14px;
  font-weight: 600;
}

.order-status.unpaid {
  color: var(--theme-color);
}

.order-status.pending {
  color: #faad14;
}

.order-body {
  padding: 16px 20px;
}

.order-item {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
}

.order-item:last-child {
  margin-bottom: 0;
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
  margin-bottom: 2px;
}

.item-info p {
  font-size: 12px;
  color: #999;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  border-top: 1px solid #f0f0f0;
  background: #fafafa;
}

.order-total {
  font-size: 13px;
  color: #666;
}

.order-total em {
  font-style: normal;
  font-size: 18px;
  font-weight: 700;
  color: var(--theme-color);
}

.order-actions {
  display: flex;
  gap: 10px;
}
</style>