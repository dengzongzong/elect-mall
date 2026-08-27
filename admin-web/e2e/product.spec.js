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
    
    await page.fill('.el-dialog input[placeholder="请输入商品名称"]', '测试商品_PW')
    
    // 直接点击保存，不选择分类（分类非必填）
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能删除商品', async ({ page }) => {
    await page.goto('/product')
    await page.waitForLoadState('networkidle')
    
    // 先创建商品
    const addButton = page.locator('.el-button', { hasText: '新增商品' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入商品名称"]', '测试商品_PW')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 删除商品 - 使用 first() 选择第一个匹配的行
    const prodRow = page.locator('.el-table__body tr', { hasText: '测试商品_PW' }).first()
    await prodRow.waitFor({ state: 'visible' })
    await prodRow.locator('button:has-text("删除")').click()
    
    await page.waitForSelector('.el-message-box', { state: 'visible', timeout: 10000 })
    await page.click('.el-message-box .el-button--primary:has-text("确定")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })
})
