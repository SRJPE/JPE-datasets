library(tidyverse)
library(lubridate)
catch_data <- read_csv("data/standard-format-data/standard_catch.csv")  |>  glimpse()

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
