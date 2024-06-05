# press `cmd+shift+enter` to run the code

print("hello world")
print(paste("hello", "world"))

# -------------------------------------------------------------------------- basic data types
# converting illegal variable names to legal ones
validnames <- make.names(c("_abc", "", "a-b", ".123e1"))
print(validnames)

# null (vector of length 0)
nullvar <- NULL

# scalar (vector of length 1)
charvar <- "hello"
doublevar <- 3.14
boolvar <- TRUE
complexvar <- 3 + 4i
intvar <- 5L
infinityvar <- Inf
rawvar <- charToRaw("hello")
print(paste("type of complexvar is:", typeof(complexvar)))

# -------------------------------------------------------------------------- s3 data types
# (atomic / immutable) vector
# all elements get coerced to the same type
vecvar <- c(1, 2, 3, 4, 5)
print(paste("length of vector is:", length(vecvar)))
print(paste("properties of vector are:", attributes(vecvar), class(vecvar), mode(vecvar), typeof(vecvar)))

# list (heterogeneous vector)
listvar <- list(elem1 = 1L:3L, elem2 = c(FALSE, TRUE), elem3 = c(1.1, 2.2), elem4 = "z")
print(str(listvar))

# factor (enum / categorical data)
enum <- c("red", "green", "blue")
factorData <- c("red", "red", "green", "red")
factorvar <- factor(factorData, levels = enum)
print(str(attributes(factorvar)))
table(factorvar)

# matrix (2d vector)
matrixvar <- cbind(c(1, 2, 3), c(4, 5, 6))

# array (n-d vector)
arrayvar0 <- array(1:24, dim=c(2, 2, 3))
colnames(arrayvar0) <- LETTERS[1:ncol(arrayvar0)]
rownames(arrayvar0) <- letters[1:nrow(arrayvar0)]
print(arrayvar0)
arrayvar1 <- matrix(1:6, ncol = 3, nrow = 2)
dimnames(arrayvar1) <- list(c("row1", "row2"), c("col1", "col2", "col3"))
print(arrayvar1)

# dataframe (heterogeneous matrix, list of equal length vectors)
dataframevar <- data.frame(c("one", "two", "three"), c(3, 2, 2), c("a1", "a2", "a1"))
names(dataframevar) <- c("name", "year", "attr")
print(str(dataframevar))

# tibble (modern dataframe)
if (!require("tibble")) {
    install.packages("tibble")
}
library(tibble)
tibblevar <- tibble(age = 1:3, weight = age*2)
print(str(tibblevar))

# data tables (large dataframes)
if (!require("data.table")) {
    install.packages("data.table")
}
library(data.table)
datatablevar <- as.data.table(dataframevar)

# -------------------------------------------------------------------------- data generation
seq1 <- 1:4
seq2 <- seq(from=0, to=1, by=0.3)
seq3 <- seq(length=5, from=0, by=0.3)

rep1 <- rep(c(2, 1), 3)
rep2 <- rep(c(2, 1), each = 3)
sixSidedDie <- sample(1:6, size = 1, replace = TRUE)
print(paste("random number between 1 and 6 is:", sixSidedDie))

# -------------------------------------------------------------------------- vectors in depth
vec1 <- c(1, 2, 3)

# map()
isLarge1 <- vec1 > 2 
isLarge2 <- sapply(vec1, function(x) x > 2)
print(identical(isLarge1, isLarge2)) # true

# naming
namedVec <- c(first = 1, second = 2, third = 3)
unnamedVec <- c(1, 2, 3)
names(unnamedVec) <- c("first", "", "third")
print(identical(namedVec, unnamedVec)) # false

# attributes (metadata)
attr(vec1, "attr1") <- "I'm a vector"
attr(vec1, "attr2") <- mean(vec1)
print(str(attributes(vec1)))

# -------------------------------------------------------------------------- dataframes in depth
df <- data.frame(Income = c(1000, 1100, 1200, 1300, 1400), Age = c(20, 19, 54, 45, 24))
summary(df)

# add / remove columns
df$TmpCol <- c(1, 2, 3, 4, 5)
df$TmpCol <- NULL
df$Group <- factor(c("A", "B", "A", "A", "B"))

# map()
idx <- sapply(df, is.numeric)
df[idx] <- lapply(df[idx], function(x) x + 1)
df[idx] <- df[idx] + 1
print(df)
meanDf <- tapply(df$Income, df$Group, mean)
print(meanDf)

# -------------------------------------------------------------------------- lists in depth
mixedList <- list(a = 1:2, b = letters[1:3], c = c(TRUE, FALSE))

# read elements
# `[` returns a list
# `[[` returns the list content
# `$` == `[[` if named
# `x$n` == `x[["n", exact = FALSE]]`
req1 <- mixedList[1]$a
req2 <- mixedList[[1]]
req3 <- mixedList$a
print(identical(req1, req2, req3)) # true

# -------------------------------------------------------------------------- matrices in depth
matr <- matrix(1:6, ncol = 3)
rownames(matr) <- LETTERS[1:2]
colnames(matr) <- letters[1:3]
print(matr)

# reading elements
matr[c(TRUE, FALSE), c("b", "c")]
matr[ ,c(1, 1, 2)]
matr[-2, ]

# -------------------------------------------------------------------------- arrays in depth
arr <- array(1:12, dim = c(2, 3, 2))

# reading elements
# `drop = TRUE` is the default and looses data through simplification
perserved <- length(dim(arr[ , , 1, drop = FALSE]))
simplified <- length(dim(arr[ , , 1, drop = TRUE]))
print(identical(perserved, simplified)) # false: 3 vs 2

# -------------------------------------------------------------------------- control flow
f <- function(x) {
    if (x < 0) {
        stop("x must be non-negative")
    }
    if (x > 10) {
        warning("x is too large")
    }
    for (i in 1:x) {
        if (i == 3) {
            counter <- 1
            while (counter > 0) {
                print("called function")
                counter <- counter - 1
            }
        }
    }
    return("returned val")
}
print(f(3))
print(formals(f))
print(body(f))
print(environment(f))

# piping
x <- 1:4
res1 <- x |> sum() |> sqrt()

if (!require("magrittr")) {
    install.packages("magrittr")
}
library(magrittr)
res2 <- x %>% sum() %>% sqrt()
print(identical(res1, res2)) # true

# -------------------------------------------------------------------------- error handling
simuMeans <- function(m, n=100, seed=1) {
    set.seed(seed)
    RES <- matrix(0, nrow=m, ncol=3)
    for (i in 1:m){
        X <- cbind(rnorm(n), rt(n,2), rexp(n))
        if (i == 3) {
            X[1,1] <- NA
        }
        for (j in 1:3){
            # this path is critical, so we use tryCatch
            RES[i,j] <- tryCatch(my.mean(X[,j]), error = function(e) warning(e))
        } 
    }
    return(RES)
}
print(simuMeans(5))
