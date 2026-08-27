<template>
  <div class="product">
    <div class="page-header">
      <div class="page-title">
        <h2>商品管理</h2>
        <p>管理商城中的所有商品信息，包括新增、编辑、上下架等操作。</p>
      </div>
      <div class="page-actions">
        <el-button type="danger" @click="handleImport">
          <el-icon><Upload /></el-icon>导入商品
        </el-button>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>新增商品
        </el-button>
      </div>
    </div>
    <el-card shadow="hover" class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="商品名称">
          <el-input v-model="searchForm.name" placeholder="请输入商品名称" clearable />
        </el-form-item>
        <el-form-item label="商品分类">
          <el-select v-model="searchForm.categoryId" placeholder="请选择分类" clearable>
            <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="上架" value="1" />
            <el-option label="下架" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    <el-card shadow="hover" class="table-card">
      <el-table :data="tableData" stripe style="width: 100%">
        <el-table-column prop="id" label="商品编号" width="120" />
        <el-table-column prop="name" label="商品名称" min-width="200" />
        <el-table-column prop="partNo" label="料号" width="150" />
        <el-table-column prop="price" label="价格" width="120">
          <template #default="{ row }">
            ¥{{ row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="danger" link size="small">下架</el-button>
            <el-button type="warning" link size="small" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          layout="total, prev, pager, next, jumper"
        />
      </div>
    </el-card>

    <!-- 新增/编辑商品对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="商品名称">
          <el-input v-model="form.name" placeholder="请输入商品名称" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.categoryId" placeholder="请选择分类" style="width: 100%">
            <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="料号">
          <el-input v-model="form.partNo" placeholder="请输入料号" />
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number v-model="form.price" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="库存">
          <el-input-number v-model="form.stock" :min="0" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">上架</el-radio>
            <el-radio :value="0">下架</el-radio>
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminProducts, saveProduct, deleteProduct, getAdminCategories } from '../api/admin'

const searchForm = reactive({
  name: '',
  categoryId: '',
  status: ''
})

const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const categories = ref([])

const tableData = ref([])
const form = ref({
  id: null,
  name: '',
  categoryId: null,
  partNo: '',
  price: 0,
  stock: 0,
  status: 1
})

async function fetchCategories() {
  try {
    const res = await getAdminCategories()
    categories.value = res.data || []
  } catch (e) {
    // ignore
  }
}

async function fetchProducts() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
    }
    if (searchForm.name) params.keyword = searchForm.name
    if (searchForm.categoryId) params.categoryId = searchForm.categoryId
    if (searchForm.status) params.status = searchForm.status

    const res = await getAdminProducts(params)
    if (res.data) {
      if (res.data.records) {
        tableData.value = res.data.records
        total.value = res.data.total || 0
      } else {
        tableData.value = res.data
      }
    }
  } catch (e) {
    // ignore
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  currentPage.value = 1
  fetchProducts()
}

function handleReset() {
  searchForm.name = ''
  searchForm.categoryId = ''
  searchForm.status = ''
  currentPage.value = 1
  fetchProducts()
}

function handleImport() {
  ElMessage.info('导入商品功能开发中')
}

function handleAdd() {
  dialogTitle.value = '新增商品'
  form.value = { id: null, name: '', categoryId: null, partNo: '', price: 0, stock: 0, status: 1 }
  dialogVisible.value = true
}

async function handleSave() {
  try {
    await saveProduct(form.value)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    fetchProducts()
  } catch (e) {
    ElMessage.error('保存失败')
  }
}

function handleDelete(id) {
  ElMessageBox.confirm('确认删除该商品？', '提示', {
    type: 'warning',
  }).then(async () => {
    try {
      await deleteProduct(id)
      ElMessage.success('删除成功')
      fetchProducts()
    } catch (e) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

onMounted(() => {
  fetchCategories()
  fetchProducts()
})
</script>

<style scoped>
.product {
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

.page-actions {
  display: flex;
  gap: 12px;
}

.search-card {
  margin-bottom: 20px;
  border-radius: 8px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.table-card {
  border-radius: 8px;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
