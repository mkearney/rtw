context("search_users")

test_that("search_users returns users data", {
  skip_on_cran()

  n <- 3
  x <- search_users("twitter", n = n, verbose = FALSE)

  expect_equal(is.data.frame(x), TRUE)
  expect_named(x)
  expect_true("user_id" %in% names(x))
  expect_gt(nrow(x), 2)
  expect_gt(ncol(x), 15)
  expect_true(all(c("text", "retweet_count") %in% names(x)))
})

