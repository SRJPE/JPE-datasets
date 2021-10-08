feather-river-adult-holding-redd-survey-qc-checklist
================
Inigo Peng
9/30/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2009 - 2020

**Completeness of Record throughout timeframe:** TODO

**Sampling Location:** TODO

**Data Contact:** Chris Cook

Any additional info? 1. Latitude and longitude are in NAD 1983 UTM Zone
10N The substrate is observed visually and an estimate of the percentage
of 5 size classes. Fines &lt;1cm, small 1-5cm, medium 6-15cm, large
16-30cm, boulder &gt;30cm Type refers to whether a polygon (A for Area)
or point (P) was mapped with the Trimble GPS unit A different substrate
classification system was used in 2008. Each of the 5 size classes were
given a number: 1=fines, 2=small, 3=medium, 4=large, 5=boulder. The
dominant class was recorded as a number. D stands for Digging. We used
to record digging areas as redds that looked to be unfinished. We record
only finished redds now. Q refers to Questionable redds. Areas where the
substrate was disturbed but did not have the proper characteristics to
be called a redd. We no longer record questionable redds. \#\# Access
Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
```

    ## Set default bucket name to 'jpe-dev-bucket'

``` r
datasets <- gcs_list_objects()
# git data and save as xlsx

datasets
```

    ##                                                                                                                   name
    ## 1                                                                              adult-holding-redd-and-carcass-surveys/
    ## 2                                                                adult-holding-redd-and-carcass-surveys/feather-river/
    ## 3     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx
    ## 4         adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx
    ## 5         adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2011_Chinook_Redd_Survey_Data.xlsx
    ## 6     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx
    ## 7     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx
    ## 8          adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx
    ## 9     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx
    ## 10    adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx
    ## 11    adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx
    ## 12    adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx
    ## 13    adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx
    ## 14    adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx
    ## 15                                                          adult-holding-redd-and-carcass-surveys/feather-river/data/
    ## 16                                                                                  adult-upstream-passage-monitoring/
    ## 17                                                                      adult-upstream-passage-monitoring/clear-creek/
    ## 18                                                             adult-upstream-passage-monitoring/clear-creek/data-raw/
    ## 19                     adult-upstream-passage-monitoring/clear-creek/data-raw/2019-20 CCVS Video Reading Protocol.docx
    ## 20          adult-upstream-passage-monitoring/clear-creek/data-raw/ClearCreekVideoWeir_AdultRecruitment_2013-2020.xlsx
    ## 21                                                                 adult-upstream-passage-monitoring/clear-creek/data/
    ## 22                                                adult-upstream-passage-monitoring/clear-creek/data/clear_passage.csv
    ## 23                                                                    adult-upstream-passage-monitoring/feather-river/
    ## 24                                                                adult-upstream-passage-monitoring/feather-river/CWT/
    ## 25                                                       adult-upstream-passage-monitoring/feather-river/CWT/data-raw/
    ## 26                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-14_FRFH_tblOutput.xlsx
    ## 27                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-15_FRFH_tblOutput.xlsx
    ## 28                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-17_FRFH_tblOutput.xlsx
    ## 29                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-20_FRFH_tblOutput.xlsx
    ## 30                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-21_FRFH_tblOutput.xlsx
    ## 31                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-22_FRFH_tblOutput.xlsx
    ## 32                         adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021_FRFH_SR-HP_tblOutput.xlsx
    ## 33                                                          adult-upstream-passage-monitoring/feather-river/hallprint/
    ## 34                                                 adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/
    ## 35                    adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/all_hallprints_all_years.xlsx
    ## 36                                         adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/returns/
    ## 37 adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/returns/FRFH HP RUN DATA 2018 as of 9-10-20.xlsx
    ## 38                                                     adult-upstream-passage-monitoring/feather-river/hallprint/data/
    ## 39                                                                                                                rst/
    ## 40                                                                                                     rst/yuba-river/
    ## 41                                                                                            rst/yuba-river/data-raw/
    ## 42                                               rst/yuba-river/data-raw/Draft CAMP screw trap database dictionary.doc
    ## 43                                               rst/yuba-river/data-raw/Rotary Screw Traps Report 2007-2008 (PDF).pdf
    ## 44                                                                                                rst/yuba-river/data/
    ## 45                                                                                                           survival/
    ##        size             updated
    ## 1   0 bytes 2021-09-27 22:15:47
    ## 2   0 bytes 2021-10-04 21:28:40
    ## 3   67.9 Kb 2021-10-04 21:32:53
    ## 4   55.3 Kb 2021-10-04 21:32:53
    ## 5   57.9 Kb 2021-10-04 21:32:53
    ## 6  134.9 Kb 2021-10-04 21:32:54
    ## 7     56 Kb 2021-10-04 21:32:54
    ## 8  185.8 Kb 2021-10-04 21:32:54
    ## 9  232.9 Kb 2021-10-04 21:32:54
    ## 10 107.5 Kb 2021-10-04 21:32:54
    ## 11 257.9 Kb 2021-10-04 21:32:54
    ## 12 209.3 Kb 2021-10-04 21:32:55
    ## 13   271 Kb 2021-10-04 21:32:55
    ## 14   403 Kb 2021-10-04 21:32:55
    ## 15  0 bytes 2021-10-04 21:33:16
    ## 16  0 bytes 2021-09-27 18:49:42
    ## 17  0 bytes 2021-09-28 16:18:09
    ## 18  0 bytes 2021-09-30 16:38:52
    ## 19    41 Kb 2021-09-30 16:39:14
    ## 20   3.7 Mb 2021-09-30 16:39:24
    ## 21  0 bytes 2021-09-30 16:38:59
    ## 22 124.6 Kb 2021-10-01 17:58:10
    ## 23  0 bytes 2021-09-28 16:20:07
    ## 24  0 bytes 2021-10-01 20:40:34
    ## 25  0 bytes 2021-10-01 20:40:52
    ## 26  12.7 Kb 2021-10-01 20:48:46
    ## 27  21.9 Kb 2021-10-01 20:48:31
    ## 28    23 Kb 2021-10-01 20:48:16
    ## 29  13.5 Kb 2021-10-01 20:47:59
    ## 30  23.2 Kb 2021-10-01 20:47:44
    ## 31  16.5 Kb 2021-10-01 20:47:28
    ## 32    13 Kb 2021-10-01 20:47:16
    ## 33  0 bytes 2021-10-01 20:40:28
    ## 34  0 bytes 2021-10-01 20:40:41
    ## 35   3.1 Mb 2021-10-01 21:16:01
    ## 36  0 bytes 2021-10-01 21:09:50
    ## 37 292.8 Kb 2021-10-01 21:10:44
    ## 38  0 bytes 2021-10-01 21:04:10
    ## 39  0 bytes 2021-09-27 22:16:03
    ## 40  0 bytes 2021-09-28 16:22:29
    ## 41  0 bytes 2021-09-30 16:40:06
    ## 42   8.7 Mb 2021-09-30 16:40:21
    ## 43 646.7 Kb 2021-09-30 16:40:34
    ## 44  0 bytes 2021-09-30 16:40:11
    ## 45  0 bytes 2021-09-27 22:16:18

``` r
for (item in datasets[3:14, 1]){
  gcs_get_object(object_name = item,
                 bucket = gcs_get_global_bucket(),
                 saveToDisk = gsub(" ", "_", item),
                 overwrite = TRUE)
                 }
```

    ## 2021-10-05 08:56:23 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx (67.9 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx (55.3 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2011_Chinook_Redd_Survey_Data.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2011_Chinook_Redd_Survey_Data.xlsx (57.9 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx (134.9 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx (56 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx (185.8 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx (232.9 Kb)

    ## 2021-10-05 08:56:24 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx (107.5 Kb)

    ## 2021-10-05 08:56:25 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx (257.9 Kb)

    ## 2021-10-05 08:56:25 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx (209.3 Kb)

    ## 2021-10-05 08:56:25 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx (271 Kb)

    ## 2021-10-05 08:56:25 -- Saved adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx to adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx (403 Kb)

Read in data from google cloud, glimpse raw data:

``` r
# read in data to clean 

raw_data_2009 = readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx"),  
                                   sheet="2009 All Data")

raw_data_2010 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx"))

raw_data_2011 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2011_Chinook_Redd_Survey_Data.xlsx"))

raw_data_2012 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2013 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2014 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx"))

raw_data_2015 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2016 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx"))
raw_data_2017 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2018 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2019 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx"))

raw_data_2020 =  readxl::read_excel(paste0(getwd(),
                                    "/adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx"))
```

## Data transformations

``` r
glimpse(raw_data_2009)
```

    ## Rows: 301
    ## Columns: 17
    ## $ Location             <chr> "Table Mountain", "Table Mountain", "Table Mounta~
    ## $ File                 <chr> "4", "1", "3", "5", "7", "8", "9", "6", "11", "12~
    ## $ `Type (D, A, P)`     <chr> "Area", "Point", "Area", "Area", "Area", "Area", ~
    ## $ Remeasured           <chr> "No", "No", "No", "No", "No", "No", "No", "No", "~
    ## $ `#  Redds`           <dbl> 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 2, 1~
    ## $ `# Salmon`           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `Depth (m)`          <chr> "0.78", "0.56000000000000005", "0.64", "0.5", "0.~
    ## $ `Pot depth (m)`      <chr> "0", "0", "0", "0", "0", "0", "0", "0", NA, NA, N~
    ## $ `Velocity (m/s)`     <chr> "0", "0", "0", "0", "0", "0", "0", "0", NA, NA, N~
    ## $ `% Fines (<1 cm)`    <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, NA, ~
    ## $ `% Small (1-5 cm)`   <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, NA, N~
    ## $ `% Medium (5-15 cm)` <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, NA, N~
    ## $ `% Large (15-30 cm)` <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, NA, ~
    ## $ `% Boulder (>30 cm)` <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, NA, 0~
    ## $ `Redd Width (ft)`    <dbl> NA, 3, 3, 3, 4, 3, 3, 12, NA, 4, 2, 2, 3, 4, 3, 4~
    ## $ `Redd Lenght (ft)`   <dbl> NA, 4, 5, 4, 6, 3, 3, 4, NA, 4, 3, 3, 4, 5, 3, 6,~
    ## $ `Survey Date`        <dttm> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-29, ~

``` r
raw_data_2009$'Redd Width (ft)' = raw_data_2009$'Redd Width (ft)'/3.281
raw_data_2009$'Redd Lenght (ft)' = raw_data_2009$'Redd Lenght (ft)'/3.281
cleaner_data_2009 <- raw_data_2009 %>%
  select(-c(Remeasured, File, '#  Redds')) %>%
  add_column(longitude = NA) %>% 
  add_column(latitude = NA) %>% 
  relocate('Survey Date', .before = 'Location') %>% 
  relocate('latitude', .after = '# Salmon') %>%
  relocate('longitude', .before = 'Depth (m)') %>%  
  rename('Date' = 'Survey Date',
         'type' = 'Type (D, A, P)', 
         'salmon_counted' = '# Salmon', 
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% Fines (<1 cm)',
         'percent_small_substrate' = '% Small (1-5 cm)',
         'percent_medium_substrate'= '% Medium (5-15 cm)',
         'percent_large_substrate' =  '% Large (15-30 cm)',
         'percent_boulder' = '% Boulder (>30 cm)',
         'redd_width_m' = 'Redd Width (ft)',
         'redd_length_m' = 'Redd Lenght (ft)') %>%
  mutate('depth_m' = as.numeric('depth_m'),
         'pot_depth_m' = as.numeric('pot_depth_m'),
         'velocity_m/s'= as.numeric('velocity_m/s'),
         'latitude' = as.numeric(latitude),
         'longitude' = as.numeric(longitude)) %>% 
glimpse()
```

    ## Rows: 301
    ## Columns: 16
    ## $ Date                     <dttm> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-~
    ## $ Location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "Area", "Point", "Area", "Area", "Area", "Are~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_fine_substrate   <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, ~
    ## $ percent_small_substrate  <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, ~
    ## $ percent_boulder          <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, N~
    ## $ redd_width_m             <dbl> NA, 0.9143554, 0.9143554, 0.9143554, 1.219140~
    ## $ redd_length_m            <dbl> NA, 1.2191405, 1.5239256, 1.2191405, 1.828710~

``` r
# glimpse(raw_data_2010)

raw_data_2010$'redd width (ft)' = raw_data_2010$'redd width (ft)'/3.281
raw_data_2010$'redd length (ft)' = raw_data_2010$'redd length (ft)'/3.281
cleaner_data_2010 <- raw_data_2010 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'pot_depth_m' = 'Pot Depth (m)',
         'percent_fine_substrate' = '% fines(<1 cm)',
         'percent_small_substrate' = '% small (1-5 cm)',
         'percent_medium_substrate'= '% med (5-15 cm)',
         'percent_large_substrate' = '% large (15-30 cm)',
         'percent_boulder' = '% boulder (>30 cm)',
         'redd_width_m' = 'redd width (ft)',
         'redd_length_m' = 'redd length (ft)',
         ) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude)) %>% 
  glimpse()
```

    ## Rows: 901
    ## Columns: 16
    ## $ Date                     <dttm> 2010-09-17, 2010-09-17, 2010-09-17, 2010-09-~
    ## $ Location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "A", "Q", "Q", "Q", "A", "A", "Q", "A", "A", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, 0.70, 0.66, NA, 0.56, 0.64, 0~
    ## $ pot_depth_m              <dbl> 0.90, NA, NA, NA, 0.76, 0.70, NA, 0.52, 0.66,~
    ## $ `velocity_m/s`           <dbl> 0.38, NA, NA, NA, 0.55, 0.80, NA, 0.33, 0.35,~
    ## $ percent_fine_substrate   <dbl> 10, NA, NA, NA, 20, 10, NA, 10, 10, 10, 30, 2~
    ## $ percent_small_substrate  <dbl> 60, NA, NA, NA, 70, 10, NA, 90, 20, 20, 40, 3~
    ## $ percent_medium_substrate <dbl> 30, NA, NA, NA, 10, 70, NA, 0, 70, 50, 30, 50~
    ## $ percent_large_substrate  <dbl> 0, NA, NA, NA, 0, 10, NA, 0, 0, 20, 0, 0, 0, ~
    ## $ percent_boulder          <dbl> 0, NA, NA, NA, 0, 0, NA, 0, 0, 0, 0, 0, 0, 0,~
    ## $ redd_width_m             <dbl> NA, 0.9143554, 1.2191405, 3.0478513, NA, NA, ~
    ## $ redd_length_m            <dbl> NA, 0.6095703, 0.9143554, 4.5717769, NA, NA, ~

``` r
# glimpse(raw_data_2011)

raw_data_2011$'redd width (ft)' = raw_data_2011$'redd width (ft)'/3.281
raw_data_2011$'redd length (ft)' = raw_data_2011$'redd length (ft)'/3.281
cleaner_data_2011 <- raw_data_2011 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines(<1 cm)',
         'percent_small_substrate' = '% small (1-5 cm)',
         'percent_medium_substrate'= '% med (5-15 cm)',
         'percent_large_substrate' = '% large (15-30 cm)',
         'percent_boulder' = '% boulder (>30 cm)',
         'redd_width_m' = 'redd width (ft)',
         'redd_length_m' = 'redd length (ft)',
         ) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude)) %>% 
  glimpse()
```

    ## Rows: 1,394
    ## Columns: 16
    ## $ Date                     <dttm> 2011-09-11, 2011-09-11, 2011-09-11, 2011-09-~
    ## $ Location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "q", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 3, 2, 0, 4, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> 0.78, 0.78, 0.86, NA, 0.42, 0.68, NA, 0.38, 0~
    ## $ pot_depth_m              <dbl> 0.67, 0.67, 1.12, NA, 0.44, 0.65, NA, 0.52, 0~
    ## $ `velocity_m/s`           <dbl> 0.55, 0.55, 0.79, NA, 0.12, 0.55, NA, 0.65, 0~
    ## $ percent_fine_substrate   <dbl> 30, 30, 20, NA, 10, 10, NA, 10, 10, 10, 10, 2~
    ## $ percent_small_substrate  <dbl> 60, 60, 50, NA, 60, 20, NA, 40, 40, 50, 30, 6~
    ## $ percent_medium_substrate <dbl> 10, 10, 30, NA, 30, 60, NA, 40, 50, 40, 60, 2~
    ## $ percent_large_substrate  <dbl> 0, 0, 0, NA, 0, 10, NA, 10, 0, 0, 0, 0, 0, 0,~
    ## $ percent_boulder          <dbl> 0, 0, 0, NA, 0, 0, NA, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ redd_width_m             <dbl> 0.9143554, 0.9143554, 0.6095703, NA, 1.523925~
    ## $ redd_length_m            <dbl> 0.9143554, 0.9143554, 1.2191405, NA, 2.438281~

``` r
glimpse(raw_data_2012)
```

    ## Rows: 1,774
    ## Columns: 19
    ## $ Date              <dttm> 2012-08-08, 2012-08-08, 2012-08-08, 2012-09-12, 201~
    ## $ `Survey Wk`       <dbl> 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2~
    ## $ Location          <chr> "Moes", "Moes", "Moes", "Table Mtn", "Table Mtn", "T~
    ## $ `File #`          <dbl> 1, 2, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, ~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 1, 0, 2, 0, 0, 2, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0~
    ## $ Latitude          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ Longitude         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Depth (m)`       <dbl> 0.38, 0.32, 0.22, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Pot Depth (m)`   <dbl> 0.40, 0.45, 0.28, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Velocity (m/s)`  <dbl> 0.55, 0.64, 0.42, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `% fines`         <dbl> 0, 10, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA~
    ## $ `% small`         <dbl> 40, 40, 25, NA, NA, NA, NA, NA, NA, NA, NA, NA, 20, ~
    ## $ `% med`           <dbl> 50, 50, 65, NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, ~
    ## $ `% large`         <dbl> 10, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 30, NA~
    ## $ `% boulder`       <dbl> 0, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, ~
    ## $ `redd width (m)`  <dbl> 1.00, 1.00, 0.75, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `redd length (m)` <dbl> 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2~

``` r
cleaner_data_2012 <- raw_data_2012 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude)) %>% 
  glimpse()
```

    ## Rows: 1,774
    ## Columns: 16
    ## $ Date                     <dttm> 2012-08-08, 2012-08-08, 2012-08-08, 2012-09-~
    ## $ Location                 <chr> "Moes", "Moes", "Moes", "Table Mtn", "Table M~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 1, 0, 2, 0, 0, 2, 0, 0, 0, 1, 1, 1, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> 0.38, 0.32, 0.22, NA, NA, NA, NA, NA, NA, NA,~
    ## $ pot_depth_m              <dbl> 0.40, 0.45, 0.28, NA, NA, NA, NA, NA, NA, NA,~
    ## $ `velocity_m/s`           <dbl> 0.55, 0.64, 0.42, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_fine_substrate   <dbl> 0, 10, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ percent_small_substrate  <dbl> 40, 40, 25, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 50, 50, 65, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 10, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_boulder          <dbl> 0, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ redd_width_m             <dbl> 1.00, 1.00, 0.75, NA, NA, NA, NA, NA, NA, NA,~
    ## $ redd_length_m            <dbl> 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA~

``` r
# glimpse(raw_data_2013)

cleaner_data_2013 <- raw_data_2013 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('Date' = All,
         'salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>%
  mutate(Date = as.Date(as.numeric(Date), origin = "1899-12-30")) %>% 
  glimpse()
```

    ## Rows: 748
    ## Columns: 16
    ## $ Date                     <date> 2013-09-10, 2013-09-10, 2013-09-10, 2013-09-~
    ## $ Location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 1, 1, 0, 1, 0, 3, 1, 0, 0, 0, 1, 1, 0, 1, ~
    ## $ latitude                 <dbl> 393055.9, 393056.1, 393055.7, 393055.8, 39305~
    ## $ longitude                <dbl> 1213338, 1213338, 1213338, 1213338, 1213337, ~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.25, NA,~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.43, NA,~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.71, NA,~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, NA, N~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, NA, N~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 25, NA, N~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 15, NA, N~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, NA~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, NA, NA~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1.5, NA, ~

``` r
# glimpse(raw_data_2014)

cleaner_data_2014 <- raw_data_2014 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>%
  mutate(Date = as.Date(as.numeric(Date), origin = "1899-12-30")) %>% 
  glimpse()
```

    ## Rows: 1,911
    ## Columns: 16
    ## $ Date                     <date> 2014-09-09, 2014-09-09, 2014-09-15, 2014-09-~
    ## $ Location                 <chr> "Moe's Side Channel", "Upper Cottonwood", "Co~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 0, 3, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, ~
    ## $ latitude                 <dbl> 4375043, 4375121, 4375108, 4375106, 4375110, ~
    ## $ longitude                <dbl> 6239424.4, 624284.0, 624147.7, 624150.0, 6241~
    ## $ depth_m                  <dbl> 0.30, 0.62, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ pot_depth_m              <dbl> 0.50, 0.70, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `velocity_m/s`           <dbl> 0.61, 0.89, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_fine_substrate   <dbl> 40, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0,~
    ## $ percent_small_substrate  <dbl> 20, 65, NA, NA, NA, NA, NA, NA, NA, NA, NA, 4~
    ## $ percent_medium_substrate <dbl> 35, 30, NA, NA, NA, NA, NA, NA, NA, NA, NA, 5~
    ## $ percent_large_substrate  <dbl> 5, 5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 10,~
    ## $ percent_boulder          <dbl> 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, ~
    ## $ redd_width_m             <dbl> 1.1, 2.5, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ redd_length_m            <dbl> 2.0, 3.5, NA, NA, NA, NA, NA, NA, NA, NA, NA,~

``` r
# glimpse(raw_data_2015)
cleaner_data_2015 <- raw_data_2015 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  glimpse()
```

    ## Rows: 2,344
    ## Columns: 16
    ## $ Date                     <dttm> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-~
    ## $ Location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> 4375000, 4374955, 4374977, 4374978, 4374985, ~
    ## $ longitude                <dbl> 623703.5, 623760.0, 623766.3, 623766.7, 62376~
    ## $ depth_m                  <dbl> 0.40, 0.40, 0.56, 0.56, 0.50, 0.42, 0.37, 0.4~
    ## $ pot_depth_m              <dbl> 0.50, 0.60, 0.60, 0.60, 0.60, 0.55, 0.45, 0.6~
    ## $ `velocity_m/s`           <dbl> 0.40, 0.59, 0.53, 0.53, 0.55, 0.32, 0.74, 0.6~
    ## $ percent_fine_substrate   <dbl> 20, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, ~
    ## $ percent_small_substrate  <dbl> 40, 30, 30, 30, 30, 20, 40, 30, 30, 20, 30, 1~
    ## $ percent_medium_substrate <dbl> 40, 40, 30, 30, 30, 50, 50, 60, 50, 50, 60, 6~
    ## $ percent_large_substrate  <dbl> 0, 30, 40, 40, 40, 30, 0, 0, 10, 20, 0, 30, 3~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 20, 0~
    ## $ redd_width_m             <dbl> 1.20, 1.10, 0.75, 0.75, 1.50, 1.60, 1.20, 1.0~
    ## $ redd_length_m            <dbl> 1.75, 1.75, 1.00, 1.00, 1.75, 2.00, 1.75, 1.2~

``` r
glimpse(raw_data_2016)
```

    ## Rows: 1,570
    ## Columns: 19
    ## $ Date              <dttm> 2016-09-20, 2016-09-20, 2016-09-20, 2016-09-20, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Cottonwood", "Cottonwood", "Cottonwood", "Cottonwoo~
    ## $ `File #`          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 3, 0, 0, 3, 0, 2, 1, 0, 5, 0, 2, 3, 1, 0~
    ## $ `Latitude mN`     <dbl> 4375097, 4375101, 4375108, 4375111, 4375123, 4375135~
    ## $ `Longitude mE`    <dbl> 624148.9, 624146.1, 624152.3, 624169.5, 624172.1, 62~
    ## $ `Depth (m)`       <dbl> NA, NA, NA, NA, NA, NA, NA, 0.54, NA, NA, NA, NA, 0.~
    ## $ `Pot Depth (m)`   <dbl> NA, NA, NA, NA, NA, NA, NA, 0.62, NA, NA, NA, NA, 0.~
    ## $ `Velocity (m/s)`  <dbl> NA, NA, NA, NA, NA, NA, NA, 0.34, NA, NA, NA, NA, 0.~
    ## $ `% fines`         <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, NA, 5, N~
    ## $ `% small`         <dbl> NA, NA, NA, NA, NA, NA, NA, 30, NA, NA, NA, NA, 30, ~
    ## $ `% med`           <dbl> NA, NA, NA, NA, NA, NA, NA, 40, NA, NA, NA, NA, 50, ~
    ## $ `% large`         <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, NA, 15, ~
    ## $ `% boulder`       <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, NA, 0, N~
    ## $ `redd width (m)`  <dbl> NA, NA, NA, NA, NA, NA, NA, 1.0, NA, NA, NA, NA, 1.0~
    ## $ `redd length (m)` <dbl> NA, NA, NA, NA, NA, NA, NA, 2.5, NA, NA, NA, NA, 1.5~

``` r
cleaner_data_2016 <- raw_data_2016 %>% 
  select(-c('Survey Wk', 'File #', '# of redds')) %>% 
  rename('salmon_counted'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  glimpse()
```

    ## Rows: 1,570
    ## Columns: 16
    ## $ Date                     <dttm> 2016-09-20, 2016-09-20, 2016-09-20, 2016-09-~
    ## $ Location                 <chr> "Cottonwood", "Cottonwood", "Cottonwood", "Co~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 3, 0, 0, 3, 0, 2, 1, 0, 5, 0, 2, ~
    ## $ latitude                 <dbl> 4375097, 4375101, 4375108, 4375111, 4375123, ~
    ## $ longitude                <dbl> 624148.9, 624146.1, 624152.3, 624169.5, 62417~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, 0.54, NA, NA, NA,~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, 0.62, NA, NA, NA,~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, 0.34, NA, NA, NA,~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, N~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, 30, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, NA, NA, 40, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, N~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, N~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, NA, NA, 1.0, NA, NA, NA, ~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, NA, NA, 2.5, NA, NA, NA, ~

``` r
# glimpse(raw_data_2017)
cleaner_data_2017 <- raw_data_2017 %>% 
  select(-c('Survey Wk', 'File #', '# redds')) %>% 
  rename('type'= 'Type',
         'salmon_counted'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  glimpse()
```

    ## Rows: 2,717
    ## Columns: 16
    ## $ Date                     <dttm> 2017-10-03, 2017-10-03, 2017-10-03, 2017-10-~
    ## $ Location                 <chr> "Hatchery", "Hatchery", "Top of Auditorium", ~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4375041, 4375035, 4375077, 4375074, 4375069, ~
    ## $ longitude                <dbl> 624281.7, 624285.5, 624062.3, 624060.5, 62406~
    ## $ depth_m                  <dbl> 0.32, 0.50, 0.48, 0.34, 0.52, 0.48, 0.70, 0.6~
    ## $ pot_depth_m              <dbl> 0.48, 0.42, 0.56, 0.40, 0.66, 0.62, 0.80, 0.5~
    ## $ `velocity_m/s`           <dbl> 0.64, 0.55, 0.45, 0.57, 0.95, 0.30, 0.42, 0.4~
    ## $ percent_fine_substrate   <dbl> 0, 0, 5, 5, 0, 5, 0, 0, 10, 10, 10, 10, 5, 0,~
    ## $ percent_small_substrate  <dbl> 5, 5, 30, 30, 30, 30, 50, 60, 20, 20, 30, 30,~
    ## $ percent_medium_substrate <dbl> 65, 65, 50, 50, 70, 50, 50, 40, 40, 40, 30, 3~
    ## $ percent_large_substrate  <dbl> 30, 30, 15, 15, 0, 15, 0, 0, 30, 30, 30, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 2.2, 2.2, 1.2, 1.0, 1.2, 1.4, 1.9, 1.4, 1.8, ~
    ## $ redd_length_m            <dbl> 3.6, 2.9, 2.7, 1.3, 3.2, 2.8, 3.2, 2.3, 4.0, ~

``` r
# glimpse(raw_data_2018)
cleaner_data_2018 <- raw_data_2018 %>% 
  select(-c('Survey Wk', 'File #', '# redds')) %>% 
  rename('type' = Type,
         'salmon_counted'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',) %>% 
  glimpse()
```

    ## Rows: 4,156
    ## Columns: 16
    ## $ Date                     <dttm> 2018-09-18, 2018-09-18, 2018-09-18, 2018-09-~
    ## $ Location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4374970, NA, 4374978, 4374983, 4374987, 43749~
    ## $ longitude                <dbl> 623743.6, NA, 623812.0, 623810.8, 623810.3, 6~
    ## $ depth_m                  <dbl> 0.58, 0.38, 0.46, 0.44, 0.32, 0.46, 0.52, 0.4~
    ## $ pot_depth_m              <dbl> 0.58, 0.46, 0.48, 0.52, 0.34, 0.56, 0.58, 0.4~
    ## $ `velocity_m/s`           <dbl> 0.36, 0.39, 0.27, 0.52, 0.66, 0.55, 0.75, 0.4~
    ## $ percent_fine_substrate   <dbl> 25, 10, 10, 20, 20, 20, 10, 15, 5, 10, 5, 10,~
    ## $ percent_small_substrate  <dbl> 20, 15, 10, 30, 50, 40, 20, 30, 25, 40, 50, 5~
    ## $ percent_medium_substrate <dbl> 40, 50, 55, 25, 25, 25, 60, 50, 65, 40, 40, 3~
    ## $ percent_large_substrate  <dbl> 15, 25, 25, 25, 5, 15, 10, 5, 5, 10, 5, 0, 15~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 3.00, 1.75, 1.50, 2.00, 1.50, 1.00, 2.50, 1.5~
    ## $ redd_length_m            <dbl> 1.75, 2.50, 2.50, 2.50, 2.50, 1.75, 2.50, 2.2~

``` r
glimpse(raw_data_2019)
```

    ## Rows: 5,048
    ## Columns: 19
    ## $ Date              <dttm> 2019-09-03, 2019-09-04, 2019-09-05, 2019-09-06, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-2", "1-3", "1-4", "2-1", "3-1", "3-1", "3-~
    ## $ Location          <chr> NA, NA, NA, NA, NA, "Middle Auditorium", "Middle Aud~
    ## $ `File #`          <dbl> NA, NA, NA, NA, NA, 1, 2, 3, 1, 2, 3, 4, 5, 6, 7, 8,~
    ## $ Type              <chr> NA, NA, NA, NA, NA, "p", "p", "p", "p", "p", "p", "p~
    ## $ `# redds`         <dbl> 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 0, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `Latitude mN`     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Longitude mE`    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Depth (m)`       <dbl> NA, NA, NA, NA, NA, 0.24, 0.47, 0.56, 0.48, 0.50, 0.~
    ## $ `Pot Depth (m)`   <dbl> NA, NA, NA, NA, NA, 0.34, 0.60, 0.72, 0.52, 0.54, 0.~
    ## $ `Velocity (m/s)`  <dbl> NA, NA, NA, NA, NA, 0.64, 1.10, 0.50, 0.47, 0.69, 0.~
    ## $ `% fines`         <dbl> NA, NA, NA, NA, NA, 10, 0, 0, 5, 0, 0, 5, 5, 40, 10,~
    ## $ `% small`         <dbl> NA, NA, NA, NA, NA, 40, 40, 60, 35, 30, 40, 20, 40, ~
    ## $ `% med`           <dbl> NA, NA, NA, NA, NA, 50, 50, 40, 60, 70, 55, 70, 50, ~
    ## $ `% large`         <dbl> NA, NA, NA, NA, NA, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 5,~
    ## $ `% boulder`       <dbl> NA, NA, NA, NA, NA, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `redd width (m)`  <dbl> NA, NA, NA, NA, NA, 1.1, 1.5, 2.0, 1.1, 1.0, 1.2, 0.~
    ## $ `redd length (m)` <dbl> NA, NA, NA, NA, NA, 4.5, 4.5, 3.7, 2.0, 1.5, 3.1, 1.~

``` r
cleaner_data_2019 <- raw_data_2019 %>% 
  select(-c('Survey Wk', 'File #', '# redds')) %>% 
  rename('type'= Type,
         'salmon_counted'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude)) %>% 
  glimpse()
```

    ## Rows: 5,048
    ## Columns: 16
    ## $ Date                     <dttm> 2019-09-03, 2019-09-04, 2019-09-05, 2019-09-~
    ## $ Location                 <chr> NA, NA, NA, NA, NA, "Middle Auditorium", "Mid~
    ## $ type                     <chr> NA, NA, NA, NA, NA, "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, 0.24, 0.47, 0.56, 0.48, 0~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, 0.34, 0.60, 0.72, 0.52, 0~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, 0.64, 1.10, 0.50, 0.47, 0~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, 10, 0, 0, 5, 0, 0, 5, 5, ~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, 40, 40, 60, 35, 30, 40, 2~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, 50, 50, 40, 60, 70, 55, 7~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, 0, 0, 0, 0, 0, 5, 5, 5, 5~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, 0, 10, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, 1.1, 1.5, 2.0, 1.1, 1.0, ~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, 4.5, 4.5, 3.7, 2.0, 1.5, ~

``` r
glimpse(raw_data_2020)
```

    ## Rows: 5,432
    ## Columns: 19
    ## $ Date              <dttm> 2020-09-22, 2020-09-22, 2020-09-22, 2020-09-22, 202~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Table Mountain", "Table Mountain", "Lower Table Mou~
    ## $ `File#`           <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1~
    ## $ Type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `#Redds`          <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# Salmon`        <dbl> 0, 0, 0, 1, 4, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `Latitude mN`     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Longitude nE`    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Depth (m)`       <dbl> 0.48, 0.72, NA, NA, NA, 0.47, NA, NA, 0.49, 0.52, 0.~
    ## $ `Pot Depth (m)`   <dbl> 0.54, 0.84, NA, NA, NA, 0.50, NA, NA, 0.50, 0.55, 0.~
    ## $ `Velocity (m/s)`  <dbl> 0.718, 1.012, NA, NA, NA, 0.250, NA, NA, 0.282, 0.34~
    ## $ `% Fines`         <dbl> 10, 0, NA, NA, NA, 10, NA, NA, 20, 20, 30, 0, 10, NA~
    ## $ `% Small`         <dbl> 20, 30, NA, NA, NA, 20, NA, NA, 40, 40, 40, 10, 30, ~
    ## $ `% Med`           <dbl> 30, 40, NA, NA, NA, 50, NA, NA, 30, 30, 20, 30, 40, ~
    ## $ `% Large`         <dbl> 30, 30, NA, NA, NA, 20, NA, NA, 10, 10, 10, 50, 20, ~
    ## $ `% Boulder`       <dbl> 10, 0, NA, NA, NA, 0, NA, NA, 0, 0, 0, 10, 0, NA, NA~
    ## $ `Redd Width (m)`  <dbl> 0.5, 0.5, NA, NA, NA, 0.7, NA, NA, 1.0, 1.2, 1.0, 0.~
    ## $ `Redd Length (m)` <dbl> 1.8, 1.5, NA, NA, NA, 1.8, NA, NA, 2.0, 2.2, 2.0, 1.~

``` r
cleaner_data_2020 <- raw_data_2020 %>% 
  select(-c('Survey Wk', 'File#', '#Redds')) %>% 
  rename('type'= Type, 
         'salmon_counted'= '# Salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude nE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% Fines',
         'percent_small_substrate' = '% Small',
         'percent_medium_substrate'= '% Med',
         'percent_large_substrate' = '% Large',
         'percent_boulder' = '% Boulder',
         'redd_width_m' = 'Redd Width (m)',
         'redd_length_m' = 'Redd Length (m)'
         ) %>% 
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude)) %>% 
  glimpse()
```

    ## Rows: 5,432
    ## Columns: 16
    ## $ Date                     <dttm> 2020-09-22, 2020-09-22, 2020-09-22, 2020-09-~
    ## $ Location                 <chr> "Table Mountain", "Table Mountain", "Lower Ta~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 0, 0, 0, 1, 4, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> 0.48, 0.72, NA, NA, NA, 0.47, NA, NA, 0.49, 0~
    ## $ pot_depth_m              <dbl> 0.54, 0.84, NA, NA, NA, 0.50, NA, NA, 0.50, 0~
    ## $ `velocity_m/s`           <dbl> 0.718, 1.012, NA, NA, NA, 0.250, NA, NA, 0.28~
    ## $ percent_fine_substrate   <dbl> 10, 0, NA, NA, NA, 10, NA, NA, 20, 20, 30, 0,~
    ## $ percent_small_substrate  <dbl> 20, 30, NA, NA, NA, 20, NA, NA, 40, 40, 40, 1~
    ## $ percent_medium_substrate <dbl> 30, 40, NA, NA, NA, 50, NA, NA, 30, 30, 20, 3~
    ## $ percent_large_substrate  <dbl> 30, 30, NA, NA, NA, 20, NA, NA, 10, 10, 10, 5~
    ## $ percent_boulder          <dbl> 10, 0, NA, NA, NA, 0, NA, NA, 0, 0, 0, 10, 0,~
    ## $ redd_width_m             <dbl> 0.5, 0.5, NA, NA, NA, 0.7, NA, NA, 1.0, 1.2, ~
    ## $ redd_length_m            <dbl> 1.8, 1.5, NA, NA, NA, 1.8, NA, NA, 2.0, 2.2, ~

``` r
full_redd_survey_data <- bind_rows(cleaner_data_2009, 
          cleaner_data_2010, 
          cleaner_data_2011, 
          cleaner_data_2012, 
          cleaner_data_2013,
          cleaner_data_2014,
          cleaner_data_2015,
          cleaner_data_2016,
          cleaner_data_2017,
          cleaner_data_2018,
          cleaner_data_2019,
          cleaner_data_2020)
```

``` r
glimpse(full_redd_survey_data)
```

    ## Rows: 28,296
    ## Columns: 16
    ## $ Date                     <dttm> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-~
    ## $ Location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "Area", "Point", "Area", "Area", "Area", "Are~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_fine_substrate   <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, ~
    ## $ percent_small_substrate  <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, ~
    ## $ percent_boulder          <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, N~
    ## $ redd_width_m             <dbl> NA, 0.9143554, 0.9143554, 0.9143554, 1.219140~
    ## $ redd_length_m            <dbl> NA, 1.2191405, 1.5239256, 1.2191405, 1.828710~

Clean up the column names, change convert date time (dttm) to Date
format

``` r
cleaner_full_redd_survey_data <- full_redd_survey_data %>% 
  set_names(tolower(colnames(full_redd_survey_data))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 28,296
    ## Columns: 16
    ## $ date                     <date> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-~
    ## $ location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "Area", "Point", "Area", "Area", "Area", "Are~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_fine_substrate   <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, ~
    ## $ percent_small_substrate  <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, ~
    ## $ percent_boulder          <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, N~
    ## $ redd_width_m             <dbl> NA, 0.9143554, 0.9143554, 0.9143554, 1.219140~
    ## $ redd_length_m            <dbl> NA, 1.2191405, 1.5239256, 1.2191405, 1.828710~

## Explore Categorical Variables:

``` r
cleaner_full_redd_survey_data %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable: `location`

``` r
table(cleaner_full_redd_survey_data$location)
```

    ## 
    ##                          Alec                         Aleck 
    ##                             1                           162 
    ##                  Aleck Riffle                    Auditorium 
    ##                            27                           335 
    ##                       Bedrock                Bedrock Riffle 
    ##                           276                           262 
    ##              Below Auditorium                 Below Big Bar 
    ##                             2                             4 
    ##                Below Big Hole           Below Big hole East 
    ##                             1                             1 
    ##           Below Big Hole East        Below Lower Auditorium 
    ##                            14                           267 
    ##                    Below weir                           Big 
    ##                             1                             7 
    ##                       Big Bar                 Big Hole East 
    ##                            42                           183 
    ##                 Big Hole West                  Big HoleWest 
    ##                            20                             6 
    ##                    Big Riffle                Big River Left 
    ##                            82                             6 
    ##     Bottom G95 East Side Chnl                    Cottonwood 
    ##                            14                           658 
    ##                    Developing             Developing Riffle 
    ##                             9                             8 
    ##                           Eye                    Eye Riffle 
    ##                            63                             1 
    ##              Eye Side Channel        G-95 East Side Channel 
    ##                            99                             1 
    ## G-95 East Side Channel Bottom                     G-95 Main 
    ##                             1                             1 
    ## G-95 West Side Channel Bottom                           G95 
    ##                             1                            19 
    ##                    G95 Bottom                      G95 East 
    ##                             7                            15 
    ##               G95 East Bottom         G95 East Side Channel 
    ##                            84                            56 
    ##  G95 East Side Channel Bottom     G95 East side Channel Top 
    ##                            84                             4 
    ##     G95 East Side Channel Top                  G95 East Top 
    ##                            30                            96 
    ##                      G95 Main              G95 Side Channel 
    ##                            68                             1 
    ##                      G95 West               G95 West Bottom 
    ##                            24                             1 
    ##         G95 West Side Channel            G95 West Side Chnl 
    ##                            28                             2 
    ##                  G95 West Top                       Gateway 
    ##                             4                            38 
    ##          Gateway Main Channel          Gateway Side Channel 
    ##                            15                             8 
    ##                         Goose                  Goose Riffle 
    ##                            27                             9 
    ##                 Great Western                      Hatchery 
    ##                            12                          1306 
    ##                Hatchery Ditch                 Hatchery Pipe 
    ##                           141                           361 
    ##               Hatchery Riffle         Hatchery Side Channel 
    ##                           919                           114 
    ##                     High Flow                          Hour 
    ##                             1                            29 
    ##                    Hour Glide                       Keister 
    ##                             4                            60 
    ##                Keister Riffle                   Keister Top 
    ##                             2                             1 
    ##              Lower Auditorium                 Lower Bedrock 
    ##                          5519                             3 
    ##                 Lower Big Bar              Lower Big Riffle 
    ##                             6                             8 
    ##                 Lower Gateway                Lower Hatchery 
    ##                             3                            16 
    ##          Lower Hatchery Ditch         Lower Hatchery Riffle 
    ##                            56                            55 
    ##                    lower Hour                    Lower Hour 
    ##                            10                           129 
    ##               Lower McFarland              Lower Moes Ditch 
    ##                            27                            54 
    ##                Lower Robinson         Lower Steep Side Chnl 
    ##                           996                             3 
    ##          Lower Table Mountain               Lower Table Mtn 
    ##                           450                            49 
    ##            Lower Trailer Park              Lower Vance East 
    ##                            44                            42 
    ##                       Mathews                      Matthews 
    ##                           225                            97 
    ##                Mid Auditorium        Mid G95 East Side Chnl 
    ##                           114                             9 
    ##                      Mid Hour                 Mid McFarland 
    ##                            15                             1 
    ##                Mid Vance East              Middle Auditoium 
    ##                             4                           216 
    ##             Middle Auditorium               Middle Robinson 
    ##                           804                            14 
    ##                   Moe's Ditch            Moe's Side Channel 
    ##                            97                          1803 
    ##                          Moes                    Moes Ditch 
    ##                             3                            32 
    ##                          Palm                   Palm Riffle 
    ##                             9                             1 
    ##                      Robinson                         Steep 
    ##                            55                            85 
    ##                  Steep Riffle            Steep Side Channel 
    ##                           108                           123 
    ##                Table Mountain                     Table Mtn 
    ##                           751                            94 
    ##                    Thermalito             Top Big Hole East 
    ##                             2                            21 
    ##           Top Big River Right        Top G95 East Side Chnl 
    ##                             1                             8 
    ##                  Top G95 Main        Top G95 West Side Chnl 
    ##                            10                             4 
    ##                      Top Hour                   Top Keister 
    ##                            19                             3 
    ##         Top Moes Side Channel             Top of Auditorium 
    ##                             8                          2477 
    ##               Top of Hatchery                   Top of Hour 
    ##                             9                             8 
    ##               Top of Matthews             Top of Moes Ditch 
    ##                             2                             2 
    ##                  Top of Steep                Top Vance East 
    ##                             8                            38 
    ##                Top Vance West                  Trailer Park 
    ##                             9                          1586 
    ##                   Upper Aleck              Upper Auditorium 
    ##                             3                          1918 
    ##                 Upper Bedrock              Upper Cottonwood 
    ##                           109                           392 
    ##                Upper Hatchery          Upper Hatchery Ditch 
    ##                           848                            12 
    ##         Upper Hatchery Riffle                    Upper Hour 
    ##                           676                            83 
    ##               Upper Hour east                 Upper Mathews 
    ##                             2                           174 
    ##                Upper Matthews               Upper Mcfarland 
    ##                           101                             7 
    ##               Upper McFarland                Upper McFarlin 
    ##                            24                             2 
    ##           Upper Moe's Channel                    Upper Moes 
    ##                             2                            30 
    ##              Upper Moes Ditch                Upper Robinson 
    ##                             4                           928 
    ##                   Upper Steep            Upper Trailer Park 
    ##                            14                            17 
    ##                   Upper Vance             Uppper Auditorium 
    ##                             1                             3 
    ##                    Vance East              Vance East Lower 
    ##                           154                             6 
    ##       Vance East Side Channel                Vance East Top 
    ##                             1                            10 
    ##                    vance West                    Vance West 
    ##                             6                            62 
    ##                          Weir                   Weir Riffle 
    ##                           149                            81 
    ##                          Wier 
    ##                             2

``` r
cleaner_full_redd_survey_data$location <- tolower(cleaner_full_redd_survey_data$location)  
table(cleaner_full_redd_survey_data$location)
```

    ## 
    ##                          alec                         aleck 
    ##                             1                           162 
    ##                  aleck riffle                    auditorium 
    ##                            27                           335 
    ##                       bedrock                bedrock riffle 
    ##                           276                           262 
    ##              below auditorium                 below big bar 
    ##                             2                             4 
    ##                below big hole           below big hole east 
    ##                             1                            15 
    ##        below lower auditorium                    below weir 
    ##                           267                             1 
    ##                           big                       big bar 
    ##                             7                            42 
    ##                 big hole east                 big hole west 
    ##                           183                            20 
    ##                  big holewest                    big riffle 
    ##                             6                            82 
    ##                big river left     bottom g95 east side chnl 
    ##                             6                            14 
    ##                    cottonwood                    developing 
    ##                           658                             9 
    ##             developing riffle                           eye 
    ##                             8                            63 
    ##                    eye riffle              eye side channel 
    ##                             1                            99 
    ##        g-95 east side channel g-95 east side channel bottom 
    ##                             1                             1 
    ##                     g-95 main g-95 west side channel bottom 
    ##                             1                             1 
    ##                           g95                    g95 bottom 
    ##                            19                             7 
    ##                      g95 east               g95 east bottom 
    ##                            15                            84 
    ##         g95 east side channel  g95 east side channel bottom 
    ##                            56                            84 
    ##     g95 east side channel top                  g95 east top 
    ##                            34                            96 
    ##                      g95 main              g95 side channel 
    ##                            68                             1 
    ##                      g95 west               g95 west bottom 
    ##                            24                             1 
    ##         g95 west side channel            g95 west side chnl 
    ##                            28                             2 
    ##                  g95 west top                       gateway 
    ##                             4                            38 
    ##          gateway main channel          gateway side channel 
    ##                            15                             8 
    ##                         goose                  goose riffle 
    ##                            27                             9 
    ##                 great western                      hatchery 
    ##                            12                          1306 
    ##                hatchery ditch                 hatchery pipe 
    ##                           141                           361 
    ##               hatchery riffle         hatchery side channel 
    ##                           919                           114 
    ##                     high flow                          hour 
    ##                             1                            29 
    ##                    hour glide                       keister 
    ##                             4                            60 
    ##                keister riffle                   keister top 
    ##                             2                             1 
    ##              lower auditorium                 lower bedrock 
    ##                          5519                             3 
    ##                 lower big bar              lower big riffle 
    ##                             6                             8 
    ##                 lower gateway                lower hatchery 
    ##                             3                            16 
    ##          lower hatchery ditch         lower hatchery riffle 
    ##                            56                            55 
    ##                    lower hour               lower mcfarland 
    ##                           139                            27 
    ##              lower moes ditch                lower robinson 
    ##                            54                           996 
    ##         lower steep side chnl          lower table mountain 
    ##                             3                           450 
    ##               lower table mtn            lower trailer park 
    ##                            49                            44 
    ##              lower vance east                       mathews 
    ##                            42                           225 
    ##                      matthews                mid auditorium 
    ##                            97                           114 
    ##        mid g95 east side chnl                      mid hour 
    ##                             9                            15 
    ##                 mid mcfarland                mid vance east 
    ##                             1                             4 
    ##              middle auditoium             middle auditorium 
    ##                           216                           804 
    ##               middle robinson                   moe's ditch 
    ##                            14                            97 
    ##            moe's side channel                          moes 
    ##                          1803                             3 
    ##                    moes ditch                          palm 
    ##                            32                             9 
    ##                   palm riffle                      robinson 
    ##                             1                            55 
    ##                         steep                  steep riffle 
    ##                            85                           108 
    ##            steep side channel                table mountain 
    ##                           123                           751 
    ##                     table mtn                    thermalito 
    ##                            94                             2 
    ##             top big hole east           top big river right 
    ##                            21                             1 
    ##        top g95 east side chnl                  top g95 main 
    ##                             8                            10 
    ##        top g95 west side chnl                      top hour 
    ##                             4                            19 
    ##                   top keister         top moes side channel 
    ##                             3                             8 
    ##             top of auditorium               top of hatchery 
    ##                          2477                             9 
    ##                   top of hour               top of matthews 
    ##                             8                             2 
    ##             top of moes ditch                  top of steep 
    ##                             2                             8 
    ##                top vance east                top vance west 
    ##                            38                             9 
    ##                  trailer park                   upper aleck 
    ##                          1586                             3 
    ##              upper auditorium                 upper bedrock 
    ##                          1918                           109 
    ##              upper cottonwood                upper hatchery 
    ##                           392                           848 
    ##          upper hatchery ditch         upper hatchery riffle 
    ##                            12                           676 
    ##                    upper hour               upper hour east 
    ##                            83                             2 
    ##                 upper mathews                upper matthews 
    ##                           174                           101 
    ##               upper mcfarland                upper mcfarlin 
    ##                            31                             2 
    ##           upper moe's channel                    upper moes 
    ##                             2                            30 
    ##              upper moes ditch                upper robinson 
    ##                             4                           928 
    ##                   upper steep            upper trailer park 
    ##                            14                            17 
    ##                   upper vance             uppper auditorium 
    ##                             1                             3 
    ##                    vance east              vance east lower 
    ##                           154                             6 
    ##       vance east side channel                vance east top 
    ##                             1                            10 
    ##                    vance west                          weir 
    ##                            68                           149 
    ##                   weir riffle                          wier 
    ##                            81                             2

## Explore Numeric Variables:

``` r
cleaner_full_redd_survey_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ##  [1] "salmon_counted"           "latitude"                
    ##  [3] "longitude"                "depth_m"                 
    ##  [5] "pot_depth_m"              "velocity_m/s"            
    ##  [7] "percent_fine_substrate"   "percent_small_substrate" 
    ##  [9] "percent_medium_substrate" "percent_large_substrate" 
    ## [11] "percent_boulder"          "redd_width_m"            
    ## [13] "redd_length_m"

### Variable: salmon\_counted

``` r
cleaner_full_redd_survey_data %>% 
  # na.omit(salmon_counted) %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

``` r
# Boxplots of daily counts by year
cleaner_full_redd_survey_data  %>%
  group_by(date) %>%
  summarise(daily_salmon_count = sum(salmon_counted)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = (daily_salmon_count)))+ 
  geom_boxplot() + 
  theme_minimal() +
  theme(text = element_text(size = 12)) 
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->
**Numeric Summary of \[Variable\] over Period of Record**

``` r
summary(cleaner_full_redd_survey_data$salmon_counted)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
    ##   0.0000   0.0000   0.0000   0.4195   0.0000 200.0000        1

``` r
cleaner_full_redd_survey_data %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    6.00   18.00   40.24   61.00  382.00

**NA and Unknown Values** \* 0.004 % of values in the `salmon_counted`
column are NA.

### Variable: latitude

``` r
cleaner_full_redd_survey_data %>% 
  ggplot(aes(x = date, y = latitude)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 12)) + 
  theme(axis.text.x = element_text(angle = 90))
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
distinct(cleaner_full_redd_survey_data, latitude)
```

    ## # A tibble: 9,152 x 1
    ##    latitude
    ##       <dbl>
    ##  1      NA 
    ##  2       1 
    ##  3  393056.
    ##  4  393056.
    ##  5  393056.
    ##  6  393056.
    ##  7  393056.
    ##  8  393056.
    ##  9  393056.
    ## 10  393057.
    ## # ... with 9,142 more rows

``` r
summary(cleaner_full_redd_survey_data$latitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       1 4374974 4375010 3991592 4375053 4394990   18818

``` r
cleaner_full_redd_survey_data %>% 
  count(latitude)
```

    ## # A tibble: 9,152 x 2
    ##    latitude     n
    ##       <dbl> <int>
    ##  1       1    146
    ##  2  392226.     1
    ##  3  392226.     1
    ##  4  392227.     1
    ##  5  392227.     1
    ##  6  392227.     1
    ##  7  392227.     1
    ##  8  392227.     1
    ##  9  392228.     1
    ## 10  392241.     1
    ## # ... with 9,142 more rows

\*latitude at 1.0 is converted to NA

``` r
cleaner_full_redd_survey_data$latitude <-
  na_if(cleaner_full_redd_survey_data$latitude, 1) 
cleaner_full_redd_survey_data %>%
  count(latitude)
```

    ## # A tibble: 9,151 x 2
    ##    latitude     n
    ##       <dbl> <int>
    ##  1  392226.     1
    ##  2  392226.     1
    ##  3  392227.     1
    ##  4  392227.     1
    ##  5  392227.     1
    ##  6  392227.     1
    ##  7  392227.     1
    ##  8  392228.     1
    ##  9  392241.     1
    ## 10  392243.     1
    ## # ... with 9,141 more rows

**NA and Unknown Values** \* 67 % of values in the `latitude` column are
NA.

### Variable: longitude

**Plotting longitude over Period of Record**

``` r
cleaner_full_redd_survey_data %>% 
  ggplot(aes(x = date, y = longitude)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 12)) + 
  theme(axis.text.x = element_text(angle = 90))
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of \[Variable\] over Period of Record**

``` r
summary(cleaner_full_redd_survey_data$longitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       1  623778  624009  663335  624216 6245105   18817

``` r
distinct(cleaner_full_redd_survey_data, longitude)
```

    ## # A tibble: 9,262 x 1
    ##    longitude
    ##        <dbl>
    ##  1       NA 
    ##  2        1 
    ##  3  1213338.
    ##  4  1213338.
    ##  5  1213338.
    ##  6  1213338.
    ##  7  1213337.
    ##  8  1213337.
    ##  9  1213334.
    ## 10  1213334.
    ## # ... with 9,252 more rows

``` r
cleaner_full_redd_survey_data %>% 
  count(longitude)
```

    ## # A tibble: 9,262 x 2
    ##    longitude     n
    ##        <dbl> <int>
    ##  1        1    147
    ##  2   617030.     1
    ##  3   617104.     1
    ##  4   617166.     1
    ##  5   617201.     1
    ##  6   617207.     1
    ##  7   617212.     1
    ##  8   617216.     1
    ##  9   617216.     1
    ## 10   617216.     1
    ## # ... with 9,252 more rows

\*longitude at 1.0 is converted to NA

``` r
cleaner_full_redd_survey_data$longitude <-
  na_if(cleaner_full_redd_survey_data$longitude, 1) 
cleaner_full_redd_survey_data %>%
  count(longitude)
```

    ## # A tibble: 9,261 x 2
    ##    longitude     n
    ##        <dbl> <int>
    ##  1   617030.     1
    ##  2   617104.     1
    ##  3   617166.     1
    ##  4   617201.     1
    ##  5   617207.     1
    ##  6   617212.     1
    ##  7   617216.     1
    ##  8   617216.     1
    ##  9   617216.     1
    ## 10   617236.     1
    ## # ... with 9,251 more rows

**NA and Unknown Values** \* 67 % of values in the `longitude` column
are NA

### Variable: depth\_m

**Plotting “depth\_m” over Period of Record** \#\#TODO: would be
interesting to see depth vs location chart

``` r
cleaner_full_redd_survey_data %>% 
  ggplot(aes(x = date, y = depth_m)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 12)) + 
  theme(axis.text.x = element_text(angle = 90))
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

``` r
# Boxplots of daily counts by year
cleaner_full_redd_survey_data  %>%
  group_by(date) %>%
  summarise(mean_depth_location = mean(depth_m)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = (mean_depth_location)))+ 
  geom_boxplot() + 
  theme_minimal() +
  theme(text = element_text(size = 12)) 
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

**Numeric Summary of “depth\_m”over Period of Record**

``` r
summary(cleaner_full_redd_survey_data$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.020   0.320   0.440   0.453   0.560   1.500   24243

**NA and Unknown Values** \* 85.7 % of values in the `depth_m` column
are NA

### Variable: pot\_depth\_m

TODO: add replace date with location **Plotting longitude over Period of
Record**

``` r
cleaner_full_redd_survey_data %>% 
  ggplot(aes(x = date, y = pot_depth_m)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 8)) + 
  theme(axis.text.x = element_text(angle = 90))
```

![](feather-river-halltag-data-qc-checklist_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of pot\_depth\_m over Period of Record**

``` r
summary(cleaner_full_redd_survey_data$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.400   0.500   0.549   0.620  50.000   24413

``` r
distinct(cleaner_full_redd_survey_data, pot_depth_m)
```

    ## # A tibble: 102 x 1
    ##    pot_depth_m
    ##          <dbl>
    ##  1       NA   
    ##  2        0.9 
    ##  3        0.76
    ##  4        0.7 
    ##  5        0.52
    ##  6        0.66
    ##  7        0.6 
    ##  8        0.8 
    ##  9        0.42
    ## 10        0.72
    ## # ... with 92 more rows

``` r
cleaner_full_redd_survey_data %>% 
  count(pot_depth_m)
```

    ## # A tibble: 102 x 2
    ##    pot_depth_m     n
    ##          <dbl> <int>
    ##  1        0        1
    ##  2        0.1      1
    ##  3        0.13     1
    ##  4        0.15     4
    ##  5        0.16     2
    ##  6        0.17     2
    ##  7        0.18     3
    ##  8        0.19     3
    ##  9        0.2     20
    ## 10        0.21     8
    ## # ... with 92 more rows

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values** \* 86.3 % of values in the `pot_depth_m`
column are NA.

### Variable: velocity\_m/s

``` r
# cleaner_full_redd_survey_data %>% 
#   ggplot(aes(x = date, y = pot_depth_m)) + 
#   geom_col() + 
#   facet_wrap(~year(date), scales = "free") + 
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
#   theme_minimal() + 
#   theme(text = element_text(size = 8)) + 
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
# summary(cleaner_full_redd_survey_data$pot_depth_m
# )
```

``` r
# cleaner_full_redd_survey_data %>% 
#   count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA.  -->

### Variable: percent\_fine\_substrate

``` r
# cleaner_full_redd_survey_data %>% 
#   ggplot(aes(x = date, y = pot_depth_m)) + 
#   geom_col() + 
#   facet_wrap(~year(date), scales = "free") + 
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
#   theme_minimal() + 
#   theme(text = element_text(size = 8)) + 
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
# summary(cleaner_full_redd_survey_data$pot_depth_m)
```

``` r
# cleaner_full_redd_survey_data %>% 
#   count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA.  -->

### Variable: percent\_small\_substrate

``` r
# cleaner_full_redd_survey_data %>% 
#   ggplot(aes(x = date, y = pot_depth_m)) + 
#   geom_col() + 
#   facet_wrap(~year(date), scales = "free") + 
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
#   theme_minimal() + 
#   theme(text = element_text(size = 8)) + 
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
# summary(cleaner_full_redd_survey_data$pot_depth_m)
```

``` r
# cleaner_full_redd_survey_data %>% 
  # count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA.  -->

### Variable: percent\_medium\_substrate

``` r
# cleaner_full_redd_survey_data %>% 
#   ggplot(aes(x = date, y = pot_depth_m)) + 
#   geom_col() + 
#   facet_wrap(~year(date), scales = "free") + 
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
#   theme_minimal() + 
#   theme(text = element_text(size = 8)) + 
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
# summary(cleaner_full_redd_survey_data$pot_depth_m)
```

``` r
# cleaner_full_redd_survey_data %>% 
#   count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA.  -->

### Variable: percent\_large\_substrate

``` r
# cleaner_full_redd_survey_data %>% 
#   ggplot(aes(x = date, y = pot_depth_m)) + 
#   geom_col() + 
#   facet_wrap(~year(date), scales = "free") + 
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
#   theme_minimal() + 
#   theme(text = element_text(size = 8)) + 
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>% 
#   ggplot(aes(x = year, y = (daily_salmon_count)))+ 
#   geom_boxplot() + 
#   theme_minimal() +
#   theme(text = element_text(size = 12)) 
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
# summary(cleaner_full_redd_survey_data$pot_depth_m)
```

``` r
# cleaner_full_redd_survey_data %>% 
#   count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA.  -->

### Variable: percent\_boulder

``` r
# cleaner_full_redd_survey_data %>%
#   ggplot(aes(x = date, y = pot_depth_m)) +
#   geom_col() +
#   facet_wrap(~year(date), scales = "free") +
#   scale_x_date(labels = date_format("%b"), date_breaks = "1 month") +
#   theme_minimal() +
#   theme(text = element_text(size = 8)) +
#   theme(axis.text.x = element_text(angle = 90))
```

``` r
# # Boxplots of mean depth by location
# cleaner_full_redd_survey_data  %>%
#   group_by(date) %>%
#   summarise(pot_depth_by_location = mean(pot_depth_m)) %>%
#   mutate(year = as.factor(year(date))) %>%
#   ggplot(aes(x = year, y = (daily_salmon_count)))+
#   geom_boxplot() +
#   theme_minimal() +
#   theme(text = element_text(size = 12))
```

**Numeric Summary of velocity\_m/s over Period of Record**

``` r
summary(cleaner_full_redd_survey_data$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.400   0.500   0.549   0.620  50.000   24413

``` r
# cleaner_full_redd_survey_data %>%
#   count(pot_depth_m)
```

TODO: group by location

``` r
# cleaner_full_redd_survey_data %>%
#   group_by(date) %>%
#   summarise(count = sum(salmon_counted, na.rm = T)) %>%
#   pull(count) %>%
#   summary()
```

**NA and Unknown Values**
<!-- * 86.3 % of values in the `pot_depth_m` column are NA. -->

### Variable: redd\_width\_m

### Variable: redd\_length\_m
