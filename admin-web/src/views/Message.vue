<template>
  <div class="message">
    <div class="page-header">
      <div class="page-title">
        <h2>消息通知</h2>
        <p>查看系统消息和通知，包括订单通知、系统公告等。</p>
      </div>
      <el-button type="danger" @click="dialogVisible = true">
        <el-icon><Plus /></el-icon>发送通知
      </el-button>
    </div>
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card shadow="hover" class="msg-type-card">
          <template #header>
            <div class="msg-type-header">
              <span>消息分类</span>
            </div>
          </template>
          <div class="msg-type-list">
            <div class="msg-type-item active">
              <span>全部消息</span>
              <el-tag type="danger" size="small">12</el-tag>
            </div>
            <div class="msg-type-item">
              <span>订单通知</span>
              <el-tag type="warning" size="small">5</el-tag>
            </div>
            <div class="msg-type-item">
              <span>系统公告</span>
              <el-tag type="primary" size="small">3</el-tag>
            </div>
            <div class="msg-type-item">
              <span>询价回复</span>
              <el-tag type="success" size="small">4</el-tag>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="16">
        <el-card shadow="hover">
          <template #header>
            <span>消息列表</span>
          </template>
          <div class="message-list" v-loading="loading">
            <div class="message-item" v-for="item in messages" :key="item.id">
              <div class="message-dot" :class="{ unread: !item.read }" />
              <div class="message-content">
                <div class="message-title">{{ item.title }}</div>
                <div class="message-time">{{ item.time }}</div>
              </div>
              <el-tag size="small" :type="item.type === '订单' ? 'warning' : item.type === '系统' ? 'primary' : 'success'">
                {{ item.type }}
              </el-tag>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 发送通知对话框 -->
    <el-dialog v-model="dialogVisible" title="发送通知" width="500px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="消息标题">
          <el-input v-model="form.title" placeholder="请输入消息标题" />
        </el-form-item>
        <el-form-item label="消息类型">
          <el-select v-model="form.type" placeholder="请选择消息类型" style="width: 100%">
            <el-option label="订单通知" value="订单" />
            <el-option label="系统公告" value="系统" />
            <el-option label="询价回复" value="询价" />
          </el-select>
        </el-form-item>
        <el-form-item label="消息内容">
          <el-input v-model="form.content" type="textarea" :rows="4" placeholder="请输入消息内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="danger" :loading="sending" @click="handleSend">发送</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getAdminMessages, sendMessage } from '../api/admin'

const loading = ref(false)
const sending = ref(false)
const dialogVisible = ref(false)
const messages = ref([])

const form = ref({
  title: '',
  type: '',
  content: ''
})

async function fetchMessages() {
  loading.value = true
  try {
    const res = await getAdminMessages()
    messages.value = res.data || []
  } catch (e) {
    ElMessage.error('获取消息列表失败')
  } finally {
    loading.value = false
  }
}

async function handleSend() {
  if (!form.value.title || !form.value.type || !form.value.content) {
    ElMessage.warning('请填写完整信息')
    return
  }
  sending.value = true
  try {
    await sendMessage(form.value)
    ElMessage.success('发送成功')
    dialogVisible.value = false
    form.value = { title: '', type: '', content: '' }
    await fetchMessages()
  } catch (e) {
    ElMessage.error('发送失败')
  } finally {
    sending.value = false
  }
}

onMounted(() => {
  fetchMessages()
})
</script>

<style scoped>
.message {
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

.msg-type-card {
  border-radius: 8px;
}

.msg-type-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-weight: 600;
}

.msg-type-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.msg-type-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #606266;
  transition: all 0.2s;
}

.msg-type-item:hover,
.msg-type-item.active {
  background-color: #fff1f0;
  color: #E60012;
}

.message-list {
  display: flex;
  flex-direction: column;
}

.message-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background-color 0.2s;
}

.message-item:last-child {
  border-bottom: none;
}

.message-item:hover {
  background-color: #fafafa;
}

.message-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: #dcdfe6;
  flex-shrink: 0;
}

.message-dot.unread {
  background-color: #E60012;
}

.message-content {
  flex: 1;
  min-width: 0;
}

.message-title {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 4px;
}

.message-time {
  font-size: 12px;
  color: #909399;
}
</style>