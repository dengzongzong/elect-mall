import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('订单管理测试', () => {
  test('应该显示订单列表页面', async ({ page }) => {
    await page.goto('/order')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('.page-title h2')).toContainText('订单管理')
  })

  test('应该能查看订单列表', async ({ page }) => {
    await page.goto('/order')
    await page.waitForLoadState('networkidle')
    
    // 验证表格存在
    await expect(page.locator('.el-table')).toBeVisible({ timeout: 10000 })
  })
})
