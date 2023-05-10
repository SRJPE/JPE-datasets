# Scripts to prepare data for model
library(lubridate)
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP
f <- function(input, output) write_csv(input, file = output)

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
                             T ~ F)) |> 
  filter(exclude == F) |> 
  glimpse()

View(stream_week_site_year_include)

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

standard_catch_unmarked <- standard_catch %>% 
  filter(species == "chinook salmon", # filter for only chinook
         is.na(release_id)) %>%  # filter for only unmarked fish, exclude recaptured fish that were part of efficiency trial
  select(-species, -release_id)

# add logic to assign lifestage_for_model 
# TODO confirm with Ashley that this is where we want it 
# TODO see if we can come up with simplified faster approach - approach that comes 
# to mind would be to assign weekly based on props that week but we would loose granularity on run, ect.
# seems like current approach is less biased


# extrapolate lifestage for model for plus count fish/fish without fork lenghts based on weekly fl probabilities
# Create table with prob fry, smolt, and yearlings for each stream, site, week, year
weekly_lifestage_bins <- standard_catch_unmarked |> 
  filter(!is.na(fork_length), count != 0) |> 
  mutate(year = year(date), week = week(date)) |> 
  group_by(year, week, stream, site) |> 
  summarize(percent_fry = sum(lifestage_for_model == "fry")/n(),
            percent_smolt = sum(lifestage_for_model == "smolt")/n(),
            percent_yearling = sum(lifestage_for_model == "yearling")/n()) |> 
  ungroup() |> 
  glimpse() 

# create table of all na values that need to be filled
na_to_fill <- standard_catch_unmarked |> 
  mutate(week = week(date), year = year(date)) |> 
  filter(is.na(fork_length), count != 0) |>
  uncount(count) |> 
  glimpse() 

# create helper function that selects week, year, stream, site from prob table and na to fill table 
fill_na_lifestage <- function(week, year, stream, site) {
  # rename to avoid funky behavior with filter statement
  selected_week <- week
  selected_year <- year
  selected_stream <- stream
  selected_site <- site
  
  # filter prob table
  prob_tb <- weekly_lifestage_bins |> 
    filter(week == selected_week, 
           year == selected_year, 
           stream == selected_stream, 
           site == selected_site)
  
  # create prob vector
  probs <- c(prob_tb$percent_fry, prob_tb$percent_smolt, prob_tb$percent_yearling)
  
  # add conditional for times when we do not have probs for a week 
  if (length(probs) == 3) {
    # if we do have probs for a week, filter na to fill table, and assign lifestage_for_model 
    # based on sample of c("fry", "smolt", "yearling) based off of the prob for that year, week, stream, site
    to_fill <- na_to_fill |> 
      filter(week == selected_week, year == selected_year, 
             stream == selected_stream, site == selected_site) |> 
      mutate(lifestage_for_model = sample(x = c("fry", "smolt", "yearling"), 
                                          size = 1, prob = probs, replace = TRUE))
  } else {
    # if no prob for that week, leave na_to_fill table as is but filter to week, year, stream, site
    # lifestage_for_model will remain NA
    to_fill <- na_to_fill |> 
      filter(week == selected_week, year == selected_year, 
             stream == selected_stream, site == selected_site)
  }
  return(to_fill)
}

week_year_stream_site_combos <- na_to_fill |> 
  select(week, year, stream, site) |> 
  distinct() |> glimpse()

# takes super long for all 3250 distinct week, year, stream, site combos 
# TODO improve performance - way to slow (1 minute for 100 rows) total of 3250 that we need to map through 
filled_na_lifstage_for_model_one <- purrr::pmap(week_year_stream_site_combos[1:500,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_two <- purrr::pmap(week_year_stream_site_combos[501:1000,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_three <- purrr::pmap(week_year_stream_site_combos[1001:1500,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_four <- purrr::pmap(week_year_stream_site_combos[1501:2000,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_five <- purrr::pmap(week_year_stream_site_combos[2001:2500,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_six <- purrr::pmap(week_year_stream_site_combos[2501:3000,], fill_na_lifestage) |> reduce(bind_rows)
filled_na_lifstage_for_model_seven <- purrr::pmap(week_year_stream_site_combos[3001:3250,], fill_na_lifestage) |> reduce(bind_rows)

# add filled values back into combined_rst 
# first filter combined rst to exclude rows in na_to_fill
combined_rst_wo_na_fl <- standard_catch_unmarked |>   
  filter(!is.na(fork_length)) |> 
  mutate(model_lifestage_method = "assigned from fl cutoffs") |> 
  glimpse()

daily_total_filled_na_lifestage <- bind_rows(filled_na_lifstage_for_model_one, 
                                             filled_na_lifstage_for_model_two,
                                             filled_na_lifstage_for_model_three,
                                             filled_na_lifstage_for_model_four,
                                             filled_na_lifstage_for_model_five,
                                             filled_na_lifstage_for_model_six,
                                             filled_na_lifstage_for_model_seven) |> 
  group_by(date, run, dead, interpolated, stream, site, subsite, adipose_clipped, 
           run_method, species, weight, lifestage_for_model) |> 
  mutate(model_lifestage_method = "sampled from weekly distribution") |> 
  summarise(count = n())

updated_standard_catch <- bind_rows(combined_rst_wo_na_fl, total_filled_na_lifestage) |> glimpse()

# add include_in_model variable based on sampling window criteria
# read in years to include produced in prep data for model
gcs_get_object(object_name = "jpe-model-data/stream_week_site_year_include.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data", "model-data", "stream_week_site_year_include.csv"), overwrite = TRUE)

years_to_include <- read_csv(here::here("data", "model-data", "stream_week_site_year_include.csv")) |> 
  select(min_date, max_date) |> glimpse()


rst_with_inclusion_criteria <- updated_standard_catch |> 
  mutate(monitoring_year = ifelse(month(date) %in% 9:12, year(date) + 1, year(date))) |> 
  left_join(years_to_include) |> 
  mutate(include_in_mode = ifelse(date > min_date & date < max_date, TRUE, FALSE)) |> 
  select(-c(monitoring_year, min_date, min_week, max_date, max_week, exclude)) |> 
  glimpse()

gcs_upload(rst_with_inclusion_criteria,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/daily_catch_unmarked.csv",
           predefinedAcl = "bucketLevel")

write_csv(updated_standard_rst, "data/model-data/daily_catch_unmarked.csv")

# Summarize standard_catch by week
# stream, site, subsite, week, year, run, lifestage, adipose_clipped
weekly_standard_catch_unmarked <- standard_catch_unmarked %>% 
  mutate(week = week(date),
         year = year(date)) %>% 
  group_by(week, year, stream, site, subsite, run, lifestage, adipose_clipped, is_yearling) %>% 
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

weekly_flow <- standard_flow |> 
  mutate(week = week(date),
         year = year(date)) |> 
  group_by(week, year, stream, site, source) |> 
  summarize(mean_flow = mean(flow_cfs, na.rm = T))

# Standard temperature
unique(standard_temperature$site)
gcs_upload(standard_temperature,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/standard_temperature.csv",
           predefinedAcl = "bucketLevel")
write_csv(standard_temperature, "data/model-data/standard_temperature.csv")

weekly_temperature <- standard_temperature |> 
  mutate(week = week(date),
         year = year(date)) |> 
  group_by(week, year, stream, site, subsite, source) |> 
  summarize(mean_temperature = mean(mean_daily_temp_c, na.rm = T))
# Trap --------------------------------------------------------------------

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

# Efficiency --------------------------------------------------------------

# Summarize releases and recaptures
standard_recapture %>% glimpse()
standard_release %>% glimpse()
release_summary <- standard_release |> 
  mutate(week_released = ifelse(is.na(week_released), week(date_released), week_released),
         year_released = ifelse(is.na(year_released), year(date_released), year_released)) 
gcs_upload(release_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/release_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(release_summary, "data/model-data/release_summary.csv")

# number of efficiency trials by week
release_summary_metadata <- release_summary |> 
  filter(include == "yes") |> 
  group_by(stream, site, week_released, year_released) |> 
  distinct(release_id) |> 
  tally()
total_trials <- sum(release_summary_metadata$n)
multiple_trials <- filter(release_summary_metadata, n > 1) 

compare_flow <- multiple_trials |> 
  left_join(release_summary) |> 
  select(stream, site, week_released, year_released, release_id, date_released) |> 
  left_join(standard_flow |> 
              rename(date_released = date) |> 
              select(-source)) |> 
  group_by(week_released, year_released, stream, site) |> 
  mutate(number = row_number()) |> 
  pivot_wider(id_cols = c(week_released, year_released, stream, site),
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
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured))
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
  mutate(number_recaptured = ifelse(is.na(number_recaptured), 0, number_recaptured))
gcs_upload(efficiency_summary,
           object_function = f,
           type = "csv",
           name = "jpe-model-data/efficiency_summary.csv",
           predefinedAcl = "bucketLevel")
write_csv(efficiency_summary, "data/model-data/efficiency_summary.csv")

# weekly release
## Summarize origin by week
weekly_release_origin <- release_summary |> 
  group_by(stream, site, week_released, year_released, origin_released) |> 
  tally() |> 
  mutate(percent = n/sum(n)) |> 
  pivot_wider(id_cols = c(stream, site, week_released, year_released),
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
  select(stream, site, release_id, date_released, week_released, year_released, 
         number_released, median_fork_length_released, flow_at_release, temperature_at_release, 
         turbidity_at_release) |> 
  left_join(standard_flow |> 
              mutate(date_released = date + 1,
                     flow_release = lag(flow_cfs),
                     week_released = week(date_released),
                     year_released = year(date_released)) |> 
              select(-date, -flow_cfs)) |> 
  group_by(stream, site, week_released, year_released) |> 
  summarise(number_released = sum(number_released),
            median_fork_length_released = median(median_fork_length_released, na.rm = T),
            flow_at_recapture_day1 = mean(flow_release, na.rm = T)) |> 
  mutate(across(everything(), ~replace(., is.nan(.), NA))) |> 
  left_join(weekly_release_origin)

# weekly recapture
# # More recaps than releases because we removed include == F from release data to 
# remove trials that we should exclude 
weekly_recapture <- recapture_summary |> 
  select(stream, site, release_id, date_released, week_released, year_released, 
         number_recaptured, median_fork_length_recaptured) |> 
  mutate(week_released = ifelse(is.na(week_released), week(date_released), week_released),
         year_released = ifelse(is.na(year_released), year(date_released), year_released)) |> 
  group_by(stream, site, week_released, year_released) |> 
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

