feather-river-redd-survey-qc-checklist-2020
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2020

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2020_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2020 = readxl::read_excel("2020_Chinook_Redd_Survey_Data_raw.xlsx")
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

## Data Transformation

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
cleaner_data_2020 <- cleaner_data_2020 %>% 
  set_names(tolower(colnames(cleaner_data_2020))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 5,432
    ## Columns: 16
    ## $ date                     <date> 2020-09-22, 2020-09-22, 2020-09-22, 2020-09-~
    ## $ location                 <chr> "Table Mountain", "Table Mountain", "Lower Ta~
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

## Explore Categorical Variables

``` r
cleaner_data_2020 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2020$location)
```

    ## 
    ##                 Aleck Riffle               Bedrock Riffle 
    ##                           27                          262 
    ##          Below Big hole East          Below Big Hole East 
    ##                            1                            7 
    ##       Below Lower Auditorium                Big Hole East 
    ##                          115                           55 
    ##                Big Hole West                   Big Riffle 
    ##                            7                           28 
    ##                   Cottonwood            Developing Riffle 
    ##                          156                            1 
    ##                          Eye             Eye Side Channel 
    ##                           13                           33 
    ##              G95 East Bottom G95 East Side Channel Bottom 
    ##                           11                           34 
    ##    G95 East Side Channel Top                 G95 East Top 
    ##                           27                           22 
    ##                     G95 Main              G95 West Bottom 
    ##                           29                            1 
    ##        G95 West Side Channel         Gateway Main Channel 
    ##                            9                           15 
    ##         Gateway Side Channel                 Goose Riffle 
    ##                            8                            7 
    ##                Great Western                Hatchery Pipe 
    ##                           11                          143 
    ##              Hatchery Riffle                      Keister 
    ##                          345                            6 
    ##             Lower Auditorium                   Lower Hour 
    ##                          694                           64 
    ##              Lower McFarland               Lower Robinson 
    ##                            5                          357 
    ##         Lower Table Mountain             Lower Vance East 
    ##                          153                            6 
    ##                      Mathews            Middle Auditorium 
    ##                           35                          212 
    ##           Moe's Side Channel                  Palm Riffle 
    ##                          292                            1 
    ##                 Steep Riffle           Steep Side Channel 
    ##                           79                           63 
    ##               Table Mountain            Top of Auditorium 
    ##                          195                          468 
    ##                 Trailer Park             Upper Auditorium 
    ##                          439                          328 
    ##             Upper Cottonwood        Upper Hatchery Riffle 
    ##                           15                          215 
    ##                   Upper Hour                Upper Mathews 
    ##                           18                           61 
    ##              Upper McFarland               Upper Robinson 
    ##                            7                          222 
    ##                   Vance East                   Vance West 
    ##                           48                           16 
    ##                  Weir Riffle 
    ##                           66

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2020 <- cleaner_data_2020 %>% 
  mutate(location = tolower(location),
         location = if_else(location == "g95 east top", "g95 east side channel top", location),
         location = if_else(location == "g95 west bottom", "g95 west side channel bottom", location),
         location = if_else(location == "middle auditorium", "mid auditorium", location)
         )
table(cleaner_data_2020$location)
```

    ## 
    ##                 aleck riffle               bedrock riffle 
    ##                           27                          262 
    ##          below big hole east       below lower auditorium 
    ##                            8                          115 
    ##                big hole east                big hole west 
    ##                           55                            7 
    ##                   big riffle                   cottonwood 
    ##                           28                          156 
    ##            developing riffle                          eye 
    ##                            1                           13 
    ##             eye side channel              g95 east bottom 
    ##                           33                           11 
    ## g95 east side channel bottom    g95 east side channel top 
    ##                           34                           49 
    ##                     g95 main        g95 west side channel 
    ##                           29                            9 
    ## g95 west side channel bottom         gateway main channel 
    ##                            1                           15 
    ##         gateway side channel                 goose riffle 
    ##                            8                            7 
    ##                great western                hatchery pipe 
    ##                           11                          143 
    ##              hatchery riffle                      keister 
    ##                          345                            6 
    ##             lower auditorium                   lower hour 
    ##                          694                           64 
    ##              lower mcfarland               lower robinson 
    ##                            5                          357 
    ##         lower table mountain             lower vance east 
    ##                          153                            6 
    ##                      mathews               mid auditorium 
    ##                           35                          212 
    ##           moe's side channel                  palm riffle 
    ##                          292                            1 
    ##                 steep riffle           steep side channel 
    ##                           79                           63 
    ##               table mountain            top of auditorium 
    ##                          195                          468 
    ##                 trailer park             upper auditorium 
    ##                          439                          328 
    ##             upper cottonwood        upper hatchery riffle 
    ##                           15                          215 
    ##                   upper hour                upper mathews 
    ##                           18                           61 
    ##              upper mcfarland               upper robinson 
    ##                            7                          222 
    ##                   vance east                   vance west 
    ##                           48                           16 
    ##                  weir riffle 
    ##                           66

-   0 % of values in the `location` column are NA.

## Variable:`Type`

Description:  
Area - polygon mapped with Trimble GPS unit Point - points mapped with
Trimble GPS unit Questionable redds - polygon mapped with Trimble GPS
unit where the substrate was disturbed but did not have the proper
characteristics to be called a redd - it was no longer recorded after
2020

``` r
table(cleaner_data_2020$type)
```

    ## 
    ##    p 
    ## 5432

``` r
cleaner_data_2020 <- cleaner_data_2020 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2020$type)
```

    ## 
    ## Point 
    ##  5432

## Explore Numeric Variables

``` r
cleaner_data_2020 %>% 
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

#### Plotting salmon counted in 2020 

``` r
cleaner_data_2020 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Counted in 2020")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Daily Summary of salmon\_counted Over 2020**  

``` r
cleaner_data_2020 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   4.750   7.000   7.306   9.000  19.000

``` r
cleaner_data_2020  %>%
  ggplot(aes(y = location, x = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 10))+
  scale_y_discrete()+
  theme(axis.text.y = element_text(size = 8,vjust = 0.1, hjust=0.2))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric summary of salmon\_counted by location in 2020**

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_counted, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   0.000   2.000   5.367   6.000  39.000

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2020 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data_2020 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2020$redd_width_m, na.rm = TRUE), max(cleaner_data_2020$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2020**

``` r
summary(cleaner_data_2020$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.400   1.075   1.300   1.380   1.600   3.700    4816

**NA and Unknown Values** \* 88.7 % of values in the `redd_width_m`
column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2020 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data_2020 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2020$redd_length_m, na.rm = TRUE), max(cleaner_data_2020$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2020**

``` r
summary(cleaner_data_2020$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.800   2.100   2.600   2.587   3.000   5.300    4816

**NA and Unknown Values** \* 88.7 % of values in the `redd_length_m`
column are NA.

### Location Physical Attributes

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2020**

``` r
summary(cleaner_data_2020$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   4.741  10.000  70.000    4814

**NA and Unknown Values** \* 88.6 % of values in the
`percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2020**

``` r
summary(cleaner_data_2020$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   30.74   40.00   90.00    4813

**NA and Unknown Values** \* 88.6 % of values in the
`percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2020**

``` r
summary(cleaner_data_2020$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   30.00   40.00   38.05   50.00   80.00    4813

**NA and Unknown Values** \* 88.6 % of values in the
`percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2020**

``` r
summary(cleaner_data_2020$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     0.0     0.0    20.0    21.4    30.0    90.0    4813

**NA and Unknown Values** \* 88.6 % of values in the
`percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2020 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2020**

``` r
summary(cleaner_data_2020$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   5.081  10.000  60.000    4814

**NA and Unknown Values** NA and Unknown Values\*\* \* 88.6 % of values
in the `percent_large_substrate` column are NA.

### Variable: `depth_m`

``` r
cleaner_data_2020 %>% 
  group_by(location) %>% 
  summarise(mean_depth_m = mean(depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2020**

``` r
summary(cleaner_data_2020$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.02    0.32    0.44    0.45    0.56    1.20    4813

**NA and Unknown Values** NA and Unknown Values\*\* \* 88.6 % of values
in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2020 %>% 
  group_by(location) %>% 
  summarise(mean_pot_depth_m = mean(pot_depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_pot_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Pot Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2020**

``` r
summary(cleaner_data_2020$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.130   0.400   0.520   0.533   0.640   1.340    4813

**NA and Unknown Values** NA and Unknown Values\*\* \* 88.6 % of values
in the `pot_depth_m` column are NA.

### Variable: `velocity_m/s`

``` r
cleaner_data_2020 %>% 
  group_by(location) %>% 
  summarise(`mean_velocity_m/s` = mean(`velocity_m/s`, na.rm = TRUE)) %>%
  ggplot(aes(x = `mean_velocity_m/s`, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Velocity By Location")
```

![](feather-river-redd-survey-qc-checklist-2020_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

**Numeric Summary of velocity\_m/s Over 2020**

``` r
summary(cleaner_data_2020$`velocity_m/s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -0.013   0.333   0.509   0.540   0.710   1.810    4813

**NA and Unknown Values** NA and Unknown Values\*\* \* 88.6 % of values
in the `velocity_m/s` column are NA.

``` r
feather_redd_survey_2020 <- cleaner_data_2020 %>% glimpse()
```

    ## Rows: 5,432
    ## Columns: 16
    ## $ date                     <date> 2020-09-22, 2020-09-22, 2020-09-22, 2020-09-~
    ## $ location                 <chr> "table mountain", "table mountain", "lower ta~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
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

### Add cleaned data back onto google cloud

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2020,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/2020_Chinook_Redd_Survey_Data.csv")
```

    ## i 2021-10-13 10:10:02 > File size detected as  381.1 Kb

    ## i 2021-10-13 10:10:02 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-13 10:10:02 > File size detected as  381.1 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/2020_Chinook_Redd_Survey_Data.csv 
    ## Type:                csv 
    ## Size:                381.1 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2020_Chinook_Redd_Survey_Data.csv?generation=1634145003377547&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2020_Chinook_Redd_Survey_Data.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2020_Chinook_Redd_Survey_Data.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/2020_Chinook_Redd_Survey_Data.csv/1634145003377547 
    ## MD5 Hash:            nKQD7ri8DvgsOav3ic2Amg== 
    ## Class:               STANDARD 
    ## Created:             2021-10-13 17:10:03 
    ## Updated:             2021-10-13 17:10:03 
    ## Generation:          1634145003377547 
    ## Meta Generation:     1 
    ## eTag:                CIunwMPwx/MCEAE= 
    ## crc32c:              1ukHvw==
