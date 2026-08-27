<template>
  <footer class="main-footer">
    <div class="footer-service">
      <div class="container">
        <div class="service-grid">
          <div class="service-item">
            <el-icon class="service-icon"><CircleCheck /></el-icon>
            <div class="service-info">
              <h4>100%正品保证</h4>
              <p>所有商品原装正品</p>
            </div>
          </div>
          <div class="service-item">
            <el-icon class="service-icon"><Clock /></el-icon>
            <div class="service-info">
              <h4>极速发货</h4>
              <p>当天16:00前下单当天发货</p>
            </div>
          </div>
          <div class="service-item">
            <el-icon class="service-icon"><Headset /></el-icon>
            <div class="service-info">
              <h4>专业客服</h4>
              <p>在线客服快速响应</p>
            </div>
          </div>
          <div class="service-item">
            <el-icon class="service-icon"><CircleCheck /></el-icon>
            <div class="service-info">
              <h4>无忧售后</h4>
              <p>7天退换货保障</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="footer-links">
      <div class="container">
        <div class="links-grid">
          <div class="links-column">
            <h4>购物指南</h4>
            <a href="#">购物流程</a>
            <a href="#">会员介绍</a>
            <a href="#">常见问题</a>
            <a href="#">联系客服</a>
          </div>
          <div class="links-column">
            <h4>配送方式</h4>
            <a href="#">配送范围</a>
            <a href="#">配送时间</a>
            <a href="#">运费标准</a>
            <a href="#">物流查询</a>
          </div>
          <div class="links-column">
            <h4>支付方式</h4>
            <a href="#">在线支付</a>
            <a href="#">银行转账</a>
            <a href="#">对公汇款</a>
            <a href="#">发票说明</a>
          </div>
          <div class="links-column">
            <h4>售后服务</h4>
            <a href="#">退换货政策</a>
            <a href="#">退换货流程</a>
            <a href="#">投诉建议</a>
            <a href="#">品质保证</a>
          </div>
          <div class="links-column contact-column">
            <h4>联系我们</h4>
            <div class="contact-item">
              <el-icon><Message /></el-icon>
              <span>企业QQ：4008889999</span>
            </div>
            <div class="contact-item">
              <el-icon><ChatLineSquare /></el-icon>
              <span>微信公众号：电子元器件商城</span>
            </div>
            <div class="contact-item">
              <el-icon><Phone /></el-icon>
              <span>客服热线：400-888-9999</span>
            </div>
            <div class="contact-item">
              <el-icon><Clock /></el-icon>
              <span>工作时间：周一至周五 9:00-18:00</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="container">
        <div class="footer-bottom-links">
          <a href="#">关于我们</a>
          <span class="sep">|</span>
          <a href="#">合作品牌</a>
          <span class="sep">|</span>
          <a href="#">合作伙伴</a>
          <span class="sep">|</span>
          <a href="#">投诉建议</a>
          <span class="sep">|</span>
          <a href="#">隐私政策</a>
          <span class="sep">|</span>
          <a href="#">用户协议</a>
        </div>
        <div class="footer-copyright">
          <p>&copy; 2024 电子元器件商城 版权所有</p>
          <p class="icp">备案号：京ICP备xxxxxxxx号 | 京公网安备 xxxxxxxxxxxx号</p>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
</script>

<style scoped>
.main-footer {
  background: #fff;
  border-top: 1px solid #eee;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 服务承诺 */
.footer-service {
  background: #fafafa;
  border-bottom: 1px solid #eee;
  padding: 30px 0;
}

.service-grid {
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.service-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.service-icon {
  font-size: 36px;
  color: var(--theme-color);
}

.service-info h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.service-info p {
  font-size: 13px;
  color: #999;
}

/* 链接区域 */
.footer-links {
  padding: 40px 0 30px;
  background: #fff;
}

.links-grid {
  display: flex;
  gap: 60px;
}

.links-column {
  flex: 1;
}

.links-column h4 {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
}

.links-column a {
  display: block;
  font-size: 13px;
  color: #888;
  line-height: 30px;
  transition: color 0.2s;
}

.links-column a:hover {
  color: var(--theme-color);
}

.contact-column {
  flex: 1.5;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #888;
  line-height: 30px;
}

.contact-item .el-icon {
  color: var(--theme-color);
  font-size: 16px;
}

/* 底部版权 */
.footer-bottom {
  background: #f8f8f8;
  padding: 20px 0;
  border-top: 1px solid #eee;
}

.footer-bottom-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.footer-bottom-links a {
  font-size: 13px;
  color: #888;
  transition: color 0.2s;
}

.footer-bottom-links a:hover {
  color: var(--theme-color);
}

.sep {
  color: #ddd;
  font-size: 12px;
}

.footer-copyright {
  text-align: center;
  font-size: 12px;
  color: #aaa;
  line-height: 22px;
}

.icp {
  color: #bbb;
}
</style>