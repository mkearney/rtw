context("lookup_users")

test_that("lookup_users returns users data", {
  skip_on_cran()

  n <- 2
  x <- lookup_users(c("Twitter", "TwitterSupport"))

  expect_equal(is.data.frame(x), TRUE)
  expect_named(x)
  expect_true("user_id" %in% names(x))
  expect_equal(nrow(x), n)
  expect_gt(ncol(x), 15)
  expect_true(all(c("text", "retweet_count") %in% names(x)))
})

