// 新增补全功能的 UI 验证：型号管理/账户安全(邮箱)/BOM 提交
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
  rec('登录', 'phone-login', !!(await page.evaluate(() => localStorage.getItem('token'))));

  // ---------- 型号管理 ----------
  console.log('\n【型号管理】/user/partNo');
  await page.goto(BASE + '/#/user/partNo', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const before = await page.locator('.partno-item').count();
  const mark = 'REG-PARTNO-' + Date.now().toString().slice(-5);
  await page.getByRole('button', { name: '添加型号' }).click();
  await page.getByPlaceholder('输入型号').fill(mark);
  await page.getByRole('button', { name: '添加', exact: true }).click();
  await page.waitForTimeout(1500);
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const added = (await page.locator('.partno-item', { hasText: mark }).count()) > 0;
  rec('型号管理', 'C 新增(刷新后仍在)', added, `共${before}→${before + 1}`);
  if (added) {
    await page.locator('.partno-item', { hasText: mark }).getByText('删除').click();
    await page.waitForTimeout(800);
    await page.getByRole('button', { name: /确定/ }).click();
    await page.waitForTimeout(1500);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1500);
    const gone = (await page.locator('.partno-item', { hasText: mark }).count()) === 0;
    rec('型号管理', 'D 删除(刷新后不复活)', gone);
  }

  // ---------- 账户安全：邮箱绑定 ----------
  console.log('\n【账户安全】/user/security');
  await page.goto(BASE + '/#/user/security', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const phoneShown = (await page.locator('.sec-desc').first().textContent()).includes(PHONE.slice(0, 3));
  rec('账户安全', 'R 显示真实手机号', phoneShown, '手机绑定行显示已绑定');
  const emailMark = 'sec-' + Date.now().toString().slice(-5) + '@test.com';
  // 邮箱行按钮可能是「绑定」或「修改」，按行定位
  await page.locator('.security-item').nth(1).getByRole('button').click();
  await page.waitForTimeout(800);
  await page.getByPlaceholder('请输入邮箱地址').fill(emailMark);
  await page.getByRole('button', { name: '确认' }).click();
  await page.waitForTimeout(1500);
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const emailShown = (await page.locator('.sec-desc').nth(1).textContent()).includes(emailMark);
  rec('账户安全', 'U 绑定邮箱(刷新后仍在)', emailShown, `email=${emailMark}`);

  // ---------- BOM ----------
  console.log('\n【BOM】/bom');
  await page.goto(BASE + '/#/bom', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await page.getByRole('button', { name: '手动输入BOM' }).click();
  await page.getByPlaceholder('输入型号，多个用逗号分隔').fill('C0805C104K5RAC, 不存在的料号XYZ');
  await page.getByPlaceholder('输入对应数量').fill('5, 2');
  await page.getByRole('button', { name: '提交查询' }).click();
  await page.waitForTimeout(2500);
  const resultShown = (await page.locator('.bom-result').count()) > 0;
  rec('BOM', 'C 提交显示结果', resultShown, resultShown ? '结果表已渲染' : '无结果');
  if (resultShown) {
    const summary = await page.locator('.result-summary').textContent();
    const matched = /匹配到\s*(\d+)/.test(summary);
    rec('BOM', '匹配统计', matched, summary.trim());
  }
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(1800);
  const history = (await page.locator('.bom-history .record-item').count()) > 0;
  rec('BOM', 'R 历史记录(刷新后仍在)', history, history ? '记录已持久化' : '无历史记录');
  if (history) {
    const beforeH = await page.locator('.bom-history .record-item').count();
    await page.locator('.bom-history .record-item').first().getByText('删除').click();
    await page.waitForTimeout(800);
    await page.getByRole('button', { name: /确定/ }).click();
    await page.waitForTimeout(1800);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(1800);
    const afterH = await page.locator('.bom-history .record-item').count();
    rec('BOM', 'D 删除记录(刷新后不复活)', afterH < beforeH, `${beforeH} → ${afterH}`);
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
