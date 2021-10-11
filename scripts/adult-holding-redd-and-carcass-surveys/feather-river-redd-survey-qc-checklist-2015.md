feather-river-redd-survey-qc-checklist-2015
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2015

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2015_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2015 = readxl::read_excel("2015_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2015)
```

    ## Rows: 2,344
    ## Columns: 19
    ## $ Date              <dttm> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-16, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Lower Auditorium", "Lower Auditorium", "Lower Audit~
    ## $ `File #`          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 3~
    ## $ Latitude          <dbl> 4375000, 4374955, 4374977, 4374978, 4374985, 4374991~
    ## $ Longitude         <dbl> 623703.5, 623760.0, 623766.3, 623766.7, 623762.2, 62~
    ## $ `Depth (m)`       <dbl> 0.40, 0.40, 0.56, 0.56, 0.50, 0.42, 0.37, 0.40, 0.37~
    ## $ `Pot Depth (m)`   <dbl> 0.50, 0.60, 0.60, 0.60, 0.60, 0.55, 0.45, 0.60, 0.45~
    ## $ `Velocity (m/s)`  <dbl> 0.40, 0.59, 0.53, 0.53, 0.55, 0.32, 0.74, 0.60, 0.61~
    ## $ `% fines`         <dbl> 20, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, 0, 20, ~
    ## $ `% small`         <dbl> 40, 30, 30, 30, 30, 20, 40, 30, 30, 20, 30, 10, 20, ~
    ## $ `% med`           <dbl> 40, 40, 30, 30, 30, 50, 50, 60, 50, 50, 60, 60, 40, ~
    ## $ `% large`         <dbl> 0, 30, 40, 40, 40, 30, 0, 0, 10, 20, 0, 30, 30, 30, ~
    ## $ `% boulder`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 20, 0, 0, 0,~
    ## $ `redd width (m)`  <dbl> 1.20, 1.10, 0.75, 0.75, 1.50, 1.60, 1.20, 1.00, 1.70~
    ## $ `redd length (m)` <dbl> 1.75, 1.75, 1.00, 1.00, 1.75, 2.00, 1.75, 1.20, 3.00~

## Data Transformation

``` r
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
  filter(salmon_counted > 0, rm.na = TRUE) %>% 
  glimpse()
```

    ## Rows: 1,021
    ## Columns: 16
    ## $ Date                     <dttm> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-~
    ## $ Location                 <chr> "Middle Auditorium", "Moe's Side Channel", "M~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 5, 3, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, ~
    ## $ latitude                 <dbl> 4374998, 4375038, 4375042, 4375044, 4375042, ~
    ## $ longitude                <dbl> 623851.9, 623923.2, 623924.5, 623930.0, 62394~
    ## $ depth_m                  <dbl> 0.39, 0.25, 0.25, 0.35, 0.32, 0.25, 0.25, 0.6~
    ## $ pot_depth_m              <dbl> 0.42, 0.39, 0.35, 0.42, 0.35, 0.38, 0.40, 0.6~
    ## $ `velocity_m/s`           <dbl> 0.49, 0.50, 0.42, 0.34, 0.50, 0.45, 0.90, 0.5~
    ## $ percent_fine_substrate   <dbl> 10, 0, 10, 20, 10, 0, 10, 0, 0, 0, 0, 0, 20, ~
    ## $ percent_small_substrate  <dbl> 50, 40, 30, 40, 30, 30, 30, 10, 30, 10, 10, 1~
    ## $ percent_medium_substrate <dbl> 30, 60, 60, 30, 50, 60, 60, 50, 40, 50, 40, 4~
    ## $ percent_large_substrate  <dbl> 10, 0, 0, 0, 10, 10, 0, 30, 30, 30, 40, 40, 2~
    ## $ percent_boulder          <dbl> 0, 0, 0, 10, 0, 0, 0, 10, 0, 10, 10, 10, 10, ~
    ## $ redd_width_m             <dbl> 1.75, 1.00, 1.20, 1.20, 1.10, 1.60, 1.00, 1.0~
    ## $ redd_length_m            <dbl> 2.0, 1.7, 1.6, 1.5, 2.0, 2.0, 1.2, 1.5, 1.5, ~

``` r
cleaner_data_2015 <- cleaner_data_2015 %>% 
  set_names(tolower(colnames(cleaner_data_2015))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 1,021
    ## Columns: 16
    ## $ date                     <date> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-~
    ## $ location                 <chr> "Middle Auditorium", "Moe's Side Channel", "M~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ salmon_counted           <dbl> 1, 5, 3, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 2, ~
    ## $ latitude                 <dbl> 4374998, 4375038, 4375042, 4375044, 4375042, ~
    ## $ longitude                <dbl> 623851.9, 623923.2, 623924.5, 623930.0, 62394~
    ## $ depth_m                  <dbl> 0.39, 0.25, 0.25, 0.35, 0.32, 0.25, 0.25, 0.6~
    ## $ pot_depth_m              <dbl> 0.42, 0.39, 0.35, 0.42, 0.35, 0.38, 0.40, 0.6~
    ## $ `velocity_m/s`           <dbl> 0.49, 0.50, 0.42, 0.34, 0.50, 0.45, 0.90, 0.5~
    ## $ percent_fine_substrate   <dbl> 10, 0, 10, 20, 10, 0, 10, 0, 0, 0, 0, 0, 20, ~
    ## $ percent_small_substrate  <dbl> 50, 40, 30, 40, 30, 30, 30, 10, 30, 10, 10, 1~
    ## $ percent_medium_substrate <dbl> 30, 60, 60, 30, 50, 60, 60, 50, 40, 50, 40, 4~
    ## $ percent_large_substrate  <dbl> 10, 0, 0, 0, 10, 10, 0, 30, 30, 30, 40, 40, 2~
    ## $ percent_boulder          <dbl> 0, 0, 0, 10, 0, 0, 0, 10, 0, 10, 10, 10, 10, ~
    ## $ redd_width_m             <dbl> 1.75, 1.00, 1.20, 1.20, 1.10, 1.60, 1.00, 1.0~
    ## $ redd_length_m            <dbl> 2.0, 1.7, 1.6, 1.5, 2.0, 2.0, 1.2, 1.5, 1.5, ~

## Explore Categorical Variables

``` r
cleaner_data_2015 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2015$location)
```

    ## 
    ##                      Big Bar                   Big Riffle 
    ##                            2                            2 
    ##                   Cottonwood       G-95 East Side Channel 
    ##                           37                            1 
    ## G95 East Side Channel Bottom                     G95 Main 
    ##                            1                            1 
    ##                        Goose                     Hatchery 
    ##                            3                          102 
    ##        Hatchery Side Channel                         Hour 
    ##                            5                            7 
    ##                      Keister             Lower Auditorium 
    ##                            1                          283 
    ##            Middle Auditorium           Moe's Side Channel 
    ##                           63                          141 
    ##            Top of Auditorium             Upper Auditorium 
    ##                           82                           61 
    ##             Upper Cottonwood               Upper Hatchery 
    ##                           75                          152 
    ##                   Vance East 
    ##                            2

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2015 <- cleaner_data_2015 %>% 
  mutate(location = tolower(location),
         location = if_else(location == "g-95 east side channel", "g95 east side channel", location),
         location = if_else(location == "middle auditorium", "mid auditorium", location) 
         )
table(cleaner_data_2015$location)
```

    ## 
    ##                      big bar                   big riffle 
    ##                            2                            2 
    ##                   cottonwood        g95 east side channel 
    ##                           37                            1 
    ## g95 east side channel bottom                     g95 main 
    ##                            1                            1 
    ##                        goose                     hatchery 
    ##                            3                          102 
    ##        hatchery side channel                         hour 
    ##                            5                            7 
    ##                      keister             lower auditorium 
    ##                            1                          283 
    ##               mid auditorium           moe's side channel 
    ##                           63                          141 
    ##            top of auditorium             upper auditorium 
    ##                           82                           61 
    ##             upper cottonwood               upper hatchery 
    ##                           75                          152 
    ##                   vance east 
    ##                            2

-   0 % of values in the `location` column are NA.

## Variable:`Type`

Description:  
Area - polygon mapped with Trimble GPS unit Point - points mapped with
Trimble GPS unit Questionable redds - polygon mapped with Trimble GPS
unit where the substrate was disturbed but did not have the proper
characteristics to be called a redd - it was no longer recorded after
2015

``` r
table(cleaner_data_2015$type)
```

    ## 
    ##    p 
    ## 1021

``` r
cleaner_data_2015 <- cleaner_data_2015 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type),
         type = if_else(type == 'q', 'Questionable Redds', type))
table(cleaner_data_2015$type)
```

    ## 
    ## Point 
    ##  1021

## Expore Numeric Variables

``` r
cleaner_data_2015 %>% 
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

#### Plotting salmon counted in 2015 

``` r
cleaner_data_2015 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Counted in 2015")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Daily Summary of salmon\_counted Over 2015**

``` r
cleaner_data_2015 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00   18.50   50.00   48.69   77.00  124.00

``` r
cleaner_data_2015  %>%
  ggplot(aes(y = location, x = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 10))+
  scale_y_discrete()+
  theme(axis.text.y = element_text(size = 8,vjust = 0.1, hjust=0.2))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric summary of salmon\_counted by location in 2015**

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_counted, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    3.00   11.00   89.68  128.50  527.00

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2015 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2015$redd_width_m, na.rm = TRUE), max(cleaner_data_2015$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2015**

``` r
summary(cleaner_data_2015$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.500   1.000   1.200   1.307   1.500   3.800     767

**NA and Unknown Values** \* 75.1 % of values in the `redd_width_m`
column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2015 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2015$redd_length_m, na.rm = TRUE), max(cleaner_data_2015$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2015**

``` r
summary(cleaner_data_2015$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.800   1.500   2.000   2.023   2.400   5.600     767

**NA and Unknown Values** \* 75.1 % of values in the `redd_length_m`
column are NA.

### Location Physical Attributes

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   8.976  15.000  70.000     767

**NA and Unknown Values** \* 75.1 % of values in the
`percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   29.83   40.00   80.00     767

**NA and Unknown Values** \* 75.1 % of values in the
`percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     5.0    30.0    40.0    40.6    50.0    85.0     767

**NA and Unknown Values** \* 75.1 % of values in the
`percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   10.00   10.00   16.44   20.00   80.00     767

**NA and Unknown Values** \* 75.1 % of values in the
`percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2015**

``` r
summary(cleaner_data_2015$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   10.00   10.00   16.44   20.00   80.00     767

**NA and Unknown Values** NA and Unknown Values\*\* \* 75.1 % of values
in the `percent_large_substrate` column are NA.

### Variable: `depth_m`

``` r
cleaner_data_2015 %>% 
  ggplot(aes(x = depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2015**

``` r
summary(cleaner_data_2015$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0800  0.3000  0.4000  0.4176  0.5000  1.3000     767

**NA and Unknown Values** NA and Unknown Values\*\* \* 75.1 % of values
in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2015 %>% 
  ggplot(aes(x = pot_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Pot Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->
**Numeric Summary of pot\_depth\_m Over 2015**

``` r
summary(cleaner_data_2015$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1500  0.3900  0.4750  0.4985  0.5950  1.7000     767

**NA and Unknown Values** NA and Unknown Values\*\* \* 75.1 % of values
in the `pot_depth_m` column are NA.

### Variable: `velocity_m/s`

``` r
cleaner_data_2015 %>% 
  ggplot(aes(x = `velocity_m/s`, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Velocity By Location")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->
**Numeric Summary of velocity\_m/s Over 2015**

``` r
summary(cleaner_data_2015$`velocity_m/s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.050   0.300   0.410   0.452   0.540   1.500     767

**NA and Unknown Values** NA and Unknown Values\*\* \* 75.1 % of values
in the `velocity_m/s` column are NA.
