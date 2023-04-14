# pull in and prep data for adult model

# libraries ---------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(rstan)
library(bayesplot)

# pull adult data & process ----------------------------------------------------------------
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# upstream passage total counts
upstream_passage <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                            bucket = gcs_get_global_bucket())) |>
  filter(!is.na(date)) |> 
  mutate(stream = tolower(stream),
         year = year(date)) |>
  filter(run %in% c("spring", NA, "not recorded")) |> 
  group_by(year, passage_direction, stream) |>
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  pivot_wider(names_from = passage_direction, values_from = count) |> 
  # calculate upstream passage for streams where passage direction is recorded
  mutate(down = ifelse(is.na(down), 0, down),
         up = case_when(stream %in% c("deer creek", "mill creek") ~ `NA`,
                        !stream %in% c("deer creek", "mill creek") & is.na(up) ~ 0,
                        TRUE ~ up)) |> 
  select(-`NA`) |> 
  group_by(year, stream) |> 
  summarise(count = round(up - down), 0) |> 
  select(year, count, stream) |> 
  ungroup() |> 
  glimpse()

# holding
holding <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
                                   bucket = gcs_get_global_bucket()))|> 
  group_by(year, stream) |> 
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  glimpse()

# redd
redd <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
                                bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", "not recorded")) |> 
  # redds in these reaches are likely fall, so set to 0 for battle & clear
  mutate(max_yearly_redd_count = case_when(reach %in% c("R6", "R6A", "R6B", "R7") & 
                                             stream %in% c("battle creek", "clear creek") ~ 0,
                                           TRUE ~ max_yearly_redd_count)) |> 
  group_by(year, stream) |>
  summarise(count = sum(max_yearly_redd_count, na.rm = T)) |> 
  ungroup() |> 
  select(year, stream, count) |> 
  glimpse()

redd_daily <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
                                      bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  mutate(count = 1) |> 
  group_by(year, stream) |> 
  summarise(count = sum(count)) |> 
  ungroup() |> 
  glimpse()

# carcass
carcass <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
                                   bucket = gcs_get_global_bucket())) |>
  filter(run %in% c("spring", "unknown", NA)) |> 
  select(date, stream, count) |> 
  mutate(year = year(date)) |> 
  group_by(year, stream) |> 
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  glimpse()

# temperature

# threshold
# https://www.noaa.gov/sites/default/files/legacy/document/2020/Oct/07354626766.pdf 
threshold <- 20

# migratory temps - sac, months = 3:5
# holding temps - trib specific; 5-7

standard_temp <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
                                         bucket = gcs_get_global_bucket()))

# temperature covariates: migratory temperature (march - may in sacramento river)
migratory_temp <- standard_temp |> 
  filter(stream == "sacramento river") |> 
  filter(month(date) %in% 3:5) |> 
  group_by(year(date)) |> 
  mutate(above_threshold = ifelse(mean_daily_temp_c > threshold, TRUE, FALSE)) |> 
  summarise(prop_days_exceed_threshold = round(sum(above_threshold, na.rm = T)/length(above_threshold), 2)) |> 
  ungroup() |> 
  mutate(prop_days_below_threshold = 1 - prop_days_exceed_threshold,
         prop_days_below_threshold = ifelse(prop_days_below_threshold == 0, 0.001, prop_days_below_threshold)) |> 
  rename(year = `year(date)`) |> 
  glimpse()

# temperature covariates: migratory temperature (may - july by tributary)
holding_temp <- standard_temp |> 
  filter(month(date) %in% 5:7) |> 
  group_by(year(date), stream) |> 
  mutate(above_threshold = ifelse(mean_daily_temp_c > threshold, TRUE, FALSE)) |> 
  summarise(prop_days_exceed_threshold = round(sum(above_threshold, na.rm = T)/length(above_threshold), 2)) |> 
  ungroup() |> 
  mutate(prop_days_below_threshold = 1 - prop_days_exceed_threshold,
         prop_days_below_threshold = ifelse(prop_days_below_threshold == 0, 0.001, prop_days_below_threshold)) |> 
  rename(year = `year(date)`) |> 
  glimpse()


# draft model for each of the four streams --------------------------------

streams <- c("battle creek", "clear creek", "deer creek", "mill creek")

# simple linear regression: prespawn mortality vs temperature

# provide exploratory plots to evaluate the variation across streams

# plots showing relationships between redd and passage, ratio to temp (or redd to temp, passage to temp)
# cumulative normal plots of passage
# additional thinking and exploration of year effect



# scratch -----------------------------------------------------------------

# linear model of prespawn mortality (upstream - redd) to get intercept
upstream_passage_clear <- upstream_passage |> 
  filter(stream %in% c("battle creek", "clear creek", "yuba river")) |> 
  rename(upstream_count = count)

redd_clear <- redd |> 
  filter(stream %in% c("battle creek", "clear creek", "yuba river")) |> 
  rename(redd_count = count)

clear_prespawn <- upstream_passage_clear |> 
  left_join(redd_clear, by = c("year", "stream")) |> 
  mutate(female_upstream = upstream_count * 0.5,
         prespawn_survival = redd_count / female_upstream,
         prespawn_survival = ifelse(prespawn_survival > 1, 1, prespawn_survival)) |> 
  glimpse()

temp_prespawn <- left_join(clear_prespawn, migratory_temp |> 
                             select(year, migratory_prop_days_exceed_threshold = prop_days_exceed_threshold),
                           by = "year") |> 
  left_join(holding_temp |> 
              select(year, stream, holding_prop_days_exceed_threshold = prop_days_exceed_threshold)) |> 
  mutate(total_prop_days_exceed_threshold = ifelse(is.na(holding_prop_days_exceed_threshold), migratory_prop_days_exceed_threshold, 
                                                   holding_prop_days_exceed_threshold + migratory_prop_days_exceed_threshold)) |> 
  glimpse()

temp_prespawn |> 
  ggplot(aes(x = total_prop_days_exceed_threshold, y = prespawn_survival, fill = stream)) + 
  geom_point(aes(color = stream)) + geom_smooth(method = "lm") 

m <- lm(data = temp_prespawn, prespawn_survival ~ total_prop_days_exceed_threshold + stream)
summary(m)

# TODO try median 7-day maximum temps (pull from gauges)

surv_factor <- coef(m)[1] # TODO find estimates

temp_prespawn_scaled <- temp_prespawn |> 
  select(year, stream, prespawn_survival, total_prop_days_exceed_threshold) |> 
  mutate(scaled_prop_days_exceed = total_prop_days_exceed_threshold * surv_factor) |> 
  glimpse()

temp_index <- temp_prespawn_scaled |> 
  group_by(year) |> 
  summarise(temp_index = mean(scaled_prop_days_exceed, na.rm = T)) |> 
  ungroup() |> 
  mutate(temp_index = ifelse(is.na(temp_index), 1, temp_index))

