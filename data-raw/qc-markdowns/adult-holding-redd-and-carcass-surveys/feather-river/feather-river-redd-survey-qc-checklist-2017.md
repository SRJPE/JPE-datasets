feather-river-redd-survey-qc-checklist-2017
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2017

**Completeness of Record throughout timeframe:**

-   Longitude and latitude data are not available for 2009, 2010, 2011,
    2012, 2019, 2020. NA values will be filled in for these data sets in
    final cleaned data set.

**Sampling Location:** Various sampling locations on Feather River.

**Data Contact:** [Chris Cook](mailto::Chris.Cook@water.ca.gov)

Additional Info:  
1. Latitude and longitude are in NAD 1983 UTM Zone 10N  
2. The substrate is observed visually and an estimate of the percentage
of 5 size classes:

-   fines &lt;1cm  
-   small 1-5cm  
-   medium 6-15cm  
-   large 16-30cm  
-   boulder &gt;30cm

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2017_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2017 = readxl::read_excel("2017_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2017)
```

    ## Rows: 2,717
    ## Columns: 19
    ## $ Date              <dttm> 2017-10-03, 2017-10-03, 2017-10-03, 2017-10-03, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Hatchery", "Hatchery", "Top of Auditorium", "Top of~
    ## $ `File #`          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1, 2, 3, ~
    ## $ Type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# redds`         <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 3~
    ## $ `Latitude mN`     <dbl> 4375041, 4375035, 4375077, 4375074, 4375069, 4375043~
    ## $ `Longitude mE`    <dbl> 624281.7, 624285.5, 624062.3, 624060.5, 624069.0, 62~
    ## $ `Depth (m)`       <dbl> 0.32, 0.50, 0.48, 0.34, 0.52, 0.48, 0.70, 0.64, 0.28~
    ## $ `Pot Depth (m)`   <dbl> 0.48, 0.42, 0.56, 0.40, 0.66, 0.62, 0.80, 0.58, 0.40~
    ## $ `Velocity (m/s)`  <dbl> 0.64, 0.55, 0.45, 0.57, 0.95, 0.30, 0.42, 0.42, 0.44~
    ## $ `% fines`         <dbl> 0, 0, 5, 5, 0, 5, 0, 0, 10, 10, 10, 10, 5, 0, 0, 0, ~
    ## $ `% small`         <dbl> 5, 5, 30, 30, 30, 30, 50, 60, 20, 20, 30, 30, 20, 40~
    ## $ `% med`           <dbl> 65, 65, 50, 50, 70, 50, 50, 40, 40, 40, 30, 30, 40, ~
    ## $ `% large`         <dbl> 30, 30, 15, 15, 0, 15, 0, 0, 30, 30, 30, 30, 35, 0, ~
    ## $ `% boulder`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `redd width (m)`  <dbl> 2.2, 2.2, 1.2, 1.0, 1.2, 1.4, 1.9, 1.4, 1.8, 1.2, 1.~
    ## $ `redd length (m)` <dbl> 3.6, 2.9, 2.7, 1.3, 3.2, 2.8, 3.2, 2.3, 4.0, 3.2, 2.~

## Data Transformation

``` r
cleaner_data_2017 <- raw_data_2017 %>% 
  select(-c('Survey Wk', 'File #')) %>% 
  rename('redd_count' = "# redds",
         'salmon_count'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m_per_s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>%
  mutate(Date = as.Date(Date))
cleaner_data_2017 <- cleaner_data_2017 %>% 
  set_names(tolower(colnames(cleaner_data_2017))) %>% 
  glimpse()
```

    ## Rows: 2,717
    ## Columns: 17
    ## $ date                     <date> 2017-10-03, 2017-10-03, 2017-10-03, 2017-10-~
    ## $ location                 <chr> "Hatchery", "Hatchery", "Top of Auditorium", ~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4375041, 4375035, 4375077, 4375074, 4375069, ~
    ## $ longitude                <dbl> 624281.7, 624285.5, 624062.3, 624060.5, 62406~
    ## $ depth_m                  <dbl> 0.32, 0.50, 0.48, 0.34, 0.52, 0.48, 0.70, 0.6~
    ## $ pot_depth_m              <dbl> 0.48, 0.42, 0.56, 0.40, 0.66, 0.62, 0.80, 0.5~
    ## $ velocity_m_per_s         <dbl> 0.64, 0.55, 0.45, 0.57, 0.95, 0.30, 0.42, 0.4~
    ## $ percent_fine_substrate   <dbl> 0, 0, 5, 5, 0, 5, 0, 0, 10, 10, 10, 10, 5, 0,~
    ## $ percent_small_substrate  <dbl> 5, 5, 30, 30, 30, 30, 50, 60, 20, 20, 30, 30,~
    ## $ percent_medium_substrate <dbl> 65, 65, 50, 50, 70, 50, 50, 40, 40, 40, 30, 3~
    ## $ percent_large_substrate  <dbl> 30, 30, 15, 15, 0, 15, 0, 0, 30, 30, 30, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 2.2, 2.2, 1.2, 1.0, 1.2, 1.4, 1.9, 1.4, 1.8, ~
    ## $ redd_length_m            <dbl> 3.6, 2.9, 2.7, 1.3, 3.2, 2.8, 3.2, 2.3, 4.0, ~

## Explore `date`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Numeric Summary of `date` in 2017

``` r
summary(cleaner_data_2017$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2017-10-03" "2017-10-31" "2017-11-07" "2017-11-07" "2017-11-15" "2017-12-14"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data_2017 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2017$location)
```

    ## 
    ##                         Aleck                       Big Bar 
    ##                             6                             1 
    ##                 Big Hole East                    Big Riffle 
    ##                             6                             4 
    ##                    Developing              Eye Side Channel 
    ##                             1                            14 
    ## G-95 East Side Channel Bottom G-95 West Side Channel Bottom 
    ##                             1                             1 
    ##               G95 East Bottom                  G95 East Top 
    ##                             8                             5 
    ##                 Great Western                      Hatchery 
    ##                             1                           300 
    ##         Hatchery Side Channel                       Keister 
    ##                            27                             3 
    ##              Lower Auditorium                    Lower Hour 
    ##                           486                             6 
    ##                Lower Robinson          Lower Table Mountain 
    ##                           149                            16 
    ##              Lower Vance East                       Mathews 
    ##                             4                            68 
    ##             Middle Auditorium            Moe's Side Channel 
    ##                            74                           488 
    ##                  Steep Riffle            Steep Side Channel 
    ##                            25                             1 
    ##                Table Mountain             Top of Auditorium 
    ##                            30                           371 
    ##               Top of Hatchery                  Trailer Park 
    ##                             9                           105 
    ##              Upper Auditorium                Upper Hatchery 
    ##                           204                           120 
    ##                    Upper Hour                 Upper Mathews 
    ##                             1                            15 
    ##                Upper Robinson                    Vance East 
    ##                           152                             9 
    ##                    Vance West                   Weir Riffle 
    ##                             2                             4

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2017 <- cleaner_data_2017 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "Middle Auditorium", "Mid Auditorium", location),
         location = if_else(location == "G-95 East Side Channel Bottom", "G95 East Side Channel Bottom", location),
         location = if_else(location == "G-95 West Side Channel Bottom", "G95 West Side Channel Bottom", location),
         location = if_else(location == "G95 East Bottom", "G95 East Side Channel Bottom", location),
         location = if_else(location == "G95 East Top", "G95 East Side Channel Top", location),
         location = if_else(location == "Middle Auditoium", "Mid Auditorium", location),
         location = if_else(location == "Moe's Side Channel", "Moes Side Channel", location)
         )
table(cleaner_data_2017$location)
```

    ## 
    ##                        Aleck                      Big Bar 
    ##                            6                            1 
    ##                Big Hole East                   Big Riffle 
    ##                            6                            4 
    ##                   Developing             Eye Side Channel 
    ##                            1                           14 
    ## G95 East Side Channel Bottom    G95 East Side Channel Top 
    ##                            9                            5 
    ## G95 West Side Channel Bottom                Great Western 
    ##                            1                            1 
    ##                     Hatchery        Hatchery Side Channel 
    ##                          300                           27 
    ##                      Keister             Lower Auditorium 
    ##                            3                          486 
    ##                   Lower Hour               Lower Robinson 
    ##                            6                          149 
    ##         Lower Table Mountain             Lower Vance East 
    ##                           16                            4 
    ##                      Mathews               Mid Auditorium 
    ##                           68                           74 
    ##            Moes Side Channel                 Steep Riffle 
    ##                          488                           25 
    ##           Steep Side Channel               Table Mountain 
    ##                            1                           30 
    ##            Top Of Auditorium              Top Of Hatchery 
    ##                          371                            9 
    ##                 Trailer Park             Upper Auditorium 
    ##                          105                          204 
    ##               Upper Hatchery                   Upper Hour 
    ##                          120                            1 
    ##                Upper Mathews               Upper Robinson 
    ##                           15                          152 
    ##                   Vance East                   Vance West 
    ##                            9                            2 
    ##                  Weir Riffle 
    ##                            4

**NA and Unknown Values**

-   0 % of values in the `location` column are NA.

## Variable:`type`

Description:

-   Area - polygon mapped with Trimble GPS unit

-   Point - points mapped with Trimble GPS unit

-   Questionable redds - polygon mapped with Trimble GPS unit where the
    substrate was disturbed but did not have the proper characteristics
    to be called a redd - it was no longer recorded after 2011

``` r
table(cleaner_data_2017$type)
```

    ## 
    ##    p 
    ## 2717

``` r
cleaner_data_2017 <- cleaner_data_2017 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2017$type)
```

    ## 
    ## Point 
    ##  2717

## Explore Numeric Variables

``` r
cleaner_data_2017 %>% 
  select_if(is.numeric) %>% colnames()
```

    ##  [1] "redd_count"               "salmon_count"            
    ##  [3] "latitude"                 "longitude"               
    ##  [5] "depth_m"                  "pot_depth_m"             
    ##  [7] "velocity_m_per_s"         "percent_fine_substrate"  
    ##  [9] "percent_small_substrate"  "percent_medium_substrate"
    ## [11] "percent_large_substrate"  "percent_boulder"         
    ## [13] "redd_width_m"             "redd_length_m"

### Variable:`salmon_count`

``` r
cleaner_data_2017 %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Count in 2017")
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->
**Numeric Daily Summary of salmon\_count Over 2017**

``` r
cleaner_data_2017 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    1.00    8.00   28.37   26.00  156.00

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2017$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2017  %>%
  ggplot(aes(x = salmon_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Salmon Count Distribution",
       x = 'Daily Salmon Count')+
  guides(fill = guide_legend(nrow = 13),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Numeric summary of salmon\_count by location in 2017**

``` r
cleaner_data_2017 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    0.00    3.00   33.23   53.50  300.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2017 %>% 
  filter(is.na(date)==FALSE) %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2017")
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
cleaner_data_2017  %>%
  ggplot(aes(x = redd_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Redd Count Distribution",
       x = 'Daily Redd Count')+
  guides(fill = guide_legend(nrow = 13),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2017**

``` r
cleaner_data_2017 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.00   12.00   50.00   66.39  101.00  291.00

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2017 %>%
  filter(redd_width_m < 20) %>% #filtered out 1 large value for more clear view of distribution 
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2017$redd_width_m, na.rm = TRUE), max(cleaner_data_2017$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2017**

``` r
summary(cleaner_data_2017$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.800   1.000   1.103   1.300  20.000    2152

**NA and Unknown Values**

-   79.2 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2017$redd_length_m, na.rm = TRUE), max(cleaner_data_2017$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2017**

``` r
summary(cleaner_data_2017$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   1.700   2.200   2.296   2.900   5.000    2163

**NA and Unknown Values**

-   79.6 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable: `longitude and latitude`

``` r
utm_coords <- na.omit(subset(cleaner_data_2017, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                  min       max
    ## longitude -121.64133 -121.5509
    ## latitude    39.37411   39.5179
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 2717

**NA and Unknown Values**

-   0 % of values in the `longitude` column are NA.

-   0 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2017**

``` r
summary(cleaner_data_2017$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   6.023  10.000  80.000    2153

**NA and Unknown Values**

-   79.2 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2017**

``` r
summary(cleaner_data_2017$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   15.00   25.00   27.27   40.00   80.00    2152

**NA and Unknown Values**

-   79.2 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2017**

``` r
summary(cleaner_data_2017$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   30.00   40.00   42.47   50.00   90.00    2151

**NA and Unknown Values**

-   79.2 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2017**

``` r
summary(cleaner_data_2017$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   15.00   19.33   30.00   80.00    2153

**NA and Unknown Values**

-   79.2 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = percent_boulder, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2017**

``` r
summary(cleaner_data_2017$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   15.00   19.33   30.00   80.00    2153

**NA and Unknown Values**

-   79.4 % of values in the `percent_boulder` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2017 %>% 
  group_by(location) %>% 
  summarise(mean_percent_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE),
            mean_percent_small_substrate = mean(percent_small_substrate, na.rm = TRUE),
            mean_percent_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE),
            mean_percent_large_substrate = mean(percent_large_substrate, na.rm = TRUE),
            mean_percent_boulder = mean(percent_boulder, na.rm = TRUE),
            ) %>% 
  pivot_longer(
    cols = starts_with("mean"),
    names_to = "substrate_type",
    values_to = "percent",
    values_drop_na = TRUE
  ) %>%
  ggplot(aes(fill = substrate_type,
             y = location,
             x = percent))+
  geom_bar(position = 'stack', stat = 'identity', color = 'black')+
  labs(title = "Mean Percent Substrate by Location")
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.15, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

**Numeric Summary of depth\_m Over 2017**

``` r
summary(cleaner_data_2017$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.08    0.30    0.41    0.43    0.52    1.50    2147

**NA and Unknown Values**

-   79 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2017 %>%
  filter(pot_depth_m < 40) %>% # filtered out 2 large values for a more clear view of the distribution
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.2, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2017**

``` r
summary(cleaner_data_2017$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.3800  0.4600  0.6392  0.5800 50.0000    2148

**NA and Unknown Values**

-   79.1 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2017 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.25, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2017_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

**Numeric Summary of velocity\_m\_per\_s Over 2017**

``` r
summary(cleaner_data_2017$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0300  0.3400  0.4600  0.5009  0.6200  1.2700    2329

**NA and Unknown Values**

-   85.7 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2017 <- cleaner_data_2017 %>% glimpse()
```

    ## Rows: 2,717
    ## Columns: 17
    ## $ date                     <date> 2017-10-03, 2017-10-03, 2017-10-03, 2017-10-~
    ## $ location                 <chr> "Hatchery", "Hatchery", "Top Of Auditorium", ~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4375041, 4375035, 4375077, 4375074, 4375069, ~
    ## $ longitude                <dbl> 624281.7, 624285.5, 624062.3, 624060.5, 62406~
    ## $ depth_m                  <dbl> 0.32, 0.50, 0.48, 0.34, 0.52, 0.48, 0.70, 0.6~
    ## $ pot_depth_m              <dbl> 0.48, 0.42, 0.56, 0.40, 0.66, 0.62, 0.80, 0.5~
    ## $ velocity_m_per_s         <dbl> 0.64, 0.55, 0.45, 0.57, 0.95, 0.30, 0.42, 0.4~
    ## $ percent_fine_substrate   <dbl> 0, 0, 5, 5, 0, 5, 0, 0, 10, 10, 10, 10, 5, 0,~
    ## $ percent_small_substrate  <dbl> 5, 5, 30, 30, 30, 30, 50, 60, 20, 20, 30, 30,~
    ## $ percent_medium_substrate <dbl> 65, 65, 50, 50, 70, 50, 50, 40, 40, 40, 30, 3~
    ## $ percent_large_substrate  <dbl> 30, 30, 15, 15, 0, 15, 0, 0, 30, 30, 30, 30, ~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 2.2, 2.2, 1.2, 1.0, 1.2, 1.4, 1.9, 1.4, 1.8, ~
    ## $ redd_length_m            <dbl> 3.6, 2.9, 2.7, 1.3, 3.2, 2.8, 3.2, 2.3, 4.0, ~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2017,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2017.csv")
```

    ## i 2021-10-27 11:18:34 > File size detected as  239.8 Kb

    ## i 2021-10-27 11:18:34 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-27 11:18:35 > File size detected as  239.8 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2017.csv 
    ## Type:                csv 
    ## Size:                239.8 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2017.csv?generation=1635358714585085&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2017.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2017.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2017.csv/1635358714585085 
    ## MD5 Hash:            KXCX1xrlyErmzKjL40vYXw== 
    ## Class:               STANDARD 
    ## Created:             2021-10-27 18:18:34 
    ## Updated:             2021-10-27 18:18:34 
    ## Generation:          1635358714585085 
    ## Meta Generation:     1 
    ## eTag:                CP2/jfqZ6/MCEAE= 
    ## crc32c:              6/UCJA==
