import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('分类管理测试', () => {
  test('应该显示分类列表页面', async ({ page }) => {
    await page.goto('/category')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('.page-title h2')).toContainText('分类管理')
  })

  test('应该能新增分类', async ({ page }) => {
    await page.goto('/category')
    await page.waitForLoadState('networkidle')
    
    const addButton = page.locator('.el-button--danger', { hasText: '新增分类' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await expect(page.locator('.el-dialog__title')).toContainText('新增分类')
    
    await page.fill('.el-dialog input[placeholder="请输入分类名称"]', '测试分类_PW')
    await page.fill('.el-dialog input[placeholder="请输入分类编码"]', 'TEST_CAT')
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能编辑分类', async ({ page }) => {
    await page.goto('/category')
    await page.waitForLoadState('networkidle')
    
    // 先创建分类
    const addButton = page.locator('.el-button--danger', { hasText: '新增分类' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入分类名称"]', '测试分类_PW')
    await page.fill('.el-dialog input[placeholder="请输入分类编码"]', 'TEST_CAT')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待旧的成功消息消失
    await page.locator('.el-message--success').first().waitFor({ state: 'hidden', timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 编辑分类 - 使用 first() 选择第一个匹配的行
    const categoryRow = page.locator('.el-table__body tr', { hasText: '测试分类_PW' }).first()
    await categoryRow.waitFor({ state: 'visible' })
    await categoryRow.locator('button:has-text("编辑")').click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    
    await page.fill('.el-dialog input[placeholder="请输入分类名称"]', '测试分类_PW_编辑')
    
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })

  test('应该能删除分类', async ({ page }) => {
    await page.goto('/category')
    await page.waitForLoadState('networkidle')
    
    // 先创建分类
    const addButton = page.locator('.el-button--danger', { hasText: '新增分类' })
    await addButton.waitFor({ state: 'visible' })
    await addButton.click()
    
    await page.waitForSelector('.el-dialog', { state: 'visible', timeout: 10000 })
    await page.fill('.el-dialog input[placeholder="请输入分类名称"]', '测试分类_PW')
    await page.fill('.el-dialog input[placeholder="请输入分类编码"]', 'TEST_CAT')
    await page.click('.el-dialog .el-button--primary:has-text("保存")')
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
    
    // 等待旧的成功消息消失
    await page.locator('.el-message--success').first().waitFor({ state: 'hidden', timeout: 10000 })
    
    // 等待表格加载
    await page.waitForSelector('.el-table__body tr', { timeout: 15000 })
    
    // 删除分类 - 使用 first() 选择第一个匹配的行
    const categoryRow = page.locator('.el-table__body tr', { hasText: '测试分类_PW' }).first()
    await categoryRow.waitFor({ state: 'visible' })
    await categoryRow.locator('button:has-text("删除")').click()
    
    await page.waitForSelector('.el-message-box', { state: 'visible', timeout: 10000 })
    await page.click('.el-message-box .el-button--primary:has-text("确定")')
    
    await expect(page.locator('.el-message--success')).toBeVisible({ timeout: 10000 })
  })
})
