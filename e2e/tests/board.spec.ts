import { expect, Locator } from "@playwright/test";
import { test } from './my-test';

test.describe.configure({ mode: 'serial' });

test.beforeEach(async ({ page, boardId }) => {
  await page.goto(`/boards/${boardId}`);
});

test.afterEach(async ({ page }) => {
  const todoItems = page.getByTestId("todo-items").locator("ul > li");
  await deleteItems(todoItems);

  const doingItems = page.getByTestId("doing-items").locator("ul > li");
  await deleteItems(doingItems);

  const doneItems = page.getByTestId("done-items").locator("ul > li");
  await deleteItems(doneItems);
});

async function deleteItems(locator: Locator) {
  const count = await locator.count();
  if (count > 1) {
    for (let i = 1; i < count; i++) {
      await locator.nth(1).hover();
      await locator.nth(1).getByTestId("delete-todo").click();
    }
  }
}

const TODO_ITEMS = [
  "buy some cheese",
  "feed the cat",
  "book a doctors appointment",
];

test.describe("New Todo", () => {
  test("should have todo input with placeholder `What needs to be done?`", async ({
    page,
  }) => {
    await expect(page.getByPlaceholder("What needs to be done?")).toBeVisible();
  });

  test("should allow me to add todo items", async ({ page }) => {
    // create a new todo locator
    const newTodo = page.getByPlaceholder("What needs to be done?");

    // Create 1st todo.
    await newTodo.fill(TODO_ITEMS[0]);
    await page.getByTestId("create-todo").click();

    // Make sure the list only has one todo item.
    await expect(page.getByTestId("todo-items")).toContainText([TODO_ITEMS[0]]);

    // Create 2nd todo.
    await newTodo.fill(TODO_ITEMS[1]);
    await page.getByTestId("create-todo").click();

    // Make sure the list now has two todo items.
    await expect(page.getByTestId("todo-items")).toContainText([TODO_ITEMS[1]]);
  });

  test('should clear todo input field when an item is added', async ({ page }) => {
    // create a new todo locator
    const newTodo = page.getByPlaceholder('What needs to be done?');

    // Create one todo item.
    await newTodo.fill(TODO_ITEMS[0]);
    await page.getByTestId("create-todo").click();

    // Check that input is empty.
    await expect(newTodo).toBeEmpty();
  });
});

test.describe('Item', () => {
  test('should allow me to move item from TODO to DOING', async ({ page }) => {
    // create a new todo locator
    const newTodo = page.getByPlaceholder('What needs to be done?');

    // Create two items.
    for (const item of TODO_ITEMS.slice(0, 2)) {
      await newTodo.fill(item);
      await page.getByTestId("create-todo").click();
    }

    const firstTodoItem = page.getByTestId("todo-items").locator("ul > li").nth(1);
    await firstTodoItem.hover();
    await firstTodoItem.getByTestId("toggle-next").click();

    // Make sure the list now has doing items.
    await expect(page.getByTestId("doing-items")).toContainText([TODO_ITEMS[0]]);
  })

  test('should allow me to move item from DOING to DONE', async ({ page }) => {
    // create a new todo locator
    const newTodo = page.getByPlaceholder('What needs to be done?');

    // Create two items.
    for (const item of TODO_ITEMS.slice(0, 2)) {
      await newTodo.fill(item);
      await page.getByTestId("create-todo").click();
    }

    const firstTodoItem = page.getByTestId("todo-items").locator("ul > li").nth(1);
    await firstTodoItem.hover();
    await firstTodoItem.getByTestId("toggle-next").click();

    // Make sure the list now has doing items.
    await expect(page.getByTestId("doing-items")).toContainText([TODO_ITEMS[0]]);

    const firstDoingItem = page.getByTestId("doing-items").locator("ul > li").nth(0);
    await firstDoingItem.hover();
    await firstDoingItem.getByTestId("toggle-next").click();

    // Make sure the list now has done items.
    await expect(page.getByTestId("done-items")).toContainText([TODO_ITEMS[0]]);
  })
});

test.describe('Validate', () => {
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
