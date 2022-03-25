library(dplyr)
library(tidyverse)
library(googleCloudStorageR)
library(hms)

# script to prep data for eda #

# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
# getwd() to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


# lifestage encoding ------------------------------------------------------
# This is currently not being used but is here for quick reference and later use
encoding_fn <- function(dat) {
  dat %>%
    mutate(lifestage = case_when(lifestage %in% c("yolk-sac fry", "yolk sac fry (alevin)") ~ "yolk sac fry",
                                 lifestage == "fingerling" ~ "silvery parr",
                                 lifestage %in% c("unknown", "not recorded", "not provided", "yoy (young of the year)") ~ NA_character_,
                                 lifestage == "pre-smolt" ~ "parr",
                                 lifestage == "button-up fry" ~ "fry",
                                 T ~ NA_character_))
}

# rst data pull ####
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
files_knights <- tibble(path = rep("rst/lower-sac-river/data/knights-landing/knl_combine_",2),
                        name = c("rst_clean","sampling_effort_clean"),
                        save = rep("data/rst/knights_",2))
files_tisdale <- tibble(path = "rst/lower-sac-river/data/tisdale/rst_clean",
                     name = c(""),
                     save = "data/rst/tisdale_rst")
files_mill <- tibble(path = "rst/mill-creek/data/mill_rst",
                        name = c(""),
                        save = "data/rst/mill_rst")
files_yuba <- tibble(path = "rst/yuba-river/data/yuba_rst",
                     name = c(""),
                     save = "data/rst/yuba_rst")
get_data <- function(path, name, save) {
  gcs_get_object(object_name = paste0(path, name, ".csv"),
                 bucket = gcs_get_global_bucket(),
                 saveToDisk = paste0(save, name, ".csv"),
                 overwrite = TRUE)
}
# redd carcass holding ####

files_battle <- tibble(path = rep("adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_",3),
                       name = c("carcass","holding","redd"),
                       save = rep("data/redd_carcass_holding/battle_",3))
files_butte <- tibble(path = rep("adult-holding-redd-and-carcass-surveys/butte-creek/data/butte_",20),
                       name = c("carcass_2014-2016","carcass_2017-2020","carcass_chops", "holding_2001",
                                "holding_2002", "holding_2003", "holding_2004", "holding_2005", "holding_2006",
                                "holding_2007", "holding_2008", "holding_2009", "holding_2010", "holding_2011",
                                "holding_2012", "holding_2013", "holding_2014", "holding_2015", "holding_2016",
                                "holding_2017"),
                       save = rep("data/redd_carcass_holding/butte_",20))
files_clear <- tibble(path = rep("adult-holding-redd-and-carcass-surveys/clear-creek/data/clear_",3),
                       name = c("carcass","holding","redd"),
                       save = rep("data/redd_carcass_holding/clear_",3))
files_deer <- tibble(path = rep("adult-holding-redd-and-carcass-surveys/deer-creek/data/deer_adult_holding_",2),
                       name = c("1997_to_2020","1986_to_1996"),
                       save = rep("data/redd_carcass_holding/deer_",2))




pmap(files_battle, get_data)
pmap(files_butte, get_data)
pmap(files_clear, get_data)
pmap(files_deer, get_data)

pmap(files_feather, get_data)
pmap(files_knights, get_data)
pmap(files_tisdale, get_data)
pmap(files_mill, get_data)
pmap(files_yuba, get_data)


# load in data ####

# catch data
battle_rst <- read_csv("data/rst/battle_rst_catch.csv")
butte_rst <- read_csv("data/rst/butte_rst.csv") # contains trap data too
clear_rst <- read_csv("data/rst/clear_rst_catch.csv")
deer_rst <- read_csv("data/rst/deer_rst.csv") # contains trap data too
feather_rst <- read_csv("data/rst/feather_rst.csv")
knights_rst <- read_csv("data/rst/knights_rst_clean.csv") # contains cpue info
tisdale_rst <- read_csv("data/rst/tisdale_rst.csv")
mill_rst <- read_csv("data/rst/mill_rst.csv") # contains trap data too
yuba_rst <- read_csv("data/rst/yuba_rst.csv")

# sampling effort and environmental
battle_environmental <- read_csv("data/rst/battle_rst_environmental.csv")
clear_environmental <- read_csv("data/rst/clear_rst_environmental.csv")
feather_effort <- read_csv("data/rst/feather_rst_effort.csv")
knights_effort <- read_csv("data/rst/knights_sampling_effort_clean.csv")

# passage estimates
battle_passage <- read_csv("data/rst/battle_rst_passage_estimates.csv")

# TODO filter out interpolated?

# carcass holding
battle_carcass <- read_csv("data/redd_carcass_holding/battle_carcass.csv")
battle_holding <- read_csv("data/redd_carcass_holding/battle_holding.csv")
butte_carcass_2014_2016 <- read_csv(("data/redd_carcass_holding/butte_carcass_2014-2016.csv"))
butte_carcass_2017_2020 <- read_csv(("data/redd_carcass_holding/butte_carcass_2017-2020.csv"))
butte_carcass_chops <- read_csv(("data/redd_carcass_holding/butte_carcass_chops.csv"))
butte_holding_01 <- read_csv("data/redd_carcass_holding/butte_holding_2001.csv")
butte_holding_02 <- read_csv("data/redd_carcass_holding/butte_holding_2002.csv")
butte_holding_03 <- read_csv("data/redd_carcass_holding/butte_holding_2003.csv")
butte_holding_04 <- read_csv("data/redd_carcass_holding/butte_holding_2004.csv")
butte_holding_05 <- read_csv("data/redd_carcass_holding/butte_holding_2005.csv")
butte_holding_06 <- read_csv("data/redd_carcass_holding/butte_holding_2006.csv")
butte_holding_07 <- read_csv("data/redd_carcass_holding/butte_holding_2007.csv")
butte_holding_08 <- read_csv("data/redd_carcass_holding/butte_holding_2008.csv")
butte_holding_09 <- read_csv("data/redd_carcass_holding/butte_holding_2009.csv")
butte_holding_10 <- read_csv("data/redd_carcass_holding/butte_holding_2010.csv")
butte_holding_11 <- read_csv("data/redd_carcass_holding/butte_holding_2011.csv")
butte_holding_12 <- read_csv("data/redd_carcass_holding/butte_holding_2012.csv")
butte_holding_13 <- read_csv("data/redd_carcass_holding/butte_holding_2013.csv")
butte_holding_14 <- read_csv("data/redd_carcass_holding/butte_holding_2014.csv")
butte_holding_15 <- read_csv("data/redd_carcass_holding/butte_holding_2015.csv")
butte_holding_16 <- read_csv("data/redd_carcass_holding/butte_holding_2016.csv")
butte_holding_17 <- read_csv("data/redd_carcass_holding/butte_holding_2017.csv")
clear_carcass <- read_csv("data/redd_carcass_holding/clear_carcass.csv")
clear_holding <- read_csv("data/redd_carcass_holding/clear_holding.csv")
deer_holding_1997_2020 <- read_csv("data/redd_carcass_holding/deer_1997_to_2020.csv")
deer_holding_1986_1996 <- read_csv("data/redd_carcass_holding/deer_1986_to_1996.csv")

# minor cleaning by watershed #####
# battle ####
battle_rst %>% glimpse
unique(battle_rst$lifestage)
filter(battle_rst, interpolated == T)
unique(battle_rst$run)
# spring, late fall, fall, winter
# date, run, fork_length, lifestage, count, dead, interpolated

battle_rst_clean <- battle_rst %>%
  select(-sample_id) %>%
  mutate(watershed = "Battle Creek",
         site = "Battle Creek",
         species = "chinook",
         lifestage = ifelse(lifestage == "yolk-sac fry", "yolk sac fry", lifestage)) 
  
# butte ####
butte_rst %>% glimpse
unique(butte_rst$station)
unique(butte_rst$lifestage)
# TODO no run assigned or filtered to spring?
# date, time, add run column, fork_length, lifestage, dead, count, station
# lifestage encoding
# fingerling to silvery parr; unknown to NA

butte_rst_clean <- butte_rst %>%
  select(date, station, dead, count, fork_length, lifestage, time) %>%
  mutate(watershed = "Butte Creek",
         species = "chinook",
         lifestage = case_when(lifestage == "fingerling" ~ "silvery parr",
                               lifestage == "unknown" ~ NA_character_,
                               T ~  lifestage)) %>%
  rename(site = station)

# clear ####
clear_rst %>%glimpse
unique(clear_rst$station_code)
filter(clear_rst, station_code == "UCC")
unique(clear_rst$lifestage)
unique(clear_rst$run)
# spring, late fall, fall, winter
# date, station_code, run, fork_length, lifestage, count , dead, interpolated

clear_rst_clean <- clear_rst %>%
  select(-sample_id) %>%
  mutate(watershed = "Clear Creek",
         species = "chinook",
         lifestage = ifelse(lifestage == "yolk-sac fry", "yolk sac fry", lifestage)) %>%
  rename(site = station_code) %>% glimpse

# deer #####
# TODO no run assigned or filtered to spring?
deer_rst %>% glimpse
unique(deer_rst$location)
deer_rst %>%
  group_by(date) %>%
  distinct(location)
# date, location, add run column, fork_length, count

deer_rst_clean <- deer_rst %>%
  select(date, location, count, fork_length, count) %>%
  mutate(watershed = "Deer Creek") %>%
  rename(site = location)

# feather ####
feather_rst %>% glimpse
unique(feather_rst$run)
unique(feather_rst$lifestage)
# date, site_name, run, lifestage, fork_length, count
# lifestage encoding
# pre-smolt = parr, yolk sac fry (alevin) = yolk sac fry

feather_rst_clean <- feather_rst %>%
  mutate(watershed = "Feather River",
         lifestage = case_when(lifestage == "yolk sac fry (alevin)" ~ "yolk sac fry",
                               lifestage == "yoy (young of the year)" ~ NA_character_,
                               lifestage == "pre-smolt" ~ "parr",
                               T ~ lifestage)) %>%
  rename(site = site_name)

filter(feather_rst, lifestage == "pre-smolt")
# knights ####
knights_rst %>% glimpse
unique(knights_rst$at_capture_run)
unique(knights_rst$lifestage)
unique(knights_rst$marked)
# date, fork_length_max_mm, fork_length_min_mm, species, count, at_capture_run, lifestage, marked
# lifestage encoding
# older juvenile = juvenile

knights_rst_clean <- filter(knights_rst, !is.na(count)) %>%
  select(date, fork_length_max_mm, fork_length_min_mm, species, count, at_capture_run, lifestage, marked) %>%
  rename(run = at_capture_run,
         rearing = marked) %>%
  mutate(watershed = "Lower Sac",
         site = "Knights Landing",
         run = tolower(run),
         species = tolower(species),
         rearing = case_when(rearing == T ~ "hatchery",
                             rearing == F ~ "natural"),
         lifestage = ifelse(lifestage == "older juvenile", NA_character_, lifestage)) %>% glimpse

# tisdale ####
# Note that tisdale was aggregated to sum together traps from left and right
tisdale_rst %>% glimpse
unique(tisdale_rst$run)
unique(tisdale_rst$species)
unique(tisdale_rst$rearing)
unique(tisdale_rst$life_stage)
filter(tisdale_rst, is.na(trap_position))
# date, trap_position, fork_length_mm, life_stage, species, run, mortality, rearing, count
# TODO lifestage encodings
# button-up fry = fry, yolk sac fry (alvein) = yolk sac fry, not recorded = NA

tisdale_rst_clean <- tisdale_rst %>%
  select(date, trap_position, species, fork_length_mm, life_stage, run, mortality, rearing, count) %>%
  rename(fork_length = fork_length_mm,
         lifestage = life_stage,
         dead = mortality) %>%
  mutate(watershed = "Lower Sac",
         site = paste("Tisdale", trap_position),
         run = tolower(run),
         run = case_when(run == "not recorded" ~ NA_character_,
                         T ~ run),
         species = "chinook",
         rearing = tolower(rearing),
         lifestage = tolower(lifestage),
         lifestage = case_when(lifestage == "button-up fry" ~ "fry",
                               lifestage == "yolk sac fry (alevin)" ~ "yolk sac fry",
                               lifestage == "not recorded" ~ NA_character_,
                               T ~ lifestage)) %>% glimpse

# mill ####
# TODO no run assigned or filtered to spring?
mill_rst %>% glimpse
unique(mill_rst$location)
# date, count, fork_length

mill_rst_clean <- mill_rst %>%
  select(date, count, fork_length) %>%
  mutate(watershed = "Mill Creek",
         species = "chinook",
         site = "Mill Creek")

# yuba ####
yuba_rst %>% glimpse
unique(yuba_rst$location)
unique(yuba_rst$run)
# all are CHN
unique(yuba_rst$organism_code)
unique(yuba_rst$lifestage)
# spring, outlier salmon, fall, unknown, late fall
# date, time, fork_length, lifestage, count, location, run
# lifestage encoding
# not provided = NA, yolk-sac fry = yolk sac fry

yuba_rst_clean <- yuba_rst %>%
  select(date, time, fork_length, lifestage, count, location, run) %>%
  rename(site = location) %>%
  mutate(watershed = "Yuba River",
         species = "chinook",
         lifestage = case_when(lifestage == "not provided" ~ NA_character_,
                               lifestage == "yolk-sac fry" ~ "yolk sac fry",
                               T ~ lifestage)) %>% glimpse

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
saveRDS(combined_rst, "data/rst/combined_rst.rds")


# trap data ####
# battle ####
# sample_id, trap_start_date, trap_start_time, sample_date, sample_time, counter,
# flow_start_meter, flow_end_meter, flow_set_time, velocity, turbidity, cone, 
# trap_sample_type, thalweg, depth_adjust, avg_time_per_rev, fish_properly

# counter means number on cone revolution counter at sample_date, sample_time
battle_environmental %>% str
unique(battle_environmental$trap_sample_type)
unique(battle_environmental$fish_properly)
unique(battle_environmental$partial_sample)

# check to see why some dates are NA. I think this is an error
# becuase these contain no data. Decided to remove. 
filter(battle_trap_clean, is.na(start_date))

battle_trap_clean <- battle_environmental %>%
  select(trap_start_date, trap_start_time, sample_date, sample_time,
         counter, flow_start_meter, flow_end_meter, flow_set_time, velocity,
         turbidity, cone, trap_sample_type, thalweg, depth_adjust, avg_time_per_rev,
         fish_properly, partial_sample) %>%
  # sample_date and sample_time are described as the end of 24 hour sampling period
  # rename to match others
  rename(start_date = trap_start_date,
         start_time = trap_start_time,
         end_date = sample_date,
         end_time = sample_time,
         sample_period_revolutions = counter) %>%
  mutate(site = "Battle Creek",
         watershed = "Battle Creek") %>%
  filter(!is.na(start_date)) %>%
  data.frame() %>%
  distinct()
 
# check to make sure one row per day/time 
battle_trap_clean %>%
  group_by(start_date, start_time) %>%
  tally() %>%
  filter(n > 1)

# butte ####
# date, time, station, trap_status, gear_id, turbidity, velocity, trap_revolutions, 
# rpms_start, rpms_end

# trap_revolutions is the number of revolutions since last check

unique(butte_rst$trap_status)
unique(butte_rst$gear_id)
unique(butte_rst$station)
butte_rst %>%
  group_by(station, gear_id) %>%
  tally()

# there are multiple obs per day which i think is a data entry issue.
# group by date, station, time, gear_id, trap_status then average
butte_trap_clean <- butte_rst %>%
  select(date, station, trap_status, time, gear_id, temperature, turbidity, velocity,
         trap_revolutions, rpms_start, rpms_end) %>%
  group_by(date, station, trap_status, time, gear_id) %>%
  summarize(temperature = mean(temperature, na.rm = T),
            turbidity = mean(turbidity, na.rm = T),
            velocity = mean(velocity, na.rm = T),
            trap_revolutions = mean(trap_revolutions, na.rm = T),
            rpms_start = mean(rpms_start, na.rm = T),
            rpms_end = mean(rpms_end, na.rm = T)) %>%
  rename(site = station,
         sample_period_revolutions = trap_revolutions) %>%
  mutate(watershed = "Butte Creek") %>%
  distinct()

# check to make sure one row per day/time 
butte_trap_clean %>%
  group_by(date, time, site, gear_id, trap_status) %>%
  tally() %>%
  filter(n > 1)

# clear #####
# station_code, sample_id, trap_start_date, trap_start_time, sample_date, sample_time,
# counter, flow_end_meter, flow_start_meter, velocity, turbidity, cone, depth_adjust
# avg_time_per_rev, fish_properly
unique(clear_environmental$gear_condition_code)
unique(clear_environmental$station_code)

# there are NA start_dates which don't have any data. need to remove.

clear_trap_clean <- clear_environmental %>%
  select(station_code, sample_id, trap_start_date, trap_start_time, sample_date,
         sample_time, counter, flow_start_meter, flow_end_meter, flow_set_time,
         velocity, turbidity, cone, trap_sample_type, thalweg, depth_adjust,
         avg_time_per_rev, fish_properly, partial_sample) %>%
  rename(site = station_code,
         start_date = trap_start_date,
         start_time = trap_start_time,
         end_date = sample_date,
         end_time = sample_time,
         sample_period_revolutions = counter) %>%
  mutate(watershed = "Clear Creek") %>%
  filter(!is.na(start_date)) %>%
  distinct()

# check to make sure one row per day/time 
clear_trap_clean %>%
  group_by(start_date, start_time, site) %>%
  tally() %>%
  filter(n > 1)

# deer ####
# date, location, flow, time_for_10_revolutions, trap_condition_code, turbidity,
# water_temperature_celsius

# few cases where there are different measurements per day
# group by date, site and average

unique(deer_rst$location)
unique(deer_rst$trap_condition_code)
deer_trap_clean <- deer_rst %>%
  select(date, location, flow, time_for_10_revolutions, trap_condition_code, turbidity,
         water_temperature_celsius) %>%
  group_by(date, location, trap_condition_code) %>%
  summarize(flow = mean(flow, na.rm = T),
            time_for_10_revolutions = mean(time_for_10_revolutions, na.rm = T),
            turbidity = mean(turbidity, na.rm = T),
            water_temperature_celsius = mean(water_temperature_celsius, na.rm =T)) %>%
  rename(site = location,
         temperature = water_temperature_celsius) %>%
  mutate(watershed = "Deer Creek") %>%
  distinct()


# check to make sure one row per day/time 
deer_trap_clean %>%
  group_by(date,site, trap_condition_code) %>%
  tally() %>%
  filter(n > 1)

filter(deer_trap_clean, date == "2001-11-10")

# feather ####
unique(feather_effort$trap_functioning)
unique(feather_effort$sub_site_name)
# date, site_name, visit_time, visit_type, trap_functioning, water_temp_c,
# turbidity_ntu, latitude, longitude
feather_trap_clean <- feather_effort %>%
  select(date, site_name, sub_site_name, visit_time, visit_type, trap_functioning,
         water_temp_c, turbidity_ntu, latitude, longitude) %>%
  rename(site = site_name,
         subsite = sub_site_name,
         time = visit_time,
         temperature = water_temp_c,
         turbidity = turbidity_ntu,
         trap_status = visit_type) %>%
  mutate(time = as_hms(time),
         watershed = "Feather River") %>%
  distinct()

# check to make sure one row per day/time 
feather_trap_clean %>%
  group_by(date,time, site, subsite) %>%
  tally() %>%
  filter(n > 1)

# knights ####
unique(knights_effort$gear)
unique(knights_effort$cone_sampling_effort)
# date, start_date, stop_date, number_traps, hrs_fished, flow_cfs, turbidity,
# water_t_f, cone_sampling_effort, cone_id, cone_rpm, total_cone_rev
knights_trap_clean <- knights_effort %>%
  select(date, start_date, stop_date, start_time, stop_time, number_traps, hrs_fished, flow_cfs,
         water_t_f, cone_sampling_effort, turbidity, cone_id, cone_rpm, total_cone_rev) %>%
  # convert temp from F to C
  mutate(temperature = (water_t_f - 32) * (5/9),
         watershed = "Lower Sac",
         site = "Knights Landing") %>%
  rename(end_date = stop_date,
         end_time = stop_time,
         flow = flow_cfs,
         sample_period_revolutions = total_cone_rev) %>%
  distinct()

# check to make sure one row per day/time 
knights_trap_clean %>%
  group_by(start_date,start_time, cone_id, date) %>%
  tally() %>%
  filter(n > 1)

# tisdale #####
# no information about trap

# mill #####
# date, flow, time_for_10_revolutions, trap_condition_code, water_temperature,
# turbidity
unique(mill_rst$location)
unique(mill_rst$trap_condition_code)
mill_trap_clean <- mill_rst %>%
  select(date, location, flow, time_for_10_revolutions, trap_condition_code,
         water_temperature, turbidity) %>%
  group_by(date, location, trap_condition_code) %>%
  summarize(flow = mean(flow, na.rm = T),
            time_for_10_revolutions = mean(time_for_10_revolutions, na.rm = T),
            turbidity = mean(turbidity, na.rm = T),
            water_temperature = mean(water_temperature, na.rm =T)) %>%
  rename(temperature = water_temperature) %>%
  mutate(watershed = "Mill Creek",
         site = "Mill Creek") %>%
  distinct()

# check to make sure one row per day/time 
mill_trap_clean %>%
  group_by(date,site, trap_condition_code) %>%
  tally() %>%
  filter(n > 1)
filter(mill_trap_clean, date == "2002-02-07")
# yuba ####
# date, time, method, temperature, turbidity, velocity, trap_status, trap_revolutions,
# trap_revolutions2, rpms_before, rpms_after, location
unique(yuba_rst$method)
unique(yuba_rst$trap_status)
unique(yuba_rst$location)
yuba_trap_clean <- yuba_rst %>%
  select(date, time, method, temperature, turbidity, velocity, trap_status,
         rpms_before, rpms_after, location) %>%
  rename(site = location) %>%
  mutate(watershed = "Yuba River") %>%
  distinct()

# check to make sure one row per day/time 
yuba_trap_clean %>%
  group_by(date,time, site) %>%
  tally() %>%
  filter(n > 1)

# trap combined ####
combined_trap <- bind_rows(battle_trap_clean,
                          butte_trap_clean,
                          clear_trap_clean,
                          deer_trap_clean,
                          feather_trap_clean,
                          knights_trap_clean,
                          #tisdale_trap_clean,
                          mill_trap_clean,
                          yuba_trap_clean)

saveRDS(combined_trap, "data/rst/combined_trap.rds")


# Carcass -----------------------------------------------------------------
# TODO - how categorize spawn condition - can green, ripe be put in unspawned or are they useful as separate categories?
# Battle
battle_carcass %>% glimpse()
unique(battle_carcass$sex)
unique(battle_carcass$adipose)
unique(battle_carcass$carcass_live_status)
unique(battle_carcass$spawn_condition)
unique(battle_carcass$run)

battle_carcass_clean <- battle_carcass %>%
  select(-c(observed_only, cwt_code, other_tag, comments)) %>%
  rename(way_point = location,
         carcass_status = carcass_live_status) %>%
  mutate(adipose = case_when(adipose == "present" ~ T,
                             adipose == "absent" ~ F),
         carcass_status = case_when(carcass_status %in% c("bright", "fresh") ~ "fresh",
                                    carcass_status == "non-fresh" ~ "decayed"),
         spawn_condition = case_when(spawn_condition == "spawned" ~ "spawned",
                                     spawn_condition %in% c("green", "ripe", "unspawned") ~ "unspawned"),
         watershed = "Battle Creek")
# Butte
butte_carcass_2014_2016 %>% glimpse()
unique(butte_carcass_2014_2016$disposition)
unique(butte_carcass_2014_2016$sex)
unique(butte_carcass_2014_2016$condition)
unique(butte_carcass_2014_2016$spawning_status)
unique(butte_carcass_2014_2016$ad_fin_clip_cd)

butte_carcass_2017_2020 %>% glimpse()

# TODO - what is "p" mean in spawning condition?
# I think it means partial

butte_carcass_clean <- bind_rows(butte_carcass_2014_2016,
                                 butte_carcass_2017_2020) %>%
  select(-c(disposition, disc_tag_applied, scale_nu, tissue_nu, otolith_nu, comments)) %>%
  rename(reach = section_cd,
         way_point = way_pt,
         carcass_status = condition,
         fork_length = fork_length_mm,
         spawn_condition = spawning_status,
         adipose = ad_fin_clip_cd,
         carcass_survey_id = survey) %>%
  mutate(watershed = "Butte Creek",
         carcass_status = case_when(carcass_status == "f" ~ "fresh",
                                    carcass_status == "d" ~ "decayed"),
         spawn_condition = case_when(spawn_condition == "yes" ~ "spawned",
                                     spawn_condition == "no" ~ "unspawned",
                                     spawn_condition == "p" ~ "partial")) 

# Clear
# TODO what is hybrid mean in run
clear_carcass %>% glimpse()
unique(clear_carcass$hatchery)
unique(clear_carcass$why_sex_unknown)
unique(clear_carcass$condition)
unique(clear_carcass$spawn_status)
unique(clear_carcass$run)
unique(clear_carcass$sex)
unique(clear_carcass$adipose)
# only chinook
unique(clear_carcass$species)
# only 10 when run_call is different than run and they don't really make sense,
# use run
ck <- filter(clear_carcass, run !=  run_call)

clear_carcass_clean <- clear_carcass %>%
  select(-c(obs_only, tis_eth, tis_dry, scale, otolith_st, why_sex_unknown, why_not_sp, head_retrieved, tag_type,
            photo, comments, cwt_code, brood_year, release_location, hatchery, mark_rate, verification_and_cwt_comments,
            genetic, run_call, species, sample_id)) %>%
  rename(carcass_status = condition,
         spawn_condition = spawn_status,
         method = type) %>% 
  mutate(carcass_status = case_when(carcass_status == "non-fresh" ~ "decayed",
                                    T ~ carcass_status),
         adipose = case_when(adipose == "present" ~ T,
                             adipose == "absent" ~ F),
         watershed = "Clear Creek")

combined_carcass <- bind_rows(battle_carcass_clean,
                              butte_carcass_clean,
                              clear_carcass_clean)

saveRDS(combined_carcass, "data/redd_carcass_holding/combined_carcass.rds")


# Holding -----------------------------------------------------------------

# Battle
battle_holding %>% glimpse()

battle_holding_clean <- battle_holding %>%
  select(-notes) %>%
  mutate(watershed = "Battle Creek")

# Butte
butte_holding_clean <- bind_rows(butte_holding_01 %>% select(-comments),
                                 butte_holding_02,
                                 butte_holding_03,
                                 butte_holding_04,
                                 butte_holding_05,
                                 butte_holding_06,
                                 butte_holding_07, 
                                 butte_holding_08,
                                 butte_holding_09,
                                 butte_holding_10,
                                 butte_holding_11,
                                 butte_holding_12,
                                 butte_holding_13,
                                 butte_holding_14,
                                 butte_holding_15,
                                 butte_holding_16,
                                 butte_holding_17) %>%
  select(-personnel, -why_fish_count_na) %>%
  rename(count = fish_count) %>%
  mutate(watershed = "Butte Creek")
butte_holding_clean %>% glimpse()

# Clear
clear_holding %>% glimpse()

clear_holding_clean <- clear_holding %>%
  select(-c(comments, picket_weir_location_rm, picket_weir_relate)) %>%
  rename(jacks = jack_count) %>%
  mutate(watershed = "Clear Creek")

clear_holding_clean %>% glimpse()

# Deer
deer_holding_1986_1996 %>% glimpse()

deer_holding_clean <- bind_rows(deer_holding_1986_1996,
                                deer_holding_1997_2020) %>%
  rename(reach = location) %>%
  mutate(watershed = "Deer Creek")

combined_holding <- bind_rows(battle_holding_clean,
                              butte_holding_clean,
                              clear_holding_clean,
                              deer_holding_clean)

saveRDS(combined_holding, "data/redd_carcass_holding/combined_holding.rds")