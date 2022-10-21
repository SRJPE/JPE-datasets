# Scripts to prepare data for model
library(lubridate)
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP

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

# Summarize standard_catch by week
# stream, site, subsite, week, year, run, lifestage, adipose_clipped
weekly_standard_catch_unmarked <- standard_catch_unmarked %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(week, year, stream, site, subsite, run, lifestage, adipose_clipped) %>% 
  summarize(mean_fork_length = mean(fork_length, na.rm = T),
            mean_weight = mean(weight, na.rm = T),
            count = sum(count))

# Summarize effort data by week
standard_effort %>% glimpse()

weekly_standard_effort <- standard_effort %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(stream, site, subsite, week, year) %>% 
  summarize(hours_fished = sum(hours_fished))

# Join weekly effort data to weekly catch data
# there are a handful of cases where hours fished is NA. may be able to fill these in
weekly_catch <- left_join(weekly_standard_catch_unmarked, weekly_standard_effort) 
filter(weekly_catch, is.na(hours_fished))

# Join environmental data to catch data
standard_environmental %>% glimpse()

standard_catch_unmarked_environmental <- standard_catch_unmarked %>% 
  left_join(standard_environmental)

# Join trap operations data to catch data
# improvement that could be made is making counter and sample revolutions easier to understand
standard_trap %>% glimpse()

standard_catch_unmarked_trap <- standard_catch_unmarked %>% 
  left_join(standard_trap, by = c("date" = "trap_stop_date", 
                                  "stream" ="stream", 
                                  "site" = "site", 
                                  "subsite" = "subsite"))

# Summarize releases and recaptures
standard_recapture %>% glimpse()
standard_release %>% glimpse()

efficiency_summary <- standard_release %>% 
  select(stream, site, release_id, number_released) %>% 
  left_join(standard_recapture %>% 
              select(stream, site, subsite, release_id, number_recaptured) %>% 
              group_by(stream, site, subsite, release_id) %>% 
              summarize(number_recaptured = sum(number_recaptured))) %>% 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured))




