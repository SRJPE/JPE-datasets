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

# analysis for red bluff

gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
               overwrite = TRUE)
catch <- read_csv("data/standard-format-data/standard_rst_catch.csv") %>% glimpse()

rb <- filter(catch, site == "red bluff diversion dam")

rb |> 
  group_by(date) |> 
  summarize(count = sum(count, na.rm = T)) |> 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date)),
         fake_date = ifelse(month(date) %in% 10:12, ymd(paste0("1999-",month(date), "-", day(date))), 
                            ymd(paste0("2000-",month(date), "-", day(date))))) |> 
  filter(wy == 2023) |> 
  ggplot(aes(x = fake_date, y = count)) +
    geom_point()

# 1996, 1998, 2001, 2002, 2004, 2006, 2017, 2019, 2020

# 1996 - most of february is missing
# 1998 - all of february is missing
# 2001 - no data collection
# 2002 - data collection started in april
# 2004 - missing second half of february
# 2006 - missing first two weeks of march
# 2017 - missing a lot of winter months
# 2019 - missing first two weeks of march
# 2020 - no data collection after march


ck <- rb |> 
  group_by(date) |> 
  summarize(count = sum(count, na.rm = T)) |> 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  filter(wy == 2020)
  
exclude <- tibble(stream = c(rep("battle creek",3), rep("butte creek", 5), rep("deer creek", 8),
                             rep("feather river", 2), rep("mill creek", 5), "sacramento river"),
                  monitoring_year = c(2003, 2007, 2015, 
                                      2019, 2005, 1997, 2006, 1998, 
                                      1993, 1994, 1997, 1998, 2008, 1999, 2004, 2006, 
                                      2021, 2017, 
                                      1997, 1998, 1999, 2004, 2009, 
                                      2013),
                  exclude = rep("yes", 24))

gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_catch.csv",
               overwrite = TRUE)

daily_catch <- read_csv("data/standard-format-data/standard_catch.csv")


min_max_week <- daily_catch |> 
  mutate(monitoring_year = ifelse(month(date) %in% 9:12, year(date) + 1, year(date))) |> 
  group_by(monitoring_year, stream, site, subsite) |> 
  summarize(min_date = min(date),
            min_week = week(min_date),
            max_date = max(date),
            max_week = week(max_date))

include <- min_max_week |> 
  left_join(exclude) |> 
  mutate(exclude = ifelse(site == "red bluff diversion dam" & monitoring_year %in% c(1996, 1998,
                                                                                     2001, 2002,
                                                                                     2004, 2006,
                                                                                     2017, 2018,
                                                                                     2020),
                          "yes", exclude)) |> 
  filter(is.na(exclude)) |> 
  select(-exclude)

write_csv(include, "analysis/data/stream_week_year_include.csv")

gcs_upload(include,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/stream_week_year_include.csv",
           predefinedAcl = "bucketLevel")

