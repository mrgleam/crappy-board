import { test as base } from '@playwright/test';

export type TestOptions = {
  boardId: string;
};

export const test = base.extend<TestOptions>({
  // Define an option and provide a default value.
  // We can later override it in the config.
  boardId: ['1cde4b2c-5f94-4feb-9b11-cb23dc07419e', { option: true }],
});