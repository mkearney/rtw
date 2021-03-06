#' Get tweets data for given statuses (status IDs).
#'
#' Returns data on up to 90,000 Twitter statuses. To return data on
#' more than 90,000 statuses, users must iterate through status IDs
#' whilst avoiding rate limits, which reset every 15 minutes.
#'
#' @param statuses User id or screen name of target user.
#' @param parse Logical, indicating whether or not to parse
#'   return object into data frame(s).
#' @param token a twitter token.
#' @seealso \url{https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/get-statuses-lookup}
#' @examples
#'
#' \dontrun{
#'
#' ## create object containing status IDs
#' statuses <- c(
#'   "567053242429734913",
#'   "266031293945503744",
#'   "440322224407314432"
#' )
#'
#' ## lookup tweets data for given statuses
#' tw <- lookup_statuses(statuses)
#' tw
#'
#' }
#'
#' @return A data.frame of tweets data.
#' @family tweets
#' @export
lookup_statuses <- function(statuses, parse = TRUE, token = NULL) {
  args <- list(statuses = statuses, parse = parse, token = token)
  do.call("lookup_statuses_", args)
}

#' @rdname lookup_statuses
#' @export
lookup_tweets <- function(statuses, parse = TRUE, token = NULL) {
  lookup_statuses(statuses, parse = parse, token = token)
}

lookup_statuses_ <- function(statuses,
                             token = NULL,
                             parse = TRUE) {
  stopifnot(is.atomic(statuses))
  if (length(statuses) > 90000) {
    warning("number of statuses exceed max per token",
      "collecting data for first 90,000 ids")
    statuses <- statuses[1:90000]
  }
  n.times <- ceiling(length(statuses) / 100)
  from <- 1
  twt <- vector("list", n.times)
  pb <- pbr::pbr(n.times)
  on.exit(pb$done(), add = TRUE)
  for (i in seq_len(n.times)) {
    to <- from + 99
    if (to > length(statuses)) {
      to <- length(statuses)
    }
    twt[[i]] <- .status_lookup(statuses[from:to], token = token)
    pb$tick()
    from <- to + 1
    if (from > length(statuses)) break
  }
  if (parse) {
    twt <- tweets_with_users(twt)
  }
  twt
}

.status_lookup <- function(statuses, token = NULL) {
  ## gotta have ut8-encoding for the comma separated IDs
  op <- getOption("encoding")
  on.exit(options(encoding = op), add = TRUE)
  options(encoding = "UTF-8")

  query <- "statuses/lookup"
  if (length(statuses) > 100) {
    statuses <- statuses[1:100]
  }
  params <- list(
    id = paste(statuses, collapse = ","),
    tweet_mode = "extended")
  url <- make_url(
    query = query,
    param = params)
  token <- check_token(token)
  if (length(statuses) > 20L) {
    get <- FALSE
  } else {
    get <- TRUE
  }
  resp <- TWIT(get = get, url, token)
  from_js(resp)
}



