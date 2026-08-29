const { chromium } = require('playwright-core');
const CHROME = 'C:/Users/MateBook D/AppData/Local/ms-playwright/chromium-1234/chrome-win64/chrome.exe';

(async () => {
  const browser = await chromium.launch({ executablePath: CHROME, headless: true });
  const page = await browser.newPage();
  const errs = [];
  page.on('pageerror', (e) => errs.push(e.message));
  page.on('console', (m) => { if (m.type() === 'error') errs.push(m.text()); });

  await page.goto('http://localhost:8080/#/', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2500);

  // 一级菜单点击
  const firstCat = (await page.$$('.cat-link'))[0];
  const catText = await firstCat.textContent();
  const catHref = await firstCat.evaluate(el => el.href);
  await firstCat.click({ force: true });
  await page.waitForTimeout(1500);
  console.log('一级菜单点击:', catText.trim(), '->', page.url(), page.url().includes('/category/') ? 'OK' : 'FAIL');

  // 回到首页，悬停一级菜单，点击子面板里的三级子项
  await page.goto('http://localhost:8080/#/', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const item = (await page.$$('.category-item'))[0];
  await item.hover();
  await page.waitForTimeout(600);
  const subLinks = await page.$$('.sub-cat-link');
  console.log('子分类链接数量:', subLinks.length);
  if (subLinks.length > 0) {
    const href = await subLinks[0].evaluate(el => el.href);
    const txt = await subLinks[0].textContent();
    await subLinks[0].click();
    await page.waitForTimeout(1500);
    console.log('三级子项点击:', txt.trim(), '->', page.url(), page.url().includes('/category/') ? 'OK' : 'FAIL');
  }
  // 二级分组标题
  await page.goto('http://localhost:8080/#/', { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const item2 = (await page.$$('.category-item'))[0];
  await item2.hover();
  await page.waitForTimeout(600);
  const titles = await page.$$('.sub-cat-title');
  console.log('二级分组标题数量:', titles.length);
  if (titles.length > 0) {
    const href = await titles[0].evaluate(el => el.href);
    const txt = await titles[0].textContent();
    await titles[0].click();
    await page.waitForTimeout(1500);
    console.log('二级标题点击:', txt.trim(), '->', page.url(), page.url().includes('/category/') ? 'OK' : 'FAIL');
  }

  console.log('JS报错:', errs.length ? errs.slice(0,5) : '无');
  await browser.close();
})();
