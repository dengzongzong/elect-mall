<template>
  <div class="user-message">
    <div class="section-card">
      <h4>我的消息</h4>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="系统通知" name="system">
          <div class="message-list">
            <div class="message-item" v-for="m in messages" :key="m.id">
              <div class="msg-icon">
                <el-icon :size="24"><Bell /></el-icon>
              </div>
              <div class="msg-content">
                <h5>{{ m.title }}</h5>
                <p>{{ m.content }}</p>
                <span class="msg-time">{{ m.created_at }}</span>
              </div>
            </div>
          </div>
          <div class="empty-state" v-if="messages.length === 0">
            <el-icon><Folder /></el-icon>
            <p>暂无系统通知</p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="订单消息" name="order">
          <div class="empty-state">
            <el-icon><Folder /></el-icon>
            <p>暂无订单消息</p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="询价回复" name="inquiry">
          <div class="empty-state">
            <el-icon><Folder /></el-icon>
            <p>暂无询价回复</p>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMessageList } from '../api/user'

const activeTab = ref('system')

// message 表无类型字段，统一在系统通知中展示
const messages = ref([])

async function fetchMessages() {
  try {
    const res = await getMessageList()
    messages.value = Array.isArray(res) ? res : []
  } catch (e) {
    messages.value = []
  }
}

onMounted(() => {
  fetchMessages()
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

.message-list {
  display: flex;
  flex-direction: column;
}

.message-item {
  display: flex;
  gap: 16px;
  padding: 16px 0;
  border-bottom: 1px solid #f5f5f5;
}

.message-item:last-child {
  border-bottom: none;
}

.msg-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--theme-color-light);
  color: var(--theme-color);
  border-radius: 50%;
  flex-shrink: 0;
}

.msg-content h5 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.msg-content p {
  font-size: 13px;
  color: #888;
  margin-bottom: 4px;
  line-height: 1.5;
}

.msg-time {
  font-size: 12px;
  color: #bbb;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
  color: #ccc;
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 12px;
}
</style>