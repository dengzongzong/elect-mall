// 验证 Datasheet/BindPhone 接通真实接口
const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8080';
const PHONE = '13900008888';

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push(e.message));
  page.on('console', (m) => { if (m.type() === 'error') errs.push(m.text()); });

  // Datasheet
  await page.goto(BASE + '/#/datasheet', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1800);
  const items = await page.locator('.ds-item').count();
  const firstTitle = await page.locator('.ds-item h4').first().textContent().catch(() => '');
  console.log(`${items > 0 ? '✓' : '✗'} Datasheet 列表 ${items} 条（真实接口），首条: ${(firstTitle || '').trim()}`);
  // 搜索过滤
  await page.getByPlaceholder('输入型号搜索数据手册...').fill('API');
  await page.waitForTimeout(600);
  const filtered = await page.locator('.ds-item').count();
  console.log(`${filtered > 0 ? '✓' : '✗'} Datasheet 搜索过滤 ${filtered} 条`);

  // BindPhone 渲染正常
  await page.goto(BASE + '/#/bindPhone', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1200);
  const hasInput = (await page.locator('input[placeholder]').count()) > 0;
  console.log(`${hasInput ? '✓' : '✗'} BindPhone 页面渲染正常`);

  console.log(errs.length ? 'JS错误:\n  ' + [...new Set(errs)].slice(0,5).join('\n  ') : 'JS错误: 无');
  await browser.close();
  process.exit(0);
})().catch((e) => { console.error('异常: ' + e.message); process.exit(2); });
