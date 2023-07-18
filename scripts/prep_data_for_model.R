# Scripts to prepare data for model
library(lubridate)
library(tidyverse)
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP
f <- function(input, output) write_csv(input, file = output)


# site handling -----------------------------------------------------------

# Based on multiple conversations about site handling, we will be adding a field
# called site_group that only applies to feather river. This will handle the 
# hfc/lfc grouping while retaining site/subsite variables.

lfc_subsites <- c("eye riffle_north", "eye riffle_side channel", "gateway main 400' up river", "gateway_main1", "gateway_rootball", "gateway_rootball_river_left", "#steep riffle_rst", "steep riffle_10' ext", "steep side channel")
hfc_subsites <- c("herringer_east", "herringer_upper_west", "herringer_west", "live oak", "shawns_east", "shawns_west", "sunset east bank", "sunset west bank")

lfc_sites <- c("eye riffle", "gateway riffle", "steep riffle")
hfc_sites <- c("herringer riffle", "live oak", "shawn's beach", "sunset pumps")

# RST years to include ----------------------------------------------------
# 
# upload data
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# read in data
# this file was created in analysis/generate_sample_window.R
gcs_get_object(object_name = "jpe-model-data/stream_week_year_include.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/standard-format-data/stream_week_year_include.csv",
               overwrite = TRUE)
years_to_include <- read_csv("data/standard-format-data/stream_week_year_include.csv")

stream_week_site_year_include <- years_to_include |>
  group_by(monitoring_year, stream, site) |> 
  # decided to go inclusively 
  # if just take min week does not account for the monitoring year so need to find min date first
  summarise(min_date = min(min_date),
            min_week = week(min_date),
            max_date = max(max_date),
            max_week = week(max_date)) |> 
  # identified as excluded due to incomplete sampling
  mutate(exclude = case_when(monitoring_year == 2022 & stream == "battle creek" ~ T,
                             monitoring_year == 2005 & site == "yuba river" ~ T,
                             monitoring_year == 2008 & site == "yuba river" ~ T,
                             monitoring_year == 2007 & site == "sunset pumps" ~ T,
                             monitoring_year == 2009 & site == "sunset pumps" ~ T,
                             T ~ F),
         site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA)) |> 
  filter(exclude == F) |> 
  select(monitoring_year, stream, site_group, site, min_date, min_week, max_date, max_week)

# View(stream_week_site_year_include)

gcs_upload(stream_week_site_year_include,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/stream_week_site_year_include.csv",
           predefinedAcl = "bucketLevel")
write_csv(stream_week_site_year_include, "data/model-data/stream_week_site_year_include.csv")

# Catch -------------------------------------------------------------------

# Filter standard_catch to include only unmarked fish (is.na(release_id), species == "chinook")
standard_catch %>% glimpse()
unique(standard_catch$site)
unique(standard_catch$subsite)
unique(standard_catch$release_id)
unique(standard_catch$species)
filter(standard_catch, grepl("chinook", species)) %>% distinct(species)
gcs_get_object(object_name = "standard-format-data/daily_yearling_ruleset.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "daily_yearling_ruleset.csv"),
               overwrite = TRUE)
daily_yearling_ruleset <- read_csv(here::here("data", "daily_yearling_ruleset.csv"))


standard_catch_unmarked <- standard_catch %>% 
  filter(species == "chinook salmon", # filter for only chinook
         is.na(release_id)) %>%  # filter for only unmarked fish, exclude recaptured fish that were part of efficiency trial
  mutate(month = month(date), # add to join with lad and yearling
         day = day(date)) |> 
  left_join(daily_yearling_ruleset) |> 
  mutate(lifestage_for_model = case_when(fork_length > cutoff & !run %in% c("fall","late fall", "winter") ~ "yearling",
                                         fork_length <= cutoff & fork_length > 45 & !run %in% c("fall","late fall", "winter") ~ "smolt",
                                         fork_length > 45 & run %in% c("fall", "late fall", "winter", "not recorded") ~ "smolt",
                                         fork_length > 45 & stream == "sacramento river" ~ "smolt",
                                         fork_length <= 45 ~ "fry", # logic from flora includes week (all weeks but 7, 8, 9 had this threshold) but I am not sure this is necessary, worth talking through
                                         T ~ NA)) |> 
  select(-species, -release_id, -is_yearling, -month, -day, -cutoff) |> 
  glimpse()


# add logic to assign lifestage_for_model 
# extrapolate lifestage for model for plus count fish/fish without fork lenghts based on weekly fl probabilities
# Create table with prob fry, smolt, and yearlings for each stream, site, week, year

# TODO - figure out how to handle weeks where we do not have fl data 
# options 
# - use historical percentages for a specific week if a year week does not have fl data 
# or specificy as unknown 
weekly_lifestage_bins <- standard_catch_unmarked |> 
  filter(!is.na(fork_length), count != 0) |> 
  mutate(year = year(date), week = week(date)) |> 
  group_by(year, week, stream, site) |> 
  summarize(percent_fry = sum(lifestage_for_model == "fry")/n(),
            percent_smolt = sum(lifestage_for_model == "smolt")/n(),
            percent_yearling = sum(lifestage_for_model == "yearling")/n()) |> 
  ungroup() |> 
  glimpse() 

# Use when no FL data for a year 
proxy_weekly_fl <- standard_catch_unmarked |> 
  mutate(year = year(date), week = week(date)) |> 
  filter(!is.na(lifestage_for_model)) |> 
  group_by(week, stream) |> 
  summarize(percent_fry = sum(lifestage_for_model == "fry")/n(),
            percent_smolt = sum(lifestage_for_model == "smolt")/n(),
            percent_yearling = sum(lifestage_for_model == "yearling")/n()) |> 
  ungroup() |> 
  glimpse() 

# Years without FL data 
proxy_lifestage_bins_for_weeks_without_fl <- standard_catch_unmarked |> 
  group_by(year = year(date), week = week(date), stream, site) |> 
  summarise(fork_length = mean(fork_length, na.rm = TRUE)) |> 
  filter(is.na(fork_length)) |> 
  left_join(proxy_weekly_fl, by = c("week" = "week", "stream" = "stream")) |> 
  select(-fork_length) |> 
  glimpse() 

all_lifestage_bins <- bind_rows(weekly_lifestage_bins, proxy_lifestage_bins_for_weeks_without_fl)

# create table of all na values that need to be filled
na_filled_lifestage <- standard_catch_unmarked |> 
  mutate(week = week(date), year = year(date)) |> 
  filter(is.na(fork_length) & count > 0) |> 
  left_join(all_lifestage_bins, by = c("week" = "week", "year" = "year", "stream" = "stream", "site" = "site")) |> 
  mutate(fry = round(count * percent_fry), 
         smolt = round(count * percent_smolt), 
         yearling = round(count * percent_yearling)) |> 
  select(-lifestage_for_model, -count, -week, -year) |> # remove because all na, assigning in next line
  pivot_longer(fry:yearling, names_to = 'lifestage_for_model', values_to = 'count') |> 
  select(-c(percent_fry, percent_smolt, percent_yearling)) |>  
  filter(count != 0) |> # remove 0 values introduced when 0 prop of a lifestage, significantly decreases size of DF 
  mutate(model_lifestage_method = "assign count based on weekly distribution",
         week = week(date), 
         year = year(date)) |> 
  glimpse()

# add filled values back into combined_rst 
# first filter combined rst to exclude rows in na_to_fill
# total of 
combined_rst_wo_na_fl <- standard_catch_unmarked |> 
  mutate(week = week(date), year = year(date)) |> 
  filter(!is.na(fork_length)) |> 
  mutate(model_lifestage_method = "assigned from fl cutoffs") |> 
  glimpse()

# weeks we cannot predict lifestage
gap_weeks <- proxy_lifestage_bins_for_weeks_without_fl |> 
  filter(is.na(percent_fry) & is.na(percent_smolt) & is.na(percent_yearling)) |> 
  select(year, week, stream, site)

formatted_standard_catch <- standard_catch_unmarked |> 
  mutate(week = week(date), year = year(date)) |> glimpse()

weeks_wo_lifestage <- gap_weeks |> 
  left_join(formatted_standard_catch, by = c("year" = "year", "stream" = "stream", "week" = "week", "site" = "site")) |> 
  filter(!is.na(count), count > 0) |> 
  mutate(model_lifestage_method = "Not able to determine, no weekly fl data ever") |> 
  glimpse()

no_catch <- standard_catch_unmarked |> 
  mutate(week = week(date), year = year(date)) |>
  filter(is.na(fork_length) & count == 0)

# less rows now than in original, has to do with removing count != 0 in line 104, is there any reason not to do this?
updated_standard_catch <- bind_rows(combined_rst_wo_na_fl, na_filled_lifestage, no_catch, weeks_wo_lifestage) |> glimpse()

# Quick plot to check that we are not missing data 
updated_standard_catch |> 
  ggplot() + 
  geom_line(aes(x = date, y = count, color = site)) + facet_wrap(~stream, scales = "free")


# fill in run for all streams ------------------------------------------
# how many records have no information for run?
# ~15% of battle creek have no run; ~3% of clear creek have no run
updated_standard_catch_na_run <- updated_standard_catch |> 
  mutate(run = ifelse(run %in% c("not recorded", "unknown", NA_character_), NA_character_, run)) |> glimpse()

updated_standard_catch_na_run |> 
  group_by(stream, run) |> 
  summarise(n = n()) |> 
  mutate(freq = n / sum(n)) |> 
  filter(is.na(run))

updated_standard_catch_na_run |> 
  filter(stream == "clear creek") |> 
  group_by(site, week) |> 
  summarise(n = n(),
            prop_spring = sum(run == "spring", na.rm = T) / n,
            prop_other = sum(run %in% c("fall", "late fall", "winter", NA_character_) / n)) |> 
  ggplot(aes(x = week, y = prop_spring)) + 
  geom_bar(stat = "identity") +
  facet_wrap(~site, scales = "free")

updated_standard_catch_na_run_no_deer_mill <- updated_standard_catch_na_run |> 
  filter(!stream %in% c("deer creek", "mill creek")) |> 
  glimpse()

# create weekly proportion bins for run (spring / not spring / unknown)
weekly_run_bins <- updated_standard_catch_na_run_no_deer_mill |> 
  filter(!is.na(run), count != 0) |> 
  mutate(year = year(date), week = week(date)) |> 
  group_by(year, week, stream, site) |>
  summarize(percent_spring = sum(run == "spring", na.rm = T)/n(),
            percent_not_spring = sum(run != "spring", na.rm = T) / n()) |> 
  ungroup() |> 
  glimpse()

# Use when no run data for a year 
proxy_weekly_run <- updated_standard_catch_na_run_no_deer_mill |>
  mutate(year = year(date), week = week(date)) |>
  filter(count > 0, !is.na(run)) |> 
  group_by(week, stream, site) |>
  summarise(percent_spring = sum(run == "spring", na.rm = T)/n(),
            percent_not_spring = sum(run != "spring", na.rm = T)/n()) |>
  ungroup() |>
  glimpse()

# # Years without run data 
proxy_run_bins_for_weeks_without_run <- updated_standard_catch_na_run_no_deer_mill |>
  filter(count > 0) |> 
  group_by(year, week, stream, site) |>
  summarise(all_na = sum(is.na(run)) == n()) |> 
  ungroup() |> 
  filter(all_na) |> 
  left_join(proxy_weekly_run, by = c("week", "stream", "site")) |>
  select(-all_na) |>
  glimpse()

all_run_bins <- bind_rows(weekly_run_bins, proxy_run_bins_for_weeks_without_run) |>
  glimpse()
  

# create table of all na values that need to be filled
na_filled_run <- updated_standard_catch_na_run_no_deer_mill |> 
  filter(is.na(run) & count > 0) |> 
  left_join(all_run_bins, by = c("year", "week", "stream", "site")) |> 
  mutate(spring_run = round(count * percent_spring),
         not_spring_run = round(count * percent_not_spring)) |> 
  select(-c(count, week, year, run)) |> # remove bc all NA, assigning in next line
  pivot_longer(spring_run:not_spring_run, names_to = 'run_for_model', values_to = 'count') |> 
  select(-c(percent_spring, percent_not_spring)) |>  
  filter(count != 0) |> # remove 0 values introduced when 0 prop of a lifestage, significantly decreases size of DF 
  mutate(model_run_method = "assign run based on weekly distribution",
         week = week(date), 
         year = year(date)) |> 
  glimpse()

# add filled values back into combined_rst 
# first filter combined rst to exclude rows in na_to_fill
# total of 
combined_rst_wo_na_run <- updated_standard_catch_na_run_no_deer_mill |> 
  filter(!is.na(run) & count > 0) |> 
  mutate(run_for_model = if_else(run == "spring", "spring_run", "not_spring_run")) |> 
  rename(model_run_method = run_method) |> 
  glimpse()

mill_and_deer <- updated_standard_catch_na_run |> 
  filter(stream %in% c("mill creek", "deer creek")) |> 
  mutate(run_for_model = NA)

no_catch_run <- updated_standard_catch_na_run_no_deer_mill |> 
  filter(count == 0) |> 
  mutate(run_for_model = NA)

# TODO we added lots of records here. I think it has to do with joining on site - all joins in this section
# have increased nrow()
updated_standard_catch_with_run <- bind_rows(combined_rst_wo_na_run, na_filled_run, no_catch_run, mill_and_deer) |> glimpse()

# Quick plot to check that we are not missing data 
updated_standard_catch_with_run |> 
  ggplot() + 
  geom_line(aes(x = date, y = count, color = run_for_model)) + facet_wrap(~stream, scales = "free")



# add include_in_model variable based on sampling window criteria
# read in years to include produced in prep data for model
gcs_get_object(object_name = "jpe-model-data/stream_week_site_year_include.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "stream_week_site_year_include.csv"), overwrite = TRUE)

years_to_include <- read_csv(here::here("data", "model-data", "stream_week_site_year_include.csv")) |> 
  select(stream, site, monitoring_year, min_date, max_date) |> glimpse()

rst_with_inclusion_criteria <- updated_standard_catch |> 
  mutate(monitoring_year = ifelse(month(date) %in% 9:12, year(date) + 1, year(date))) |> 
  left_join(years_to_include) |> 
  mutate(include_in_model = ifelse(date >= min_date & date <= max_date, TRUE, FALSE),
         # if the year was not included in the list of years to include then should be FALSE
         include_in_model = ifelse(is.na(min_date), FALSE, include_in_model)) |> 
  select(-c(monitoring_year, min_date, max_date, year, week)) |> 
  glimpse()

gcs_upload(rst_with_inclusion_criteria,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")

write_csv(rst_with_inclusion_criteria, "data/model-data/daily_catch_unmarked.csv")

# Summarize standard_catch by week
# stream, site, subsite, week, year, run, lifestage, adipose_clipped
weekly_standard_catch_unmarked <- rst_with_inclusion_criteria %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(week, year, stream, site_group, site, subsite, run, lifestage, adipose_clipped, lifestage_for_model, include_in_model) %>% 
  summarize(mean_fork_length = mean(fork_length, na.rm = T),
            mean_weight = mean(weight, na.rm = T),
            count = sum(count)) %>% glimpse()

gcs_upload(weekly_standard_catch_unmarked,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_standard_catch_unmarked, "data/model-data/weekly_catch_unmarked.csv")

# Effort ------------------------------------------------------------------

# Summarize effort data by week
standard_effort_w_site_group <- standard_effort |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(standard_effort_w_site_group,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_effort.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_effort_w_site_group, "data/model-data/daily_effort.csv")
weekly_standard_effort <- standard_effort_w_site_group %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(stream, site_group, site, subsite, week, year) %>% 
  summarize(hours_fished = sum(hours_fished))

gcs_upload(weekly_standard_effort,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_effort.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_standard_effort, "data/model-data/weekly_effort.csv")


# Catch & Effort ----------------------------------------------------------

# Join weekly effort data to weekly catch data
# there are a handful of cases where hours fished is NA. 
# weekly hours fished will be assumed to be 168 hours (24 hours * 7) as most
# traps fish continuously. Ideally these data points would be filled in, however,
# after extensive effort 54 still remain. It is unlikely that these datapoints
# will have a huge effect in such a large data set.
weekly_catch_effort <- left_join(weekly_standard_catch_unmarked, weekly_standard_effort) |> 
  mutate(hours_fished = ifelse(is.na(hours_fished), 168, hours_fished))
gcs_upload(weekly_catch_effort,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_catch_effort.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_catch_effort, "data/model-data/weekly_catch_effort.csv")


# Environmental -----------------------------------------------------------

# Join environmental data to catch data
standard_environmental_w_site_group <- standard_environmental |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(standard_environmental_w_site_group,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_environmental.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_environmental_w_site_group, "data/model-data/daily_environmental.csv")
standard_catch_unmarked_environmental <- standard_catch_unmarked %>% 
  left_join(standard_environmental_w_site_group)

# Standard flow
unique(standard_flow$site)

standard_flow_w_site_group <- standard_flow |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
 gcs_upload(standard_flow_w_site_group,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/standard_flow.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_flow_w_site_group, "data/model-data/standard_flow.csv")

weekly_flow <- standard_flow_w_site_group |> 
  mutate(week = week(date),
         year = year(date)) |> 
  group_by(week, year, stream, site_group, site, source) |> 
  summarize(mean_flow = mean(flow_cfs, na.rm = T))

# Standard temperature
unique(standard_temperature$site)
standard_temperature_w_site_group <- standard_temperature |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(standard_temperature_w_site_group,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/standard_temperature.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_temperature_w_site_group, "data/model-data/standard_temperature.csv")

weekly_temperature <- standard_temperature_w_site_group |> 
  mutate(week = week(date),
         year = year(date)) |> 
  group_by(week, year, stream, site_group, site, subsite, source) |> 
  summarize(mean_temperature = mean(mean_daily_temp_c, na.rm = T))
# Trap --------------------------------------------------------------------

# Join trap operations data to catch data
# improvement that could be made is making counter and sample revolutions easier to understand
standard_trap_w_site_group <- standard_trap |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(standard_trap_w_site_group,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_trap.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_trap_w_site_group, "data/model-data/daily_trap.csv")
standard_catch_unmarked_trap <- standard_catch_unmarked %>% 
  left_join(standard_trap_w_site_group, by = c("date" = "trap_stop_date", 
                                  "stream" ="stream", 
                                  "site_group" = "site_group",
                                  "site" = "site", 
                                  "subsite" = "subsite"))

# Efficiency --------------------------------------------------------------

# Summarize releases and recaptures
standard_recapture %>% glimpse()
standard_release %>% glimpse()
release_summary <- standard_release |> 
  mutate(week_released = ifelse(is.na(week_released), week(date_released), week_released),
         year_released = ifelse(is.na(year_released), year(date_released), year_released),
         site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA)) 
gcs_upload(release_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/release_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(release_summary, "data/model-data/release_summary.csv")

# number of efficiency trials by week
release_summary_metadata <- release_summary |> 
  filter(include == "yes") |> 
  group_by(stream, site_group, site, week_released, year_released) |> 
  distinct(release_id) |> 
  tally()
total_trials <- sum(release_summary_metadata$n)
multiple_trials <- filter(release_summary_metadata, n > 1) 

compare_flow <- multiple_trials |> 
  left_join(release_summary) |> 
  select(stream, site_group, site, week_released, year_released, release_id, date_released) |> 
  left_join(standard_flow_w_site_group |> 
              rename(date_released = date) |> 
              select(-source)) |> 
  group_by(week_released, year_released, stream, site_group, site) |> 
  mutate(number = row_number()) |> 
  pivot_wider(id_cols = c(week_released, year_released, stream, site_group, site),
              names_from = number, values_from = flow_cfs) 

compare_flow |> 
  mutate(pdiff1_2 = ((`2` - `1`)/`1`)*100,
         pdiff1_3 = ((`3` - `1`)/`1`)*100,
         pdiff1_4 = ((`4` - `1`)/`1`)*100,
         pdiff1_5 = ((`5` - `1`)/`1`)*100,
         pdiff2_3 = ((`3` - `2`)/`2`)*100,
         pdiff2_4 = ((`4` - `1`)/`1`)*100,
         pdiff2_5 = ((`5` - `1`)/`1`)*100,
         pdiff3_4 = ((`4` - `3`)/`3`)*100,
         pdiff3_5 = ((`5` - `1`)/`1`)*100,
         pdiff_4_5 = ((`5` - `4`)/`4`)*100) |> 
  pivot_longer(cols = c(pdiff1_2, pdiff2_3, pdiff3_4, pdiff_4_5, pdiff1_3, pdiff1_4, pdiff1_5,
                        pdiff2_4, pdiff2_5, pdiff3_5),
               names_to = "percent_diff_type",
               values_to = "percent_difference") |> 
  filter(!is.na(percent_difference)) |> 
  ggplot(aes(percent_difference)) +
  geom_density()

# add zero recaptures
recapture_summary <- select(standard_release, stream, site, release_id, date_released, week_released, year_released) |> 
  full_join(select(standard_recapture, -c(date_released, week_released, year_released))) |> 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured),
         site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(recapture_summary,
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
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured),
         site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
gcs_upload(efficiency_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/efficiency_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(efficiency_summary, "data/model-data/efficiency_summary.csv")

# weekly release
## Summarize origin by week
weekly_release_origin <- release_summary |> 
  group_by(stream, site_group, site, week_released, year_released, origin_released) |> 
  tally() |> 
  mutate(percent = n/sum(n)) |> 
  pivot_wider(id_cols = c(stream, site_group, site, week_released, year_released),
              names_from = origin_released, values_from = percent) |> 
  # logic here is that if hatchery or natural is less than 100% (all trials within that week)
  # then origin is mixed
  # if any reported as unknown or not recorded then origin is unknown or not reported
  mutate(origin_released = case_when(hatchery == 1 ~ "hatchery",
                                     natural == 1 ~ "natural",
                                     !is.na(`not recorded`) ~ "not recorded",
                                     !is.na(unknown) ~ "unknown",
                                     !is.na(mixed) ~ "mixed",
                                     hatchery < 1 | natural < 1 ~ "mixed")) |> 
  select(-c(natural, hatchery, `not recorded`, unknown, mixed))
weekly_release <- release_summary |> 
  filter(include == "yes") |> 
  select(stream, site_group, site, release_id, date_released, week_released, year_released, 
         number_released, median_fork_length_released, flow_at_release, temperature_at_release, 
         turbidity_at_release) |> 
  left_join(standard_flow_w_site_group |> 
              mutate(date_released = date + 1,
                     flow_release = lag(flow_cfs),
                     week_released = week(date_released),
                     year_released = year(date_released)) |> 
              select(-date, -flow_cfs)) |> 
  group_by(stream, site_group, site, week_released, year_released) |> 
  summarise(number_released = sum(number_released),
            median_fork_length_released = median(median_fork_length_released, na.rm = T),
            flow_at_recapture_day1 = mean(flow_release, na.rm = T)) |> 
  mutate(across(everything(), ~replace(., is.nan(.), NA))) |> 
  left_join(weekly_release_origin)

# weekly recapture
# # More recaps than releases because we removed include == F from release data to 
# remove trials that we should exclude 
weekly_recapture <- recapture_summary |> 
  select(stream, site_group, site, release_id, date_released, week_released, year_released, 
         number_recaptured, median_fork_length_recaptured) |> 
  mutate(week_released = ifelse(is.na(week_released), week(date_released), week_released),
         year_released = ifelse(is.na(year_released), year(date_released), year_released)) |> 
  group_by(stream, site_group, site, week_released, year_released) |> 
  summarise(number_recaptured = sum(number_recaptured),
            median_fork_length_recaptured = median(median_fork_length_recaptured, na.rm = T))
# weekly efficiency
# this weekly summary assumes fish released in week 1 are caught in week 1
weekly_efficiency <- left_join(weekly_release, weekly_recapture)
gcs_upload(weekly_efficiency,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_efficiency.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_efficiency, "data/model-data/weekly_efficiency.csv")

# Adult Upstream ----------------------------------------------------------

gcs_upload(standard_upstream,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/upstream_passage.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_upstream, "data/model-data/upstream_passage.csv")

# Holding -----------------------------------------------------------------

gcs_upload(standard_holding,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/holding.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_holding, "data/model-data/holding.csv")

# Redd --------------------------------------------------------------------

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

