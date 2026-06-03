\name{RWI}
\alias{RWI}
\title{Random Walk Index}
\description{
  The Random Walk Index (RWI) is a technical indicator created by Michael Poulos 
  to determine if a security is in a strong uptrend or downtrend by comparing 
  price movements to a random walk.
}
\usage{
RWI(x, n = 14, maType = "EMA", \dots)
}
\arguments{
  \item{x}{Object that is coercible to xts or matrix and contains High-Low-Close 
  prices. If only High-Low is provided, TR falls back to High - Low.}
  \item{n}{Number of periods to use for the maximum look-back.}
  \item{maType}{A function or a string naming the function to be called.}
  \item{\dots}{Other arguments to be passed to the \code{maType} function.}
}
\details{
  The RWI separates the trend into \code{RWI High} (for uptrends) and 
  \code{RWI Low} (for downtrends). It calculates the maximum of the price movement 
  relative to the Average True Range (ATR) over the specified \code{n} periods, 
  scaled by the square root of time. 
  
  An \code{RWI High} value greater than 1 typically indicates a strong uptrend, 
  while an \code{RWI Low} value greater than 1 indicates a strong downtrend.
}
\value{
  A object of the same class as \code{x} or a matrix (if \code{try.xts} fails) 
  containing the columns:
  \item{ RWI.High }{The RWI High values.}
  \item{ RWI.Low }{The RWI Low values.}
}
\references{
  The following site(s) were used to code/document this indicator:\cr
  \url{https://tradingsim.com/blog/random-walk-index/}\cr
  \url{https://www.linnsoft.com/techind/random-walk-index}\cr
}
\author{Joshua Ulrich, Dhairya Motta}
\seealso{
  See \code{\link{ATR}}, \code{\link{EMA}}, \code{\link{SMA}}, etc.
}
\examples{
  data(ttrc)
  rwi <- RWI(ttrc[,c("High","Low","Close")])
}
\keyword{ts}
