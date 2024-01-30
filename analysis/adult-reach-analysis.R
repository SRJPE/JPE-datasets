# standardize adult reaches

library(tidyverse)
library(lubridate)
library(googleCloudStorageR)

# get standard data from cloud
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "standard-format-data", "standard_daily_redd.csv"),
               overwrite = TRUE)
gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "standard-format-data", "standard_annual_redd.csv"),
               overwrite = TRUE)
gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "standard-format-data", "standard_carcass.csv"),
               overwrite = TRUE)
gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "standard-format-data", "standard_holding.csv"),
               overwrite = TRUE)
# battle and clear survey reaches
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/resources_Battle_Clear_Reach_Breaks_Adult_Surveys.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", "battle-creek", 
                                       "battle-clear-creek-survey-reaches.xlsx"),
               overwrite = TRUE)
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/carcass/2017_2021/CAMP_Escapement_20210412.mdb",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", 
                                       "feather-river", "feather_carcass_2017_2021.mdb"),
               overwrite = TRUE)
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/feather_reach_clarification_CJC_edits.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys",
                                       "feather-river", "feather_reach_clarification_CJC_edits.csv"),
               overwrite = TRUE)

# read in adult data files

redd <- read.csv(here::here("data", "standard-format-data", "standard_daily_redd.csv")) |> 
  filter(species != "steelhead")
annual_redd <- read.csv(here::here("data", "standard-format-data", "standard_annual_redd.csv")) |> 
  filter(species != "steelhead")
carcass <- read.csv(here::here("data", "standard-format-data", "standard_carcass.csv"))
holding <- read.csv(here::here("data", "standard-format-data", "standard_holding.csv"))

# this file is stored in the google drive: https://drive.google.com/drive/u/0/folders/1vv_QV9NdiIc4tlWPPB3UBs1s8idBOiSB and also on the GCP bucket (read in above)
battle_clear_reaches <- readxl::read_xlsx(here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", "battle-creek", 
                                             "battle-clear-creek-survey-reaches.xlsx"))
# extract CAMP descriptions of feather reaches
library(Hmisc)
CAMP_feather_reach_categorization <- mdb.get(file = here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", 
                                                              "feather-river", "feather_carcass_2017_2021.mdb"),
                                        tables = "LocationSection") |> 
  mutate(SectionID = as.character(SectionID)) |> 
  select(section_id = SectionID, section_description = Section)
detach(package:Hmisc)

# read in original reach list file
# this isn't being used for anything
# reach_list_raw <- read.csv(here::here("analysis", "reach_list.csv"))


# Battle Creek ------------------------------------------------------------
all_battle_reaches <- bind_rows(carcass |> 
                                  filter(stream == "battle creek") |> 
                                  mutate(data_type = "carcass") |> 
                                  select(reach, data_type, date),
                                redd |> 
                                  filter(stream == "battle creek") |> 
                                  mutate(data_type = "redd") |> 
                                  select(reach, data_type, date),
                                holding |> 
                                  filter(stream == "battle creek") |> 
                                  mutate(data_type = "holding") |> 
                                  select(reach, data_type, date))

all_battle_reaches |> 
  mutate(year = year(date)) |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type)

# create reach lookup based on excel file provided by stream teams
battle_clear_reaches |> 
  janitor::clean_names() |> 
  filter(study_creek == "Battle Creek") |> 
  select(location, reach_break) |> 
  print(n=Inf) 

standard_battle_reaches <- tibble("standardized_reach" = c("R1A", "R1B", "R1", "R2", "R3", "R4",
                                                         "R5", "R6", "R7", NA),
                              "reach_description" = c("Eagle Canyon Dam to Trout Farm",
                                                      "Trout Farm to Wildcat Dam",
                                                      "Assumes encompasses R1A and R1B: Eagle Canyon Dam to Wildcat Dam. Moving forward will be using sub-reaches",
                                                      "Wildcat Dam to Conflence",
                                                      "Coleman Dam to Confluence",
                                                      "Confluence to Barnbeat",
                                                      "Barnbeat to Springbranch",
                                                      "Springbranch to Coleman NFH",
                                                      "Coleman NFH to LBC (Lower Battle Creek)",
                                                      "not recorded"))

battle_reach_lookup <- tibble("reach" = unique(all_battle_reaches$reach),
                              "standardized_reach" = c(NA, "R7", "R3", "R4",
                                                       "R6", "R7", "R2", "R1", "R5",
                                                       "R6", "R7", "R4", "R1",
                                                       "R2", "R5", "R3", "R1", "R1")) |> 
  left_join(standard_battle_reaches)


# Clear Creek -------------------------------------------------------------
all_clear_reaches <- bind_rows(carcass |> 
                                  filter(stream == "clear creek") |> 
                                  mutate(data_type = "carcass") |> 
                                  select(reach, data_type, date),
                                redd |> 
                                  filter(stream == "clear creek") |> 
                                  mutate(data_type = "redd") |> 
                                  select(reach, data_type, date),
                                holding |> 
                                  filter(stream == "clear creek") |> 
                                  mutate(data_type = "holding") |> 
                                  select(reach, data_type, date))

all_clear_reaches |> 
  mutate(year = year(date)) |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type)

# create reach lookup based on excel file provided by stream teams
battle_clear_reaches |> 
  janitor::clean_names() |> 
  filter(study_creek == "Clear Creek") |> 
  select(location, reach_break) |> 
  print(n=Inf) 

standard_clear_reaches <- tibble("standardized_reach" = c("R1", "R2", "R3", "R4", "R5",
                                                          "R6A", "R6B", "R7", NA),
                                  "reach_description" = c("Whiskeytown Dam to NEED Camp Bridge",
                                                          "NEED Camp Bridge to Kanaka Creek Confluence",
                                                          "Kanaka Creek Confluence to Placer Rd. Bridge",
                                                          "Placer Rd. Bridge to Clear Creek Rd. Bridge",
                                                          "Clear Creek Rd. Bridge to Clear Creek Gorge",
                                                          "Clear Creek Gorge to Gold Dredge BLM Recreation Area",
                                                          "Gold Drege BLM REcreation Area to China Garden BLM Recreation Area",
                                                          "China Garden BLM Recreation Area to Clear Creek Video Station",
                                                          "not recorded"))

clear_reach_lookup <- tibble("reach" = unique(all_clear_reaches$reach),
                              "standardized_reach" = c("R3", "R2", "R4", "R5", "R1", "R5",
                                                       "R6A", "R5", "R7", "R6A", "R5")) |> 
  left_join(standard_clear_reaches)


# Butte Creek -------------------------------------------------------------
all_butte_reaches <- bind_rows(carcass |> 
                                 filter(stream == "butte creek") |> 
                                 mutate(data_type = "carcass") |> 
                                 select(reach, data_type, date),
                               holding |> 
                                 filter(stream == "butte creek") |> 
                                 mutate(data_type = "holding") |> 
                                 select(reach, data_type, date))

all_butte_reaches |> 
  mutate(year = year(date)) |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type, scales = "free") + 
  theme(legend.position = "bottom")

# hard-code butte reaches based on map provided in report (see adult data report)
butte_subreach_lookup <- tibble("sub_reach" = c("A1", "A2", "A3", "A4", "A5",
                                           "B1", "B2", "B3", "B4", "B5", 
                                           "B6", "B7", "B8", "C1", "C2",
                                           "C3", "C4", "C5", "C6", "C7", 
                                           "C8", "C9", "C10", "C11", "C12",
                                           "D1", "D2", "D3", "D4", "D5", 
                                           "D6", "D7", "D8", "E1", "E2", 
                                           "E3", "E4", "E5", "E6", "E7", 
                                           "F", "G", "H", "I", NA, "no description",
                                           "COV-BCK", "BCK-PWL", "PWL-PPD",
                                           "PH-PWL",
                                           "Covered bridge to Parrot-Phelan Diversion"),
                                "sub_reach_descriptions" = c("Quartz Pool 1", "Quartz Pool 2", "Quartz Pool 3",
                                                             "Chimney (Pool in Quartz Bowl)",
                                                             rep(NA, 41), 
                                                             "no description in current map/source",
                                                             "Covered bridge to USGS BCK gage",
                                                             "USGS BCK gage to power lines",
                                                             "Power lines to Parrot-Phelan Diversion",
                                                             "Centreville powerhouse to power lines",
                                                             "Covered bridge to Parrot-Phelan Diversion (full sub-reach)"),
                          "reach" = c("A", "A", "A", "A", "A", 
                                      "B", "B", "B", "B", "B", "B", "B", "B", 
                                      "C", "C", "C", "C", "C", "C", "C", "C", 
                                      "C", "C", "C", "C", "D", "D", "D", "D", 
                                      "D", "D", "D", "D", "E", "E", "E", "E", "E", 
                                      "E", "E", "F", "G", "H", "I", NA, "no description",
                                      "Covered bridge to Parrot-Phelan Diversion",
                                      "Covered bridge to Parrot-Phelan Diversion",
                                      "Covered bridge to Parrot-Phelan Diversion",
                                      "Covered bridge to Parrot-Phelan Diversion",
                                      "Covered bridge to Parrot-Phelan Diversion"))
standard_butte_reaches <- tibble("reach" = c("A", "B", "C", "D", "E", "F", "G", "H", "I", NA, "no description",
                                             "Covered bridge to Parrot-Phelan Diversion"),
                                 "reach_description" = c("Quartz Bowl Pool to Whiskey Flat",
                                                         "Whiskey Flat to Helltown",
                                                         "Helltown to Quail Run Bridge",
                                                         "Quail Run Bridge to Cable Bridge",
                                                         "Cable Bridge to Covered Bridge",
                                                         "Parrot-Phelan Diversion to Hwy 99 Bridge",
                                                         "Hwy 99 Bridge to Durham-Dayton Rd",
                                                         "Durham-Dayton Rd to Adams Dam",
                                                         "Adams Dam to Western Canal",
                                                         "not recorded",
                                                         "no description in current map/source",
                                                         "Covered bridge to Parrot-Phelan Diversion")) |> 
      full_join(butte_subreach_lookup)

# Skyway-99 encoding - likely fall survey, outside normal survey range
butte_reach_lookup <- tibble("sub_reach" = unique(all_butte_reaches$reach),
                             "standardized_sub_reach" = c("A1", "A2", "A3", "A5", "B1", "B2", "B3", "B6", 
                                                          "B7", "C1", "C11", "C2", "C4", "C9", "A4", "B4", 
                                                          "B5", "B8", "C10", "C12", "C3", "C5", "C6", "C7",
                                                          "C8", "D2", "D3", "D4", "D7", "E3", "E4", "COV-BCK",
                                                          "D8", "E5", "E7", "E1", "COV-BCK", 
                                                          "BCK-PWL", "PWL-PPD", 
                                                          "E2", "D1", "D5", "COV-BCK", "D6", 
                                                          "BCK-PWL", "PWL-PPD", 
                                                          "E6", "Covered bridge to Parrot-Phelan Diversion", "BCK-PWL", 
                                                          "BCK-PWL", NA, "BCK-PWL", 
                                                          "Covered bridge to Parrot-Phelan Diversion", "PH-PWL", "PWL-PPD", 
                                                          "C1", "A4", "A1", "A2", "A3",
                                                          "C5", "D1", "C5", "C5", "COV-BCK", "PWL-PPD", 
                                                          "F", "G", "G")) |> 
  left_join(standard_butte_reaches, 
            by = c("standardized_sub_reach" = "sub_reach"))

# Deer --------------------------------------------------------------------
all_deer_reaches <- bind_rows(holding |> 
                              filter(stream == "deer creek") |> 
                              mutate(data_type = "holding") |> 
                              select(reach, data_type, year))

all_deer_reaches |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type)

# hard-code deer reaches based on map provided in report (see adult data report)
standard_deer_reaches <- tibble("standardized_reach" = c("Upper Falls to Potato Patch Camp",
                                            "Potato Patch Camp to Highway 32 (Red Bridge)",
                                            "Highway 32 (Red Bridge) to Lower Falls", 
                                            "Lower Falls to A Line",
                                            "A Line to Wilson Cove",
                                            "Wilson Cove to Polk Springs",
                                            "Polk Springs to Murphy Trail",
                                            "Murphy Trail to Ponderosa Way",
                                            "Ponderosa Way to Trail 2E17",
                                            "Trail 2E17 to Dillon Cove",
                                            "Ponderosa Way to Moak Cove"),
                                "reach_description" = c("Upper Falls to Potato Patch Camp",
                                                        "Potato Patch Camp to Highway 32 (Red Bridge). Sometimes combined into one survey reach Potato Patch Camp to Lower Falls.",
                                                        "Highway 32 (Red Bridge) to Lower Falls. Sometimes combined into one survey reach Potato Patch Camp to Lower Falls.", 
                                                        "Lower Falls to A Line",
                                                        "A Line to Wilson Cove",
                                                        "Wilson Cove to Polk Springs",
                                                        "Polk Springs to Murphy Trail",
                                                        "Murphy Trail to Ponderosa Way. Contains historical survey reaches Murphy Trail to Beaver Creek and Beaver Creek to Ponderosa Way",
                                                        "Ponderosa Way to Trail 2E17",
                                                        "Trail 2E17 to Dillon Cove",
                                                        "Ponderosa Way to Homstead at Moak Cove. Historical and rarely surveyed."))
deer_reach_lookup <- tibble("reach" = unique(all_deer_reaches$reach),
                            "standardized_reach" = c("Highway 32 (Red Bridge) to Lower Falls",
                                                      "Lower Falls to A Line",
                                                      "Upper Falls to Potato Patch Camp",
                                                      "Potato Patch Camp to Highway 32 (Red Bridge)",
                                                      "Highway 32 (Red Bridge) to Lower Falls",
                                                      "A Line to Wilson Cove",
                                                      "Wilson Cove to Polk Springs",
                                                      "Polk Springs to Murphy Trail",
                                                      "Murphy Trail to Ponderosa Way",
                                                      "Murphy Trail to Ponderosa Way",
                                                      "Ponderosa Way to Moak Cove",
                                                      "Ponderosa Way to Trail 2E17",
                                                      "Potato Patch Camp to Highway 32 (Red Bridge)",
                                                      "A Line to Wilson Cove",
                                                      "Wilson Cove to Polk Springs",
                                                      "Polk Springs to Murphy Trail",
                                                      "Murphy Trail to Ponderosa Way",
                                                      "Ponderosa Way to Trail 2E17",
                                                      "Trail 2E17 to Dillon Cove")) |> 
  left_join(standard_deer_reaches)

# Mill --------------------------------------------------------------------
all_mill_reaches <- bind_rows(annual_redd |> 
                              filter(stream == "mill creek") |> 
                              mutate(data_type = "redd") |> 
                              select(reach, data_type, year))

# beautiful! 
all_mill_reaches |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type)

# no need to standardize for Mill Creek, but create lookup to bind rows
mill_reach_lookup <- tibble(reach = unique(all_mill_reaches$reach),
                            standardized_reach = unique(all_mill_reaches$reach),
                            reach_description = unique(all_mill_reaches$reach))

# Feather -----------------------------------------------------------------
all_feather_reaches <- bind_rows(redd |> 
                                   filter(stream == "feather river") |> 
                                   mutate(data_type = "redd") |> 
                                   select(reach, data_type, year),
                                 carcass |> 
                                   filter(stream == "feather river") |> 
                                   mutate(data_type = "carcass",
                                          year = year(date)) |> 
                                   select(reach, data_type, year))

all_feather_reaches |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type) +
  theme(legend.position = "bottom")

# hard-code feather reaches
# feather reaches: in carcass file, sections numbered from 1:38
# in redd file, descriptions of specific riffle pools
# ideally we can map these riffle pools to the numbered survey reaches
# used the survey map to match the riffles to the numbered survey reaches
# https://drive.google.com/file/d/1KtnSSlU2Z3v8KvI_7_9FBbekitkRuFo9/view?usp=drive_link (link to file)

feather_reach_categorization <- tibble("standardized_reach" = c(as.character(seq(1, 38)), NA, "historical reach - no description"),
                                       "categorization" = c(rep("HFC - high flow channel", 21),
                                                            rep("LFC - low flow channel", 17),
                                                            NA, "unknown")) |> 
  left_join(CAMP_feather_reach_categorization, by = c("standardized_reach" = "section_id")) |> 
  rename(CAMP_description = section_description)
standard_feather_reaches <- tibble("standardized_reach" = c(as.character(seq(1, 38)),
                                                            NA, "historical reach - no description"),
                                "reach_description" = c("Table Mountain Riffle and Cottonwood Riffle",
                                                        "no named riffles", 
                                                        "Top of Auditorium",
                                                        "Hatchery Riffle",
                                                        "Moes S.C.",
                                                        "Upper Auditorium and Lower Auditorium",
                                                        "Hatchery S.C.",
                                                        "Below Lower Auditorium", # inferred this
                                                        "no named riffles",
                                                        "Bedrock Riffle, Highway 70, Riverbend Park, and Highway 162",
                                                        "Trailer Park Riffle and Mathews Riffle",
                                                        "Mathews",
                                                        "no named riffles",
                                                        "Aleck Riffle",
                                                        "River Reflections RV Park Boat Launch and Great Western",
                                                        "Upper Robinson Riffle",
                                                        "Lower Robinson Riffle",
                                                        "Steep Riffle, Steep Side Channel, and Weir",
                                                        "Eye Side Channel",
                                                        "Eye Riffle",
                                                        "Gateway Riffle",
                                                        # skip outlet (between 21 and 22)
                                                        "Vance West (Evens)",
                                                        "Vance East (Odds)",
                                                        "Vance Ave/Big Hole Launch",
                                                        "Big Hole",
                                                        "no named riffles",
                                                        "G-95 Riffle",
                                                        "no named riffles",
                                                        "Hour Riffle",
                                                        "Hour Bars",
                                                        "Palm Ave. Boat Launch",
                                                        "Keister Riffle",
                                                        "Goose Riffle and Gaging Station/SWP Boundary",
                                                        "Big Riffle",
                                                        "Big Bar",
                                                        "Upper McFarland and Lower McFarland",
                                                        "Developing Riffle",
                                                        "Swampy Bend",
                                                        NA,
                                                        "historical reach - no description in data/source"))

# read in feather corrected reach list file (from Casey Campos 1-22-2024)
feather_reach_clarification <- read_csv(here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys",
                                                   "feather-river", "feather_reach_clarification_CJC_edits.csv")) |> 
  select(reach = reach_name, clarified_categorization = `LFC/HFC`, clarified_reach_description = Notes) |> 
  mutate(clarified_categorization = ifelse(clarified_categorization == "HFC", "HFC - high flow channel", "unknown"),
         clarified_reach_description = ifelse(clarified_reach_description == "", "historical reach - not in use", clarified_reach_description)) |> 
  glimpse()

feather_reach_lookup <- tibble("reach" = unique(all_feather_reaches$reach),
                               "standardized_reach" = as.character(
                                 c(1, 1, 5, 4, 6, 
                                   10, 11, 12, 14, 16,
                                   17, 18, 20, 21, 17, 
                                   17, 6, 6, 18, 3,
                                   5, 8, 20, 18, 18,
                                   18, 6, 16, 8, 10,
                                   10, 11, 14, 16, 18,
                                   22, 23, 25, 27, 27,
                                   27, 27, 29, 29, 32,
                                   33, 34, 35, 36, 23,
                                   1, 5, 5, 4, 4,
                                   21, 19, 24, 25, 25,
                                   27, 29, 29, 31, 32,
                                   33, 25, 35, 36, 37,
                                   27, 23, 23, 23, 18,
                                   12, 18, 27, 27, 7,
                                   4, 5, 5, 18, 4,
                                   5, 7, 11, 11, "historical reach - no description",
                                   25, 27, 27, 27, 22,
                                   25, 32, "historical reach - no description", "historical reach - no description", 35,
                                   36, 37, 29, 32, 1,
                                   29, 4, 7, 29, 27,
                                   15, 4, 34, NA, "historical reach - no description", 
                                   10, 14, 21, 21, 31,
                                   1, 2, 3, 4, 8,
                                   7, 6, 5, 10, 13,
                                   14, 15, 17, 18, 19,
                                   20, "historical reach - no description", "historical reach - no description", "historical reach - no description", 9,
                                   11, 12, 16, 25, 29,
                                   33, 32, "historical reach - no description", "historical reach - no description", "historical reach - no description",
                                   26, 38, 30, 36, 22,
                                   23, 24, 28, 37, "historical reach - no description",
                                   27, 31, "historical reach - no description", "historical reach - no description", 35,
                                   "historical reach - no description", 34, 21, "historical reach - no description", "historical reach - no description", "historical reach - no description"))) |> 
  left_join(standard_feather_reaches) |> 
  left_join(feather_reach_categorization) |> 
  left_join(feather_reach_clarification) |> 
  mutate(categorization = ifelse(is.na(clarified_categorization), categorization, clarified_categorization),
         reach_description = ifelse(is.na(clarified_reach_description), reach_description, clarified_reach_description)) |> 
  select(-c(clarified_categorization, clarified_reach_description)) |> 
  glimpse()

# Yuba --------------------------------------------------------------------
# TODO no reach data
# carcass has river mile, redd has lat/longs
all_yuba_reaches <- bind_rows(redd |> 
                                filter(stream == "yuba river") |> 
                                mutate(data_type = "redd") |> 
                                select(reach, data_type, year),
                              carcass |> 
                                filter(stream == "yuba river") |> 
                                mutate(data_type = "carcass",
                                       year = year(date)) |> 
                                select(reach, data_type, year)) 

all_yuba_reaches |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type) +
  theme(legend.position = "bottom")


# Bind together all years and streams into a lookup -----------------------

all_stream_reach_lookup <- bind_rows(battle_reach_lookup |> 
                                       mutate(stream = "battle creek"),
                                     clear_reach_lookup |> 
                                       mutate(stream = "clear creek"),
                                     butte_reach_lookup |> 
                                       mutate(stream = "butte creek"),
                                     feather_reach_lookup |> 
                                       mutate(stream = "feather river"),
                                     deer_reach_lookup |> 
                                       mutate(stream = "deer creek"),
                                     mill_reach_lookup |> 
                                       mutate(stream = "mill creek")) |> 
  glimpse()

data_dictionary <- tibble(column_name = names(all_stream_reach_lookup),
                          streams_collecting = c("B, C, Bu, F, D, M",
                                                 "B, C, F, D, M",
                                                 "B, C, Bu, F, D, M",
                                                 "B, C, Bu, F, D, M",
                                                 "Bu", "Bu", "Bu", "F", "F"), 
                          description = c("Surveyed reach name in raw data", 
                                          "Standard reach associated with raw reach name",
                                          "Description of standard reach",
                                          "Stream where reach is surveyed",
                                          "Sub-reach name in raw data",
                                          "Standard sub-reach associated with raw sub-reach name",
                                          "Description of standard sub-reach",
                                          "Categorization of reach as high or low flow channels (HFC/LFC)",
                                          "Description of standard reach from CAMP database"))

# push to cloud -----------------------------------------------------------
f <- function(input, output) write_csv(input, file = output)
gcs_upload(all_stream_reach_lookup,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/standard_reach_lookup.csv")
# TODO pull into the standard adult markdowns (new branch)


