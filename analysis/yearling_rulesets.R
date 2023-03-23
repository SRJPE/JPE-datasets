library(googleCloudStorageR)
library(tidyverse)
library(lubridate)
library(waterYearType)
library(viridis)
library(stringr)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Get data for google bucket
gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "analysis/data/daily_catch_unmarked.csv",
               overwrite = TRUE)

gcs_get_object(object_name = "standard-format-data/weekly_yearling_cutoff.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "analysis/data/weekly_yearling_cutoff.csv",
               overwrite = TRUE)

# load data ---------------------------------------------------------------

catch_data <- read_csv(here::here("analysis", "data", "daily_catch_unmarked.csv")) |> 
  filter(fork_length < 300) |> # for graph scaling, takes out a lot of butte creek
  filter(stream != "sacramento river") |> 
  mutate(week = week(date),
         week = if_else(week == 53, 52, week), # all December 30th or 31st
         month = month(date),
         day = ifelse(day(date) < 10, paste0("0", day(date)), day(date)),
         fake_year = ifelse(month %in% 10:12, 1971, 1972),
         # create fake date for plotting all years on same x axis
         fake_date = ymd(paste0(fake_year, "-",month, "-", day))) |> 
  select(true_fl = fork_length, week, stream, fake_date) |> 
  glimpse()

# this takes the day at the beginning of a week for plotting the 
# fork length cutoffs as points
fake_date_for_plot <- catch_data |> 
  group_by(week) |> 
  summarise(date_for_plot = min(fake_date)) |> 
  ungroup() |> 
  glimpse()

# read in rulesets from csv
rulesets <- read.csv(here::here("analysis", "data", "weekly_yearling_cutoff.csv")) |> 
  mutate(date_for_plot = as_date(date_for_plot))

# function to generate plots ----------------------------------------------
generate_yearling_plots <- function(catch_data, rulesets, stream_name) {
  rulesets_filtered <- rulesets |> 
    filter(stream == stream_name)
  
  data <- catch_data |> 
    filter(stream == stream_name) |> 
    # join manually-entered cutoffs by week
    # full join because butte is missing data for august in catch_data
    # and we need to keep the fl_cutoff values in the join
    full_join(rulesets_filtered, by = c("week", "stream"))
  
  # interpolate daily cutoff line from weekly cutoff values
  generate_cutoff <- approxfun(rulesets_filtered$date_for_plot,
                               rulesets_filtered$fl_cutoff, rule = 2)
  ruleset_lines <- tibble(
    rulesets_dates = seq(as.Date("1971-10-01"), as.Date("1972-09-30"), by = "day"),
    cutoff_line = generate_cutoff(rulesets_dates)
  )
  
  # format daily rulesets
  daily_ruleset <- ruleset_lines |> 
    mutate(month = month(rulesets_dates),
           day = day(rulesets_dates),
           cutoff = round(cutoff_line, 2),
           stream = stream_name) |> 
    select(stream, month, day, cutoff)
  
  # join interpolated line by date and then assign
  # yearling cutoffs based on the interpolated line
  data <- data |> 
    left_join(ruleset_lines, by = c("fake_date" = "rulesets_dates")) |> 
    mutate(is_yearling = case_when(true_fl <= cutoff_line ~ "Subyearling",
                                   true_fl > cutoff_line ~ "Yearling",
                                   is.na(cutoff_line) ~ "Missing weekly cutoff value"))
  
  # plot
  ggplot() + 
    geom_point(data, mapping = aes(x = fake_date, y = true_fl, 
                                   color = is_yearling), alpha = 0.6) +
    scale_x_date(date_breaks = "1 month", date_labels = "%b",
                 limits = c(ymd("1971-10-01"), ymd("1972-09-30"))) +
    labs(y = "fork length (mm)",
         x = "") +
    theme_minimal() +
    geom_line(ruleset_lines, mapping = aes(x = rulesets_dates, y = cutoff_line)) +
    ggtitle(paste0(str_to_title(stream_name))) + 
    theme(plot.title = element_text(hjust = 0.5)) + 
    labs(color = "Yearling designation") + 
    geom_point(rulesets_filtered, mapping = aes(x = date_for_plot, y = fl_cutoff), shape = 15) + 
    scale_color_manual(values = c("#440154FF", "#FDE725FF", "#21908CFF"),
                       breaks = c("Subyearling", "Yearling", "Missing weekly cutoff value"))
  
  write_csv(daily_ruleset, paste0("analysis/data/daily_yearling_ruleset_",stream_name, ".csv"))
  
  ggsave(filename = paste0("analysis/figures/", stream_name, "_plot.png"), dpi = 100, bg = "white",
         width = 1000, height = 600, units = "px")
  
}

# plot all streams and save to /plots 
for(i in unique(catch_data$stream)){
  generate_yearling_plots(catch_data, rulesets, i)
}

# combine rulesets 
battle <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_battle creek.csv"))
butte <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_butte creek.csv"))
clear <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_clear creek.csv"))
deer <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_deer creek.csv"))
feather <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_feather river.csv"))
mill <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_mill creek.csv"))
yuba <- read_csv(here::here("analysis", "data", "daily_yearling_ruleset_yuba river.csv"))

daily_yearling_ruleset <- bind_rows(battle,
                                    butte,
                                    clear,
                                    deer,
                                    feather,
                                    mill,
                                    yuba)
f <- function(input, output) write_csv(input, file = output)
gcs_upload(daily_yearling_ruleset,
           object_function = f,
           type = "csv",
           name = "standard-format-data/daily_yearling_ruleset.csv",
           predefinedAcl = "bucketLevel")