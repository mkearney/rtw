context("stream_tweets")

test_that("stream_tweets returns tweets data", {
  skip_on_cran()

  x <- suppressMessages(
    stream_tweets(paste(letters, collapse = ","),
                  timeout = 4, verbose = TRUE))

  expect_true(is.data.frame(x))
  expect_named(x)
  expect_true("status_id" %in% names(x))
  expect_gt(nrow(x), 0)
  expect_gt(ncol(x), 15)
})

