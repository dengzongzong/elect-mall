import { test, expect } from '@playwright/test'
import { login } from './auth-helper'

test.beforeEach(async ({ page }) => {
  await login(page)
})

test.describe('导航菜单测试', () => {
  test('应该能访问所有管理页面', async ({ page }) => {
    const pages = [
      { path: '/dashboard', title: '工作台' },
      { path: '/product', title: '商品管理' },
      { path: '/category', title: '分类管理' },
      { path: '/brand', title: '品牌管理' },
      { path: '/order', title: '订单管理' },
      { path: '/user', title: '用户管理' },
      { path: '/finance', title: '财务管理' },
      { path: '/setting', title: '系统设置' },
    ]

    for (const p of pages) {
      await page.goto(p.path)
      await page.waitForLoadState('networkidle')
      await expect(page.locator('.page-header h2')).toContainText(p.title, { timeout: 10000 })
    }
  })

  test('侧边菜单应该显示所有菜单项', async ({ page }) => {
    await page.goto('/dashboard')
    await page.waitForLoadState('networkidle')
    
    const menuItems = [
      '工作台',
      '商品管理',
      '分类管理',
      '品牌管理',
      '订单管理',
      '用户管理',
      '财务管理',
      '系统设置',
    ]
    
    for (const item of menuItems) {
      await expect(page.locator('.el-menu-item').filter({ hasText: item }).first()).toBeVisible()
    }
  })
})
