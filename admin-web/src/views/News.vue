<template>
  <div class="news">
    <div class="page-header">
      <div class="page-title">
        <h2>新闻管理</h2>
        <p>发布和管理商城新闻资讯、行业动态等内容。</p>
      </div>
      <el-button type="danger" @click="handleAdd">
        <el-icon><Edit /></el-icon>新增新闻
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" stripe v-loading="loading" style="width: 100%">
        <el-table-column prop="id" label="编号" width="80" />
        <el-table-column prop="title" label="新闻标题" min-width="280" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '已发布' : '草稿' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="新闻标题">
          <el-input v-model="form.title" placeholder="请输入新闻标题" />
        </el-form-item>
        <el-form-item label="新闻内容">
          <el-input v-model="form.content" type="textarea" :rows="5" placeholder="请输入新闻内容" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">已发布</el-radio>
            <el-radio :value="0">草稿</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAdminNews, saveNews, deleteNews } from '../api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const form = ref({
  id: null,
  title: '',
  content: '',
  status: 1
})

async function fetchNews() {
  loading.value = true
  try {
    const res = await getAdminNews()
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取新闻列表失败')
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  dialogTitle.value = '新增新闻'
  form.value = { id: null, title: '', content: '', status: 1 }
  dialogVisible.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑新闻'
  form.value = { ...row }
  dialogVisible.value = true
}

async function handleSave() {
  try {
    await saveNews(form.value)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await fetchNews()
  } catch (e) {
    ElMessage.error('保存失败')
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm('确认删除该新闻吗？', '提示', { type: 'warning' })
    await deleteNews(row.id)
    ElMessage.success('删除成功')
    await fetchNews()
  } catch (e) {
    // 取消删除或删除失败均不做处理
  }
}

onMounted(() => {
  fetchNews()
})
</script>

<style scoped>
.news {
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
