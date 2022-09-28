library(tidyverse)
library(googleCloudStorageR)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
gcs_get_object(object_name = "rst/RiverLAD.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "analysis/RiverLAD.csv",
               overwrite = TRUE)

lad_raw <- read_csv(here::here("analysis", "RiverLAD.csv"))


lad_counts <- lad_raw |> 
  rename(month = SAMPLEMONTH, 
         day = SAMPLEDAY, 
         run = LENGTHRUN,
         fl_start = STARTFL,
         fl_end = ENDFL) |>
  group_by(month, day, run) |>
  mutate(count = n()) |> glimpse()

all_lad <- lad_counts |> 
  slice_min(fl_start) |>
  rename(fl_start_1 = fl_start,
         fl_end_1 = fl_end) |>
  left_join(filter(lad_counts, count > 1) |> 
              slice_max(fl_start) |>
              rename(fl_start_2 = fl_start,
                     fl_end_2 = fl_end)) |>
  select(-count) |> glimpse()

write_csv(all_lad, "analysis/river_lad_fl_and_dates.csv")
