library(googleCloudStorageR)
library(tidyverse)

gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "daily_catch_unmarked.csv"), overwrite = TRUE)

gcs_get_object(object_name = "jpe-model-data/daily_environmental.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "daily_environmental.csv"), overwrite = TRUE)

gcs_get_object(object_name = "jpe-model-data/efficiency_summary.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "efficiency_summary.csv"), overwrite = TRUE)

gcs_get_object(object_name = "jpe-model-data/release_summary.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "release_summary.csv"), overwrite = TRUE)

gcs_get_object(object_name = "jpe-model-data/daily_effort.csv",
              bucket = gcs_get_global_bucket(),
              saveToDisk = here::here("data", "model-data", "daily_effort.csv"), overwrite = TRUE)


catch_raw <- read_csv(here::here("data", "model-data", "daily_catch_unmarked.csv"))
environmental_raw <- read_csv(here::here("data", "model-data", "daily_environmental.csv"))
efficiency_raw <- read_csv(here::here("data", "model-data", "efficiency_summary.csv"))
release_raw <- read_csv(here::here("data", "model-data", "release_summary.csv"))
effort_raw <- read_csv(here::here("data", "model-data", "daily_effort.csv"))

# data prep
efficiency <- efficiency_raw |> 
  left_join(release_raw |> 
              select(release_id, date_released)) |> 
  mutate(week = week(date_released),
         wy = ifelse(month(date_released) %in% 10:12, year(date_released) + 1, year(date_released))) |> 
  filter(stream == "battle creek",
         wy == 2018) 

catch <- catch_raw |> 
  mutate(week = week(date),
         wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  filter(stream == "battle creek", 
         wy == 2018) 

environmental <- environmental_raw |> 
  mutate(week = week(date),
         wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  filter(stream == "battle creek", 
         wy == 2018,
         parameter %in% c("turbidity"))   # select for discharge, turbidity, temperature
  
# Biweekly report
# decided that adipose_clipped fish will be summarized with unclipped fish

# List of data that needs to be summarized

# Table 1
# Daily environmental covariates
# discharge, temperature, turbidity

# Daily passage by BY/Run
# To do this we will need to calculate efficiency for all efficiency trials
# and assign the day to the closest trial
# Baily efficiency - total repcatured/total released

effiency_summary <- efficiency |> 
  mutate(efficiency = number_recaptured/number_released) |> 
  group_by(week) |> 
  summarize(efficiency = mean(efficiency))

# use the mean efficiency to date when an efficiency trial does not exist for a given week
efficiency_total <- effiency_summary |> 
  summarize(efficiency = mean(efficiency))


# catch data needs to be grouped by run, species
catch_summary <- catch |> 
  group_by(run, date, week, wy) |>  # will need to group by species as well but not included in this dataset
  summarize(count = sum(count))

daily_passage <- catch_summary |> 
  left_join(effiency_summary) |> 
  mutate(efficiency = ifelse(is.na(efficiency), efficiency_total$efficiency, efficiency),
         passage = round(count/efficiency)) |> 
  filter(!is.na(run)) |> 
  select(date, run, passage) |> # select species when available
  pivot_wider(id_cols = date, names_from = "run", values_from = "passage", values_fill = 0) |> view()

# Brood Year Total
# We won't be able to pull in historical data yet but we can do a running total
# by adding together the passage from all previous dates

# Confidence Intervals for the total catch based on bootstrap distribution of the 2 week period

# Plot 1
# Raw catch by time colored by run and species (dashed line for steelhead)

# Narrative
# 1. Description of what report is
# 2. Description of methods
# 3. Text entry of abnormal events
# 4. Note about data being preliminary
# 5. Contact
# 6. Once we get data on EDI could include link
# 
# 
# # TODO would be really helpful to have some understanding of the percent catch based on historical timing - see new report ryan sent

