<template>
  <div class="brand">
    <div class="page-header">
      <div class="page-title">
        <h2>品牌管理</h2>
        <p>管理商城中的电子元器件品牌信息。</p>
      </div>
      <el-button type="danger">
        <el-icon><Plus /></el-icon>新增品牌
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="name" label="品牌名称" min-width="160" />
        <el-table-column prop="country" label="国家/地区" width="120" />
        <el-table-column prop="website" label="官方网站" min-width="200">
          <template #default="{ row }">
            <el-link type="primary" :underline="false">{{ row.website }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="productCount" label="商品数量" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '启用' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="danger" link size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: 'STMicroelectronics', country: '瑞士', website: 'www.st.com', productCount: 1250, status: '启用' },
  { name: 'Texas Instruments', country: '美国', website: 'www.ti.com', productCount: 2100, status: '启用' },
  { name: 'Analog Devices', country: '美国', website: 'www.analog.com', productCount: 980, status: '启用' },
  { name: 'NXP Semiconductors', country: '荷兰', website: 'www.nxp.com', productCount: 1560, status: '启用' },
  { name: 'Infineon Technologies', country: '德国', website: 'www.infineon.com', productCount: 870, status: '启用' }
])
</script>

<style scoped>
.brand {
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