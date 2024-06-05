# install dependencies
if (!require("pacman")) install.packages("pacman", repos = "http://cran.us.r-project.org")
library("pacman")
pacman::p_load(numbers, DescTools, microbenchmark, parallel, foreach, doParallel, devtools, Rcpp, memoise)

# ------------------------------------------------------------------------------ library implementations

# descTools library
fib_ratio_lib_desctools <- function(n) {
  stopifnot(n > 1)
  seq <- DescTools::Fibonacci(0:(n + 2))
  return(seq[2:(n + 1)] / seq[1:n])
}

# numbers library
fib_ratio_lib_numbers <- function(n) {
  stopifnot(n > 1)
  seq <- sapply(0:n, numbers::fibonacci)
  return(seq[2:(n + 1)] / seq[1:n])
}

# ------------------------------------------------------------------------------ hpc implementations (don't run)

# cpp ffi
# (don't run benchmarks, the ffi is way too slow)
fib_ratio_cpp <- function(n) {
  stopifnot(n > 1)
  fib_cpp <- Rcpp::cppFunction("
  int fibonacci(const int x) {
    if (x == 0) return(0);
    if (x == 1) return(1);
    return (fibonacci(x - 1)) + fibonacci(x - 2);
  }")
  seq <- sapply(0:n, fib_cpp)
  return(seq[2:(n + 1)] / seq[1:n])
}

# parallel
# (don't run benchmarks - it will kill your machine because of too many sub-processes)
fib_ratio_parallel_for <- function(n) {
  stopifnot(n > 1)
  cores <- parallel::detectCores()
  cl <- parallel::makeCluster(cores)
  doParallel::registerDoParallel(cl)
  seq <- foreach::foreach(i = 0:n, .combine = "c") %dopar% {
    numbers::fibonacci(i)
  }
  seq <- DescTools::Fibonacci(0:(n + 2))
  return(seq[2:(n + 1)] / seq[1:n])
}

# ------------------------------------------------------------------------------ sequential implementations

# for-loop
fib_ratio_for <- function(n) {
  stopifnot(n > 1)
  n_fib <- n + 1
  fib <- numeric(n_fib)
  fib[1] <- 0
  fib[2] <- 1
  for (i in 3:n_fib) {
    fib[i] <- fib[i - 1] + fib[i - 2]
  }
  return(fib[2:n_fib] / fib[1:(n_fib - 1)])
}

# while-loop
fib_ratio_while <- function(n) {
  stopifnot(n > 1)
  n_fib <- n + 1
  fib <- numeric(n_fib)
  fib[1] <- 0
  fib[2] <- 1
  i <- 3
  while (i <= n_fib) {
    fib[i] <- fib[i - 1] + fib[i - 2]
    i <- i + 1
  }
  return(fib[2:n_fib] / fib[1:(n_fib - 1)])
}

# ------------------------------------------------------------------------------ recursive implementations

# source: https://www.r-bloggers.com/2014/12/fibonacci-sequence-in-r-with-memoization/
# source: https://www.r-bloggers.com/2018/10/optimize-your-r-code-using-memoization/

# recursive
fib_ratio_rec <- function(n) {
  stopifnot(n > 1)
  fibrec <- function(i) {
    if (i == 0) {
      Inf
    } else if (i == 1) {
      1
    } else {
      1 + 1 / fibrec(i - 1)
    }
  }
  return(sapply(seq_len(n) - 1, fibrec))
}

# recursive memoized v1
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

# recursive memoized v2
fib_ratio_rec_memo_2 <- function(n) {
  stopifnot(n > 1)

  fib_m <- (function() {
    cache <- NULL
    cache_reset <- function() {
      cache <<- new.env(TRUE, emptyenv())
      cache_set("0", 0)
      cache_set("1", 1)
    }
    cache_set <- function(key, value) {
      assign(key, value, envir = cache)
    }
    cache_get <- function(key) {
      get(key, envir = cache, inherits = FALSE)
    }
    cache_has_key <- function(key) {
      exists(key, envir = cache, inherits = FALSE)
    }
    cache_reset()

    function(n) {
      nc <- as.character(n)
      if (length(n) > 1) {
        return(sapply(n, fib_m))
      }
      if (round(n, 0) != n) {
        return(NA)
      }
      if (cache_has_key(nc)) {
        return(cache_get(nc))
      }
      if (n < 0) {
        return(fib_m(-1 * n) * ((-1)^((n + 1) %% 2)))
      }
      out <- fib_m(n - 1) + fib_m(n - 2)
      cache_set(nc, out)
      return(out)
    }
  })()

  seq <- sapply(0:n, fib_m)
  return(seq[2:(n + 1)] / seq[1:n])
}

# ------------------------------------------------------------------------------ tests

test_range <- 2:4
for (n in test_range) {
  cat("n =", n, "\n")

  # cat("descTools: \t", fib_ratio_lib_desctools(n), "\n")
  # cat("numbers: \t", fib_ratio_lib_numbers(n), "\n")
  solution <- fib_ratio_lib_desctools(n)

  # cat("for: \t\t", fib_ratio_for(n), "\n")
  # cat("while: \t\t", fib_ratio_while(n), "\n")
  stopifnot(fib_ratio_for(n) == solution)
  stopifnot(fib_ratio_while(n) == solution)

  # cat("rec: \t\t", fib_ratio_rec(n), "\n")
  # cat("rec_memo_1: \t", fib_ratio_rec_memo_1(n), "\n")
  # cat("rec_memo_2: \t", fib_ratio_rec_memo_2(n), "\n")
  stopifnot(fib_ratio_rec(n) == solution)
  stopifnot(fib_ratio_rec_memo_1(n) == solution)
  stopifnot(fib_ratio_rec_memo_2(n) == solution)

  cat("\n")
}
cat("✅ passed all tests")

# log machine specs for reproducibility
cat(system("uname -a", intern = TRUE), "\n")

# supress warnings
options(warn = -1)

bench <- function(n, iters) {
  cat("🔥 benchmarking for n =", n, "and", iters, "iterations\n")

  microbenchmark::microbenchmark(

    fib_ratio_lib_numbers(n),
    fib_ratio_lib_desctools(n),

    fib_ratio_for(n), # fastest sequential implementation
    fib_ratio_while(n),

    fib_ratio_rec(n),
    fib_ratio_rec_memo_1(n), # fastest recursive implementation
    fib_ratio_rec_memo_2(n),

    times = iters
  )
}

bench(100, 100)
