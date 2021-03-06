% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lists_subscriptions.R
\name{lists_subscriptions}
\alias{lists_subscriptions}
\title{Get list subscriptions of a given user.}
\usage{
lists_subscriptions(user, n = 20, cursor = "-1", parse = TRUE, token = NULL)
}
\arguments{
\item{user}{Either the user ID or screen name of user.}

\item{n}{Specifies the number of results to return
per page (see cursor below). The default is 20, with a maximum
of 1000.}

\item{cursor}{Causes the collection of list members
to be broken into "pages" of consistent sizes (specified by
the count parameter). If no cursor is provided, a
value of -1 will be assumed, which is the first "page."
The response from the API will include a previous_cursor
and next_cursor to allow paging back and forth. See Using
cursors to navigate collections for more information.}

\item{parse}{Logical indicating whether to convert the response object into
an R list. Defaults to TRUE.}

\item{token}{a twitter token.}
}
\description{
Get list subscriptions of a given user.
}
\examples{

\dontrun{

## get subscriptions of new york times politics list
rstats <- lists_subscriptions(
  slug = "new-york-times-politics",
  n = 1000
)

}

}
\seealso{
Other lists: 
\code{\link{lists_members}()},
\code{\link{lists_statuses}()},
\code{\link{lists_subscribers}()},
\code{\link{lists_users}()}
}
\concept{lists}
