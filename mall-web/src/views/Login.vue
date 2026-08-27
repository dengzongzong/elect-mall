<template>
  <div class="login-page">
    <div class="login-header">
      <router-link to="/" class="login-logo">
        <span class="logo-icon">EC</span>
        <span class="logo-text">电子元器件商城</span>
      </router-link>
    </div>
    <div class="login-body">
      <div class="login-card">
        <div class="login-tabs">
          <div class="tab-header">
            <div class="tab-item" :class="{ active: activeTab === 'wechat' }" @click="activeTab = 'wechat'">微信扫码登录</div>
            <div class="tab-item" :class="{ active: activeTab === 'phone' }" @click="activeTab = 'phone'">手机号登录</div>
          </div>
          <div class="tab-content">
            <!-- 微信扫码登录 -->
            <div v-show="activeTab === 'wechat'" class="wechat-login">
              <div class="qr-code-placeholder">
                <el-icon class="qr-icon"><ChatLineSquare /></el-icon>
                <span class="qr-text">请使用微信扫码登录</span>
                <div class="qr-box">
                  <div class="qr-sim">
                    <div class="qr-pattern">
                      <div class="qr-block" v-for="i in 20" :key="i" :style="getRandomStyle()"></div>
                    </div>
                  </div>
                </div>
                <p class="qr-tip">扫码即表示同意 <a href="#">用户协议</a> 和 <a href="#">隐私政策</a></p>
              </div>
            </div>

            <!-- 手机号登录 -->
            <div v-show="activeTab === 'phone'" class="phone-login">
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
                    <el-button
                      class="get-code-btn"
                      :disabled="codeSending || countdown > 0"
                      @click="handleGetCode"
                    >
                      {{ countdown > 0 ? `${countdown}s` : '获取验证码' }}
                    </el-button>
                  </div>
                </el-form-item>
                <el-form-item>
                  <el-button type="danger" class="login-btn" :loading="loading" @click="handleLogin">
                    登录
                  </el-button>
                </el-form-item>
              </el-form>
              <div class="login-footer-info">
                <p>首次登录将自动创建账号</p>
                <p>登录即表示同意 <a href="#">用户协议</a> 和 <a href="#">隐私政策</a></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="login-footer">
      <p>&copy; 2024 电子元器件商城 版权所有</p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'
import { sendCode, phoneLogin, wechatLogin } from '../api/auth'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref(null)
const activeTab = ref('phone')
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

function getRandomStyle() {
  const w = 5 + Math.random() * 12
  const h = 5 + Math.random() * 12
  const t = Math.random() * 24
  const l = Math.random() * 24
  return {
    width: `${w}px`,
    height: `${h}px`,
    top: `${t}px`,
    left: `${l}px`,
    background: Math.random() > 0.5 ? '#333' : '#E60012',
  }
}

async function handleGetCode() {
  if (!/^1[3-9]\d{9}$/.test(form.phone)) {
    ElMessage.warning('请输入正确的手机号')
    return
  }
  codeSending.value = true
  try {
    const res = await sendCode(form.phone)
    if (res.success !== false) {
      countdown.value = 60
      timer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) {
          clearInterval(timer)
        }
      }, 1000)
      ElMessage.success('验证码已发送')
    } else {
      ElMessage.error(res.message || '验证码发送失败')
    }
  } catch (e) {
    // 错误已在拦截器中处理
  } finally {
    codeSending.value = false
  }
}

async function handleLogin() {
  formRef.value.validate(async (valid) => {
    if (!valid) return
    loading.value = true
    try {
      const res = await phoneLogin(form.phone, form.code)
      if (res.success !== false) {
        userStore.setToken(res.token)
        userStore.setUserInfo(res.user || {
          nickname: '用户' + form.phone.slice(-4),
          phone: form.phone,
        })
        ElMessage.success('登录成功')
        router.push('/')
      } else {
        ElMessage.error(res.message || '登录失败')
      }
    } catch (e) {
      // 错误已在拦截器中处理
    } finally {
      loading.value = false
    }
  })
}

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: #f5f5f5;
  display: flex;
  flex-direction: column;
}

.login-header {
  height: 64px;
  background: #fff;
  display: flex;
  align-items: center;
  padding: 0 40px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.login-logo {
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

.login-body {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
}

.login-card {
  width: 440px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.tab-header {
  display: flex;
  border-bottom: 1px solid #f0f0f0;
}

.tab-item {
  flex: 1;
  text-align: center;
  padding: 18px 0;
  font-size: 16px;
  font-weight: 600;
  color: #999;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.tab-item.active {
  color: var(--theme-color);
}

.tab-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 60px;
  height: 3px;
  background: var(--theme-color);
  border-radius: 2px;
}

.tab-content {
  padding: 32px;
}

/* 微信扫码 */
.wechat-login {
  text-align: center;
}

.qr-code-placeholder {
  padding: 20px 0;
}

.qr-icon {
  font-size: 40px;
  color: #07c160;
  margin-bottom: 12px;
}

.qr-text {
  display: block;
  font-size: 15px;
  color: #333;
  margin-bottom: 20px;
}

.qr-box {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.qr-sim {
  width: 180px;
  height: 180px;
  background: #fff;
  border: 2px solid #333;
  border-radius: 8px;
  padding: 8px;
  position: relative;
}

.qr-pattern {
  width: 100%;
  height: 100%;
  position: relative;
  background: #fff;
}

.qr-block {
  position: absolute;
  border-radius: 1px;
}

.qr-tip {
  font-size: 12px;
  color: #999;
}

.qr-tip a {
  color: var(--theme-color);
  text-decoration: none;
}

/* 手机号登录 */
.phone-login {
  max-width: 360px;
  margin: 0 auto;
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
  font-size: 14px;
}

.login-btn {
  width: 100%;
  height: 44px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 6px;
  margin-top: 8px;
}

.login-footer-info {
  text-align: center;
  margin-top: 16px;
}

.login-footer-info p {
  font-size: 12px;
  color: #bbb;
  line-height: 22px;
}

.login-footer-info a {
  color: var(--theme-color);
  text-decoration: none;
}

.login-footer {
  text-align: center;
  padding: 20px;
  font-size: 12px;
  color: #ccc;
}
</style>