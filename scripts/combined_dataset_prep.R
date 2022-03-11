library(tidyverse)
library(googleCloudStorageR)

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

battle_trap_clean <- battle_environmental %>%
  select(sample_id, trap_start_date, trap_start_time, sample_date, sample_time,
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
         watershed = "Battle Creek")

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

butte_trap_clean <- butte_rst %>%
  select(date, station, trap_status, time, gear_id, temperature, turbidity, velocity,
         trap_revolutions, rpms_start, rpms_end) %>%
  rename(site = station,
         sample_period_revolutions = trap_revolutions) %>%
  mutate(watershed = "Butte Creek")

# clear #####
# station_code, sample_id, trap_start_date, trap_start_time, sample_date, sample_time,
# counter, flow_end_meter, flow_start_meter, velocity, turbidity, cone, depth_adjust
# avg_time_per_rev, fish_properly
unique(clear_environmental$gear_condition_code)
unique(clear_environmental$station_code)

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
  mutate(watershed = "Clear Creek")

# deer ####
# date, location, flow, time_for_10_revolutions, trap_condition_code, turbidity,
# water_temperature_celsius
unique(deer_rst$location)
unique(deer_rst$trap_condition_code)
deer_trap_clean <- deer_rst %>%
  select(date, location, flow, time_for_10_revolutions, trap_condition_code, turbidity,
         water_temperature_celsius) %>%
  rename(site = location,
         temperature = water_temperature_celsius) %>%
  mutate(watershed = "Deer Creek")

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
         watershed = "Feather River")

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
         sample_period_revolutions = total_cone_rev)

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
  rename(site = location,
         temperature = water_temperature) %>%
  mutate(watershed = "Mill Creek")

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
  mutate(watershed = "Yuba River")

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
