// 验证产品对比页与首页配置走后端
const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8080';
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
  page.on('pageerror', (e) => errs.push(e.message));
  page.on('console', (m) => { if (m.type() === 'error') errs.push(m.text()); });

  // 首页：侧边广告/卖点/轮播来自后端
  await page.goto(BASE + '/#/', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2500);
  const ads = await page.locator('.ad-item').count();
  const feats = await page.locator('.feature-card').count();
  rec('首页', '侧边广告(后端 home_block)', ads >= 1, `${ads} 个`);
  rec('首页', '卖点(后端 home_block)', feats >= 1, `${feats} 个`);
  // 顶部推荐品牌
  await page.hover('.mega-trigger, .header-cat-trigger, .category-trigger').catch(() => {});
  await page.hover('.main-nav, .header-nav').catch(() => {});
  const brands = await page.locator('.brand-logo-item').count();
  rec('首页', '推荐品牌(后端 brand/list)', brands >= 1, `${brands} 个`);

  // 产品对比页
  console.log('\n【产品对比】/product-compare');
  await page.goto(BASE + '/#/product-compare', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1200);
  // 添加第一个
  await page.locator('.slot-placeholder').first().click();
  await page.waitForTimeout(800);
  await page.getByPlaceholder('输入型号或名称搜索').fill('C0805');
  await page.locator('.el-dialog').getByRole('button', { name: '搜索' }).click();
  await page.waitForTimeout(1500);
  const res1 = await page.locator('.result-item').count();
  rec('对比', '搜索返回结果', res1 >= 1, `${res1} 条`);
  await page.locator('.result-item').first().click();
  await page.waitForTimeout(1500);
  // 添加第二个
  await page.locator('.slot-placeholder').first().click();
  await page.waitForTimeout(800);
  await page.getByPlaceholder('输入型号或名称搜索').fill('C0603');
  await page.locator('.el-dialog').getByRole('button', { name: '搜索' }).click();
  await page.waitForTimeout(1500);
  const res2 = await page.locator('.result-item').count();
  if (res2 >= 1) {
    await page.locator('.result-item').first().click();
    await page.waitForTimeout(1500);
  }
  const slots = await page.locator('.compare-slot.filled').count();
  rec('对比', '添加商品到槽位', slots >= 2, `${slots} 个`);
  const tableRows = await page.locator('.compare-table table tbody tr').count();
  rec('对比', '对比表格(真实接口)', tableRows > 0, `${tableRows} 行`);
  const partNos = await page.locator('.compare-table td').nth(3).textContent().catch(() => '');
  rec('对比', '展示后端型号', !!partNos && partNos.trim().length > 0, `首列型号=${(partNos||'').trim()}`);
  // 移除
  if (slots > 0) {
    await page.locator('.slot-remove').first().click();
    await page.waitForTimeout(1200);
    const slotsAfter = await page.locator('.compare-slot.filled').count();
    rec('对比', '移除商品', slotsAfter === slots - 1, `${slots} → ${slotsAfter}`);
  }

  console.log('\n==== JS 报错 ====');
  const uniq = [...new Set(errs)];
  if (!uniq.length) console.log('  无');
  else uniq.slice(0, 10).forEach((e) => console.log('  - ' + e.slice(0, 140)));
  const failed = results.filter((r) => !r.ok);
  console.log(`\n==== 汇总: ${results.length - failed.length}/${results.length} 通过 ====`);
  failed.forEach((f) => console.log(`  - [${f.mod}] ${f.action} ${f.note || ''}`));
  await browser.close();
  process.exit(failed.length ? 1 : 0);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
