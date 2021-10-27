


#' Bearer token
#'
#' Convert default token into bearer token for application only (user-free)
#' authentication method
#'
#' @param token Oauth token
#' @return A bearer token
#'
#' @examples
#' \dontrun{
#' ## use bearer token to search for >18k tweets (up to 45k) w/o hitting rate limit
#' verified_user_tweets <- search_tweets("filter:verified", n = 30000, token = bearer_token())
#'
#' ## get followers (user == app)
#' ### - USER (normal) token – rate limit 15req/15min
#' cnn_flw <- get_followers("cnn", n = 75000)
#' ### - APP (bearer) token – rate limit 15req/15min
#' cnn_flw <- get_followers("cnn", n = 75000, token = bearer_token())
#'
#' ## get timelines (user < app)
#' ### - USER (normal) token – rate limit 900req/15min
#' cnn_flw_data <- get_timelines(cnn_flw$user_id[1:900])
#' ### - APP (bearer) token – rate limit 1500req/15min
#' cnn_flw_data <- get_timelines(cnn_flw$user_id[1:1500], token = bearer_token())
#'
#' ## lookup statuses (user > app)
#' ### - USER (normal) token – rate limit 900req/15min
#' cnn_flw_data2 <- lookup_tweets(cnn_flw_data$status_id[1:90000])
#' ### - APP (bearer) token – rate limit 300req/15min
#' cnn_flw_data2 <- lookup_tweets(cnn_flw_data$status_id[1:30000], token = bearer_token())
#'
#' }
#' @export
bearer_token <- function(token = NULL) {
  bearer <- get_bearer(token)
  if (is.null(bearer)) {
    stop("couldn't find bearer token")
  }
  r <- request(headers = c(Authorization = paste0("Bearer ", bearer$access_token)) )
  structure(r, bearer = bearer, class = c("bearer", "list"))
}


get_bearer <- function(token = NULL) {
  ## retrieve
  bearer_env <- get(".bearer_env", envir = .state)
  bearer <- tryCatch(get("bearer", envir = bearer_env), error = function(e) NULL)
  if (is.null(bearer)) {
    stop("couldn't find bearer token")
  }
  bearer
}

get_app_key <- function(token) {
  token$app$key
}

get_app_secret <- function(token) {
  token$app$secret
}

get_oauth_key <- function(token) {
  token$credentials$oauth_token
}

get_oauth_secret <- function(token) {
  token$credentials$oauth_token_secret
}

print.bearer <- function(bearer) {
  cat(paste0("Bearer token: ", attr(bearer, "bearer")$access_token), fill = TRUE)
}

