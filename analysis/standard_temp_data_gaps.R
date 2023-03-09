library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(padr)
library(CDECRetrieve)
library(rnoaa)
library(lubridate)


# helper function ---------------------------------------------------------
# function for f to c
f_to_c <- function(temp_f){
  temp_c <- (temp_f - 32) * (5 / 9)
  return(temp_c)
}

# function to pull/bind temp data from NOAA
get_noaa_temp <- function(datasetid, stationid, datatype, year_range) {
  df <- tibble(date = ymd("1800-01-01"),
               mean_daily_temp = -100)
  
  for(i in year_range){
    
    startdate <- paste0(i, "-01-01")
    enddate <- paste0(i, "-12-31")
    print(c(startdate, enddate))
    
    temp_df <- rnoaa::ncdc(datasetid = datasetid, 
                           stationid = stationid, 
                           datatype = datatype, 
                           startdate = startdate,
                           enddate = enddate,
                           token = token,
                           add_units = TRUE,
                           limit = 365)$data |>
      mutate(date = as.Date(date),
             value = if_else(units == "celcius_tenths", (value/10), as.numeric(value))) |> 
      select(date, datatype, value) |>
      pivot_wider(names_from = "datatype", values_from = "value") |>
      group_by(date) |>
      summarise(mean_daily_temp = (TMAX + TMIN)/2) |>
      ungroup()
    
    df <- bind_rows(df, temp_df)
  }
  df <- df[-1,] 
  
  df_final <- df |> 
    mutate(source = str_replace(stationid, ":", " "))
  return(df_final)
}

# function to plot noaa output
plot_noaa_output <- function(data) {
  data |> 
    mutate(day = if_else(day(date) <= 9, paste0("0", day(date)), paste0(day(date))),
           month = if_else(month(date) <= 9, paste0("0", month(date)), paste0(month(date))),
           fake_date = paste0("1970-", month, "-", day),
           fake_date = as.Date(fake_date),
           year = year(date)) |> 
    ggplot(aes(x = fake_date, y = mean_air_temp_c)) +
    geom_line() +
    facet_wrap(~year) + 
    theme_minimal() + 
    scale_x_date(date_labels = "%b")
}

# pull in google cloud data ------------------------------------------------------------

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# upstream passage
upstream_passage <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                            bucket = gcs_get_global_bucket())) |> 
  mutate(stream = tolower(stream),
         type = "upstream_passage") |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  select(date, stream, type)

# holding
holding <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
                                   bucket = gcs_get_global_bucket())) |>
  mutate(type = "holding")|> 
  select(date, stream, type)


# redd
redd_daily <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
                                      bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  mutate(type = "redd_daily") |> 
  select(date, stream, type)

# redd_annual <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
#                                        bucket = gcs_get_global_bucket())) |> 
#   filter(run %in% c("spring", NA, "not recorded")) |> 
#   mutate(type = "redd_annual") |> 
#   select(year, stream, type)

carcass <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
                                   bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  mutate(type = "carcass") |> 
  select(date, stream, type)

# pull in standard format temperature
standard_temp_raw <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
                                             bucket = gcs_get_global_bucket()))




# pull in data from USGS and NOAA sources ---------------------------------
# pull in feather data - CDEC "FRA"
cdec_feather_at_61 <- cdec_query(station = "FRA", dur_code = "D", sensor_num = "25", start_date = "2002-01-01") |>
  mutate(mean_daily_temp_c = f_to_c(parameter_value),
         source = "CDEC FRA",
         stream = "feather river") |>
  select(date = datetime, mean_daily_temp_c, source, stream) |>
  glimpse()

# pull yuba temp from USGS 11421000
usgs_yuba_at_marysville <- dataRetrieval::readNWISdv(siteNumbers = '11421000', parameterCd = '00010',
                                                     startDate = '1989-01-01', endDate = '2020-09-29',
                                                     statCd = c('00001', '00002')) |> 
  select(date = Date, max = X_00010_00001, min = X_00010_00002) %>%
  mutate(mean_daily_temp_c = (max + min) / 2,
         source = "USGS 11421000",
         stream = "yuba river") |> 
  select(date, mean_daily_temp_c, source, stream) |> 
  glimpse()

# model supplemental yuba water temp from air temp ------------------------

# model yuba air temp -----------------------------------------------------
# get NOAA token
token <- Sys.getenv("token") #noaa cdo api token saved in .Renviron file


#this is better than marysville ("GHCND:USW00093205")
yuba_foresthill_air_temp <- get_noaa_temp(datasetid = "GHCND",
                                          stationid = "GHCND:USR0000CFOR",
                                          datatype = c("TMAX", "TMIN"),
                                          year_range = 2001:2020) |> 
  rename(mean_air_temp_c = mean_daily_temp)


plot_noaa_output(yuba_foresthill_air_temp)

# now train air temp model on existing yuba data and then predict water temp
yuba_water <- standard_temp_raw |> 
  filter(stream == "yuba river") |>
  glimpse()

yuba_train <- yuba_water |> 
  left_join(yuba_foresthill_air_temp,
            by = "date") |>
  filter(!is.na(mean_air_temp_c)) |> 
  select(date, mean_daily_temp_c, mean_air_temp_c) |> 
  glimpse()

yuba_train %>%
  ggplot(aes(x = mean_air_temp_c, mean_daily_temp_c)) +
  geom_point() +
  geom_smooth(method = 'lm')

# linear model
yuba_model <- lm(mean_daily_temp_c ~ mean_air_temp_c, data = yuba_train)
summary(yuba_model)
coefficients(yuba_model)

# pred water temp from foresthill air temp
yuba_pred_water_temp_raw <- unname(predict(yuba_model, yuba_foresthill_air_temp))

yuba_pred_water_temp <- tibble(date = yuba_foresthill_air_temp$date,
                               pred_mean_water_temp_c = yuba_pred_water_temp_raw) |> 
  rename(mean_daily_temp_c = pred_mean_water_temp_c) |> 
  mutate(source = "GHCND USR0000CFOR predict",
         stream = "yuba river") |> glimpse()

yuba_pred_water_temp |> 
  mutate(day = if_else(day(date) <= 9, paste0("0", day(date)), paste0(day(date))),
         month = if_else(month(date) <= 9, paste0("0", month(date)), paste0(month(date))),
         fake_date = paste0("1970-", month, "-", day),
         fake_date = as.Date(fake_date),
         year = year(date)) |> 
  ggplot(aes(x = fake_date, y = mean_daily_temp_c)) +
  geom_line() +
  facet_wrap(~year) + 
  theme_minimal() + 
  scale_x_date(date_labels = "%b")



# bind together all data sources ------------------------------------------

standard_temp <- bind_rows(standard_temp_raw, cdec_feather_at_61, usgs_yuba_at_marysville,
                           yuba_pred_water_temp) |> 
  mutate(date = as.Date(date)) |> 
  glimpse()

# plot and find missing values --------------------------------------------

# plot
standard_temp |> 
  filter(!is.na(mean_daily_temp_c)) |> 
  ggplot(aes(x = date, y = mean_daily_temp_c, color = source)) + 
  geom_line() +
  theme_minimal() + 
  facet_wrap(~stream, scales = "free")

# range of dates included
standard_temp |> 
  group_by(stream) |> 
  summarise(min = min(date), 
            max = max(date),
            percent_missing = sum(!seq(min, max, by = "day") %in% date) / length(seq(min, max, by = "day")))


# fill in missing dates and plot ---------------------------------------------------

streams <- unique(standard_temp$stream)
filling_dates <- lapply(streams, function(x) {
  stream_name <- x
  df <- standard_temp |> 
    filter(stream == x) |>
    complete(date = seq(min(date), max(date), by = "day"),
             fill = list(source = "missing",
                         mean_daily_temp_c = 10,
                         stream = stream_name), explicit = FALSE)
  return(df)
})

standard_temp_filled <- bind_rows(standard_temp, filling_dates, .id = "column_label")

ggplot() + 
  geom_line(data = standard_temp, aes(x = date, y = mean_daily_temp_c)) +
  geom_point(data = standard_temp_filled |> filter(source == "missing"), 
            aes(x = date, y = mean_daily_temp_c), col = "orange", size = 0.5, alpha = 0.2) +
  theme_minimal() + 
  facet_wrap(~stream, scales = "free")

# look at creeks
standard_temp_filled |> 
  filter(stream == "yuba river") |> 
  group_by(source) |> 
  tally()


# pull in adult data and plot those time frames ---------------------------
adult_data <- bind_rows(holding, carcass, redd_daily, upstream_passage) # redd annual at yearly granularity



# join --------------------------------------------------------------------

adult_data |> glimpse()
standard_temp_filled |> glimpse()

temp_join <- left_join(adult_data, 
                       standard_temp_filled |> 
                         select(date, stream, source, mean_daily_temp_c), 
                       by = c("date", "stream")) |> 
  mutate(source = if_else(is.na(source), "outside_date_range", source)) |> 
  glimpse()

# outside date range means that there are dates covered in the adult data datasets
# that are not covered by the temperature. 
# missing means that there are dates not covered by standard_temp that are included
# in adult data, meaning that we should fill these in
  
temp_join |> 
  filter(source %in% c("missing", "outside_date_range")) |> 
  group_by(stream, source, type) |>
  tally() |> 
  print(n=Inf)


# look at years missing for each stream and data type
years_missing <- temp_join |> 
  mutate(year = year(date)) |> 
  filter(source == "missing") |> 
  group_by(stream, year, type) |> 
  tally() |> 
  print(n=Inf)

years_missing |> 
  ggplot(aes(x = stream, y = n, fill = type)) + 
  geom_bar(stat = "identity") + 
  theme_minimal()

# yuba predicted water temp does not have fall temps :,)





