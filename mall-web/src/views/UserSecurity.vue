<template>
  <div class="user-security">
    <div class="section-card">
      <h4>账户安全</h4>
      <div class="security-list">
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Cellphone /></el-icon>
            <div>
              <span class="sec-title">手机绑定</span>
              <span class="sec-desc">{{ userInfo.phone ? '已绑定手机 ' + userInfo.phone : '未绑定手机' }}</span>
            </div>
          </div>
          <el-button link type="primary" @click="openPhoneDialog">修改</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Message /></el-icon>
            <div>
              <span class="sec-title">邮箱绑定</span>
              <span class="sec-desc">{{ userInfo.email ? '已绑定邮箱 ' + userInfo.email : '未绑定邮箱' }}</span>
            </div>
          </div>
          <el-button link type="primary" @click="openEmailDialog">{{ userInfo.email ? '修改' : '绑定' }}</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Lock /></el-icon>
            <div>
              <span class="sec-title">登录密码</span>
              <span class="sec-desc">当前为手机验证码登录，无需设置密码</span>
            </div>
          </div>
          <el-button link @click="ElMessage.info('当前为验证码登录，无需设置密码')">说明</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Key /></el-icon>
            <div>
              <span class="sec-title">支付密码</span>
              <span class="sec-desc">暂未开放支付密码功能</span>
            </div>
          </div>
          <el-button link @click="ElMessage.info('暂未开放支付密码功能')">说明</el-button>
        </div>
      </div>
    </div>

    <!-- 修改手机号 -->
    <el-dialog v-model="phoneDialog" title="修改绑定手机号" width="420px">
      <el-form label-width="80px">
        <el-form-item label="新手机号">
          <el-input v-model="phoneForm.phone" maxlength="11" placeholder="请输入新手机号" />
        </el-form-item>
        <el-form-item label="验证码">
          <div class="code-row">
            <el-input v-model="phoneForm.code" maxlength="6" placeholder="请输入验证码" />
            <el-button :disabled="sending" @click="handleSendCode">获取验证码</el-button>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="phoneDialog = false">取消</el-button>
        <el-button type="danger" :loading="binding" @click="handleBindPhone">确认</el-button>
      </template>
    </el-dialog>

    <!-- 绑定邮箱 -->
    <el-dialog v-model="emailDialog" :title="userInfo.email ? '修改绑定邮箱' : '绑定邮箱'" width="420px">
      <el-form label-width="80px">
        <el-form-item label="邮箱">
          <el-input v-model="emailForm.email" placeholder="请输入邮箱地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="emailDialog = false">取消</el-button>
        <el-button type="danger" :loading="binding" @click="handleBindEmail">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getUserInfo } from '../api/auth'
import { bindPhone } from '../api/auth'
import { sendCode } from '../api/auth'
import { bindEmail } from '../api/user'

const userInfo = ref({})
const phoneDialog = ref(false)
const emailDialog = ref(false)
const sending = ref(false)
const binding = ref(false)

const phoneForm = reactive({ phone: '', code: '' })
const emailForm = reactive({ email: '' })

async function fetchUser() {
  try {
    const res = await getUserInfo()
    userInfo.value = res || {}
  } catch (e) {
    userInfo.value = {}
  }
}

function openPhoneDialog() {
  phoneForm.phone = ''
  phoneForm.code = ''
  phoneDialog.value = true
}

function openEmailDialog() {
  emailForm.email = userInfo.value.email || ''
  emailDialog.value = true
}

async function handleSendCode() {
  if (!/^1\d{10}$/.test(phoneForm.phone)) {
    ElMessage.warning('请输入正确的手机号')
    return
  }
  sending.value = true
  try {
    await sendCode(phoneForm.phone)
    ElMessage.success('验证码已发送')
  } catch (e) {
    ElMessage.error('发送失败')
  } finally {
    sending.value = false
  }
}

async function handleBindPhone() {
  if (!/^1\d{10}$/.test(phoneForm.phone)) {
    ElMessage.warning('请输入正确的手机号')
    return
  }
  binding.value = true
  try {
    await bindPhone(phoneForm.phone, phoneForm.code)
    ElMessage.success('手机号已更新')
    phoneDialog.value = false
    await fetchUser()
  } catch (e) {
    ElMessage.error('绑定失败')
  } finally {
    binding.value = false
  }
}

async function handleBindEmail() {
  const email = emailForm.email.trim()
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    ElMessage.warning('请输入正确的邮箱地址')
    return
  }
  binding.value = true
  try {
    await bindEmail(email)
    ElMessage.success('邮箱已更新')
    emailDialog.value = false
    await fetchUser()
  } catch (e) {
    ElMessage.error('绑定失败')
  } finally {
    binding.value = false
  }
}

onMounted(() => {
  fetchUser()
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

.security-list {
  display: flex;
  flex-direction: column;
}

.security-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 0;
  border-bottom: 1px solid #f5f5f5;
}

.security-item:last-child {
  border-bottom: none;
}

.sec-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.sec-info .el-icon {
  font-size: 24px;
  color: var(--theme-color);
}

.sec-title {
  display: block;
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.sec-desc {
  font-size: 13px;
  color: #999;
}

.code-row {
  display: flex;
  gap: 8px;
  width: 100%;
}
</style>
