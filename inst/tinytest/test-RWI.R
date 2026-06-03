library(TTR)
library(xts)

# Use stock data from TTR for testing
data(ttrc)
test_data <- ttrc[1:100, c("High", "Low", "Close")]

# ------------------------------------------------------------------------------
# Test 1: Basic functionality and dimensions
# ------------------------------------------------------------------------------
test_xts <- xts(test_data, order.by = Sys.Date() - 100:1)
res <- RWI(test_xts, n = 14)
expect_identical( dim(res), c(100L, 2L) )
expect_identical( colnames(res), c("RWI.High", "RWI.Low") )
expect_true( inherits(res, "xts") )

# ------------------------------------------------------------------------------
# Test 2: Error handling for missing columns
# ------------------------------------------------------------------------------
expect_error( RWI(ttrc[, "Close"], n=14), "Price series must contain High-Low-Close columns." )

# ------------------------------------------------------------------------------
# Test 3: Errors on HL data (no Close)
# ------------------------------------------------------------------------------
hl_data <- test_data[, c("High", "Low")]
expect_error( RWI(hl_data, n=14), "Price series must contain High-Low-Close columns." )

# ------------------------------------------------------------------------------
# Test 4: Custom maType
# ------------------------------------------------------------------------------
res_sma <- RWI(test_xts, n = 14, maType = "SMA")
expect_false( isTRUE(all.equal(res, res_sma)) ) # EMA and SMA should differ

# ------------------------------------------------------------------------------
# Test 5: Known mathematical properties
# RWI should have NA values at the beginning matching the max lookback for ATR
# ------------------------------------------------------------------------------
# For n=14, ATR(14) needs 14 periods. Plus we lag it by 1 period, so 15.
# Wait, pmax ignores NAs if na.rm=TRUE, but the first few values of ATR will be NA.
expect_true( is.na(res[1, "RWI.High"]) )
expect_true( is.na(res[1, "RWI.Low"]) )
