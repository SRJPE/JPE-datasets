
# libraries
library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(waterYearType)
library(clipr) #?write_clip
library(stringr)
library(viridis)

# color palettes [1] "#0D0887FF" "#2D0594FF" "#44039EFF" "#5901A5FF" "#6F00A8FF"
viridis(option = "plasma", 20) # to get hex codes
colors <- c("#DD5E66FF","#FEB72DFF", "#5901A5FF", "#F7E225FF") # for data type (upstream, holding, redd annual, carcass)
data_type_palette = c("upstream passage" = colors[1],
                      "holding" = colors[2],
                      "redd" = colors[3],
                      "carcass" = colors[4])


# get data ----------------------------------------------------------------

# upload data
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# read in data
# upstream passage
upstream_passage <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                 bucket = gcs_get_global_bucket())) |> 
  mutate(stream = tolower(stream)) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  glimpse()

# holding
holding <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
                                   bucket = gcs_get_global_bucket())) |> glimpse()


# redd
redd_daily <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
                                   bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> glimpse()
redd_annual <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
                                      bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> glimpse()

# carcass
# first get streams != yuba
carcass <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
                                   bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "unknown")) |> 
  glimpse()


# get range of years for each stream  -----------------------------
year_ranges <- bind_rows(upstream_passage |> 
                    mutate(year = year(date)) |> 
                    select(year, stream),
                  holding |> 
                    mutate(data_type = "holding") |> 
                    select(year, stream),
                  redd_annual |> 
                    mutate(data_type = "redd_annual") |> 
                    rename(count = max_yearly_redd_count) |> 
                    select(year, stream),
                  carcass |> 
                    mutate(year = year(date)) |> 
                    group_by(year, stream) |> 
                    summarise(count = sum(count, na.rm = T)) |> 
                  mutate(data_type = "carcass") |> 
                  select(year, stream)) |> 
  group_by(stream) |> 
  summarise(year_min = min(year, na.rm = T),
            year_max = max(year, na.rm = T)) |> 
  glimpse()


# plots by creek ----------------------------------------------------------------
streams <- c(unique(upstream_passage$stream), "butte creek", "feather river")
battle_clear <- c("battle creek", "clear creek")
non_battle_clear <- streams[!streams %in% battle_clear]

create_stream_plots <- function(upstream_passage, holding, redd_annual, carcass, stream_name,
                                year_ranges){
  # for battle and clear, reaches 6 and 7 are likely fall run so filter out
  if(stream_name %in% c("battle creek", "clear creek")){
    redd_annual <- redd_annual |> 
      filter(!reach %in% c("R6", "R6A", "R6B", "R7"))
    holding <- holding |> 
      filter(!reach %in% c("R6", "R6A", "R6B", "R7"))
    # carcass <- carcass |> 
    #   filter(!reach %in% c("R6", "R6A", "R6B", "R7"))
  }
  
  if(stream_name %in% unique(upstream_passage$stream)){
    upstream_passage <- upstream_passage |> 
      filter(stream == stream_name)
    # format upstream_passage for up-down
    if(sum(c("up", "down") %in% unique(upstream_passage$passage_direction)) >= 1){
      upstream_passage <- upstream_passage |>   
        group_by(year(date), passage_direction) |> 
        summarise(count = sum(count)) |> 
        ungroup() |> 
        rename(year = `year(date)`) |> 
        pivot_wider(names_from = passage_direction, values_from = count) |> 
        mutate(down = ifelse(is.na(down), 0, down), 
               up = ifelse(is.na(up), 0, up)) |> 
        group_by(year) |> 
        summarise(count = up - down) |> 
        select(year, count) |> 
        mutate(data_type = "upstream passage")
    } else {
      upstream_passage <- upstream_passage |> 
        group_by(year(date)) |> 
      summarise(count = sum(count)) |> 
        select(year = `year(date)`, count) |> 
        mutate(data_type = "upstream passage")
    }
  } else {
    upstream_passage <- NULL
  }
  
  if(stream_name %in% unique(holding$stream)){
    # format holding data
    holding <- holding |> 
      filter(stream == stream_name) |> 
      group_by(year) |> 
      summarise(count = sum(count, na.rm = T)) |> 
      select(year, count) |>
      mutate(data_type = "holding")
  } else {
    holding <- NULL
  }
  
  if(stream_name %in% unique(redd_annual$stream)){
    # format redd
    redd_annual <- redd_annual |> 
      filter(stream == stream_name) |> 
      group_by(year) |> 
      summarise(count = sum(max_yearly_redd_count, na.rm = T)) |> 
      select(year, count) |> 
      mutate(data_type = "redd")
  } else {
    redd_annual <- NULL
  }
  
  if (stream_name %in% unique(carcass$stream)){
    carcass <- carcass |> 
      filter(stream == stream_name) |>
      mutate(year = year(date)) |> 
      group_by(year) |> 
      summarise(count = sum(count, na.rm = T)) |> 
      select(year, count) |> 
      mutate(data_type = "carcass")
  } else {
    carcass <- NULL
  }
  
  # create dummy data that has what we want i.e. each data type for each year 
  # that exists in the stream's data
  yearly_ranges_stream <- year_ranges |> 
    filter(stream == stream_name)
  
  data_template <- bind_rows(tibble(year = rep(yearly_ranges_stream$year_min:yearly_ranges_stream$year_max),
                                    data_type = "upstream passage"),
                             tibble(year = rep(yearly_ranges_stream$year_min:yearly_ranges_stream$year_max),
                                    data_type = "holding"),
                             tibble(year = rep(yearly_ranges_stream$year_min:yearly_ranges_stream$year_max),
                                    data_type = "redd"),
                             tibble(year = rep(yearly_ranges_stream$year_min:yearly_ranges_stream$year_max),
                                    data_type = "carcass")) 
                             
  # bind all the data we have for that stream
  real_data <- bind_rows(upstream_passage, holding, redd_annual, carcass)
  
  # join with template to have placeholders for years with no data for a 
  # data_type; fill in those NAs with 0 so they are plotted but don't show
  # any data (this makes all geom_col the same width)
  full_data <- left_join(data_template, real_data, by = c("year", "data_type")) |> 
    mutate(count = if_else(is.na(count), 0, count))

  # plot
  full_data |>
    ggplot(aes(x=year, y=count, fill = data_type)) +
    geom_col(position = "dodge", width = 0.75) +
    xlab("Year") + ylab("Count") +
    ggtitle(paste0(str_to_title(stream_name), ": ", "Counts by Data Type")) +
    scale_fill_manual(values = data_type_palette, drop = T) +
    theme_minimal() +
    labs(fill = "") +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position="bottom")
}

# note: butte plot in the report uses estimates, not raw counts (see adult_plots_butte_estimates.R)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "battle creek", year_ranges)
#create_stream_plots(upstream_passage, holding, redd_annual, carcass, "butte creek", year_ranges)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "clear creek", year_ranges)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "deer creek", year_ranges)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "feather river", year_ranges)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "mill creek", year_ranges)
create_stream_plots(upstream_passage, holding, redd_annual, carcass, "yuba river", year_ranges)



# functions ---------------------------------------------------------------
# data completeness table function 
# gets percent NA of columns (excludes columns that are all NA) and 
# copies to clipboard
data_completeness <- function(data, stream_name) {
  if(missing(stream_name)){
    summary <- data |> 
      summarise_all(list(percent_na = ~sum(is.na(.))/length(.))) |> 
      pivot_longer(cols = everything(), values_to = "percent_na", names_to = "column_long") |>
      mutate(percent_na = round(percent_na, 4) * 100) |> 
      filter(percent_na < 100) |> 
      select(percent_na, column_long)
  }else {
    summary <- data |> 
      filter(stream == stream_name) |> 
      select(-stream) |> 
      summarise_all(list(percent_na = ~sum(is.na(.))/length(.))) |> 
      pivot_longer(cols = everything(), values_to = "percent_na", names_to = "column_long") |>
      mutate(#variable = names(data[-1]),
        percent_na = round(percent_na, 4) * 100) |> 
      filter(percent_na < 100) |> 
      select(percent_na, column_long) # removed variable
  }
  # print
  print(summary)
  # copy to clipboard
  write_clip(summary)
}


# deer creek --------------------------------------------------------------
# redd daily not available
# redd annual not available

upstream_passage |> 
  data_completeness("deer creek")

# mill creek --------------------------------------------------------------
# holding not available
# redd daily not available

upstream_passage|> 
  data_completeness("mill creek")
redd_annual |> 
  data_completeness("mill creek")


# yuba river --------------------------------------------------------------
# holding not available

upstream_passage |> data_completeness("yuba river")
redd_annual |> data_completeness("yuba river")
redd_daily |> data_completeness("yuba river")

# battle creek ------------------------------------------------------------

upstream_passage |> data_completeness("battle creek")
holding |> data_completeness("battle creek")
redd_annual |> data_completeness("battle creek")
redd_daily |> data_completeness("battle creek")

# Butte Creek -------------------------------------------------------------
# upstream passage not available
# redd annual not available
# redd daily not available

holding |> data_completeness("butte creek")

# Clear Creek -------------------------------------------------------------

upstream_passage |> data_completeness("clear creek")
holding |> data_completeness("clear creek")
redd_annual |> data_completeness("clear creek")
redd_daily |> data_completeness("clear creek")

# Feather -----------------------------------------------------------------
# upstream passage not available
# holding not available

redd_annual |> data_completeness("feather river")
redd_daily |> data_completeness("feather river")

# heat maps of data completeness -------------------------------------------

generate_heatmap <- function(data, data_type) {
  data |> 
    group_by(stream) %>% 
    summarise_all(list(percent_na = ~sum(is.na(.))/length(.))) |> 
    pivot_longer(-stream, names_to = "column", values_to = "percent_na") |> 
    mutate(column = str_remove(column, "_percent_na")) |> 
    ggplot(aes(x = stream, y = column)) +
    geom_tile(aes(fill = percent_na)) +
    xlab("Stream") +
    ylab("Column") +
    ggtitle(paste0(data_type, " Data Completeness")) +
    scale_fill_gradient(low = "#DD5E66FF",
                        high = "#fbf3f3") + 
    labs(fill = "Percent NA") + 
    theme(plot.title = element_text(hjust = 0.5))
}

# plots
upstream_passage |> generate_heatmap("Upstream Passage")
holding |> generate_heatmap("Holding")
redd_daily |> generate_heatmap("Redd Daily")
redd_annual |> generate_heatmap("Redd Annual")
carcass |> generate_heatmap("Carcass")

# scratch -----------------------------------------------------------------

# water year for colors
wy_type <- waterYearType::water_year_indices |> 
  filter(location == "Sacramento Valley") |> 
  rename(year = WY) |> 
  select(year, Yr_type)

# fill in 2018-2020
# https://cdec.water.ca.gov/reportapp/javareports?name=WSIHIST
addl_wy <- as_tibble(c(2018, 2019, 2020, 2021)) 
addl_wy$Yr_type <- c("Below normal", "Wet", "Dry", "Critical")
addl_wy <- addl_wy |> rename(year = value)
wy_type <- bind_rows(wy_type, addl_wy)

