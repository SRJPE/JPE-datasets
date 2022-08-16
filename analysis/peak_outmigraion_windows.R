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
  summarize(mean_efficiency = mean(efficiency, na.rm = T)) %>%  view

# Use global mean for those without historical estimates
efficiency_global <- left_join(number_released_flow, number_recaptured) %>% 
  mutate(efficiency = number_recaptured/number_released) %>% 
  summarize(mean_efficiency = mean(efficiency, na.rm = T)) %>% view


# Table of number of fish needed for release ------------------------------

# Calculate the number of fish needed for release based on avg efficiency and 0.2 precision

# Peak Outmigration -------------------------------------------------------

# Glimpse RST datasets 
mark_recaps <- read_csv(here::here("data", "standard-format-data", "standard_mark_recaptures.csv")) %>% glimpse()
rst_catch <- read_csv(here::here("data", "standard-format-data", "standard_catch.csv")) %>% glimpse()
rst_catch_lad <- read_csv(here::here("data", "standard-format-data", "standard_rst_catch_lad.csv")) %>% glimpse()

date_range <- function(watershed) {
# Create yearly count table 
yearly_counts <- rst_catch_lad %>%
  filter(stream == "mill creek" & run_rivermodel == "spring") %>% 
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) %>%
  group_by(water_year) %>%
  summarise(yearly_count = sum(count)) %>%
  glimpse

# Create table for battle creek of % catch in rolling 42 day (6 week) windows  
battle_rollsum <- rst_catch_lad %>% 
  filter(stream == "mill creek" & run_rivermodel == "spring" & adipose_clipped != T) %>% 
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
# 
# battle_date_range <- battle_rollsum %>% 
#   filter(left_percents == max_left | right_percents == max_right) %>% 
#   mutate(start_date = case_when(left_percents == max_left ~ as_date(date),
#                                 right_percents == max_right ~ as_date(date) - 42),
#          end_date = case_when(left_percents == max_left ~ as_date(date) + 42,
#                               right_percents == max_right ~ as_date(date)))

battle_date_range_left <- battle_rollsum %>% 
  filter(left_percents == max_left) %>% 
  group_by(water_year) %>% 
  slice_min(date) %>% 
  mutate(start_date = as_date(date),
         end_date = as_date(date) + 42) 

battle_date_range_left %>% 
  select(water_year, start_date, end_date) %>% 
  pivot_longer(c(start_date, end_date), names_to = "type", values_to = "date") %>% 
  mutate(year = ifelse(month(date) %in% 10:12, "1999", "2000"),
          date = as_date(paste(year, month(date), day(date), sep = "-"))) %>% 
  ggplot(aes(x = date, y = water_year, color = type)) +
  geom_point()
}

date_range("mill creek")


# Battle: mid Dec - beg Feb
# Butte: mid Dec - beg Feb
# Clear: mid-Nov - beg Jan
# Feather: beg Dec - mid Feb
# Yuba: mid-Nov - beg Jan
# Knights Landing: mid Feb - beg Apr
# Tisdale: mid Jan - Mar *
# Mill: mid Mar - May
# Deer: mid Mar - May

# * peak outmigration more variable
# scrap --------------------------------------------------------------------

mill_catch <- filter(rst_catch_lad, stream == "mill creek") %>% 
  



battle_average_date_range <- battle_date_range_left %>% 
  mutate(start_day = yday(start_date),
         end_day = yday(end_date)) %>% 
  ungroup() %>% 
  summarize(avg_start = mean(start_day),
            avg_end = mean(end_day)) %>%  view

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

