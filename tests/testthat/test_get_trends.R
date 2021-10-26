context("get_trends")


test_that("get_trends returns trends data", {
  skip_on_cran()

  x <- get_trends()

  expect_true(is.data.frame(x))
  expect_named(x)
  expect_true(all(c("trend", "promoted_content") %in% names(x)))
  expect_gt(nrow(x), 10)
  expect_gt(ncol(x), 5)
})

