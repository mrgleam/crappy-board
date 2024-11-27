import { test, expect, Locator } from './my-test';

test.beforeEach(async ({ page, user02, user03, user04, boardId }, testInfo) => {
  if (testInfo.title.includes("#user02")) {
    await user02.page.goto(`/boards/${boardId.user02}`);
  } else if (testInfo.title.includes("#user03")) {
    await user03.page.goto(`/boards/${boardId.user03}`);
  } else if (testInfo.title.includes("#user04")) {
    await user04.page.goto(`/boards/${boardId.user04}`);
  } else {
    await page.goto(`/boards/${boardId.user01}`);
  }
});

test.afterEach(async ({ page, user02, user03, user04, boardId }, testInfo) => {
  let currentPage = page;
  if (testInfo.title.includes("#user02")) {
    currentPage = user02.page;
    await currentPage.goto(`/boards/${boardId.user02}`);
  } else if (testInfo.title.includes("#user03")) {
    currentPage = user03.page;
    await currentPage.goto(`/boards/${boardId.user03}`);
  } else if (testInfo.title.includes("#user04")) {
    currentPage = user04.page;
    await currentPage.goto(`/boards/${boardId.user04}`);
  } else {
    await page.goto(`/boards/${boardId.user01}`);
  }

  const todoItems = currentPage.getByTestId("todo-items").locator("ul > li");
  await deleteItems(todoItems, add1);

  const doingItems = currentPage.getByTestId("doing-items").locator("ul > li");
  await deleteItems(doingItems, identity);

  const doneItems = currentPage.getByTestId("done-items").locator("ul > li");
  await deleteItems(doneItems, identity);
});

const add1: (number) => number =  (a) => a + 1;

const identity: (number) => number =  (a) => a;

async function deleteItems(locator: Locator, fn: (number) => number) {
  const count = await locator.count();
  if (count > fn(0)) {
    for (let i = fn(0); i < count; i++) {
      await locator.nth(fn(0)).hover();
      await locator.nth(fn(0)).getByTestId("delete-todo").click();
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

  test("should not allow me to add todo items when the board is limited to the number of items [#user02]", async ({ user02 }) => {
    // create a new todo locator
    const newTodo = user02.page.getByPlaceholder("What needs to be done?");

    for (let i = 0; i < 20; i++) {
      await newTodo.fill(TODO_ITEMS[0]);
      await user02.page.getByTestId("create-todo").click();
    }

    const responseSubmit = user02.page.waitForResponse('**/items/create');
    // Create item todo.
    await newTodo.fill(TODO_ITEMS[0]);
    await user02.page.getByTestId("create-todo").click();

    const response = await responseSubmit;
    expect(response.status()).toBe(400);
  });
});

test.describe('Item', () => {
  test('should allow me to move item from TODO to DOING [#user03]', async ({ user03 }) => {
    // create a new todo locator
    const newTodo = user03.page.getByPlaceholder('What needs to be done?');

    // Create two items.
    for (const item of TODO_ITEMS.slice(0, 2)) {
      await newTodo.fill(item);
      await user03.page.getByTestId("create-todo").click();
    }

    const firstTodoItem = user03.page.getByTestId("todo-items").locator("ul > li").nth(1);
    await firstTodoItem.hover();
    await firstTodoItem.getByTestId("toggle-next").click();

    // Make sure the list now has doing items.
    await expect(user03.page.getByTestId("doing-items")).toContainText([TODO_ITEMS[0]]);
  })

  test('should allow me to move item from DOING to DONE [#user04]', async ({ user04 }) => {
    // create a new todo locator
    const newTodo = user04.page.getByPlaceholder('What needs to be done?');

    // Create two items.
    for (const item of TODO_ITEMS.slice(0, 2)) {
      await newTodo.fill(item);
      await user04.page.getByTestId("create-todo").click();
    }

    const firstTodoItem = user04.page.getByTestId("todo-items").locator("ul > li").nth(1);
    await firstTodoItem.hover();
    await firstTodoItem.getByTestId("toggle-next").click();

    // Make sure the list now has doing items.
    await expect(user04.page.getByTestId("doing-items")).toContainText([TODO_ITEMS[0]]);

    const firstDoingItem = user04.page.getByTestId("doing-items").locator("ul > li").nth(0);
    await firstDoingItem.hover();
    await firstDoingItem.getByTestId("toggle-next").click();

    // Make sure the list now has done items.
    await expect(user04.page.getByTestId("done-items")).toContainText([TODO_ITEMS[0]]);
  })
});
