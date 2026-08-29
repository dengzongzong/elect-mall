// 管理后台(admin-web:8081) UI 增删改查测试
const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8081';

const results = [];
function rec(mod, action, ok, note) {
  results.push({ mod, action, ok, note });
  console.log(`  ${ok ? '✓' : '✗'} [${mod}] ${action}${note ? ' — ' + note : ''}`);
}

const ROUTES = ['dashboard','product','category','brand','bom','inquiry','order','user','finance','carousel','news','datasheet','cooperate','partner','message','feedback','setting'];

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push('pageerror: ' + e.message));
  page.on('console', (m) => { if (m.type() === 'error') errs.push('console: ' + m.text()); });

  // 登录
  console.log('\n【登录】admin/admin123');
  await page.goto(BASE + '/login', { waitUntil: 'domcontentloaded' });
  await page.getByPlaceholder('请输入用户名').fill('admin');
  await page.getByPlaceholder('请输入密码').fill('admin123');
  await page.getByRole('button', { name: /登\s*录/ }).click();
  await page.waitForTimeout(1800);
  const tok = await page.evaluate(() => localStorage.getItem('admin_token'));
  rec('登录', 'admin 登录', !!tok, tok ? '已登录' : '未拿到 token');
  if (!tok) { await browser.close(); process.exit(1); }

  // 冒烟：遍历所有管理路由
  console.log('\n【冒烟】遍历管理路由');
  for (const r of ROUTES) {
    await page.goto(BASE + '/' + r, { waitUntil: 'domcontentloaded' });
    await page.waitForTimeout(900);
    const hasError = await page.locator('.el-error, .error-page').count();
    const title = await page.locator('h1, h2, .page-title, .page-header h2, .card-header h4').first().textContent().catch(() => '');
    rec('冒烟', '/' + r, hasError === 0, (title || '').trim().slice(0, 20) || '已渲染');
  }

  // ---------- 品牌 CRUD ----------
  console.log('\n【品牌管理】CRUD');
  await page.goto(BASE + '/brand', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(1200);
  const brandMark = '测试品牌' + Date.now().toString().slice(-5);
  await page.getByRole('button', { name: /新增品牌/ }).click();
  await page.waitForTimeout(600);
  await page.locator('.el-dialog input').first().fill(brandMark);
  await page.locator('.el-dialog').getByRole('button', { name: '保存' }).click();
  await page.waitForTimeout(1500);
  const brandInList = (await page.locator('.el-table__row', { hasText: brandMark }).count()) > 0;
  rec('品牌', 'C 新增', brandInList, brandMark);
  if (brandInList) {
    await page.locator('.el-table__row', { hasText: brandMark }).getByRole('button', { name: '删除' }).click();
    await page.waitForTimeout(800);
    await page.locator('.el-message-box .el-button--primary').click();
    await page.waitForTimeout(1500);
    const brandGone = (await page.locator('.el-table__row', { hasText: brandMark }).count()) === 0;
    rec('品牌', 'D 删除', brandGone, brandGone ? '已删除' : '删除后仍存在');
  }

  // ---------- 分类 CRUD ----------
  console.log('\n【分类管理】CRUD');
  await page.goto(BASE + '/category', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(1500);
  const catMark = '测试分类' + Date.now().toString().slice(-5);
  await page.getByRole('button', { name: /新增分类/ }).click();
  await page.waitForTimeout(800);
  await page.locator('.el-dialog input').first().fill(catMark);
  await page.locator('.el-dialog').getByRole('button', { name: '保存' }).click();
  await page.waitForTimeout(1800);
  const catInList = (await page.locator('.el-table__row', { hasText: catMark }).count()) > 0;
  rec('分类', 'C 新增', catInList, catMark);
  if (catInList) {
    await page.locator('.el-table__row', { hasText: catMark }).getByRole('button', { name: '删除' }).click();
    await page.waitForTimeout(800);
    await page.locator('.el-message-box .el-button--primary').click();
    await page.waitForTimeout(1800);
    const catGone = (await page.locator('.el-table__row', { hasText: catMark }).count()) === 0;
    rec('分类', 'D 删除', catGone, catGone ? '已删除' : '删除后仍存在');
  }

  // ---------- 商品 CRUD ----------
  console.log('\n【商品管理】CRUD');
  await page.goto(BASE + '/product', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(1500);
  const prodMark = '自动化测试商品' + Date.now().toString().slice(-5);
  await page.getByRole('button', { name: /新增商品/ }).click();
  await page.waitForTimeout(800);
  await page.locator('.el-dialog').getByPlaceholder('请输入商品名称').fill(prodMark);
  await page.locator('.el-dialog').getByPlaceholder('请输入料号').fill('TST-' + Date.now().toString().slice(-6));
  await page.locator('.el-dialog .el-input-number').nth(0).locator('input').fill('1.234'); // 价格
  await page.locator('.el-dialog .el-input-number').nth(1).locator('input').fill('10'); // 库存
  await page.locator('.el-dialog').getByRole('button', { name: '保存' }).click();
  await page.waitForTimeout(2000);
  const prodInList = (await page.locator('.el-table__row', { hasText: prodMark }).count()) > 0;
  rec('商品', 'C 新增', prodInList, prodMark);
  if (prodInList) {
    await page.locator('.el-table__row', { hasText: prodMark }).getByRole('button', { name: '删除' }).click();
    await page.waitForTimeout(800);
    await page.locator('.el-message-box .el-button--primary').click();
    await page.waitForTimeout(2000);
    const prodGone = (await page.locator('.el-table__row', { hasText: prodMark }).count()) === 0;
    rec('商品', 'D 删除', prodGone, prodGone ? '已删除' : '删除后仍存在');
  }

  console.log('\n==== JS 报错 ====');
  const uniq = [...new Set(errs)];
  if (!uniq.length) console.log('  无');
  else uniq.slice(0, 12).forEach((e) => console.log('  - ' + e.slice(0, 150)));

  const failed = results.filter((r) => !r.ok);
  console.log(`\n==== 汇总: ${results.length - failed.length}/${results.length} 通过 ====`);
  failed.forEach((f) => console.log(`  - [${f.mod}] ${f.action} ${f.note || ''}`));
  await browser.close();
  process.exit(failed.length ? 1 : 0);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
