context("get_timeline")

test_that("get_timeline", {
  skip_on_cran()

  n <- 400
  x <- get_timeline(c("TwitterSupport", "Twitter"), n = n)
  expect_true(is.data.frame(x))
  expect_named(x)
  expect_true("status_id" %in% names(x))
  expect_gt(nrow(x), 100)
  expect_gt(ncol(x), 25)
  xts <- ts_data(x, by = "hours")
  expect_true(is.data.frame(xts))
})

