

progress_bar <- function(its, fmt = "Working", width = getOption("width")) {
    .pb <- new.env()
    assign("i", 0L, envir = .pb)
    assign("N", its, envir = .pb)
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
            msg <- paste(fmt,
              paste(rep("=", ceiling(pb_int * i)), collapse = ""))
            width <- get("width", envir = .pb)
            x <- pb_tick(expr, msg = msg, secs = pb_secs_rmn, width = width)
            if (i >= N) {
                pb_clear_line(width)
            } else {
                pb_clear_line(1)
            }
            x
        }
    )
}

pb_tick <- function(expr, msg = "=", secs = NULL, width = getOption("width")) {
    x <- eval(expr)
    if (!is.null(secs)) {
        secsfmt <- sprintf("%4ds", secs)
        sprmn <- width - nchar(msg) + 1L
        if (sprmn > 0) {
            secsfmt <- paste0(paste(rep(" ", sprmn), collapse = ""), secsfmt)
        }
        msg <- paste0(msg, secsfmt)
    }
    cat(msg)
    x
}
pb_clear_line <- function(width = getOption("width")) {
    str <- paste0(c("\r", rep(" ", width)), collapse = "")
    cat(.makeMessage(str))
}
