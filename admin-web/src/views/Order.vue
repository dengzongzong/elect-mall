<template>
  <div class="order">
    <div class="page-header">
      <div class="page-title">
        <h2>订单管理</h2>
        <p>管理所有客户订单，包括订单审核、发货、退款等操作。</p>
      </div>
      <el-button type="danger">
        <el-icon><Download /></el-icon>导出订单
      </el-button>
    </div>
    <el-card shadow="hover" class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="订单编号">
          <el-input v-model="searchForm.orderNo" placeholder="请输入订单编号" clearable />
        </el-form-item>
        <el-form-item label="订单状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="待付款" value="pending" />
            <el-option label="待发货" value="shipping" />
            <el-option label="已发货" value="delivered" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="下单时间">
          <el-date-picker v-model="searchForm.dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="orderNo" label="订单编号" width="180" />
        <el-table-column prop="customer" label="客户" width="130" />
        <el-table-column prop="totalAmount" label="订单金额" width="120">
          <template #default="{ row }">
            ¥{{ row.totalAmount }}
          </template>
        </el-table-column>
        <el-table-column prop="itemCount" label="商品数量" width="100" />
        <el-table-column prop="status" label="订单状态" width="120">
          <template #default="{ row }">
            <el-tag :type="statusMap[row.status]?.type || 'info'">{{ statusMap[row.status]?.label || row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="$router.push(`/order/${row.id}`)">查看详情</el-button>
            <el-button v-if="row.status === '待审核'" type="warning" link size="small" @click="handleAudit(row.id)">审核</el-button>
            <el-button v-if="row.status === '待发货'" type="success" link size="small" @click="handleShip(row.id)">发货</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          layout="total, prev, pager, next, jumper"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getAdminOrders, auditOrder, shipOrder } from '../api/admin'

const searchForm = reactive({
  orderNo: '',
  status: '',
  dateRange: null
})

const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const loading = ref(false)

const statusMap = {
  '待审核': { label: '待审核', type: 'warning' },
  '待付款': { label: '待付款', type: 'warning' },
  '待发货': { label: '待发货', type: 'danger' },
  '待收货': { label: '已发货', type: 'primary' },
  '已完成': { label: '已完成', type: 'success' },
  '已取消': { label: '已取消', type: 'info' }
}

const tableData = ref([])

async function fetchOrders() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
    }
    if (searchForm.orderNo) params.keyword = searchForm.orderNo
    if (searchForm.status) params.status = searchForm.status

    const res = await getAdminOrders(params)
    if (res.data) {
      if (res.data.records) {
        tableData.value = res.data.records
        total.value = res.data.total || 0
      } else {
        tableData.value = res.data
      }
    }
  } catch (e) {
    // ignore
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  currentPage.value = 1
  fetchOrders()
}

function handleReset() {
  searchForm.orderNo = ''
  searchForm.status = ''
  searchForm.dateRange = null
  currentPage.value = 1
  fetchOrders()
}

async function handleAudit(id) {
  try {
    await auditOrder(id)
    ElMessage.success('审核通过')
    fetchOrders()
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

async function handleShip(id) {
  try {
    await shipOrder(id)
    ElMessage.success('已发货')
    fetchOrders()
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  fetchOrders()
})
</script>

<style scoped>
.order {
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

.search-card {
  margin-bottom: 20px;
  border-radius: 8px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>