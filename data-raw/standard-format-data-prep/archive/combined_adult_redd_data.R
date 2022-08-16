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
files_battle <- tibble(path = "adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_redd",
                       name = c(""),
                       save = "data/redd_carcass_holding/battle_redd")
files_clear <- tibble(path = "adult-holding-redd-and-carcass-surveys/clear-creek/data/clear_redd",
                      name = c(""),
                      save = "data/redd_carcass_holding/clear_redd")
files_feather <- tibble(path = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd",
                     name = c(""),
                     save = "data/redd_carcass_holding/feather_redd")
files_mill <- tibble(path = "adult-holding-redd-and-carcass-surveys/mill-creek/data/mill_redd_survey",
                        name = c(""),
                        save = "data/redd_carcass_holding/mill_redd")

pmap(files_battle, get_data)
pmap(files_clear, get_data)
pmap(files_feather, get_data)
pmap(files_mill, get_data)




# Read in & Explore 
# Adult upstream passage data 
# Battle
battle_redd <- read_csv("data/redd_carcass_holding/battle_redd.csv", 
                        col_names = TRUE, 
                        col_types = list("n", "n", "D", "c", "n", "c", 
                                         "c", "c", "l", "l", "l", "n", 
                                         "n", "n", "n", "n", "c", "n", 
                                         "n", "n", "n", "n", "n", "n", 
                                         "c")) %>% glimpse()
unique(battle_redd$pre_redd_substrate_size)
# explore data
unique(battle_redd$flow_meter)

# Clear 
clear_redd <- read_csv("data/redd_carcass_holding/clear_redd.csv", 
                       col_names = TRUE,
                       col_types = list("c", "n", "n", "n", "n", "n", 
                                        "c", "n", "c", "D", "c", "c", "n", "c", 
                                        "c", "c", "c", "c", "c", "l", "l", "l", 
                                        "D", "n", "n", "n", "n", "n", "n", "n", 
                                        "n", "n", "n", "n", "n", "c", "c", "c",
                                        "D", "n", "l", "n", "n")) %>% glimpse()
# explore data
unique(clear_redd$method)

# Feather
feather_redd <- read_csv("data/redd_carcass_holding/feather_redd.csv", 
                         col_names = TRUE, 
                         col_types = list("D", "c", "c", "n",
                                       "n", "n", "n", "n", "n",
                                       "n", "n", "n", "n", "n",
                                       "n", "n", "n")) %>% glimpse()
# explore data
summary(feather_redd)

# Mill 
mill_redd <- read_csv("data/redd_carcass_holding/mill_redd.csv") %>% glimpse()
# explore data
summary(mill_redd)



# Clean Up 
# Clean columns to format as follows
# date 
# year (*mill creek)
# location (site name)
# latitude
# longitude 



# Battle - ONLY LOOKING AT VIDEO NOW
clean_battle_redd <- battle_redd %>% 
  mutate(count = 1, # each row refers to an individual redd 
         watershed = "Battle Creek") %>% 
  rename(flow = flow_fps, fish_on_redd = fish_guarding) %>% 
  select(-flow_meter, -start_number_flow_meter, -start_number_flow_meter_80, 
         -end_number_flow_meter, -end_number_flow_meter_80, -flow_meter_time, -flow_meter_time_80) %>% glimpse

unique(clean_battle_upstream_passage$passage_direction)

# Clear Creek 
clean_clear_redd <- clear_redd %>% 
  mutate(count = 1, 
         watershed = "Clear Creek") %>% 
  rename(redd_measured = measured, survey_number = survey, reach = surveyed_reach,
         gravel_injection_site = inj_site) %>%
  select(-start_60, -start_80, -end_60, -end_80, 
         -sec_60, -secs_80, -bomb_vel60, -bomb_vel80, 
         -redd_loc) %>%
  glimpse

unique(clean_clear_redd$survey)
unique(clean_clear_upstream_passage$observation_reach)

# Feather River
clean_feather_redd <- feather_redd %>% 
  mutate(watershed = "Feather River",
         velocity = velocity_m_per_s * 3.28084) %>% 
  rename(count = redd_count, site_name = location, 
         redd_width = redd_width_m, redd_length = redd_length_m,
         redd_pit_depth = pot_depth_m, pre_redd_depth = depth_m) %>% # all are in meters
  select(-type, -velocity_m_per_s) %>% # type not helpful unless we have corresponding shape files
  glimpse 

# Mill creek 
clean_mill_redd <- mill_redd %>% 
  mutate(watershed = "Mill Creek") %>% 
  rename(count = redd_count, site_name = location) %>% glimpse 

# Combine
combined_redd <- bind_rows(clean_battle_redd, clean_clear_redd, 
                           clean_feather_redd, clean_mill_redd) %>% 
  mutate(run = ifelse(run == "late-fall", "late fall", run)) %>%
  select(-pre_redd_substrate_size, -redd_substrate_size, -tail_substrate_size) %>% glimpse

# Categorical variables 
unique(combined_redd$reach)
unique(combined_redd$watershed)
unique(combined_redd$method)
unique(combined_redd$ucc_relate)
unique(combined_redd$picket_weir_relation)
unique(combined_redd$redd_id) # NO standard convention
unique(combined_redd$gravel)
unique(combined_redd$gravel_injection_site)
unique(combined_redd$run) # TODO fix run to have latefall instead of late-fall 
unique(combined_redd$observation_reach)
unique(combined_redd$site_name)

# Numeric variables 
summary(combined_redd$longitude) 
summary(combined_redd$latitude)
summary(combined_redd$river_mile)
summary(combined_redd$pre_redd_depth)
summary(combined_redd$redd_pit_depth)
summary(combined_redd$redd_tail_depth)
summary(combined_redd$redd_length)
summary(combined_redd$redd_width)
summary(combined_redd$flow)
summary(combined_redd$count)
summary(combined_redd$survey_number)
summary(combined_redd$x1000ftbreak)
summary(combined_redd$picket_weir_location)
summary(combined_redd$age)
summary(combined_redd$percent_fine_substrate)
summary(combined_redd$percent_small_substrate)
summary(combined_redd$percent_medium_substrate)
summary(combined_redd$percent_large_substrate)
summary(combined_redd$percent_boulder)
summary(combined_redd$starting_elevation_ft)
summary(combined_redd$year)
#DATE/TIME ranges 
summary(combined_redd$date) # 2000 - 2020 


saveRDS(combined_redd, "data/redd_carcass_holding/combined_redd.rds")
