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

# upload data
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


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

# when we filter the catch dataset to chinook we may lose some dates where the trap was running
# but no chinook were caught. the following code creates a list of all dates trap is assumed to be
# running so that if that date does not exist in the catch data we can assign chinook count = 0
dates_trap_running <- standard_trap |> 
  select(trap_start_date, trap_stop_date, stream, site, subsite, trap_functioning) |> 
  filter(trap_functioning != "trap not in service") |> 
  select(-c(trap_functioning)) |> 
  distinct(trap_start_date, trap_stop_date, stream, site, subsite) |> 
  glimpse()

date_ranges_trap_running <- dates_trap_running |> 
  mutate(diff = as.numeric(trap_stop_date - trap_start_date)) |> 
  filter(diff > 1) |>  
  rowwise() |> 
  mutate(date_list = list(seq.Date(from = as_date(trap_start_date), to = as_date(trap_stop_date), by = "day"))) |> 
  glimpse()

full_date_list <- date_ranges_trap_running |> 
  group_by(row_number()) |> 
  group_map(function(data, i) {
    data |> 
      tibble(dates = unlist(date_list)) |> 
      mutate(dates = as_date(dates))
  }) |> 
  list_rbind() |> 
  select(stream, site, subsite, dates) |> 
  bind_rows(dates_trap_running |> 
              select(stream, site, subsite, trap_start_date) |> 
              rename(dates = trap_start_date),
            dates_trap_running |> 
              select(stream, site, subsite, trap_stop_date) |> 
              rename(dates = trap_stop_date)) |> 
  distinct() |> 
  filter(!is.na(dates))
#1184541
standard_catch_unmarked_raw <- standard_catch %>% 
  mutate(lifestage = ifelse(is.na(lifestage), "not recorded", lifestage)) |> 
  #distinct() |> # notcied some duplicates for knights landing that may have resulted from adding in 0s for trap visit not in catch
  filter(species == "chinook salmon", # filter for only chinook
         is.na(release_id), # filter for only unmarked fish, exclude recaptured fish that were part of efficiency trial
         lifestage != "adult") %>%  # remove the adult fish (mostly on Butte)
  mutate(month = month(date), # add to join with lad and yearling
         day = day(date)) |> 
  glimpse()

standard_catch_unmarked <- standard_catch_unmarked_raw |> 
  # note there are some join issues happening here
  # add in dates that trap was running
  full_join(full_date_list |> rename(date = dates)) |> 
  # replace NA count with 0 for the dates where no chinook were caught
  mutate(count = ifelse(is.na(count), 0, count))

gcs_upload(standard_catch_unmarked,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_catch_unmarked_051525.csv",
           predefinedAcl = "bucketLevel")

write_csv(standard_catch_unmarked, "data/model-data/daily_catch_unmarked.csv")

# Summarize standard_catch by week
# stream, site, subsite, week, year, run, lifestage, adipose_clipped
weekly_standard_catch_unmarked <- standard_catch_unmarked %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(week, year, stream, site, subsite, run, lifestage, adipose_clipped, lifestage_for_model, include_in_model) %>% 
  summarize(mean_fork_length = mean(fork_length, na.rm = T),
            mean_weight = mean(weight, na.rm = T),
            count = sum(count)) %>% glimpse()

gcs_upload(weekly_standard_catch_unmarked,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/weekly_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")
write_csv(weekly_standard_catch_unmarked, "data/model-data/weekly_catch_unmarked.csv")


# fork length distributions -----------------------------------------------

# In order to apply PLAD run assignments to historical juvenile abundance
# Need fork length distributions by week and lifestage (fry/smolt)
# Provide as raw data, small size bins, larger size bins

catch_fl_summary_site <- standard_catch_unmarked |> 
  # only want to include those weeks being included in model
  filter(include_in_model == T) |> 
  mutate(week = week(date),
         wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  # summarize by week 
  # can also summarize to the site level as subsites can be added together (e.g. river left + river right)
  group_by(week, wy, fork_length, stream, site, site_group, lifestage_for_model) |> 
  summarize(count = sum(count))

gcs_upload(catch_fl_summary_site,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/fork_length_summary_site.csv",
           predefinedAcl = "bucketLevel")
write_csv(catch_fl_summary_site, "data/model-data/fork_length_summary_site.csv")

catch_fl_summary_stream <- standard_catch_unmarked |> 
  # only want to include those weeks being included in model
  filter(include_in_model == T) |> 
  mutate(week = week(date),
         wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  # summarize by week 
  # can also summarize to the site level as subsites can be added together (e.g. river left + river right)
  group_by(week, wy, fork_length, stream, site, site_group, lifestage_for_model) |> 
  summarize(count = sum(count)) |> 
  # if want to summarize at the stream level need to either select one site to use or could take the average
  # can't sum across sites or will result in double counting (e.g. upper clear creek and lower clear creek, same fish passing through)
  group_by(week, wy, fork_length, stream, lifestage_for_model) |> 
  summarize(count = mean(count))

gcs_upload(catch_fl_summary_stream,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/fork_length_summary_stream.csv",
           predefinedAcl = "bucketLevel")
write_csv(catch_fl_summary_stream, "data/fork_length_summary_stream.csv")

# measure fork length by PLAD size bin ------------------------------------
# from meeting with josh 12/27/23 - wants number of fish per PLAD size bin (only measured)
plad_bin_lookup <- tibble(plad_size_bins = c(seq(1:16), "not measured", "outside bins"),
                          bin_lower = c(seq(from = 35, to = 110,by = 5),NA, NA),
                          bin_upper = c(seq(from = 39, to = 114, by = 5), NA, NA),
                          bin_mid = c(seq(from = 37.5, to = 112.5, by = 5), NA, NA))
plad_distributions_raw <- standard_catch_unmarked |> 
  mutate(week = week(date),
         monitoring_year = ifelse(month(date) %in% 9:12, year(date) + 1, year(date)),
         month = month(date), # add to join with yearling
         day = day(date),
         fork_length = round(fork_length)) |> 
  left_join(years_to_include) |> 
  mutate(include_in_model = ifelse(date >= min_date & date <= max_date, TRUE, FALSE),
         # if the year was not included in the list of years to include then should be FALSE
         include_in_model = ifelse(is.na(min_date), FALSE, include_in_model)) |> 
  filter(include_in_model == T) |> 
  left_join(daily_yearling_ruleset) |> 
  mutate(
    plad_size_bins = case_when(
      fork_length %in% 35:39 ~ "1",
      fork_length %in% 40:44 ~ "2",
      fork_length %in% 45:49 ~ "3",
      fork_length %in% 50:54 ~ "4",
      fork_length %in% 55:59 ~ "5",
      fork_length %in% 60:64 ~ "6",
      fork_length %in% 65:69 ~ "7",
      fork_length %in% 70:74 ~ "8",
      fork_length %in% 75:79 ~ "9",
      fork_length %in% 80:84 ~ "10",
      fork_length %in% 85:89 ~ "11",
      fork_length %in% 90:94 ~ "12",
      fork_length %in% 95:99 ~ "13",
      fork_length %in% 100:104 ~ "14",
      fork_length %in% 105:109 ~ "15",
      fork_length %in% 110:114 ~ "16",
      is.na(fork_length) ~ "not measured",
      fork_length > 114 |
        fork_length < 35 ~ "outside bins")
  ) |>
  group_by(stream, site, week, monitoring_year, plad_size_bins, lifestage_for_model) |> 
  summarize(count = sum(count, na.rm = T))

plad_distributions <- plad_distributions_raw |>  
  group_by(stream, site, week, monitoring_year) |> 
  summarize(total = sum(count)) |> 
  left_join(plad_distributions_raw) |> 
  select(stream, site, week, monitoring_year, lifestage_for_model, plad_size_bins, count, total) |> 
  rename(year = monitoring_year) |> 
  left_join(plad_bin_lookup) |> 
  # Josh said he is not going to use these
  filter(!plad_size_bins %in% c("not measured", "outside bins"))
 
gcs_upload(plad_distributions,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/plad_bin_distribution.csv",
           predefinedAcl = "bucketLevel")
write_csv(plad_distributions, "data/plad_bin_distribution.csv")
  # ck <- plad_distributions_raw |> 
  #   filter(is.na(plad_size_bins), !is.na(fork_length), fork_length > 34, fork_length < 114)
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

# feather annual site list to use -----------------------------------------
# Describe for feather river which site to use each year, in years that there 
# are multiple sites fished, use the site with the most reccords

# Use weekly catch effort to summarize sites fished for each year 
annual_sites_trapped <- weekly_catch_effort |> 
  filter(stream == "feather river") |> 
  mutate(site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                         site %in% hfc_sites ~ "feather river hfc",
                         T ~ NA)) |> 
  group_by(year, site_group, site) |> 
  tally() |> 
  rename(reccords_per_site = n)

# Filter to only include site with most records per year and site group 
filtered_annual_sites <- annual_sites_trapped |> 
  group_by(year, site_group) |> 
  mutate(x = rank(desc(reccords_per_site), ties.method = "first"),
         stream = "feather river") |> 
  filter(x == 1) |>
  select(year, stream, site_group, site) |> glimpse()
  
# Confirm only one site per site group 
filtered_annual_sites |> 
  group_by(year, site_group) |> 
  tally() |> 
  rename(traps_per_site_group = n) |> 
  pull(traps_per_site_group) |> unique()

# save to cloud 
gcs_upload(filtered_annual_sites,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/feather_annual_site_selection.csv",
           predefinedAcl = "bucketLevel")
write_csv(filtered_annual_sites, "data/model-data/feather_annual_site_selection.csv")




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
  group_by(week, year, stream, site_group, site, subsite, gage_agency, gage_number, statistic) |> 
  summarize(mean_temperature = mean(value, na.rm = T))
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
                                T ~ NA),
         origin_released = ifelse(origin_released == "natural", "wild", origin_released)) 

ck <- filter(release_summary, site == "red bluff diversion dam")
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
  full_join(standard_recapture) |> 
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
              select(stream, site, release_id, number_recaptured) %>% 
              group_by(stream, site, release_id) %>% 
              summarize(number_recaptured = sum(number_recaptured))) %>% 
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured),
         site_group = case_when(site %in% lfc_sites ~ "feather river lfc",
                                site %in% hfc_sites ~ "feather river hfc",
                                T ~ NA))
ck <- filter(efficiency_summary, site == "red bluff diversion dam")
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
                                     wild == 1 ~ "wild",
                                     !is.na(`not recorded`) ~ "not recorded",
                                     !is.na(unknown) ~ "unknown",
                                     !is.na(mixed) ~ "mixed",
                                     hatchery < 1 | wild < 1 ~ "mixed")) |> 
  select(-c(wild, hatchery, `not recorded`, unknown, mixed))
weekly_release <- release_summary |> 
  filter(include == "yes" | is.na(include)) |> 
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
write_csv(standard_daily_redd, "data/model-data/daily_redd.csv")

