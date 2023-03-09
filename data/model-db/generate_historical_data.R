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
                 description = c("upper battle creek rst site location")) 
butte <- tibble(stream = c(rep("butte creek", 5)),
                site = c(rep("okie dam",4), "adams dam"),
                subsite = c("okie dam 1", "okie dam 2", "okie dam fyke trap", NA, "adams dam"),
                site_group = c("butte creek"),
                description = c("rst 1 at okie dam (aka parrott-phalean)", "rst 2 at okie dam (aka parrott-phalean)",
                                "fyke trap at okie dam located in diversion canal", "trap unknown", 
                                "rst at adams dam, only used historically")) 
clear <- tibble(stream = c(rep("clear creek",2)),
                site = c("lcc", "ucc"),
                subsite = c("lcc", "ucc"),
                site_group = c("clear creek"),
                description = c("lower clear creek rst site", "upper clear creek rst site")) 
deer <- tibble(stream = c("deer creek"),
               site = c("deer creek"),
               subsite = c("deer creek"),
               site_group = c("deer creek"),
               description = c("deer creek rst site location")) 
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
                                  rep("low flow channel rst sites",4), "rst at river right", "rst at river left")) 
mill <- tibble(stream = c("mill creek"),
               site = c("mill creek"),
               subsite = c("mill creek"),
               site_group = c("mill creek"),
               description = c("mill creek rst site location")) 
yuba <- tibble(stream = c(rep("yuba river",4)),
               site = c("yuba river", rep("hallwood",3)),
               subsite = c("yub","hal","hal2","hal3"),
               site_group = c("yuba river"),
               description = c("rst at yuba river, only used historically", 
                               "rst 1 at hallwood", "rst 2 at hallwood", "rst 3 at hallwood")) 
sacramento <- tibble(stream = c(rep("sacramento river",5)),
                     site = c(rep("knights landing",3), rep("tisdale",2)),
                     subsite = c("8.3", "8.4", "knights landing", "rr","rl"),
                     site_group = c(rep("knights landing",3) , rep("tisdale",2)),
                     description = c(rep("rst at knights landing",2), "rst location unknown", 
                                     "rst at river right", "rst at river left")) 
trap_location <- bind_rows(battle, butte, clear, deer, feather, mill, yuba, sacramento) |> 
  mutate(id = row_number())
write_csv(trap_location, "data/model-db/trap_location.csv")


# run ---------------------------------------------------------------------
run <- tibble(definition = c("late fall", "spring", "fall", "winter", NA, "not recorded", "unknown"),
              description = c("chinook salmon categorized as late fall", "chinook salmon categorized as spring",
                              "chinook salmon categorized as fall", "chinook salmon categorized as winter",
                              "run listed as NA because count is 0", "run not recorded likely because length at date model does not apply",
                              "run recorded as unknown likely due to uncertainty in the field")) |> 
  mutate(id = row_number())

write_csv(run, "data/model-db/run.csv")
# lifestage ---------------------------------------------------------------
lifestage <- tibble(definition = c("smolt", "fry", "yolk sac fry", "not recorded", "parr", "silvery parr", 
                                   NA, "adult", "unknown", "yearling", "juvenile"),
              description = c("smolt", "fry", "yolk sac fry", "lifestage not recorded", "parr", "silvery parr",
                              "lifestage listed as NA because count is 0","adult","lifestage recorded as unknown",
                              "lifestage recorded as yearling", "used for lifestage of fish in release trials")) |> 
  mutate(id = row_number())
write_csv(lifestage, "data/model-db/lifestage.csv")
# visit_type --------------------------------------------------------------
visit_type <- tibble(definition = c("not recorded", "continue trapping", "end trapping", "start trapping", 
                                    "unplanned restart", "service trap", "drive by"),
                    description = c("visit type not record", "continued trapping", "trap ended at end of trap visit",
                                    "trap started during trap visit", "trap restarted during trap visit", "trap serviced",
                                    "trap checked visually by drive by, no catch processed")) |> 
  mutate(id = row_number())

write_csv(visit_type, "data/model-db/visit_type.csv")
# trap_functioning --------------------------------------------------------
trap_functioning <- tibble(definition = c("not recorded", "trap functioning normally", "trap stopped functioning", 
                                          "trap functioning but not normally", "trap not in service"),
                     description = c("trap function not recorded", "trap functioning normally","trap stopped functioning",
                                     "trap functioning but not normally","trap not in service")) |> 
  mutate(id = row_number())
write_csv(trap_functioning, "data/model-db/trap_functioning.csv")
# fish_processed ----------------------------------------------------------
fish_processed <- tibble(definition = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                        "no catch data, fish left in live box"),
                           description = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                           "no catch data, fish left in live box")) |> 
  mutate(id = row_number())
write_csv(fish_processed, "data/model-db/fish_processed.csv")

# debris_level ------------------------------------------------------------
debris_level <- tibble(definition = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                      "none"),
                         description = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                         "none")) |> 
  mutate(id = row_number())
write_csv(debris_level, "data/model-db/debris_level.csv")

# environmental_parameter -------------------------------------------------
environmental_parameter <- tibble(definition = c("temperature", "discharge"),
                                  description = c("mean daily water temperature in C", 
                                                  "mean daily discharge in C")) |> 
  mutate(id = row_number())
write_csv(environmental_parameter, "data/model-db/environmental_parameter.csv")


# gage_source -------------------------------------------------------------

gage_source <- tibble(definition = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                     "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                     "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000"),
                      description = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                      "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                      "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000")) |> 
  mutate(id = row_number())
write_csv(gage_source, "data/model-db/gage_source.csv")
# hatchery ----------------------------------------------------------------
hatchery <- tibble(definition = c("FEATHER R HATCHERY", "COLEMAN NFH", "LIVINGSTON STONE HAT", 
                                  "NIMBUS FISH HATCHERY", "TEHAMA-COLUSA FF"),
                      description = c("FEATHER R HATCHERY", "COLEMAN NFH", "LIVINGSTON STONE HAT", 
                                      "NIMBUS FISH HATCHERY", "TEHAMA-COLUSA FF")) |> 
  mutate(id = row_number())
write_csv(hatchery, "data/model-db/hatchery.csv")
# origin ------------------------------------------------------------------

origin <- tibble(definition = c("natural", "hatchery", "not recorded", "unknown", "mixed"),
                       description = c("wild fish used in release", "hatchery fish used in release", 
                                       "origin of fish used in release not recorded", "origin unknown",
                                       "both hatchery and wild fish used in release")) |> 
  mutate(id = row_number())
write_csv(origin, "data/model-db/origin.csv")
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

unique(catch$trap_location_id)
unique(catch$lifestage_id)
unique(catch$run_id)

write_csv(catch, "data/model-db/catch.csv")
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

write_csv(trap, "data/model-db/trap_visit.csv")
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
write_csv(environmental_gage, "data/model-db/environmental_gage.csv")
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
  select(-c(stream, site, subsite, site_group, description)) |> 
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
write_csv(release_summary, "data/model-db/release_summary.csv")
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

write_csv(recaptured_fish, "data/model-db/recaptured_fish.csv")
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
write_csv(hatchery_release, "data/model-db/hatchery_release.csv")
