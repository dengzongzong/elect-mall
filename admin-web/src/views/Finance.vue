<template>
  <div class="finance" v-loading="loading">
    <div class="page-header">
      <div class="page-title">
        <h2>财务管理</h2>
        <p>查看商城财务数据，包括交易流水、结算管理等。</p>
      </div>
      <el-button type="danger">
        <el-icon><Download /></el-icon>导出报表
      </el-button>
    </div>
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="finance-stat">
            <div class="finance-stat-label">本月收入</div>
            <div class="finance-stat-value" style="color: #52c41a;">{{ stats.monthlyIncome }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="finance-stat">
            <div class="finance-stat-label">本月支出</div>
            <div class="finance-stat-value" style="color: #E60012;">{{ stats.monthlyExpense }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="finance-stat">
            <div class="finance-stat-label">本月利润</div>
            <div class="finance-stat-value" style="color: #1890ff;">{{ stats.monthlyProfit }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="finance-stat">
            <div class="finance-stat-label">待结算金额</div>
            <div class="finance-stat-value" style="color: #faad14;">{{ stats.pendingSettlement }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-card shadow="hover" class="table-card">
      <template #header>
        <span>交易流水</span>
      </template>
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="流水号" width="180" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.type === '收入' ? 'success' : 'danger'">{{ row.type }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="amount" label="金额" width="120">
          <template #default="{ row }">
            <span :style="{ color: row.type === '收入' ? '#52c41a' : '#E60012' }">
              {{ row.type === '收入' ? '+' : '-' }}¥{{ row.amount }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="说明" min-width="200" />
        <el-table-column prop="createTime" label="时间" width="180" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getFinanceData } from '../api/admin'

const loading = ref(false)
const stats = ref({
  monthlyIncome: '¥ 0',
  monthlyExpense: '¥ 0',
  monthlyProfit: '¥ 0',
  pendingSettlement: '¥ 0'
})
const tableData = ref([])

async function fetchFinanceData() {
  loading.value = true
  try {
    const res = await getFinanceData()
    stats.value = res.data.stats
    tableData.value = res.data.transactions
  } catch (e) {
    console.error('获取财务数据失败', e)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchFinanceData()
})
</script>

<style scoped>
.finance {
  max-width: 1400px;
}

.page-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 20px;
}

.page-title h2 {
  font-size: 22px;
  color: #303133;
  margin-bottom: 8px;
}

.page-title p {
  font-size: 14px;
  color: #909399;
}

.stats-row {
  margin-bottom: 20px;
}

.finance-stat {
  text-align: center;
  padding: 8px 0;
}

.finance-stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.finance-stat-value {
  font-size: 24px;
  font-weight: bold;
}

.table-card {
  border-radius: 8px;
}
</style>