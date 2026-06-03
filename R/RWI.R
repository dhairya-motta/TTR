#' Random Walk Index
#' 
#' The Random Walk Index (RWI) calculates the actual price movement over 
#' a specified period of time relative to a random walk. It helps determine
#' if a security is in a strong uptrend or downtrend.
#' 
#' @param x Object that is coercible to xts or matrix and contains 
#' High-Low-Close prices. If only High-Low is provided, TR falls back 
#' to High - Low.
#' @param n Number of periods to use for the maximum look-back.
#' @param maType A function or a string naming the function to be called.
#' @param \dots Other arguments to be passed to the \code{maType} function.
#' 
#' @return A object of the same class as \code{x} or a matrix (if \code{try.xts}
#' fails) containing the RWI.High and RWI.Low.
#' 
#' @author Joshua Ulrich, Dhairya Motta
#' @references
#' \itemize{
#'   \item \url{https://www.technicalindicators.net/indicators-technical-analysis/168-rwi-random-walk-index}
#'   \item \url{https://tradingsim.com/blog/random-walk-index/}
#'   \item \url{https://www.linnsoft.com/techind/random-walk-index}
#' }
#' @seealso See \code{\link{ATR}}, \code{\link{EMA}}, \code{\link{SMA}}, etc.
#' @keywords ts
#' @export
RWI <- function(x, n = 14, maType = "EMA", ...) {
  
  # Input validation
  x <- try.xts(x, error = as.matrix)
  
  # Calculation requires HLC series for True Range
  if (NCOL(x) >= 3) {
    hi <- x[, 1]
    lo <- x[, 2]
  } else {
    stop("Price series must contain High-Low-Close columns.")
  }
  
  rwih <- rep(NA_real_, NROW(x))
  rwil <- rep(NA_real_, NROW(x))
  
  for (i in 1:n) {
    if (i == 1) {
      atr_i <- TR(x)[, "tr"]
    } else {
      atr_i <- ATR(x, n = i, maType = maType, ...)[, "atr"]
    }
    
    # ATR is shifted back by 1 period per standard calculation formulas
    atr_shift <- lag(atr_i, 1)
    
    lo_shift <- lag(lo, i)
    hi_shift <- lag(hi, i)
    
    rwih_i <- (hi - lo_shift) / (atr_shift * sqrt(i))
    rwil_i <- (hi_shift - lo) / (atr_shift * sqrt(i))
    
    rwih <- pmax(rwih, coredata(rwih_i), na.rm = TRUE)
    rwil <- pmax(rwil, coredata(rwil_i), na.rm = TRUE)
  }
  
  res <- cbind(RWI.High = rwih, RWI.Low = rwil)
  reclass(res, x)
}
