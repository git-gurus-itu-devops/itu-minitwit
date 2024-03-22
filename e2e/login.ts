import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.goto("/login");
});

test("should succesfully fail with invalid username", async ({ page }) => {
  await page.fill("input[name=username]", "notauser");
  await page.fill("input[name=password]", "notapassword");
  await page.click("input[type=submit]");
  await expect(
    page.getByText(
      "Invalid username"
    )
  ).toBeVisible();
});

test("should succesfully fail with invalid password", async ({ page }) => {
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=password]", "notapassword");
  await page.click("input[type=submit]");
  await expect(
    page.getByText(
    "Invalid password"
    )
  ).toBeVisible();
});


test("should succesfully login", async ({ page }) => {
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=password]", "1234");
  await page.click("input[type=submit]");
  await expect(
    page.getByText(
    "You were logged in"
    )
  ).toBeVisible();
});

test("should succesfully logout", async ({ page }) => {
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=password]", "1234");
  await page.click("input[type=submit]");
  await page.getByText(
    "sign out testuser"
    ).click();
  await expect(page).toHaveURL(/.*logout/);
  await expect(
    page.getByText(
    "You were logged out"
    )
  ).toBeVisible();
});