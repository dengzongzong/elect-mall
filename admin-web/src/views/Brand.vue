<template>
  <div class="brand">
    <div class="page-header">
      <div class="page-title">
        <h2>品牌管理</h2>
        <p>管理商城中的电子元器件品牌信息。</p>
      </div>
      <el-button type="danger" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增品牌
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="name" label="品牌名称" min-width="160" />
        <el-table-column prop="logo" label="品牌Logo" width="200">
          <template #default="{ row }">
            <el-link type="primary" :underline="false">{{ row.logo }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '停用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="isCooperate" label="合作品牌" width="100">
          <template #default="{ row }">
            <el-tag :type="row.isCooperate === 1 ? 'success' : 'info'">{{ row.isCooperate === 1 ? '是' : '否' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="品牌名称" required>
          <el-input v-model="form.name" placeholder="请输入品牌名称" />
        </el-form-item>
        <el-form-item label="品牌Logo">
          <el-input v-model="form.logo" placeholder="请输入Logo URL" />
        </el-form-item>
        <el-form-item label="品牌描述">
          <el-input v-model="form.description" type="textarea" placeholder="请输入品牌描述" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">启用</el-radio>
            <el-radio :value="0">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="合作品牌">
          <el-radio-group v-model="form.isCooperate">
            <el-radio :value="1">是</el-radio>
            <el-radio :value="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminBrands, saveBrand } from '../api/admin'
import request from '../api/request'

const loading = ref(false)
const saving = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('新增品牌')
const form = ref({
  id: null,
  name: '',
  logo: '',
  description: '',
  sort: 0,
  status: 1,
  isCooperate: 0
})

async function fetchBrands() {
  loading.value = true
  try {
    const res = await getAdminBrands()
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取品牌列表失败')
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  dialogTitle.value = '新增品牌'
  form.value = { id: null, name: '', logo: '', description: '', sort: 0, status: 1, isCooperate: 0 }
  dialogVisible.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑品牌'
  form.value = { ...row }
  dialogVisible.value = true
}

async function handleSave() {
  saving.value = true
  try {
    await saveBrand(form.value)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await fetchBrands()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确定要删除品牌「${row.name}」吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    await request.delete('/brand/delete', { data: { id: row.id } })
    ElMessage.success('删除成功')
    await fetchBrands()
  } catch (e) {
    // 用户取消删除或删除失败，不做处理
  }
}

onMounted(() => {
  fetchBrands()
})
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
