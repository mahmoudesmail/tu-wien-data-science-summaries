if (!require("pacman")) install.packages("pacman", repos = "http://cran.us.r-project.org")
library("pacman")
pacman::p_load(numbers, DescTools, microbenchmark, parallel, foreach, doParallel, devtools, Rcpp)

plot_golden_ratio <- function(result) {
  golden_ratio <- (1 + sqrt(5)) / 2
  last_elem <- result[length(result)]
  diff <- abs(golden_ratio - last_elem)

  cat("🧪 results:", "\n")
  cat("- last elem:", last_elem, "\n")
  cat("- golden ratio:", golden_ratio, "\n")
  cat("- abs diff:", diff, "\n")

  plot(result, pch = 19, col = "black")
  lines(result, pch = 19, col = "black")
  abline(h = (1 + sqrt(5)) / 2, col = "brown", lty = 2)
  legend("topright", legend = c("f(i)/f(i+1)", "Golden Ratio"), col = c("red", "blue"), lwd = 2)
}

fib_ratio_rec_memo_1 <- function(n) {
  stopifnot(n > 1)
  memo <- rep(NA, n)
  memo[1:2] <- c(Inf, 1)

  fibrec <- function(i) {
    if (is.na(memo[i])) {
      memo[i] <<- 1 + 1 / fibrec(i - 1)
    }
    memo[i]
  }
  sapply(seq_len(n), fibrec)
}

solution <- fib_ratio_rec_memo_1(1000)
# plot_golden_ratio(solution)


# fib_ratio_pow <- function(n) {
#   stopifnot(n > 1)
#   fibonacci_n <- (1 + sqrt(5))^n / sqrt(5)
#   fibonacci_n_minus_1 <- (1 + sqrt(5))^(n - 1) / sqrt(5)
#   return(fibonacci_n / fibonacci_n_minus_1)
# }

test_range <- c(12, 60, 120, 300)
fib_ratio_pow <- (1 + (5^0.5)) / 2
for (i in test_range) {
  rec <- tail(fib_ratio_rec_memo_1(i), 1)
  pow <- fib_ratio_pow
  diff <- abs(rec - pow)
  cat(sprintf("%03d", i), "-> diff:", diff, "\n")
}