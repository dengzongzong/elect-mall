<template>
  <div class="user">
    <div class="page-header">
      <div class="page-title">
        <h2>用户管理</h2>
        <p>管理商城注册用户信息，包括用户审核、权限管理等。</p>
      </div>
      <div class="header-actions">
        <el-button :disabled="!multipleSelection.length" @click="handleBatchDelete">批量删除</el-button>
        <el-button type="danger">
          <el-icon><Plus /></el-icon>新增用户
        </el-button>
      </div>
    </div>

    <!-- 搜索表单 -->
    <el-card shadow="hover" class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item label="用户名">
          <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="searchForm.email" placeholder="请输入邮箱" clearable />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="searchForm.phone" placeholder="请输入手机号" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card shadow="hover">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="用户ID" width="100" />
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="email" label="邮箱" min-width="200" />
        <el-table-column prop="phone" label="手机号" width="140" />
        <el-table-column prop="userType" label="用户类型" width="120">
          <template #default="{ row }">
            <el-tag :type="row.userType === '企业用户' ? 'primary' : 'success'">{{ row.userType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '激活' ? 'success' : 'info'">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="regTime" label="注册时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default>
            <el-button type="primary" link size="small">编辑</el-button>
            <el-button type="warning" link size="small">禁用</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @current-change="fetchUsers"
          @size-change="fetchUsers"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAdminUsers, deleteAdminUser } from '../api/admin'

const tableData = ref([])
const loading = ref(false)
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const multipleSelection = ref([])

const searchForm = ref({
  username: '',
  email: '',
  phone: ''
})

async function fetchUsers() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value
    }
    // 只在有值时传递搜索参数
    if (searchForm.value.username) params.username = searchForm.value.username
    if (searchForm.value.email) params.email = searchForm.value.email
    if (searchForm.value.phone) params.phone = searchForm.value.phone

    const res = await getAdminUsers(params)
    // 兼容后端返回 { records, total } 或直接返回数组
    if (res.data && Array.isArray(res.data.records)) {
      tableData.value = res.data.records
      total.value = res.data.total
    } else if (Array.isArray(res.data)) {
      tableData.value = res.data
      total.value = res.data.length
    } else {
      tableData.value = res.data || []
      total.value = (res.data && res.data.total) || 0
    }
  } catch (e) {
    console.error('获取用户列表失败', e)
    tableData.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

function handleSelectionChange(val) {
  multipleSelection.value = val
}

async function handleBatchDelete() {
  if (!multipleSelection.value.length) {
    ElMessage.warning('请先选择要删除的记录')
    return
  }
  try {
    await ElMessageBox.confirm(`确定删除选中的 ${multipleSelection.value.length} 条记录吗？`, '确认删除', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    for (const row of multipleSelection.value) {
      await deleteAdminUser(row.id)
    }
    ElMessage.success('批量删除成功')
    await fetchUsers()
  } catch (e) {
    // 用户取消或删除失败
  }
}

function handleSearch() {
  currentPage.value = 1
  fetchUsers()
}

function handleReset() {
  searchForm.value = { username: '', email: '', phone: '' }
  currentPage.value = 1
  fetchUsers()
}

onMounted(() => {
  fetchUsers()
})
</script>

<style scoped>
.user {
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

.search-card {
  margin-bottom: 16px;
}

.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}
</style>