import { expect } from '@playwright/test'

/**
 * 通过 UI 登录 - 模拟真实用户登录流程
 */
export async function login(page) {
  await page.goto('/login')
  await page.fill('input[placeholder="请输入用户名"]', 'admin')
  await page.fill('input[placeholder="请输入密码"]', 'admin123')
  await page.click('button:has-text("登 录")')
  await page.waitForURL('**/dashboard', { timeout: 15000 })
  await page.waitForLoadState('networkidle')
}

/**
 * 确保已登录 - 检查当前状态，未登录则执行登录
 */
export async function ensureLoggedIn(page) {
  const currentUrl = page.url()
  if (currentUrl.includes('/login')) {
    await login(page)
  }
}
