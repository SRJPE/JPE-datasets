# pull in and prep data for adult model

# libraries ---------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(rstan)
library(bayesplot)
library(GGally) # pairs plot
library(waterYearType)

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

# TODO holding time by stream and year
# TODO pull in standard flow


# temperature -------------------------------------------------------------

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
  select(year, prop_days_exceed_threshold_migratory = prop_days_exceed_threshold) |> 
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
  select(prop_days_exceed_threshold_holding = prop_days_exceed_threshold,
         stream, year) |> 
  glimpse()



# flow --------------------------------------------------------------------

standard_flow <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_flow.csv",
                                         bucket = gcs_get_global_bucket())) |> 
  mutate(year = year(date)) |> 
  group_by(stream, year) |> 
  summarise(mean_flow = mean(flow_cfs, na.rm = T)) |> 
  glimpse()

# prespawn survival -------------------------------------------------------

streams <- c("battle creek", "clear creek", "deer creek", "mill creek")

prespawn_survival <- inner_join(upstream_passage |> 
                                  rename(upstream_count = count), 
                                redd |> 
                                  rename(redd_count = count), 
                                by = c("year", "stream")) |> 
  mutate(female_upstream = upstream_count * 0.5,
         prespawn_survival = redd_count / female_upstream,
         prespawn_survival = ifelse(prespawn_survival > 1, 1, prespawn_survival)) |>
  filter(stream %in% streams) |> 
  glimpse()


# passage timing ----------------------------------------------------------
upstream_passage_timing <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                            bucket = gcs_get_global_bucket())) |> 
  filter(!is.na(date)) |> 
  mutate(stream = tolower(stream),
         year = year(date),
         week = week(date)) |>
  filter(run %in% c("spring","not recorded")) |> 
  group_by(year, passage_direction, stream) |>
  summarise(count = sum(count, na.rm = T),
            median_passage_timing = median(week, na.rm = T)) |> 
  ungroup() |> # TODO worry about up-down
  select(-c(passage_direction, count)) |> 
  glimpse()



# water year --------------------------------------------------------------

water_year_data <- waterYearType::water_year_indices

# combine -----------------------------------------------------------------

survival_model_data <- left_join(prespawn_survival, 
                                migratory_temp, 
                                by = c("year")) |> 
  left_join(holding_temp,
            by = c("year", "stream")) |> 
  mutate(total_prop_days_exceed_threshold = ifelse(is.na(prop_days_exceed_threshold_migratory), prop_days_exceed_threshold_holding, 
                                                   (prop_days_exceed_threshold_migratory + prop_days_exceed_threshold_holding) / 2)) |>
  left_join(standard_flow, 
            by = c("year", "stream")) |> 
  left_join(upstream_passage_timing, 
            by = c("year", "stream")) |> 
  left_join(water_year_data |> 
              select(WY, water_year_type = Yr_type),
            by = c("year" = "WY")) |> # TODO add water year (keep month in this dataset) |> 
  mutate(water_year_type = tolower(water_year_type)) |> 
  glimpse()



survival_model_data |> 
  ggplot(aes(x = total_prop_days_exceed_threshold, y = prespawn_survival, fill = stream)) + 
  geom_point(aes(color = stream)) + geom_smooth(method = "lm")

survival_model_data |> 
  ggplot(aes(x = mean_flow, y = prespawn_survival, fill = stream)) + 
  geom_point(aes(color = stream)) + geom_smooth(method = "lm") 

survival_model_data |> 
  filter(stream == "mill creek") |> 
  ggplot(aes(x = mean_flow, y = prespawn_survival)) + 
  geom_point(aes(color = stream))

survival_model_data |> 
  filter(stream != "mill creek") |> 
  ggplot(aes(x = median_passage_timing, y = prespawn_survival, fill = stream)) + 
  geom_point(aes(color = stream)) + geom_smooth(method = "lm")

survival_model_data |> 
  ggplot(aes(x = upstream_count, y = prespawn_survival, fill = stream)) + 
  geom_point(aes(color = stream)) + geom_smooth(method = "lm")
  



# draft model for each of the four streams --------------------------------

battle_model_data <- survival_model_data |> 
  filter(stream == "battle creek")

ggpairs(battle_model_data)
m1 <- lm(prespawn_survival ~ total_prop_days_exceed_threshold + mean_flow + median_passage_timing + water_year_type,
         data = battle_model_data)
summary(m1)
m2 <- 


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

