<template>
  <div class="user-address">
    <div class="section-card">
      <div class="card-header">
        <h4>收货地址</h4>
        <el-button type="danger" @click="openAdd">新增地址</el-button>
      </div>
      <div class="empty-state" v-if="addresses.length === 0">
        <p>暂无收货地址，点击右上角「新增地址」添加</p>
      </div>
      <div class="address-list" v-else>
        <div class="address-item" v-for="(addr, idx) in addresses" :key="addr.id ?? idx">
          <div class="addr-info">
            <div class="addr-name">
              <span class="name">{{ addr.name }}</span>
              <span class="phone">{{ addr.phone }}</span>
              <span class="tag" v-if="addr.isDefault">默认</span>
            </div>
            <p class="addr-detail">{{ addr.province }}{{ addr.city }}{{ addr.district }} {{ addr.detail }}</p>
          </div>
          <div class="addr-actions">
            <el-button link type="primary" @click="handleEdit(idx)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(idx)">删除</el-button>
          </div>
        </div>
      </div>
    </div>

    <el-dialog v-model="showDialog" :title="editingId ? '编辑地址' : '新增地址'" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="收货人">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item label="所在地区">
          <el-cascader :options="regionOptions" v-model="form.region" />
        </el-form-item>
        <el-form-item label="详细地址">
          <el-input v-model="form.detail" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="form.isDefault">设为默认地址</el-checkbox>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="danger" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAddressList, addAddress, updateAddress, deleteAddress } from '../api/user'

const showDialog = ref(false)
const saving = ref(false)
const editingId = ref(null)

const form = reactive({
  name: '',
  phone: '',
  region: [],
  detail: '',
  isDefault: false,
})

// value 与 label 一致，便于直接作为 province/city/district 存库
const regionOptions = [
  { value: '广东省', label: '广东省', children: [
    { value: '深圳市', label: '深圳市', children: [{ value: '南山区', label: '南山区' }, { value: '福田区', label: '福田区' }] },
    { value: '广州市', label: '广州市', children: [{ value: '天河区', label: '天河区' }] },
  ] },
  { value: '北京市', label: '北京市', children: [
    { value: '北京市', label: '北京市', children: [{ value: '海淀区', label: '海淀区' }, { value: '朝阳区', label: '朝阳区' }] },
  ] },
]

const addresses = ref([])

async function fetchAddresses() {
  try {
    const res = await getAddressList()
    const list = Array.isArray(res) ? res : []
    // 后端字段为 is_default，统一成 isDefault 便于模板使用
    addresses.value = list.map(a => ({ ...a, isDefault: !!a.isDefault || !!a.is_default }))
  } catch (e) {
    addresses.value = []
  }
}

function resetForm() {
  form.name = ''
  form.phone = ''
  form.region = []
  form.detail = ''
  form.isDefault = false
}

function handleEdit(idx) {
  const addr = addresses.value[idx]
  editingId.value = addr.id
  form.name = addr.name || ''
  form.phone = addr.phone || ''
  form.region = [addr.province, addr.city, addr.district].filter(Boolean)
  form.detail = addr.detail || ''
  form.isDefault = !!addr.isDefault
  showDialog.value = true
}

async function handleDelete(idx) {
  const addr = addresses.value[idx]
  try {
    await ElMessageBox.confirm('确定删除该地址吗？', '提示', { type: 'warning' })
  } catch {
    return
  }
  try {
    await deleteAddress(addr.id)
    ElMessage.success('已删除')
    await fetchAddresses()
  } catch (e) {
    ElMessage.error('删除失败')
  }
}

async function handleSave() {
  if (!form.name || !form.phone) {
    ElMessage.warning('请填写收货人和手机号')
    return
  }
  saving.value = true
  try {
    const [province = '', city = '', district = ''] = form.region
    const payload = {
      name: form.name,
      phone: form.phone,
      province,
      city,
      district,
      detail: form.detail,
      isDefault: form.isDefault ? 1 : 0,
    }
    if (editingId.value) {
      await updateAddress({ ...payload, id: editingId.value })
    } else {
      await addAddress(payload)
    }
    ElMessage.success(editingId.value ? '地址已更新' : '地址已保存')
    showDialog.value = false
    editingId.value = null
    resetForm()
    await fetchAddresses()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

// 打开新增前重置表单
const openAdd = () => {
  editingId.value = null
  resetForm()
  showDialog.value = true
}

onMounted(() => {
  fetchAddresses()
})
</script>

<style scoped>
.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.card-header h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.address-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
  border-bottom: 1px solid #f5f5f5;
}

.address-item:last-child {
  border-bottom: none;
}

.addr-name {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
}

.addr-name .name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}

.addr-name .phone {
  font-size: 13px;
  color: #888;
}

.tag {
  font-size: 11px;
  color: var(--theme-color);
  background: var(--theme-color-light);
  padding: 1px 6px;
  border-radius: 2px;
}

.addr-detail {
  font-size: 13px;
  color: #888;
}

.addr-actions {
  display: flex;
  gap: 8px;
}

.empty-state {
  text-align: center;
  padding: 50px 0;
  color: #999;
  font-size: 14px;
}
</style>