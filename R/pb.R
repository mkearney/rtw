
pblue <- function(x) {
    paste0("\033[38;5;110m", x, "\033[39m")
}

progress_bar <- function(its, fmt = "Working", width = getOption("width")) {
    .pb <- new.env()
    assign("i", 0L, envir = .pb)
    assign("N", its, envir = .pb)
    fmt <- paste0("...", fmt, "...", paste(rep(" ", max(c(1, 15 - nchar(fmt)))),
      collapse = ""), "[")
    mwidth <- width - nchar(fmt)
    assign("width", width, envir = .pb)
    pb_int <- mwidth / its
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
            msg <- paste0(fmt,
              paste(rep("=", ceiling(pb_int * i)), collapse = ""))
            width <- get("width", envir = .pb)
            if (i >= N) {
                x <- pb_tick(expr, msg = msg, width = width)
                #pb_clear_line(width)
            } else {
                x <- pb_tick(expr, msg = msg, secs = pb_secs_rmn, width = width)
                pb_clear_line(0)
            }
            x
        }
    )
}

pb_tick <- function(expr, msg = "=", secs = NULL, width = getOption("width")) {
    x <- eval(expr)
    if (!is.null(secs)) {
        if (secs <= 120) {
            secsfmt <- sprintf("%4ds", secs)
        } else {
            secsfmt <- springf("%4dm", ceiling(secs / 60))
        }
        sprmn <- width - nchar(msg) + 1L
        if (sprmn > 0) {
            secsfmt <- paste0("[", paste(rep(" ", sprmn), collapse = ""), secsfmt)
        } else {
            secsfmt <- paste0("[", secsfmt)
        }
        msg <- paste0(msg, secsfmt)
    } else {
        msg <- paste0(msg, "]")
    }
    cat(pblue(msg))
    x
}
pb_clear_line <- function(width = getOption("width")) {
    sp <- if (width > 0) {
        rep(" ", width)
    } else {
        ""
    }
    str <- paste0(c("\r", sp), collapse = "")
    cat(.makeMessage(str))
}

pb_end <- function(width = getOption("width")) {
    str <- "\n"
    cat(.makeMessage(str))
}