<template>
  <div class="product">
    <div class="page-header">
      <div class="page-title">
        <h2>商品管理</h2>
        <p>管理商城中的所有商品信息，包括新增、编辑、上下架等操作。</p>
      </div>
      <div class="page-actions">
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
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
      <el-table :data="tableData" stripe style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="商品编号" width="120" />
        <el-table-column prop="name" label="商品名称" min-width="200" />
        <el-table-column prop="partNo" label="料号" width="150" />
        <el-table-column prop="l1_name" label="一级分类" min-width="130">
          <template #default="{ row }">{{ row.l1_name || '-' }}</template>
        </el-table-column>
        <el-table-column prop="l2_name" label="二级分类" min-width="130">
          <template #default="{ row }">{{ row.l2_name || '-' }}</template>
        </el-table-column>
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
            <el-button type="primary" link size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link size="small">下架</el-button>
            <el-button type="warning" link size="small" @click="handleDelete(row)">删除</el-button>
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
        <el-form-item label="阶梯价">
          <div class="tier-price-block">
            <div v-for="(tier, index) in form.tierPrices" :key="index" class="tier-price-row">
              <el-input-number v-model="tier.min_qty" :min="1" placeholder="起订量" />
              <span class="tier-label">件及以上</span>
              <el-input-number v-model="tier.price" :min="0" :precision="4" placeholder="单价" />
              <el-button type="danger" link size="small" @click="removeTierPrice(index)">删除</el-button>
            </div>
            <el-button type="primary" link size="small" @click="addTierPrice">+ 添加阶梯价</el-button>
          </div>
        </el-form-item>
        <el-form-item label="库存">
          <el-input-number v-model="form.stock" :min="0" />
        </el-form-item>
        <el-form-item label="重量(g)">
          <el-input-number v-model="form.weight" :min="0" :precision="4" />
        </el-form-item>
        <el-form-item label="规格参数">
          <div class="specs-block">
            <div v-for="(spec, index) in form.specs" :key="index" class="spec-row">
              <el-input v-model="spec.key" placeholder="参数名，如封装" style="width: 140px" />
              <span class="spec-sep">:</span>
              <el-input v-model="spec.value" placeholder="参数值，如 0603" style="width: 180px" />
              <el-button type="danger" link size="small" @click="removeSpec(index)">删除</el-button>
            </div>
            <el-button type="primary" link size="small" @click="addSpec">+ 添加规格参数</el-button>
          </div>
        </el-form-item>
        <el-form-item label="详情">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="商品详情/副标题文案，展示在商城商品详情页" />
        </el-form-item>
        <el-form-item label="商品主图">
          <el-input v-model="form.image" placeholder="图片URL，如 https://.../xxx.jpg" style="width: 100%" />
          <div v-if="form.image" class="img-preview">
            <img :src="form.image" alt="预览" @error="e => e.target.style.display = 'none'" />
          </div>
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
const multipleSelection = ref([])
const form = ref({
  id: null,
  name: '',
  categoryId: null,
  partNo: '',
  price: 0,
  tierPrices: [],
  stock: 0,
  weight: null,
  specs: [],
  description: '',
  image: '',
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

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的商品')
    return
  }
  const withStock = multipleSelection.value.filter(r => (r.stock || 0) > 0)
  const toDelete = multipleSelection.value.filter(r => !(r.stock > 0))
  if (withStock.length) {
    ElMessage.warning(`${withStock.length} 件商品有库存，已跳过删除；将对其余 ${toDelete.length} 件执行删除`)
  }
  if (!toDelete.length) return
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${toDelete.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of toDelete) {
      await deleteProduct(row.id)
    }
    ElMessage.success('删除成功')
    await fetchProducts()
  } catch (e) {
    // 用户取消或后端拦截（如库存）已提示
  }
}

function handleImport() {
  ElMessage.info('导入商品功能开发中')
}

function handleAdd() {
  dialogTitle.value = '新增商品'
  form.value = { id: null, name: '', categoryId: null, partNo: '', price: 0, tierPrices: [], stock: 0, weight: null, specs: [], description: '', image: '', status: 1 }
  dialogVisible.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑商品'
  const specs = row.specs
  form.value = {
    id: row.id,
    name: row.name || '',
    categoryId: row.category_id || null,
    partNo: row.part_no || '',
    price: row.price || 0,
    tierPrices: Array.isArray(row.tier_prices) ? row.tier_prices : [],
    stock: row.stock || 0,
    weight: row.weight || null,
    specs: Array.isArray(specs) ? specs : (specs && typeof specs === 'object' ? Object.entries(specs).map(([k, v]) => ({ key: k, value: v })) : []),
    description: row.description || '',
    image: row.image_url || '',
    status: row.status ?? 1
  }
  dialogVisible.value = true
}

function addTierPrice() {
  form.value.tierPrices.push({ min_qty: 1, price: 0 })
}

function removeTierPrice(index) {
  form.value.tierPrices.splice(index, 1)
}

function addSpec() {
  form.value.specs.push({ key: '', value: '' })
}

function removeSpec(index) {
  form.value.specs.splice(index, 1)
}

async function handleSave() {
  try {
    const payload = { ...form.value }
    // 规格参数 [{key,value}] 转成 {key:value} 对象存储
    if (Array.isArray(payload.specs)) {
      const specsObj = {}
      payload.specs.forEach(s => { if (s.key) specsObj[s.key] = s.value })
      payload.specs = specsObj
    }
    await saveProduct(payload)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    fetchProducts()
  } catch (e) {
    ElMessage.error('保存失败')
  }
}

function handleDelete(row) {
  if ((row.stock || 0) > 0) {
    ElMessage.warning('该商品有库存，不允许删除')
    return
  }
  ElMessageBox.confirm('确认删除该商品？', '提示', {
    type: 'warning',
  }).then(async () => {
    try {
      await deleteProduct(row.id)
      ElMessage.success('删除成功')
      fetchProducts()
    } catch (e) {
      // 后端拦截器已弹出错误提示（如有库存等情况）
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

.tier-price-block {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.tier-price-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.tier-price-row .el-input-number {
  width: 140px;
}

.tier-label {
  color: #606266;
  font-size: 13px;
  white-space: nowrap;
}

.specs-block {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.spec-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.spec-sep {
  color: #606266;
}

.img-preview {
  margin-top: 8px;
}

.img-preview img {
  max-width: 200px;
  max-height: 200px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  object-fit: contain;
}
</style>
