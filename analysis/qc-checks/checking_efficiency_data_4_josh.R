library(googleCloudStorageR)
library(tidyverse)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Mark-Recapture Data for RST
# standard recapture data table
gcs_get_object(object_name = "jpe-model-data/weekly_efficiency.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/weekly_efficiency.csv",
               overwrite = TRUE)
efficiency <- read_csv("data/model-data/weekly_efficiency.csv")

filter(efficiency, !is.na(median_fork_length_released))

# check data from Feb 13 2023
efficiency_2_13 <- read_csv("weekly_efficiency2_14_2023.csv")

filter(efficiency_2_13, !is.na(median_fork_length_released))

# check data from Dec 28 2022
efficiency_12_28 <- read_csv("weekly_efficiency12_28_2022.csv")

filter(efficiency_12_28, !is.na(median_fork_length_released))

# check data from Dec 22 2022
efficiency_12_22 <- read_csv("efficiency_summary_12_22.csv")

filter(efficiency_12_22, !is.na(median_fork_length_released))

release_12_22 <- read_csv("release_summary_12_22.csv")

release_12_22 |> 
  group_by(week(date_released), stream, site, year(date_released)) |> 
  summarize(median_fork_length_released = median(median_fork_length_released, na.rm = T)) |> 
  filter(!is.na(median_fork_length_released))

# October 21 2022
release_10_21 <- read_csv("release_summary_10_21.csv")

release_10_21 |> 
  group_by(week(date_released), stream, site, year(date_released)) |> 
  summarize(median_fork_length_released = median(median_fork_length_released, na.rm = T)) |> 
  filter(!is.na(median_fork_length_released))

# July 28
release_07_28 <- read_csv("release_07_28.csv")

release_07_28 |> 
  group_by(week(release_date), stream, site, year(release_date)) |> 
  summarize(median_fork_length_released = median(median_fork_length_released, na.rm = T)) |> 
  filter(!is.na(median_fork_length_released))

ck <- release_07_28 |> 
  filter(!is.na(median_fork_length_released)) |> 
  group_by(week(release_date), stream, site, year(release_date)) |> 
  tally()

ck |> 
  ungroup() |> 
  summarise(n = sum(n))

# July 22
release_07_22 <- read_csv("release_7_22.csv")

release_07_22 |> 
  group_by(week(release_date), stream, site, year(release_date)) |> 
  summarize(median_fork_length_released = median(median_fork_length_released, na.rm = T)) |> 
  filter(!is.na(median_fork_length_released))


# current
efficiency_current <- read_csv("weekly_efficiency_current.csv")

ck <- filter(efficiency_current, !is.na(median_fork_length_released))
