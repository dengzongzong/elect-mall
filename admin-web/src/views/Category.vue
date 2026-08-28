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
        <el-table-column label="详情" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.description" type="success" size="small">已编辑</el-tag>
            <el-tag v-else type="info" size="small">无</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="420" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="success" link size="small" @click="handleAddSub(row)">新增子类</el-button>
            <el-button type="warning" link size="small" @click="handleEditDescription(row)">编辑详情</el-button>
            <el-button type="info" link size="small" @click="handlePreview(row)">预览</el-button>
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

    <!-- 编辑详情对话框 -->
    <el-dialog
      v-model="descDialogVisible"
      title="编辑分类详情"
      width="860px"
      :close-on-click-modal="false"
      :before-close="beforeCloseDescDialog"
    >
      <el-form label-width="100px">
        <el-form-item label="分类名称">
          <el-tag>{{ descForm.name }}</el-tag>
        </el-form-item>
        <el-form-item label="分类详情">
          <div class="desc-editor">
            <QuillEditor
              ref="quillRef"
              v-model:content="descForm.description"
              content-type="html"
              :options="editorOptions"
              class="rich-editor"
              @focus="onEditorFocus"
            />
            <div class="desc-upload">
              <el-upload
                action="/admin/adapter/upload"
                :headers="uploadHeaders"
                :show-file-list="false"
                :on-success="handleImageUploadSuccess"
              >
                <el-button size="small" type="primary">上传图片</el-button>
              </el-upload>
              <span class="upload-tip">点击工具栏「图片」按钮或点此上传，支持 JPG/PNG/GIF，图片会自动插入到光标位置</span>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="descDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSaveDescription">保存</el-button>
      </template>
    </el-dialog>

    <!-- 分类预览对话框 -->
    <el-dialog
      v-model="previewVisible"
      :title="'预览：' + previewForm.name"
      width="800px"
      :close-on-click-modal="false"
      top="40px"
    >
      <div class="preview-wrapper">
        <div class="preview-breadcrumb">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item>全部产品分类</el-breadcrumb-item>
            <el-breadcrumb-item v-if="previewParent">{{ previewParent.name }}</el-breadcrumb-item>
            <el-breadcrumb-item>{{ previewForm.name }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="preview-content" v-html="previewForm.description || '暂无详情内容'"></div>
        <div class="preview-note" v-if="!previewForm.description">
          <el-empty description="该分类尚未编辑详情内容" />
        </div>
      </div>
      <template #footer>
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="primary" @click="handleEditDescription(previewForm._row)">编辑详情</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminCategories, saveCategory, deleteCategory } from '../api/admin'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'

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
  description: '',
  sort: 0,
  status: 1
})

const descDialogVisible = ref(false)
const descForm = ref({
  id: null,
  name: '',
  description: ''
})
const quillRef = ref(null)

const editorOptions = {
  modules: {
    toolbar: {
      container: [
        [{ header: [1, 2, 3, false] }],
        ['bold', 'italic', 'underline', 'strike'],
        [{ color: [] }, { background: [] }],
        [{ list: 'ordered' }, { list: 'bullet' }],
        [{ align: [] }],
        ['blockquote', 'code-block'],
        [{ indent: '-1' }, { indent: '+1' }],
        ['link', 'image'],
        ['table'],
        ['clean']
      ],
      handlers: {
        table: function() {
          const quill = this.quill
          const range = quill.getSelection(true)
          const tableHTML = '<table style="border-collapse:collapse;width:100%;margin:10px 0;" border="1" cellpadding="8" cellspacing="0"><tbody>'
            + '<tr><td style="border:1px solid #ddd;padding:8px;background:#f5f5f5;font-weight:600;">标题1</td><td style="border:1px solid #ddd;padding:8px;background:#f5f5f5;font-weight:600;">标题2</td><td style="border:1px solid #ddd;padding:8px;background:#f5f5f5;font-weight:600;">标题3</td></tr>'
            + '<tr><td style="border:1px solid #ddd;padding:8px;">内容1</td><td style="border:1px solid #ddd;padding:8px;">内容2</td><td style="border:1px solid #ddd;padding:8px;">内容3</td></tr>'
            + '<tr><td style="border:1px solid #ddd;padding:8px;">内容4</td><td style="border:1px solid #ddd;padding:8px;">内容5</td><td style="border:1px solid #ddd;padding:8px;">内容6</td></tr>'
            + '</tbody></table>'
          quill.clipboard.dangerouslyPasteHTML(range.index, tableHTML)
        },
        image: function() {
          // 点击图片按钮 → 直接触发文件上传
          setTimeout(() => {
            document.querySelector('.desc-upload .el-upload input')?.click()
          }, 100)
        }
      }
    }
  },
  placeholder: '请输入分类详情内容...'
}

function onEditorFocus() {
}

function beforeCloseDescDialog() {
  descDialogVisible.value = false
}

const previewVisible = ref(false)
const previewForm = ref({ name: '', description: '' })
const previewParent = ref(null)

const uploadHeaders = computed(() => ({
  token: localStorage.getItem('admin_token') || ''
}))

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

function handleEditDescription(row) {
  descForm.value = {
    id: row.id,
    name: row.name,
    description: row.description || ''
  }
  descDialogVisible.value = true
}

function handlePreview(row) {
  previewForm.value = {
    name: row.name,
    description: row.description || '',
    _row: row
  }
  // 查找父分类
  const findParent = (id, list) => {
    for (const item of list) {
      if (item.id === id) return item
      if (item.children) {
        const found = findParent(id, item.children)
        if (found) return found
      }
    }
    return null
  }
  previewParent.value = row.parent_id && row.parent_id !== '0'
    ? findParent(row.parent_id, tableData.value)
    : null
  previewVisible.value = true
}

function handleImageUploadSuccess(res) {
  if (res.data?.url) {
    // Insert image into Quill editor at cursor position
    const quill = quillRef.value?.getQuill()
    if (quill) {
      const imgTag = `<img src="${res.data.url}" alt="图片" style="max-width:100%;border:1px solid #eee;margin:10px 0;" />`
      const range = quill.getSelection()
      quill.clipboard.dangerouslyPasteHTML(range ? range.index : quill.getLength(), imgTag)
    }
    ElMessage.success('图片已插入')
  }
}

async function handleSaveDescription() {
  saving.value = true
  try {
    await saveCategory(descForm.value)
    ElMessage.success('保存成功')
    descDialogVisible.value = false
    await fetchCategories()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
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

.desc-editor {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}

.rich-editor {
  min-height: 550px;
  background: #fff;
}

:deep(.quill) {
  height: auto;
}

:deep(.quill .ql-container) {
  min-height: 480px;
  font-size: 14px;
}

:deep(.quill .ql-editor) {
  min-height: 480px;
}

.desc-upload {
  padding: 8px 12px;
  border-bottom: 1px solid #dcdfe6;
  background: #fafafa;
  display: flex;
  align-items: center;
  gap: 12px;
}

.desc-upload .upload-tip {
  font-size: 12px;
  color: #909399;
}

/* 表格内图片样式 */
:deep(.ql-editor td img) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 4px auto;
}

.preview-wrapper {
  padding: 0;
}

.preview-breadcrumb {
  padding: 12px 16px;
  background: #f8f8f8;
  border-radius: 4px;
  margin-bottom: 16px;
}

.preview-content {
  line-height: 1.8;
  color: #333;
  font-size: 14px;
  min-height: 100px;
}

.preview-content img {
  max-width: 100%;
  height: auto;
  margin: 12px 0;
}

.preview-content table {
  border-collapse: collapse;
  width: 100%;
  margin: 12px 0;
}

.preview-content table th,
.preview-content table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: left;
}

.preview-content table th {
  background: #f5f5f5;
  font-weight: 600;
}

.preview-content p {
  margin: 8px 0;
}

.preview-note {
  padding: 40px 0;
}
</style>
