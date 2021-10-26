## TEST LISTS FUNCTIONS

context("lists")

test_that("lists_users returns data frame with nrow > 1", {
    skip_on_cran()

    sns <- "Twitter"
    x <- lists_users(sns)
    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
    x <- lists_members(slug = "senators", owner_user = "cspan")
    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
    x <- lists_memberships("Twitter", n = 200)
    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
})

test_that("lists_memberships returns data frame with nrow > 1", {
    skip_on_cran()

    sns <- "Twitter"
    
    x <- lists_memberships(sns)

    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
    expect_true(is.character(previous_cursor(x)))
    expect_true(is.character(next_cursor(x)))
    expect_true(is.null(max_id(x)))
    expect_true(is.null(since_id(x)))

    x <- lists_memberships(sns, parse = FALSE)
    expect_true(is.data.frame(as.data.frame(x)))
    expect_true(is.character(previous_cursor(x)))
    expect_true(is.character(next_cursor(x)))
    expect_true(is.null(max_id(x)))
    expect_true(is.null(since_id(x)))
})


test_that("lists_members returns data frame with nrow > 1", {
    skip_on_cran()

    lst_id <- "99924643"
    
    x <- lists_members(lst_id)

    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
})

test_that("lists_statuses returns data frame with nrow > 1", {
    skip_on_cran()

    lst_id <- "99924643"
    
    x <- lists_statuses(lst_id)

    expect_true(is.data.frame(x))
    expect_gt(nrow(x), 0)
})


test_that("lists_subscribers returns users data frame", {
  skip_on_cran()
  

  x <- lists_subscribers(
    slug = "new-york-times-politics",
    owner_user = "nytpolitics",
    n = 200
  )

  expect_true(is.data.frame(x))
  expect_true("description" %in% names(x))
  expect_gt(nrow(x), 50)
})
