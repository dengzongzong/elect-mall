import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('商品管理测试', () => {
  test('应该显示商品列表页面', async ({ page }) => {
    await page.goto('/product')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('.page-title h2')).toContainText('商品管理')
  })

  test('应该能新增商品', async ({ page }) => {
    await page.goto('/product')
    await page.waitForLoadState('networkidle')
    
    const addButton = page.locator('.el-button', { hasText: '新增商品' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    
    const ts = Date.now()
    await page.fill('.el-dialog input[placeholder="请输入商品名称"]', `测试商品_${ts}`)
    await page.fill('.el-dialog input[placeholder="请输入料号"]', `PW-TEST-${ts}`)
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能删除商品', async ({ page }) => {
    await page.goto('/product')
    await page.waitForLoadState('networkidle')
    
    const ts = Date.now()
    
    // 先创建商品
    const addButton = page.locator('.el-button', { hasText: '新增商品' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入商品名称"]', `测试商品_${ts}`)
    await page.fill('.el-dialog input[placeholder="请输入料号"]', `PW-TEST-${ts}`)
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 删除商品 - 使用 first() 选择第一个匹配的行
    const prodRow = page.locator('.el-table__body tr', { hasText: `测试商品_${ts}` }).first()
    await prodRow.waitFor({ state: 'visible' })
    await prodRow.locator('button:has-text("删除")').click()
    
    await page.waitForSelector('.el-message-box', { state: 'visible', timeout: 10000 })
    await page.waitForTimeout(500)
    await page.locator('.el-message-box .el-button--primary').click({ timeout: 5000 })

    await expect(page.locator('.el-message--success').first()).toBeVisible({ timeout: 10000 })
  })
})
