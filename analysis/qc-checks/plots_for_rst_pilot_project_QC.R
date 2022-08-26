library(tidyverse)
library(lubridate)
catch_data <- read_csv("data/standard-format-data/standard_catch.csv")  |>  glimpse()
env_data <- read_csv("data/standard-format-data/standard_environmental.csv")
ops_data <- read_csv("data/standard-format-data/standard_trap.csv")

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

# LAST 5 year density lines in gray 
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
       y = " ",
       # title = "Today's Fork Length values with historical data", 
       # subtitle = "Point Plot of today's fork length data with desity curves of fork length dirstibution for the last five years."
       ) +
  theme(axis.text.y = element_blank(),
        legend.position = c(0.8, 0.8))


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
       y = " ",
       # title = "Today's Fork Length values with historical data", 
       # subtitle = "Point Plot of today's fork length data with desity curves of fork length dirstibution for the last five years."
  ) +
  theme(axis.text.y = element_blank(),
        legend.position = c(0.8, 0.8))


catch_data %>% group_by(stream, site) %>% 
  summarise(na_count = sum(is.na(weight)),
            percent_na = na_count/n())


# Env conditions ---------------------------------------------------------------
# flow
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
  geom_line(aes(x = date, y = flow)) +
geom_point(data = qc_day, aes(x = date, y = flow), color = "red", size = 3) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Flow (cfs)")

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
