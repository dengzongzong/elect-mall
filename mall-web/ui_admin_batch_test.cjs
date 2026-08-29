// 管理后台 批量删除 + 过滤查询 验证
const { chromium } = require('playwright-core');
const { execSync } = require('child_process');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8081';
const MYSQL = '"E:/yejing/mysql-8.4.3-winx64/bin/mysql.exe"';
function dbQuery(sql) {
  const safeSql = sql.replace(/"/g, '\\"');
  try {
    return execSync(`${MYSQL} -uroot -p123456 mall_db -N -e "${safeSql}"`, { stdio: ['pipe', 'pipe', 'ignore'] }).toString().trim();
  } catch (e) { return 'ERR'; }
}
const results = [];
function rec(mod, action, ok, note) {
  results.push({ mod, action, ok, note });
  console.log(`  ${ok ? '✓' : '✗'} [${mod}] ${action}${note ? ' — ' + note : ''}`);
}

const ROUTES = ['product','category','brand','bom','inquiry','order','user','carousel','news','datasheet','cooperate','partner','message','feedback'];

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push(e.message));

  // 登录
  await page.goto(BASE + '/login', { waitUntil: 'domcontentloaded' });
  await page.getByPlaceholder('请输入用户名').fill('admin');
  await page.getByPlaceholder('请输入密码').fill('admin123');
  await page.getByRole('button', { name: /登\s*录/ }).click();
  await page.waitForTimeout(2000);
  rec('登录', 'admin', !!(await page.evaluate(() => localStorage.getItem('admin_token'))));

  // 各页面冒烟：有批量删除按钮 + 无 JS 报错
  console.log('\n【冒烟】批量删除按钮存在性');
  for (const r of ROUTES) {
    const preErr = errs.length;
    await page.goto(BASE + '/' + r, { waitUntil: 'domcontentloaded' });
    await page.waitForTimeout(1500);
    const hasBtn = (await page.getByRole('button', { name: /批量删除/ }).count()) > 0;
    rec('冒烟', '/' + r, hasBtn && errs.length === preErr, hasBtn ? '有批量删除按钮' : '缺按钮');
  }

  // ---------- 品牌：搜索 + 批量删除 ----------
  console.log('\n【品牌】搜索+批量删除');
  const b1 = '批量测试A' + Date.now().toString().slice(-4);
  const b2 = '批量测试B' + Date.now().toString().slice(-4);
  await page.goto(BASE + '/brand', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(1500);
  // 新增 2 个测试品牌
  for (const name of [b1, b2]) {
    await page.getByRole('button', { name: /新增品牌/ }).click();
    await page.waitForTimeout(500);
    await page.locator('.el-dialog input').first().fill(name);
    await page.locator('.el-dialog').getByRole('button', { name: '保存' }).click();
    await page.waitForTimeout(1200);
  }
  const db2 = dbQuery(`SELECT COUNT(*) FROM brand WHERE name IN ('${b1}','${b2}') AND (deleted=0 OR deleted IS NULL)`);
  rec('品牌', '新增2条(DB)', Number(db2) === 2, `brand表=${db2}条`);
  // 搜索过滤
  await page.locator('.header-actions input').fill(b1.slice(0, 5));
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1200);
  const rows1 = await page.locator('.el-table__row:visible').count();
  rec('品牌', '搜索过滤', rows1 === 1, `搜索后剩 ${rows1} 行`);
  // 清空搜索
  await page.locator('.header-actions input').fill('');
  await page.keyboard.press('Enter');
  await page.waitForTimeout(1200);
  // 勾选 2 个并批量删除
  await page.locator('.el-table__row', { hasText: b1 }).locator('.el-checkbox').first().click();
  await page.locator('.el-table__row', { hasText: b2 }).locator('.el-checkbox').first().click();
  await page.waitForTimeout(300);
  await page.getByRole('button', { name: /批量删除/ }).click();
  await page.waitForTimeout(600);
  await page.locator('.el-message-box .el-button--primary').click();
  await page.waitForTimeout(1800);
  const dbAfter = dbQuery(`SELECT COUNT(*) FROM brand WHERE name IN ('${b1}','${b2}') AND (deleted=0 OR deleted IS NULL)`);
  rec('品牌', '批量删除(DB)', Number(dbAfter) === 0, `brand表=${dbAfter}条`);

  // ---------- 商品：批量删除 ----------
  console.log('\n【商品】批量删除');
  const p1 = '批量商品P' + Date.now().toString().slice(-4);
  const p2 = '批量商品Q' + Date.now().toString().slice(-4);
  await page.goto(BASE + '/product', { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(1500);
  for (const [name, pn] of [[p1, 'BT-P1'], [p2, 'BT-P2']]) {
    await page.getByRole('button', { name: /新增商品/ }).click();
    await page.waitForTimeout(500);
    await page.locator('.el-dialog').getByPlaceholder('请输入商品名称').fill(name);
    await page.locator('.el-dialog').getByPlaceholder('请输入料号').fill(pn + Date.now().toString().slice(-4));
    await page.locator('.el-dialog .el-input-number').nth(0).locator('input').fill('0.5');
    await page.locator('.el-dialog .el-input-number').nth(1).locator('input').fill('5');
    await page.locator('.el-dialog').getByRole('button', { name: '保存' }).click();
    await page.waitForTimeout(1500);
  }
  const dp = dbQuery(`SELECT COUNT(*) FROM product WHERE name IN ('${p1}','${p2}')`);
  rec('商品', '新增2条(DB)', Number(dp) === 2, `product表=${dp}条`);
  await page.locator('.el-table__row', { hasText: p1 }).locator('.el-checkbox').first().click();
  await page.locator('.el-table__row', { hasText: p2 }).locator('.el-checkbox').first().click();
  await page.waitForTimeout(300);
  await page.getByRole('button', { name: /批量删除/ }).click();
  await page.waitForTimeout(600);
  await page.locator('.el-message-box .el-button--primary').click();
  await page.waitForTimeout(1800);
  const dpAfter = dbQuery(`SELECT COUNT(*) FROM product WHERE name IN ('${p1}','${p2}')`);
  rec('商品', '批量删除(DB)', Number(dpAfter) === 0, `product表=${dpAfter}条`);

  console.log('\n==== JS 报错 ====');
  const uniq = [...new Set(errs)];
  if (!uniq.length) console.log('  无');
  else uniq.slice(0, 8).forEach((e) => console.log('  - ' + e.slice(0, 130)));
  const failed = results.filter((r) => !r.ok);
  console.log(`\n==== 汇总: ${results.length - failed.length}/${results.length} 通过 ====`);
  failed.forEach((f) => console.log(`  - [${f.mod}] ${f.action} ${f.note || ''}`));
  await browser.close();
  process.exit(failed.length ? 1 : 0);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
