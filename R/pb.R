
pblue <- function(x) {
    paste0("\033[38;5;110m", x, "\033[39m")
}
pmint <- function(x) {
    paste0("\033[38;5;36m", x, "\033[39m")
}
ppink <- function(x) {
    paste0("\033[38;5;198m", x, "\033[39m")
}
ppurp <- function(x) {
    paste0("\033[38;5;99m", x, "\033[39m")
}
pgray <- function(x) {
    paste0("\033[38;5;241m", x, "\033[39m")
}
hbar <- function() "\u2015"
hbars <- function(n) if (n > 0) paste(rep(hbar(), n), collapse = "") else ""
hspace <- function() " "
hspaces <- function(n) if (n > 0) paste(rep(hspace(), n), collapse = "") else ""
pb_build_msg <- function(action, pct_cmp, barwidth, secs = 0, action_pad = 1, secs_pad = 1) {
  if (secs > 129599) {
    secs <- sprintf("%3dd", as.integer(secs / 86400))
  } else if (secs > 3599) {
    secs <- sprintf("%3dh", as.integer(secs / 3600))
  } else if (secs > 90) {
    secs <- sprintf("%3dm", as.integer(secs / 60))
  } else if (secs > 0) {
    secs <- sprintf("%3ds", as.integer(secs))
  } else {
    secs <- ""
  }
  bar_cmp <- as.integer(pct_cmp * barwidth)
  bar_rem <- barwidth - bar_cmp
  paste0(
    pmint(action), hspaces(action_pad),
    ppink(hbars(bar_cmp)),
    pgray(hbars(bar_rem)),
    hspaces(secs_pad), ppurp(secs)
  )
}

progress_bar <- function(its, fmt = "Working", width = NULL) {
    if (is.null(width)) {
        width <- min(c(75, getOption("width", 75)), na.rm = TRUE)
    }
    .pb <- new.env()
    assign("i", 0L, envir = .pb)
    assign("N", its, envir = .pb)
    fmt <- paste0("..", fmt, "..", hspaces(max(c(1, 14 - nchar(fmt)))))
    mwidth <- width - nchar(fmt)
    bar_width <- width - nchar(fmt) - 4L
    assign("width", width, envir = .pb)
    pb_int <- bar_width / its
    assign("pb_int", pb_int, envir = .pb)
    assign("pb_start_time", Sys.time() - 1, envir = .pb)
    list(
        tick = function(expr) {
            ## update iterator
            i <- get("i", envir = .pb)
            i <- i + 1L
            assign("i", i, envir = .pb)

            ## calculate progress and estimate time remaining
            N <- get("N", envir = .pb)
            pb_int <- get("pb_int", envir = .pb)
            pb_start_time <- get("pb_start_time", envir = .pb)
            s <- as.numeric(difftime(Sys.time(), pb_start_time, units = "secs"))
            pb_secs_per <- s / i
            pb_secs_tot <- pb_secs_per * N
            pb_secs_rmn <- as.integer(pb_secs_tot - s)

            ## build message, evaluate expression, print time remaining
            bar_width <- get("bar_width", envir = .pb)
            msg <- pb_build_msg(fmt, pct_cmp = i / N, barwidth = bar_width, secs = pb_secs_rmn)
            x <- eval(expr)

            if (i >= N) {
                cat(msg)
            } else {
                cat(msg)
                pb_clear_line(0)
            }
            x
        }
    )
}

pb_clear_line <- function(width = getOption("width")) {
    sp <- hspaces(width)
    str <- paste0(c("\r", sp), collapse = "")
    cat(.makeMessage(str))
}

pb_end <- function(width = getOption("width")) {
    str <- "\n"
    cat(.makeMessage(str))
}