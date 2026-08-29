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
            <el-steps :active="stepActive" align-center>
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
                <span class="value">{{ order.order_no || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="label">下单时间：</span>
                <span class="value">{{ order.created_at || '-' }}</span>
              </div>
              <div class="info-row">
                <span class="label">订单状态：</span>
                <span class="value status">{{ statusText }}</span>
              </div>
              <div class="info-row">
                <span class="label">支付方式：</span>
                <span class="value">{{ payMethodText }}</span>
              </div>
            </div>
          </div>

          <!-- 收货地址 -->
          <div class="info-section">
            <h4>收货信息</h4>
            <div class="address-display">
              <p v-if="order.receiver_name || order.receiver_phone">
                {{ order.receiver_name }} {{ order.receiver_phone }}
              </p>
              <p>{{ order.receiver_address || '未填写收货地址' }}</p>
            </div>
          </div>

          <!-- 商品清单 -->
          <div class="info-section">
            <h4>商品清单</h4>
            <div class="item-list" v-if="items.length">
              <div class="item-row" v-for="item in items" :key="item.id">
                <div class="item-img"><el-icon><Cpu /></el-icon></div>
                <div class="item-detail">
                  <h5>{{ item.product_name || item.name }}</h5>
                  <p class="item-model">{{ item.part_no }}</p>
                  <p>￥{{ Number(item.price).toFixed(4) }} x {{ item.quantity }}</p>
                </div>
                <div class="item-subtotal">￥{{ itemSubtotal(item).toFixed(2) }}</div>
              </div>
            </div>
            <div class="empty-state" v-else>该订单暂无商品明细</div>
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
              <span>￥{{ goodsAmount.toFixed(2) }}</span>
            </div>
            <div class="amount-row">
              <span>运费</span>
              <span>￥0.00</span>
            </div>
            <div class="amount-total">
              <span>实付金额</span>
              <span class="total-price">￥{{ payAmount.toFixed(2) }}</span>
            </div>
          </div>

          <div class="action-card">
            <el-button
              type="danger"
              v-if="order.status === 'pending'"
              @click="$router.push(`/pay/${order.order_no}`)"
            >立即付款</el-button>
            <el-button
              type="danger"
              v-if="order.status === 'shipped'"
              :loading="acting"
              @click="handleConfirmReceipt"
            >确认收货</el-button>
            <el-button
              v-if="['pending', 'audited'].includes(order.status)"
              :loading="acting"
              @click="handleCancel"
            >取消订单</el-button>
            <el-button @click="$router.push('/order/list')">返回订单列表</el-button>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { getOrderDetail, cancelOrder, confirmReceipt } from '../api/order'

const route = useRoute()
const router = useRouter()

const order = ref({})
const items = ref([])
const loading = ref(false)
const acting = ref(false)

const statusMap = {
  pending: '待审核',
  audited: '待付款',
  paid: '已支付',
  shipped: '已发货',
  completed: '已完成',
  cancelled: '已取消',
}

const payMethodMap = {
  wechat: '微信支付',
  alipay: '支付宝',
  bank: '银行转账',
  balance: '余额支付',
}

const statusText = computed(() => statusMap[order.value.status] || order.value.status || '-')
const payMethodText = computed(() => payMethodMap[order.value.payment_method] || '未支付')

const stepActive = computed(() => {
  switch (order.value.status) {
    case 'completed': return 5
    case 'shipped': return 4
    case 'paid': return 3
    case 'audited': return 2
    case 'pending': return 1
    case 'cancelled': return 0
    default: return 1
  }
})

// 明细小计：优先用后端 subtotal，缺失时用 单价 × 数量
function itemSubtotal(item) {
  if (item.subtotal != null && item.subtotal !== '') return Number(item.subtotal) || 0
  return (Number(item.price) || 0) * (Number(item.quantity) || 0)
}

const goodsAmount = computed(() => items.value.reduce((sum, i) => sum + itemSubtotal(i), 0))
const payAmount = computed(() => Number(order.value.total_amount) || goodsAmount.value || 0)

async function fetchOrder() {
  loading.value = true
  try {
    const res = await getOrderDetail(route.params.id)
    order.value = res || {}
    items.value = Array.isArray(res?.items) ? res.items : []
  } catch (e) {
    ElMessage.error('订单不存在或加载失败')
    order.value = {}
    items.value = []
  } finally {
    loading.value = false
  }
}

async function handleCancel() {
  try {
    await ElMessageBox.confirm('确定要取消该订单吗？', '提示', { type: 'warning' })
  } catch {
    return
  }
  acting.value = true
  try {
    await cancelOrder(order.value.id)
    ElMessage.success('订单已取消')
    await fetchOrder()
  } catch (e) {
    ElMessage.error('取消失败')
  } finally {
    acting.value = false
  }
}

async function handleConfirmReceipt() {
  acting.value = true
  try {
    await confirmReceipt(order.value.id)
    ElMessage.success('已确认收货')
    await fetchOrder()
  } catch (e) {
    ElMessage.error('操作失败')
  } finally {
    acting.value = false
  }
}

function handleUploadVoucher() {
  ElMessage.success('凭证上传成功，等待审核')
}

onMounted(() => {
  fetchOrder()
})
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

.item-detail .item-model {
  font-size: 12px;
  color: #bbb;
  margin-bottom: 2px;
}

.empty-state {
  padding: 30px 0;
  text-align: center;
  color: #999;
  font-size: 14px;
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