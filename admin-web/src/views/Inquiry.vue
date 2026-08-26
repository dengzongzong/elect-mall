<template>
  <div class="inquiry">
    <div class="page-header">
      <div class="page-title">
        <h2>询价管理</h2>
        <p>处理客户提交的询价单，提供快速报价响应。</p>
      </div>
      <el-tag type="danger" size="large" effect="dark">待回复: 8</el-tag>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="询价编号" width="140" />
        <el-table-column prop="customer" label="客户名称" width="150" />
        <el-table-column prop="productName" label="询价商品" min-width="200" />
        <el-table-column prop="quantity" label="数量" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '已回复' ? 'success' : 'warning'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="提交时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === '待回复'" type="danger" link size="small">立即报价</el-button>
            <el-button v-else type="primary" link size="small">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { id: 'INQ-2024001', customer: '深圳华强电子', productName: 'STM32F407VGT6', quantity: 2000, status: '待回复', createTime: '2024-12-15 11:20:00' },
  { id: 'INQ-2024002', customer: '北京中科电子', productName: 'AD9833BRMZ', quantity: 500, status: '已回复', createTime: '2024-12-14 15:30:00' },
  { id: 'INQ-2024003', customer: '上海捷配电子', productName: 'ESP32-WROOM-32', quantity: 5000, status: '待回复', createTime: '2024-12-14 09:10:00' },
  { id: 'INQ-2024004', customer: '广州创芯电子', productName: 'LM2596S-ADJ', quantity: 3000, status: '已回复', createTime: '2024-12-13 16:45:00' }
])
</script>

<style scoped>
.inquiry {
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
</style>