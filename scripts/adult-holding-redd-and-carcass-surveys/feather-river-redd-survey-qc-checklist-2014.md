feather-river-redd-survey-qc-checklist-2014
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2014

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2014_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2014 = readxl::read_excel("2014_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2014)
```

    ## Rows: 1,911
    ## Columns: 19
    ## $ Date              <chr> "41891", "41891", "41897", "41897", "41897", "41897"~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "2-1", "2-1", "2-1", "2-1", "2-1", "2-~
    ## $ Location          <chr> "Moe's Side Channel", "Upper Cottonwood", "Cottonwoo~
    ## $ `File #`          <dbl> 1, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 1, 1, 1, 0, 3, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1~
    ## $ Latitude          <dbl> 4375043, 4375121, 4375108, 4375106, 4375110, 4375113~
    ## $ Longitude         <dbl> 6239424.4, 624284.0, 624147.7, 624150.0, 624158.1, 6~
    ## $ `Depth (m)`       <dbl> 0.30, 0.62, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.72~
    ## $ `Pot Depth (m)`   <dbl> 0.50, 0.70, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.76~
    ## $ `Velocity (m/s)`  <dbl> 0.61, 0.89, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.55~
    ## $ `% fines`         <dbl> 40, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, 0, 0, ~
    ## $ `% small`         <dbl> 20, 65, NA, NA, NA, NA, NA, NA, NA, NA, NA, 40, 40, ~
    ## $ `% med`           <dbl> 35, 30, NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, 60, ~
    ## $ `% large`         <dbl> 5, 5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, 0, 10,~
    ## $ `% boulder`       <dbl> 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, 0, 10, ~
    ## $ `redd width (m)`  <dbl> 1.1, 2.5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 1.5, 2~
    ## $ `redd length (m)` <dbl> 2.0, 3.5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2.0, 2~

## Data Transformation

``` r
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
  filter(salmon_counted > 0, rm.na = TRUE) %>% 
  glimpse()
```

    ## Rows: 771
    ## Columns: 16
    ## $ Date                     <date> 2014-09-09, 2014-09-09, 2014-09-15, 2014-09-~
    ## $ Location                 <chr> "Moe's Side Channel", "Upper Cottonwood", "Co~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 2, 3, 2, 1, 2, ~
    ## $ latitude                 <dbl> 4375043, 4375121, 4375108, 4375110, 4375105, ~
    ## $ longitude                <dbl> 6239424.4, 624284.0, 624147.7, 624158.1, 6242~
    ## $ depth_m                  <dbl> 0.30, 0.62, NA, NA, 0.72, 0.55, 0.32, 0.62, 0~
    ## $ pot_depth_m              <dbl> 0.50, 0.70, NA, NA, 0.76, 0.62, 0.40, 0.68, 0~
    ## $ `velocity_m/s`           <dbl> 0.61, 0.89, NA, NA, 0.55, 0.77, 0.28, 0.74, 0~
    ## $ percent_fine_substrate   <dbl> 40, 0, NA, NA, 0, 10, 20, 20, 10, 10, NA, 0, ~
    ## $ percent_small_substrate  <dbl> 20, 65, NA, NA, 40, 20, 50, 20, 30, 30, NA, 2~
    ## $ percent_medium_substrate <dbl> 35, 30, NA, NA, 50, 40, 50, 20, 40, 50, NA, 5~
    ## $ percent_large_substrate  <dbl> 5, 5, NA, NA, 10, 30, 0, 10, 20, 10, NA, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, NA, NA, 0, 0, 0, 30, 0, 0, NA, 0, 0, 0,~
    ## $ redd_width_m             <dbl> 1.10, 2.50, NA, NA, 1.50, 1.00, 1.00, 1.60, 2~
    ## $ redd_length_m            <dbl> 2.00, 3.50, NA, NA, 2.00, 1.50, 1.90, 1.80, 1~

``` r
cleaner_data_2014 <- cleaner_data_2014 %>% 
  set_names(tolower(colnames(cleaner_data_2014))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 771
    ## Columns: 16
    ## $ date                     <date> 2014-09-09, 2014-09-09, 2014-09-15, 2014-09-~
    ## $ location                 <chr> "Moe's Side Channel", "Upper Cottonwood", "Co~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 2, 3, 2, 1, 2, ~
    ## $ latitude                 <dbl> 4375043, 4375121, 4375108, 4375110, 4375105, ~
    ## $ longitude                <dbl> 6239424.4, 624284.0, 624147.7, 624158.1, 6242~
    ## $ depth_m                  <dbl> 0.30, 0.62, NA, NA, 0.72, 0.55, 0.32, 0.62, 0~
    ## $ pot_depth_m              <dbl> 0.50, 0.70, NA, NA, 0.76, 0.62, 0.40, 0.68, 0~
    ## $ `velocity_m/s`           <dbl> 0.61, 0.89, NA, NA, 0.55, 0.77, 0.28, 0.74, 0~
    ## $ percent_fine_substrate   <dbl> 40, 0, NA, NA, 0, 10, 20, 20, 10, 10, NA, 0, ~
    ## $ percent_small_substrate  <dbl> 20, 65, NA, NA, 40, 20, 50, 20, 30, 30, NA, 2~
    ## $ percent_medium_substrate <dbl> 35, 30, NA, NA, 50, 40, 50, 20, 40, 50, NA, 5~
    ## $ percent_large_substrate  <dbl> 5, 5, NA, NA, 10, 30, 0, 10, 20, 10, NA, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, NA, NA, 0, 0, 0, 30, 0, 0, NA, 0, 0, 0,~
    ## $ redd_width_m             <dbl> 1.10, 2.50, NA, NA, 1.50, 1.00, 1.00, 1.60, 2~
    ## $ redd_length_m            <dbl> 2.00, 3.50, NA, NA, 2.00, 1.50, 1.90, 1.80, 1~

## Explore Categorical Variables

``` r
cleaner_data_2014 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2014$location)
```

    ## 
    ##               Big Bar         Big Hole East            Big Riffle 
    ##                     2                     2                     3 
    ##            Cottonwood       G95 East Bottom       Hatchery Riffle 
    ##                    39                     2                   127 
    ##               Keister      Lower Auditorium       Lower McFarland 
    ##                     3                   222                     2 
    ##        Mid Auditorium              Mid Hour    Moe's Side Channel 
    ##                    32                     6                    68 
    ##     Top of Auditorium      Upper Auditorium      Upper Cottonwood 
    ##                   101                    49                    39 
    ## Upper Hatchery Riffle            Upper Hour            Vance East 
    ##                    71                     1                     2

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2014 <- cleaner_data_2014 %>% 
  mutate(location = tolower(location),
         location = if_else(location == "g95 east bottom", "g95 east side channel bottom", location)
         )
table(cleaner_data_2014$location)
```

    ## 
    ##                      big bar                big hole east 
    ##                            2                            2 
    ##                   big riffle                   cottonwood 
    ##                            3                           39 
    ## g95 east side channel bottom              hatchery riffle 
    ##                            2                          127 
    ##                      keister             lower auditorium 
    ##                            3                          222 
    ##              lower mcfarland               mid auditorium 
    ##                            2                           32 
    ##                     mid hour           moe's side channel 
    ##                            6                           68 
    ##            top of auditorium             upper auditorium 
    ##                          101                           49 
    ##             upper cottonwood        upper hatchery riffle 
    ##                           39                           71 
    ##                   upper hour                   vance east 
    ##                            1                            2

-   0 % of values in the `location` column are NA.

## Variable:`Type`

Description:  
Area - polygon mapped with Trimble GPS unit Point - points mapped with
Trimble GPS unit Questionable redds - polygon mapped with Trimble GPS
unit where the substrate was disturbed but did not have the proper
characteristics to be called a redd - it was no longer recorded after
2014

``` r
table(cleaner_data_2014$type)
```

    ## 
    ##   a   p 
    ##   6 765

``` r
cleaner_data_2014 <- cleaner_data_2014 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type),
         type = if_else(type == 'q', 'Questionable Redds', type))
table(cleaner_data_2014$type)
```

    ## 
    ##  Area Point 
    ##     6   765

## Expore Numeric Variables

``` r
cleaner_data_2014 %>% 
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

#### Plotting salmon counted in 2014

``` r
cleaner_data_2014 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Counted in 2014")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->
**Numeric Daily Summary of salmon\_counted Over 2014**

``` r
cleaner_data_2014 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.00   30.00   52.50   66.91   87.00  224.00

``` r
cleaner_data_2014  %>%
  ggplot(aes(y = location, x = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 10))+
  scale_y_discrete()+
  theme(axis.text.y = element_text(size = 8,vjust = 0.1, hjust=0.2))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->
**Numeric summary of salmon\_counted by location in 2014**

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_counted, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    4.00   30.50   81.78  101.00  399.00

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2014 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data_2014 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2014$redd_width_m, na.rm = TRUE), max(cleaner_data_2014$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2014**

``` r
summary(cleaner_data_2014$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.400   1.000   1.200   1.286   1.500   3.000     646

**NA and Unknown Values** \* 83.8 % of values in the `redd_width_m`
column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2014 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data_2014 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2014$redd_length_m, na.rm = TRUE), max(cleaner_data_2014$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2014**

``` r
summary(cleaner_data_2014$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.800   1.600   2.200   2.266   2.800   5.000     646

**NA and Unknown Values** \* 83.8 % of values in the `redd_length_m`
column are NA.

### Location Physical Attributes

### Variable: `longitude and latitude`

``` r
# TODO: Mutate coordinate in the dataframe 
utm_coords <- na.omit(subset(cleaner_data_2014, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                   min       max
    ## longitude -121.880687 -69.98774
    ## latitude     3.954053  39.51689
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 764

**NA and Unknown Values** \* 0.9 % of values in the `longitude` column
are NA.  
\* 0.9 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2014**

``` r
summary(cleaner_data_2014$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   7.366  10.000  90.000     640

**NA and Unknown Values** \* 83 % of values in the
`percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2014**

``` r
summary(cleaner_data_2014$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     0.0    20.0    30.0    31.3    40.0    90.0     640

**NA and Unknown Values** \* 83 % of values in the
`percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2014**

``` r
summary(cleaner_data_2014$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     5.0    30.0    40.0    39.5    50.0    70.0     640

**NA and Unknown Values** \* 83 % of values in the
`percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2014**

``` r
summary(cleaner_data_2014$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   15.00   19.31   30.00   60.00     640

**NA and Unknown Values** \* 83 % of values in the
`percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2014 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2014**

``` r
summary(cleaner_data_2014$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   2.939   0.000  55.000     640

**NA and Unknown Values** NA and Unknown Values\*\* \* 83 % of values in
the `percent_large_substrate` column are NA.

### Variable: `depth_m`

``` r
cleaner_data_2014 %>% 
  group_by(location) %>% 
  summarise(mean_depth_m = mean(depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2014**

``` r
summary(cleaner_data_2014$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1000  0.3250  0.4600  0.4744  0.5900  1.3000     640

**NA and Unknown Values** NA and Unknown Values\*\* \* 83 % of values in
the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2014 %>% 
  group_by(location) %>% 
  summarise(mean_pot_depth_m = mean(pot_depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_pot_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Pot Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->
**Numeric Summary of pot\_depth\_m Over 2014**

``` r
summary(cleaner_data_2014$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.2600  0.4600  0.5500  0.5644  0.6800  1.2000     640

**NA and Unknown Values** NA and Unknown Values\*\* \* 83 % of values in
the `pot_depth_m` column are NA.

### Variable: `velocity_m/s`

``` r
cleaner_data_2014 %>% 
  group_by(location) %>% 
  summarise(`mean_velocity_m/s` = mean(`velocity_m/s`, na.rm = TRUE)) %>%
  ggplot(aes(x = `mean_velocity_m/s`, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Velocity By Location")
```

![](feather-river-redd-survey-qc-checklist-2014_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->
**Numeric Summary of velocity\_m/s Over 2014**

``` r
summary(cleaner_data_2014$`velocity_m/s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0900  0.4500  0.5600  0.6118  0.7400  1.9800     646

**NA and Unknown Values** NA and Unknown Values\*\* \* 83.8 % of values
in the `velocity_m/s` column are NA.

``` r
feather_redd_survey_2014 <- cleaner_data_2014 %>% glimpse()
```

    ## Rows: 771
    ## Columns: 16
    ## $ date                     <date> 2014-09-09, 2014-09-09, 2014-09-15, 2014-09-~
    ## $ location                 <chr> "moe's side channel", "upper cottonwood", "co~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 2, 3, 2, 1, 2, ~
    ## $ latitude                 <dbl> 4375043, 4375121, 4375108, 4375110, 4375105, ~
    ## $ longitude                <dbl> 6239424.4, 624284.0, 624147.7, 624158.1, 6242~
    ## $ depth_m                  <dbl> 0.30, 0.62, NA, NA, 0.72, 0.55, 0.32, 0.62, 0~
    ## $ pot_depth_m              <dbl> 0.50, 0.70, NA, NA, 0.76, 0.62, 0.40, 0.68, 0~
    ## $ `velocity_m/s`           <dbl> 0.61, 0.89, NA, NA, 0.55, 0.77, 0.28, 0.74, 0~
    ## $ percent_fine_substrate   <dbl> 40, 0, NA, NA, 0, 10, 20, 20, 10, 10, NA, 0, ~
    ## $ percent_small_substrate  <dbl> 20, 65, NA, NA, 40, 20, 50, 20, 30, 30, NA, 2~
    ## $ percent_medium_substrate <dbl> 35, 30, NA, NA, 50, 40, 50, 20, 40, 50, NA, 5~
    ## $ percent_large_substrate  <dbl> 5, 5, NA, NA, 10, 30, 0, 10, 20, 10, NA, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, NA, NA, 0, 0, 0, 30, 0, 0, NA, 0, 0, 0,~
    ## $ redd_width_m             <dbl> 1.10, 2.50, NA, NA, 1.50, 1.00, 1.00, 1.60, 2~
    ## $ redd_length_m            <dbl> 2.00, 3.50, NA, NA, 2.00, 1.50, 1.90, 1.80, 1~

### Add cleaned data back onto google cloud

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2014,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/2014_Chinook_Redd_Survey_Data.csv")
```

    ## i 2021-10-13 09:44:03 > File size detected as  67.2 Kb

    ## i 2021-10-13 09:44:04 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-13 09:44:04 > File size detected as  67.2 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/2014_Chinook_Redd_Survey_Data.csv 
    ## Type:                csv 
    ## Size:                67.2 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2014_Chinook_Redd_Survey_Data.csv?generation=1634143444311943&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2014_Chinook_Redd_Survey_Data.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2014_Chinook_Redd_Survey_Data.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/2014_Chinook_Redd_Survey_Data.csv/1634143444311943 
    ## MD5 Hash:            uBfgUrQo/7JU+5kxzhmC+Q== 
    ## Class:               STANDARD 
    ## Created:             2021-10-13 16:44:04 
    ## Updated:             2021-10-13 16:44:04 
    ## Generation:          1634143444311943 
    ## Meta Generation:     1 
    ## eTag:                CIe/itzqx/MCEAE= 
    ## crc32c:              LPnysA==
