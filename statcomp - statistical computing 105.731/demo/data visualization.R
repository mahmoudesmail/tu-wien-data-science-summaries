# -------------------------------------------------------------------------- data visualization with base R
demo("graphics")

# -------- high level plotting functions
# api
methods(plot)

# example: dick
x <- seq(-2, 2, length=100)
y <- seq(-2, 2, length=100)
z <- outer(x, y, function(x, y) 0.98*y^2*((y^2-3.01)*y^2+3)-1.005+2.8*x^2*(x^2*(2.5*x^2+y^2-2)+1.2*y^2*(y*(3*y-0.75)-6.0311)+3.09))
contour(x, y, z)

data <- rnorm(100)
hist(data) # histogram
boxplot(data) # boxplot
plot(data) # scatterplot
plot(density(data)) # density plot (if converted)
stripchart(x) # stripchart

y <- rt(200, df = 5) # comparison against normal distribution
qqnorm(y)
qqplot(y, rt(300, df = 5)) # comparison against a different distribution

fac <- factor(sample(1:3, 100, replace = TRUE), labels=c("red", "green", "blue"))
plot(fac) # bar plot (if a factor)
pie(table(fac)) # pie chart

plot(rnorm(100), rexp(100)) # scatterplot

df <- data.frame("x" = rnorm(100), y = rpois(100, lambda = 1), z = rexp(100))
pairs(df) # scatterplot against all functions

# -------- low level plotting functions (like extra points, lines, legend, ...)
if (!require("MASS")) install.packages("MASS")
library("MASS")
groupA <- mvrnorm(100, mu = c(0,0), Sigma = matrix(c(1,0.5,0.5,1), nrow = 2))
groupB <- mvrnorm(100, mu = c(1,1), Sigma = matrix(c(1,-0.5,-0.5,1), nrow = 2))
df <- rbind(
    data.frame(groupA, group = "A"),
    data.frame(groupB, group = "B")
)
plot(
    df$X1,
    df$X2,
    xlim = c(-4,4),
    ylim = c(-4,4),
    col = ifelse(df$group == "A", "green", "blue"),
    pch = 2,
    xlab = "Variable 1",
    ylab="Variable 2"
)
abline(h=0, col="black")
legend("topleft", legend=c("Group A", "Group B"), col = c("green", "blue"), pch = c(1,1))

# -------- combining multiple plots
# using par() to configure environment
def.par <- par(no.readonly = TRUE)
par(mfrow=c(1,2))
curve(sin, -2*pi, 2*pi)
curve(tan, -2*pi, 2*pi)
par(def.par) # return to previous environment

# outer plots
x <- pmin(3, pmax(-3, stats::rnorm(50)))
y <- pmin(3, pmax(-3, stats::rnorm(50)))
xhist <- hist(x, breaks = seq(-3,3,0.5), plot = FALSE)
yhist <- hist(y, breaks = seq(-3,3,0.5), plot = FALSE)
top <- max(c(xhist$counts, yhist$counts))
xrange <- c(-3, 3)
yrange <- c(-3, 3)
nf <- layout(matrix(c(2,0,1,3),2,2,byrow = TRUE), c(3,1), c(1,3), TRUE)

layout.show(nf) # show grid for debugging

# inner plots
par(mar = c(3,3,1,1))
plot(x, y, xlim = xrange, ylim = yrange, xlab = "", ylab = "")
par(mar = c(0,3,1,1))
barplot(xhist$counts, axes = FALSE, ylim = c(0, top), space = 0)
par(mar = c(3,0,1,1))
barplot(yhist$counts, axes = FALSE, xlim = c(0, top), space = 0, horiz = TRUE)

# -------- interactive plotting functions
identify(x,y) # doesn't work in vscode pngs

# -------------------------------------------------------------------------- data visualization with ggplot2
if (!require("ggplot2")) install.packages("ggplot2")
library("ggplot2")
library("palmerpenguins")

# scatterplot
ggplot(penguins) +
    aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = sex) +
    geom_point()

# line plot (with multiple layers)
avg_body_mass <- mean(penguins$body_mass_g, na.rm=TRUE)
dat_mean <- data.frame(body_mass_g = rep(avg_body_mass, 3), species = c("Adelie", "Chinstrap", "Gentoo"))
dat_density <- data.frame(body_mass_g = rep(penguins$body_mass_g, 3), species = rep(c("Adelie", "Chinstrap", "Gentoo"), each = nrow(penguins)))
ggplot(penguins) +
    aes(x = body_mass_g, fill = species) +
    aes(y = stat(density)) +
    geom_histogram(binwidth = 500) +
    facet_wrap(~species) +
    # density line
    geom_density(data = dat_density, fill = NA) +
    # average line
    geom_vline(data = dat_mean, aes(xintercept = body_mass_g)) + facet_wrap(~ species) +
    # customizing
    theme_bw() +
    ggtitle("penguins") +
    xlab("body mass in g") +
    ylab("counts") +
    scale_fill_brewer(palette = "Dark2") +
    theme(legend.position = "none")
