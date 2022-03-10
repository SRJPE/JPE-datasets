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

encoding_fn <- function(dat) {
  dat %>%
    mutate(lifestage = case_when(lifestage %in% c("yolk-sac fry", "yolk sac fry (alevin)") ~ "yolk sac fry",
                                 lifestage == "fingerling" ~ "silvery parr",
                                 lifestage %in% c("unknown", "not recorded", "not provided") ~ NA_character_,
                                 lifestage == "yoy (young of the year)" ~ "young of year",
                                 lifestage == "pre-smolt" ~ "parr",
                                 lifestage == "older juvenile", "juvenile",
                                 lifestage == "button-up fry" ~ "fry"))
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

# TODO make lifestage encoding consistent
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
                               lifestage == "yoy (young of the year)" ~ "young of year",
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

knights_rst_clean <- knights_rst %>%
  select(date, fork_length_max_mm, fork_length_min_mm, species, count, at_capture_run, lifestage, marked) %>%
  rename(run = at_capture_run,
         rearing = marked) %>%
  mutate(watershed = "Lower Sac",
         site = "Knights Landing",
         run = tolower(run),
         species = tolower(species),
         rearing = case_when(rearing == T ~ "hatchery",
                             rearing == F ~ "natural"),
         lifestage = ifelse(lifestage == "older juvenile", "juvenile", lifestage)) %>% glimpse

# tisdale ####
# Note that tisdale was aggregated to sum together traps from left and right
tisdale_rst %>% glimpse
unique(tisdale_rst$run)
unique(tisdale_rst$species)
unique(tisdale_rst$rearing)
unique(tisdale_rst$life_stage)
# date, trap_position, fork_length_mm, life_stage, species, run, mortality, rearing, count
# TODO lifestage encodings
# button-up fry = fry, yolk sac fry (alvein) = yolk sac fry, not recorded = NA

tisdale_rst_clean <- tisdale_rst %>%
  select(date, trap_position, species, fork_length_mm, life_stage, run, mortality, rearing, count) %>%
  rename(fork_length = fork_length_mm,
         lifestage = life_stage,
         dead = mortality) %>%
  mutate(watershed = "Lower Sac",
         site = "Tisdale",
         run = tolower(run),
         run = case_when(run == "not recorded" ~ NA_character_,
                         T ~ run),
         species = "chinook",
         rearing = tolower(rearing),
         lifestage = tolower(lifestage),
         lifestage = case_when(lifestage == "button-up fry" ~ "fry",
                               lifestage == "yolk sac fry (alevin)" ~ "yolk sac fry",
                               lifestage == "not recorded" ~ NA_character_,
                               T ~ lifestage)) %>% 
  # condense trap_position
  group_by(date, species, fork_length, lifestage, run, dead, rearing, watershed, site) %>%
  summarize(count = sum(count))

# mill ####
# TODO no run assigned or filtered to spring?
mill_rst %>% glimpse
unique(mill_rst$location)
# date, count, fork_length

mill_rst_clean <- mill_rst %>%
  select(date, count, fork_length) %>%
  mutate(watershed = "Mill Creek",
         species = "chinook")

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

