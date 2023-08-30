# Scripts to prepare data for model
library(lubridate)
library(tidyverse)
library(ggplot2)
library(ggridges)
theme_set(theme_minimal())
source("data/standard-format-data/pull_data.R") # pulls in all standard datasets on GCP
f <- function(input, output) write_csv(input, file = output)

colors_full <-  c("#9A8822", "#F5CDB4", "#F8AFA8", "#FDDDA0", "#74A089", #Royal 2
                  "#899DA4", "#C93312", "#DC863B", # royal 1 (- 3)
                  "#F1BB7B", "#FD6467", "#5B1A18", "#D67236",# Grand Budapest 1 (-4)
                  "#D8B70A", "#02401B", "#A2A475", # Cavalcanti 1
                  "#E6A0C4", "#C6CDF7", "#D8A499", "#7294D4", #Grand Budapest 2
                  "#9986A5", "#EAD3BF", "#AA9486", "#B6854D", "#798E87", # Isle of dogs 2 altered slightly
                  "#F3DF6C", "#CEAB07", "#D5D5D3", "#24281A", # Moonriese 1, 
                  "#798E87", "#C27D38", "#CCC591", "#29211F", # moonrise 2
                  "#85D4E3", "#F4B5BD", "#9C964A", "#CDC08C", "#FAD77B" # moonrise 3 
)

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
  filter(count > 0, species == "chinook salmon",  run == "spring") %>%
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

spring_run_catch |> 
  filter(count < 100000) |> 
  ggplot(aes(x = count, y = stream, fill = stream)) +
  scale_fill_manual(values = colors_full) + 
  geom_density_ridges(quantile_lines = TRUE, 
                      quantiles = c(0.025, 0.975), 
                      alpha = 0.5,
                      scale = 0.75) + 
  theme(legend.position = "none",
        text = element_text(size = 20)) + 
  labs(title = "Annual Distribution in Total Spring run Chinook RST Catch", 
       x = "Total Annual Catch", 
       y = "")

spring_run_catch |> 
  # filter(count < 100000) |> 
  ggplot(aes(x = count, y = stream, fill = stream)) +
  scale_fill_manual(values = colors_full) + 
  geom_boxplot(quantile_lines = TRUE, 
           quantiles = c(0.025, 0.975), 
           alpha = 0.5,
           scale = 0.75) + 
  theme(legend.position = "none",
        text = element_text(size = 20)) + 
  labs(title = "Annual Distribution in Total Spring run Chinook RST Catch", 
       x = "Total Annual Catch", 
       y = "")

feather_permit_nums <- sum(c(75, 300, 5000, 3250, 25, 3, 10000))
  