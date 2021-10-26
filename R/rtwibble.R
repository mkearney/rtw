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
  x[seq_len(n) , ]
}


#' @export
print.rtwibble <- function(x, ...) {
  cat("# rtwibble (", NROW(x), " x ", NCOL(x), ")\n", sep = "")
  if (NROW(x) == 0) {
    return(invisible())
  }
  if (!all(c("text", "screen_name", "created_at") %in% names(x))) {
    x <- hd(x)
    print.data.frame(x)
    return(invisible())
  }
  p <- hd(x[, names(x) %in% c("created_at", "screen_name", "text")])
  w <- getOption("width", 80)
  w <- max(c(getOption("width", 80), 80))
  w <- w - (42 + max(nchar(p[["screen_name"]])))
  dots <- nchar(p[["text"]]) > w
  p[["text"]] <- substr(p[["text"]], 1, w)
  p[["text"]] <- ifelse(dots, paste0(p[["text"]], "..."), p[["text"]])
  p[["..."]] <- "."
  print.data.frame(p)
  cat("   ...\n", sep = "")
  invisible(x)
}
