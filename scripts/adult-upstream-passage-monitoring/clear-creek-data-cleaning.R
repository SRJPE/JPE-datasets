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
               saveToDisk = "test-data.xlsx")

# read in data to clean 
raw_data_test <- readxl::read_excel("test-data.xlsx")

# clean data 


# save data back up to bucket 

