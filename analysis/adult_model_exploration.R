# Data exploration
library(googleCloudStorageR)
library(tidyverse)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Pull Data
gcs_get_object(object_name = "standard-format-data/standard_adult_passage_estimate.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_adult_passage_estimate.csv",
               overwrite = TRUE)
upstream <- read_csv("data/standard-format-data/standard_adult_passage_estimate.csv")

# Adult Holding Data
gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_holding.csv",
               overwrite = TRUE)
holding <- read_csv("data/standard-format-data/standard_holding.csv")

# Adult Redd Data
gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_annual_redd.csv",
               overwrite = TRUE)
annual_redd <- read_csv("data/standard-format-data/standard_annual_redd.csv")

gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_daily_redd.csv",
               overwrite = TRUE)
daily_redd <- read_csv("data/standard-format-data/standard_daily_redd.csv")

# Temperature
gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_temperature.csv",
               overwrite = TRUE)
temperature <- read_csv("data/standard-format-data/standard_temperature.csv")

# Exploring relationship between temperature and holding for Deer Creek
# 1. Format temperature data - for simplicity take july average (month prior to august spawn)
# 2. Set up as normal model

# There does not seem to be a relationship processing temp this way
mean_july_temperature <- temperature |> 
  filter(month(date) == 7) |> 
  mutate(year = year(date)) |> 
  group_by(stream, year) |> 
  summarize(mean_temperature = mean(mean_daily_temp_c))

annual_holding <- holding |> 
  group_by(stream, year) |> 
  summarize(count = sum(count, na.rm = T))

deer_data <- filter(mean_july_temperature, stream == "deer creek") |> 
  full_join(filter(annual_holding, stream == "deer creek")) |> 
  filter(!is.na(mean_temperature), !is.na(count))

ggplot(deer_data, aes(x = mean_temperature, y = count)) +
  geom_point()
  
# Try number of days above 18C in May and June?
above_18_may_june <- temperature |> 
  filter(month(date) %in% 5:6) |> 
  mutate(year = year(date),
         above_threshold = ifelse(mean_daily_temp_c > 18, T, F)) |> 
  group_by(year, stream) |> 
  summarize(days_above = sum(above_threshold))

deer_data <- filter(above_18_may_june, stream == "deer creek") |> 
  full_join(filter(annual_holding, stream == "deer creek")) |> 
  filter(!is.na(days_above), !is.na(count))

ggplot(deer_data, aes(x = days_above, y = count)) +
  geom_point()
