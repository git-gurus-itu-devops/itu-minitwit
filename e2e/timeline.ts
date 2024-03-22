import { test, expect, Page } from "@playwright/test";

test("Public timeline shows all messages", async ({ page }) => {
  await page.goto("/public");
  expect(page.getByText("This is a message written by user 2")).toBeVisible();
  expect(page.getByText("This is a message written by user 3")).toBeVisible();
});

test("My timeline only shows messages from followed users", async ({
  page,
}) => {
  await page.goto("/login");
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=password]", "1234");
  await page.click("input[type=submit]");
  expect(page.getByText("This is a message written by user 2")).toBeVisible();
  expect(page.getByText("This is a message written by user 3")).toBeHidden();
});
