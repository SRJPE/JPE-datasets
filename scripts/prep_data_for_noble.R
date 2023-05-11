# Noble needs to 2021/2022 data to back calculate estimates based on actual catch
# Ideally we would just pull this data from the jpe-model-db but it isn't quite there yet
library(readr)
library(dplyr)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Tisdale
# https://github.com/FlowWest/jpe-tisdale-edi/blob/add-metadata/data/catch.csv
tisdale_raw <- read_csv(here::here("data", "tisdale_catch_edi.csv"))
tisdale_2021_present <- tisdale_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, finalRun, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  rename(run = atCaptureRun) |> 
  mutate(stream = "sacramento river")


# Knights Landing
# https://github.com/FlowWest/jpe-knights-edi/blob/main/data/catch.csv
# knights_raw <- read_csv(here::here("data", "knights_catch_edi.csv"))
# knights_2021_present <- knights_raw |> 
#   filter(commonName == "Chinook salmon") |> 
#   select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, finalRun, totalLength, visitType, actualCount)) |> 
#   filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
#   rename(run = atCaptureRun) |> 
#   mutate(stream = "sacramento river")
# only includes through June 2021


# Butte
# pulled most recent catch file from the butte edi repo: https://github.com/FlowWest/jpe-butte-edi/blob/make_xml_qc/data/butte_catch_edi.csv
butte_raw <- read_csv(here::here("data", "butte_catch_edi.csv"))
butte_2021_present <- butte_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, finalRun, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  rename(run = atCaptureRun) |> 
  mutate(stream = "butte creek")

# Feather 
# https://github.com/FlowWest/jpe-feather-edi/blob/make_xml_qc/data/feather_catch_edi.csv
feather_raw <- read_csv(here::here("data", "feather_catch_edi.csv"))
feather_2021_present <- feather_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, releaseID, totalLength, visitType, actualCount)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  mutate(stream = "feather river")

# Mill/Deer - paper sheets - working on data entry
gcs_get_object(object_name = 
                 "rst/mill-creek/data/mill_2021_catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data-raw/qc-markdowns/rst/mill-creek/mill_2021_catch.csv",
               overwrite = TRUE)

mill_raw <- read_csv("data-raw/qc-markdowns/rst/mill-creek/mill_2021_catch.csv")
mill_2021_present <- mill_raw |> 
  filter(species == "chinook salmon") |> 
  mutate(run = "not recorded",
         siteName = "upper mill creek",
         subSiteName = "upper mill creek",
         fishOrigin = "not recorded") |> 
  select(-c(mort, is_plus_count, weight, species)) |> 
  rename(lifeStage = lifestage,
         forkLength = fork_length,
         n = count,
         visitTime = date)
  
# Battle/Clear - working on getting from Natasha
# erin created this - TODO merge workflow
battle_clear_raw <- read_csv("data/battle_clear_catch_2021_2022.csv")
battle_2021_present <- battle_clear_raw |> 
  rename(stream = river,
         siteName = station_code,
         subSiteName = station_code,
         visitTime = sample_date,
         lifeStage = life_stage,
         n = count, 
         forkLenth = fork_length) |> 
  mutate(fishOrigin = "not recorded") |> 
  select(-common_name)
# Yuba - just started in 2022/2023

current_data <- bind_rows(butte_2021_present, 
                          feather_2021_present,
                          tisdale_2021_present,
                          mill_2021_present,
                          battle_2021_present)
write_csv(current_data, here::here("data", "PLAD-data","catch_2021_current.csv"))

# upload to google cloud bucket
f <- function(input, output) write_csv(input, file = output)
gcs_upload(current_data,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/combined_2021_2022_data.csv")
