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
import { ref, onMounted } from 'vue'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getOrderList } from '../api/order'

const activeTab = ref('all')
const orders = ref([])
const loading = ref(false)

const statusMap = {
  '待审核': { text: '待审核', cls: 'pending' },
  '待付款': { text: '待付款', cls: 'unpaid' },
  '待发货': { text: '待发货', cls: 'shipping' },
  '待收货': { text: '待收货', cls: 'received' },
  '已完成': { text: '已完成', cls: 'completed' },
  '已取消': { text: '已取消', cls: 'cancelled' },
  'paid': { text: '已支付', cls: 'paid' },
}

async function fetchOrders() {
  loading.value = true
  try {
    const res = await getOrderList()
    // 接口经响应拦截器后返回 { records, total, ... }，订单数组在 records 中
    const list = res?.records || res?.data?.records || []
    if (list.length) {
      orders.value = list.map(order => ({
        ...order,
        statusText: statusMap[order.status]?.text || order.status,
        statusClass: statusMap[order.status]?.cls || 'pending',
        items: order.items || [],
        totalQty: (order.items || []).reduce((sum, item) => sum + (item.quantity || 0), 0),
      }))
    }
  } catch (e) {
    // ignore
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchOrders()
})
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