import { test as base, type Page } from '@playwright/test';
import { authFile01, authFile02, authFile03, authFile04 } from '../utils/auth';

// Page Object Model for the "admin" page.
// Here you can add locators and helper methods specific to the admin page.
class UserPage {
  // Page signed in as "admin".
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }
}

export type TestOptions = {
  user01: UserPage;
  user02: UserPage;
  user03: UserPage;
  user04: UserPage;
  boardId: {
    user01: string;
    user02: string;
    user03: string;
    user04: string;
  };
};

export * from '@playwright/test';

export const test = base.extend<TestOptions>({
  // Define an option and provide a default value.
  // We can later override it in the config.

  user01: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: authFile01 });
    const userPage = new UserPage(await context.newPage());
    await use(userPage);
    await context.close();
  },

  user02: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: authFile02 });
    const userPage = new UserPage(await context.newPage());
    await use(userPage);
    await context.close();
  },

  user03: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: authFile03 });
    const userPage = new UserPage(await context.newPage());
    await use(userPage);
    await context.close();
  },

  user04: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: authFile04 });
    const userPage = new UserPage(await context.newPage());
    await use(userPage);
    await context.close();
  },

  boardId: [
    {
      user01:'1cde4b2c-5f94-4feb-9b11-cb23dc07419e',
      user02:'1cde4b2c-5f94-4feb-9b11-cb23dc07419f',
      user03:'1cde4b2c-5f94-4feb-9b11-cb23dc074110',
      user04:'1cde4b2c-5f94-4feb-9b11-cb23dc074111',
    },
    { option: true }
  ],
});
