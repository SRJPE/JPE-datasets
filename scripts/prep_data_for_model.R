# Scripts to prepare data for model
library(lubridate)
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP
f <- function(input, output) write_csv(input, file = output)


# Filter standard_catch to include only unmarked fish (is.na(release_id), species == "chinook")
standard_catch %>% glimpse()
unique(standard_catch$site)
unique(standard_catch$subsite)
unique(standard_catch$release_id)
unique(standard_catch$species)
filter(standard_catch, grepl("chinook", species)) %>% distinct(species)

standard_catch_unmarked <- standard_catch %>% 
  filter(species == "chinook salmon", # filter for only chinook
         is.na(release_id)) %>%  # filter for only unmarked fish, exclude recaptured fish that were part of efficiency trial
  select(-species, -release_id)

gcs_upload(standard_catch_unmarked,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_catch_unmarked, "data/model-data/daily_catch_unmarked.csv")
# Summarize standard_catch by week
# stream, site, subsite, week, year, run, lifestage, adipose_clipped
weekly_standard_catch_unmarked <- standard_catch_unmarked %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(week, year, stream, site, subsite, run, lifestage, adipose_clipped) %>% 
  summarize(mean_fork_length = mean(fork_length, na.rm = T),
            mean_weight = mean(weight, na.rm = T),
            count = sum(count)) %>% glimpse()

gcs_upload(weekly_standard_catch_unmarked,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_standard_catch_unmarked, "data/model-data/weekly_catch_unmarked.csv")
# Summarize effort data by week
standard_effort %>% glimpse()
gcs_upload(standard_effort,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_effort.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_effort, "data/model-data/daily_effort.csv")
weekly_standard_effort <- standard_effort %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(stream, site, subsite, week, year) %>% 
  summarize(hours_fished = sum(hours_fished))

gcs_upload(weekly_standard_effort,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_effort.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_standard_effort, "data/model-data/weekly_effort.csv")
# Join weekly effort data to weekly catch data
# there are a handful of cases where hours fished is NA. may be able to fill these in
weekly_catch <- left_join(weekly_standard_catch_unmarked, weekly_standard_effort) 
filter(weekly_catch, is.na(hours_fished))

# Join environmental data to catch data
standard_environmental %>% glimpse()
gcs_upload(standard_environmental,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_environmental.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_environmental, "data/model-data/daily_environmental.csv")
standard_catch_unmarked_environmental <- standard_catch_unmarked %>% 
  left_join(standard_environmental)

# Standard flow
unique(standard_flow$site)
 gcs_upload(standard_flow,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/standard_flow.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_flow, "data/model-data/standard_flow.csv")
# Join trap operations data to catch data
# improvement that could be made is making counter and sample revolutions easier to understand
standard_trap %>% glimpse()
gcs_upload(standard_trap,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_trap.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_trap, "data/model-data/daily_trap.csv")
standard_catch_unmarked_trap <- standard_catch_unmarked %>% 
  left_join(standard_trap, by = c("date" = "trap_stop_date", 
                                  "stream" ="stream", 
                                  "site" = "site", 
                                  "subsite" = "subsite"))

# Summarize releases and recaptures
standard_recapture %>% glimpse()
standard_release %>% glimpse()
gcs_upload(standard_release,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/release_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_release, "data/model-data/release_summary.csv")
# add zero recaptures
recapture_summary <- select(standard_release, stream, site, release_id, date_released, week_released, year_released) |> 
  full_join(select(standard_recapture, -c(date_released, week_released, year_released))) |> 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured))
gcs_upload(ecapture_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/recapture_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(recapture_summary, "data/model-data/recapture_summary.csv")
efficiency_summary <- standard_release %>% 
  select(stream, site, release_id, number_released) %>% 
  left_join(standard_recapture %>% 
              select(stream, site, subsite, release_id, number_recaptured) %>% 
              group_by(stream, site, subsite, release_id) %>% 
              summarize(number_recaptured = sum(number_recaptured))) %>% 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured))
gcs_upload(efficiency_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/efficiency_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(efficiency_summary, "data/model-data/efficiency_summary.csv")
gcs_upload(standard_upstream,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/upstream_passage.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_upstream, "data/model-data/upstream_passage.csv")
gcs_upload(standard_holding,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/holding.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_holding, "data/model-data/holding.csv")
gcs_upload(standard_annual_redd,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/annual_redd.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_annual_redd, "data/model-data/annual_redd.csv")
gcs_upload(standard_daily_redd,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_redd.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_annual_redd, "data/model-data/daily_redd.csv")
