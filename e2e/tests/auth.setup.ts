import { expect } from '@playwright/test';
import { test as setup } from './my-test';

const authFile = 'playwright/.auth/user.json';

setup('authenticate', async ({ page, boardId }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('/signin');
  await page.getByLabel('Email address').fill('aaa@aaa.com');
  await page.getByLabel('Password').fill('aaaaaaaa');
  await page.getByRole('button', { name: 'Sign in' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL(`/boards/${boardId}`);
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile });
});