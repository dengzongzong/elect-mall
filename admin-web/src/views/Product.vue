<template>
  <div class="product">
    <div class="page-header">
      <div class="page-title">
        <h2>商品管理</h2>
        <p>管理商城中的所有商品信息，包括新增、编辑、上下架等操作。</p>
      </div>
      <div class="page-actions">
        <el-button type="danger" @click="handleImport">
          <el-icon><Upload /></el-icon>导入商品
        </el-button>
        <el-button type="primary">
          <el-icon><Plus /></el-icon>新增商品
        </el-button>
      </div>
    </div>
    <el-card shadow="hover" class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="商品名称">
          <el-input v-model="searchForm.name" placeholder="请输入商品名称" clearable />
        </el-form-item>
        <el-form-item label="商品分类">
          <el-select v-model="searchForm.category" placeholder="请选择分类" clearable>
            <el-option label="集成电路" value="ic" />
            <el-option label="被动元件" value="passive" />
            <el-option label="连接器" value="connector" />
            <el-option label="传感器" value="sensor" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="上架" value="on" />
            <el-option label="下架" value="off" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary">搜索</el-button>
          <el-button>重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <el-card shadow="hover" class="table-card">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="商品编号" width="120" />
        <el-table-column prop="name" label="商品名称" min-width="200" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="brand" label="品牌" width="120" />
        <el-table-column prop="price" label="价格" width="120">
          <template #default="{ row }">
            ¥{{ row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '上架' ? 'success' : 'info'">
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="danger" link size="small">下架</el-button>
            <el-button type="warning" link size="small">删除</el-button>
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
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

const searchForm = reactive({
  name: '',
  category: '',
  status: ''
})

const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(100)

const tableData = ref([
  { id: 'EC-001', name: 'STM32F103C8T6 微控制器', category: '集成电路', brand: 'ST', price: 12.50, stock: 5000, status: '上架' },
  { id: 'EC-002', name: 'AMS1117-3.3 稳压器', category: '集成电路', brand: 'AMS', price: 0.85, stock: 12000, status: '上架' },
  { id: 'EC-003', name: 'RC0805 10KΩ 贴片电阻', category: '被动元件', brand: 'Yageo', price: 0.05, stock: 50000, status: '上架' },
  { id: 'EC-004', name: 'XH2.54-2P 接线端子', category: '连接器', brand: 'JST', price: 0.35, stock: 8000, status: '下架' },
  { id: 'EC-005', name: 'DHT22 温湿度传感器', category: '传感器', brand: 'Aosong', price: 8.90, stock: 2000, status: '上架' }
])

function handleImport() {
  ElMessage.info('导入商品功能开发中')
}
</script>

<style scoped>
.product {
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

.page-actions {
  display: flex;
  gap: 12px;
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

.table-card {
  border-radius: 8px;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>