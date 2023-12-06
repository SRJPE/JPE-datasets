# This script can be used to prepare historical data for the jpe-model-db
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)
f <- function(input, output) write_csv(input, file = output)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


# read in lookups ---------------------------------------------------------
# trap_location
gcs_get_object(object_name = "model-db/trap_location.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/trap_location.csv",
               overwrite = TRUE)
trap_location <- read_csv("data/model-db/trap_location.csv")
# run
gcs_get_object(object_name = "model-db/run.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/run.csv",
               overwrite = TRUE)
run <- read_csv("data/model-db/run.csv")
#lifestage
gcs_get_object(object_name = "model-db/lifestage.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/lifestage.csv",
               overwrite = TRUE)
lifestage <- read_csv("data/model-db/lifestage.csv")
#visit_type
gcs_get_object(object_name = "model-db/visit_type.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/visit_type.csv",
               overwrite = TRUE)
visit_type <- read_csv("data/model-db/visit_type.csv")
#trap_functioning
gcs_get_object(object_name = "model-db/trap_functioning.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/trap_functioning.csv",
               overwrite = TRUE)
trap_functioning <- read_csv("data/model-db/trap_functioning.csv")
#fish_processed
gcs_get_object(object_name = "model-db/fish_processed.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/fish_processed.csv",
               overwrite = TRUE)
fish_processed <- read_csv("data/model-db/fish_processed.csv")
#debris_level
gcs_get_object(object_name = "model-db/debris_level.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/debris_level.csv",
               overwrite = TRUE)
debris_level <- read_csv("data/model-db/debris_level.csv")
#environmental_parameter
gcs_get_object(object_name = "model-db/environmental_parameter.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/environmental_parameter.csv",
               overwrite = TRUE)
environmental_parameter <- read_csv("data/model-db/environmental_parameter.csv")
#gage_source
gcs_get_object(object_name = "model-db/gage_source.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/gage_source.csv",
               overwrite = TRUE)
gage_source <- read_csv("data/model-db/gage_source.csv")
#hatchery
gcs_get_object(object_name = "model-db/hatchery.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/hatchery.csv",
               overwrite = TRUE)
hatchery <- read_csv("data/model-db/hatchery.csv")
# origin
gcs_get_object(object_name = "model-db/origin.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/origin.csv",
               overwrite = TRUE)
origin <- read_csv("data/model-db/origin.csv")
# survey_location
gcs_get_object(object_name = "model-db/survey_location.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/survey_location.csv",
               overwrite = TRUE)
survey_location <- read_csv("data/model-db/survey_location.csv")
# sex
gcs_get_object(object_name = "model-db/sex.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/sex.csv",
               overwrite = TRUE)
sex <- read_csv("data/model-db/sex.csv")
# direction
gcs_get_object(object_name = "model-db/direction.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/direction.csv",
               overwrite = TRUE)
direction <- read_csv("data/model-db/direction.csv")
# catch -------------------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)
catch_raw <- read_csv("data/model-data/daily_catch_unmarked.csv")

# add trap location id
# run id
# lifestage id

# need to fix the feather river sites in catch data 

catch <- catch_raw |> 
  select(stream, site, subsite, date, count, run, lifestage, adipose_clipped, 
         dead, fork_length, weight) |> 
  # trap_location_id
  left_join(trap_location, by = c("stream", "site", "subsite")) |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  # run_id
  left_join(select(run, -description), by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run) |> 
  # lifestage_id
  left_join(select(lifestage, -description), by = c("lifestage" = "definition")) |> 
  rename(lifestage_id = id) |> 
  select(-lifestage) |> 
  mutate(actual_count = NA)

ck <- filter(catch, is.na(id))
unique(catch$trap_location_id)
unique(catch$lifestage_id)
unique(catch$run_id)

try(if(any((unique(catch$trap_location_id) %in% trap_location$id) == F)) 
  stop("Missing Trap Location ID! Please fix!"))
try(if(any((unique(catch$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any((unique(catch$lifestage_id) %in% lifestage$id) == F))
  stop("Missing Lifestage ID! Please fix!"))

gcs_upload(catch,
           object_function = f,
           type = "csv",
           name = "model-db/catch.csv",
           predefinedAcl = "bucketLevel")
# trap --------------------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/daily_trap.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_trap.csv",
               overwrite = TRUE)
trap_raw <- read_csv("data/model-data/daily_trap.csv")


gcs_get_object(object_name = "standard-format-data/standard_RST_environmental.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_environmental.csv",
               overwrite = TRUE)
environmental_raw <- read_csv("data/standard-format-data/standard_environmental.csv")
# add trap location id
# visit type id
# trap functioning id
# fish processed id
# debris level id
# add environmental variables, need to format correctly first

# TODO in trap standard data: if stop/start date NA then make start the same as visit time
discharge <- filter(environmental_raw, parameter == "discharge") |> 
  select(-c(parameter, text)) |> 
  rename(discharge = value) |> 
  group_by(date, stream, site, subsite) |> 
  summarize(discharge = mean(discharge, na.rm = T))
water_velocity <- filter(environmental_raw, parameter == "velocity") |> 
  select(-c(parameter, text)) |> 
  rename(water_velocity = value) |> 
  group_by(date, stream, site, subsite) |> 
  summarize(water_velocity = mean(water_velocity, na.rm = T))
water_temp <- filter(environmental_raw, parameter == "temperature") |> 
  select(-c(parameter, text)) |> 
  rename(water_temp = value) |> 
  group_by(date, stream, site, subsite) |> 
  summarize(water_temp = mean(water_temp, na.rm = T))
turbidity <- filter(environmental_raw, parameter == "turbidity") |> 
  select(-c(parameter, text)) |> 
  rename(turbidity = value) |> 
  group_by(date, stream, site, subsite) |> 
  summarize(turbidity = mean(turbidity, na.rm = T))

trap <- trap_raw |> 
  select(stream, site, subsite, visit_type,  trap_start_date, trap_start_time,
         trap_stop_date, trap_stop_time, trap_functioning, is_half_cone_configuration,
         fish_processed, rpms_start, rpms_end, sample_period_revolutions,
         debris_volume, debris_level, include) |> 
  left_join(discharge, by = c("stream", "site", "subsite", "trap_stop_date" = "date")) |> 
  left_join(water_velocity, by = c("stream", "site", "subsite", "trap_stop_date" = "date")) |> 
  left_join(water_temp, by = c("stream", "site", "subsite", "trap_stop_date" = "date")) |> 
  left_join(turbidity, by = c("stream", "site", "subsite", "trap_stop_date" = "date")) |> 
  # trap_location_id
  left_join(trap_location, by = c("stream", "site", "subsite")) |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  # visit_type_id
  left_join(visit_type, by = c("visit_type" = "definition")) |> 
  rename(visit_type_id = id) |> 
  select(-visit_type, -description) |> 
  # trap_functioning_id
  left_join(trap_functioning, by = c("trap_functioning" = "definition")) |> 
  rename(trap_functioning_id = id) |> 
  select(-trap_functioning, -description) |> 
  # fish_processed_id
  left_join(fish_processed, by = c("fish_processed" = "definition")) |> 
  rename(fish_processed_id = id) |> 
  select(-fish_processed, -description) |> 
  # debris_level_id
  left_join(debris_level, by = c("debris_level" = "definition")) |> 
  rename(debris_level_id = id) |> 
  select(-debris_level, -description) |> 
  rename(in_half_cone_configuration = is_half_cone_configuration,
         rpm_start = rpms_start,
         rpm_end = rpms_end,
         total_revolutions = sample_period_revolutions) |> 
  mutate(trap_visit_time_start = case_when(!is.na(trap_start_time) ~ ymd_hms(paste(trap_start_date, trap_start_time)),
                                           T ~ ymd(trap_start_date)),
         trap_visit_time_end = case_when(!is.na(trap_stop_time) ~ ymd_hms(paste(trap_stop_date, trap_stop_time)),
                                         T ~ ymd(trap_stop_date))) |> 
  select(-c(trap_start_time, trap_start_date, trap_stop_time, trap_stop_date)) |> 
 select(c(trap_location_id, visit_type_id, trap_visit_time_start, trap_visit_time_end,
            trap_functioning_id, in_half_cone_configuration, fish_processed_id,
            rpm_start, rpm_end, total_revolutions, debris_volume, debris_level_id,
            discharge, water_velocity, water_temp, turbidity, include))
         
unique(trap$trap_location_id)
unique(trap$visit_type_id)
unique(trap$trap_functioning_id)
unique(trap$fish_processed_id)
unique(trap$debris_level_id)

ck <- filter(trap, is.na(trap_visit_time_start) & is.na(trap_visit_time_end))

# TODO ADD CHECKS
# trap location id
# visit type id
# trap functioning id
# fish processed id
# debris level id

# check that there are no missing dates

unique(ck$visit_type)
gcs_upload(trap,
           object_function = f,
           type = "csv",
           name = "model-db/trap.csv",
           predefinedAcl = "bucketLevel")
# environmental_gage ------------------------------------------------------
gcs_get_object(object_name = "standard-format-data/standard_flow.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_flow.csv",
               overwrite = TRUE)
flow_raw <- read_csv("data/standard-format-data/standard_flow.csv")

flow <- flow_raw |> 
  full_join(trap_location, by = c("stream", "site"), multiple = "all") |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  rename(value = flow_cfs, 
         gage = source) |> 
  filter(!is.na(value), !is.na(date)) |> 
  mutate(parameter = "discharge") |> 
  left_join(environmental_parameter, by = c("parameter" = "definition")) |> 
  rename(parameter_id = id) |> 
  select(-parameter, -description) |> 
  left_join(gage_source, by = c("gage" = "definition")) |> 
  rename(gage_id = id) |> 
  select(-gage, -description)
  
unique(flow$trap_location_id)
unique(flow$parameter_id)
unique(flow$gage_id)

gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_temperature.csv",
               overwrite = TRUE)
temperature_raw <- read_csv("data/standard-format-data/standard_temperature.csv")
temperature <- temperature_raw |> 
  filter(source != "RST environmental") |> 
  left_join(trap_location, by = c("stream", "site", "subsite"), multiple = "all") |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  rename(value = mean_daily_temp_c,
         gage = source) |> 
  select(-max_daily_temp_c) |> 
  mutate(parameter = "temperature") |> 
  left_join(environmental_parameter, by = c("parameter" = "definition")) |> 
  rename(parameter_id = id) |> 
  select(-parameter, -description) |> 
  left_join(gage_source, by = c("gage" = "definition")) |> 
  rename(gage_id = id) |> 
  select(-gage, -description)
  
unique(temperature$trap_location_id)
unique(temperature$parameter_id)
unique(temperature$gage_id)

environmental_gage <- bind_rows(flow, temperature)

# TODO ADD CHECKS
# parameter
# trap location
# check that there are no missing dates

gcs_upload(environmental_gage,
           object_function = f,
           type = "csv",
           name = "model-db/environmental_gage.csv",
           predefinedAcl = "bucketLevel")
# release_summary ---------------------------------------------------------

# TODO efficiency raw has rows for each subsite which i don't think we want

gcs_get_object(object_name = "standard-format-data/standard_release.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_release.csv",
               overwrite = TRUE)
release_raw <- read_csv("data/standard-format-data/standard_release.csv")

gcs_get_object(object_name = "jpe-model-data/efficiency_summary.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/efficiency_summary.csv",
               overwrite = TRUE)
efficiency_raw <- read_csv("data/standard-format-data/efficiency_summary.csv")

release_summary <- release_raw |> 
  select(stream, site, release_id, date_released, time_released, 
         origin_released, lifestage_released, run_released) |> 
  left_join(efficiency_raw) |> 
  mutate(date_released = case_when(is.na(time_released) ~ ymd(date_released),
                                   T ~ ymd_hms(paste(date_released, time_released))),
         run_released = ifelse(run_released == "other", "unknown", run_released)) |> 
  select(-time_released) |> 
  left_join(trap_location, by = c("stream", "site"), multiple = "all") |> 
  select(-c(stream, site, description)) |> 
  rename(trap_location_id = id) |> 
  left_join(origin, by = c("origin_released" = "definition")) |> 
  rename(origin_id = id) |> 
  select(-origin_released, -description) |> 
  left_join(run, by = c("run_released" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run_released, -description) |> 
  left_join(lifestage, by = c("lifestage_released" = "definition")) |> 
  rename(lifestage_id = id) |> 
  select(-lifestage_released, -description)

# Need to determine if want to keep this table or make it just a release table
# trap location, origin, run, lifestage
# check that there are no missing dates
# one time check - compare to last table provided josh with
# check number recaptured and number released make sense

gcs_upload(release_summary,
           object_function = f,
           type = "csv",
           name = "model-db/release_summary.csv",
           predefinedAcl = "bucketLevel")
# released_fish -----------------------------------------------------------
# no historical data

# recaptured_fish ---------------------------------------------------------
gcs_get_object(object_name = "standard-format-data/standard_recapture.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_recapture.csv",
               overwrite = TRUE)
recapture_raw <- read_csv("data/standard-format-data/standard_recapture.csv")

gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_catch.csv",
               overwrite = TRUE)
standard_catch <- read_csv("data/standard-format-data/standard_catch.csv")

recapture_raw <- standard_catch %>% 
  filter(species == "chinook salmon", # filter for only chinook
         !is.na(release_id)) %>%  # filter for only recaptured fish that were part of efficiency trial
  select(-species)

recaptured_fish <- recapture_raw |> 
  select(stream, site, subsite, date, count, run, lifestage, adipose_clipped, dead, fork_length, weight,
         release_id) |> 
  # trap_location_id
  left_join(trap_location, by = c("stream", "site", "subsite")) |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  # run_id
  left_join(select(run, -description), by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run) |> 
  # lifestage_id
  left_join(select(lifestage, -description), by = c("lifestage" = "definition")) |> 
  rename(lifestage_id = id) |> 
  select(-lifestage) |> 
  mutate(actual_count = NA)

unique(recaptured_fish$trap_location_id)
unique(recaptured_fish$run_id)
unique(recaptured_fish$lifestage_id)

# TODO ADD CHECKS
# Need to determine if want to keep this table or make it just a release table
# trap location, run, lifestage
# check that there are no missing dates
# one time check - compare to last table provided josh with
# check number recaptured and number released make sense


gcs_upload(recaptured_fish,
           object_function = f,
           type = "csv",
           name = "model-db/recaptured_fish.csv",
           predefinedAcl = "bucketLevel")

# check difference between 2 data pulls
recaptured_fish <- read_csv("data/standard-format-data/standard_catch.csv") |> 
  filter(species == "chinook salmon", # filter for only chinook
         !is.na(release_id)) |> 
  group_by(stream, site, subsite, release_id, date) |> 
  summarize(number_recaptured_ck = sum(count),
            median_fork_length_recaptured_ck = median(fork_length, na.rm = T)) |> 
  rename(date_recaptured = date)
standard_recapture <- read_csv("data/standard-format-data/standard_recapture.csv") |> 
  group_by(stream, site, subsite, release_id, date_recaptured, median_fork_length_recaptured) |> 
  summarize(number_recaptured = sum(number_recaptured, na.rm=T)) |> 
  filter(number_recaptured > 0)
ck <- full_join(recaptured_fish, standard_recapture)
mismatch <- filter(ck, site != "red bluff diversion dam", number_recaptured != number_recaptured_ck)

# hatchery_release --------------------------------------------------------
# need to figure out this one
gcs_get_object(object_name = "standard-format-data/standard_rst_hatchery_release.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_hatchery.csv",
               overwrite = TRUE)
hatchery_raw <- read_csv("data/standard-format-data/standard_hatchery.csv")

hatchery_release <- hatchery_raw |> 
  select(first_release_date, last_release_date, run, avg_length, avg_weight, hatchery_location_name,
         release_location_name, total_number_released, adclip_rate) |> 
  rename(mean_length = avg_length,
         mean_weight = avg_weight,
         number_released = total_number_released) |> 
  # run_id
  left_join(select(run, -description), by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run) |> 
  # hatcher_id 
  left_join(select(hatchery, -description), by = c("hatchery_location_name" = "definition")) |> 
  rename(hatchery_id = id) |> 
  select(-hatchery_location_name) |> 
  mutate(stream = case_when(release_location_name %in% c("FEATHER BEL THRM HI FLOW", "FEATHER RIVER", "FEATHER AT GRIDLEY",
                                                         "LAKE OROVILLE", "FEATHER AT LIVE OAK", "FEATHER R HATCHERY") ~ "feather river",
                            # battle creek release locations are below trap but would feed into sacramento
                            release_location_name %in% c("SAC R LAKE REDDING PARK", "SAC R BONNYVIEW BOAT RAMP", "SAC R BEL RBDD", "SAC R RED BLUFF DIV DAM",
                                                         "COLEMAN NFH", "BATTLE CREEK BELOW CNFH") ~ "sacramento river",
                            # boyds pump is below feather rst sites, after confluence with yuba
                            # elkhorn is just north of sacramento
                            # yolo bypass is south
                            # release_location_name %in% c("FEATHER BOYDS PUMP RAMP", "SAC R ELKHORN BOAT RAMP", "YOLO BYPASS", "YOLO BYPASS ELKHORN", "AMERICAN R AT SUNRISE",
                            #                              "COYOTE CREEK", "FEATHER AT YUBA CITY", "SAC R AT CLARKSBURG", "SAC R AT DISCOVERY PARK",
                            #                              "AMERICAN RIVER", "SAC R AB COLLINSVILLE") ~ NA,
                            T ~ NA_character_)) |> 
  # trap_location_id
  left_join(trap_location, by = "stream", multiple = "all") |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  # remove LFC site ids for "FEATHER BEL THRM HI FLOW" "FEATHER AT GRIDLEY" "FEATHER AT LIVE OAK"
  mutate(remove = ifelse(release_location_name %in% c("FEATHER BEL THRM HI FLOW", "FEATHER AT GRIDLEY", "FEATHER AT LIVE OAK") &
                           trap_location_id %in% c(051, 052, 057, 058, 059, 0514, 0515, 0516, 0517), "remove", "keep")) |> 
  filter(remove != "remove", !is.na(trap_location_id)) |> 
  select(-c(remove, release_location_name))

unique(hatchery_release$trap_location_id)
gcs_upload(hatchery_release,
           object_function = f,
           type = "csv",
           name = "model-db/hatchery_release.csv",
           predefinedAcl = "bucketLevel")


# carcass -----------------------------------------------------------------
# TODO
# This currently contains both bulk counts and individual carcasses
# There is still some work to do to clean this up and this data is not a high
# priority for SR JPE 
gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_carcass.csv",
               overwrite = TRUE)
carcass_raw <- read_csv("data/standard-format-data/standard_carcass.csv")

carcass_reach <- carcass_raw |> 
  group_by(stream) |> 
  distinct(reach)
# carcass_estimates -------------------------------------------------------
# TODO need to confirm the run and adipose_clipped for this data
gcs_get_object(object_name = "standard-format-data/standard_carcass_cjs_estimate.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_carcass_cjs_estimate.csv",
               overwrite = TRUE)
carcass_estimates_raw <- read_csv("data/standard-format-data/standard_carcass_cjs_estimate.csv")

carcass_estimates <- carcass_estimates_raw |> 
  rename(carcass_estimate = spawner_abundance_estimate,
         upper_bound_estimate = upper,
         lower_bound_estimate = lower,
         confidence_level = confidence_interval) |> 
  # this is so we can join to survey_location
  mutate(reach = NA) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |>
  # need to confirm the run and adipose clipped
  mutate(run = "spring",
         adipose_clipped = F) |> 
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description) 

try(if(any((unique(carcass_estimates$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(carcass_estimates$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(carcass_estimates$year)))
  stop("Missing Year! Please fix!"))

gcs_upload(carcass_estimates,
           object_function = f,
           type = "csv",
           name = "model-db/carcass_estimates.csv",
           predefinedAcl = "bucketLevel")

# bulk carcass ------------------------------------------------------------
# currently not going to use this table. originally designed to separate
# out bulk counts from individual estimates

# daily_redd --------------------------------------------------------------
# TODO look into the unknow date entries for Feather River
gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_daily_redd.csv",
               overwrite = TRUE)
daily_redd_raw <- read_csv("data/standard-format-data/standard_daily_redd.csv")

daily_redd <- daily_redd_raw |> 
  # remove any NA entries - there should not be any now that Feather issue fixed
  # remove any non chinook species
  filter(!is.na(date), species %in% c("chinook", "not recorded", "unknown")) |> 
  select(date, latitude, longitude, reach, redd_id, age, age_index,
         velocity, run, stream) |> 
  # change format to date instead of datetime
  mutate(date = as.Date(date))
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |>
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description) 

redd_reach <- daily_redd_raw |> 
  group_by(stream) |> 
  distinct(reach)

try(if(any((unique(daily_redd$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(daily_redd$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(daily_redd$date)))
  stop("Missing Date! Please fix!"))

gcs_upload(daily_redd,
           object_function = f,
           type = "csv",
           name = "model-db/daily_redd.csv",
           predefinedAcl = "bucketLevel")

# annual_redd -------------------------------------------------------------
gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_annual_redd.csv",
               overwrite = TRUE)
annual_redd_raw <- read_csv("data/standard-format-data/standard_annual_redd.csv")

annual_redd <- annual_redd_raw |> 
  # filter out NA dates
  filter(!is.na(year)) |> 
  # filter to chinook, might want to do more work to look into error associated 
  # with species misidentification
  filter(species %in% c("chinook", "not recorded", "unknown")) |> 
  select(-c(species)) |> 
  rename(count = annual_redd_count) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |>
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description) 

try(if(any((unique(annual_redd$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(annual_redd$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(annual_redd$year)))
  stop("Missing Year! Please fix!"))

gcs_upload(annual_redd,
           object_function = f,
           type = "csv",
           name = "model-db/annual_redd.csv",
           predefinedAcl = "bucketLevel")

# passage_counts ----------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/upstream_passage.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/upstream_passage.csv",
               overwrite = TRUE)
passage_raw <- read_csv("data/model-data/upstream_passage.csv")

passage <- passage_raw |> 
  # remove missing dates
  filter(!is.na(date)) |> 
  mutate(date = case_when(!is.na(time) ~ ymd_hms(paste0(date,time)),
                           T ~ ymd_hms(paste0(date, " 00:00:00")))) |> 
  rename(hours_sampled = hours) |> 
  select(-c(time, viewing_condition, spawning_condition, jack_size, ladder, 
            flow, temperature, comments)) |> 
  # survey_location_id
  mutate(stream = tolower(stream),
         reach = NA,
         sex = ifelse(is.na(sex), "not recorded", sex),
         passage_direction = ifelse(is.na(passage_direction), "not recorded", passage_direction)) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |>
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description) |> 
  # sex_id
  left_join(sex, by = c("sex" = "definition")) |> 
  rename(sex_id = id) |> 
  select(-sex, -description) |> 
  #direction_id
  left_join(direction, by = c("passage_direction" = "definition")) |> 
  rename(direction_id = id) |> 
  select(-passage_direction, -description)

try(if(any((unique(passage$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(passage$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any((unique(passage$sex_id) %in% sex$id) == F))
  stop("Missing Sex ID! Please fix!"))
try(if(any((unique(passage$direction_id) %in% direction$id) == F))
  stop("Missing Direction ID! Please fix!"))
try(if(any(is.na(passage$date)))
  stop("Missing Date! Please fix!"))
  
gcs_upload(passage,
           object_function = f,
           type = "csv",
           name = "model-db/passage.csv",
           predefinedAcl = "bucketLevel")
# passage_estimates -------------------------------------------------------
gcs_get_object(object_name = "standard-format-data/standard_adult_passage_estimate.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_adult_passage_estimate.csv",
               overwrite = TRUE)
passage_estimates_raw <- read_csv("data/standard-format-data/standard_adult_passage_estimate.csv")

passage_estimate <- passage_estimates_raw |> 
  filter(!is.na(passage_estimate)) |> 
  # survey_location_id
  mutate(reach = NA) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |>
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description)   
  
try(if(any((unique(passage_estimate$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(passage_estimate$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(passage_estimate$year)))
  stop("Missing Year! Please fix!"))

gcs_upload(passage_estimate,
           object_function = f,
           type = "csv",
           name = "model-db/passage_estimate.csv",
           predefinedAcl = "bucketLevel")

# daily_holding -----------------------------------------------------------------
# TODO check run and adipose clipped

gcs_get_object(object_name = "jpe-model-data/holding.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/holding.csv",
               overwrite = TRUE)
holding_raw <- read_csv("data/model-data/holding.csv")

daily_holding <- holding_raw |> 
  select(date, reach, count, latitude, longitude, stream) |> 
  # remove all that are missing date
  filter(!is.na(date)) |> 
  mutate(run = "spring",
         adipose_clipped = F) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |> 
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description)  

try(if(any((unique(daily_holding$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(daily_holding$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(daily_holding$date)))
  stop("Missing Date! Please fix!"))

holding_reach <- holding_raw |> 
  group_by(stream) |> 
  distinct(reach)

gcs_upload(daily_holding,
           object_function = f,
           type = "csv",
           name = "model-db/daily_holding.csv",
           predefinedAcl = "bucketLevel")
# annual_holding -----------------------------------------------------------------
# TODO check run and adipose clipped
annual_holding <- holding_raw |> 
  mutate(year = ifelse(is.na(year), year(date), year)) |> 
  group_by(year, stream, reach) |> 
  summarize(count = sum(count)) |> 
  mutate(run = "spring",
         adipose_clipped = F) |> 
  left_join(survey_location, by = c("stream", "reach")) |>
  select(-c(stream, reach, description)) |>
  rename(survey_location_id = id) |> 
  # run_id
  left_join(run, by = c("run" = "definition")) |> 
  rename(run_id = id) |> 
  select(-run, -description)  

try(if(any((unique(annual_holding$survey_location_id) %in% survey_location$id) == F)) 
  stop("Missing Survey Location ID! Please fix!"))
try(if(any((unique(annual_holding$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any(is.na(annual_holding$year)))
  stop("Missing Year! Please fix!"))
gcs_upload(annual_holding,
           object_function = f,
           type = "csv",
           name = "model-db/annual_holding.csv",
           predefinedAcl = "bucketLevel")

# create spreadsheet to QC reach
reach <- redd_reach |> 
  mutate(included_redd = T) |> 
  full_join(holding_reach |> 
              mutate(included_holding = T)) |> 
  full_join(carcass_reach |> 
              mutate(included_carcass = T))
write_csv(reach, "data/reach_list.csv")

reach_all <- redd_reach |> 
  bind_rows(holding_reach, carcass_reach) |> 
  distinct(stream, reach)
dput(unique(filter(reach_all, stream == "battle creek"))$reach)
dput(unique(filter(reach_all, stream == "butte creek"))$reach)
dput(unique(filter(reach_all, stream == "clear creek"))$reach)
dput(unique(filter(reach_all, stream == "deer creek"))$reach)
dput(unique(filter(reach_all, stream == "feather river"))$reach)
dput(filter(annual_redd_raw, stream == "mill creek") |>  distinct(reach))
dput(unique(filter(reach_all, stream == "yuba river"))$reach)
