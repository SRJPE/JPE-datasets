library(googleCloudStorageR)
library(tidyverse)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_get_object(object_name = "model-db/trap_location.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/trap_location.csv",
               overwrite = TRUE)
site_lookup <- read_csv("data/model-db/trap_location.csv")

site <- site_lookup |> 
  select(stream, site, subsite, site_group) |> 
  distinct()

gcs_get_object(object_name = "standard-format-data/standard_flow.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_flow.csv",
               overwrite = TRUE)
standard_flow <- read_csv("data/standard-format-data/standard_flow.csv")

flow_lookup <- standard_flow |> 
  select(stream, site, source) |> 
  distinct() |> 
  separate(source, sep = " ", into = c("gage_agency", "gage_number")) |> 
  mutate(gage_number = case_when(site == "lower feather" ~ "FSB",
                                 T ~ gage_number)) |> 
  left_join(site)
  
# standard temp
gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_temperature.csv",
               overwrite = TRUE)
standard_temperature <- read_csv("data/standard-format-data/standard_temperature.csv")

glimpse(standard_temperature)

temp_lookup <- standard_temperature |> 
  select(stream, site, subsite, gage_agency, gage_number) |> 
  distinct() |> 
  filter(!(stream == "sacramento river" & gage_number == "logger"),
         !(stream == "feather river" & gage_number == "logger"),
         !(stream == "yuba river" & gage_number == "logger"))
  mutate(gage_number = case_when(site == "ubc" ~ "UBC",
                                 stream == "clear creek" ~ "UCC",
                                 ))
