<template>
  <div class="order-detail-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/order/list' }">我的订单</el-breadcrumb-item>
          <el-breadcrumb-item>订单详情</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="detail-layout">
        <div class="detail-main">
          <!-- 订单状态 -->
          <div class="order-status-bar">
            <el-steps :active="1" align-center>
              <el-step title="提交订单" />
              <el-step title="等待审核" />
              <el-step title="已付款" />
              <el-step title="已发货" />
              <el-step title="已完成" />
            </el-steps>
          </div>

          <!-- 订单信息 -->
          <div class="info-section">
            <h4>订单信息</h4>
            <div class="info-grid">
              <div class="info-row">
                <span class="label">订单编号：</span>
                <span class="value">ORD20240315001</span>
              </div>
              <div class="info-row">
                <span class="label">下单时间：</span>
                <span class="value">2024-03-15 14:30:25</span>
              </div>
              <div class="info-row">
                <span class="label">订单状态：</span>
                <span class="value status">待审核</span>
              </div>
              <div class="info-row">
                <span class="label">支付方式：</span>
                <span class="value">微信支付</span>
              </div>
            </div>
          </div>

          <!-- 收货地址 -->
          <div class="info-section">
            <h4>收货信息</h4>
            <div class="address-display">
              <p>张三 138****8888</p>
              <p>广东省深圳市南山区科技园南路100号</p>
            </div>
          </div>

          <!-- 商品清单 -->
          <div class="info-section">
            <h4>商品清单</h4>
            <div class="item-list">
              <div class="item-row" v-for="item in orderItems" :key="item.id">
                <div class="item-img"><el-icon><Cpu /></el-icon></div>
                <div class="item-detail">
                  <h5>{{ item.name }}</h5>
                  <p>￥{{ item.price }} x {{ item.qty }}</p>
                </div>
                <div class="item-subtotal">￥{{ (item.price * item.qty).toFixed(2) }}</div>
              </div>
            </div>
          </div>

          <!-- 上传凭证 -->
          <div class="info-section">
            <h4>付款凭证</h4>
            <div class="voucher-upload">
              <el-upload
                action="#"
                list-type="picture-card"
                :auto-upload="false"
                :limit="3"
              >
                <el-icon><Plus /></el-icon>
              </el-upload>
              <p class="upload-tip" v-if="false">支持 JPG/PNG/PDF 格式，文件大小不超过 5MB</p>
              <el-button type="danger" v-if="true" @click="handleUploadVoucher">上传凭证</el-button>
            </div>
          </div>
        </div>

        <!-- 订单金额 -->
        <div class="detail-sidebar">
          <div class="amount-card">
            <h4>订单金额</h4>
            <div class="amount-row">
              <span>商品金额</span>
              <span>￥56.00</span>
            </div>
            <div class="amount-row">
              <span>运费</span>
              <span>￥0.00</span>
            </div>
            <div class="amount-total">
              <span>实付金额</span>
              <span class="total-price">￥56.00</span>
            </div>
          </div>

          <div class="action-card">
            <el-button type="danger" @click="$router.push('/pay/ORD20240315001')" v-if="false">立即付款</el-button>
            <el-button @click="$router.push('/order/list')">返回订单列表</el-button>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const orderItems = ref([
  { id: 1, name: 'STM32F103C8T6', price: 8.50, qty: 2 },
  { id: 2, name: 'AMS1117-3.3', price: 0.35, qty: 10 },
  { id: 3, name: 'DS18B20', price: 2.80, qty: 5 },
])

function handleUploadVoucher() {
  ElMessage.success('凭证上传成功，等待审核')
}
</script>

<style scoped>
.order-detail-page {
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
  gap: 24px;
  padding-bottom: 40px;
}

.detail-main {
  flex: 1;
}

.order-status-bar {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
  margin-bottom: 16px;
}

.info-section {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 16px;
}

.info-section h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.info-grid {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.info-row {
  display: flex;
  align-items: center;
}

.info-row .label {
  width: 100px;
  font-size: 14px;
  color: #999;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.info-row .value.status {
  color: #faad14;
  font-weight: 600;
}

.address-display p {
  font-size: 14px;
  color: #333;
  line-height: 28px;
}

.item-list {
  display: flex;
  flex-direction: column;
}

.item-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
}

.item-row:last-child {
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

.item-detail {
  flex: 1;
}

.item-detail h5 {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.item-detail p {
  font-size: 13px;
  color: #999;
}

.item-subtotal {
  font-size: 15px;
  font-weight: 600;
  color: var(--theme-color);
}

.voucher-upload {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.upload-tip {
  font-size: 12px;
  color: #bbb;
}

.detail-sidebar {
  width: 320px;
  flex-shrink: 0;
}

.amount-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 16px;
}

.amount-card h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.amount-row {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
}

.amount-total {
  display: flex;
  justify-content: space-between;
  font-size: 15px;
  font-weight: 600;
  color: #333;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
  margin-top: 16px;
}

.total-price {
  font-size: 22px;
  font-weight: 700;
  color: var(--theme-color);
}

.action-card {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.action-card .el-button {
  width: 100%;
}
</style>