# Historical data prep for model
# RST data
# Guidance from Josh
# Table 1. Unmarked catch (5 fields)
# 
# Fields would be: Year (Yr), Julian Week (Jwk), Unmarked catch (u1), and mean size of unmarked catch (u1_sz), Effort (Eff, hours trap fished per week).
# 
# If more than one trap, sum data across traps (including effort).
# 
# Table 2. Releases and Recaptures (~ 6 fields)
# 
# Year (yr)
# Julian week marked fish were released on (Jwk)
# Number of marked fish released (r1),
# Number of recaptures of r1 within first week of release (m1)
# Number of recaptures of r1 within second week of release (m2),
# Number of recaptures of r1 within second week of release (m3),
# … probably don’t need more than this, and m2 might be sufficient.
# 
# If not too much trouble, also include mean size fields for release (r1_sz) and recaptures (e.g., m1_sz).
# 
# With a year-stream, there should not be more rows in Table 2 than Table 1. However, as many streams and weeks will not have efficiency data, I suspect the number of rows in Table 2 < rows in Table 1.
# 
# Down the road I could see an accompanying covariate table which would include the discharge and average temperature for each Jwk. Could use that data as covariates to predict efficiency. Don’t need that to start though.

library(tidyverse)
library(lubridate)
# RST - Unmarked catch ----------------------------------------------------

# year - year
# week - julian_week
# unmarked catch - count
# mean size of unmarked catch - mean_fork_length
# effort - effort
# tributary
# site


# Set up system to pull in data from google cloud --------------------------

# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
# getwd() to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# define files to pull in (in some cases there is just one catch file while others
# have sample and environmental data)
files_battle <- tibble(path = rep("rst/battle-creek/data/battle_rst_",3),
                       name = c("catch","environmental","passage_estimates"),
                       save = rep("data/rst/battle_rst_",3))
files_butte <- tibble(path = "rst/butte-creek/data/butte_rst",
                      name = c(""),
                      save = "data/rst/butte_rst")
files_clear <- tibble(path = rep("rst/clear-creek/data/clear_rst_",3),
                      name = c("catch","environmental","passage_estimates"),
                      save = rep("data/rst/clear_rst_",3))
files_deer <- tibble(path = "rst/deer-creek/data/deer_rst",
                     name = c(""),
                     save = "data/rst/deer_rst")
files_feather <- tibble(path = rep("rst/feather-river/data/feather_rst",2),
                        name = c("","_effort"),
                        save = rep("data/rst/feather_rst",2))
# files_knights <- tibble(path = rep("rst/lower-sac-river/data/knights-landing/knl_combine_",2),
#                         name = c("rst_clean","sampling_effort_clean"),
#                         save = rep("data/rst/knights_",2))
files_tisdale <- tibble(path = "rst/lower-sac-river/data/tisdale/rst_clean",
                        name = c(""),
                        save = "data/rst/tisdale_rst")
files_mill <- tibble(path = "rst/mill-creek/data/mill_rst",
                     name = c(""),
                     save = "data/rst/mill_rst")
files_yuba <- tibble(path = "rst/yuba-river/data/yuba_rst",
                     name = c(""),
                     save = "data/rst/yuba_rst")
# function to save file to disk
get_data <- function(path, name, save) {
  gcs_get_object(object_name = paste0(path, name, ".csv"),
                 bucket = gcs_get_global_bucket(),
                 saveToDisk = paste0(save, name, ".csv"),
                 overwrite = TRUE)
}
# apply function to each set of files
pmap(files_battle, get_data)
pmap(files_butte, get_data)
pmap(files_clear, get_data)
pmap(files_deer, get_data)
pmap(files_feather, get_data)
# pmap(files_knights, get_data)
pmap(files_tisdale, get_data)
pmap(files_mill, get_data)
pmap(files_yuba, get_data)

# load in data
# catch data
battle_rst <- read_csv("data/rst/battle_rst_catch.csv")
butte_rst <- read_csv("data/rst/butte_rst.csv") # contains trap data too
clear_rst <- read_csv("data/rst/clear_rst_catch.csv")
deer_rst <- read_csv("data/rst/deer_rst.csv") # contains trap data too
feather_rst <- read_csv("data/rst/feather_rst.csv")
# knights_rst <- read_csv("data/rst/knights_rst_clean.csv") # contains cpue info
tisdale_rst <- read_csv("data/rst/tisdale_rst.csv")
mill_rst <- read_csv("data/rst/mill_rst.csv") # contains trap data too
yuba_rst <- read_csv("data/rst/yuba_rst.csv")

# sampling effort and environmental
battle_environmental <- read_csv("data/rst/battle_rst_environmental.csv")
clear_environmental <- read_csv("data/rst/clear_rst_environmental.csv")
feather_effort <- read_csv("data/rst/feather_rst_effort.csv")
# knights_effort <- read_csv("data/rst/knights_sampling_effort_clean.csv")

# Knights landing data pulled from camp
knights_landing_rst <- read_rds("data/rst/knights_landing_raw_catch.rds")

# Data prep ---------------------------------------------------------------

# battle ####

# Hours fished #
# battle_environmental has trap_start_date, trap_state_time, sample_date, sample_time
battle_hours_fished <- battle_environmental %>%
  filter(!is.na(trap_start_date), !is.na(trap_start_time)) %>%
  mutate(start_datetime = ymd_hms(paste(trap_start_date, trap_start_time)),
         stop_datetime = ymd_hms(paste(sample_date, sample_time)),
         hours_fished = difftime(stop_datetime, start_datetime, units = "hours"),
         week = week(sample_date),
         year = year(sample_date))

battle_hours_fished_week_mean <- battle_hours_fished %>%
    # manual check of values, negative values and those greater than 50 are typos
    filter(hours_fished > 0, hours_fished < 50) %>%
    group_by(week, year) %>%
    summarize(mean_hours = mean(hours_fished))
  
battle_hours_fished_final <- left_join(battle_hours_fished, battle_hours_fished_week_mean) %>%
    mutate(hours_fished = case_when(hours_fished < 0 | hours_fished > 50 ~ mean_hours,
                             T ~ hours_fished)) %>%
  group_by(week, year) %>%
  summarize(hours_fished = sum(hours_fished)) %>%
  mutate(tributary = "Battle Creek")

# battle catch data #
battle_rst %>% glimpse
unique(battle_rst$run)
# notes to include
# some data may be interpolated (~1% may be interpolated)
# run filtered to spring
# no variable for marked so assume all are unmarked
battle_rst_clean <- battle_rst %>%
  filter(count > 0) %>%
  select(-c(sample_id, lifestage, dead, interpolated)) %>%
  mutate(tributary = "Battle Creek")

# butte ####
# No hours 
butte_rst %>% glimpse
unique(butte_rst$station)
unique(butte_rst$mark_code)
# I think the location is for unique locations
# TODO no run assigned or filtered to spring?

butte_rst_clean <- butte_rst %>%
  # filter out marked or adclipped fish
  filter((mark_code == "none" | is.na(mark_code)), count > 0) %>%
  select(date, station, count, fork_length) %>%
  mutate(tributary = "Butte Creek",
         run = "spring") %>%
  rename(site = station)

# clear ####
# clear_environmental has trap_start_date, trap_state_time, sample_date, sample_time
clear_hours_fished <- clear_environmental %>%
  filter(!is.na(trap_start_date), !is.na(trap_start_time)) %>%
  mutate(start_datetime = ymd_hms(paste(trap_start_date, trap_start_time)),
         stop_datetime = ymd_hms(paste(sample_date, sample_time)),
         hours_fished = difftime(stop_datetime, start_datetime, units = "hours"),
         week = week(sample_date),
         year = year(sample_date))

clear_hours_fished_week_mean <- clear_hours_fished %>%
  # manual check of values, negative values and those greater than 50 are typos
  filter(hours_fished > 0, hours_fished < 50) %>%
  group_by(week, year) %>%
  summarize(mean_hours = mean(hours_fished))

clear_hours_fished_final <- left_join(clear_hours_fished, clear_hours_fished_week_mean) %>%
  mutate(hours_fished = case_when(hours_fished < 0 | hours_fished > 50 ~ mean_hours,
                           T ~ hours_fished)) %>%
  group_by(week, year, station_code) %>%
  summarize(hours_fished = sum(hours_fished)) %>%
  rename(site = station_code) %>%
  mutate(tributary = "Clear Creek")

# catch data
clear_rst %>%glimpse
unique(clear_rst$run)
# only one with missing run designation
filter(clear_rst, is.na(run)) %>% tally()
# notes to include
# some data may be interpolated (less than 1% may be interpolated)
# run filtered to spring
# no variable for mark code so assume all unmarked
unique(clear_rst$station_code)
# locations are unique locations

clear_rst_clean <- clear_rst %>%
  filter(count > 0) %>%
  select(-c(sample_id, lifestage, dead, interpolated)) %>%
  mutate(tributary = "Clear Creek") %>%
  rename(site = station_code)

# deer #####
# TODO no run assigned or filtered to spring?
# notes to include
# no variable for mark code so assume all unmarked
# locations are different names for trap at same location
deer_rst %>% glimpse
unique(deer_rst$location)

deer_rst_clean <- deer_rst %>%
  filter(count > 0) %>%
  select(date, location, count, fork_length) %>%
  group_by(date, fork_length) %>%
  summarize(count = sum(count, na.rm = T)) %>%
  mutate(tributary = "Deer Creek",
         run = NA_character_)

# feather ####
feather_rst %>% glimpse
unique(feather_rst$run)
# 127 out of 180871 where run is not designated
# data are for all natural salmon
filter(feather_rst, is.na(run)) %>% tally()
# notes - sites are unique locations

feather_rst_clean <- feather_rst %>%
  filter(count > 0) %>%
  select(date, site_name, fork_length, count, run) %>%
  mutate(tributary = "Feather River") %>%
  rename(site = site_name)

# knights ####
# knights hours fished #
knights_hours_fished <- knights_landing_rst %>%
  distinct(visitTime, visitTime2) %>%
  arrange(visitTime) %>%
  mutate(end_date = lead(visitTime)) %>%
  rename(start_date = visitTime) %>%
  select(-visitTime2) %>%
  mutate(hours_fished = difftime(end_date, start_date, units = "hours"),
         week = week(start_date),
         year = year(start_date))

knights_hours_fished_week_mean <- knights_hours_fished %>%
  # manual check of values, negative values and those greater than 50 are typos
  filter(hours_fished > 0, hours_fished < 100) %>%
  group_by(week, year) %>%
  summarize(mean_hours = mean(hours_fished))

knights_hours_fished_final <- left_join(knights_hours_fished, knights_hours_fished_week_mean) %>%
  mutate(hours_fished = case_when(hours_fished < 0 | hours_fished > 50 ~ mean_hours,
                                  T ~ hours_fished)) %>%
  group_by(week, year) %>%
  summarize(hours_fished = sum(hours_fished, na.rm = T)) %>%
  mutate(tributary = "Lower Sacramento - Knights Landing")

# knights catch #
unique(knights_landing_rst$commonName)
unique(knights_landing_rst$fishOrigin)
unique(knights_landing_rst$run)

knights_rst_clean <- knights_landing_rst %>%
  filter(commonName == "Chinook salmon", fishOrigin == "Natural", n > 0) %>%
  select(forkLength, n, run, visitTime) %>%
  rename(count = n,
         date = visitTime,
         fork_length = forkLength) %>%
  mutate(tributary = "Lower Sacramento - Knights Landing",
         run = case_when(run == "Not recorded" ~ NA_character_,
                         run == "Not applicable (n/a)" ~ NA_character_,
                         T ~ tolower(run)),
         date = as_date(date))

# tisdale ####
# Note that tisdale was aggregated to sum together traps from left and right
tisdale_rst %>% glimpse
# 15 obs where run is not recorded, 9 where run is NA
unique(tisdale_rst$run)
unique(tisdale_rst$species)
unique(tisdale_rst$rearing)
unique(tisdale_rst$mark_type)
# date, trap_position, fork_length_mm, life_stage, species, run, mortality, rearing, count
# TODO lifestage encodings
# button-up fry = fry, yolk sac fry (alvein) = yolk sac fry, not recorded = NA

tisdale_rst_clean <- tisdale_rst %>%
  filter(rearing == "Natural", mark_type == "None", count > 0) %>%
  select(date, trap_position, fork_length_mm, count, run) %>%
  rename(fork_length = fork_length_mm) %>%
  group_by(date, fork_length, run) %>%
  summarize(count = sum(count, na.rm = T)) %>%
  mutate(tributary = "Lower Sacramento - Tisdale",
         run = case_when(run == "Not recorded" ~ NA_character_,
                         T ~ tolower(run)))

# mill ####
# TODO no run assigned or filtered to spring?
mill_rst %>% glimpse
unique(mill_rst$location)

mill_rst_clean <- mill_rst %>%
  filter(count > 0) %>%
  select(date, count, fork_length) %>%
  mutate(tributary = "Mill Creek",
         run = NA_character_)

# yuba ####
yuba_rst %>% glimpse
unique(yuba_rst$location)
unique(yuba_rst$run)
ck <- filter(yuba_rst, is.na(run), !is.na(count), count > 0)
# all are CHN
unique(yuba_rst$organism_code)
# note that run designation is a combination of run and lifestage.
# filtered to spring but if necessary could leave all in
# sites are names for traps at the same location and should be summed

yuba_rst_clean<- yuba_rst %>%
  filter(count > 0) %>%
  select(date, fork_length, count, location, run) %>%
  group_by(date, fork_length, run) %>%
  summarize(count = sum(count, na.rm = T)) %>%
  mutate(tributary = "Yuba River",
         run = case_when(run == "unknown" ~ NA_character_,
                         T ~ tolower(run)))

# catch combined ####
combined_rst <- bind_rows(battle_rst_clean,
                          butte_rst_clean,
                          clear_rst_clean,
                          deer_rst_clean,
                          feather_rst_clean,
                          knights_rst_clean,
                          tisdale_rst_clean,
                          mill_rst_clean,
                          yuba_rst_clean)

combined_hours_fished <- bind_rows(battle_hours_fished_final,
                                   clear_hours_fished_final,
                                   knights_hours_fished_final)
# format data -------------------------------------------------------------
# TODO make sure the week is the right format
combined_rst_format <- combined_rst %>%
  mutate(week = week(date),
         year = year(date)) %>%
  group_by(week, year, tributary, site, run) %>%
  summarize(count = sum(count),
            mean_fork_length = mean(fork_length)) %>%
  left_join(combined_hours_fished) %>%
  mutate(hours_fished = as.numeric(hours_fished))


# Notes about dataset
# Filtered to spring run (run is determined by length at date though may differ by trib; yuba has a lifestage and run joint variable)
# If locations had multiple traps, counts were summed
# Some tribs have multiple sites, the max count per day was taken

# saveRDS(combined_rst, "data/rst/combined_rst.rds")


# Hours trap fished -------------------------------------------------------

# hours of start datetime to end datetime, group by week and sum
# filter by trap fishing?
# if no start and end datetime?

# butte #
# do not have start/end or time

# deer #
# do not have start/end or time

# tisdale #
# do not have start/end or time

# mill #
# do not have start/end or time

# yuba #
# we have date and time but no start/stop
