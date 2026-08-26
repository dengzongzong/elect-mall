<template>
  <div class="user-balance">
    <div class="section-card">
      <h4>账户余额</h4>
      <div class="balance-display">
        <span class="balance-label">可用余额</span>
        <span class="balance-amount">￥{{ balance }}</span>
      </div>
      <div class="balance-actions">
        <el-button type="danger">充值</el-button>
        <el-button>提现</el-button>
      </div>
      <div class="balance-records">
        <h5>余额记录</h5>
        <div class="record-item" v-for="(r, idx) in records" :key="idx">
          <div class="record-info">
            <span class="record-desc">{{ r.desc }}</span>
            <span class="record-time">{{ r.time }}</span>
          </div>
          <span class="record-amount" :class="r.type">￥{{ r.amount }}</span>
        </div>
      </div>
      <div class="pagination-wrap">
        <el-pagination background small layout="prev, pager, next" :total="20" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const balance = ref('1280.50')

const records = ref([
  { desc: '在线支付 - 订单 ORD20240315001', time: '2024-03-15 14:30', amount: '56.00', type: 'expense' },
  { desc: '余额充值', time: '2024-03-10 10:00', amount: '500.00', type: 'income' },
  { desc: '退款 - 订单 ORD20240308001', time: '2024-03-09 16:20', amount: '120.00', type: 'income' },
  { desc: '在线支付 - 订单 ORD20240305001', time: '2024-03-05 09:15', amount: '35.00', type: 'expense' },
])
</script>

<style scoped>
.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
}

.section-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.balance-display {
  text-align: center;
  padding: 30px 0;
  background: #fafafa;
  border-radius: 8px;
  margin-bottom: 20px;
}

.balance-label {
  display: block;
  font-size: 14px;
  color: #999;
  margin-bottom: 8px;
}

.balance-amount {
  font-size: 42px;
  font-weight: 700;
  color: var(--theme-color);
}

.balance-actions {
  display: flex;
  gap: 12px;
  margin-bottom: 30px;
}

.balance-records h5 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
}

.record-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px solid #f5f5f5;
}

.record-desc {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.record-time {
  font-size: 12px;
  color: #999;
}

.record-amount {
  font-size: 16px;
  font-weight: 600;
}

.record-amount.income {
  color: #52c41a;
}

.record-amount.expense {
  color: var(--theme-color);
}

.pagination-wrap {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
</style>