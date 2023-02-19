# This script can be used to prepare historical data for the jpe-model-db
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# trap_location -----------------------------------------------------------

battle <- tibble(stream = c("battle creek"),
                 site = c("ubc"),
                 subsite = c("ubc"),
                 site_group = c("battle creek"),
                 description = c("upper battle creek rst site location")) |> 
  mutate(id = paste0("01",row_number()))
butte <- tibble(stream = c(rep("butte creek", 5)),
                site = c(rep("okie dam",4), "adams dam"),
                subsite = c("okie dam 1", "okie dam 2", "okie dam fyke trap", NA, "adams dam"),
                site_group = c("butte creek"),
                description = c("rst 1 at okie dam (aka parrott-phalean)", "rst 2 at okie dam (aka parrott-phalean)",
                                "fyke trap at okie dam located in diversion canal", "trap unknown", 
                                "rst at adams dam, only used historically")) |> 
  mutate(id = paste0("02",row_number()))
clear <- tibble(stream = c(rep("clear creek",2)),
                site = c("lcc", "ucc"),
                subsite = c("lcc", "ucc"),
                site_group = c("clear creek"),
                description = c("lower clear creek rst site", "upper clear creek rst site")) |> 
  mutate(id = paste0("03",row_number()))
deer <- tibble(stream = c("deer creek"),
               site = c("deer creek"),
               subsite = c("deer creek"),
               site_group = c("deer creek"),
               description = c("deer creek rst site location")) |> 
  mutate(id = paste0("04",row_number()))
feather <- tibble(stream = c(rep("feather river",19)),
                  site = c(rep("eye riffle",2), "live oak", rep("herringer riffle",3), rep("steep riffle",3), 
                           rep("sunset pumps",2), rep("shawn's beach",2), rep("gateway riffle",4), 
                           rep("lower feather river",2)),
                  subsite = c("eye riffle_north", "eye riffle_side channel", "live oak",
                              "herringer_west", "herringer_east", "herringer_upper_west",
                              "#steep riffle_rst", "steep riffle_10' ext", "steep side channel",
                              "sunset west bank", "sunset east bank", "shawns_west", "shawns_east",
                              "gateway_main1", "gateway main 400' up river", "gateway_rootball", 
                              "gateway_rootball_river_left", "rr", "rl"),
                  site_group = c(rep("upper feather lfc",2), rep("upper feather hfc", 4),
                                 rep("upper feather lfc",3), rep("upper feather hfc", 4),
                                 rep("upper feather lfc",4), rep("lower feather river",2)),
                  description = c(rep("low flow channel rst sites",2), rep("high flow channel rst sites", 4),
                                  rep("low flow channel rst sites",3), rep("high flow channel rst sites", 4),
                                  rep("low flow channel rst sites",4), "rst at river right", "rst at river left")) |> 
  mutate(id = paste0("05",row_number()))
mill <- tibble(stream = c("mill creek"),
               site = c("mill creek"),
               subsite = c("mill creek"),
               site_group = c("mill creek"),
               description = c("mill creek rst site location")) |> 
  mutate(id = paste0("06",row_number()))
yuba <- tibble(stream = c(rep("yuba river",4)),
               site = c("yuba river", rep("hallwood",3)),
               subsite = c("yub","hal","hal2","hal3"),
               site_group = c("yuba river"),
               description = c("rst at yuba river, only used historically", 
                               "rst 1 at hallwood", "rst 2 at hallwood", "rst 3 at hallwood")) |> 
  mutate(id = paste0("07",row_number()))
sacramento <- tibble(stream = c(rep("sacramento river",5)),
                     site = c(rep("knights landing",3), rep("tisdale",2)),
                     subsite = c("8.3", "8.4", "knights landing", "rr","rl"),
                     site_group = c(rep("knights landing",3) , rep("tisdale",2)),
                     description = c(rep("rst at knights landing",2), "rst location unknown", 
                                     "rst at river right", "rst at river left")) |> 
  mutate(id = paste0("08",row_number()))
trap_location <- bind_rows(battle, butte, clear, deer, feather, mill, yuba, sacramento)


# run ---------------------------------------------------------------------
run <- tibble(definition = c("late fall", "spring", "fall", "winter", NA, "not recorded", "unknown"),
              description = c("chinook salmon categorized as late fall", "chinook salmon categorized as spring",
                              "chinook salmon categorized as fall", "chinook salmon categorized as winter",
                              "run listed as NA because count is 0", "run not recorded likely because length at date model does not apply",
                              "run recorded as unknown likely due to uncertainty in the field")) |> 
  mutate(id = row_number())


# lifestage ---------------------------------------------------------------
lifestage <- tibble(definition = c("smolt", "fry", "yolk sac fry", "not recorded", "parr", "silvery parr", 
                                   NA, "adult", "unknown", "yearling"),
              description = c("smolt", "fry", "yolk sac fry", "lifestage not recorded", "parr", "silvery parr",
                              "lifestage listed as NA because count is 0","adult","lifestage recorded as unknown",
                              "lifestage recorded as yearling")) |> 
  mutate(id = row_number())

# visit_type --------------------------------------------------------------
visit_type <- tibble(definition = c("not recorded", "continue trapping", "end trapping", "start trapping", 
                                    "unplanned restart", "service trap", "drive by"),
                    description = c("visit type not record", "continued trapping", "trap ended at end of trap visit",
                                    "trap started during trap visit", "trap restarted during trap visit", "trap serviced",
                                    "trap checked visually by drive by, no catch processed")) |> 
  mutate(id = row_number())


# trap_functioning --------------------------------------------------------
trap_functioning <- tibble(definition = c("not recorded", "trap functioning normally", "trap stopped functioning", 
                                          "trap functioning but not normally", "trap not in service"),
                     description = c("trap function not recorded", "trap functioning normally","trap stopped functioning",
                                     "trap functioning but not normally","trap not in service")) |> 
  mutate(id = row_number())

# fish_processed ----------------------------------------------------------
fish_processed <- tibble(definition = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                        "no catch data, fish left in live box"),
                           description = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                           "no catch data, fish left in live box")) |> 
  mutate(id = row_number())


# debris_level ------------------------------------------------------------
debris_level <- tibble(definition = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                      "none"),
                         description = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                         "none")) |> 
  mutate(id = row_number())


# environmental_parameter -------------------------------------------------
environmental_parameter <- tibble(definition = c("temperature", "discharge"),
                                  description = c("mean daily water temperature in C", 
                                                  "mean daily discharge in C")) |> 
  mutate(id = row_number())



# gage_source -------------------------------------------------------------

gage_source <- tibble(definition = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                     "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                     "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000"),
                      description = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                      "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                      "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000")) |> 
  mutate(id = row_number())

# hatchery ----------------------------------------------------------------


# origin ------------------------------------------------------------------

origin <- tibble(definition = c("natural", "hatchery", "not recorded", "unknown", "mixed"),
                       description = c("wild fish used in release", "hatchery fish used in release", 
                                       "origin of fish used in release not recorded", "origin unknown",
                                       "both hatchery and wild fish used in release")) |> 
  mutate(id = row_number())

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
discharge <- filter(environmental_raw, parameter == "discharge") |> 
  select(-c(parameter, text)) |> 
  rename(discharge = value)
water_velocity <- filter(environmental_raw, parameter == "velocity") |> 
  select(-c(parameter, text)) |> 
  rename(water_velocity = value)
water_temp <- filter(environmental_raw, parameter == "temperature") |> 
  select(-c(parameter, text)) |> 
  rename(water_temp = value)
turbidity <- filter(environmental_raw, parameter == "turbidity") |> 
  select(-c(parameter, text)) |> 
  rename(turbidity = value)

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
  mutate(trap_visit_time_start = ymd_hms(paste(trap_start_date, trap_start_time)),
         trap_visit_time_end = ymd_hms(paste(trap_stop_date, trap_stop_time))) |> 
  select(-c(trap_start_time, trap_start_date, trap_stop_time, trap_stop_date)) |> 
 select(c(trap_location_id, visit_type_id, trap_visit_time_start, trap_visit_time_end,
            trap_functioning_id, in_half_cone_configuration, fish_processed_id,
            rpm_start, rpm_end, total_revolutions, debris_volume, debris_level_id,
            discharge, water_velocity, water_temp, turbidity, include))
         

# environmental_gage ------------------------------------------------------
gcs_get_object(object_name = "standard-format-data/standard_flow.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_flow.csv",
               overwrite = TRUE)
flow_raw <- read_csv("data/standard-format-data/standard_flow.csv")
flow <- flow_raw |> 
  left_join(trap_location, by = c("stream", "site")) |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  rename(value = flow_cfs, 
         gage = source) |> 
  mutate(parameter = "discharge") |> 
  left_join(environmental_parameter, by = c("parameter" = "definition")) |> 
  rename(parameter_id = id) |> 
  select(-parameter, -description) |> 
  left_join(gage_source, by = c("gage" = "definition")) |> 
  rename(gage_id = id) |> 
  select(-gage, -description)
  
gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_temperature.csv",
               overwrite = TRUE)
temperature_raw <- read_csv("data/standard-format-data/standard_temperature.csv")
temperature <- temperature_raw |> 
  filter(source != "RST environmental") |> 
  left_join(trap_location, by = c("stream", "site", "subsite")) |> 
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
  
environmental_gage <- bind_rows(flow, temperature)
# release_summary ---------------------------------------------------------

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
  mutate(date_released = ymd_hms(paste(date_released, time_released))) |> 
  select(-time_released) |> 
  left_join(trap_location, by = c("stream", "site", "subsite")) |> 
  select(-c(stream, site, subsite, site_group, description)) |> 
  rename(trap_location_id = id) |> 
  left_join(origin, by = c("origin_released" = "definition")) |> 
  rename(origin_id = id) |> 
  select(-origin_released, -description)

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
  
# hatchery_release --------------------------------------------------------
# need to figure out this one
gcs_get_object(object_name = "rst/RMIS_hatchery_release_Nov102022.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/standard_hatchery.csv",
               overwrite = TRUE)
hatchery_raw <- read_csv("data/standard-format-data/standard_hatchery.csv")
