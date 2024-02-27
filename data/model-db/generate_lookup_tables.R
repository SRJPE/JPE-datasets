# Script to generate lookup tables for db
# This only needs to be run once unless there are modifications
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)

f <- function(input, output) write_csv(input, file = output)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# trap_location -----------------------------------------------------------

battle <- tibble(stream = c("battle creek","battle creek", "battle creek"),
                 site = c("ubc", "ubc", "lbc"),
                 subsite = c("ubc", NA, "lbc"),
                 site_group = c("battle creek"),
                 description = c("upper battle creek rst site location", 
                                 "upper battle creek rst site location and subsite is
                                 not associated with release location",
                                 "lower battle creek rst site location")) 
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

battle_s <- tibble(stream = rep("battle creek",18),
                   reach = c("R2", "R3", "R7", "R1", "R4", "R5", "R6", "4", "1", "2", "5", 
                             "3", "R1B", "R12", NA, "CNFH", "Nevis Creek", "Tailrace"),
                   description = c("R2", "R3", "R7", "R1", "R4", "R5", "R6", "4", "1", "2", "5", 
                                   "3", "R1B", "R12", NA, "CNFH", "Nevis Creek", "Tailrace")
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   )

butte_s <- tibble(stream = rep("butte creek",69),
                   reach = c("A1", "A2", "A3", "A4", "A5", "Chimney", "Quartz", "B1", "B2", 
                             "B3", "B4", "B5", "B6", "B7", "B8", "C1", "C2", "C4", "C5", "C10", 
                             "C11", "C12", "C6", "C7", "C8", "C9", "D1", "D3", "D4", "D5", 
                             "D7", "E1", "E2", "E4", "E5", "E6", "Quartz 2", "Quartz 3", "C3", 
                             "C5-C12", "D1-D4", "D6", "D2", "D8", "E7", "C5b", "E3", "C5a", 
                             "BCK-PL", "Cov-BCK", "PL-OKIE", "Below PPD", "below Skyway-99", 
                             "HWY 99 -OROCHICO", "COV-BLK", "COV-BCK", "BCK-PWL", "PWL-OKIE", 
                             "C-B", "B-P", "P-O", "COV-OKIE", "BCK-PWR", NA, "BLK-PL", "COVER-PTR", 
                             "PH-PWL", "PWR-OKI", "CO1"),
                   description = c("A1", "A2", "A3", "A4", "A5", "Chimney", "Quartz", "B1", "B2", 
                                   "B3", "B4", "B5", "B6", "B7", "B8", "C1", "C2", "C4", "C5", "C10", 
                                   "C11", "C12", "C6", "C7", "C8", "C9", "D1", "D3", "D4", "D5", 
                                   "D7", "E1", "E2", "E4", "E5", "E6", "Quartz 2", "Quartz 3", "C3", 
                                   "C5-C12", "D1-D4", "D6", "D2", "D8", "E7", "C5b", "E3", "C5a", 
                                   "BCK-PL", "Cov-BCK", "PL-OKIE", "Below PPD", "below Skyway-99", 
                                   "HWY 99 -OROCHICO", "COV-BLK", "COV-BCK", "BCK-PWL", "PWL-OKIE", 
                                   "C-B", "B-P", "P-O", "COV-OKIE", "BCK-PWR", NA, "BLK-PL", "COVER-PTR", 
                                   "PH-PWL", "PWR-OKI", "CO1")
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
)

clear_s <- tibble(stream = rep("clear creek",15),
                   reach = c("R1", "R2", "R4", "R3", "R5", "R5A", "R5B", "R5C", "R5A (Above UCC)", "R5A (Below UCC)",
                             "R6", "R6B", "R7", 
                             "R6A", NA),
                   description = c("R1", "R2", "R4", "R3", "R5", "R5A", "R5B", "R5C", "R5A (Above UCC)", "R5A (Below UCC)",
                                   "R6", "R6B", "R7", 
                                   "R6A", NA)
                   # north_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
                   # east_bounding_coordinate = ,
                   # south_bounding_coordinate = ,
)

deer_s <- tibble(stream = rep("deer creek",20),
                  reach = c("Hwy 32 To A Line", "Lower Falls To A Line", "Upper Falls To Potato Patch", 
                            "Potato Patch To Hwy 32", "Hwy 32 To Lower Falls", "A Line To Wilson", 
                            "Wilson To Polk Springs", "Polk Springs To Murphy", "Murphy To Beaver", 
                            "Beaver To Ponderosa", "Ponderosa To Homestead", "Homestead To 2e17", 
                            "Potato Patch To Lower Falls", "A Line To Wilson Cove", "Wilson Cove To Polk Springs", 
                            "Polk Springs To Murphy Trail", "Murphy Trail To Ponderosa Way", 
                            "Ponderosa Way To Trail 2e17", "Trail 2e17 To Dillon Cove", NA),
                  description = c("Hwy 32 To A Line", "Lower Falls To A Line", "Upper Falls To Potato Patch", 
                                  "Potato Patch To Hwy 32", "Hwy 32 To Lower Falls", "A Line To Wilson", 
                                  "Wilson To Polk Springs", "Polk Springs To Murphy", "Murphy To Beaver", 
                                  "Beaver To Ponderosa", "Ponderosa To Homestead", "Homestead To 2e17", 
                                  "Potato Patch To Lower Falls", "A Line To Wilson Cove", "Wilson Cove To Polk Springs", 
                                  "Polk Springs To Murphy Trail", "Murphy Trail To Ponderosa Way", 
                                  "Ponderosa Way To Trail 2e17", "Trail 2e17 To Dillon Cove", NA)
                  # north_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
                  # east_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
)

feather_s <- tibble(stream = rep("feather river",170),
                  reach = c("Table Mountain", "Cottonwood", "Moes Ditch", "Hatchery Riffle", 
                            "Lower Auditorium", "Bedrock", "Trailer Park", "Mathews", "Aleck", 
                            "Upper Robinson", "Lower Robinson", "Steep", "Eye", "Gateway", 
                            "Hatchery Ditch", "Hatchery Pipe", "Upper Auditorium", "Mid Auditorium", 
                            "Weir", "Top Of Auditorium", "Moes Side Channel", "Below Lower Auditorium", 
                            "Eye Riffle", "Weir Riffle", "Steep Side Channel", "Steep Riffle", 
                            "Auditorium", "Robinson", "Below Auditorium", "Upper Bedrock", 
                            "Lower Bedrock", "Upper Mathews", "Upper Aleck", "Middle Robinson", 
                            "Top Of Steep", "Vance West", "Vance East", "Big Hole East", 
                            "G95 Side Channel", "G95 East Side Channel Top", "G95", "G95 Main Bottom", 
                            "Upper Hour", "Lower Hour", "Keister Riffle", "Goose Riffle", 
                            "Big Riffle", "Big Bar", "Upper McFarland", "Upper Vance East", 
                            "Lower Table Mountain", "Upper Moes Side Channel", "Upper Moes Channel", 
                            "Upper Hatchery", "Lower Hatchery", "Lower Gateway", "Eye Side Channel", 
                            "Upper Vance", "Big Hole West", "Below Big Hole East", "G95 West Side Channel", 
                            "Top Of Hour", "Mid Hour", "Palm", "Keister", "Goose", "Big", 
                            "Below Big Bar", "Lower McFarland", "Developing", "G95 East Side Channel Bottom", 
                            "Lower Vance East", "Mid Vance East", "Top Vance East", "Upper Steep", 
                            "Top of Mathews", "Below Weir", "G95 Main", "G95 East Side Channel", 
                            "Lower Hatchery Ditch", "Upper Hatchery Riffle", "Top Of Moes Ditch", 
                            "Lower Moes Ditch", "Lower Steep Side Channel", "Lower Hatchery Riffle", 
                            "Upper Moes Ditch", "Upper Hatchery Ditch", "Upper Trailer Park", 
                            "Lower Trailer Park", "Thermalito", "Top Big Hole East", "G95 West Side Channel Top", 
                            "G95 Main Top", "G95 East Side Channel Mid", "Top Vance West", 
                            "Below Big Hole", "Top Keister", "Top Big River Right", "Big River Left", 
                            "Lower Big Bar", "Mid McFarland", "Developing Riffle", "Hour Glide", 
                            "Keister Top", "Upper Cottonwood", "Upper Hour East", "Hatchery", 
                            "Hatchery Side Channel", "Hour", "G95 West Side Channel Bottom", 
                            "Great Western", "Top Of Hatchery", "Lower Big Riffle", NA, "High Flow", 
                            "Bedrock Riffle", "Aleck Riffle", "Gateway Side Channel", "Gateway Main Channel", 
                            "Palm Riffle", "1", "2", "3", "4", "8", "7", "6", "5", "10", 
                            "13", "14", "15", "17", "18", "19", "20", "43", "45", "42", "9", 
                            "11", "12", "16", "25", "29", "33", "32", "39", "40", "41", "26", 
                            "38", "30", "36", "22", "23", "24", "28", "37", "46", "27", "31", 
                            "47", "44", "35", "48", "34", "21", "50", "0"),
                  description = c("Table Mountain", "Cottonwood", "Moes Ditch", "Hatchery Riffle", 
                                  "Lower Auditorium", "Bedrock", "Trailer Park", "Mathews", "Aleck", 
                                  "Upper Robinson", "Lower Robinson", "Steep", "Eye", "Gateway", 
                                  "Hatchery Ditch", "Hatchery Pipe", "Upper Auditorium", "Mid Auditorium", 
                                  "Weir", "Top Of Auditorium", "Moes Side Channel", "Below Lower Auditorium", 
                                  "Eye Riffle", "Weir Riffle", "Steep Side Channel", "Steep Riffle", 
                                  "Auditorium", "Robinson", "Below Auditorium", "Upper Bedrock", 
                                  "Lower Bedrock", "Upper Mathews", "Upper Aleck", "Middle Robinson", 
                                  "Top Of Steep", "Vance West", "Vance East", "Big Hole East", 
                                  "G95 Side Channel", "G95 East Side Channel Top", "G95", "G95 Main Bottom", 
                                  "Upper Hour", "Lower Hour", "Keister Riffle", "Goose Riffle", 
                                  "Big Riffle", "Big Bar", "Upper McFarland", "Upper Vance East", 
                                  "Lower Table Mountain", "Upper Moes Side Channel", "Upper Moes Channel", 
                                  "Upper Hatchery", "Lower Hatchery", "Lower Gateway", "Eye Side Channel", 
                                  "Upper Vance", "Big Hole West", "Below Big Hole East", "G95 West Side Channel", 
                                  "Top Of Hour", "Mid Hour", "Palm", "Keister", "Goose", "Big", 
                                  "Below Big Bar", "Lower McFarland", "Developing", "G95 East Side Channel Bottom", 
                                  "Lower Vance East", "Mid Vance East", "Top Vance East", "Upper Steep", 
                                  "Top of Mathews", "Below Weir", "G95 Main", "G95 East Side Channel", 
                                  "Lower Hatchery Ditch", "Upper Hatchery Riffle", "Top Of Moes Ditch", 
                                  "Lower Moes Ditch", "Lower Steep Side Channel", "Lower Hatchery Riffle", 
                                  "Upper Moes Ditch", "Upper Hatchery Ditch", "Upper Trailer Park", 
                                  "Lower Trailer Park", "Thermalito", "Top Big Hole East", "G95 West Side Channel Top", 
                                  "G95 Main Top", "G95 East Side Channel Mid", "Top Vance West", 
                                  "Below Big Hole", "Top Keister", "Top Big River Right", "Big River Left", 
                                  "Lower Big Bar", "Mid McFarland", "Developing Riffle", "Hour Glide", 
                                  "Keister Top", "Upper Cottonwood", "Upper Hour East", "Hatchery", 
                                  "Hatchery Side Channel", "Hour", "G95 West Side Channel Bottom", 
                                  "Great Western", "Top Of Hatchery", "Lower Big Riffle", NA, "High Flow", 
                                  "Bedrock Riffle", "Aleck Riffle", "Gateway Side Channel", "Gateway Main Channel", 
                                  "Palm Riffle", "1", "2", "3", "4", "8", "7", "6", "5", "10", 
                                  "13", "14", "15", "17", "18", "19", "20", "43", "45", "42", "9", 
                                  "11", "12", "16", "25", "29", "33", "32", "39", "40", "41", "26", 
                                  "38", "30", "36", "22", "23", "24", "28", "37", "46", "27", "31", 
                                  "47", "44", "35", "48", "34", "21", "50", "0")
                  # north_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
                  # east_bounding_coordinate = ,
                  # south_bounding_coordinate = ,
)

mill_s <- tibble(stream = rep("mill creek",16),
                  reach = c("Above Hwy 36", "Hwy 36 To Little Hole In Ground", 
                            "Litte Hole In Ground To Hole In Ground", "Hole In Ground To Ishi Trail Head", 
                            "Ishi Trail Head To Big Bend", "Big Bend To Canyon Camp", "Canyon Camp To Sooner Place", 
                            "Sooner Place To Mccarthy Place", "Mccarthy Place To Savercool Place", 
                            "Savercool Place  To Black Rock", "Black Rock To Below Ranch House", 
                            "Below Ranch House To Above Avery", "Above Avery To Pape Place", 
                            "Pape Place To Buckhorn Gulch", "Buckhorn Gulch To Upper Dam", NA
                  ),
                  description = c("Above Hwy 36", "Hwy 36 To Little Hole In Ground", 
                                  "Litte Hole In Ground To Hole In Ground", "Hole In Ground To Ishi Trail Head", 
                                  "Ishi Trail Head To Big Bend", "Big Bend To Canyon Camp", "Canyon Camp To Sooner Place", 
                                  "Sooner Place To Mccarthy Place", "Mccarthy Place To Savercool Place", 
                                  "Savercool Place  To Black Rock", "Black Rock To Below Ranch House", 
                                  "Below Ranch House To Above Avery", "Above Avery To Pape Place", 
                                  "Pape Place To Buckhorn Gulch", "Buckhorn Gulch To Upper Dam", NA
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

