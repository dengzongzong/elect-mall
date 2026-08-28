<template>
  <div class="carousel">
    <div class="page-header">
      <div class="page-title">
        <h2>轮播图管理</h2>
        <p>管理首页轮播图，支持添加、编辑、删除和排序。</p>
      </div>
      <el-button type="danger" @click="handleAdd">
        <el-icon><Plus /></el-icon>新增轮播图
      </el-button>
    </div>
    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="image_url" label="图片预览" width="160">
          <template #default="{ row }">
            <el-image v-if="row.image_url" :src="row.image_url" style="width: 120px; height: 60px" fit="cover" />
            <span v-else style="color:#999">暂无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="180" />
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
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入轮播图标题" />
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            class="avatar-uploader"
            action="/admin/adapter/upload"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :before-upload="beforeUpload"
          >
            <img v-if="form.image_url" :src="form.image_url" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="图片URL" prop="image_url">
          <el-input v-model="form.image_url" placeholder="上传图片或直接输入图片URL" />
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
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCarousels, saveCarousel, deleteCarousel, uploadFile } from '../api/admin'

const loading = ref(false)
const saving = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const form = ref({
  id: null,
  title: '',
  image_url: '',
  link: '',
  sort: 0,
  status: 1
})

const rules = {
  title: [
    { required: true, message: '请输入轮播图标题', trigger: 'blur' },
    { min: 2, max: 50, message: '标题长度应在 2-50 个字符之间', trigger: 'blur' }
  ],
  image_url: [
    { required: true, message: '请上传图片或输入图片URL', trigger: 'blur' },
    { pattern: /^https?:\/\/.+/, message: '图片URL必须以 http:// 或 https:// 开头', trigger: 'blur' }
  ]
}

const uploadHeaders = computed(() => ({
  token: localStorage.getItem('admin_token') || ''
}))

async function fetchData() {
  loading.value = true
  try {
    const res = await getCarousels()
    tableData.value = res.data || []
  } catch (e) {
    ElMessage.error('获取轮播图列表失败')
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  dialogTitle.value = '新增轮播图'
  form.value = { id: null, title: '', image_url: '', link: '', sort: 0, status: 1 }
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑轮播图'
  form.value = { ...row }
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

function handleUploadSuccess(res) {
  if (res.data?.url) {
    form.value.image_url = res.data.url
    ElMessage.success('上传成功')
  }
}

function beforeUpload(file) {
  const isImage = file.type.startsWith('image/')
  if (!isImage) { ElMessage.error('只能上传图片文件'); return false }
  return true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    await saveCarousel(form.value)
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
  ElMessageBox.confirm(`确定删除轮播图「${row.title}」？`, '确认删除', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteCarousel(row.id)
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
.carousel {
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
.link-text {
  font-size: 12px;
  color: #1677ff;
  word-break: break-all;
}
.avatar-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  width: 240px;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.avatar-uploader:hover {
  border-color: #E60012;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
}
.avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>