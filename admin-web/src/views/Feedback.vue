<template>
  <div class="feedback">
    <div class="page-header">
      <div class="page-title">
        <h2>投诉反馈管理</h2>
        <p>处理用户投诉和反馈意见，维护良好的客户关系。</p>
      </div>
      <div class="header-actions">
        <el-input v-model="keyword" placeholder="搜索反馈..." clearable style="width: 200px" @keyup.enter="fetchFeedbacks" @clear="fetchFeedbacks" />
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
      </div>
      <el-tag type="danger" size="large" effect="dark">待处理: 5</el-tag>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="username" label="用户" width="130" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.type === '投诉' ? 'danger' : 'warning'">{{ row.type }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="250" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '已处理' ? 'success' : 'danger'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="提交时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button v-if="row.status === '待处理'" type="danger" link size="small">立即处理</el-button>
            <el-button v-else type="primary" link size="small">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminFeedbacks, deleteFeedback } from '../api/admin'

const loading = ref(false)
const tableData = ref([])
const keyword = ref('')
const multipleSelection = ref([])

async function fetchFeedbacks() {
  loading.value = true
  try {
    const res = await getAdminFeedbacks({ keyword: keyword.value })
    tableData.value = res.data || []
  } catch (e) {
    console.error('获取反馈列表失败:', e)
  } finally {
    loading.value = false
  }
}

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的记录')
    return
  }
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${multipleSelection.value.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of multipleSelection.value) {
      await deleteFeedback(row.id)
    }
    ElMessage.success('批量删除成功')
    await fetchFeedbacks()
  } catch (e) {
    // 用户取消或删除失败
  }
}

onMounted(() => {
  fetchFeedbacks()
})
</script>

<style scoped>
.feedback {
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

.header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}
</style>