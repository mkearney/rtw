context("get_followers")

test_that("get_followers returns data frame with user_id", {
  skip_on_cran()

  rl <- rate_limit("get_followers")
  if (rl$remaining > 1) {
    f <- get_followers("TwitterSupport", n = 10000)
  
    expect_true(is.data.frame(f))
    expect_true(identical(length(next_cursor(f)), 1L))
    expect_named(f, "user_id")
    expect_gt(NROW(f), 9999)
  } else {
    expect_true(rl$limit == 15)
    expect_true(rl$remaining == 0)
    expect_true(rl$limit == 15)
    expect_true(rl$limit == 15)
  }
})

