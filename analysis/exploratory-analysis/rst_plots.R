library(readr)
library(tidyverse)
library(lubridate)
library(scales)

rst_data <- read_rds("data/rst/combined_rst.rds")

glimpse(rst_data)

# Cuml catch all watersheds all years
cuml_catch <- rst_data %>%
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date)),
         fake_date = as_date(paste(ifelse(month(date) %in% 10:12, 1999, 2000), month(date), day(date)))) %>% 
  arrange(date) %>%
  group_by(water_year) %>%
  mutate(count = ifelse(is.na(count), 0, count), 
         cumulative_catch = cumsum(count)) %>% glimpse

# Cumulative catch by year, might look nice as plotly where you hover over to get year
cuml_catch %>% 
  ggplot() +
  geom_line(aes(x = fake_date, y = cumulative_catch, color = as.character(water_year))) +
  theme_minimal() + 
  theme(text = element_text(size = 23),
        plot.subtitle =  element_text(size = 17),
        legend.position = 'bottom', 
        legend.title = element_blank(),
        legend.text = element_text(size = 15)) +
  scale_x_date(labels = date_format("%b")) +
  labs(x = "Date", 
       y = "Cumulative Catch")

# Cuml catch by watershed 
cuml_catch_by_watershed <- rst_data %>%
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date)),
         fake_date = as_date(paste(ifelse(month(date) %in% 10:12, 1999, 2000), month(date), day(date)))) %>% 
  arrange(date) %>%
  group_by(watershed, water_year) %>%
  mutate(count = ifelse(is.na(count), 0, count), 
         cumulative_catch = cumsum(count)) %>% glimpse

# All watersheds facetted on year
cuml_catch_by_watershed %>% ggplot() +
  geom_line(aes(x = fake_date, y = cumulative_catch, color = watershed)) +
  theme_minimal() + 
  theme(text = element_text(size = 23),
        plot.subtitle =  element_text(size = 17),
        legend.position = 'bottom', 
        legend.title = element_blank(),
        legend.text = element_text(size = 15)) + 
  facet_wrap(~water_year, scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "3 months") + 
  labs(x = "Date", 
       y = "Cumulative Catch")

# single watershed 
plot_cuml_catch <- function(watershed_selected) {
  cuml_catch_by_watershed %>% 
    filter(watershed == watershed_selected) %>%
    ggplot() +
    geom_line(aes(x = fake_date, y = cumulative_catch, color = as.character(water_year))) +
    theme_minimal() + 
    theme(text = element_text(size = 23),
          plot.subtitle =  element_text(size = 17),
          legend.position = 'bottom', 
          legend.title = element_blank(),
          legend.text = element_text(size = 15)) + 
    scale_x_date(labels = date_format("%b"), date_breaks = "3 months") + 
    labs(x = "Date", 
         y = "Cumulative Catch",
         title = paste(watershed_selected, "Cumulative Catch by Water Year"))
}

plot_cuml_catch("Battle Creek")
plot_cuml_catch("Butte Creek")
plot_cuml_catch("Clear Creek")
plot_cuml_catch("Deer Creek")
plot_cuml_catch("Feather River")
plot_cuml_catch("Mill Creek")
plot_cuml_catch("Yuba River")
plot_cuml_catch("Lower Sac")
