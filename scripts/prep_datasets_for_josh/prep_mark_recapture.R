library(tidyverse)
library(lubridate)
library(googleCloudStorageR)

# script to prep data for eda 
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))

# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# rst pull battle and clear data from google cloud 
battle_mark_recapture <- gcs_get_object(object_name = "rst/battle-creek/data/battle_mark_reacpture.csv",
                                        bucket = gcs_get_global_bucket(),
                                        saveToDisk = "data/rst/battle_mark_recapture.csv",
                                        overwrite = TRUE)
clear_mark_recapture <- gcs_get_object(object_name = "rst/clear-creek/data/clear_mark_reacpture.csv",
                                       bucket = gcs_get_global_bucket(),
                                       saveToDisk = "data/rst/clear_mark_recapture.csv",
                                       overwrite = TRUE)

battle_mark_recap <- read_csv("data/rst/battle_mark_recapture.csv") %>% 
  rename(number_recaptured = recaps, number_released = no_released) %>% 
  mutate(watershed = "Battle Creek") %>% glimpse

clear_mark_recap <- read_csv("data/rst/clear_mark_recapture.csv")  %>% 
  rename(number_recaptured = recaps, number_released = no_released) %>% 
  mutate(watershed = "Clear Creek") %>% glimpse

# Pull feather and knights landing data from package 
feather_mark_recapture <- read_rds("data/rst/feather_mark_recapture_data.rds") %>% 
  rename(number_released = nReleased) %>% 
  mutate(watershed = "Feather River") %>%
  glimpse

knights_landing_mark_recapture <- read_rds("data/rst/knights_landing_mark_recapture_data.rds") %>% 
  mutate(watershed = "Knights Landing") %>%
  rename(number_released = nReleased) %>% glimpse

# Combine feather and knights landing and add catch week for recaptures 
# TODO does the site matter? Email Mike to see if they record traps for recaptures 
# TODO check to see if I can find feather and knights landing mark recapture 

feather_and_knights  <- bind_rows(feather_mark_recapture, knights_landing_mark_recapture) %>%
   mutate(days_btw_release_and_catch = as_date(recaptured_date) - as_date(release_date), 
          caught_week_1 = ifelse(days_btw_release_and_catch >= 0 & days_btw_release_and_catch <= 7, number_recaptured, 0),
          caught_week_2 = ifelse(days_btw_release_and_catch > 7 & days_btw_release_and_catch <= 14, number_recaptured, 0),
          caught_week_3 = ifelse(days_btw_release_and_catch > 14 & days_btw_release_and_catch <= 21, number_recaptured, 0)) %>% 
  group_by(watershed, release_date, number_released) %>%
  summarise(caught_week_1 = sum(caught_week_1, na.rm = T),
            caught_week_2 = sum(caught_week_2, na.rm = T), 
            caught_week_3 = sum(caught_week_3, na.rm = T)) %>%
  ungroup() %>%
  glimpse

# Combine battle and clear 
battle_clear <- bind_rows(battle_mark_recap, clear_mark_recap) %>%
  mutate(caught_week_1 = number_recaptured) %>% glimpse

# COmbine battle, clear, feather, and knights 
combined_mark_recapture <- bind_rows(battle_clear, feather_and_knights) %>% glimpse

# Description from Josh of what he was looking for 
# Table 2. Releases and Recaptures (~ 6 fields)
# 
# Year (yr)
# Julian week marked fish were released on (Jwk)
# Number of marked fish released (r1),
# Number of recaptures of r1 within first week of release (m1)
# Number of recaptures of r1 within second week of release (m2),
# Number of recaptures of r1 within third week of release (m3),
# … probably don’t need more than this, and m2 might be sufficient.
mark_recapture_data <- combined_mark_recapture %>% 
  select(watershed, release_date, number_released, number_recaptured, 
         caught_week_1, caught_week_2, caught_week_3, 
         median_fl_released = mark_med_fork_length_mm, 
         median_fl_recaptured = recap_med_fork_length_mm) %>% 
  mutate(year = year(release_date), 
         julian_week = week(release_date),
         release_date = as_date(release_date)) %>% 
  select(watershed, release_date, year, julian_week, number_released, 
         caught_week_1, caught_week_2, caught_week_3, median_fl_released, 
         median_fl_recaptured) %>%
  glimpse() 

# Rename and reformat for Josh
# Summarize by week 
weekly_releases_and_recaptures <- mark_recapture_data %>% 
  select(-release_date) %>%
  rename(tributary = watershed, yr = year, Jwl = julian_week, 
         r1 = number_released, m1 = caught_week_1, 
         m2 = caught_week_2, m3 = caught_week_3) %>% 
  group_by(tributary, yr, Jwl) %>%
  summarize(r1 = sum(r1, na.rm = T),
            m1 = sum(m1, na.rm = T), 
            m2 = sum(m2, na.rm = T),
            m3 = sum(m3, na.rm = T),
            released_fl = mean(median_fl_released, na.rm = T),
            recaptured_fl = mean(median_fl_recaptured, na.rm = T)) %>%
  mutate(m2 = ifelse(tributary %in% c("Battle Creek", "Clear Creek"), NA, m2), # Replace 0 that were created in summarize statement with NA
         m3 = ifelse(tributary %in% c("Battle Creek", "Clear Creek"), NA, m3),
         released_fl = ifelse(tributary %in% c("Feather River", "Knights Landing"), NA, released_fl),
         recaptured_fl = ifelse(tributary %in% c("Feather River", "Knights Landing"), NA, recaptured_fl)) %>% 
  filter(tributary == "Knights Landing") %>%
  glimpse

# Rename and reformat for Josh
# Do not summarize by week 
releases_and_recaptures <- mark_recapture_data %>% 
  select(-release_date) %>%
  rename(tributary = watershed, yr = year, Jwl = julian_week, 
         r1 = number_released, m1 = caught_week_1, 
         m2 = caught_week_2, m3 = caught_week_3) %>% 
  glimpse


# weekly summary csv
write_csv(weekly_releases_and_recaptures, "data/datasets_for_josh/jpe_weekly_releases_and_recaptures.csv")

# row for each efficiency trial 
write_csv(releases_and_recaptures, "data/datasets_for_josh/jpe_releases_and_recaptures.csv")


# Visualize 
releases_and_recaptures %>% 
  mutate(week_1_efficiency = m1/r1) %>%
  ggplot(aes(x = week_1_efficiency, color = tributary)) + 
  geom_density()

releases_and_recaptures %>% 
  group_by(yr, tributary) %>% 
  summarise(trials_per_year = n()) %>% 
  ggplot(aes(x = as.character(yr), y = trials_per_year, fill = tributary)) + 
  geom_col(position = 'dodge')

releases_and_recaptures %>% 
  mutate(week_1_efficiency = m1/r1) %>%
  ggplot(aes(x = Jwl, y = yr, size = week_1_efficiency)) +
  geom_point()

