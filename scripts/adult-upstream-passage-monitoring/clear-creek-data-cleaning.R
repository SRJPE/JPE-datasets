library(tidyverse)
library(lubridate)
library(googleCloudStorageR)

# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# View objects within global bucket
gcs_list_objects()

# git data and save as xlsx
gcs_get_object(object_name = "adult-upstream-passage-monitoring/clear-creek/ClearCreekVideoWeir_AdultRecruitment_2013-2020.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "test-data.xlsx",
               overwrite = TRUE)

# read in data to clean 
readxl::excel_sheets("test-data.xlsx")
domain_description <- readxl::read_excel("test-data.xlsx", sheet = "Domain Description") %>% glimpse()
raw_data_test <- readxl::read_excel("test-data.xlsx", sheet = "ClearCreekVideoWeir_AdultRecrui") %>% glimpse()

unique(raw_data_test$Run)
# TODO fix time_passed to be time format, fix time_block to be in time format
# clean data 
filtered_data <- raw_data_test %>% 
  set_names(tolower(colnames(raw_data_test))) %>%
  mutate(date = as.Date(date),
         time_block = format(time_block, format = "%H:%M:%S")) %>% # Left in characters for now TODO change to time
  filter(species == "CHN", run == "SR") %>% 
  select(-stt_size) %>% glimpse()

# 

unique(filtered_data$Species)
# save data back up to bucket 

