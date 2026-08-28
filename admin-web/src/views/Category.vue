<template>
  <div class="category">
    <div class="page-header">
      <div class="page-title">
        <h2>分类管理</h2>
        <p>管理电子元器件的分类体系，支持多级分类结构。</p>
      </div>
      <el-button type="danger" @click="handleAddRoot">
        <el-icon><Plus /></el-icon>新增分类
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table
        v-loading="loading"
        :data="tableData"
        stripe
        row-key="id"
        :tree-props="{ children: 'children' }"
        style="width: 100%"
      >
        <el-table-column prop="name" label="分类名称" min-width="200" />
        <el-table-column prop="parent_id" label="层级" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.parent_id === 0 || !row.parent_id" type="danger" size="small">1级-大类</el-tag>
            <el-tag v-else-if="row.children" type="warning" size="small">2级-品牌</el-tag>
            <el-tag v-else type="info" size="small">3级-细分</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '禁用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="success" link size="small" @click="handleAddSub(row)">新增子类</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑分类对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" :max="999" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">启用</el-radio>
            <el-radio :value="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminCategories, saveCategory, deleteCategory } from '../api/admin'

const loading = ref(false)
const saving = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({
  id: null,
  parentId: null,
  name: '',
  prefix: '',
  sort: 0,
  status: 1
})

const rules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
}

async function fetchCategories() {
  loading.value = true
  try {
    const res = await getAdminCategories()
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取分类列表失败')
  } finally {
    loading.value = false
  }
}

function openDialog(title, row) {
  dialogTitle.value = title
  form.value = {
    id: row?.id || null,
    parentId: row?.parentId ?? row?.parent_id ?? 0,
    name: row?.name || '',
    prefix: row?.prefix || '',
    sort: row?.sort ?? 0,
    status: row?.status ?? 1
  }
  dialogVisible.value = true
}

function handleAddRoot() {
  openDialog('新增分类', { parentId: 0, sort: 0 })
}

function handleEdit(row) {
  openDialog('编辑分类', row)
}

function handleAddSub(row) {
  openDialog('新增子分类', { parentId: row.id, sort: 0 })
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    await saveCategory(form.value)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await fetchCategories()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

function handleDelete(row) {
  ElMessageBox.confirm(`确定删除分类「${row.name}」？`, '确认删除', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteCategory(row.id)
      ElMessage.success('删除成功')
      await fetchCategories()
    } catch (e) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

onMounted(() => {
  fetchCategories()
})
</script>

<style scoped>
.category {
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
