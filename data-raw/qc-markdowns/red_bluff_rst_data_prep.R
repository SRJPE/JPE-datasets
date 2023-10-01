# Pull in EDI data for Red Bluff
library(EDIutils)
library(tidyverse)
library(googleCloudStorageR)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
f <- function(input, output) write_csv(input, file = output)

read_data_entity_names("edi.1365.7")
# catch
raw <- read_data_entity("edi.1365.7", "58540ac4ed34ce05f3309510f4be91e5")
rb_catch_raw <- readr::read_csv(file = raw)
# trap
raw <- read_data_entity("edi.1365.7", "eed3b61b7eb6030dafc9e4765f07a106")
rb_trap_raw <- readr::read_csv(file = raw)
# recapture
raw <- read_data_entity("edi.1365.7", "460853b8a4a0a2308c2bfb4d3dc2793c")
rb_recapture_raw <- readr::read_csv(file = raw)
# release
raw <- read_data_entity("edi.1365.7", "414dd61cd26985641875fb194328f8a6")
rb_release_raw <- readr::read_csv(file = raw)
# release fish
raw <- read_data_entity("edi.1365.7", "f1649215c4114b74d964b825d6371b66")
rb_release_fish_raw <- readr::read_csv(file = raw)

# format data to match structure of existing data for model
rb_catch_raw |> glimpse()
unique(rb_catch_raw$run)
unique(rb_catch_raw$lifestage)

rb_catch <- rb_catch_raw |> 
  mutate(date = ymd_hms(paste0(start_date, " ", start_time)),
         run = case_when(run == "late fall run" ~ "late fall",
                         run == "spring run" ~ "spring",
                         run == "winter run" ~ "winter",
                         run == "fall run" ~ "fall",
                         T ~ run),
         lifestage = case_when(lifestage == "not provided" ~ "not recorded",
                               lifestage == "RBT - parr" ~ "parr",
                               lifestage == "RBT - silvery parr" ~ "silvery parr",
                               lifestage == "RBT - smolt" ~ "smolt",
                               lifestage == "RBT - yolk sac fry" ~ "yolk sac fry",
                               lifestage == "RBT - fry" ~ "fry",
                               T ~ lifestage),
         species = tolower(common_name),
         stream = "sacramento river",
         site = "red bluff diversion dam",
         subsite = station_code) |> 
  select(date, run, fork_length, lifestage, dead, count, stream, site, subsite,
         adipose_clipped, species, weight)

gcs_upload(rb_catch,
           object_function = f,
           type = "csv",
           name = "rst/rbdd/data/catch.csv",
           predefinedAcl = "bucketLevel")

rb_trap <- rb_trap_raw |> 
  mutate(stream = "sacramento river",
         site = "red bluff diversion dam",
         subsite = station_code,
         trap_start_date = start_date,
         trap_start_time = start_time,
         counter_start = counter,
         debris_volume = debris_tubs*5,
         is_half_cone_configuration = ifelse(cone == 0.5, T, F),
         trap_functioning = case_when(gear_condition == "normal" ~ "trap functioning normally",
                                      gear_condition %in% c("total block", "not rotating") ~ "trap stopped functioning",
                                      gear_condition == "partial block" ~ "trap functioning but not normally",
                                      T ~ gear_condition),
         gear_type = "rotary screw trap") |> 
  select(stream, site, subsite, trap_start_date, trap_start_time, trap_functioning,
         gear_type, is_half_cone_configuration, debris_volume, counter_start)

gcs_upload(rb_trap,
           object_function = f,
           type = "csv",
           name = "rst/rbdd/data/trap.csv",
           predefinedAcl = "bucketLevel")

rb_environmental_raw <- rb_trap_raw |> 
  mutate(stream = "sacramento river",
         site = "red bluff diversion dam",
         subsite = station_code,
         date = ymd_hms(paste0(start_date, " ", start_time))) |> 
  select(date, stream, site, subsite, flow_cfs, temperature, turbidity, velocity, river_depth, diel, weather, 
         volume) 

rb_environmental <- rb_environmental_raw |> 
  select(date, stream, site, subsite, flow_cfs, temperature, turbidity, velocity, river_depth,
         volume) |> 
  pivot_longer(cols = c(flow_cfs, temperature, turbidity, velocity, river_depth,
                        volume), names_to = "parameter", values_to = "value") |> 
  bind_rows(rb_environmental_raw |> 
              select(date, stream, site, subsite, diel, weather) |> 
              pivot_longer(cols = c(diel, weather), names_to = "parameter", values_to = "text"))

gcs_upload(rb_environmental,
           object_function = f,
           type = "csv",
           name = "rst/rbdd/data/environmental.csv",
           predefinedAcl = "bucketLevel")

summary_release_fish <- rb_release_fish_raw |> 
  mutate(source = toupper(source),
         fish_origin = tolower(fish_origin)) |> 
  group_by(mark_sample_row_id) |> 
  summarize(median_fork_length_released = median(fork_length),
            origin_released = fish_origin,
            source_released = source) |> 
  distinct()

rb_release <- rb_release_raw |> 
  left_join(summary_release_fish) |> 
  mutate(release_id = trial_id,
         stream = "sacramento river",
         site = "red bluff diversion dam",
         date_released = release_date,
         time_released = release_time,
         number_released = num_released,
         run_released = tolower(run_designation),
         run_released = ifelse(run_released == "latefall", "late fall", 
                               run_released),
         site_released = release_site,
         turbidity_at_release = mean_turbidity,
         origin_released = case_when(origin_released == "both" ~ "mixed",
                                     origin_released == "cnfh" ~ "hatchery",
                                     T ~ origin_released),
         source_released = case_when(source_released == "HATCH" ~ "hatchery",
                                     source_released == "MIX" ~ "mixed",
                                     T ~ source_released)) |> 
  select(stream, site, release_id, date_released, time_released, site_released,
         number_released, median_fork_length_released, run_released, origin_released,
         source_released, turbidity_at_release)

gcs_upload(rb_release,
           object_function = f,
           type = "csv",
           name = "rst/rbdd/data/release.csv",
           predefinedAcl = "bucketLevel")
  
  
rb_recapture <- rb_recapture_raw |> 
  mutate(release_id = trial_id,
         stream = "sacramento river",
         site = "red bluff diversion dam",
         subsite = station_code,
         date_recaptured = sample_date,
         number_recaptured = count) |> 
  select(stream, site, subsite, release_id, date_recaptured, number_recaptured,
         fork_length)

gcs_upload(rb_recapture,
           object_function = f,
           type = "csv",
           name = "rst/rbdd/data/recapture.csv",
           predefinedAcl = "bucketLevel")
  
