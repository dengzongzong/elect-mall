<template>
  <div class="cooperate">
    <div class="page-header">
      <div class="page-title">
        <h2>合作品牌管理</h2>
        <p>管理与商城合作的原厂品牌信息，维护品牌合作关系。</p>
      </div>
      <div class="header-actions">
        <el-input v-model="keyword" placeholder="搜索品牌名称" clearable style="width: 200px" @keyup.enter="fetchCooperates" @clear="fetchCooperates" />
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
        <el-button type="danger" @click="handleAdd">
          <el-icon><Plus /></el-icon>新增合作
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="name" label="品牌名称" min-width="180" />
        <el-table-column prop="region" label="所属地区" width="120" />
        <el-table-column prop="contact" label="联系人" width="130" />
        <el-table-column prop="cooperationType" label="合作类型" width="120">
          <template #default="{ row }">
            <el-tag>{{ row.cooperationType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="合作状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '合作中' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="startDate" label="合作开始" width="120" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">终止合作</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑合作品牌' : '新增合作品牌'" width="540px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="品牌名称">
          <el-input v-model="form.name" placeholder="请输入品牌名称" />
        </el-form-item>
        <el-form-item label="所属地区">
          <el-input v-model="form.region" placeholder="请输入所属地区" />
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="form.contact" placeholder="请输入联系人" />
        </el-form-item>
        <el-form-item label="合作类型">
          <el-input v-model="form.cooperationType" placeholder="请输入合作类型" />
        </el-form-item>
        <el-form-item label="合作状态">
          <el-select v-model="form.status" placeholder="请选择合作状态">
            <el-option label="合作中" value="合作中" />
            <el-option label="已终止" value="已终止" />
          </el-select>
        </el-form-item>
        <el-form-item label="合作开始">
          <el-date-picker v-model="form.startDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminCooperates, saveCooperate, deleteCooperate } from '../api/admin'

const tableData = ref([])
const loading = ref(false)
const keyword = ref('')
const multipleSelection = ref([])
const dialogVisible = ref(false)
const form = ref({
  id: null,
  name: '',
  region: '',
  contact: '',
  cooperationType: '',
  status: '合作中',
  startDate: ''
})

async function fetchCooperates() {
  loading.value = true
  try {
    const res = await getAdminCooperates({ keyword: keyword.value })
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取合作品牌列表失败')
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  form.value = { id: null, name: '', region: '', contact: '', cooperationType: '', status: '合作中', startDate: '' }
  dialogVisible.value = true
}

function handleEdit(row) {
  form.value = { ...row }
  dialogVisible.value = true
}

async function handleDelete(row) {
  try {
    await deleteCooperate(row.id)
    ElMessage.success('已终止合作')
    await fetchCooperates()
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的合作品牌')
    return
  }
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${multipleSelection.value.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of multipleSelection.value) {
      await deleteCooperate(row.id)
    }
    ElMessage.success('批量删除成功')
    await fetchCooperates()
  } catch (e) {
    // 用户取消或删除失败
  }
}

async function handleSave() {
  try {
    await saveCooperate(form.value)
    ElMessage.success(form.value.id ? '更新成功' : '新增成功')
    dialogVisible.value = false
    await fetchCooperates()
  } catch (e) {
    ElMessage.error('保存失败')
  }
}

onMounted(() => {
  fetchCooperates()
})
</script>

<style scoped>
.cooperate {
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