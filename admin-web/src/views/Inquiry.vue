<template>
  <div class="inquiry">
    <div class="page-header">
      <div class="page-title">
        <h2>询价管理</h2>
        <p>处理客户提交的询价单，提供快速报价响应。</p>
      </div>
      <el-tag type="danger" size="large" effect="dark">待回复: {{ pendingCount }}</el-tag>
    </div>
    <el-card shadow="hover">
      <el-table v-loading="loading" :data="tableData" stripe style="width: 100%">
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
            <el-button v-if="row.status === '待回复'" type="danger" link size="small" @click="handleReply(row)">立即报价</el-button>
            <el-button v-else type="primary" link size="small" @click="handleReply(row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="replyDialogVisible" :title="replyDialogTitle" width="500px">
      <el-form :model="replyForm" label-width="80px">
        <el-form-item label="客户名称">
          <el-input :model-value="currentRow?.customer" disabled />
        </el-form-item>
        <el-form-item label="询价商品">
          <el-input :model-value="currentRow?.productName" disabled />
        </el-form-item>
        <el-form-item label="回复内容">
          <el-input v-model="replyForm.content" type="textarea" :rows="4" placeholder="请输入报价回复内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="replyDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submitReply">确认回复</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getAdminInquiries, replyInquiry } from '../api/admin'

const loading = ref(false)
const submitting = ref(false)
const tableData = ref([])
const replyDialogVisible = ref(false)
const currentRow = ref(null)
const replyForm = ref({
  content: ''
})

const pendingCount = computed(() => {
  return tableData.value.filter(item => item.status === '待回复').length
})

const replyDialogTitle = computed(() => {
  return currentRow.value?.status === '待回复' ? '回复询价' : '询价详情'
})

async function fetchInquiries() {
  loading.value = true
  try {
    const res = await getAdminInquiries()
    tableData.value = res.data?.records || (Array.isArray(res.data) ? res.data : [])
  } catch (e) {
    ElMessage.error('获取询价单列表失败')
    tableData.value = []
  } finally {
    loading.value = false
  }
}

function handleReply(row) {
  currentRow.value = row
  replyForm.value.content = ''
  replyDialogVisible.value = true
}

async function submitReply() {
  if (!replyForm.value.content.trim()) {
    ElMessage.warning('请输入回复内容')
    return
  }
  submitting.value = true
  try {
    await replyInquiry(currentRow.value.id, replyForm.value.content)
    ElMessage.success('回复成功')
    replyDialogVisible.value = false
    await fetchInquiries()
  } catch (e) {
    ElMessage.error('回复失败，请重试')
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  fetchInquiries()
})
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