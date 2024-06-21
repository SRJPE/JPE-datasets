# Noble needs to current data to back calculate estimates based on actual catch
# Ideally we would just pull this data from SRJPEdata but it isn't quite there yet
library(readr)
library(dplyr)
library(EDIutils)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Tisdale
# pull straight from EDI
# TODO these data are not up to date
res <- read_data_entity_names(packageId = "edi.1499.2")
raw <- read_data_entity(packageId = "edi.1499.2", entityId = res$entityId[1])
tisdale_raw <- read_csv(file = raw)
tisdale_2021_present <- tisdale_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, finalRun, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  rename(run = atCaptureRun) |> 
  mutate(stream = "sacramento river")
min(tisdale_2021_present$visitTime)
max(tisdale_2021_present$visitTime)
# Knights Landing
# TODO these data are not up to date
res <- read_data_entity_names(packageId = "edi.1501.1")
raw <- read_data_entity(packageId = "edi.1501.1", entityId = res$entityId[2])
knights_raw <- read_csv(file = raw)
knights_2021_present <- knights_raw |>
  filter(commonName == "Chinook salmon", releaseID %in% c(0, 255)) |>
  mutate(siteName = "knights landing",
         subSiteName = as.character(subSiteName)) |> 
  select(-c(catchRawID, trapVisitID, commonName, releaseID, totalLength, visitType)) |>
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |>
  mutate(stream = "sacramento river")
min(knights_2021_present$visitTime)
max(knights_2021_present$visitTime)

# Butte
# These data are regularly updated on EDI
res <- read_data_entity_names(packageId = "edi.1497.12")
raw <- read_data_entity(packageId = "edi.1497.12", entityId = res$entityId[1])
butte_raw <- read_csv(file = raw)
butte_2021_present <- butte_raw |> 
  mutate(commonName = tolower(commonName)) |> 
  filter(commonName == "chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, finalRun, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  rename(run = atCaptureRun) |> 
  mutate(stream = "butte creek")
min(butte_2021_present$visitTime)
max(butte_2021_present$visitTime)

# Feather 
# These data are regularly updated on EDI
res <- read_data_entity_names(packageId = "edi.1239.11")
raw <- read_data_entity(packageId = "edi.1239.11", entityId = res$entityId[1])
feather_raw <- read_csv(file = raw)
feather_2021_present <- feather_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  mutate(stream = "feather river")
min(feather_2021_present$visitTime)
max(feather_2021_present$visitTime)

# Mill/Deer - paper sheets - working on data entry
# TODO add in the data from paper field sheets
deer_mill_raw <- read_csv("scripts/deer_mill_catch_edi.csv") |> glimpse()
deer_mill_2024 <- read_csv("scripts/deer_mill_catch_2024.csv") |> glimpse()


mill_deer_2021_present <- bind_rows(deer_mill_raw,
                                    deer_mill_2024 |> 
                                      mutate(date = as.Date(date, tryFormats = "%m/%d/%y"))) |>
  filter(species == "chinook salmon" | species == "chisal") |>
  filter(as.Date(date) > as.Date("2021-09-01")) |>
  mutate(run = "not recorded",
         siteName = stream,
         subSiteName = stream,
         fishOrigin = "not recorded") |>
  select(-c(weight, species, is_plus_count, fieldsheet_page, `...11`)) |>
  rename(lifeStage = lifestage,
         forkLength = fork_length,
         n = count,
         visitTime = date) 
min(mill_deer_2021_present$visitTime)
max(mill_deer_2021_present$visitTime)

# Update once EDI packaage is updated
# res <- read_data_entity_names(packageId = "edi.1504.1")
# raw <- read_data_entity(packageId = "edi.1504.1", entityId = res$entityId[1])
# deer_mill_raw <- read_csv(file = raw)
# mill_deer_2021_present <- deer_mill_raw |>
#   filter(species == "chinook salmon") |>
#   filter(as.Date(date) > as.Date("2021-09-01")) |> 
#   mutate(run = "not recorded",
#          siteName = stream,
#          subSiteName = stream,
#          fishOrigin = "not recorded") |>
#   select(-c(weight, species)) |>
#   rename(lifeStage = lifestage,
#          forkLength = fork_length,
#          n = count,
#          visitTime = date)

# gcs_get_object(object_name = 
#                  "rst/mill-creek/data/mill_2021_catch.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data-raw/qc-markdowns/rst/mill-creek/mill_2021_catch.csv",
#                overwrite = TRUE)
# 
# mill_raw <- read_csv("data-raw/qc-markdowns/rst/mill-creek/mill_2021_catch.csv")
# mill_2021_present <- mill_raw |> 
#   filter(species == "chinook salmon") |> 
#   mutate(run = "not recorded",
#          siteName = "upper mill creek",
#          subSiteName = "upper mill creek",
#          fishOrigin = "not recorded") |> 
#   select(-c(mort, is_plus_count, weight, species)) |> 
#   rename(lifeStage = lifestage,
#          forkLength = fork_length,
#          n = count,
#          visitTime = date)
#   
# Battle/Clear 
# TODO these data are not regularly updated on EDI
# In order to get data to Noble quickly I am pulling in csvs that were generated:
# https://github.com/FlowWest/edi-battle-clear-rst
# As of June 13 waiting on mark recapture data in order to update package

battle_clear_raw <- read_csv("scripts/battle_clear_catch.csv")
battle_2021_present <- battle_clear_raw |>
  filter(as.Date(sample_date) > as.Date("2021-09-01")) |>
  rename(siteName = station_code,
         visitTime = sample_date,
         lifeStage = life_stage,
         n = count,
         forkLenth = fork_length) |>
  mutate(stream = case_when(siteName %in% c("upper battle creek", "lower battle creek", "power house battle creek") ~ "battle creek",
                            siteName %in% c("lower clear creek", "upper clear creek") ~ "clear creek",
                            T ~ siteName),
         fishOrigin = "not recorded",
         subSiteName = siteName) |>
  select(-common_name)

min(battle_2021_present$visitTime)
max(battle_2021_present$visitTime)
# Update this once new data added to EDI package
# res <- read_data_entity_names(packageId = "edi.1509.1")
# raw <- read_data_entity(packageId = "edi.1509.1", entityId = res$entityId[1])
# battle_clear_raw <- read_csv(file = raw)
# 
# battle_2021_present <- battle_clear_raw |> 
#   filter(as.Date(sample_date) > as.Date("2021-09-01")) |> 
#   rename(siteName = station_code,
#          visitTime = sample_date,
#          lifeStage = life_stage,
#          n = count, 
#          forkLenth = fork_length) |> 
#   mutate(stream = case_when(siteName %in% c("upper battle creek", "lower battle creek", "power house battle creek") ~ "battle creek",
#                             siteName %in% c("lower clear creek", "upper clear creek") ~ "clear creek",
#                             T ~ siteName),
#          fishOrigin = "not recorded",
#          subSiteName = siteName) |> 
#   select(-common_name)

# Yuba - just started in 2022/2023
# These dated are updated regularly on EDI
res <- read_data_entity_names(packageId = "edi.1529.8")
raw <- read_data_entity(packageId = "edi.1529.8", entityId = res$entityId[1])
yuba_raw <- read_csv(file = raw)
yuba_2021_present <- yuba_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, totalLength, visitType)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  mutate(stream = "yuba river")
min(yuba_2021_present$visitTime)
max(yuba_2021_present$visitTime)

current_data <- bind_rows(butte_2021_present, 
                          feather_2021_present,
                          tisdale_2021_present,
                          mill_deer_2021_present,
                          battle_2021_present,
                          knights_2021_present) |> 
  filter(!is.na(stream))
write_csv(current_data, here::here("data", "PLAD-data","catch_2021_current.csv"))
unique(current_data$stream)
unique(current_data$siteName)

yuba_butte_feather <- bind_rows(butte_2021_present, 
                                feather_2021_present,
                                yuba_2021_present) |> 
  filter(!is.na(stream))
write_csv(yuba_butte_feather, here::here("data", "PLAD-data","catch_2021_current_yuba_butte_feather.csv"))

# upload to google cloud bucket
f <- function(input, output) write_csv(input, file = output)
gcs_upload(current_data,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/combined_2021_2022_data.csv")
