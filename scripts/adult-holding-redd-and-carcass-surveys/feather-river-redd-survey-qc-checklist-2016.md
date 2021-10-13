feather-river-redd-survey-qc-checklist-2016
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2016

**Completeness of Record throughout timeframe: **  

-   Longitude and latitude data are not available for 2009, 2010, 2011,
    2012, 2019, 2020. NA values will be filled in for these data sets in
    final cleaned data set.

**Sampling Location:** Feather River

**Data Contact:** [Chris Cook](Chris.Cook@water.ca.gov)

Additional Info:  
1. Latitude and longitude are in NAD 1983 UTM Zone 10N  
2. The substrate is observed visually and an estimate of the percentage
of 5 size classes:  
\* fines &lt;1cm  
\* small 1-5cm  
\* medium 6-15cm  
\* large 16-30cm  
\* boulder &gt;30cm

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
gcs_list_objects()
# git data and save as xlsx
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2016_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2016 = readxl::read_excel("2016_Chinook_Redd_Survey_Data_raw.xlsx")
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

## Data Transformation

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
cleaner_data_2016 <- cleaner_data_2016 %>% 
  set_names(tolower(colnames(cleaner_data_2016))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 1,570
    ## Columns: 16
    ## $ date                     <date> 2016-09-20, 2016-09-20, 2016-09-20, 2016-09-~
    ## $ location                 <chr> "Cottonwood", "Cottonwood", "Cottonwood", "Co~
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

## Explore Categorical Variables

``` r
cleaner_data_2016 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2016$location)
```

    ## 
    ##            Cottonwood       Hatchery Riffle      Lower Auditorium 
    ##                    56                   149                   701 
    ##     Middle Auditorium           Moe's Ditch     Top of Auditorium 
    ##                   105                    65                   156 
    ##      Upper Auditorium      Upper Cottonwood Upper Hatchery Riffle 
    ##                    89                    80                   169

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2016 <- cleaner_data_2016 %>% 
  mutate(location = tolower(location),
        location = if_else(location == "middle auditorium", "mid auditorium", location) )
table(cleaner_data_2016$location)
```

    ## 
    ##            cottonwood       hatchery riffle      lower auditorium 
    ##                    56                   149                   701 
    ##        mid auditorium           moe's ditch     top of auditorium 
    ##                   105                    65                   156 
    ##      upper auditorium      upper cottonwood upper hatchery riffle 
    ##                    89                    80                   169

-   0 % of values in the `location` column are NA.

## Variable:`Type`

Description:  
Area - polygon mapped with Trimble GPS unit Point - points mapped with
Trimble GPS unit Questionable redds - polygon mapped with Trimble GPS
unit where the substrate was disturbed but did not have the proper
characteristics to be called a redd - it was no longer recorded after
2016

``` r
table(cleaner_data_2016$type)
```

    ## 
    ##    p 
    ## 1570

``` r
cleaner_data_2016 <- cleaner_data_2016 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2016$type)
```

    ## 
    ## Point 
    ##  1570

## Expore Numeric Variables

``` r
cleaner_data_2016 %>% 
  select_if(is.numeric) %>% colnames()
```

    ##  [1] "salmon_counted"           "latitude"                
    ##  [3] "longitude"                "depth_m"                 
    ##  [5] "pot_depth_m"              "velocity_m/s"            
    ##  [7] "percent_fine_substrate"   "percent_small_substrate" 
    ##  [9] "percent_medium_substrate" "percent_large_substrate" 
    ## [11] "percent_boulder"          "redd_width_m"            
    ## [13] "redd_length_m"

### Variable:`salmon_counted`

#### Plotting salmon counted in 2016 

``` r
cleaner_data_2016 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Counted in 2016")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Daily Summary of salmon\_counted Over 2016**

``` r
cleaner_data_2016 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   14.00   24.00   35.50   53.83   77.50  137.00

``` r
cleaner_data_2016  %>%
  ggplot(aes(y = location, x = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 10))+
  scale_y_discrete()+
  theme(axis.text.y = element_text(size = 8,vjust = 0.1, hjust=0.2))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric summary of salmon\_counted by location in 2016**

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_counted, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    44.0    53.0    67.0   107.7   101.0   402.0

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2016 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data_2016 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2016$redd_width_m, na.rm = TRUE), max(cleaner_data_2016$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2016**

``` r
summary(cleaner_data_2016$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.500   1.000   1.200   1.252   1.500   3.000    1461

**NA and Unknown Values** \* 93.1 % of values in the `redd_width_m`
column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2016 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data_2016 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2016$redd_length_m, na.rm = TRUE), max(cleaner_data_2016$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2016**

``` r
summary(cleaner_data_2016$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.900   1.500   2.000   2.004   2.500   5.000    1461

**NA and Unknown Values** \* 93.1 % of values in the `redd_length_m`
column are NA.

### Location Physical Attributes

### Variable: `longitude and latitude`

``` r
# TODO: Mutate coordinate in the dataframe 
utm_coords <- na.omit(subset(cleaner_data_2016, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                  min        max
    ## longitude -121.56115 -121.55365
    ## latitude    39.51501   39.51689
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 1570

**NA and Unknown Values** \* 0 % of values in the `longitude` column are
NA.  
\* 0 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2016**

``` r
summary(cleaner_data_2016$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   5.000   5.000   8.304  10.000  50.000    1399

**NA and Unknown Values** \* 89.1 % of values in the
`percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2016**

``` r
summary(cleaner_data_2016$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   15.00   25.00   25.56   30.00   60.00    1399

**NA and Unknown Values** \* 89.1 % of values in the
`percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2016**

``` r
summary(cleaner_data_2016$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00   40.00   50.00   46.96   60.00   80.00    1399

**NA and Unknown Values** \* 89.1 % of values in the
`percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2016**

``` r
summary(cleaner_data_2016$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   10.00   16.61   20.00   70.00    1399

**NA and Unknown Values** \* 89.1 % of values in the
`percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2016 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2016**

``` r
summary(cleaner_data_2016$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   10.00   16.61   20.00   70.00    1399

**NA and Unknown Values** NA and Unknown Values\*\* \* 89.1 % of values
in the `percent_large_substrate` column are NA.

### Variable: `depth_m`

``` r
cleaner_data_2016 %>% 
  group_by(location) %>% 
  summarise(mean_depth_m = mean(depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2016**

``` r
summary(cleaner_data_2016$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1600  0.3400  0.4600  0.4743  0.6000  1.0800    1400

**NA and Unknown Values** NA and Unknown Values\*\* \* 89.2 % of values
in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2016 %>% 
  group_by(location) %>% 
  summarise(mean_pot_depth_m = mean(pot_depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_pot_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Pot Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2016**

``` r
summary(cleaner_data_2016$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1900  0.4200  0.5400  0.5396  0.6400  1.0000    1400

**NA and Unknown Values** NA and Unknown Values\*\* \* 89.2 % of values
in the `pot_depth_m` column are NA.

### Variable: `velocity_m/s`

``` r
cleaner_data_2016 %>% 
  group_by(location) %>% 
  summarise(`mean_velocity_m/s` = mean(`velocity_m/s`, na.rm = TRUE)) %>%
  ggplot(aes(x = `mean_velocity_m/s`, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Velocity By Location")
```

![](feather-river-redd-survey-qc-checklist-2016_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

**Numeric Summary of velocity\_m/s Over 2016**

``` r
summary(cleaner_data_2016$`velocity_m/s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0200  0.2900  0.4200  0.4500  0.5875  1.3200    1400

**NA and Unknown Values** NA and Unknown Values\*\* \* 89.2 % of values
in the `velocity_m/s` column are NA.

``` r
feather_redd_survey_2016 <- cleaner_data_2016 %>% glimpse()
```

    ## Rows: 1,570
    ## Columns: 16
    ## $ date                     <date> 2016-09-20, 2016-09-20, 2016-09-20, 2016-09-~
    ## $ location                 <chr> "cottonwood", "cottonwood", "cottonwood", "co~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
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

### Add cleaned data back onto google cloud

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2016,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/2016_Chinook_Redd_Survey_Data.csv")
```

    ## i 2021-10-13 09:34:08 > File size detected as  137 Kb

    ## i 2021-10-13 09:34:09 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-13 09:34:09 > File size detected as  137 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/2016_Chinook_Redd_Survey_Data.csv 
    ## Type:                csv 
    ## Size:                137 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2016_Chinook_Redd_Survey_Data.csv?generation=1634142850037708&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2016_Chinook_Redd_Survey_Data.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2016_Chinook_Redd_Survey_Data.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/2016_Chinook_Redd_Survey_Data.csv/1634142850037708 
    ## MD5 Hash:            uuLtO2H8iRqCg3SROvWEkQ== 
    ## Class:               STANDARD 
    ## Created:             2021-10-13 16:34:10 
    ## Updated:             2021-10-13 16:34:10 
    ## Generation:          1634142850037708 
    ## Meta Generation:     1 
    ## eTag:                CMzv2sDox/MCEAE= 
    ## crc32c:              Uom9mw==
