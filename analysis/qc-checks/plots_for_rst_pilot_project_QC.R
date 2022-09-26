library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(wakefield)
catch_data <- read_csv("data/standard-format-data/standard_catch.csv")  |>  glimpse()
env_data <- read_csv("data/standard-format-data/standard_environmental.csv")
ops_data <- read_csv("data/standard-format-data/standard_trap.csv")
recapture_data <- read_csv("data/standard-format-data/standard_recapture.csv")
release <- read_csv("data/standard-format-data/standard_release.csv")

mark_recapture <- left_join(recapture_data, release, 
                            by = c("release_id" = "release_id", "stream" = "stream")) |> 
  group_by(stream, site, release_id, release_date, number_released) |> 
  summarize(total_fish_recaptured = sum(number_recaptured, na.rm = T), 
            median_fork_length_released = median(as.numeric(median_fork_length_released), na.rm = T),
            median_fork_length_recaptured = median(as.numeric(median_fork_length_recaptured), na.rm = T),
            flow_at_release = mean(flow_at_release, na.rm = T),
            temperature_at_release = mean(temperature_at_release, na.rm = T),
            turbidity_at_release = mean(turbidity_at_release, na.rm = T),
            efficiency = (total_fish_recaptured + 1)/(number_released + 1))  |>  glimpse()

padded_env_dates <- tibble(date = seq.Date(from = min(env_data$date, na.rm = T), 
         to = max(env_data$date, na.rm = T), by = "day"))
# FORK LENGTH ------------------------------------------------------------------

# Initial plot describing fork length and lifestage for fork length QC 
catch_data  |>
  filter(site == "knights landing") |> 
  filter(date == as.Date("2016-02-24")) |> 
  ggplot(aes(x = fork_length, fill = lifestage)) + 
  geom_vline(xintercept = 100, linetype = "dashed") +
  geom_vline(xintercept = 60, linetype = "dashed") + # think about this one as a fry juv cutoff 
  geom_histogram() + 
  theme_minimal()

# Boxplot with historical data vs todays catch data 
# Filter historical data to be +/- 1 week from todays catch date (5 years prior)
catch_data  |>  
  filter(site == "knights landing") |> 
  mutate(year = year(date), day = day(date), month = month(date)) |> 
  filter(day == 24, month == 2) |> 
  mutate(todays_catch = ifelse(year == 2016,
                               "today", "historical")) |> 
  ggplot(aes(y = fork_length, x = todays_catch, color = todays_catch)) + 
  geom_boxplot() + 
  geom_point() +
  theme_minimal()


# day points with historical densities
qc_day <- catch_data  |>  
  filter(site == "mill creek") |> 
  # group_by(date) |>
  # summarise(total_count = sum(count, na.rm = T)) |>
  # filter(total_count > 50) |> 
  filter(date == as.Date("1996-02-16")) |> glimpse()

library(waterYearType)
water_year_type <- waterYearType::water_year_indices |> 
  filter(location == "Sacramento Valley") |> 
  select(water_year = WY, year_type = Yr_type)
  
catch_data  |>  
  filter(site == "mill creek") |> 
  mutate(year = year(date), day = day(date), month = month(date),
         water_year = ifelse(month %in% 10:12, year + 1, year)) |> 
  left_join(water_year_type) |> 
  mutate(year = as.character(year(date))) |> 
  ggplot() +
  geom_density(aes(x = fork_length,  color = year_type)) +
  geom_point(data = qc_day, aes(x = fork_length, y = 0, color = lifestage)) +
  theme_minimal() + 
  labs(x = "Fork Length (mm)", 
       y = " ") +
  theme(axis.text.y = element_blank())

### Plots for QC interface -----------------------------------------------------
# measures & associated variables ----------------------------------------------
# fork length
qc_day <- catch_data  |>  
  filter(site == "lcc") |> 
  # group_by(date) |>
  # summarise(total_count = sum(count, na.rm = T)) |>
  # filter(total_count > 50) |> glimpse()
  filter(date == as.Date("2003-12-15")) |> glimpse()


catch_data  |>  
  filter(site == "lcc") |> 
  mutate(year = year(date), day = day(date), month = month(date),
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_water_year = max(water_year)) |> 
  filter(water_year > max_water_year - 5) |> 
  mutate(year = as.character(year(date))) |> 
  ggplot() +
  geom_density(aes(x = fork_length, group = water_year), color = "gray", size = 1.05) +
  geom_point(data = qc_day, aes(x = fork_length, y = 0, color = lifestage), size = 2) +
  theme_minimal() + 
  labs(x = "Fork Length (mm)", 
       y = "Density",
       # title = "Today's Fork Length values with historical data", 
       # subtitle = "Point Plot of today's fork length data with desity curves of fork length dirstibution for the last five years."
       ) +
  theme(legend.position = c(0.8, 0.8))


# WEIGHT -----------------------------------------------------------------------
# Data is very sparse, plots are not that helpful
qc_day <- catch_data  |>  
  filter(site == "tisdale") |> 
  # group_by(date) |>
  # summarise(total_count = sum(count, na.rm = T),
  #           num_na_weight = sum(is.na(weight))) |>
  # filter(total_count > 50) |> View()
  filter(date == as.Date("2011-03-07")) |> glimpse()


catch_data  |>  
  filter(site == "tisdale") |> 
  mutate(year = year(date), day = day(date), month = month(date),
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_water_year = max(water_year)) |> 
  filter(water_year > max_water_year - 5) |> 
  mutate(year = as.character(year(date))) |> 
  ggplot() +
  geom_density(aes(x = weight, group = water_year), color = "gray", size = 1.05, na.rm = T) +
  geom_point(data = qc_day, aes(x = weight, y = 0, color = lifestage), size = 2) +
  theme_minimal() + 
  labs(x = "Weight (g)", 
       y = "Density",
       # title = "Today's Fork Length values with historical data", 
       # subtitle = "Point Plot of today's fork length data with desity curves of fork length dirstibution for the last five years."
  ) +
  theme(legend.position = c(0.8, 0.8))


catch_data %>% group_by(stream, site) %>% 
  summarise(na_count = sum(is.na(weight)),
            percent_na = na_count/n())


qc_day <- catch_data  |>  
  filter(site == "mill creek") |> 
  group_by(stream, site, date)  |> 
  summarize(total_count = sum(count, na.rm = T)) |> 
  mutate(max_date = max(date, na.rm = T),
         fk_year = 1900,
         water_year = ifelse(month(date) %in% 10:12, fk_year - 1, fk_year),
         fake_date = as_date(paste(fk_year,"-", month(date), "-", day(date)))) |> 
  filter(date == max_date) |>  glimpse()

# TOTAL count
catch_data %>% 
  filter(site == "mill creek") |> 
  mutate(fk_year = 1900,
         water_year = ifelse(month(date) %in% 10:12, year(date) - 1, year(date)), 
         fk_water_year = ifelse(month(date) %in% 10:12, fk_year - 1, fk_year),
         max_water_year = max(water_year)) |> 
  filter(water_year > max_water_year - 5) |> 
  group_by(stream, site, date, water_year, fk_water_year) |> 
  summarize(total_count = sum(count, na.rm = T)) |> 
  mutate(year = as.character(year(date)), 
         fake_date = as_date(paste(fk_water_year,"-", month(date), "-", day(date))),
         water_year = as.character(water_year)) |> 
  ggplot(aes(x = fake_date, y = total_count, group = water_year)) +
  geom_line(color = "gray", size = 1) +
  geom_point(data = qc_day, aes(x = fake_date, y = total_count), color = "red", size = 3) + 
  scale_x_date(date_breaks = "1 month", date_labels = "%B") + 
  theme_minimal() + 
  labs(x = "Date", 
       y = "Total Daily Catch")
  

# Env conditions ---------------------------------------------------------------
# flow
qc_day <- env_data  |>  
  filter(site == "mill creek") |> 
  mutate(max_date = max(date, na.rm = T)) |> 
  filter(date == max_date) |>  glimpse()

env_data |> 
  full_join(padded_env_dates) |> 
  filter(site == "deer creek") |> 
  mutate(year = year(date), 
         month = month(date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T),
         color_NA = ifelse(is.na(flow), TRUE, FALSE)) |>  
  filter(water_year > max_year - 2) |> 
ggplot() +
  geom_point(aes(x = date, y = flow)) +
  geom_line(aes(x = date, y = flow), linetype = "dashed", color = "gray") +
geom_point(data = qc_day, aes(x = date, y = flow), color = "red", size = 3) +
  # geom_ribbon(aes(x = date, ymin = 0, ymax = flow, fill = color_NA)) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Flow (cfs)")

# flow lolipop
env_data |> 
  filter(site == "mill creek") |> 
  mutate(year = year(date), 
         month = month(date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T)) |>  
  filter(water_year > max_year - 2) |> 
  ggplot() +
  geom_point(aes(x = date, y = flow)) +
  geom_segment(aes(x = date, y = flow, xend = date, yend = 0)) +
  geom_point(data = qc_day, aes(x = date, y = flow), color = "red", size = 4) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Flow (cfs)") +
  geom_segment(aes(x = as_date("2009-06-10"), 
                   xend = as_date("2009-10-15"),
                   y = 0, yend = 0), color = "red", size = 1)

# temp
qc_day <- env_data  |>  
  filter(site == "mill creek") |> 
  mutate(max_date = max(date, na.rm = T)) |> 
  filter(date == max_date) |>  glimpse()

env_data |> 
  filter(site == "mill creek") |> 
  mutate(year = year(date), 
         month = month(date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T)) |>  
  filter(water_year > max_year - 2) |> 
  ggplot() +
  geom_line(aes(x = date, y = temperature)) +
  geom_point(data = qc_day, aes(x = date, y = temperature), color = "red", size = 3) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Temperature (°C)")

# temp lolipop
env_data |> 
  filter(site == "mill creek") |> 
  mutate(year = year(date), 
         month = month(date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T)) |>  
  filter(water_year > max_year - 2) |> 
  ggplot() +
  geom_point(aes(x = date, y = temperature)) +
  geom_segment(aes(x = date, y = temperature, xend = date, yend = 0)) +
  geom_point(data = qc_day, aes(x = date, y = temperature), color = "red", size = 4) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Temperature (C)") +
  geom_segment(aes(x = as_date("2009-06-10"), 
                   xend = as_date("2009-10-15"),
                   y = 0, yend = 0), color = "red", size = 1)

# turbidity
qc_day <- env_data  |>  
  filter(site == "mill creek") |> 
  mutate(max_date = max(date, na.rm = T)) |> 
  filter(date == max_date) |>  glimpse()

env_data |> 
  filter(site == "mill creek") |> 
  mutate(year = year(date), 
         month = month(date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T)) |>  
  filter(water_year > max_year - 2) |> 
  ggplot() +
  geom_line(aes(x = date, y = turbidity)) +
  geom_point(data = qc_day, aes(x = date, y = turbidity), color = "red", size = 3) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Turbidity (NTU)")

# Trap operations --------------------------------------------------------------
# TODO figure out best way to visualize this one density plot? 
qc_day <- ops_data  |>  
  filter(site == "hallwood") |> 
  mutate(max_date = max(trap_stop_date, na.rm = T)) |> 
  filter(trap_stop_date == max_date) |>  glimpse()


ops_data |> 
  filter(site == "hallwood", rpms_start < 1000) |> 
  mutate(year = year(trap_stop_date), 
         month = month(trap_stop_date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = max(water_year, na.rm = T)) |>  
  filter(water_year > max_year - 1) |> 
  ggplot() +
  geom_density(aes(x = rpms_start), alpha = .5) +
  geom_density(aes(x = rpms_end), color = "blue", alpha = .5) +
  geom_point(data = qc_day, aes(y = 0, x = rpms_start), color = "red", size = 3) +
  geom_point(data = qc_day, aes(y = 0, x = rpms_end), color = "red", size = 3) +
  theme_minimal() + 
  labs(x = "RPM", 
       y = "")

ops_data |> filter(!is.na(debris_volume)) |> View()


# categorical variables --------------------------------------------------------
# adipose clipped 
catch_data  |>  
  filter(site == "tisdale") |> 
  mutate(year = year(date), day = day(date), month = month(date),
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_water_year = max(water_year),
         time = ifelse(date == max(date, na.rm = T), "today", "historical")) |> 
  filter(water_year > max_water_year - 5) |>
  group_by(time) |> 
  summarise("Clipped" = sum(adipose_clipped == TRUE)/n(),
            "Not Clipped" = sum(adipose_clipped == FALSE)/n()) |> 
  pivot_longer(c("Clipped", "Not Clipped"), 
               names_to = "Adipose Clipped", 
               values_to = "Percent Clipped") |> 
  ggplot() +
  geom_col(aes(x = `Adipose Clipped`, y = `Percent Clipped`, 
               fill = time), position = 'dodge') +
  theme_minimal() + 
  labs(x = "", 
       y = "Percent") +
  theme(legend.position = c(0.1, 0.9),
        legend.title = element_blank())


# FAKE Data for adipose clipped

times <-  seq.POSIXt(from = as.POSIXct("2022-01-01 00:00:00"), to = as.POSIXct("2022-01-01 04:00:00"), by = "5 mins")
adipose_clipped <- wakefield::r_sample_logical(49, prob = NULL, name = "Logical")

clipped_values <- tibble(times, adipose_clipped)

clipped_values |> 
  ggplot() +
  geom_point(aes(x = times, y = adipose_clipped, color = adipose_clipped), 
             size = 2) + 
  theme_minimal() + 
  labs(x = "Sampling Time", 
       y = "Adipose Clipped") +
  theme(legend.position = "none")

# species
catch_data  |>  
  filter(site == "mill creek") |> 
  mutate(year = year(date), day = day(date), month = month(date),
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_water_year = max(water_year),
         time = ifelse(date == max(date, na.rm = T), "today", "historical")) |> 
  filter(water_year > max_water_year - 5) |> 
  group_by(time) |> 
  summarise("Chinook" = sum(species == "chinook salmon")/n(),
            "Steelhead" = sum(species == "steelhead")/n(),
            "Other" = 1 - Chinook - Steelhead) |> 
  pivot_longer(c("Chinook", "Steelhead", "Other"), 
               names_to = "Species", 
               values_to = "Percent") |> 
  ggplot() +
  geom_col(aes(x = Species, y = Percent, 
               fill = time), position = 'dodge') +
  theme_minimal() + 
  labs(x = "", 
       y = "Percent") +
  theme(legend.position = c(0.2, 0.8))

## Efficiency trial plots ------------------------------------------------------

qc_day <- mark_recapture  |>  
  filter(site == "ubc") |> 
  # group_by(release_date) |> View()
  filter(release_date == as.Date("2021-03-02")) |> distinct() |> glimpse()

mark_recapture |> 
  filter(site == "ubc") |> 
  mutate(year = year(release_date), 
         month = month(release_date), 
         water_year = ifelse(month %in% 10:12, year + 1, year),
         max_year = 2021) |>  
  filter(water_year > max_year - 5) |>
  mutate(year = as.character(year(release_date))) |> 
  ggplot() +
  geom_density(aes(x = efficiency, group = year), color = "gray", size = 1.05, na.rm = T) +
  geom_point(data = qc_day, aes(x = efficiency, y = 0, size = number_released)) +
  theme_minimal() + 
  labs(x = "Efficiency", 
       y = "Density") +
  annotate(geom = "text", x = .1, y = 130, label = paste("Number Released: 320")) +
  annotate(geom = "text", x = .1, y = 120, label = paste("Number Recaptured: 14")) +
  theme(legend.position = "none")
