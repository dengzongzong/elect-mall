<template>
  <div class="cooperate-page">
    <MainHeader />
    <div class="container">
      <div class="breadcrumb">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>合作品牌</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="page-card">
        <h3>合作品牌</h3>
        <p class="page-tip">我们与全球知名半导体品牌建立了深度合作关系</p>
        <div class="coop-grid">
          <div class="coop-brand-card" v-for="b in coopBrands" :key="b.name">
            <div class="coop-logo">{{ b.name.split(' ')[0] }}</div>
            <h4>{{ b.name }}</h4>
            <p>{{ b.desc }}</p>
          </div>
        </div>
      </div>
    </div>
    <MainFooter />
  </div>
</template>

<script setup>
import MainHeader from '../components/MainHeader.vue'
import MainFooter from '../components/MainFooter.vue'

const coopBrands = [
  { name: 'STMicroelectronics', desc: '意法半导体，全球领先的半导体厂商，产品覆盖MCU、传感器、功率器件等' },
  { name: 'Texas Instruments', desc: '德州仪器，模拟器件和嵌入式处理领域的全球领导者' },
  { name: 'NXP Semiconductors', desc: '恩智浦半导体，在汽车电子、安全连接和工业领域具有领先优势' },
  { name: 'Microchip Technology', desc: 'Microchip Technology，MCU、混合信号、模拟和Flash-IP解决方案提供商' },
  { name: 'Infineon Technologies', desc: '英飞凌科技，汽车电子和功率半导体领域的全球领导者' },
  { name: 'Analog Devices', desc: 'ADI亚德诺，高性能模拟、混合信号和数字信号处理技术' },
  { name: 'Maxim Integrated', desc: 'Maxim美信，模拟集成电路设计、开发与制造' },
  { name: 'ON Semiconductor', desc: 'ON安森美，汽车、工业和云电源的智能电源和传感技术' },
  { name: 'Renesas Electronics', desc: '瑞萨电子，全球领先的微控制器和模拟功率器件供应商' },
  { name: 'Intel / Altera', desc: '英特尔/Altera，FPGA和可编程逻辑器件的领先供应商' },
  { name: 'Xilinx (AMD)', desc: '赛灵思，FPGA、自适应SoC和ACAP的全球领导者' },
  { name: 'Broadcom', desc: '博通，有线和无线通信半导体领域的全球领导者' },
]
</script>

<style scoped>
.cooperate-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 20px;
}

.breadcrumb {
  padding: 16px 0;
}

.page-card {
  background: #fff;
  border-radius: 8px;
  padding: 40px;
  margin-bottom: 40px;
}

.page-card h3 {
  font-size: 22px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-tip {
  font-size: 14px;
  color: #999;
  margin-bottom: 30px;
}

.coop-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

.coop-brand-card {
  padding: 30px;
  border: 1px solid #eee;
  border-radius: 8px;
  text-align: center;
  transition: all 0.3s;
}

.coop-brand-card:hover {
  border-color: var(--theme-color);
  box-shadow: 0 4px 16px rgba(230, 0, 18, 0.08);
}

.coop-logo {
  width: 70px;
  height: 70px;
  line-height: 70px;
  margin: 0 auto 16px;
  background: var(--theme-color-light);
  color: var(--theme-color);
  font-size: 18px;
  font-weight: 700;
  border-radius: 50%;
}

.coop-brand-card h4 {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 10px;
}

.coop-brand-card p {
  font-size: 13px;
  color: #888;
  line-height: 1.6;
}
</style>