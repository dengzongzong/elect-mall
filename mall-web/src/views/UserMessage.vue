<template>
  <div class="user-message">
    <div class="section-card">
      <h4>我的消息</h4>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="系统通知" name="system">
          <div class="message-list">
            <div class="message-item" v-for="(m, idx) in systemMessages" :key="idx">
              <div class="msg-icon">
                <el-icon :size="24"><Bell /></el-icon>
              </div>
              <div class="msg-content">
                <h5>{{ m.title }}</h5>
                <p>{{ m.content }}</p>
                <span class="msg-time">{{ m.time }}</span>
              </div>
            </div>
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
import { ref } from 'vue'

const activeTab = ref('system')

const systemMessages = ref([
  { title: '欢迎注册电子元器件商城', content: '感谢您注册成为我们的会员，现在开始选购元器件吧！', time: '2024-03-15 14:30' },
  { title: '账户安全提醒', content: '您的账户在异地登录，如非本人操作请及时修改密码。', time: '2024-03-14 10:00' },
  { title: '优惠活动通知', content: 'STM32系列MCU限时特惠，下单即享9折优惠！', time: '2024-03-12 09:00' },
])
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