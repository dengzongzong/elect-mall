<template>
  <div class="datasheet">
    <div class="page-header">
      <div class="page-title">
        <h2>数据手册管理</h2>
        <p>管理电子元器件的数据手册（Datasheet），支持上传和下载。</p>
      </div>
      <el-button type="danger">
        <el-icon><Upload /></el-icon>上传手册
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="name" label="文档名称" min-width="250" />
        <el-table-column prop="product" label="适用产品" width="200" />
        <el-table-column prop="fileSize" label="文件大小" width="120" />
        <el-table-column prop="uploadTime" label="上传时间" width="180" />
        <el-table-column prop="downloads" label="下载次数" width="100" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small">下载</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAdminDatasheets, deleteDatasheet } from '../api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const tableData = ref([])

async function fetchDatasheets() {
  loading.value = true
  try {
    const res = await getAdminDatasheets()
    tableData.value = res.data?.records || (Array.isArray(res.data) ? res.data : [])
  } catch (e) {
    tableData.value = []
  } finally {
    loading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确定删除「${row.name}」吗？`, '删除确认', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    await deleteDatasheet(row.id)
    ElMessage.success('删除成功')
    await fetchDatasheets()
  } catch (e) {
    // 取消或删除失败，不做处理
  }
}

onMounted(() => {
  fetchDatasheets()
})
</script>

<style scoped>
.datasheet {
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