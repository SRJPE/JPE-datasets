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

release_raw <- read_csv(here::here("data","standard-format-data", "standard_release.csv"))
recapture_raw <- read_csv(here::here("data","standard-format-data", "standard_recapture.csv"))

# Average efficiency ------------------------------------------------------

number_released_flow <- release_raw %>% 
  select(stream, site, release_id, release_date, number_released, flow_at_release)

number_recaptured <- recapture_raw %>% 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured)) %>% 
  group_by(stream, release_id) %>% 
  summarize(number_recaptured = sum(number_recaptured))

# Use average efficiency by stream for those with historical estimates
efficiency_stream <- left_join(number_released_flow, number_recaptured) %>% 
  mutate(efficiency = number_recaptured/number_released) %>% 
  group_by(stream) %>% 
  summarize(mean_efficiency = mean(efficiency, na.rm = T))

# Use global mean for those without historical estimates
efficiency_global <- left_join(number_released_flow, number_recaptured) %>% 
  mutate(efficiency = number_recaptured/number_released) %>% 
  summarize(mean_efficiency = mean(efficiency, na.rm = T))


# Peak Outmigration -------------------------------------------------------


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
         max_right = max(right_percents, na.rm = T))

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
