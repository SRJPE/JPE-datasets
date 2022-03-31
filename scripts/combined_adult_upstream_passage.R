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

gcs_list_objects()

get_data <- function(path, name, save) {
  gcs_get_object(object_name = paste0(path, name, ".csv"),
                 bucket = gcs_get_global_bucket(),
                 saveToDisk = paste0(save, name, ".csv"),
                 overwrite = TRUE)
}

# rst data pull ####
files_battle <- tibble(path = rep("adult-upstream-passage-monitoring/battle-creek/data/battle_",3),
                       name = c("passage_estimates","passage_trap","passage_video"),
                       save = rep("data/adult-upstream-passage-monitoring/battle_", 3))

files_clear <- tibble(path = "adult-upstream-passage-monitoring/clear-creek/data/clear_passage",
                      name = c(""),
                      save = "data/adult-upstream-passage-monitoring/clear_passage")
files_deer <- tibble(path = "adult-upstream-passage-monitoring/deer-creek/data/deer_upstream_passage_estimate",
                     name = c(""),
                     save = "data/adult-upstream-passage-monitoring/deer_upstream_passage_estimate")

files_mill <- tibble(path = "adult-upstream-passage-monitoring/mill-creek/data/mill_upstream_passage_estimate",
                     name = c(""),
                     save = "data/adult-upstream-passage-monitoring/mill_upstream_passage_estimate")

files_yuba <- tibble(path = "adult-upstream-passage-monitoring/yuba-river/data/yuba_upstream_passage",
                     name = c(""),
                     save = "data/adult-upstream-passage-monitoring/yuba_upstream_passage")

pmap(files_battle, get_data)
pmap(files_clear, get_data)
pmap(files_deer, get_data)
pmap(files_mill, get_data)
pmap(files_yuba, get_data) # Yuba data not saved in jpe datasets



# Read in & Explore 
# Adult upstream passage data 
# Battle
battle_upstream_passage_estimate <- read_csv("data/adult-upstream-passage-monitoring/battle_passage_estimates.csv") %>% glimpse()
battle_upstream_trap <- read_csv("data/adult-upstream-passage-monitoring/battle_passage_trap.csv") %>% glimpse()
battle_upstream_video <- read_csv("data/adult-upstream-passage-monitoring/battle_passage_video.csv") %>% glimpse()

# explore data
# Hold off on battle estimate (it is a weekly estimate)
unique(battle_upstream_passage_estimate$adipose)# Present, absent, unknown
unique(battle_upstream_passage_estimate$method) # trap, barrier weir 

unique(battle_upstream_video$adipose) # Present, absent, unknown
unique(battle_upstream_video$run) # "SR", "unknown", "LF", "WR","FR" 
unique(battle_upstream_video$passage_direction) # "up","down"

# Clear 
clear_passage <- read_csv("data/adult-upstream-passage-monitoring/clear_passage.csv") %>% glimpse()
# explore data
unique(clear_passage$adipose)# "present" "unknown" "absent"  NA
unique(clear_passage$jack_size)
unique(clear_passage$run)

# Deer 
deer_passage <- read_csv("data/adult-upstream-passage-monitoring/deer_upstream_passage_estimate.csv") %>% glimpse()
# explore data
summary(deer_passage)

# Mill 
mill_passage <- read_csv("data/adult-upstream-passage-monitoring/mill_upstream_passage_estimate.csv") %>% glimpse()
# explore data
summary(mill_passage)

# Yuba 
yuba_passage <- read_csv("data/adult-upstream-passage-monitoring/yuba_upstream_passage.csv") %>% glimpse()
# explore data
unique(yuba_passage$adipose) # NA, uknonwn, clipped
# TODO change clipped to absent?

unique(yuba_passage$ladder)
unique(yuba_passage$ladder)

# Clean Up 
# Clean columns to format as follows
# date 
# time 
# count
# adipose: present, absent, unknown, NA
# run: LateFall, Spring, Winter, Fall, unknown, NA
# passage_direction: up, down, NA
# viewing_condition (clear only)
# spawning condition (clear only)
# length (yuba only)
# ladder (yuba only)
# flow, temp (mill and deer only)
# comments

# Battle - ONLY LOOKING AT VIDEO NOW
clean_battle_upstream_passage <- battle_upstream_video %>% 
  mutate(run = case_when(run == "SR" ~ "spring", 
                         run == "FR" ~ "fall",
                         run == "LF" ~ "late fall", 
                         run == "WR" ~ "winter",
                         run == "unknown" ~ "unknown"),
         count_type = "raw count",
         watershed = "Battle Creek") %>% glimpse

unique(clean_battle_upstream_passage$passage_direction)

# Clear Creek 
# TODO check on these interpretations of categorical variables 

# Spawn Condition 
# pre spawn (1) = "Energetic; bright or silvery; no spawning coloration or developed secondary sex characteristics.",
# early spawn (2) = "Energetic, can tell sex from secondary characteristics (kype) silvery or bright coloration but may have some hint of spawning colors.",
# late spawn (3) = "Spawning colors, defined kype, some tail wear or small amounts of fungus.",
# fungus (4) = "Fungus, lethargic, wandering; “ Zombie fish”. Significant tail wear in females to indicate the spawning process has already occurred.",
# unknon (5) = "Unable to make distinction."

# Viewing Condition 
# normal (0) = "Normal (good visability, clear water, all equiptment working, no obstructions)", 
# readable (1) = "Readable (lower confidence due to turbidity or partial loss of video equiptment)", 
# not readable (2) = "Not Readable (high turbidity or equiptment failure)",
# weir flooded (3) = "Weir is flooded"


clean_clear_upstream_passage <- clear_passage %>% 
  mutate(run = case_when(run == "SR" ~ "spring", 
                         run == "FR" ~ "fall",
                         run == "LF" ~ "late fall", 
                         run == "WR" ~ "winter",
                         run == "unknown" ~ "unknown"),
         spawning_condition = case_when(
           spawning_condition == 1 ~ "prespawn", 
           spawning_condition == 2 ~ "early spawn", 
           spawning_condition == 3 ~ "late spawn", 
           spawning_condition == 4 ~ "fungus", 
           spawning_condition == 5 ~ "unknown"
         ),
         viewing_condition = case_when(
           viewing_condition == 0 ~ "normal", 
           viewing_condition == 1 ~ "readable",
           viewing_condition == 2 ~ "not readable", 
           viewing_condition == 3 ~ "weir flooded"
         ),
         time = time_passed,
         count_type = "raw count",
         watershed = "Clear Creek") %>% 
  select(-time_block, -time_passed) %>%
  glimpse

unique(clean_clear_upstream_passage$passage_direction)
unique(clean_clear_upstream_passage$jack_size)

# Deer creek 
clean_deer_upstream_passage <- deer_passage %>% 
  mutate(count_type = "passage estimate", 
         watershed = "Deer Creek") %>% 
  rename(count = passage_estimate) %>% glimpse 

# Mill creek 
clean_mill_upstream_passage <- mill_passage %>% 
  mutate(count_type = "passage estimate", 
         watershed = "Mill Creek") %>% 
  rename(count = passage_estimate) %>% glimpse 

# Yuba River 
clean_yuba_upstream_passage <- yuba_passage %>% 
  mutate(adipose = case_when(adipose == "unknown" ~ "unknown", 
                             adipose == "clipped" ~ "absent"),
         count_type = "raw count",
         watershed = "Yuba River") %>% 
  select(date, time, count, adipose, 
         passage_direction, ladder, watershed, length = length_cm) %>% glimpse 

unique(clean_yuba_upstream_passage$adipose)

# Combine
combined_adult_upstream_passage <- bind_rows(clean_battle_upstream_passage, clean_clear_upstream_passage, 
                                             clean_deer_upstream_passage, clean_mill_upstream_passage, 
                                             clean_yuba_upstream_passage) %>% glimpse

# Categorical variables 
unique(combined_adult_upstream_passage$adipose)
unique(combined_adult_upstream_passage$run)
unique(combined_adult_upstream_passage$passage_direction)
unique(combined_adult_upstream_passage$count_type)
unique(combined_adult_upstream_passage$watershed)
unique(combined_adult_upstream_passage$viewing_condition)
unique(combined_adult_upstream_passage$sex)
unique(combined_adult_upstream_passage$spawning_condition)
unique(combined_adult_upstream_passage$jack_size)

# Numeric variables 
summary(combined_adult_upstream_passage$count) # -1 seems like a problem 
summary(combined_adult_upstream_passage$flow)
summary(combined_adult_upstream_passage$temperature)
summary(combined_adult_upstream_passage$length)

#DATE/TIME ranges 
summary(combined_adult_upstream_passage$date)
summary(combined_adult_upstream_passage$time)

saveRDS(combined_adult_upstream_passage, "data/adult-upstream-passage-monitoring/combined_upstream_passage.rds")
