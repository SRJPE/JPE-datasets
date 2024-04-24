# Script to generate lookup tables for db
# This only needs to be run once unless there are modifications
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)

f <- function(input, output) write_csv(input, file = output)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# trap_location -----------------------------------------------------------

battle <- tibble(stream = c("battle creek","battle creek", "battle creek", "battle creek", "battle creek"),
                 site = c("ubc", "ubc", "lbc", "powerhouse",NA),
                 subsite = c("ubc", NA, "lbc","powerhouse", NA),
                 site_group = c("battle creek"),
                 description = c("upper battle creek rst site location", 
                                 "upper battle creek rst site location and subsite is
                                 not associated with release location",
                                 "lower battle creek rst site location",
                                 "powerhouse battle creek rst site loction",
                                 "site is not recorded")) 
butte <- tibble(stream = c(rep("butte creek", 5)),
                site = c(rep("okie dam",4), "adams dam"),
                subsite = c("okie dam 1", "okie dam 2", "okie dam fyke trap", NA, "adams dam"),
                site_group = c("butte creek"),
                description = c("rst 1 at okie dam (aka parrott-phalean)", "rst 2 at okie dam (aka parrott-phalean)",
                                "fyke trap at okie dam located in diversion canal", "trap unknown or okie dam site and subsite is not associated with release location",
                                "rst at adams dam only used historically")) 
clear <- tibble(stream = c(rep("clear creek",5)),
                site = c("lcc", "ucc", "not recorded", "lcc", "ucc"),
                subsite = c("lcc", "ucc", NA, NA, NA),
                site_group = c("clear creek"),
                description = c("lower clear creek rst site", "upper clear creek rst site",
                                "site not recorded during release trial", "lower clear creek rst site and subsite is not associated with release location",
                                "upper clear creek rst site and subsite is not associated with release location")) 
deer <- tibble(stream = c("deer creek", "deer creek"),
               site = c("deer creek", "deer creek"),
               subsite = c("deer creek", NA),
               site_group = c("deer creek"),
               description = c("deer creek rst site location",
                               "deer creek rst site location and subsite is not associated with release location")) 
feather <- tibble(stream = c(rep("feather river",26)),
                  site = c(rep("eye riffle",3), rep("live oak",2), rep("herringer riffle",4), rep("steep riffle",4), 
                           rep("sunset pumps",3), rep("shawn's beach",2), rep("gateway riffle",5), 
                           rep("lower feather river",3)),
                  subsite = c("eye riffle_north", "eye riffle_side channel", NA,
                              "live oak", NA,
                              "herringer_west", "herringer_east", "herringer_upper_west", NA,
                              "#steep riffle_rst", "steep riffle_10' ext", "steep side channel", NA,
                              "sunset west bank", "sunset east bank", NA,
                              "shawns_west", "shawns_east",
                              "gateway_main1", "gateway main 400' up river", "gateway_rootball", 
                              "gateway_rootball_river_left", NA, 
                              "rr", "rl", NA),
                  site_group = c(rep("upper feather lfc",3), rep("upper feather hfc", 6),
                                 rep("upper feather lfc",4), rep("upper feather hfc", 5),
                                 rep("upper feather lfc",5), rep("lower feather river",3)),
                  description = c(rep("low flow channel rst sites",2), "low flow channel rst sites and subsite is not associated with release location",
                                  rep("high flow channel rst sites", 1), "high flow channel rst sites and subsite is not associated with release location",
                                  rep("high flow channel rst sites", 3), "high flow channel rst sites and subsite is not associated with release location",
                                  rep("low flow channel rst sites",3), "low flow channel rst sites and subsite is not associated with release location",
                                  rep("high flow channel rst sites", 2),"high flow channel rst sites and subsite is not associated with release location",
                                  rep("high flow channel rst sites", 2),
                                  rep("low flow channel rst sites",4), "low flow channel rst sites and subsite is not associated with release location",
                                  "rst at river right", "rst at river left", "lower feather and subsite is not associated with release location")) 
mill <- tibble(stream = c("mill creek", "mill creek"),
               site = c("mill creek", "mill creek"),
               subsite = c("mill creek", NA),
               site_group = c("mill creek"),
               description = c("mill creek rst site location",
                               "mill creek rst site location and subsite is not associated with release location")) 
yuba <- tibble(stream = c(rep("yuba river",5)),
               site = c("yuba river", rep("hallwood",4)),
               subsite = c("yub","hal","hal2","hal3", NA),
               site_group = c("yuba river"),
               description = c("rst at yuba river, only used historically", 
                               "rst 1 at hallwood", "rst 2 at hallwood", "rst 3 at hallwood",
                               "hallwood rst site location and subsite is not associated with release location")) 
sacramento <- tibble(stream = c(rep("sacramento river",23)),
                     site = c(rep("knights landing",4), rep("tisdale",3), rep("red bluff diversion dam", 16)),
                     subsite = c("8.3", "8.4", "knights landing", NA, 
                                 "rr","rl", NA,
                                 "gate 6", "gate 3", "gate 7", "gate 8", "gate 4", "gate 9", 
                                   "gate 5", "gate 2", "gate 1", "gate 11", "gate 10", "gate 6 e", 
                                   "gate 6 w", "gate 5 w", "gate 7 e", NA),
                     site_group = c(rep("knights landing",4) , rep("tisdale",3), rep("red bluff diversion dam", 16)),
                     description = c(rep("rst at knights landing",2), "rst location unknown", 
                                     "knights landing rst site location and subsite is not associated with release location",
                                     "rst at river right", "rst at river left",
                                     "tisdale rst site location and subsite is not associated with release location",
                                     rep("rst at red bluff diversion dam", 15),
                                     "red bluff rst site location and subsite is not associated with release location")) 
trap_location <- bind_rows(battle, butte, clear, deer, feather, mill, yuba, sacramento) |> 
  mutate(id = row_number())

gcs_upload(trap_location,
           object_function = f,
           type = "csv",
           name = "model-db/trap_location.csv",
           predefinedAcl = "bucketLevel")


# survey_location ---------------------------------------------------------
# daily_redd_raw |>  
#   filter(stream == "battle creek") |> 
#   group_by(reach) |> 
#   tally()
# holding_raw |>  
#   filter(stream == "battle creek") |> 
#   group_by(reach) |> 
#   tally()
battle_s <- tibble(stream = rep("battle creek",8),
                   reach = c("R1", "R2", "R3", "R4", "R5", "R6", "R7", NA),
                   description = c("R1", "R2", "R3", "R4", "R5", "R6", "R7", NA)
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   )
# ck <- holding_raw |>
#   filter(stream == "butte creek") |>
#   group_by(reach) |>
#   tally()
# dput(ck$reach)
butte_s <- tibble(stream = rep("butte creek",46),
                   reach = c("A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", 
                             "B6", "B7", "B8", "BCK-PWL", "C1", "C10", "C11", "C12", "C2", 
                             "C3", "C4", "C5", "C6", "C7", "C8", "C9", "COV-BCK", "D1", "D2", 
                             "D3", "D4", "D5", "D6", "D7", "D8", "E1", "E2", "E3", "E4", "E5", 
                             "E6", "E7", "F", "G", "PWL-PPD", NA),
                   description = c("A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", 
                                   "B6", "B7", "B8", "BCK-PWL", "C1", "C10", "C11", "C12", "C2", 
                                   "C3", "C4", "C5", "C6", "C7", "C8", "C9", "COV-BCK", "D1", "D2", 
                                   "D3", "D4", "D5", "D6", "D7", "D8", "E1", "E2", "E3", "E4", "E5", 
                                   "E6", "E7", "F", "G", "PWL-PPD", NA)
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
)
# daily_redd_raw |>
#   filter(stream == "clear creek") |>
#   group_by(reach) |>
#   tally()
# holding_raw |>
#   filter(stream == "clear creek") |>
#   group_by(reach) |>
#   tally()
clear_s <- tibble(stream = rep("clear creek",8),
                   reach = c("R1", "R2", "R4", "R3", "R5", "R6A","R7", NA),
                   description = c("R1", "R2", "R4", "R3", "R5", "R6A","R7", NA)
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
)

# ck <- holding_raw |>
#   filter(stream == "deer creek") |>
#   group_by(reach) |>
#   tally()
# dput(ck$reach)
deer_s <- tibble(stream = rep("deer creek",12),
                  reach = c("A Line to Wilson Cove", "Highway 32 (Red Bridge) to Lower Falls", 
                            "Lower Falls to A Line", "Murphy Trail to Ponderosa Way", "Polk Springs to Murphy Trail", 
                            "Ponderosa Way to Moak Cove", "Ponderosa Way to Trail 2E17", 
                            "Potato Patch Camp to Highway 32 (Red Bridge)", "Trail 2E17 to Dillon Cove", 
                            "Upper Falls to Potato Patch Camp", "Wilson Cove to Polk Springs", NA
                  ),
                  description = c("A Line to Wilson Cove", "Highway 32 (Red Bridge) to Lower Falls", 
                                  "Lower Falls to A Line", "Murphy Trail to Ponderosa Way", "Polk Springs to Murphy Trail", 
                                  "Ponderosa Way to Moak Cove", "Ponderosa Way to Trail 2E17", 
                                  "Potato Patch Camp to Highway 32 (Red Bridge)", "Trail 2E17 to Dillon Cove", 
                                  "Upper Falls to Potato Patch Camp", "Wilson Cove to Polk Springs", NA
                  )
                  # north_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
                  # east_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
)
# ck <- daily_redd_raw |>
#   filter(stream == "feather river") |>
#   group_by(reach) |>
#   tally()
# dput(ck$reach)
feather_s <- tibble(stream = rep("feather river",33),
                  reach = c("1", "10", "11", "12", "14", "15", "16", "17", "18", "19", 
                            "20", "21", "22", "23", "24", "25", "27", "29", "3", "31", "32", 
                            "33", "34", "35", "36", "37", "4", "5", "6", "7", "8", "historical reach - no description", 
                            NA),
                  description = c("1", "10", "11", "12", "14", "15", "16", "17", "18", "19", 
                                  "20", "21", "22", "23", "24", "25", "27", "29", "3", "31", "32", 
                                  "33", "34", "35", "36", "37", "4", "5", "6", "7", "8", "historical reach - no description", 
                                  NA)
                  # north_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
                  # east_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
)
# ck <- daily_redd_raw |>
#   filter(stream == "mill creek") |>
#   group_by(reach) |>
#   tally()
# dput(ck$reach)

mill_s <- tibble(stream = rep("mill creek",16),
                  reach = c("Above Avery To Pape Place", "Above Hwy 36", "Below Ranch House To Above Avery", 
                            "Big Bend To Canyon Camp", "Black Rock To Below Ranch House", 
                            "Buckhorn Gulch To Upper Dam", "Canyon Camp To Sooner Place", 
                            "Hole In Ground To Ishi Trail Head", "Hwy 36 To Little Hole In Ground", 
                            "Ishi Trail Head To Big Bend", "Litte Hole In Ground To Hole In Ground", 
                            "Mccarthy Place To Savercool Place", "Pape Place To Buckhorn Gulch", 
                            "Savercool Place  To Black Rock", "Sooner Place To Mccarthy Place", NA
                  ),
                  description = c("Above Avery To Pape Place", "Above Hwy 36", "Below Ranch House To Above Avery", 
                                  "Big Bend To Canyon Camp", "Black Rock To Below Ranch House", 
                                  "Buckhorn Gulch To Upper Dam", "Canyon Camp To Sooner Place", 
                                  "Hole In Ground To Ishi Trail Head", "Hwy 36 To Little Hole In Ground", 
                                  "Ishi Trail Head To Big Bend", "Litte Hole In Ground To Hole In Ground", 
                                  "Mccarthy Place To Savercool Place", "Pape Place To Buckhorn Gulch", 
                                  "Savercool Place  To Black Rock", "Sooner Place To Mccarthy Place", NA
                  )
                  # north_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
                  # east_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
)

yuba_s <- tibble(stream = rep("yuba river",1),
                 reach = c(NA),
                 description = c(NA)
                 # north_bounding_coordinate = ,
                 # south_bounding_coordinate = ,
                 # east_bounding_coordinate = ,
                 # south_bounding_coordinate = ,
)

survey_location <- bind_rows(battle_s, butte_s, clear_s, deer_s, feather_s, mill_s, yuba_s) |> 
  mutate(id = row_number())

gcs_upload(survey_location,
           object_function = f,
           type = "csv",
           name = "model-db/survey_location.csv",
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

# sex ---------------------------------------------------------------------
sex <- tibble(definition = c("male", "female", "unknown", "not recorded"),
                    description = c("male", "female", "sex is unknown", "sex not recorded")) |> 
  mutate(id = row_number())

gcs_upload(sex,
           object_function = f,
           type = "csv",
           name = "model-db/sex.csv",
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
fish_processed <- tibble(definition = c("not recorded", "processed fish", "no fish caught", "no catch data and fish released", 
                                        "no catch data and fish left in live box"),
                         description = c("not recorded", "processed fish", "no fish caught", "no catch data and fish released", 
                                         "no catch data and fish left in live box")) |> 
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
                                     "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000",
                                     "CDEC FBS", "USGS 11377100"),
                      description = c("FWS", "CDEC BCK", "CDEC DCV", "CDEC MLM", 
                                      "USGS 11390500", "USGS 11376550", "USGS 11372000", "USGS 11383500", 
                                      "CDEC GRL", "USGS 11407000", "USGS 11381500", "USGS 11421000",
                                      "CDEC FBS", "USGS 11377100")) |> 
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

# direction -------------------------------------------------------
direction <- tibble(definition = c("up", "down", "not recorded"),
                 description = c("passage up to spawning grounds", "passage down 
                                 and should be removed from passage count", 
                                 "direction not recorded")) |> 
  mutate(id = row_number())
gcs_upload(direction,
           object_function = f,
           type = "csv",
           name = "model-db/direction.csv",
           predefinedAcl = "bucketLevel")


# method ------------------------------------------------------------------
# method <- tibble(definition = c("maximum yearly redd count", "summed by redd id"),
#                     description = c("","")) |> 
#   mutate(id = row_number())
# gcs_upload(method,
#            object_function = f,
#            type = "csv",
#            name = "model-db/method.csv",
#            predefinedAcl = "bucketLevel")

