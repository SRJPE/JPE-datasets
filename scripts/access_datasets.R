library(googleCloudStorageR)
library(tidyverse)

# Use me to access all cleaned SR JPE monitoring data from the cloud

# Run 
# Sys.setenv("GCS_AUTH_FILE" = {path to auth file}, 
#            "GCS_DEFAULT_BUCKET" = "jpe-dev-bucket") 
# to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
#
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))

# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# View objects stored within bucket
gcs_list_objects()

# get data and save as csv
gcs_get_object(object_name = "adult-upstream-passage-monitoring/clear-creek/data/clear_passage.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "clear_passage.csv", 
               overwrite = TRUE)

clear_passage <- read_csv("clear_passage.csv") %>% 
  glimpse()
