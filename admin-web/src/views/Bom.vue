<template>
  <div class="bom">
    <div class="page-header">
      <div class="page-title">
        <h2>BOM管理</h2>
        <p>管理物料清单（Bill of Materials），支持BOM导入、匹配和报价。</p>
      </div>
      <div class="page-actions">
        <el-button type="danger">
          <el-icon><Upload /></el-icon>导入BOM
        </el-button>
        <el-button type="primary">
          <el-icon><Plus /></el-icon>新建BOM
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="BOM编号" width="140" />
        <el-table-column prop="name" label="BOM名称" min-width="200" />
        <el-table-column prop="itemCount" label="物料数量" width="100" />
        <el-table-column prop="totalPrice" label="预估总价" width="120">
          <template #default="{ row }">
            ¥{{ row.totalPrice }}
          </template>
        </el-table-column>
        <el-table-column prop="creator" label="创建人" width="120" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small">查看详情</el-button>
            <el-button type="success" link size="small">一键询价</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAdminBomList, deleteBom } from '../api/admin'

const loading = ref(false)
const tableData = ref([])

const fetchBomList = async () => {
  loading.value = true
  try {
    const res = await getAdminBomList()
    tableData.value = res.data || res
  } catch (e) {
    console.error('获取BOM列表失败', e)
  } finally {
    loading.value = false
  }
}

const handleDelete = async (row) => {
  try {
    await deleteBom(row.id)
    tableData.value = tableData.value.filter(item => item.id !== row.id)
  } catch (e) {
    console.error('删除BOM失败', e)
  }
}

onMounted(() => {
  fetchBomList()
})
</script>

<style scoped>
.bom {
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
</style>