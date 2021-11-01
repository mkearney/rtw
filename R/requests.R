
req_combine <- function(x, y) {
  if (length(x) == 0 && length(y) == 0)
    return(request())
  if (length(x) == 0)
    return(y)
  if (length(y) == 0)
    return(x)
  request(method = y$method %||% x$method,
    url = y$url %||% x$url,
    headers = keep_last(x$headers, y$headers),
    fields = c(x$fields, y$fields),
    options = keep_last(x$options, y$options),
    auth_token = y$auth_token %||% x$auth_token,
    output = y$output %||% x$output)
}

req_concat <- function(...) {
  Reduce(req_combine, list(...))
}

request <- function(method = NULL,
                    url = NULL,
                    headers = NULL,
                    fields = NULL,
                    options = NULL,
                    auth_token = NULL,
                    output = NULL) {
  list(
    method = method,
    url = url,
    headers = headers,
    fields = fields,
    options = options,
    auth_token = auth_token,
    output = output
  )
}

compact <- function(x) {
  x <- x[lengths(x) > 0]
  x[] <- lapply(x, function(.x) .x[lengths(.x) > 0])
  x
}
compose_query <- function(elements = NULL) {
  if (length(elements) == 0) {
    return("")
  }
  elements <- compact(elements)
  names <- curl::curl_escape(names(elements))
  values <- vapply(elements, curl::curl_escape, FUN.VALUE = character(1),
    USE.NAMES = FALSE)
  paste0("?", paste0(names, "=", values, collapse = "&"))
}

buildq <- function(url) {
  paste0(url$scheme, "://", url$hostname, "/", url$path,
    compose_query(url$query))
}

nonce <- function(length = 10) {
  paste(sample(c(letters, LETTERS, 0:9), length, replace = TRUE),
    collapse = "")
}

.GET <- function(url, token = NULL, ...) {
  if (is.list(url)) {
    url <- buildq(url)
  }
  req <- request("GET", url, auth_token = token)
  if (!is.null(token) && "sign" %in% names(token)) {
    signed_req <- token$sign(req$method, req$url)
    req <- req_concat(req, signed_req)
  } else if (!is.null(token)) {
    req <- req_concat(req, token)
  }
  handle <- curl::new_handle()
  curl::handle_setheaders(handle, .list = req$headers)
  on.exit(curl::handle_reset(handle), add = TRUE)
  curl::curl_fetch_memory(url, handle = handle)
}

.uGET <- function(url, token = NULL, ...) {
  if (is.list(url)) {
    url <- buildq(url)
  }
  cnf <- request(auth_token = token)
  req <- request("GET", url, auth_token = cnf)
  signed_req <- token$sign(req$method, req$url)
  req <- req_concat(req, signed_req)
  handle <- curl::new_handle()
  curl::handle_setheaders(handle, .list = req$headers)
  on.exit(curl::handle_reset(handle), add = TRUE)
  curl::curl_fetch_memory(url, handle = handle)
}

normalize_params <- function(url, params) {
  urls <- sub("[^?]+\\??", "", url)
  urls <- strsplit(urls, "&")[[1]]
  urls <- as.list(unlist(lapply(urls, function(.x) {
    nm <- sub("=.*", "", .x)
    v <- sub("^[^=]+=", "", .x)
    `names<-`(v, nm)
  })))
  params <- lapply(params, as.character)
  params <- c(urls, params)
  params <- params[order(names(params))]
  paste0(names(params), "=", params, collapse = "&")
}

oauth_encode <- function(x) {
  x <- vapply(x, as.character, FUN.VALUE = character(1))
  vapply(x, oauth_encode1, character(1))
}

str_detect <- function (string, pattern) {
  grepl(pattern, string)
}

oauth_encode1 <- function(x) {
  encode <- function(x) paste0("%", toupper(as.character(charToRaw(x))),
    collapse = "")
  x <- as.character(x)
  chars <- strsplit(x, "")[[1]]
  ok <- !str_detect(chars, "[^A-Za-z0-9_.~-]")
  if (all(ok))
    return(x)
  chars[!ok] <- unlist(lapply(chars[!ok], encode))
  paste0(chars, collapse = "")
}

oauth_sign <- function(url, method = "GET", app,
                       token_key = NULL,
                       token_secret = NULL) {
  oauth_params <- compact(list(oauth_consumer_key = app$key,
    oauth_nonce = nonce(), oauth_signature_method = "HMAC-SHA1",
    oauth_timestamp = as.integer(Sys.time()), oauth_version = "1.0",
    oauth_token = token_key))
  norm_method <- toupper(method)
  norm_url <- sub("\\?.*", "", url)
  norm_params <- normalize_params(url, oauth_params)
  norm_req <- paste0(norm_method, "&", oauth_encode(norm_url),
    "&", oauth_encode(norm_params))
  private_key <- paste0(oauth_encode(app$secret), "&",
    oauth_encode(token_secret))
  oauth_params$oauth_signature <- sha1_fun(private_key, norm_req)
  sort_names(oauth_params)
}

sort_names <- function(x) x[order(names(x))]

sha1_fun <- function(key, string) {
  if (is.character(string)) {
    string <- charToRaw(paste(string, collapse = "\n"))
  }
  if (is.character(key)) {
    key <- charToRaw(paste(key, collapse = "\n"))
  }
  hash <- openssl::sha1(string, key = key)
  openssl::base64_encode(hash)
}


oauth_header <- function(info) {
  oauth <- paste0("OAuth ", paste0(oauth_encode(names(info)),
    "=\"", oauth_encode(info), "\"", collapse = ", "))
  request(headers = c(Authorization = oauth))
}
