# -------------------------------------------------------------------------- data cleaning with tidyr
if (!require("tidyverse")) install.packages("tidyverse")
library("tidyverse")
if (!require("tidyr")) install.packages("tidyr")
library("tidyr")

if (!require("gapminder")) install.packages("gapminder")
library("gapminder")
set.seed(123)
randomIdx <- sample(1:nrow(gapminder), 10)
data <- gapminder[randomIdx, ]
print(data)

# pivot_longer(): gather columns into rows
pivotLonger <- data %>%
               pivot_longer(cols = c(gdpPercap, lifeExp, pop), names_to = "indicator", values_to = "value")
print(pivotLonger)

# pivot_wider(): inverse of pivot_longer()
pivotWider <- pivotLonger %>%
             pivot_wider(names_from = indicator, values_from = value)
print(pivotWider)
stopifnot(identical(length(pivotWider), length(data)))

# separate(): split one column into multiple columns
separateData <- data %>%
               separate(col = lifeExp, into = c("lifeExp_p1", "lifeExp_p2"), sep = "[.]") # split lifeExp by "." (regex)
print(separateData)

# unite(): combine multiple columns into one
uniteData <- separateData %>%
            unite(col = lifeExp, c(lifeExp_p1, lifeExp_p2), sep = ".")
print(uniteData)
stopifnot(identical(length(uniteData), length(data)))

# complete(): complete missing combinations of data
stocks <- tibble(
    year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
    qtr = c( 1, 2, 3, 4, 2, 3, 4),
    returnVal = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
completeData <- stocks %>%
                complete(year, qtr) # make explicit that 2016 Q1 is missing
print(completeData)
completeData <- stocks %>%
                pivot_wider(names_from = qtr, values_from = returnVal) # make even more explicit
print(completeData)

# fill(): fill missing values
fillData <- completeData %>%
            fill(`1`, `2`, `3`, `4`)
print(fillData)

# -------------------------------------------------------------------------- data transformation with dplyr
if (!require("dplyr")) install.packages("dplyr")
library("dplyr")

library("nycflights13")
print(flights)
# datasets: 
# - flights 
# - airlines 
# - airports 
# - planes
# - weather

transformed <- flights %>%
            select(year:day, hour, air_time, distance, arr_delay, dep_delay) %>% # filter by cols
            filter(!is.na(arr_delay), !is.na(dep_delay)) %>% # filter by row
            mutate(speed = distance / air_time * 60) %>% # add new col
            transmute(year, month, day, speed, arr_delay, dep_delay) %>% # filter by cols
            arrange(desc(speed)) %>% # sort by col
            rename(arrival_delay = arr_delay, departure_delay = dep_delay) # rename cols
print(transformed)
maxSpeed <- floor(max(transformed$speed))
print(paste("the fastest speed per day is", maxSpeed, "mph, on", transformed$year[1], transformed$month[1], transformed$day[1]))

monthlySummary <- transformed %>%
            group_by(year, month) %>%
            summarise(
                avg_speed = mean(speed),
                avg_arrival_delay = mean(arrival_delay),
                avg_departure_delay = mean(departure_delay)
            ) %>% # map group to single row
            arrange(year, month) # sort by col
maxAvgMothlySpeed <- floor(max(monthlySummary$avg_speed))
print(monthlySummary)
print(paste("the fastest average speed per month is", maxAvgMothlySpeed, "mph, in", monthlySummary$year[1], monthlySummary$month[1]))

# counting by key
countedPlanes <- planes %>%
            count(tailnum, sort = TRUE) %>% # tailnum is the primary key
            filter(n > 0)
countedWeather <- weather %>%
            count(year, month, day, hour, origin) %>%
            filter(n > 0)
print(countedPlanes)
print(countedWeather)

# mutating joins: match by key, then copy data
# the key is the student name
x <- tibble(student = c("Jim","Sarah","Mike"), grade_x = c(1, 4, 2))
y <- tibble(student = c("Jim","Sarah","Julia"), grade_y = c(1, 5, 1), majorS = c("Epi","PH","Epi"))
innerJoin <- x %>% inner_join(y, by = "student") %>% print()
leftJoin <- x %>% left_join(y, by = "student") %>% print()
rightJoin <- x %>% right_join(y, by = "student") %>% print()
fullJoin <- x %>% full_join(y, by = "student") %>% print()

# filtering joins: match by key, then filter data
topDest <- flights %>%
            count(dest, sort = TRUE) %>%
            transmute(dest) %>%
            head(10)
print(topDest)
print(flights)
flightsToTopDest <- flights %>%
            semi_join(topDest, by = "dest") %>%
            mutate(date = paste(year, month, day, sep = "-")) %>%
            transmute(origin, dest, date, carrier, flight, tailnum)
print(flightsToTopDest)

# factor
fls <- flights %>%
            mutate(new_var = case_when(
                dep_time > 500 & dep_time <= 1100 ~ "morning",
                dep_time > 1100 & dep_time <= 1300 ~ "noon",
                dep_time > 1300 & dep_time <= 1800 ~ "afternoon",
                dep_time > 1800 & dep_time <= 2300 ~ "evening",
                dep_time > 2300 | dep_time <= 500 ~ "night"
            )) %>%
            mutate(new_var = as.factor(new_var)) %>%
            pull(new_var) %>% # equivalent to .$new_var
            levels()
print(fls)

# handling dates
flightsDT <- flights %>%
            filter(!is.na(dep_time), !is.na(arr_time)) %>%
            mutate(
                dep_time = make_datetime(year, month, day, dep_time %/% 100, dep_time %% 100),
                arr_time = make_datetime(year, month, day, arr_time %/% 100, arr_time %% 100)
            ) %>%
            select(origin, dest, ends_with("delay"), ends_with("time"))
print(flightsDT)
