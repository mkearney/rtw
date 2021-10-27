
`%||%` <- function(a, b) {
  if (length(a) > 0) a else b
}


keep_last <- function (...) {
  x <- c(...)
  x[!duplicated(names(x), fromLast = TRUE)]
}

is_empty <- function (x) length(x) == 0

compact <- function (x) {
  empty <- vapply(x, is_empty, logical(1))
  x[!empty]
}

request <- function (method = NULL, url = NULL, headers = NULL, fields = NULL,
  options = NULL, auth_token = NULL, output = NULL) {
  if (!is.null(method))
    stopifnot(is.character(method), length(method) == 1)
  if (!is.null(url))
    stopifnot(is.character(url), length(url) == 1)
  if (!is.null(headers))
    stopifnot(is.character(headers))
  if (!is.null(fields))
    stopifnot(is.list(fields))
  if (!is.null(output))
    stopifnot(inherits(output, "write_function"))
  structure(list(method = method, url = url, headers = keep_last(headers),
    fields = fields, options = compact(keep_last(options)),
    auth_token = auth_token, output = output), class = "request")
}

#' Fetching Twitter authorization token(s).
#'
#' Call function used to fetch and load Twitter OAuth tokens.
#' Since Twitter application key should be stored privately, users should save
#' the path to token(s) as an environment variable. This allows Tokens
#' to be instantly [re]loaded in future sessions. See the "tokens"
#' vignette for instructions on obtaining and using access tokens.
#'
#' @return Twitter OAuth token(s) (Token1.0).
#' @details This function will search for tokens using R, internal,
#'   and global environment variables (in that order).
#' @examples
#'
#' \dontrun{
#' ## fetch default token(s)
#' token <- get_tokens()
#'
#' ## print token
#' token
#'
#' }
#'
#' @family tokens
#' @export
get_tokens <- function() {
  get_token()
}

#' @export
#' @rdname get_tokens
get_token <- function() {
  access_secret <- Sys.getenv("TWITTER_ACCESS_SECRET")
  access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN")
  consumer_key <- Sys.getenv("TWITTER_CONSUMER_KEY")
  consumer_secret <- Sys.getenv("TWITTER_CONSUMER_SECRET")
  app = list(
    secret = consumer_secret,
    key = consumer_key,
    appname = "rstatslite"
  )
  credentials = list(
    list(oauth_token = access_token, oauth_token_secret = access_secret)
  )
  endpoint = list(
    request = "https://api.twitter.com/oauth/request_token",
    authorize = "https://api.twitter.com/oauth/authenticate",
    access = "https://api.twitter.com/oauth/access_token"
  )
  sign = function(method, url) {
    oauth <- oauth_sign(url, method,
      app, token_secret = access_secret, token_key = access_token)
    c(structure(list(url = url), class = "request"), oauth_header(oauth))
  }
  refresh <- function() stop("not implemented")
  can_refresh <- function() FALSE
  clone <- function() structure(token, class = c("rtweet_token", "Token"))
  token <- list(app = app, credentials = credentials, endpoint = endpoint, 
    sign = sign, 
    clone = clone, refresh = refresh, can_refresh = can_refresh)
  structure(token, class = c("rtweet_token", "Token"))
}

has_ext <- function(x) {
  stopifnot(length(x) == 1L)
  x <- basename(x)
  grepl("[[:alnum:]]{1,}\\.[[:alpha:]]{1,}$", x)
}

only_ext <- function(x) {
  if (has_ext(x)) {
    gsub(".*(?=\\.)", "", x, perl = TRUE)
  } else {
    ""
  }
}

no_ext <- function(x) {
  if (has_ext(x)) {
    gsub("(?<=[[:alnum:]]{1})\\..*(?!=\\.)", "", x, perl = TRUE)
  } else {
    x
  }
}

paste_before_ext <- function(x, p) {
  paste0(no_ext(x), p, only_ext(x))
}


uq_filename <- function(file_name) {
  stopifnot(is.character(file_name) && length(file_name) == 1L)
  if (file.exists(file_name)) {
    files <- list.files(dirname(file_name), all.files = TRUE, full.names = TRUE)
    file_name <- paste_before_ext(file_name, 1:1000)
    file_name <- file_name[!file_name %in% files][1]
  }
  file_name
}


is.token <- function(x) {
  if (length(x) == 0) return(FALSE)
  if (inherits(x, "bearer")) return(TRUE)
  ## if it doesn't have request endpoint return FALSE
  if (!"endpoint" %in% names(x) || !"request" %in% names(x$endpoint)) {
    return(FALSE)
  }
  ## check if inherits token class and uses a twitter api endpoint
  any(c("token", "token1.0") %in% tolower(class(x))) &&
    (any(grepl("api.twitter", x[['endpoint']][['request']], ignore.case = TRUE)) ||
        (is.null(x[['endpoint']][['request']]) &&
            !is.null(x[['credentials']][['oauth_token']])))
}

rate_limit_used <- function(x) {
  x$used <- x$limit - x$remaining
  x <- x[, c("query", "limit", "remaining", "used", "reset", "reset_at")]
  x[order(x$used, decreasing = TRUE), ]
}


check_token <- function(token) {
  if (is.null(token)) {
    token <- get_tokens()
  } else if (inherits(token, "bearer")) {
    return(token)
  }
  ## if valid token, then return
  if (is.token(token)) {
    return(token)
  }
  ## if list then extract first
  if (is.list(token)) {
    token <- token[[1]]
  }
  ## final check
  if (!is.token(token)) {
    stop("Not a valid access token.", call. = FALSE)
  }
  token
}

is_ttoken <- function(x) {
  if (is.token(x)) return(TRUE)
  if (is.list(x) && is.token(x[[1]])) return(TRUE)
  FALSE
}


if_load <- function(x) {
  lgl <- FALSE
  lgl <- suppressWarnings(
    tryCatch(load(x),
      error = function(e) return(NULL)))
  if (is.null(lgl) || length(lgl) == 0L) return(FALSE)
  if (identical(lgl, FALSE)) return(FALSE)
  TRUE
}

if_rds <- function(x) {
  lgl <- FALSE
  lgl <- suppressWarnings(
    tryCatch(readRDS(x),
      error = function(e) return(NULL)))
  if (is.null(lgl) || length(lgl) == 0L) return(FALSE)
  if (identical(lgl, FALSE)) return(FALSE)
  TRUE
}

