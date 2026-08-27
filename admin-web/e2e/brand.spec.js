import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('品牌管理测试', () => {
  test('应该显示品牌列表页面', async ({ page }) => {
    await page.goto('/brand')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('.page-title h2')).toContainText('品牌管理')
  })

  test('应该能新增品牌', async ({ page }) => {
    await page.goto('/brand')
    await page.waitForLoadState('networkidle')
    
    const addButton = page.locator('.el-button--danger', { hasText: '新增品牌' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await expect(page.locator('.el-dialog__title')).toContainText('新增品牌')
    
    await page.fill('.el-dialog input[placeholder="请输入品牌名称"]', '测试品牌_PW')
    await page.fill('.el-dialog input[placeholder="请输入Logo URL"]', 'https://test-brand.com/logo.png')
    await page.fill('.el-dialog textarea[placeholder="请输入品牌描述"]', '测试品牌描述')
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能编辑品牌', async ({ page }) => {
    await page.goto('/brand')
    await page.waitForLoadState('networkidle')
    
    // 先创建品牌
    const addButton = page.locator('.el-button--danger', { hasText: '新增品牌' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入品牌名称"]', '测试品牌_PW')
    await page.fill('.el-dialog input[placeholder="请输入Logo URL"]', 'https://test-brand.com/logo.png')
    await page.fill('.el-dialog textarea[placeholder="请输入品牌描述"]', '测试品牌描述')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 编辑品牌 - 使用 first() 选择第一个匹配的行
    const brandRow = page.locator('.el-table__body tr', { hasText: '测试品牌_PW' }).first()
    await brandRow.waitFor({ state: 'visible' })
    await brandRow.locator('button:has-text("编辑")').click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    
    await page.fill('.el-dialog input[placeholder="请输入品牌名称"]', '测试品牌_PW_编辑')
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能删除品牌', async ({ page }) => {
    await page.goto('/brand')
    await page.waitForLoadState('networkidle')
    
    // 先创建品牌
    const addButton = page.locator('.el-button--danger', { hasText: '新增品牌' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入品牌名称"]', '测试品牌_PW')
    await page.fill('.el-dialog input[placeholder="请输入Logo URL"]', 'https://test-brand.com/logo.png')
    await page.fill('.el-dialog textarea[placeholder="请输入品牌描述"]', '测试品牌描述')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 删除品牌 - 使用 first() 选择第一个匹配的行
    const brandRow = page.locator('.el-table__body tr', { hasText: '测试品牌_PW' }).first()
    await brandRow.waitFor({ state: 'visible' })
    await brandRow.locator('button:has-text("删除")').click()
    
    await page.waitForSelector('.el-message-box', { state: 'visible', timeout: 10000 })
    await page.click('.el-message-box .el-button--primary:has-text("确定")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })
})
