# Following the sample window workshop Erin Cain emailed list of stream/years
# to exclude. 
# Read in years_to_exclude.csv
# Read in catch data and find the min/max week for each stream/year
# Exclude years

library(googleCloudStorageR)
library(tidyverse)
library(lubridate)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# years_exclude <- read_csv(here::here("analysis","data","years_to_exclude.csv"))

exclude <- tibble(stream = c(rep("battle creek",3), rep("butte creek", 5), rep("deer creek", 8),
                             rep("feather river", 2), rep("mill creek", 5), "sacramento river"),
                  monitoring_year = c(2003, 2007, 2015, 
                                      2019, 2005, 1997, 2006, 1998, 
                                      1993, 1994, 1997, 1998, 2008, 1999, 2004, 2006, 
                                      2021, 2017, 
                                      1997, 1998, 1999, 2004, 2009, 
                                      2013),
                  exclude = rep("yes", 24))

gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)

daily_catch <- read_csv("data/model-data/daily_catch_unmarked.csv")

min_max_week <- daily_catch |> 
  mutate(monitoring_year = ifelse(month(date) %in% 9:12, year(date) + 1, year(date))) |> 
  group_by(monitoring_year, stream, site, subsite) |> 
  summarize(min_date = min(date),
            min_week = week(min_date),
            max_date = max(date),
            max_week = week(max_date))

include <- min_max_week |> 
  left_join(exclude) |> 
  filter(is.na(exclude)) |> 
  select(-exclude)

write_csv(include, "analysis/data/stream_week_year_include.csv")

gcs_upload(include,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/stream_week_year_include.csv",
           predefinedAcl = "bucketLevel")

