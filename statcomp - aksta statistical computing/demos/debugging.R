# -------------------------------------------------------------------------- debugging
f1 <- function(x) {
    stopifnot(x < 10) # assert statement
    stopifnot(x > 0)
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

# debug(f1)
f1(1)
# undebug(f1)