<template>
  <div class="user-address">
    <div class="section-card">
      <div class="card-header">
        <h4>收货地址</h4>
        <el-button type="danger" @click="showDialog = true">新增地址</el-button>
      </div>
      <div class="address-list">
        <div class="address-item" v-for="(addr, idx) in addresses" :key="idx">
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

    <el-dialog v-model="showDialog" title="新增地址" width="500px">
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
        <el-button type="danger" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const showDialog = ref(false)

const form = reactive({
  name: '',
  phone: '',
  region: [],
  detail: '',
  isDefault: false,
})

const regionOptions = [
  { value: 'guangdong', label: '广东省', children: [{ value: 'shenzhen', label: '深圳市', children: [{ value: 'nanshan', label: '南山区' }, { value: 'futian', label: '福田区' }] }] },
  { value: 'beijing', label: '北京市', children: [{ value: 'beijing', label: '北京市', children: [{ value: 'haidian', label: '海淀区' }, { value: 'chaoyang', label: '朝阳区' }] }] },
]

const addresses = ref([
  { name: '张三', phone: '138****8888', province: '广东省', city: '深圳市', district: '南山区', detail: '科技园南路100号', isDefault: true },
  { name: '李四', phone: '139****9999', province: '北京市', city: '北京市', district: '海淀区', detail: '中关村大街1号', isDefault: false },
])

function handleEdit(idx) {
  ElMessage.info('编辑地址功能')
}

function handleDelete(idx) {
  ElMessageBox.confirm('确定删除该地址吗？', '提示', { type: 'warning' }).then(() => {
    addresses.value.splice(idx, 1)
    ElMessage.success('已删除')
  }).catch(() => {})
}

function handleSave() {
  showDialog.value = false
  ElMessage.success('地址已保存')
}
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
</style>