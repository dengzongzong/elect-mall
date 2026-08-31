<template>
  <div class="category">
    <div class="page-header">
      <div class="page-title">
        <h2>分类管理</h2>
        <p>管理电子元器件的分类体系，仅支持两级分类：一级为大类（不支持富文本），二级为子类（支持富文本详情）。</p>
      </div>
      <div class="header-actions">
        <el-input v-model="keyword" placeholder="搜索分类名称" clearable style="width: 200px" />
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
        <el-button type="danger" @click="handleAddRoot">
          <el-icon><Plus /></el-icon>新增分类
        </el-button>
      </div>
    </div>
    <el-card shadow="hover">
      <el-table
        v-loading="loading"
        :data="filteredTableData"
        stripe
        row-key="id"
        :tree-props="{ children: 'children' }"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="name" label="分类名称" min-width="200" />
        <el-table-column prop="parent_id" label="层级" width="100">
          <template #default="{ row }">
            <el-tag v-if="levelOf(row) === 1" type="danger" size="small">1级-大类</el-tag>
            <el-tag v-else type="warning" size="small">2级-子类</el-tag>
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
            <el-button v-if="levelOf(row) === 1" type="success" link size="small" @click="handleAddSub(row)">新增子类</el-button>
            <el-button v-if="levelOf(row) === 2" type="warning" link size="small" @click="handleEditDescription(row)">编辑详情</el-button>
            <el-button v-if="levelOf(row) === 2" type="info" link size="small" @click="handlePreview(row)">预览</el-button>
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
      width="960px"
      :close-on-click-modal="false"
      :before-close="beforeCloseDescDialog"
    >
      <el-form label-width="100px">
        <el-form-item label="分类名称">
          <el-tag>{{ descForm.name }}</el-tag>
        </el-form-item>
        <el-form-item label="分类层级">
          <el-tag type="info" size="small">{{ descForm.parentName || '1级-大类' }}</el-tag>
        </el-form-item>
        <el-form-item label="分类详情">
          <div class="desc-editor">
            <QuillEditor
              ref="quillRef"
              :key="editorKey"
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
const keyword = ref('')
const multipleSelection = ref([])
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
  description: '',
  parentId: 0,
  parentName: '',
  prefix: '',
  sort: 0,
  status: 1
})
const quillRef = ref(null)
// 每次打开详情对话框递增，强制重建 Quill 实例，保证不同分类的编辑内容互不串扰
const editorKey = ref(0)

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

// 在树形分类中查找指定 id 的分类
function findParent(id, list) {
  for (const item of list) {
    if (String(item.id) === String(id)) return item
    if (item.children) {
      const found = findParent(id, item.children)
      if (found) return found
    }
  }
  return null
}

// 计算分类层级：parent_id 为 0 是一级大类，其余为二级子类（本项目仅支持两级）
function levelOf(row) {
  const pid = row.parent_id ?? row.parentId ?? 0
  return (pid === 0 || pid === '0') ? 1 : 2
}

// 前端树形过滤：节点自身或其子孙的 name 包含关键字时保留该节点（保留父级结构）
function filterTree(list, kw) {
  if (!kw) return list
  const keywordLower = String(kw).trim().toLowerCase()
  const walk = (nodes) => {
    const result = []
    for (const node of nodes) {
      const selfMatch = String(node.name || '').toLowerCase().includes(keywordLower)
      let children = []
      if (node.children && node.children.length) {
        children = walk(node.children)
      }
      if (selfMatch || children.length) {
        result.push({ ...node, children })
      }
    }
    return result
  }
  return walk(list)
}

const filteredTableData = computed(() => filterTree(tableData.value, keyword.value))

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
  const parentId = row.parent_id ?? row.parentId ?? 0
  descForm.value = {
    id: row.id,
    name: row.name,
    description: row.description || '',
    // 必须带上 parentId：后端是全字段更新，缺省时会被写成 0，导致子类被挂到顶层
    parentId,
    parentName: (parentId && parentId !== '0')
      ? (findParent(parentId, tableData.value)?.name || '')
      : '',
    prefix: row.prefix || '',
    sort: row.sort ?? 0,
    status: row.status ?? 1
  }
  // 重建编辑器实例，确保切换到另一个分类时内容是该分类自己的
  editorKey.value++
  descDialogVisible.value = true
}

function handlePreview(row) {
  previewForm.value = {
    name: row.name,
    description: row.description || '',
    _row: row
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

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的分类')
    return
  }
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${multipleSelection.value.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of multipleSelection.value) {
      await deleteCategory(row.id)
    }
    ElMessage.success('批量删除成功')
    await fetchCategories()
  } catch (e) {
    // 用户取消或删除失败
  }
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

.header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.desc-editor {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}

/* 注意：.rich-editor 与 Quill 的 .quill 是同一个元素（class 被合并到组件根节点），
   所以 :deep() 里不能再带 .quill 前缀，否则选择器要求 .quill 是其后代、永远匹配不到，
   之前写的 min-height 之所以一直没生效就是这个原因。 */
.rich-editor {
  min-height: 580px;
  background: #fff;
}

:deep(.ql-container) {
  height: 520px;
  font-size: 14px;
}

:deep(.ql-editor) {
  min-height: 520px;
  overflow-y: auto;
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
