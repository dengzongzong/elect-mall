import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('新闻管理测试', () => {
  test('应该显示新闻列表页面', async ({ page }) => {
    await page.goto('/news')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('.page-header h2')).toContainText('新闻', { timeout: 10000 })
  })

  test('应该能新增新闻', async ({ page }) => {
    await page.goto('/news')
    await page.waitForLoadState('networkidle')
    
    const addButton = page.locator('.el-button', { hasText: '新增新闻' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    
    await page.fill('.el-dialog input[placeholder="请输入新闻标题"]', '测试新闻_PW')
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能删除新闻', async ({ page }) => {
    await page.goto('/news')
    await page.waitForLoadState('networkidle')
    
    // 先创建新闻
    const addButton = page.locator('.el-button', { hasText: '新增新闻' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入新闻标题"]', '测试新闻_PW')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 删除新闻 - 使用 first() 选择第一个匹配的行
    const newsRow = page.locator('.el-table__body tr', { hasText: '测试新闻_PW' }).first()
    await newsRow.waitFor({ state: 'visible' })
    await newsRow.locator('button:has-text("删除")').click()
    
    await page.waitForSelector('.el-message-box', { state: 'visible', timeout: 10000 })
    // Element Plus 使用英文按钮 "OK"
    await page.click('.el-message-box button:has-text("OK")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })
})
