# This script prepares the data and plots that will be used for the LHD ruleset workshop
# for determining cutoffs for yearlings.

# pull in the most recent model data
library(googleCloudStorageR)
library(tidyverse)
library(lubridate)
library(plotly)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)
daily_catch_unmarked <- read_csv("data/model-data/daily_catch_unmarked.csv")

# dotplots for length and date for each stream and year and one with all years
# we will put these in a shiny app because will be easier to navigate the many
# plots

# butte 
butte_catch <- filter(daily_catch_unmarked, stream == "butte creek", 
                      fork_length < 1000) |> 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date)))
# butte - 2019
# need to set the x-axis to start in november

# set water year
water_year = 2019
# set max_date for xlim
max_date = butte_catch |> filter(wy == water_year) |> 
  summarize(max(date, na.rm = T)) |> magrittr:::extract2(1)

filter(butte_catch, wy == water_year) |> 
  ggplot(aes(x = date, y = fork_length)) +
  geom_point() +
  scale_x_date(date_breaks = "1 month", date_labels = "%b",
               limits = c(ymd(paste0(water_year-1, "-10-01")), ymd(paste(max_date)))) +
  labs(y = "fork length (mm)",
       x = "")


# try plot_ly -------------------------------------------------------------

water_year = 2018:2019
selected_stream = "butte creek"

data <- filter(daily_catch_unmarked, stream == selected_stream) |> 
  mutate(wy = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) |> 
  filter(wy == water_year)

# for setting xlim
max_date = data |> 
  summarize(max(date, na.rm = T)) |> magrittr:::extract2(1)

# plot
plot_ly(data = data |> 
          filter(fork_length < 1000), x = ~date, y = ~fork_length,
        color = ~wy, colors = "Set1",
        type = "scatter", mode = "markers",
        marker = list(size = 8,
                      opacity = 0.8)) |> 
  layout(xaxis = list(range = c(ymd(paste0(min(water_year)-1, "-10-01"), ymd(paste(max_date)))),
                      title = ""),
         yaxis = list(title = "Fork length (mm)"))

