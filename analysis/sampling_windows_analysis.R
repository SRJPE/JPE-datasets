library(tidyverse)
library(ggplot2)
library(googleCloudStorageR)
library(lubridate)
library(extrafont)
library(grid)
library(gridExtra)

color_pal <- c("#9A8822",  "#F8AFA8", "#FDDDA0", "#74A089", "#899DA4", "#446455", "#DC863B", "#C93312")

# load in catch data
Sys.setenv("GCS_AUTH_FILE" = "config.json", "GCS_DEFAULT_BUCKET" = "jpe-dev-bucket")
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
# # 
View(gcs_list_objects())
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_trap.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_trap.csv",
#                overwrite = TRUE)

# gcs_get_object(object_name = "standard-format-data/standard_rst_catch_lad.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch_lad.csv",
#                overwrite = TRUE)

# use LAD one! 
# catch <- read_csv("data/standard-format-data/standard_rst_catch.csv") %>% glimpse()
catch <- read_csv("data/standard-format-data/standard_rst_catch_lad.csv") %>% glimpse()

trap_operations <- read_csv("data/standard-format-data/standard_trap.csv") %>% glimpse()

catch$stream %>% unique()
catch$site %>% unique()

trap_operations$stream %>% unique()

selected_stream = "battle creek"
plot_windows <- function(selected_stream){
  years <- catch |> 
    filter(run == "spring", stream == selected_stream) |> 
    filter(!is.na(date)) %>% 
    mutate(year = year(date)) |> 
    pull(year) |> 
    unique() |> 
    length()
    
  filtered_data <- catch |> 
    filter(run == "spring", stream == selected_stream) |> 
    filter(!is.na(date)) %>% 
    mutate(fake_date = as.Date(paste0(ifelse(month(date) %in% c(9, 10, 11, 12), "0000-", "0001-"), 
                                      month(date), "-", day(date)))) |> 
    group_by(fake_date) |> 
    summarise(count = sum(count, na.rm = TRUE)) 
    
  filtered_data |> 
    ggplot(aes(x = fake_date, y = count)) +
    geom_point(alpha = .3, color = "gray") + 
    theme_minimal() 
  
  
  # Goal is to give minimum number of days to capture 95% of fish 
  cumulative_catch <- filtered_data |> 
    select(fake_date, count) |> 
    arrange(fake_date) |> 
    mutate(cumulative_catch = cumsum(count)) 
  
  cumulative_catch |> 
    ggplot(aes(x = fake_date, y = cumulative_catch)) +
    geom_line() + 
    theme_minimal()
  
  # current approach is biased twoards yeras that caught more fish 
  # We could also find windows for each year seperatly and take the average 
  
  # find sampling window that captures 90% of fish over full POR of data 
  # mid window 
  # 5% caught & 95% caught 
  total_fish <- max(cumulative_catch$cumulative_catch)
  start_threshold <- total_fish * .05
  end_threshild <- total_fish * .95
  sampling_window <- cumulative_catch |> 
    mutate(in_window = ifelse(cumulative_catch > start_threshold & 
                                cumulative_catch < end_threshild, TRUE, FALSE)) 
  
  min_date <- sampling_window |> 
    filter(in_window) |> 
    pull(fake_date) |> min()
  
  max_date <- sampling_window |> 
    filter(in_window) |> 
    pull(fake_date) |> max()
    
  caption <- paste("The sampling window that captures 90% of the catch based on \n data from", 
        years, "years of historical monitoring is", month.abb[month(min_date)], day(min_date), 
        "to", month.abb[month(max_date)], day(max_date))
  
  point_plot <- sampling_window |> 
    ggplot(aes(x = fake_date, y = count)) +
    geom_point() +
    geom_vline(xintercept = min_date, color = "red") +
    geom_vline(xintercept = max_date, color = "red") +
    theme_minimal() + 
    labs(y = "Catch", 
         x = "")
  
  cuml_plot <- sampling_window |> 
    ggplot(aes(x = fake_date, y = cumulative_catch)) +
    geom_line() +
    geom_vline(xintercept = min_date, color = "red") +
    geom_vline(xintercept = max_date, color = "red") +
    labs(y = "Cumulative Catch", 
         x = "") + 
    theme_minimal() 
  
  gridExtra::grid.arrange(point_plot, cuml_plot, bottom = textGrob(caption))
}

plot_windows("battle creek")
# could also get into shortest window (starts later)


# Cumulative catch plot can show 5% and 95% 