import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: 0,
  workers: 1,
  reporter: [['list'], ['html', { outputFolder: 'playwright-report', open: 'never' }]],
  use: {
    baseURL: 'http://localhost:8081',
    headless: true,
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',
    video: 'retain-on-failure',
    launchOptions: {
      executablePath: 'C:\\Users\\MateBook D\\AppData\\Local\\ms-playwright\\chromium-1234\\chrome-win64\\chrome.exe',
    },
  },
  timeout: 30000,
  expect: {
    timeout: 10000
  },
  projects: [
    {
      name: 'chromium',
      use: { 
        browserName: 'chromium',
        launchOptions: {
          executablePath: 'C:\\Users\\MateBook D\\AppData\\Local\\ms-playwright\\chromium-1234\\chrome-win64\\chrome.exe',
        },
      },
    },
  ],
})
