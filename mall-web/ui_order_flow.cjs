// 下单主流程 UI 验证：加购 → 购物车 → 结算 → 下单 → 支付 → 订单列表
const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8080';
const PHONE = '13900008888';

const results = [];
function rec(mod, action, ok, note) {
  results.push({ mod, action, ok, note });
  console.log(`  ${ok ? '✓' : '✗'} [${mod}] ${action}${note ? ' — ' + note : ''}`);
}

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push('pageerror: ' + e.message));
  page.on('console', (m) => { if (m.type() === 'error') errs.push('console: ' + m.text()); });

  // 登录
  await page.goto(BASE + '/#/login', { waitUntil: 'networkidle' });
  await page.getByText('手机号登录').click();
  await page.getByPlaceholder('请输入手机号').fill(PHONE);
  await page.getByPlaceholder('请输入验证码').fill('123456');
  await page.getByRole('button', { name: '登录' }).click();
  await page.waitForTimeout(1800);
  const token = await page.evaluate(() => localStorage.getItem('token'));
  rec('登录', 'phone-login', !!token);

  // 确保有一个收货地址
  await page.goto(BASE + '/#/user/address', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  if ((await page.locator('.address-item').count()) === 0) {
    await page.getByRole('button', { name: '新增地址' }).click();
    await page.waitForTimeout(600);
    await page.locator('.el-dialog input').nth(0).fill('默认收货人');
    await page.locator('.el-dialog input').nth(1).fill('13800001111');
    await page.locator('.el-dialog textarea').first().fill('默认测试地址100号');
    await page.getByRole('button', { name: '保存' }).click();
    await page.waitForTimeout(1500);
  }
  rec('准备', '存在收货地址', (await page.locator('.address-item').count()) > 0);

  // 1. 加购
  await page.goto(BASE + '/#/product/4', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1800);
  await page.getByRole('button', { name: '加入购物车' }).click();
  await page.waitForTimeout(2000);

  // 2. 购物车
  await page.goto(BASE + '/#/cart', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const cartRows = await page.locator('.cart-item').count();
  rec('购物车', '加购后有商品', cartRows > 0, `${cartRows} 行`);

  // 3. 结算
  await page.goto(BASE + '/#/checkout', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2500);
  const addrCards = await page.locator('.address-card').count();
  rec('结算', '加载真实收货地址', addrCards > 0, `${addrCards} 个地址`);
  const selAddr = await page.locator('.address-card.selected').count();
  rec('结算', '自动选中首个地址', selAddr > 0);

  // 4. 提交订单
  await page.getByRole('button', { name: /提交订单|去结算|确认订单/ }).first().click();
  await page.waitForTimeout(3000);
  const url = page.url();
  const onPayPage = url.includes('/#/pay/');
  rec('下单', '跳转到支付页', onPayPage, url.split('#').pop() || url);
  const orderNo = onPayPage ? decodeURIComponent(url.split('/pay/')[1] || '') : '';
  // 后端格式：ORD + YmdHis(14位) + rand(4位)
  rec('下单', '订单号为后端真实单号', /^ORD\d{14}\d{4}$/.test(orderNo), `订单号=${orderNo}`);

  // 5. 支付
  if (onPayPage) {
    await page.getByRole('button', { name: /立即支付/ }).click();
    await page.waitForTimeout(3000);
    const afterUrl = page.url();
    rec('支付', '支付后跳转订单列表', afterUrl.includes('/order/list'), afterUrl.split('#').pop());
  }

  // 6. 订单列表核对
  await page.goto(BASE + '/#/order/list', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2500);
  const hasOrder = (await page.locator('.order-card:visible', { hasText: orderNo }).count()) > 0;
  rec('订单列表', '新订单出现在列表', hasOrder, `orderNo=${orderNo}`);
  const paidTag = await page.locator('.order-card:visible', { hasText: orderNo }).locator('.order-status').first().textContent();
  rec('订单列表', '状态为已支付', (paidTag || '').includes('已支付'), `状态=${(paidTag || '').trim()}`);

  // 7. 购物车已清空
  await page.goto(BASE + '/#/cart', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const cartAfter = await page.locator('.cart-item').count();
  rec('购物车', '下单后已清空', cartAfter === 0, `剩余 ${cartAfter} 行`);

  // 8. 订单详情含明细
  if (orderNo) {
    await page.goto(BASE + '/#/order/list', { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000);
    await page.locator('.order-card:visible', { hasText: orderNo }).getByText('订单详情').click();
    await page.waitForTimeout(2500);
    const items = await page.locator('.item-row').count();
    rec('订单详情', '含商品明细', items > 0, `${items} 条明细`);
  }

  console.log('\n==== JS 报错 ====');
  const uniq = [...new Set(errs)];
  if (!uniq.length) console.log('  无');
  else uniq.slice(0, 12).forEach((e) => console.log('  - ' + e.slice(0, 160)));

  const failed = results.filter((r) => !r.ok);
  console.log(`\n==== 汇总: ${results.length - failed.length}/${results.length} 通过 ====`);
  failed.forEach((f) => console.log(`  - [${f.mod}] ${f.action} ${f.note || ''}`));
  await browser.close();
  process.exit(failed.length ? 1 : 0);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
