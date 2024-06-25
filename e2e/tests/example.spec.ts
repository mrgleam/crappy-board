import { test, expect, Locator } from "@playwright/test";

test.describe.configure({ mode: 'serial' });

test.beforeEach(async ({ page }) => {
  await page.goto("/");
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
