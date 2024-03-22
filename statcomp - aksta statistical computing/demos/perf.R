# -------------------------------------------------------------------------- tracing memory usage
x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))
medians <- sapply(x, median)

cat(tracemem(x), "\n")
iters <- 0
for (i in seq_along(medians)) {
    iters <- iters + 1
    x[[i]] <- x[[i]] - medians[[i]]
}
print(paste("iterations:", iters))
untracemem(x)

y <- as.list(x)
cat(tracemem(y), "\n")
iters <- 0
for (i in seq_along(medians)) {
    iters <- iters + 1
    y[[i]] <- y[[i]] - medians[[i]]
}
print(paste("iterations:", iters))
untracemem(y)

# -------------------------------------------------------------------------- benchmarking
if (!require("tibble")) install.packages("tibble")
library(tibble)
if (!require("bench")) install.packages("bench")
library(bench)

# naive implementation
slow.sqrt <- function(x) {
    ans <- numeric(0)
    for (i in seq_along(x)) {
        ans <- c(ans, sqrt(x[i]))
    }
    ans
}

# preallocate result vector
pre.sqrt <- function(x) {
    ans <- numeric(length(x))
    for (i in seq_along(x)) {
        ans[i] <- sqrt(x[i])
    }
    ans
}

# benchmark
mark(slow.sqrt(1:1000), pre.sqrt(1:1000), sqrt(1:1000))

# -------------------------------------------------------------------------- profiling
testFunc <- function(n = 1000000, seed = 1) {
    set.seed(seed)
    normals <- rnorm(n*10)
    X <- matrix(normals, nrow=10)
    Y <- matrix(normals, ncol=10)
    XXt <- X %*% t(X)
    XXcp <- tcrossprod(X)
    return(n)
}
system.time(testFunc())

# check execution time of each instruction inside the function
Rprof(interval = 0.01)
testFunc()
Rprof(NULL)
summaryRprof()$by.self

# visualization using profvis
if (!require("profvis")) install.packages("profvis")
library("profvis")

# profvis({
#     testFunc <- function(n=1000000, seed=1){ set.seed(seed)
#         normals <- rnorm(n*10)
#         X <- matrix(normals, nrow=10)
#         Y <- matrix(normals, ncol=10)
#         XXt <- X %*% t(X)
#         XXcp <- tcrossprod(X)
#         return(n)
#     }
#     testFunc()
# })

# -------------------------------------------------------------------------- parallelim
# see: https://facweb1.redlands.edu/fac/jim_bentley/Data/MATH_260/R%20Extras/Parallel/parallel.html
# summary: parallelism is hard to get right in R and if done incorrectly like below it actually slows everything down

if(!require("parallel")) install.packages("parallel")
library("parallel")
if(!require("MASS")) install.packages("MASS")
library("MASS")
if (!require("devtools")) install.packages("devtools")
library(devtools)
if (!require("microbenchmark")) install.packages("microbenchmark")
library(microbenchmark)
if (!require("foreach")) install.packages("foreach")
library(foreach)
if (!require("doParallel")) install.packages("doParallel")
library(doParallel)

# assert installed
p_load(parallel)
p_load(MASS)
p_load(devtools)
p_load(microbenchmark)
p_load(foreach)
p_load(doParallel)

numCores <- detectCores()
print(paste("number of cores:", numCores))
cat(system("uname -a", intern=TRUE), "\n")

# demo 1
starts <- rep(100,4)
fx <- function(nstart) kmeans(Boston, 4, nstart=nstart)
microbenchmark(lapply(starts, fx), mclapply(starts, fx, mc.cores=numCores))

# demo 2
# slow because of multiprocessing, not multithreading -> too many forks
registerDoParallel(2)
getDoParWorkers()
microbenchmark(
    for (i in 1:10){
        sqrt(i)
    },
    foreach(i=1:10) %do% {
        sqrt(i)
    },
    foreach (i=1:10) %dopar% {
        sqrt(i)
    },
    foreach (i=1:10, .combine=c) %dopar% {
        sqrt(i)
    }
)

# demo 3
x <- iris[which(iris[,5] != "setosa"), c(1,5)] 
trials <- 2
microbenchmark(
    bs1 <- foreach(icount(trials), .combine=cbind) %dopar% { 
        ind <- sample(100, 100, replace=TRUE) 
        result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit)) 
        coefficients(result1) 
    },
    bs2 <- foreach(icount(trials), .combine=cbind) %do% { 
        ind <- sample(100, 100, replace=TRUE) 
        result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit)) 
        coefficients(result1) 
    }
)
