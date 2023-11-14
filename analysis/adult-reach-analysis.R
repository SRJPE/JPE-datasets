# standardize adult reaches

library(tidyverse)
library(lubridate)
library(googleCloudStorageR)

# get standard data from cloud
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = here::here("data", "standard-format-data", "standard_daily_redd.csv")))
# gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = here::here("data", "standard-format-data", "standard_annual_redd.csv")))
# gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = here::here("data", "standard-format-data", "standard_cacass.csv")))
# gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = here::here("data", "standard-format-data", "standard_holding.csv")))
gcs_get_object(object_name = "resources/Battle_Clear_Reach_Breaks_Adult_Surveys.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", "battle-creek", "battle-clear-creek-survey-reaches.xlsx"))

# read in adult data files

redd <- read.csv(here::here("data", "standard-format-data", "standard_daily_redd.csv"))
annual_redd <- read.csv(here::here("data", "standard-format-data", "standard_annual_redd.csv"))
carcass <- read.csv(here::here("data", "standard-format-data", "standard_carcass.csv"))
holding <- read.csv(here::here("data", "standard-format-data", "standard_holding.csv"))


battle_clear_reaches <- readxl::read_xlsx(here::here("data-raw", "qc-markdowns", "adult-holding-redd-and-carcass-surveys", "battle-creek", 
                                             "battle-clear-creek-survey-reaches.xlsx"))
# read in original reach list file
reach_list_raw <- read.csv(here::here("analysis", "reach_list.csv"))


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
                                                      "Assumes encompasses R1A and R1B: Eagle Canyon Dam to Wildcat Dam",
                                                      "Wildcat Dam to Conflence",
                                                      "Coleman Dam to Confluence",
                                                      "Confluence to Barnbeat",
                                                      "Barnbeat to Springbranch",
                                                      "Springbranch to Coleman NFH",
                                                      "Coleman NFH to LBC (Lower Battle Creek)",
                                                      "not recorded"))


# TODO confirm Tailrace and Nevis Creek with Natasha, here encodes as NA (only 3 rows)
# TODO R1A vs R1B for older
battle_reach_lookup <- tibble("reach" = unique(all_battle_reaches$reach),
                              "standardized_reach" = c(NA, "R7", "R3", "R4",
                                                       "R6", "R7", "R2", "R1", "R5",
                                                       NA, NA)) |> 
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
                                                          "R6A", "R6B", "R7", "no description", NA),
                                  "reach_description" = c("Whiskeytown Dam to NEED Camp Bridge",
                                                          "NEED Camp Bridge to Kanaka Creek Confluence",
                                                          "Kanaka Creek Confluence to Placer Rd. Bridge",
                                                          "Placer Rd. Bridge to Clear Creek Rd. Bridge",
                                                          "Clear Creek Rd. Bridge to Clear Creek Gorge",
                                                          "Clear Creek Gorge to Gold Dredge BLM Recreation Area",
                                                          "Gold Drege BLM REcreation Area to China Garden BLM Recreation Area",
                                                          "China Garden BLM Recreation Area to Clear Creek Video Station",
                                                          "no description",
                                                          "not recorded"))
# TODO confirm reaches 15-32 with Natasha
clear_reach_lookup <- tibble("reach" = unique(all_clear_reaches$reach),
                              "standardized_reach" = c("R3", "R2", "R4", "R5", "R1", "R5",
                                                       "R6", "R5", "R7", "R6A", "R5", NA, "R6B",
                                                       "no description", "no description", "no description", 
                                                       "no description", "no description", "no description", 
                                                       "no description", "no description", "R5", "R5", 
                                                       "R5", "R5")) |> 
  left_join(standard_clear_reaches)


# Butte Creek -------------------------------------------------------------
# TODO do we want to use reach or way_pt (which seems to relate to subreach?)
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
# TODO add subreach descriptions
butte_subreach_lookup <- tibble("sub_reach" = c("A1", "A2", "A3", "A4", "A5",
                                           "B1", "B2", "B3", "B4", "B5", 
                                           "B6", "B7", "B8", "C1", "C2",
                                           "C3", "C4", "C5", "C6", "C7", 
                                           "C8", "C9", "C10", "C11", "C12",
                                           "D1", "D2", "D3", "D4", "D5", 
                                           "D6", "D7", "D8", "E1", "E2", 
                                           "E3", "E4", "E5", "E6", "E7", 
                                           "F", "G", "H", "I", NA, "no description"),
                          "reach" = c("A", "A", "A", "A", "A", 
                                      "B", "B", "B", "B", "B", "B", "B", "B", 
                                      "C", "C", "C", "C", "C", "C", "C", "C", 
                                      "C", "C", "C", "C", "D", "D", "D", "D", 
                                      "D", "D", "D", "D", "E", "E", "E", "E", "E", 
                                      "E", "E", "F", "G", "H", "I", NA, "no description"))
standard_butte_reaches <- tibble("reach" = c("A", "B", "C", "D", "E", "F", "G", "H", "I", NA, "no description",
                                             "Covered bridge to Parrott-Phelan Diversion"),
                                 "reach_description" = c("Quartz Bowl Pool to Whiskey Flat",
                                                         "Whiskey Flat to Helltown",
                                                         "Helltown to Quail Run Bridge",
                                                         "Quail Run Bridge to Cable Bridge",
                                                         "Cable Bridge to Covered Bridge",
                                                         "Parrott-Phelan Diversion to Hwy 99 Bridge",
                                                         "Hwy 99 Bridge to Durham-Dayton Rd",
                                                         "Durham-Dayton Rd to Adams Dam",
                                                         "Adams Dam to Western Canal",
                                                         "not recorded",
                                                         "no description in current map/source",
                                                         "Covered bridge to Parrott-Phelan Diversion (no reach name)")) |> 
      full_join(butte_subreach_lookup)


# TODO what is BCK, PWL, BLK, PH, PTR? Assume "OKIE" is same as Parrott-Phelan (coding of RST sites), 
# "COV" is Covered Bridge, "PWR" is Centreville powerhouse ? clarify these and we can assign these
# reaches to a standardized reach
butte_reach_lookup <- tibble("sub_reach" = unique(all_butte_reaches$reach),
                             "standardized_sub_reach" = c("A1", "A2", "A3", "A5", "B1", "B2", "B3", "B6", 
                                                          "B7", "C1", "C11", "C2", "C4", "C9", "A4", "B4", 
                                                          "B5", "B8", "C10", "C12", "C3", "C5", "C6", "C7",
                                                          "C8", "D2", "D3", "D4", "D7", "E3", "E4", "no description",
                                                          "D8", "E5", "E7", "E1", "no description", "no description",
                                                          "no description", "E2", "D1", "D5", "no description", "D6", 
                                                          "no description", "no description", "E6", "Covered bridge to Parrott-Phelan Diversion", 
                                                          "no description", "no description", NA, "no description", 
                                                          "no description", "no description", "no description", 
                                                          "no description", "no description", "A1", "A2", "A3",
                                                          "C5", "D1", "C5", "C5", "no description", "no description", 
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

# hard-code butte reaches based on map provided in report (see adult data report)
standard_deer_reaches <- tibble("standardized_reach" = c("Upper Falls to Potato Patch Camp",
                                            "Potato Patch Camp to Highway 32 (Red Bridge)",
                                            "Highway 32 (Red Bridge) to Lower Falls", 
                                            "Lower Falls to A Line",
                                            "A Line to Wilson Cove",
                                            "Wilson Cove to Polk Springs",
                                            "Polk Springs to Murphy Trail",
                                            "Murphy Trail to Ponderosa Way",
                                            "Ponderosa Way to Trail 2E17",
                                            "Trail 2E17 to Dillon Cove"),
                                "reach_description" = c("Upper Falls to Potato Patch Camp",
                                                        "Potato Patch Camp to Highway 32 (Red Bridge)",
                                                        "Highway 32 (Red Bridge) to Lower Falls", 
                                                        "Lower Falls to A Line",
                                                        "A Line to Wilson Cove",
                                                        "Wilson Cove to Polk Springs",
                                                        "Polk Springs to Murphy Trail",
                                                        "Murphy Trail to Ponderosa Way",
                                                        "Ponderosa Way to Trail 2E17",
                                                        "Trail 2E17 to Dillon Cove"))

# TODO confirm that red bridge and HW32 are the same (they appear to be on the JPE shiny map, 
# which was built with Deer Creek .kmz file)
# TODO losing resolution for Beaver site (which appears to be between Murphy Trail and Ponderosa)
# TODO losing resolution for Homestead site (apperas to be between Ponderosa and Trail 2E17)
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
                                                          "Ponderosa Way to Trail 2E17",
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

# no need to standardize for Mill Creek

# Feather -----------------------------------------------------------------
all_feather_reaches <- bind_rows(holding |> 
                                   filter(stream == "feather river") |> 
                                   mutate(data_type = "holding") |> 
                                   select(reach, data_type, year),
                                 redd |> 
                                   filter(stream == "feather river") |> 
                                   mutate(data_type = "redd") |> 
                                   select(reach, data_type, year),
                                 holding |> 
                                   filter(stream == "feather river") |> 
                                   mutate(data_type = "carcass") |> 
                                   select(reach, data_type, year))

all_feather_reaches |> 
  group_by(year, reach, data_type) |> 
  tally() |> 
  ggplot(aes(x = year, y = n, fill = reach)) + 
  geom_col() +
  facet_wrap(~data_type) +
  theme(legend.position = "bottom")

# hard-code feather reaches
# in .kmz file provided, they are numbered 1:38
# now need to map these to the sites in the files
# TODO stopped here
standard_feather_reaches <- tibble("standardized_reach" = c(as.character(seq(1, 38)),
                                                            NA, "no description"),
                                "reach_description" = c())

feather_reach_lookup <- tibble("reach" = unique(all_feather_reaches$reach),
                            "standardized_reach" = c()) |> 
  left_join(standard_feather_reaches)

# Yuba --------------------------------------------------------------------






