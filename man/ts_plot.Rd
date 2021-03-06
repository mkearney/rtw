% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts_plot.R
\name{ts_plot}
\alias{ts_plot}
\title{Plots tweets data as a time series-like data object.}
\usage{
ts_plot(data, by = "days", trim = 0L, tz = "UTC", ...)
}
\arguments{
\item{data}{Data frame or grouped data frame.}

\item{by}{Desired interval of time expressed as numeral plus one of
"secs", "mins", "hours", "days", "weeks", "months", or
"years". If a numeric is provided, the value is assumed to be in
seconds.}

\item{trim}{The number of observations to drop off the beginning
and end of the time series.}

\item{tz}{Time zone to be used, defaults to "UTC" (Twitter default)}

\item{...}{Other arguments passed to
\code{\link[graphics]{plot}}.}
}
\value{
If
  A basic time series plot
}
\description{
Creates a ggplot2 plot of the frequency of tweets over a specified
interval of time.
}
\examples{

\dontrun{

## search for tweets containing "rstats"
rt <- search_tweets("rstats", n = 10000)

## plot frequency in 1 min intervals
ts_plot(rt, "mins")


}
}
\concept{ts_data}
