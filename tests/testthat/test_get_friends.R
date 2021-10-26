context("get_friends")

test_that("get_friends returns data frame with ids", {
    skip_on_cran()

    rl <- rate_limit("get_followers")
    if (rl$remaining > 1) {
        f <- get_friends("TwitterSupport")
    
        expect_true(is.data.frame(f))
        expect_gt(nrow(f), 1)
    } else {
        expect_true(rl$limit == 15)
        expect_true(rl$remaining == 0)
        expect_true(rl$limit == 15)
        expect_true(rl$limit == 15)
    }
})

