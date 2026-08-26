<template>
  <div class="user-profile">
    <div class="section-card">
      <h4>个人资料</h4>
      <el-form :model="form" label-width="100px" size="large">
        <el-form-item label="头像">
          <div class="avatar-upload">
            <div class="avatar-preview">
              <el-icon :size="32"><UserFilled /></el-icon>
            </div>
            <el-button size="small">更换头像</el-button>
          </div>
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="form.nickname" placeholder="请输入昵称" style="width: 300px" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" disabled style="width: 300px" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱" style="width: 300px" />
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="handleSave">保存</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()

const form = reactive({
  nickname: userStore.userInfo.nickname || '',
  phone: userStore.userInfo.phone || '138****8888',
  email: 'user@example.com',
})

function handleSave() {
  ElMessage.success('保存成功')
}
</script>

<style scoped>
.section-card {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
}

.section-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.avatar-upload {
  display: flex;
  align-items: center;
  gap: 16px;
}

.avatar-preview {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--theme-color-light);
  color: var(--theme-color);
  border-radius: 50%;
}
</style>