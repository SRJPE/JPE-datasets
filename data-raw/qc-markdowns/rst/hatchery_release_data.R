# This script generates a summary hatchery release table
# Data were acquired from RMIS: https://www.rmis.org/cgi-bin/queryfrm.mpl?Table=releases&Version=4.1&record_code=T
# If data are high priority need to figure out way to automate updates to data

library(tidyverse)
library(lubridate)
library(googleCloudStorageR)

# Pull RMIS data from google cloud
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_get_object(object_name = "rst/RMIS_hatchery_release_Nov102022.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns", "rst", "RMIS_hatchery_release.csv"),
               overwrite = TRUE)

cwt_raw <- read_csv(here::here("data-raw", "qc-markdowns", "rst", "RMIS_hatchery_release.csv"))

hatchery_release_table <- cwt_raw %>% 
  select(tag_code_or_release_id, species, run, brood_year, first_release_date, 
         last_release_date, avg_weight, avg_length, cwt_1st_mark, cwt_1st_mark_count, 
         cwt_2nd_mark, cwt_2nd_mark_count, non_cwt_1st_mark, non_cwt_1st_mark_count, non_cwt_2nd_mark, 
         non_cwt_2nd_mark_count, tag_loss_rate, release_location_name, hatchery_location_name) %>% 
  mutate(run = case_when(run == 1 ~ "spring",
                         run == 2 ~ "summer",
                         run == 3 ~ "fall",
                         run == 4 ~ "winter",
                         run == 5 ~ "hybrid",
                         run == 6 ~ "landlocked",
                         run == 7 ~ "late fall",
                         run == 8 ~ "urb l fall",
                         run == 9 ~ "late winter"),
         species = "chinook salmon",
         first_release_date = as.Date(paste0(substr(first_release_date,1,4),"-", substr(first_release_date,5,6), "-", substr(first_release_date,7,8))),
         last_release_date = as.Date(paste0(substr(last_release_date,1,4),"-", substr(last_release_date,5,6), "-", substr(last_release_date,7,8))),
         cwt_1st_mark_count = ifelse(is.na(cwt_1st_mark_count), 0, cwt_1st_mark_count),
         cwt_2nd_mark_count = ifelse(is.na(cwt_2nd_mark_count), 0, cwt_2nd_mark_count),
         non_cwt_1st_mark_count = ifelse(is.na(non_cwt_1st_mark_count), 0, non_cwt_1st_mark_count),
         non_cwt_2nd_mark_count = ifelse(is.na(non_cwt_2nd_mark_count), 0, non_cwt_2nd_mark_count),
         tag_loss_rate = ifelse(is.na(tag_loss_rate), 0, tag_loss_rate),
         cwt_1st_adclip = ifelse(as.numeric(cwt_1st_mark) >= 5000, T, F),
         cwt_2nd_adclip = ifelse(as.numeric(cwt_2nd_mark) >= 5000, T, F),
         non_cwt_1st_adclip = ifelse(as.numeric(non_cwt_1st_mark) >= 5000, T, F),
         non_cwt_2nd_adclip = ifelse(as.numeric(non_cwt_2nd_mark) >= 5000, T, F),
         cwt_adclip = case_when(cwt_1st_adclip == T & cwt_2nd_adclip == T ~ cwt_1st_mark_count + cwt_2nd_mark_count - (cwt_1st_mark_count + cwt_2nd_mark_count)*tag_loss_rate,
                                cwt_1st_adclip == T & (cwt_2nd_adclip == F | is.na(cwt_2nd_adclip)) ~ cwt_1st_mark_count - (cwt_1st_mark_count*tag_loss_rate),
                                (cwt_1st_adclip == F | is.na(cwt_1st_adclip)) & cwt_2nd_adclip == T ~ cwt_2nd_mark_count - (cwt_2nd_mark_count*tag_loss_rate),
                                T ~ 0),
         non_cwt_adclip = case_when(non_cwt_1st_adclip == T & non_cwt_2nd_adclip == T ~ non_cwt_1st_mark_count + non_cwt_2nd_mark_count,
                                    non_cwt_1st_adclip == T & (non_cwt_2nd_adclip == F | is.na(non_cwt_2nd_adclip)) ~ non_cwt_1st_mark_count,
                                    (non_cwt_1st_adclip == F | is.na(non_cwt_1st_adclip)) & non_cwt_2nd_adclip == T ~ non_cwt_2nd_mark_count,
                                    T ~ 0),
         total_number_released = cwt_1st_mark_count + cwt_2nd_mark_count - ((cwt_1st_mark_count + cwt_2nd_mark_count)*tag_loss_rate) +
           non_cwt_1st_mark_count + non_cwt_2nd_mark_count,
         adclip_rate = (cwt_adclip + non_cwt_adclip)/total_number_released)

hatchery_release_table_final <- hatchery_release_table %>% 
  select(tag_code_or_release_id:avg_length, release_location_name, hatchery_location_name,
         total_number_released, adclip_rate)

ggplot(hatchery_release_table_final, aes(x = adclip_rate)) +
  geom_density()

f <- function(input, output) write_csv(input, file = output)

gcs_upload(hatchery_release_table_final,
           object_function = f,
           type = "csv",
           name = "standard-format-data/standard_rst_hatchery_release.csv",
           predefinedAcl = "bucketLevel")
