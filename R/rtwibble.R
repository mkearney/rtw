add_class <- function(x, ...) unique(c(..., class(x)))

as_rtwibble <- function(x = NULL) {
  if (is.null(x) || NROW(x) == 0) {
    x <- data.frame()
  }
  x <- as.data.frame(x, row.names = NULL, stringsAsFactors = FALSE)
  structure(x, class = add_class(x, "rtwibble"))
}

hd <- function(x, n = 10) {
  if (!is.data.frame(x)) {
    return(x)
  }
  n <- min(c(NROW(x), n))
  x[seq_len(n), , drop = FALSE]
}


#' @export
print.rtwibble <- function(x, n = 10, ...) {
  cat("# rtwibble (", NROW(x), " x ", NCOL(x), ")\n", sep = "")
  if (NROW(x) == 0) {
    return(invisible())
  }
  if (!all(c("text", "screen_name", "created_at") %in% names(x))) {
    p <- hd(x, n = n)
    print.data.frame(p)
    return(invisible(x))
  }
  vars <- names(x)
  vars <- sub("favou?rites?", "favs", sub("followers", "flw", sub("friends", "fds", vars)))
  vars <- sub("account_", "act_", sub("account_created", "act_crt", sub("_count", "_cnt", vars)))
  vars <- unique(sub("(?<=quoted|reply_to|retweet|mentions|place|country|profile)_.*",
    "_..", vars, perl = TRUE))
  vars <- grep("_expanded|t\\.co|_type|coords_coords|bbox|protected|display_text", vars, invert = TRUE, value = TRUE)
  vars <- unique(sub("_url", "", vars))
  vars <- paste("*", vars)
  if (length(vars) %% 4 == 1) {
    vars <- c(vars, "", "", "")
  }
  if (length(vars) %% 4 == 2) {
    vars <- c(vars, "", "")
  }
    if (length(vars) %% 4 == 3) {
    vars <- c(vars, "")
  }
  v1 <- vars[seq_len(length(vars) / 4)]
  v2 <- vars[(length(vars) / 4 + 1):(length(vars) / 4 * 2)]
  v3 <- vars[(length(vars) / 4 * 2 + 1):(length(vars) / 4 * 3)]
  v4 <- vars[!vars %in% v1 & !vars %in% v2 & !vars %in% v3]
  chars <- max(nchar(v1)) - nchar(v1)
  v1 <- paste0(v1, sapply(chars, function(.x) paste(rep(" ", .x), collapse = "")))
  chars <- max(nchar(v2)) - nchar(v2)
  v2 <- paste0(v2, sapply(chars, function(.x) paste(rep(" ", .x), collapse = "")))
  chars <- max(nchar(v3)) - nchar(v3)
  v3 <- paste0(v3, sapply(chars, function(.x) paste(rep(" ", .x), collapse = "")))
  vars <- paste(v1, v2, v3, v4)
  vars <- paste(vars, collapse = "\n")
  #vars <- strwrap(paste(sort(vars), collapse = ";"), getOption("width"))
  p <- hd(x[, names(x) %in% c("created_at", "screen_name", "text")], n = n)
  w <- getOption("width", 80)
  w <- max(c(getOption("width", 80), 80))
  w <- w - (52 + max(nchar(p[["screen_name"]])))
  dots <- nchar(p[["text"]]) > w
  p[["text"]] <- substr(p[["text"]], 1, w)
  wdts <- calc_width(p[["text"]])
  wdts[wdts <= 0.125] <- 0
  w <- ceiling(w - (w * wdts * 2.4))
  w[w < 5] <- 5
  p[["text"]] <- substr(p[["text"]], 1, w)
  p[["text"]] <- ifelse(dots, paste0(p[["text"]], "..."), p[["text"]])
  p[["..."]] <- "."
  print.data.frame(p)
  cat("   ...\n", sep = "")
  cat("Other variables:", vars, fill = TRUE)
  invisible(x)
}

#' @importFrom utils object.size
calc_width <- function(x) {
  char <- nchar(x)
  uncd <- log1p(count_unicode(x))
  size <- sapply(x, utils::object.size, USE.NAMES = FALSE)
  -2.469e-03 * char +
    1.479e-03 * size +
    -1.329e-02 * uncd +
    2.325e-05 * (char^2) +
    -6.766e-06 * (char * size) +
    -5.000e-05 * (char * uncd)
}


count_unicode <- function(x) {
  x <- iconv(x, 'utf-8', 'ascii', sub = '<UNICODE>')
  m <- gregexpr("<UNICODE>", x)
  lens <- lengths(m)
  lens[lens == 1] <- ifelse(sapply(m[lens == 1], function(.x) .x < 0), 0, 1)
  lens
}