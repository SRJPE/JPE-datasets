# This script can be used to prepare historical data for the jpe-model-db
library(googleCloudStorageR)
library(tidyverse)

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

# catch -------------------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)
catch_raw <- read_csv("data/model-data/daily_catch_unmarked.csv")


# trap --------------------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/daily_trap.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_trap.csv",
               overwrite = TRUE)
trap_raw <- read_csv("data/model-data/daily_trap.csv")
dput(unique(trap_raw$visit_type))

