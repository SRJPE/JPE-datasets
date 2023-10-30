# Script to generate lookup tables for db
# This only needs to be run once unless there are modifications
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)

f <- function(input, output) write_csv(input, file = output)
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
sacramento <- tibble(stream = c(rep("sacramento river",20)),
                     site = c(rep("knights landing",3), rep("tisdale",2), rep("red bluff diversion dam", 15)),
                     subsite = c("8.3", "8.4", "knights landing", "rr","rl",
                                 "gate 6", "gate 3", "gate 7", "gate 8", "gate 4", "gate 9", 
                                   "gate 5", "gate 2", "gate 1", "gate 11", "gate 10", "gate 6 e", 
                                   "gate 6 w", "gate 5 w", "gate 7 e"),
                     site_group = c(rep("knights landing",3) , rep("tisdale",2), rep("red bluff diversion dam", 15)),
                     description = c(rep("rst at knights landing",2), "rst location unknown", 
                                     "rst at river right", "rst at river left", rep("rst at red bluff diversion dam", 15))) 
trap_location <- bind_rows(battle, butte, clear, deer, feather, mill, yuba, sacramento) |> 
  mutate(id = row_number())

gcs_upload(trap_location,
           object_function = f,
           type = "csv",
           name = "model-db/trap_location.csv",
           predefinedAcl = "bucketLevel")

# run ---------------------------------------------------------------------
run <- tibble(definition = c("late fall", "spring", "fall", "winter", NA, "not recorded", "unknown"),
              description = c("chinook salmon categorized as late fall", "chinook salmon categorized as spring",
                              "chinook salmon categorized as fall", "chinook salmon categorized as winter",
                              "run listed as NA because count is 0", "run not recorded likely because length at date model does not apply",
                              "run recorded as unknown likely due to uncertainty in the field")) |> 
  mutate(id = row_number())

gcs_upload(run,
           object_function = f,
           type = "csv",
           name = "model-db/run.csv",
           predefinedAcl = "bucketLevel")

# lifestage ---------------------------------------------------------------
lifestage <- tibble(definition = c("smolt", "fry", "yolk sac fry", "not recorded", "parr", "silvery parr", 
                                   NA, "adult", "unknown", "yearling", "juvenile"),
                    description = c("smolt", "fry", "yolk sac fry", "lifestage not recorded", "parr", "silvery parr",
                                    "lifestage listed as NA because count is 0","adult","lifestage recorded as unknown",
                                    "lifestage recorded as yearling", "used for lifestage of fish in release trials")) |> 
  mutate(id = row_number())

gcs_upload(lifestage,
           object_function = f,
           type = "csv",
           name = "model-db/lifestage.csv",
           predefinedAcl = "bucketLevel")

# visit_type --------------------------------------------------------------
visit_type <- tibble(definition = c("not recorded", "continue trapping", "end trapping", "start trapping", 
                                    "unplanned restart", "service trap", "drive by"),
                     description = c("visit type not record", "continued trapping", "trap ended at end of trap visit",
                                     "trap started during trap visit", "trap restarted during trap visit", "trap serviced",
                                     "trap checked visually by drive by, no catch processed")) |> 
  mutate(id = row_number())

gcs_upload(visit_type,
           object_function = f,
           type = "csv",
           name = "model-db/visit_type.csv",
           predefinedAcl = "bucketLevel")

# trap_functioning --------------------------------------------------------
trap_functioning <- tibble(definition = c("not recorded", "trap functioning normally", "trap stopped functioning", 
                                          "trap functioning but not normally", "trap not in service"),
                           description = c("trap function not recorded", "trap functioning normally","trap stopped functioning",
                                           "trap functioning but not normally","trap not in service")) |> 
  mutate(id = row_number())
gcs_upload(trap_functioning,
           object_function = f,
           type = "csv",
           name = "model-db/trap_functioning.csv",
           predefinedAcl = "bucketLevel")

# fish_processed ----------------------------------------------------------
fish_processed <- tibble(definition = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                        "no catch data, fish left in live box"),
                         description = c("not recorded", "processed fish", "no fish caught", "no catch data, fish released", 
                                         "no catch data, fish left in live box")) |> 
  mutate(id = row_number())
gcs_upload(fish_processed,
           object_function = f,
           type = "csv",
           name = "model-db/fish_processed.csv",
           predefinedAcl = "bucketLevel")


# debris_level ------------------------------------------------------------
debris_level <- tibble(definition = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                      "none"),
                       description = c("not recorded", NA, "light", "medium", "heavy", "very heavy", 
                                       "none")) |> 
  mutate(id = row_number())
gcs_upload(debris_level,
           object_function = f,
           type = "csv",
           name = "model-db/debris_level.csv",
           predefinedAcl = "bucketLevel")


# environmental_parameter -------------------------------------------------
environmental_parameter <- tibble(definition = c("temperature", "discharge"),
                                  description = c("mean daily water temperature in C", 
                                                  "mean daily discharge in C")) |> 
  mutate(id = row_number())
gcs_upload(environmental_parameter,
           object_function = f,
           type = "csv",
           name = "model-db/environmental_parameter.csv",
           predefinedAcl = "bucketLevel")

# gage_source -------------------------------------------------------------

gage_source <- tibble(definition = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                     "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                     "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000"),
                      description = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                      "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                      "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000")) |> 
  mutate(id = row_number())
gcs_upload(gage_source,
           object_function = f,
           type = "csv",
           name = "model-db/gage_source.csv",
           predefinedAcl = "bucketLevel")

# hatchery ----------------------------------------------------------------
hatchery <- tibble(definition = c("FEATHER R HATCHERY", "COLEMAN NFH", "LIVINGSTON STONE HAT", 
                                  "NIMBUS FISH HATCHERY", "TEHAMA-COLUSA FF"),
                   description = c("FEATHER R HATCHERY", "COLEMAN NFH", "LIVINGSTON STONE HAT", 
                                   "NIMBUS FISH HATCHERY", "TEHAMA-COLUSA FF")) |> 
  mutate(id = row_number())
gcs_upload(hatchery,
           object_function = f,
           type = "csv",
           name = "model-db/hatchery.csv",
           predefinedAcl = "bucketLevel")

# origin ------------------------------------------------------------------

origin <- tibble(definition = c("natural", "hatchery", "not recorded", "unknown", "mixed"),
                 description = c("wild fish used in release", "hatchery fish used in release", 
                                 "origin of fish used in release not recorded", "origin unknown",
                                 "both hatchery and wild fish used in release")) |> 
  mutate(id = row_number())
gcs_upload(origin,
           object_function = f,
           type = "csv",
           name = "model-db/origin.csv",
           predefinedAcl = "bucketLevel")
write_csv(origin, "data/model-db/origin.csv")