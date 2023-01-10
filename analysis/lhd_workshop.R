# This script prepares the data and plots that will be used for the LHD ruleset workshop
# for determining cutoffs for yearlings.

# pull in the most recent model data
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)
daily_catch_unmarked <- read_csv("data/model-data/daily_catch_unmarked.csv")

# dotplots for length and date for each stream and year and one with all years
# we will put these in a shiny app because will be easier to navigate the many
# plots

# butte 
butte_catch <- filter(daily_catch_unmarked, stream == "butte creek") |> 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date)))
# butte - 2019
# need to set the x-axis to start in november
filter(butte_catch, wy == 2019) |> 
  ggplot(aes(x = date, y = fork_length)) +
  geom_point() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  labs(y = "fork length (mm)",
       x = "")
