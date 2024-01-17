## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE)

library(tidyverse)
library(lubridate)
library(CDECRetrieve)
library(dataRetrieval)
library(hms)
library(weathermetrics) # conversion of temperature units
library(googleCloudStorageR)
library(purrr)
library(zoo)
library(rnoaa)
library(data.table)
root.dir <- rprojroot::find_rstudio_root_file()
knitr::opts_knit$set(root.dir)
knitr::opts_chunk$set(echo = TRUE)


## ----include = F--------------------------------------------------------------------------------------------------------------------------------------
# token for rnoaa is added to Renviron file
#NOAA_KEY <- Sys.getenv("NOAA_KEY")

# google cloud set up
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Check if CDEC data provides temp data for respective location
# cdec_datasets("BAT") 
# CDEC has no temperature data available


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

BAT_USGS <- readNWISdv(11376550, "00010") # parameter code 00010: water temperature

# from ashley: don't need to save this if there is no data.
# write.csv(BAT_USGS,"BAT_USGS.csv", row.names = FALSE)

# Read created CSV
# BAT_USGS <- read_csv("BAT_USGS.csv")
# BAT_USGS


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# get data from google cloud
gcs_get_object(object_name = "environmental/data-raw/battle_clear_RSTTEMPS_07052022.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk =  here::here("data-raw", "standard-format-data-prep", "temp_data", "battle_clear_temp.xlsx"),
               overwrite = TRUE)

ubc_temp <- readxl::read_excel(here::here("data-raw", "standard-format-data-prep", "temp_data", "battle_clear_temp.xlsx"), sheet = 4)

battle_temp <- ubc_temp %>% 
  rename(date = DT,
         temp_degC = TEMP_C)

ggplot(battle_temp, aes(x=date, y = temp_degC)) +
  geom_line(color = "darkred") +
  labs(y = "Temperature (deg C)")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
write_rds(battle_temp, here::here("data-raw", "standard-format-data-prep","temp_data", "battle_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Check if CDEC data provides temp data for respective location
# cdec_datasets("BCK")

# Since this location has sensor that collects temp data, we can make request
BCK_CDEC <- cdec_query(station = "BCK", dur_code = "H", sensor_num = "25", start_date = "1995-01-01")

BCK_hourly_temps <- BCK_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date, time, temp_degC)

# Date Ranges
tail(BCK_hourly_temps$date, n=1)
head(BCK_hourly_temps$date, n=1)

ggplot(BCK_hourly_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "CDEC Water Temperature at Buttle Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
# TODO review literature on temps on Butte Creek
BCK_hourly_temps %>%
  filter(temp_degC < 37, temp_degC > -18) %>%
  ggplot(aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "CDEC Water Temperature at Buttle Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

#BCK_USGS <- readNWISdv(11372000, "00010") # parameter code 00010: water temperature
# from ashley: don't need to save if no data
#write.csv(BCK_USGS,"BCK_USGS.csv", row.names = FALSE)

# no data available from USGS


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Calculate the daily average temperature
BCK_daily_temps <- BCK_hourly_temps %>% 
  filter(temp_degC < 37, temp_degC > -18) %>%
  group_by(date) %>% 
  summarize(mean_temp_degC = mean(temp_degC, na.rm = T),
            max_temp_degC = max(temp_degC, na.rm = T)) 

# 2. Check to see if applying rolling mean would help with outliers.
butte_format <- transform(BCK_daily_temps, rollmean = rollapplyr(mean_temp_degC, 3, mean, partial = T)) %>% 
  mutate(mean_temp_degC_clean = ifelse(mean_temp_degC > 70, rollmean, mean_temp_degC)) 

butte_format %>%
  ggplot(aes(x=date)) +
  geom_line(aes(y = mean_temp_degC_clean), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "CDEC Water Temperature at Buttle Creek", caption = "CDEC")
# doesn't really seem to help much so for transparency don't apply any transformation
filter(butte_format, mean_temp_degC > 70)


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# save final version of butte data
# from ashley: erin and i have started using the here package, especially in markdowns because it makes it easier for file path reading
write_rds(BCK_daily_temps, here::here("data-raw", "standard-format-data-prep","temp_data", "butte_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Check if CDEC data provides temp data for respective location
# cdec_datasets("IGO")

# Since this location has sensor that collects temp data, we can make request
IGO_CDEC <- cdec_query(station = "IGO", dur_code = "H", sensor_num = "25", start_date = "2003-01-01")

IGO_hourly_temps <- IGO_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date,time,temp_degC)

# Date Ranges
tail(IGO_hourly_temps$date, n=1)
head(IGO_hourly_temps$date, n=1)

ggplot(IGO_hourly_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y ="Temperature (deg C)", title = "Water Temperature at Clear Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
IGO_hourly_temps %>%
  filter(temp_degC < 37, temp_degC > -18) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "CDEC Water Temperature at Clear Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

#IGO_USGS <- readNWISdv(11372000, "00010") # parameter code 00010: water temperature
#write.csv(IGO_USGS,"IGO_USGS.csv", row.names = FALSE)

# Read created CSV
# IGO_USGS <- read_csv("IGO_USGS.csv")
# IGO_USGS
# no data available from USGS


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Calculate the daily average temperature
IGO_daily_temps <- IGO_hourly_temps %>% 
  filter(temp_degC < 37, temp_degC > -18) %>%
  group_by(date) %>% 
  summarize(mean_temp_degC = mean(temp_degC),
            max_temp_degC = max(temp_degC)) 



## -----------------------------------------------------------------------------------------------------------------------------------------------------
# save final version of butte data
# from ashley: erin and i have started using the here package, especially in markdowns because it makes it easier for file path reading
write_rds(IGO_daily_temps, here::here("data-raw", "standard-format-data-prep","temp_data", "clear_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
clear_cdec <- read_rds(here::here("data-raw", "standard-format-data-prep","temp_data", "clear_temp.rds"))
ucc_temp_raw <- readxl::read_excel(here::here("data-raw", "standard-format-data-prep", "temp_data", "battle_clear_temp.xlsx"), sheet = 2)

ucc_temp <- ucc_temp_raw %>% 
  rename(date = DT,
         temp_degC = TEMP_C)
lcc_temp_raw <- readxl::read_excel(here::here("data-raw", "standard-format-data-prep", "temp_data", "battle_clear_temp.xlsx"), sheet = 3)
lcc_temp <- lcc_temp_raw %>% 
  rename(date = DT,
         temp_degC = TEMP_C)

# compare cdec to upper clear creek
ggplot(filter(clear_cdec, mean_temp_degC < 100), aes(x = date, y = mean_temp_degC)) +
  geom_line(color = "darkred") +
  geom_line(data = ucc_temp, aes(x = as.Date(date), y = temp_degC), color = "darkblue", alpha = 0.1)

# compare cded to lower clear creek
ggplot(filter(clear_cdec, mean_temp_degC < 100), aes(x = date, y = mean_temp_degC)) +
  geom_line(color = "darkred") +
  geom_line(data = lcc_temp, aes(x = as.Date(date), y = temp_degC), color = "darkblue", alpha = 0.1)


## -----------------------------------------------------------------------------------------------------------------------------------------------------
write_rds(ucc_temp, here::here("data-raw", "standard-format-data-prep","temp_data", "upper_clear_temp.rds"))

write_rds(lcc_temp, here::here("data-raw", "standard-format-data-prep","temp_data", "lower_clear_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# cdec_datasets("DCV")

DCV_CDEC <- cdec_query(station = "DCV", dur_code = "H", sensor_num = "25", start_date = "1995-01-01")

DCV_hourly_temps <- DCV_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date,time,temp_degC)

# Date Ranges
tail(DCV_hourly_temps$date, n = 1)
head(DCV_hourly_temps$date, n = 1)

# Plot
ggplot(DCV_hourly_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year",y = "Temperature (deg C)",title = "Water Temperature at Deer Creek", caption = " CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
DCV_hourly_temps %>%
    filter(temp_degC < 37, temp_degC > 0) %>%
  ggplot(aes(x=date)) +
  geom_line(aes(y = temp_degC), color ="darkred") +
  labs(x = "Year",y = "Temperature (deg C)", title = "CDEC Water Temperature at Buttle Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

DCV_USGS <- readNWISdv(11383500, "00010") # parameter code 00010: water temperature

# Format to make tidier
DCV_daily_temps <- DCV_USGS %>%
  select(Date, temp_degC =  X_00010_00003) %>%
  filter(lubridate::year(Date) >= 1995) %>%
  as_tibble() %>% 
  rename(date = Date)

# Date Ranges
tail(DCV_daily_temps$date,n=1)
head(DCV_daily_temps$date,n=1)

# Plot
ggplot(DCV_daily_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year",y = "Temperature (deg C)", title = "Water Temperature at Deer Creek", caption = "USGS")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
DCV_combined = DCV_hourly_temps %>% 
  full_join(DCV_daily_temps, by ="date") %>% 
  rename("temp_degC.CDEC"="temp_degC.x", "temp_degC.USGS"="temp_degC.y")

DCV_combined %>% 
  group_by(date = date(date)) %>% 
  group_by(date) %>% 
  summarise(
    temp_CDEC = median(temp_degC.CDEC, na.rm = TRUE),
    temp_USGS = max(temp_degC.USGS, na.rm = TRUE)) %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_CDEC), color = "darkred") +
  geom_line(aes(y = temp_USGS), color = "steelblue", linetype = "twodash") +
  labs(y = "Temperature (deg C)", title = "Water Temperature at Deer Creek")


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Calculate the daily average temperature
DCV_daily_temps <- DCV_hourly_temps %>% 
  filter(!is.na(temp_degC),
         temp_degC < 37, temp_degC > -18) %>%
  group_by(date) %>% 
  summarize(mean_temp_degC = mean(temp_degC, na.rm = T),
            max_temp_degC = max(temp_degC, na.rm = T)) 


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# save final version of butte data
# from ashley: erin and i have started using the here package, especially in markdowns because it makes it easier for file path reading
write_rds(DCV_daily_temps, here::here("data-raw", "standard-format-data-prep","temp_data", "deer_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# cdec_datasets("GRL")

GRL_CDEC <- cdec_query(station = "GRL", dur_code = "H", sensor_num = "25", start_date = "1996-01-01")

GRL_hourly_temps <- GRL_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date,time,temp_degC)

# Date Ranges
tail(GRL_hourly_temps$date, n = 1)
head(GRL_hourly_temps$date, n = 1)

# Plot GRL
ggplot(GRL_hourly_temps, aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y="Temperature (deg C)", title = "Temperature at Feather River", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
GRL_hourly_temps %>%
   filter(temp_degC < 37, temp_degC > -18) %>%
  ggplot(aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "CDEC Water Temperature at Feather River", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

# GRL_USGS <- readNWISdv(11407000, "00010") # parameter code 00010: water temperature
# # write.csv(GRL_USGS,"GRL_USGS.csv", row.names = FALSE)
# 
# # Read created CSV
# GRL_USGS <- read_csv("GRL_USGS.csv")
# GRL_USGS


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# write_rds(GRL_hourly_temps, "../../data-raw/standard-format-data-prep/temp_data/feather_temp.rds")


## -----------------------------------------------------------------------------------------------------------------------------------------------------

# cdec_datasets("MLM") 

MLM_CDEC <- cdec_query(station = "MLM", dur_code = "H", sensor_num = "25", start_date = "1996-01-01")


MLM_hourly_temps <- MLM_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date,time,temp_degC)

# Date Ranges
tail(MLM_hourly_temps$date, n = 1)
head(MLM_hourly_temps$date, n = 1)

# Plot DCV
ggplot(MLM_hourly_temps, aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "Temperature at Mill Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
MLM_hourly_temps %>%
    filter(temp_degC < 37, temp_degC > -18) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year",y = "Temperature (deg C)", title = "CDEC Water Temperature at Mill Creek", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

MLM_USGS <- readNWISdv(11381500, "00010") # parameter code 00010: water temperature temperature

# Format to make tidier
MLM_daily_temps <- MLM_USGS %>%
  select(Date, temp_degC =  X_00010_00003) %>%
  as_tibble() %>% 
  rename(date = Date)

# Date Ranges
tail(MLM_daily_temps$date, n = 1)
head(MLM_daily_temps$date, n = 1)

# Plot DCV
ggplot(MLM_daily_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year",y = "Temperature (deg C)",title = "Temperature at Mill Creek", caption = "USGS")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# comparison of USGS vs CDEC
# Does one have more data?
# Does one have a finer scale?
MLM_combined = MLM_hourly_temps %>% 
  full_join(MLM_daily_temps, by = "date") %>% 
  rename("temp_degC.CDEC" = "temp_degC.x", "temp_degC.USGS" = "temp_degC.y")

MLM_combined %>% 
  group_by(date = date(date)) %>% 
  group_by(date) %>% 
  summarise(
    temp_CDEC = median(temp_degC.CDEC, na.rm = TRUE),
    temp_USGS = max(temp_degC.USGS, na.rm = TRUE)) %>% 
  ggplot(aes(x=date)) +
  geom_line(aes(y = temp_CDEC), color = "darkred") +
  geom_line(aes(y = temp_USGS), color = "steelblue", linetype = "twodash") +
  labs(y = "Temperature (deg C)", title = "Water Temperature at Mill Creek")



## -----------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Calculate the daily average temperature
MLM_daily_temps <- MLM_hourly_temps %>% 
  filter(!is.na(temp_degC),
         temp_degC < 37, temp_degC > -18) %>% 
  group_by(date) %>% 
  summarize(mean_temp_degC = mean(temp_degC),
            max_temp_degC = max(temp_degC)) 


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# save final version of butte data
# from ashley: erin and i have started using the here package, especially in markdowns because it makes it easier for file path reading
write_rds(MLM_daily_temps, here::here("data-raw", "standard-format-data-prep","temp_data", "mill_temp.rds"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# use this code to get the data types for the station
# ncdc_datatypes(datasetid='GHCND', stationid='GHCND:USR0000CFOR', token = NOAA_KEY)
# 
# # used this code to figure out units. units for TAVG is in celsius tenths which means we need to divide by 10 to get celsisus
# with_units <- ncdc(datasetid='GHCND', stationid='GHCND:USR0000CFOR', token = NOAA_KEY, datatypeid='TAVG', startdate = '2010-05-01', enddate = '2010-10-31', limit=500, add_units = TRUE)
# head( with_units$data )
# 
# get_temp_yuba <- function(start_date, end_date, year) {
#   query <- rnoaa::ncdc(datasetid = 'GHCND', stationid = 'GHCND:USR0000CFOR', 
#                        datatypeid = 'TAVG', startdate = start_date, 
#                        enddate = end_date, token = NOAA_KEY, limit = 365)
#   # Get columns of interest
#   temp_data <- query$data %>%
#     select(date, value) %>%
#     mutate(date = as.Date(date))
#   # Return
#   write_csv(temp_data, here::here("data-raw", "standard-format-data-prep", "temp_data", paste0(year, "_yuba_noaa_airtemp.csv")))
# }
# 
# # list date ranges, note we can only take yearly data
# # note that there is no data after 2020
# date_ranges <- tibble(year = c(seq(from = 2001, to = 2020))) %>% 
#   mutate(start_date = paste0(year, "-01-01"),
#          end_date = paste0(year, "-12-31"))
#                       
# pmap(date_ranges, get_temp_yuba)
# ```
# 
# ### QC data
# 
# ```{r}
# # read in all the yuba air temp files
# files <- list.files(path = here::here("data-raw", "standard-format-data-prep", "temp_data"), pattern = "_yuba_noaa_airtemp.csv")
# path <- here::here("data-raw", "standard-format-data-prep", "temp_data")
# file_path <- paste0(path, "/",files)
# # fread uses data.table
# yuba_air <- file_path %>% 
#   map_df(~fread(.)) %>% 
#   rename(air_tempC = value) %>% 
#   mutate(date = as.Date(date),
#          air_tempC = air_tempC/10)
# 
# ggplot(yuba_air, aes(x=date, y = air_tempC)) +
#   geom_line(color = "darkred") +
#   labs(y = "Air temperature (deg C)") +
#   theme(axis.text = element_text(size = 12))


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# cdec_datasets("WLK")

WLK_CDEC <- cdec_query(station = "WLK", dur_code = "E", sensor_num = "25", start_date = "1995-01-01")

WLK_hourly_temps <- WLK_CDEC %>%
  mutate(date = as_date(datetime),
         time = as_hms(datetime),
         temp_degC = fahrenheit.to.celsius(parameter_value, round = 1)) %>%
  select(date,time,temp_degC)

# Date Ranges
tail(WLK_hourly_temps$date, n = 1)
head(WLK_hourly_temps$date, n = 1)

# Plot WLK
ggplot(WLK_hourly_temps, aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Plot without outliers
WLK_hourly_temps %>%
  filter(temp_degC < 37, temp_degC > -18) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "CDEC")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
# Using https://flowwest.shinyapps.io/jpe-eda-app/ to find temperature gage
# Using mapper to check if temp data is available for the site https://maps.waterdata.usgs.gov/mapper/index.html

WLK_USGS <- readNWISdv(11390500, "00010") # parameter code 00010: water temperature temperature

# Format to make tidier
WLK_daily_temps <- WLK_USGS %>%
  select(Date, temp_degC =  X_00010_00003) %>%
  #filter(lubridate::year(Date) >= 1995) %>%
  as_tibble() %>% 
  rename(date = Date) %>% 
  #filter(year(date) > 2000) %>%
  glimpse

# Date Ranges
tail(WLK_daily_temps$date, n = 1)
head(WLK_daily_temps$date, n = 1)

# Plot
ggplot(WLK_daily_temps, aes(x=date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year",y = "Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "USGS")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
### Identify date data starts to be missing
WLK_daily_temps %>%
  filter(date < "2004-01-01") %>%
  arrange(desc(date))
  # 1998-09-30

# data before missing data gap
WLK_daily_temps %>%
  filter(date < "1999-10-01") %>% 
  arrange(desc(date)) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y = "Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "USGS")


## -----------------------------------------------------------------------------------------------------------------------------------------------------
### Identify date data starts to be missing
WLK_daily_temps %>%
  filter(date > "2015-01-01") %>%
  arrange(date)
  # 2016-10-01

# data after missing data gap
WLK_daily_temps %>%
  filter(date >= "2016-10-01") %>% 
  arrange(desc(date)) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temp_degC), color = "darkred") +
  labs(x = "Year", y ="Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "USGS")
#


## -----------------------------------------------------------------------------------------------------------------------------------------------------
WLK_combined = WLK_hourly_temps %>% 
  full_join(WLK_daily_temps, by = "date") %>% 
  rename("temp_degC.CDEC" = "temp_degC.x", "temp_degC.USGS" = "temp_degC.y")

WLK_combined %>% 
  group_by(date = date(date)) %>% 
  summarise(
    temp_CDEC = median(temp_degC.CDEC, na.rm = TRUE),
    temp_USGS = max(temp_degC.USGS, na.rm = TRUE)) %>% 
  ggplot(aes(x=date)) +
  geom_line(aes(y = temp_CDEC), color = "darkred") +
  geom_line(aes(y = temp_USGS), color = "blue", linetype ="twodash") +
  labs(y = "Temperature (deg C)", title = "Temperature at Sacramento River- Knights Landing", caption = "USGS")

