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
        <el-form-item>
          <el-button type="danger" :loading="saving" @click="handleSave">保存</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'
import { updateUserProfile } from '../api/user'
import { getUserInfo } from '../api/auth'

const userStore = useUserStore()
const saving = ref(false)

const form = reactive({
  nickname: '',
  phone: '',
  avatar: '',
})

async function fetchProfile() {
  try {
    const res = await getUserInfo()
    form.nickname = res?.nickname || ''
    form.phone = res?.phone || ''
    form.avatar = res?.avatar || ''
  } catch (e) {
    // 未登录时回退到本地缓存
    form.nickname = userStore.userInfo?.nickname || ''
    form.phone = userStore.userInfo?.phone || ''
  }
}

async function handleSave() {
  if (!form.nickname) {
    ElMessage.warning('请输入昵称')
    return
  }
  saving.value = true
  try {
    await updateUserProfile({ nickname: form.nickname, avatar: form.avatar })
    ElMessage.success('保存成功')
    await fetchProfile()
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchProfile()
})
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