if (!require("pacman")) install.packages("pacman", repos = "http://cran.us.r-project.org")
library("pacman")
pacman::p_load(dplyr, tidyr, readr, stringr, tidyverse, readxl, stringi, tibble, ggplot2)

# clear screen
cat("\014")
cat("\n\n\n\n\n\n\n\n\n\n\n\n")

# config
options(tibble.width = Inf)
options(tibble.print_max = Inf)

# ------------------------------------------------------------------------------------------------------------

get_path <- function(filename) {
  return(file.path(getwd(), "exercise-2", "data", filename))
}

youth_unemp <- read_csv(
  get_path("rawdata_373.csv"),
  col_types = cols(
    country_name = col_character(),
    youth_unempl_rate = col_double(),
  )
)

net_migr <- read_file(get_path("rawdata_347.txt")) %>%
  str_split("\n") %>%
  unlist() %>%
  .[-c(1:2, length(.))] %>%
  str_trim() %>%
  substr(., 9, nchar(.) - 17) %>%
  str_match_all("^(.+?)\\s+(-?\\d+\\.\\d+)$") %>%
  map_df(~ tibble(
    country_name = .x[, 2],
    net_migration_rate = as.numeric(.x[, 3])
  ))

med_age <- read_file(get_path("rawdata_343.txt")) %>%
  str_split("\n") %>%
  unlist() %>%
  .[-c(1:2, length(.))] %>%
  str_trim() %>%
  substr(., 9, 78) %>%
  str_match_all("^(.+?)\\s+(-?\\d+\\.\\d+)$") %>%
  map_df(~ tibble(
    country_name = .x[, 2],
    median_age = as.numeric(.x[, 3])
  ))

# assert that keys are unique
stopifnot(!any(duplicated(youth_unemp$country_name)))
stopifnot(!any(duplicated(net_migr$country_name)))
stopifnot(!any(duplicated(med_age$country_name)))

# lowercase
youth_unemp$country_name <- sapply(youth_unemp$country_name, tolower)
net_migr$country_name <- sapply(net_migr$country_name, tolower)
med_age$country_name <- sapply(med_age$country_name, tolower)

# compare levenshtein distances between keys
print_conflicts <- function(keys) {
  cat("potential conflicts:\n")
  distances <- adist(keys, keys)
  rownames(distances) <- keys
  colnames(distances) <- keys
  for (i in 1:nrow(distances)) {
    for (j in 1:ncol(distances)) {
      if (i != j & distances[i, j] < 2) {
        cat("\t", keys[i], "-", keys[j], "->", distances[i, j], "\n")
      }
    }
  }
}

# ------------------------------------------------------------------------------------------------------------

df_vars <- full_join(youth_unemp, net_migr, by = "country_name") %>%
  full_join(med_age, by = "country_name")

stopifnot(!any(is.na(df_vars$country_name)))

# ------------------------------------------------------------------------------------------------------------

gni_income <- bind_cols(
  read_excel(
    get_path("OGHIST.xlsx"),
    sheet = "Country Analytical History",
    range = "A12:A229",
  ) %>% set_names("country_code"),

  read_excel(
    get_path("OGHIST.xlsx"),
    sheet = "Country Analytical History",
    range = "B12:B229",
  ) %>% set_names("country_name"),

  read_excel(
    get_path("OGHIST.xlsx"),
    sheet = "Country Analytical History",
    range = "AJ12:AJ229",
  ) %>% set_names("gni")
)

# lowercase
gni_income$country_name <- sapply(gni_income$country_name, tolower)
gni_income$country_code <- sapply(gni_income$country_code, tolower)

# fix conflicts
gni_income$country_name <- gsub("ô", "o", gni_income$country_name)
gni_income$country_name <- gsub("ç", "c", gni_income$country_name)
gni_income$country_name <- gsub("faeroe islands", "faroe islands", gni_income$country_name)

# ------------------------------------------------------------------------------------------------------------

mapping <- read_csv(get_path("GENC.csv"), show_col_types = FALSE) %>%
  select(1, 2) %>%
  rename(
    country_name = `Name`,
    country_code = `GENC`
  ) %>%
  mutate(country_name = tolower(country_name)) %>%
  mutate(country_code = tolower(country_code)) %>%
  filter(country_code != "-") %>%
  mutate(country_name = gsub("north macedonia", "macedonia", country_name)) %>%
  mutate(country_name = gsub("turkey \\(turkiye\\)", "turkey", country_name))

# assert that mapping keys are unique
stopifnot(!any(duplicated(mapping$country_name)))
stopifnot(!any(duplicated(mapping$country_code)))

# use mapping: add df_vars$country_code
df_vars <- full_join(df_vars, mapping, by = "country_name")
stopifnot(!any(is.na(df_vars$country_code)))

# use df_vars$country_code: add gni_income$gni
tmp <- gni_income %>% select(-country_name)
df_vars <- full_join(df_vars, tmp, by = "country_code")

# ------------------------------------------------------------------------------------------------------------

iso_mapping <- read_csv(get_path("iso.csv"), show_col_types = FALSE) %>%
  select(3, 6, 7, 8) %>%
  rename(
    country_code = `alpha-3`,
  ) %>%
  mutate(country_code = tolower(country_code))
df_vars <- left_join(df_vars, iso_mapping, by = "country_code")

geoloc <- read_csv(get_path("geoloc.csv"), show_col_types = FALSE) %>%
  select(3, 5, 6) %>%
  rename(
    country_code = `Alpha-3 code`,
    latitude = `Latitude (average)`,
    longitude = `Longitude (average)`,
  ) %>%
  mutate(country_code = tolower(country_code))
df_vars <- left_join(df_vars, geoloc, by = "country_code")

df_vars <- df_vars %>% rename(sub_region = `sub-region`)
df_vars <- df_vars %>% rename(intermediate_region = `intermediate-region`)

# ------------------------------------------------------------------------------------------------------------

# remove rows with 3/3 missing vars
vars <- c("youth_unempl_rate", "net_migration_rate", "median_age", "gni")
# cat("rows missing 3/3 vars:", sum(rowSums(is.na(df_vars[, vars])) == 3), "\n")
# cat("rows missing 2/3 vars:", sum(rowSums(is.na(df_vars[, vars])) == 2), "\n")
# cat("rows missing 1/3 vars:", sum(rowSums(is.na(df_vars[, vars])) == 1), "\n")

count_before <- nrow(df_vars)
df_vars <- df_vars %>% filter(rowSums(is.na(df_vars[, vars])) < 3)
count_after <- nrow(df_vars)

# ------------------------------------------------------------------------------------------------------------

youth_unempl_freq <- df_vars %>% count(youth_unempl_rate, sort = TRUE) %>%
  rename(freq = n) %>%
  mutate(freq = freq / count_after) %>%
  arrange(desc(freq))
print(head(youth_unempl_freq))

net_migr_freq <- df_vars %>% count(net_migration_rate, sort = TRUE) %>%
  rename(freq = n) %>%
  mutate(freq = freq / count_after) %>%
  arrange(desc(freq))
print(head(net_migr_freq))

med_age_freq <- df_vars %>% count(median_age, sort = TRUE) %>%
  rename(freq = n) %>%
  mutate(freq = freq / count_after) %>%
  arrange(desc(freq))
print(head(med_age_freq))

gni_freq <- df_vars %>% count(gni, sort = TRUE) %>%
  rename(freq = n) %>%
  mutate(freq = freq / count_after) %>%
  arrange(desc(freq))
print(head(gni_freq))

# show plot
data(iris)
ggplot(iris, aes(x=Sepal.Length, y=Petal.Length))+geom_point()
