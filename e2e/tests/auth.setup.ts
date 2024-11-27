import { expect } from '@playwright/test';
import { test as setup } from './my-test';
import { authFile01, authFile02, authFile03, authFile04 } from '../utils/auth';

setup('authen user01', async ({ page, boardId }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('/signin');
  await page.getByLabel('Email address').fill('aaa01@aaa.com');
  await page.getByLabel('Password').fill('aaaaaaaa');
  await page.getByRole('button', { name: 'Sign in' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL(`/boards/${boardId.user01}`);
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile01 });
});

setup('authen user02', async ({ page, boardId }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('/signin');
  await page.getByLabel('Email address').fill('aaa02@aaa.com');
  await page.getByLabel('Password').fill('aaaaaaaa');
  await page.getByRole('button', { name: 'Sign in' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL(`/boards/${boardId.user02}`);
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile02 });
});

setup('authen user03', async ({ page, boardId }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('/signin');
  await page.getByLabel('Email address').fill('aaa03@aaa.com');
  await page.getByLabel('Password').fill('aaaaaaaa');
  await page.getByRole('button', { name: 'Sign in' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL(`/boards/${boardId.user03}`);
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile03 });
});

setup('authen user04', async ({ page, boardId }) => {
  // Perform authentication steps. Replace these actions with your own.
  await page.goto('/signin');
  await page.getByLabel('Email address').fill('aaa04@aaa.com');
  await page.getByLabel('Password').fill('aaaaaaaa');
  await page.getByRole('button', { name: 'Sign in' }).click();
  // Wait until the page receives the cookies.
  //
  // Sometimes login flow sets cookies in the process of several redirects.
  // Wait for the final URL to ensure that the cookies are actually set.
  await page.waitForURL(`/boards/${boardId.user04}`);
  // Alternatively, you can wait until the page reaches a state where all cookies are set.
  await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();

  // End of authentication steps.

  await page.context().storageState({ path: authFile04 });
});
