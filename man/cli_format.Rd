% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format.R
\name{cli_format}
\alias{cli_format}
\alias{cli_format.default}
\alias{cli_format.character}
\alias{cli_format.numeric}
\title{Format a value for printing}
\usage{
cli_format(x, style = list(), ...)

\method{cli_format}{default}(x, style = list(), ...)

\method{cli_format}{character}(x, style = list(), ...)

\method{cli_format}{numeric}(x, style = list(), ...)
}
\arguments{
\item{x}{The object to format.}

\item{style}{List of formatting options, see the individual methods
for the style options they support.}

\item{...}{Additional arguments for methods.}
}
\description{
This function can be used directly, or via the \verb{\{.val ...\}} inline
style. \verb{\{.val \{expr\}\}} calls \code{cli_format()} automatically on the value
of \code{expr}, before styling and collapsing it.
}
\details{
It is possible to define new S3 methods for \code{cli_format} and then
these will be used automatically for \verb{\{.cal ...\}} expressions.
}
\examples{
things <- c(rep("this", 3), "that")
cli_format(things)
cli_text("{.val {things}}")

nums <- 1:5 / 7
cli_format(nums, style = list(digits = 2))
cli_text("{.val {nums}}")
divid <- cli_div(theme = list(.val = list(digits = 3)))
cli_text("{.val {nums}}")
cli_end(divid)
}
\seealso{
cli_vec
}
