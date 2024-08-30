# Noble needs to current data to back calculate estimates based on actual catch
# Ideally we would just pull this data from SRJPEdata but it isn't quite there yet
library(readr)
library(dplyr)
library(EDIutils)
library(readxl)
library(lubridate)
library(googleCloudStorageR)
library(ggplot2)
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# On Aug 28 2024 Noble requested that the sample event number be attached to catch
# data 
# This was discussed through a number of emails - the main goal is that Noble
# wants to be able to connect genetics data to catch data. The sample event number
# is more complicated. We decided on week. Brett seemed to think that this needed
# to be by water year and start on Monday. I don't think it needs to be that complicated
# Sean provided his genetic data

# Started doing this by event number
# event_dates_2023_2024_raw <- read_excel(here::here("scripts", "JPE_Event_dates.xlsx"))
# event_dates_2023_2024 <- event_dates_2023_2024_raw |> 
#   rename(event_id = `...1`,
#          date_start = `Date Start`,
#          date_end = `Date End`) |> 
#   mutate(event_id = case_when(event_id == "Event 1" ~ 1,
#                               event_id == "Event 2" ~ 2,
#                               event_id == "Event 3" ~ 3,
#                               event_id == "Event 4" ~ 4,
#                               grepl("5", event_id) ~ 5,
#                               grepl("6", event_id) ~ 6,
#                               grepl("7", event_id) ~ 7,
#                               grepl("8", event_id) ~ 8,
#                               grepl("9", event_id) ~ 9,
#                               event_id == "Event 10" ~ 10,
#                               event_id == "Event 11" ~ 11,
#                               event_id == "Event 12" ~ 12,
#                               event_id == "Event 13" ~ 13,
#                               event_id == "Event 14" ~ 14))
# 
# #create tibble based on "FL_min_max"
# event_dates_2022 <- tibble(event_id = c(1:10),
#                            date_start = c("2022-10-01",
#                                           "2022-01-24",
#                                           "2022-02-07",
#                                           "2022-02-21",
#                                           "2022-03-07",
#                                           "2022-03-21",
#                                           "2022-04-04",
#                                           "2022-04-18",
#                                           "2022-05-02",
#                                           "2022-05-16")) |> 
#   mutate(date_start = as_date(date_start),
#          date_end = date_start + 4)
# 
# all_sample_events <- bind_rows(event_dates_2022,
#                                event_dates_2023_2024)
# 
# start_dates <- all_sample_events$date_start
# end_dates <- all_sample_events$date_end
# data <- current_data |> 
#   select(visitTime, n) |> 
#   rename(date = visitTime)
# 
# assign_sample_event <- function(date, start_dates, end_dates) {
#   id <- NA
#   for (i in seq_along (start_dates)) {
#     if (date >= start_dates[i] & date <= end_dates[i]) {
#       id <- i
#       break
#     }
#   }
#   return(id)
# }
# 
# data$id <- sapply(data$date, assign_sample_event, start_dates = start_dates, end_dates = end_dates)

genetics_2022_raw <- read_excel("scripts/2022_JPE_PLAD_Genotypes_06-28-24.xlsx")
genetics_2023_raw <- read_excel("scripts/2023_JPE_PLAD_Genotypes_06-28-24.xlsx")
genetics_2024_raw <- read_excel("scripts/2024_JPE_PLAD_Genotypes_07-02-24_v2.xlsx")

genetics_raw <- bind_rows(genetics_2022_raw,
                          genetics_2023_raw,
                          genetics_2024_raw) |> 
  mutate(stream = case_when(grepl("BTC", SAMPLE_ID) ~ "battle creek",
                            grepl("BUT", SAMPLE_ID) ~ "butte creek",
                            grepl("CLR", SAMPLE_ID) ~ "clear creek",
                            grepl("DEL", SAMPLE_ID) ~ "sacramento river",
                            grepl("DER", SAMPLE_ID) ~ "deer creek",
                            grepl("F17", SAMPLE_ID) ~ "feather river",
                            grepl("F61", SAMPLE_ID) ~ "feather river",
                            grepl("KNL", SAMPLE_ID) ~ "sacramento river",
                            grepl("MIL", SAMPLE_ID) ~ "mill creek",
                            grepl("TIS", SAMPLE_ID) ~ "sacramento river",
                            grepl("YUR", SAMPLE_ID) ~ "yuba river"),
         site = case_when(stream == "battle creek" ~ "ubc",
                          stream == "butte creek" ~ "okie dam",
                          stream == "clear creek" ~ "lcc",
                          stream == "deer creek" ~ "deer creek",
                          stream == "mill creek" ~ "mill creek",
                          stream == "yuba river" ~ "hallwood",
                          grepl("DEL", SAMPLE_ID) ~ "delta entry",
                          grepl("F17", SAMPLE_ID) ~ "lower feather river",
                          grepl("F61", SAMPLE_ID) ~ "eye riffle",
                          grepl("KNL", SAMPLE_ID) ~ "knights landing",
                          grepl("TIS", SAMPLE_ID) ~ "tisdale"),
         Date = case_when(year(Date) == 3203 ~ as.Date("2023-11-20"), 
                          T ~ as.Date(Date)),
         week = week(Date),
         year = year(Date))

genetics_raw |> 
  group_by(week, year, site) |> 
  tally() |> 
  ggplot(aes(x = week, y = n, fill = site)) +
  geom_col() +
  facet_wrap(~year)

min(filter(genetics_raw, year == 2022, week > 40)$week) #44
min(filter(genetics_raw, year == 2023, week > 40)$week) #45

genetics_raw |> 
  group_by(week, year, site) |> 
  tally() |> 
  filter(week > 40) |> 
  ggplot(aes(x = week, y = n, fill = site)) +
  geom_col() +
  facet_wrap(~year)

genetics_raw |> 
  group_by(week, year, site) |> 
  tally() |> 
  filter(week < 40) |> 
  ggplot(aes(x = week, y = n, fill = site)) +
  geom_col() +
  facet_wrap(~year)

event_number <- tibble(week = c(seq(44, 53), seq(1, 22)),
                       sample_group = c(1,1,2,2,3,3,4,4,5,5,
                                        6,6,7,7,8,8,9,9,10,10,
                                        11,11,12,12,13,13,14,14,
                                        15,15, 16,16))

genetics_data <- genetics_raw |> 
  left_join(event_number) |> 
  mutate(sample_year = ifelse(week %in% 44:53, year + 1, year))

genetics_data|> 
  group_by(sample_group, sample_year, site) |> 
  tally() |> 
  ggplot(aes(x = sample_group, y = n, fill = site)) +
  geom_col() +
  facet_wrap(~sample_year)
write_csv(genetics_data, here::here("data", "PLAD-data","genetics_2022_current.csv"))


# 2021 to 2024 catch data -------------------------------------------------

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
res <- read_data_entity_names(packageId = "edi.1509.1")
raw <- read_data_entity(packageId = "edi.1509.1", entityId = res$entityId[1])
battle_clear_raw <- read_csv(file = raw)

battle_2021_present <- battle_clear_raw |>
  filter(as.Date(sample_date) > as.Date("2021-09-01")) |>
  rename(siteName = station_code,
         visitTime = sample_date,
         lifeStage = life_stage,
         n = count,
         forkLength = fork_length) |>
  mutate(stream = case_when(siteName %in% c("upper battle creek", "lower battle creek", "power house battle creek") ~ "battle creek",
                            siteName %in% c("lower clear creek", "upper clear creek") ~ "clear creek",
                            T ~ siteName),
         fishOrigin = "not recorded",
         subSiteName = siteName) |>
  select(-common_name)

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

# delta entry
res <- read_data_entity_names(packageId = "edi.1503.1")
raw <- read_data_entity(packageId = "edi.1503.1", entityId = res$entityId[1])
delta_raw <- read_csv(file = raw)
delta_2021_present <- delta_raw |> 
  filter(commonName == "Chinook salmon") |> 
  select(-c(ProjectDescriptionID, catchRawID, trapVisitID, commonName, totalLength, visitType)) |> 
  filter(as.Date(visitTime) > as.Date("2021-09-01")) |> 
  mutate(stream = "sacramento river")
min(delta_2021_present$visitTime)
max(delta_2021_present$visitTime)

current_data <- bind_rows(butte_2021_present, 
                          feather_2021_present,
                          tisdale_2021_present,
                          mill_deer_2021_present,
                          battle_2021_present,
                          knights_2021_present,
                          yuba_2021_present,
                          delta_2021_present) |> 
  filter(!is.na(stream)) 
   

current_data_formatted <- current_data |> 
  select(stream, siteName, subSiteName, visitTime, n, forkLength, lifeStage, fishOrigin, run) |> 
  rename(site = siteName,
         subsite = subSiteName,
         date = visitTime,
         count = n,
         fork_length = forkLength,
         life_stage = lifeStage,
         origin = fishOrigin) |> 
  mutate(year = year(date),
         week = week(date),
         site = tolower(site),
         subsite = tolower(subsite),
         site = case_when(grepl("arrot", site) ~ "okie dam",
                          grepl("tisdale", site) ~ "tisale",
                          grepl("lower feather", site) ~ "lower feather river",
                          grepl("upper clear creek", site) ~ "ucc",
                          grepl("upper battle creek", site) ~ "ubc",
                          grepl("lower clear creek", site) ~ "lcc",
                          grepl("lower sacramento", site) ~ "delta entry",
                          T ~ site)) |> 
  filter(site != "coleman national fish hatchery") |> 
  group_by(stream, site, date, week, year, fork_length, life_stage, origin, run) |> 
  summarize(count = sum(count, na.rm = T)) |> # summarize by site
  left_join(event_number) |> 
  mutate(sample_year = ifelse(week %in% 44:53, year + 1, year)) |> 
  select(stream, site, date, week, year, sample_group, sample_year, count,
         fork_length, life_stage, origin, run)

current_data_formatted |> 
  group_by(sample_group, sample_year, site) |> 
  summarize(count = sum(count, na.rm = T)) |> 
  ggplot(aes(x = sample_group, y = count, fill = site)) +
  geom_col() +
  facet_wrap(~sample_year)


write_csv(current_data_formatted, here::here("data", "PLAD-data","catch_2021_current.csv"))


# yuba_butte_feather <- bind_rows(butte_2021_present, 
#                                 feather_2021_present,
#                                 yuba_2021_present) |> 
#   filter(!is.na(stream))
# write_csv(yuba_butte_feather, here::here("data", "PLAD-data","catch_2021_current_yuba_butte_feather.csv"))

# upload to google cloud bucket
f <- function(input, output) write_csv(input, file = output)
gcs_upload(current_data_formatted,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/combined_2021_current_data.csv")
