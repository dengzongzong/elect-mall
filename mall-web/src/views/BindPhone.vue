<template>
  <div class="bind-page">
    <div class="bind-header">
      <router-link to="/" class="bind-logo">
        <span class="logo-icon">EC</span>
        <span class="logo-text">电子元器件商城</span>
      </router-link>
    </div>
    <div class="bind-body">
      <div class="bind-card">
        <h3>绑定手机号</h3>
        <p class="bind-tip">为了保障您的账户安全，请绑定手机号</p>
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top" size="large">
          <el-form-item label="手机号" prop="phone">
            <el-input v-model="form.phone" placeholder="请输入手机号" maxlength="11">
              <template #prefix><el-icon><Phone /></el-icon></template>
            </el-input>
          </el-form-item>
          <el-form-item label="验证码" prop="code">
            <div class="code-row">
              <el-input v-model="form.code" placeholder="请输入验证码" maxlength="6" class="code-input">
                <template #prefix><el-icon><Key /></el-icon></template>
              </el-input>
              <el-button class="get-code-btn" :disabled="codeSending || countdown > 0" @click="handleGetCode">
                {{ countdown > 0 ? `${countdown}s` : '获取验证码' }}
              </el-button>
            </div>
          </el-form-item>
          <el-form-item>
            <el-button type="danger" class="bind-btn" :loading="loading" @click="handleBind">绑定</el-button>
          </el-form-item>
        </el-form>
        <div class="skip-link">
          <router-link to="/">稍后绑定，先逛逛 ></router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref(null)
const loading = ref(false)
const codeSending = ref(false)
const countdown = ref(0)
let timer = null

const form = reactive({
  phone: '',
  code: '',
})

const validatePhone = (rule, value, callback) => {
  if (!/^1[3-9]\d{9}$/.test(value)) {
    callback(new Error('请输入正确的手机号'))
  } else {
    callback()
  }
}

const rules = {
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { validator: validatePhone, trigger: 'blur' },
  ],
  code: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { min: 4, max: 6, message: '验证码为4-6位', trigger: 'blur' },
  ],
}

function handleGetCode() {
  if (!/^1[3-9]\d{9}$/.test(form.phone)) {
    ElMessage.warning('请输入正确的手机号')
    return
  }
  codeSending.value = true
  setTimeout(() => {
    codeSending.value = false
    countdown.value = 60
    timer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) clearInterval(timer)
    }, 1000)
    ElMessage.success('验证码已发送')
  }, 1000)
}

function handleBind() {
  formRef.value.validate((valid) => {
    if (valid) {
      loading.value = true
      setTimeout(() => {
        loading.value = false
        userStore.setUserInfo({
          ...userStore.userInfo,
          phone: form.phone,
        })
        ElMessage.success('绑定成功')
        router.push('/')
      }, 1500)
    }
  })
}

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<style scoped>
.bind-page {
  min-height: 100vh;
  background: #f5f5f5;
}

.bind-header {
  height: 64px;
  background: #fff;
  display: flex;
  align-items: center;
  padding: 0 40px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.bind-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
}

.logo-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  background: var(--theme-color);
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  border-radius: 6px;
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: #333;
}

.bind-body {
  display: flex;
  justify-content: center;
  padding: 80px 20px;
}

.bind-card {
  width: 420px;
  background: #fff;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
}

.bind-card h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
  text-align: center;
}

.bind-tip {
  text-align: center;
  color: #999;
  font-size: 14px;
  margin-bottom: 32px;
}

.code-row {
  display: flex;
  gap: 12px;
}

.code-input {
  flex: 1;
}

.get-code-btn {
  width: 130px;
  flex-shrink: 0;
}

.bind-btn {
  width: 100%;
  height: 44px;
  font-size: 16px;
  font-weight: 600;
  margin-top: 8px;
}

.skip-link {
  text-align: center;
  margin-top: 20px;
}

.skip-link a {
  color: #999;
  font-size: 14px;
  text-decoration: none;
  transition: color 0.2s;
}

.skip-link a:hover {
  color: var(--theme-color);
}
</style>