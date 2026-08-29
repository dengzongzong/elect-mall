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
        <div class="record-item" v-for="r in records" :key="r.id">
          <div class="record-info">
            <span class="record-desc">{{ r.remark || '余额变动' }}</span>
            <span class="record-time">{{ r.created_at }}</span>
          </div>
          <span class="record-amount" :class="Number(r.amount) >= 0 ? 'income' : 'expense'">￥{{ Math.abs(Number(r.amount)).toFixed(2) }}</span>
        </div>
        <div class="empty-state" v-if="records.length === 0">
          <p>暂无余额变动记录</p>
        </div>
      </div>
      <div class="pagination-wrap">
        <el-pagination background small layout="prev, pager, next" :total="20" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getBalanceLog } from '../api/user'
import { getUserInfo } from '../api/auth'

const balance = ref('0.00')
const records = ref([])

async function fetchBalance() {
  try {
    const res = await getUserInfo()
    balance.value = Number(res?.balance ?? 0).toFixed(2)
  } catch (e) {
    balance.value = '0.00'
  }
}

async function fetchRecords() {
  try {
    const res = await getBalanceLog()
    records.value = Array.isArray(res) ? res : []
  } catch (e) {
    records.value = []
  }
}

onMounted(() => {
  fetchBalance()
  fetchRecords()
})
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