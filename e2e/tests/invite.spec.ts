import { expect } from "@playwright/test";
import { test } from './my-test';

test.beforeEach(async ({ page, boardId }) => {
  await page.goto(`/boards/${boardId}`);
});

test.describe('Invite', () => {
  test('should allow me to add user', async ({ page, context }) => {
    await page.getByTestId("show-menu").click();

    const [newPage] = await Promise.all([
      context.waitForEvent('page'), // get `context` by destructuring with `page` in the test params; 'page' is a built-in event, and **you must wait for this like this,**, or `newPage` will just be the response object, rather than an actual Playwright page object.
      await page.getByTestId("invite").click() // note that, like all waiting in Playwright, this is somewhat unintuitive. This is the action which is *causing the navigation*; you have to set up the wait *before* it happens, hence the use of Promise.all().
    ]);
  
    await newPage.waitForLoadState(); // wait for the new tab to fully load
    // now, use `newPage` to access the newly opened tab, rather than `page`, which will still refer to the original page/tab.
    await expect(newPage).toHaveURL(/invite/);
   
    const email = await newPage.getByPlaceholder('Please enter email');

    email.fill('aaa02@aaa.com');

    const responseSubmit = newPage.waitForResponse('**/invite');

    await newPage.getByTestId("submit").click();

    const response = await responseSubmit;
    expect(response.status()).toBe(200);
    await expect(newPage.getByText('Invitation Successful!')).toBeVisible();
  });

  test('should not allow me to add user when the user is limited to the number of boards they can join', async ({ page, context }) => {
    await page.getByTestId("show-menu").click();

    const [newPage] = await Promise.all([
      context.waitForEvent('page'), // get `context` by destructuring with `page` in the test params; 'page' is a built-in event, and **you must wait for this like this,**, or `newPage` will just be the response object, rather than an actual Playwright page object.
      await page.getByTestId("invite").click() // note that, like all waiting in Playwright, this is somewhat unintuitive. This is the action which is *causing the navigation*; you have to set up the wait *before* it happens, hence the use of Promise.all().
    ]);
  
    await newPage.waitForLoadState(); // wait for the new tab to fully load
    // now, use `newPage` to access the newly opened tab, rather than `page`, which will still refer to the original page/tab.
    await expect(newPage).toHaveURL(/invite/);
   
    const email = await newPage.getByPlaceholder('Please enter email');

    email.fill('aaa11@aaa.com');

    const responseSubmit = newPage.waitForResponse('**/invite');

    await newPage.getByTestId("submit").click();

    const response = await responseSubmit;
    expect(response.status()).toBe(403);
  });
});
