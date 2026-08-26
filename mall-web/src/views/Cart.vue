<template>
  <div class="cart-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>购物车</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>我的购物车</h3>
        <div v-if="cartStore.items.length === 0" class="empty-cart">
          <el-icon class="empty-icon"><ShoppingCart /></el-icon>
          <p>购物车还是空的</p>
          <el-button type="danger" @click="$router.push('/')">去逛逛</el-button>
        </div>
        <template v-else>
          <div class="cart-table">
            <div class="cart-header">
              <span class="col-product">商品信息</span>
              <span class="col-price">单价</span>
              <span class="col-qty">数量</span>
              <span class="col-total">小计</span>
              <span class="col-action">操作</span>
            </div>
            <div class="cart-item" v-for="item in cartStore.items" :key="item.id">
              <div class="col-product">
                <div class="item-img"><el-icon><Cpu /></el-icon></div>
                <div class="item-info">
                  <h4>{{ item.name }}</h4>
                  <p class="item-model">型号: {{ item.name }}</p>
                </div>
              </div>
              <div class="col-price">￥{{ item.price.toFixed(2) }}</div>
              <div class="col-qty">
                <el-input-number v-model="item.quantity" :min="1" :max="item.stock" size="small" @change="updateQty(item)" />
              </div>
              <div class="col-total">￥{{ (item.price * item.quantity).toFixed(2) }}</div>
              <div class="col-action">
                <el-button type="danger" link @click="handleRemove(item.id)">删除</el-button>
              </div>
            </div>
          </div>
          <div class="cart-footer">
            <div class="cart-footer-left">
              <el-button @click="cartStore.clearCart()">清空购物车</el-button>
            </div>
            <div class="cart-footer-right">
              <div class="cart-summary">
                <span>共 <em>{{ cartStore.count }}</em> 件商品</span>
                <span>合计：<em class="total-price">￥{{ cartStore.total.toFixed(2) }}</em></span>
              </div>
              <el-button type="danger" size="large" @click="$router.push('/checkout')">去结算</el-button>
            </div>
          </div>
        </template>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'
import { useCartStore } from '../stores/cart'

const cartStore = useCartStore()

function updateQty(item) {
  cartStore.saveToLocal()
}

function handleRemove(id) {
  ElMessageBox.confirm('确定要删除该商品吗？', '提示', {
    type: 'warning',
  }).then(() => {
    cartStore.removeItem(id)
    ElMessage.success('已删除')
  }).catch(() => {})
}
</script>

<style scoped>
.cart-page {
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

.empty-cart {
  text-align: center;
  padding: 80px 0;
}

.empty-icon {
  font-size: 64px;
  color: #ddd;
  margin-bottom: 16px;
}

.empty-cart p {
  font-size: 16px;
  color: #999;
  margin-bottom: 20px;
}

.cart-header {
  display: flex;
  align-items: center;
  padding: 12px 0;
  background: #fafafa;
  border-radius: 4px;
  font-size: 13px;
  color: #888;
  font-weight: 600;
}

.cart-item {
  display: flex;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #f5f5f5;
}

.col-product { flex: 3; display: flex; align-items: center; gap: 12px; padding: 0 12px; }
.col-price { flex: 1; text-align: center; color: #666; }
.col-qty { flex: 1; text-align: center; }
.col-total { flex: 1; text-align: center; color: var(--theme-color); font-weight: 600; }
.col-action { flex: 0.8; text-align: center; }

.item-img {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border-radius: 4px;
}

.item-img .el-icon {
  font-size: 28px;
  color: #ddd;
}

.item-info h4 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.item-model {
  font-size: 12px;
  color: #999;
}

.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20px;
  border-top: 2px solid #f0f0f0;
  margin-top: 10px;
}

.cart-footer-right {
  display: flex;
  align-items: center;
  gap: 24px;
}

.cart-summary {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
  font-size: 14px;
  color: #666;
}

.cart-summary em {
  font-style: normal;
  color: var(--theme-color);
}

.total-price {
  font-size: 24px;
  font-weight: 700;
}
</style>