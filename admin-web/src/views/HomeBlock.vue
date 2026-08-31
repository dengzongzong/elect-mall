<template>
  <div class="home-block">
    <div class="page-header">
      <div class="page-title">
        <h2>首页配置</h2>
        <p>管理首页轮播图下方的右侧广告位与卖点文案，支持新增、编辑、删除和排序。</p>
      </div>
      <div class="header-actions">
        <el-select v-model="blockKeyFilter" placeholder="全部类型" clearable style="width: 160px" @change="fetchData">
          <el-option label="侧边广告" value="side_ad" />
          <el-option label="卖点文案" value="feature" />
        </el-select>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>新增配置
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column label="类型" width="120">
          <template #default="{ row }">
            <el-tag :type="row.block_key === 'side_ad' ? 'warning' : 'success'">{{ blockKeyLabel(row.block_key) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="180" />
        <el-table-column prop="tag" label="标签" width="120">
          <template #default="{ row }">
            <span v-if="row.tag">{{ row.tag }}</span>
            <span v-else style="color:#999">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="link" label="链接" min-width="200">
          <template #default="{ row }">
            <span v-if="row.link" class="link-text">{{ row.link }}</span>
            <span v-else style="color:#999">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">{{ row.status === 1 ? '启用' : '停用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="类型" prop="block_key">
          <el-select v-model="form.block_key" placeholder="请选择类型" style="width: 100%">
            <el-option label="侧边广告" value="side_ad" />
            <el-option label="卖点文案" value="feature" />
          </el-select>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.desc" type="textarea" :rows="2" placeholder="描述 / 副标题（可选）" />
        </el-form-item>
        <template v-if="form.block_key === 'side_ad'">
          <el-form-item label="标签">
            <el-input v-model="form.tag" placeholder="如：限时特惠" />
          </el-form-item>
          <el-form-item label="标签底色">
            <el-input v-model="form.tag_bg" placeholder="如 #E60012 或渐变" />
          </el-form-item>
          <el-form-item label="背景">
            <el-input v-model="form.bg" placeholder="背景色 / 背景图URL（可选）" />
          </el-form-item>
        </template>
        <el-form-item v-else label="图标">
          <el-input v-model="form.icon" placeholder="Element Plus 图标名，如 Truck" />
        </el-form-item>
        <el-form-item label="链接">
          <el-input v-model="form.link" placeholder="点击跳转链接（可选）" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" :max="999" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">启用</el-radio>
            <el-radio :value="0">停用</el-radio>
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
import { getHomeBlocks, saveHomeBlock, deleteHomeBlock } from '../api/admin'

const loading = ref(false)
const saving = ref(false)
const tableData = ref([])
const blockKeyFilter = ref('')
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({
  id: null,
  block_key: 'side_ad',
  title: '',
  desc: '',
  tag: '',
  tag_bg: '',
  link: '',
  bg: '',
  icon: '',
  sort: 0,
  status: 1
})

const rules = {
  block_key: [{ required: true, message: '请选择类型', trigger: 'change' }],
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }]
}

function blockKeyLabel(key) {
  return key === 'side_ad' ? '侧边广告' : key === 'feature' ? '卖点文案' : key
}

async function fetchData() {
  loading.value = true
  try {
    const params = {}
    if (blockKeyFilter.value) params.block_key = blockKeyFilter.value
    const res = await getHomeBlocks(params)
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取配置列表失败')
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  dialogTitle.value = '新增配置'
  form.value = { id: null, block_key: 'side_ad', title: '', desc: '', tag: '', tag_bg: '', link: '', bg: '', icon: '', sort: 0, status: 1 }
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑配置'
  form.value = { ...row }
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    await saveHomeBlock(form.value)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await fetchData()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

function handleDelete(row) {
  ElMessageBox.confirm(`确定删除「${row.title}」？`, '确认删除', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteHomeBlock(row.id)
      ElMessage.success('删除成功')
      await fetchData()
    } catch (e) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

onMounted(() => { fetchData() })
</script>

<style scoped>
.home-block {
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
.link-text {
  font-size: 12px;
  color: #1677ff;
  word-break: break-all;
}
</style>
