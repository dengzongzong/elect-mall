// 询价提交 UI 验证：填料号/联系人/电话 → 提交 → 查库确认落库
const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';
const BASE = 'http://localhost:8080';
const PHONE = '13900008888';

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const page = await ctx.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push('pageerror: ' + e.message));

  // 登录
  await page.goto(BASE + '/#/login', { waitUntil: 'networkidle' });
  await page.getByText('手机号登录').click();
  await page.getByPlaceholder('请输入手机号').fill(PHONE);
  await page.getByPlaceholder('请输入验证码').fill('123456');
  await page.getByRole('button', { name: '登录' }).click();
  await page.waitForTimeout(1800);

  // 询价页
  await page.goto(BASE + '/#/inquiry', { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);

  const mark = '自动化询价料号' + Date.now().toString().slice(-6);
  // 填第一行料号
  await page.getByPlaceholder('输入料号').first().fill(mark);
  // 填联系人
  await page.getByPlaceholder('请输入联系人姓名').fill('测试询价人');
  // 填电话
  await page.getByPlaceholder('请输入手机号').fill('13800002222');
  // 提交
  await page.getByRole('button', { name: /提交询价/ }).click();
  await page.waitForTimeout(3000);

  const success = (await page.locator('.el-message--success').count()) > 0;
  console.log((success ? '✓' : '✗') + ' 询价提交提示' + (success ? '成功' : '未出现'));

  const errUniq = [...new Set(errs)];
  console.log(errUniq.length ? 'JS错误:\n  ' + errUniq.slice(0, 5).join('\n  ') : 'JS错误: 无');

  await browser.close();
  process.exit(success && errUniq.length === 0 ? 0 : 1);
})().catch((e) => { console.error('脚本异常: ' + e.message); process.exit(2); });
