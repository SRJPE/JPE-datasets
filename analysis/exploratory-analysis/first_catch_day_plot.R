library(tidyverse)
library(ggplot2)
library(googleCloudStorageR)
library(lubridate)

color_pal <- c("#9A8822",  "#F8AFA8", "#FDDDA0", "#74A089", "#899DA4", "#446455", "#DC863B", "#C93312")

# load in catch data
Sys.setenv("GCS_AUTH_FILE" = "config.json", "GCS_DEFAULT_BUCKET" = "jpe-dev-bucket")
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
# 
View(gcs_list_objects())

gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
               overwrite = TRUE)

gcs_get_object(object_name = "standard-format-data/standard_rst_trap.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_rst_trap.csv",
               overwrite = TRUE)

catch <- read_csv("data/standard-format-data/standard_rst_catch.csv") %>% glimpse
trap_operations <- read_csv("data/standard-format-data/standard_rst_trap.csv") %>% glimpse


first_catch_day <- catch %>% 
  filter(run %in% c("spring", "unknown", NA)) %>%
  group_by(year = year(date), stream, site) %>% 
  summarise(fist_catch_day = min(date, na.rm = T)) %>% glimpse

first_trap_day <- trap_operations %>% 
  group_by(year = year(trap_start_date), stream, site) %>% 
  summarise(fist_trap_day = min(trap_start_date, na.rm = T)) %>% glimpse

first_catch_day %>% full_join(first_trap_day) %>% 
  filter(year > 2003) %>% filter(stream == "battle creek")
