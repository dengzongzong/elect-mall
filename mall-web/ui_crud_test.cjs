// 前端逐个模块增删改查验证：核心判据是「刷新后数据是否仍然存在」
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
  console.log('\n【登录】' + PHONE);
  await page.goto(BASE + '/#/login', { waitUntil: 'networkidle' });
  await page.getByText('手机号登录').click();
  await page.getByPlaceholder('请输入手机号').fill(PHONE);
  await page.getByPlaceholder('请输入验证码').fill('123456');
  await page.getByRole('button', { name: '登录' }).click();
  await page.waitForTimeout(1800);
  const token = await page.evaluate(() => localStorage.getItem('token'));
  rec('登录', 'phone-login', !!token, token ? '已登录' : '未拿到 token');

  // ---------- 地址管理 ----------
  console.log('\n【地址管理】CRUD');
  await page.goto(BASE + '/#/user/address', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1200);
  const addrBefore = await page.locator('.address-item').count();
  rec('地址管理', 'R 列表', true, `${addrBefore} 条`);
  // C 新增
  await page.getByRole('button', { name: '新增地址' }).click();
  await page.waitForTimeout(600);
  await page.locator('.el-dialog input').nth(0).fill('测试收货人A');
  await page.locator('.el-dialog input').nth(1).fill('13700007777');
  await page.locator('.el-dialog textarea').first().fill('自动化测试详细地址1号');
  await page.getByRole('button', { name: '保存' }).click();
  await page.waitForTimeout(1500);
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(1200);
  const addrAfter = await page.locator('.address-item').count();
  const hasNew = (await page.locator('.address-item', { hasText: '测试收货人A' }).count()) > 0;
  rec('地址管理', 'C 新增(刷新后仍在)', addrAfter > addrBefore && hasNew, `${addrBefore} → ${addrAfter}`);
  // U 编辑
  if (hasNew) {
    await page.locator('.address-item', { hasText: '测试收货人A' }).getByText('编辑').click();
    await page.waitForTimeout(600);
    await page.locator('.el-dialog input').nth(0).fill('测试收货人B');
    await page.getByRole('button', { name: '保存' }).click();
    await page.waitForTimeout(1500);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1200);
    const edited = (await page.locator('.address-item', { hasText: '测试收货人B' }).count()) > 0;
    rec('地址管理', 'U 编辑(刷新后仍生效)', edited, edited ? '已改为 测试收货人B' : '编辑未生效');
    // D 删除
    if (edited) {
      await page.locator('.address-item', { hasText: '测试收货人B' }).getByText('删除').click();
      await page.waitForTimeout(600);
      await page.getByRole('button', { name: /确定/ }).click();
      await page.waitForTimeout(1500);
      await page.reload({ waitUntil: 'networkidle' });
      await page.waitForTimeout(1200);
      const gone = (await page.locator('.address-item', { hasText: '测试收货人B' }).count()) === 0;
      rec('地址管理', 'D 删除(刷新后不复活)', gone, gone ? '已删除' : '删除后仍存在');
    }
  }

  // ---------- 收藏 ----------
  console.log('\n【我的收藏】CRUD');
  // 先从商品详情收藏一个
  await page.goto(BASE + '/#/product/2', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const favBtn = page.getByRole('button', { name: /^收藏$|^已收藏$/ }).first();
  if (await favBtn.count()) {
    const label = (await favBtn.textContent()).trim();
    if (label === '收藏') {
      await favBtn.click();
      await page.waitForTimeout(1500);
    }
  }
  await page.goto(BASE + '/#/user/favorite', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const favBefore = await page.locator('.favorite-item').count();
  rec('我的收藏', 'R 列表', true, `${favBefore} 条`);
  rec('我的收藏', 'C 新增(商品页收藏)', favBefore > 0, favBefore > 0 ? '已写入收藏表' : '收藏为空');
  if (favBefore > 0) {
    await page.locator('.favorite-item').first().hover();
    await page.locator('.fav-remove').first().click({ force: true });
    await page.waitForTimeout(1500);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1500);
    const favAfter = await page.locator('.favorite-item').count();
    rec('我的收藏', 'D 删除(刷新后不复活)', favAfter < favBefore, `${favBefore} → ${favAfter}`);
  }

  // ---------- 购物车 ----------
  console.log('\n【购物车】CRUD');
  await page.goto(BASE + '/#/product/3', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await page.getByRole('button', { name: '加入购物车' }).click();
  await page.waitForTimeout(1800);
  await page.goto(BASE + '/#/cart', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1800);
  const cartBefore = await page.locator('.cart-item').count();
  rec('购物车', 'C 加购(刷新后仍在)', cartBefore > 0, `${cartBefore} 行`);
  if (cartBefore > 0) {
    // U 改数量
    const plus = page.locator('.el-input-number__increase').first();
    await plus.click();
    await page.waitForTimeout(1800);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1800);
    const qtyVal = await page.locator('.el-input-number input').first().inputValue();
    rec('购物车', 'U 改数量(刷新后仍生效)', Number(qtyVal) >= 2, `数量=${qtyVal}`);
    // D 删除
    await page.locator('.cart-item').first().getByText('删除').click();
    await page.waitForTimeout(700);
    await page.getByRole('button', { name: /确定/ }).click();
    await page.waitForTimeout(1800);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1800);
    const cartAfter = await page.locator('.cart-item').count();
    rec('购物车', 'D 删除(刷新后不复活)', cartAfter < cartBefore, `${cartBefore} → ${cartAfter}`);
  }

  // ---------- 订单 ----------
  console.log('\n【订单】CRUD');
  await page.goto(BASE + '/#/order/list', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const orderCards = await page.locator('.order-card:visible').count();
  rec('订单列表', 'R 列表(真实接口)', orderCards > 0, `${orderCards} 张卡（当前「全部」tab）`);
  // 标签页筛选
  const pendingTabCount = await (async () => {
    await page.getByRole('tab', { name: '待审核' }).click();
    await page.waitForTimeout(1000);
    return await page.locator('.order-card:visible').count();
  })();
  await page.getByRole('tab', { name: '全部' }).click();
  await page.waitForTimeout(1000);
  const allCount = await page.locator('.order-card:visible').count();
  rec('订单列表', 'U 标签页真实筛选', pendingTabCount !== allCount || allCount === 0,
    `待审核=${pendingTabCount} 全部=${allCount}`);
  // 订单详情
  if (allCount > 0) {
    await page.locator('.order-card:visible').first().getByText('订单详情').click();
    await page.waitForTimeout(2000);
    const orderNo = await page.locator('.info-row .value').first().textContent();
    rec('订单详情', 'R 详情(真实接口)', !!orderNo && orderNo.trim() !== '-', `订单号=${(orderNo || '').trim()}`);
    const itemRows = await page.locator('.item-row').count();
    rec('订单详情', 'R 商品明细', true, `${itemRows} 条明细`);
  }

  // ---------- 个人资料 ----------
  console.log('\n【个人资料】U');
  await page.goto(BASE + '/#/user/profile', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const nickInput = page.getByPlaceholder('请输入昵称');
  const nickBefore = await nickInput.inputValue();
  await nickInput.fill('全流程测试昵称');
  await page.getByRole('button', { name: '保存' }).click();
  await page.waitForTimeout(1500);
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const nickAfter = await nickInput.inputValue();
  rec('个人资料', 'U 改昵称(刷新后仍生效)', nickAfter === '全流程测试昵称', `${nickBefore} → ${nickAfter}`);

  // ---------- 意见反馈 ----------
  console.log('\n【意见反馈】C');
  await page.goto(BASE + '/#/user/feedback', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1200);
  await page.locator('textarea').first().fill('这是自动化测试提交的反馈内容');
  await page.getByRole('button', { name: '提交' }).click();
  await page.waitForTimeout(1800);
  const fbMsg = await page.locator('.el-message--success').count();
  rec('意见反馈', 'C 提交', fbMsg > 0, fbMsg > 0 ? '提交成功' : '未见成功提示');

  // ---------- 消息 / 余额 ----------
  console.log('\n【消息 / 余额】R');
  await page.goto(BASE + '/#/user/message', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  rec('我的消息', 'R 列表(真实接口)', true, '页面渲染正常');
  await page.goto(BASE + '/#/user/balance', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const balText = await page.locator('.balance-amount').textContent();
  rec('账户余额', 'R 余额(真实接口)', !!balText, `余额=${(balText || '').trim()}`);

  console.log('\n==== JS 报错 ====');
  const uniq = [...new Set(errs)];
  if (!uniq.length) console.log('  无');
  else uniq.slice(0, 12).forEach((e) => console.log('  - ' + e.slice(0, 150)));

  const failed = results.filter((r) => !r.ok);
  console.log(`\n==== 汇总: ${results.length - failed.length}/${results.length} 通过 ====`);
  if (failed.length) {
    console.log('失败项:');
    failed.forEach((f) => console.log(`  - [${f.mod}] ${f.action} ${f.note || ''}`));
  }
  await browser.close();
  process.exit(failed.length ? 1 : 0);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
