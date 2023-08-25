# Scripts to prepare data for model
library(lubridate)
library(tidyverse)
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP
f <- function(input, output) write_csv(input, file = output)

catch_raw <- read_csv(here::here("data","standard-format-data", "standard_rst_catch.csv"))
# flow_raw <- read_csv(here::here("data","standard-format-data", "standard_flow.csv"))
recapture_raw <- read_csv(here::here("data","standard-format-data", "standard_recapture.csv"))
release_raw <- read_csv(here::here("data","standard-format-data", "standard_release.csv"))

catch_sample_date <- catch_raw %>% 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) - 1, year(date))) %>% 
  group_by(wy, stream) %>% 
  summarize(sample_date = min(date))

catch_date <- catch_raw %>% 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) - 1, year(date))) %>% 
  # filter(run == "spring", count > 0) %>% 
  group_by(wy, stream) %>% 
  summarize(catch_date = min(date))

catch_and_sample_date <- left_join(catch_sample_date, catch_date)

# filter stream and years where catch_date > sample_date

catch_and_sample_date_filtered <- catch_and_sample_date %>% 
  filter(catch_date > sample_date) %>% 
  select(wy, stream)

spring_run_catch <- catch_raw %>% 
  filter(count > 0, species == "chinook salmon", run == "spring") %>%
  mutate(day = day(date),
         month = month(date),
         year = year(date),
         water_year = ifelse(month %in% 10:12, year + 1, year),
         fake_date = as_date(paste(ifelse(month %in% 10:12, 1999, 2000), month, day))) %>%
  group_by(water_year, stream) %>%
  # handling multiple sites: take max catch on a given day
  summarize(count = sum(count, na.rm = TRUE)) |> glimpse()

spring_run_catch |> 
  # filter(count < 000) |> 
  ggplot(aes(x = count, color = stream)) +
  geom_density(position = "identity", alpha = .3) + 
  theme_minimal() +
  facet_wrap(~stream, scales = "free")

feather_permit_nums <- sum(c(75, 300, 5000, 3250, 25, 3, 10000))
  