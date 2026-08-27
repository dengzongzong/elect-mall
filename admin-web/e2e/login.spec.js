import { test, expect } from '@playwright/test'

test.describe('登录功能测试', () => {
  test('应该显示登录页面', async ({ page }) => {
    await page.goto('/login')
    await expect(page.locator('.login-title')).toContainText('电子元器件商城管理后台')
    await expect(page.locator('.login-subtitle')).toContainText('请登录您的账号')
  })

  test('应该成功登录', async ({ page }) => {
    await page.goto('/login')
    
    // 填写登录表单
    await page.fill('input[placeholder="请输入用户名"]', 'admin')
    await page.fill('input[placeholder="请输入密码"]', 'admin123')
    
    // 点击登录按钮
    await page.click('button:has-text("登 录")')
    
    // 等待跳转到仪表盘
    await page.waitForURL('**/dashboard', { timeout: 15000 })
    
    // 验证登录成功 - 使用正确的选择器
    await expect(page.locator('.page-header h2')).toContainText('工作台', { timeout: 10000 })
  })

  test('登录失败应该显示错误', async ({ page }) => {
    await page.goto('/login')
    
    await page.fill('input[placeholder="请输入用户名"]', 'admin')
    await page.fill('input[placeholder="请输入密码"]', 'wrongpassword')
    
    await page.click('button:has-text("登 录")')
    
    // 应该显示错误消息
    await expect(page.locator('.el-message--error')).toBeVisible({ timeout: 10000 })
  })
})
