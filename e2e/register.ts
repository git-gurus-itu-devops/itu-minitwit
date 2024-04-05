import { test, expect } from "@playwright/test";

test.beforeEach(async ({ page }) => {
  await page.goto("/register");
});

test("should succesfully register a new user", async ({ page }) => {
  await page.fill("input[name=username]", "newuser");
  await page.fill("input[name=email]", "new@user.dk");
  await page.fill("input[name=password]", "1234");
  await page.fill("input[name=password2]", "1234");
  await page.click("input[type=submit]");
  await expect(page).toHaveURL(/.login/);
});

test("Should fail if username and email is taken", async ({ page }) => {
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=email]", "test@user.dk");
  await page.fill("input[name=password]", "1234");
  await page.fill("input[name=password2]", "1234");
  await page.click("input[type=submit]");
  await expect(
    page.getByText(
      "Username has already been taken, Email has already been taken"
    )
  ).toBeVisible();
});

test("Should fail if email is taken", async ({ page }) => {
  await page.fill("input[name=username]", "testuser2");
  await page.fill("input[name=email]", "test@user.dk");
  await page.fill("input[name=password]", "1234");
  await page.fill("input[name=password2]", "1234");
  await page.click("input[type=submit]");
  await expect(page.getByText("Email has already been taken")).toBeVisible();
});

test("Should fail if username is taken", async ({ page }) => {
  await page.fill("input[name=username]", "testuser");
  await page.fill("input[name=email]", "test@user.dk2");
  await page.fill("input[name=password]", "1234");
  await page.fill("input[name=password2]", "1234");
  await page.click("input[type=submit]");
  await expect(page.getByText("Username has already been taken")).toBeVisible();
});

test("Should fail is passwords do not match", async ({ page }) => {
  await page.fill("input[name=username]", "testuser2");
  await page.fill("input[name=email]", "test@user.dk2");
  await page.fill("input[name=password]", "1234");
  await page.fill("input[name=password", "12345");
  await page.click("input[type=submit]");
  await expect(
    page.getByText("Password confirmation doesn't match Password")
  ).toBeVisible();
});
