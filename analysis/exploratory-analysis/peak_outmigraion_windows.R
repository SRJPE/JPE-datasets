library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(knitr)
library(hms)
library(zoo)


# Input google cloud bucket information 
Sys.setenv("GCS_DEFAULT_BUCKET" = "jpe-dev-bucket", "GCS_AUTH_FILE" = "config.json")

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Load datasets
# gcs_get_object(object_name = "standard-format-data/standard_recapture.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_mark_recaptures.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch_lad.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch_lad.csv",
#                overwrite = TRUE)


# Glimpse RST datasets 
mark_recaps <- read_csv("data/standard-format-data/standard_mark_recaptures.csv") %>% glimpse()
rst_catch <- read_csv("data/standard-format-data/standard_rst_catch.csv") %>% glimpse()
rst_catch_lad <- read_csv("data/standard-format-data/standard_rst_catch_lad.csv") %>% glimpse()

# Create yearly count table 
yearly_counts <- rst_catch_lad %>% 
  filter(run == "spring" & stream == "battle creek") %>% 
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) %>%
  group_by(water_year) %>%
  summarise(yearly_count = sum(count)) %>%
  glimpse

# Create table for battle creek of % catch in rolling 42 day (6 week) windows  
battle_rollsum <- rst_catch_lad %>% 
  filter(run == "spring" & stream == "battle creek" & adipose_clipped != T) %>% 
  group_by(date) %>% 
  summarize(daily_count = sum(count)) %>%
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) %>% 
  left_join(yearly_counts) %>% 
  arrange(date) %>% 
  group_by(water_year) %>% 
  mutate(left_rollsum = rollsum(daily_count, 42, fill = NA, align = "left"),
         right_rollsum = rollsum(daily_count, 42, fill = NA, align = "right"), 
         left_percents = left_rollsum/yearly_count,
         right_percents = right_rollsum/yearly_count,  
         max_left = max(left_percents, na.rm = T),
         max_right = max(right_percents))

battle_date_range <- battle_rollsum %>% 




# Visualize left_percents 
rst_catch_lad %>% 
  filter(run == "spring" & stream == "battle creek") %>% 
  group_by(date) %>% 
  summarize(daily_count = sum(count)) %>%
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) %>% 
  left_join(yearly_counts) %>% 
  group_by(water_year) %>% 
  mutate(left_rollsum = rollsum(daily_count, 42, fill = NA, align = "left"),
         right_rollsum = rollsum(daily_count, 42, fill = NA, align = "right"), 
         left_percents = left_rollsum/yearly_count,
         right_percents = right_rollsum/yearly_count) %>%
  ggplot() + 
  geom_histogram(aes(x = left_percents)) + 
  facet_wrap(~water_year)
