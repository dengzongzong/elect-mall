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
              <span class="sec-desc">已绑定手机 138****8888</span>
            </div>
          </div>
          <el-button link type="primary">修改</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Message /></el-icon>
            <div>
              <span class="sec-title">邮箱绑定</span>
              <span class="sec-desc">未绑定邮箱</span>
            </div>
          </div>
          <el-button link type="primary">绑定</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Lock /></el-icon>
            <div>
              <span class="sec-title">登录密码</span>
              <span class="sec-desc">建议定期修改密码</span>
            </div>
          </div>
          <el-button link type="primary">修改</el-button>
        </div>
        <div class="security-item">
          <div class="sec-info">
            <el-icon><Key /></el-icon>
            <div>
              <span class="sec-title">支付密码</span>
              <span class="sec-desc">未设置支付密码</span>
            </div>
          </div>
          <el-button link type="primary">设置</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

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
</style>