feather-river-adult-holding-redd-survey-qc-checklist-2010
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2010

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2010_Chinook_Redd_Survey_Data_raw.xlsx",
               Overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2010 = readxl::read_excel("2010_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2010)
```

    ## Rows: 901
    ## Columns: 19
    ## $ Date                 <dttm> 2010-09-17, 2010-09-17, 2010-09-17, 2010-09-17, ~
    ## $ `Survey Wk`          <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ Location             <chr> "Table Mountain", "Table Mountain", "Table Mounta~
    ## $ `File #`             <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15~
    ## $ type                 <chr> "A", "Q", "Q", "Q", "A", "A", "Q", "A", "A", "A",~
    ## $ `# of redds`         <dbl> 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`           <dbl> 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ Latitude             <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Longitude            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `Depth (m)`          <dbl> NA, NA, NA, NA, 0.70, 0.66, NA, 0.56, 0.64, 0.66,~
    ## $ `Pot Depth (m)`      <dbl> 0.90, NA, NA, NA, 0.76, 0.70, NA, 0.52, 0.66, 0.6~
    ## $ `Velocity (m/s)`     <dbl> 0.38, NA, NA, NA, 0.55, 0.80, NA, 0.33, 0.35, 0.5~
    ## $ `% fines(<1 cm)`     <dbl> 10, NA, NA, NA, 20, 10, NA, 10, 10, 10, 30, 20, 1~
    ## $ `% small (1-5 cm)`   <dbl> 60, NA, NA, NA, 70, 10, NA, 90, 20, 20, 40, 30, 3~
    ## $ `% med (5-15 cm)`    <dbl> 30, NA, NA, NA, 10, 70, NA, 0, 70, 50, 30, 50, 60~
    ## $ `% large (15-30 cm)` <dbl> 0, NA, NA, NA, 0, 10, NA, 0, 0, 20, 0, 0, 0, 0, 0~
    ## $ `% boulder (>30 cm)` <dbl> 0, NA, NA, NA, 0, 0, NA, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ `redd width (ft)`    <dbl> NA, 3, 4, 10, NA, NA, 4, NA, NA, NA, NA, NA, NA, ~
    ## $ `redd length (ft)`   <dbl> NA, 2, 3, 15, NA, NA, 4, NA, NA, NA, NA, NA, NA, ~

## Data Transformation

``` r
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
  filter(salmon_counted > 0) %>% 
  glimpse()
```

    ## Rows: 398
    ## Columns: 16
    ## $ Date                     <dttm> 2010-09-17, 2010-09-17, 2010-09-18, 2010-09-~
    ## $ Location                 <chr> "Top of Auditorium", "Top of Auditorium", "Lo~
    ## $ type                     <chr> "Q", "A", "A", "A", "A", "A", "Q", "A", "A", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 1, 2, 2, 1, 1, 1, 5, 2, 2, 3, 2, 2, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, 0.56, 0.46, 0.48, 0.26, 0.30, NA, 0.34, 0~
    ## $ pot_depth_m              <dbl> NA, 0.52, 0.46, 0.56, 0.32, 0.32, NA, 0.36, 0~
    ## $ `velocity_m/s`           <dbl> NA, 0.33, 0.46, 0.76, 0.45, 0.25, NA, 0.78, 0~
    ## $ percent_fine_substrate   <dbl> NA, 10, 10, 10, 10, 20, NA, 20, 30, 20, NA, N~
    ## $ percent_small_substrate  <dbl> NA, 90, 70, 30, 70, 80, NA, 80, 60, 20, NA, N~
    ## $ percent_medium_substrate <dbl> NA, 0, 20, 60, 20, 0, NA, 0, 10, 40, NA, NA, ~
    ## $ percent_large_substrate  <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 20, NA, NA, 40, ~
    ## $ percent_boulder          <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 0, NA, NA, 0, NA~
    ## $ redd_width_m             <dbl> 1.219141, NA, NA, NA, NA, NA, 2.133496, NA, N~
    ## $ redd_length_m            <dbl> 1.219141, NA, NA, NA, NA, NA, 2.438281, NA, N~

``` r
cleaner_data_2010 <- cleaner_data_2010 %>% 
  set_names(tolower(colnames(cleaner_data_2010))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 398
    ## Columns: 16
    ## $ date                     <date> 2010-09-17, 2010-09-17, 2010-09-18, 2010-09-~
    ## $ location                 <chr> "Top of Auditorium", "Top of Auditorium", "Lo~
    ## $ type                     <chr> "Q", "A", "A", "A", "A", "A", "Q", "A", "A", ~
    ## $ salmon_counted           <dbl> 1, 1, 1, 1, 2, 2, 1, 1, 1, 5, 2, 2, 3, 2, 2, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, 0.56, 0.46, 0.48, 0.26, 0.30, NA, 0.34, 0~
    ## $ pot_depth_m              <dbl> NA, 0.52, 0.46, 0.56, 0.32, 0.32, NA, 0.36, 0~
    ## $ `velocity_m/s`           <dbl> NA, 0.33, 0.46, 0.76, 0.45, 0.25, NA, 0.78, 0~
    ## $ percent_fine_substrate   <dbl> NA, 10, 10, 10, 10, 20, NA, 20, 30, 20, NA, N~
    ## $ percent_small_substrate  <dbl> NA, 90, 70, 30, 70, 80, NA, 80, 60, 20, NA, N~
    ## $ percent_medium_substrate <dbl> NA, 0, 20, 60, 20, 0, NA, 0, 10, 40, NA, NA, ~
    ## $ percent_large_substrate  <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 20, NA, NA, 40, ~
    ## $ percent_boulder          <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 0, NA, NA, 0, NA~
    ## $ redd_width_m             <dbl> 1.219141, NA, NA, NA, NA, NA, 2.133496, NA, N~
    ## $ redd_length_m            <dbl> 1.219141, NA, NA, NA, NA, NA, 2.438281, NA, N~

## Explore Categorical Variables

``` r
cleaner_data_2010 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2010$location)
```

    ## 
    ##                  Aleck             Auditorium                Bedrock 
    ##                      7                     57                      8 
    ##       Below Auditorium Below Lower Auditorium          Big Hole East 
    ##                      1                      1                      2 
    ##                    G95             G95 Bottom           G95 East Top 
    ##                      3                      6                      4 
    ##           Goose Riffle         Hatchery Ditch          Hatchery Pipe 
    ##                      1                     15                      4 
    ##       Lower Auditorium         Lower Robinson                Mathews 
    ##                     40                     18                     55 
    ##        Middle Robinson     Moe's Side Channel             Moes Ditch 
    ##                      1                      2                     15 
    ##               Robinson           Steep Riffle         Table Mountain 
    ##                     23                      1                     15 
    ##      Top of Auditorium           Top of Steep           Trailer Park 
    ##                      7                      3                     73 
    ##            Upper Aleck          Upper Bedrock             Upper Hour 
    ##                      2                      1                      2 
    ##         Upper McFarlin         Upper Robinson         Vance East Top 
    ##                      1                     20                      4 
    ##             Vance West            Weir Riffle 
    ##                      5                      1

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2010 <- cleaner_data_2010 %>% 
  mutate(location = tolower(location), 
         location = if_else(location == "g95 east top", "g95 east side channel top", location),
         location = if_else(location == "middle auditorium", "mid auditorium", location),
         location = if_else(location == "moes ditch", "moe's ditch", location),        
         location = if_else(location == "top hour", "upper hour", location),
         location = if_else(location == "top of moes ditch", "upper moe's ditch", location),
         location = if_else(location == "top of steep", "upper steep", location),
         location = if_else(location == "top moes side channel", "upper moe's side channel", location),
         location = if_else(location == "upper mcfarlin", "upper mcfarland", location),
         location = if_else(location == "vance east top", "upper vance east", location),
         location = if_else(location == "g95 bottom", "g95 main bottom", location)
         )
table(cleaner_data_2010$location)
```

    ## 
    ##                     aleck                auditorium                   bedrock 
    ##                         7                        57                         8 
    ##          below auditorium    below lower auditorium             big hole east 
    ##                         1                         1                         2 
    ##                       g95 g95 east side channel top           g95 main bottom 
    ##                         3                         4                         6 
    ##              goose riffle            hatchery ditch             hatchery pipe 
    ##                         1                        15                         4 
    ##          lower auditorium            lower robinson                   mathews 
    ##                        40                        18                        55 
    ##           middle robinson               moe's ditch        moe's side channel 
    ##                         1                        15                         2 
    ##                  robinson              steep riffle            table mountain 
    ##                        23                         1                        15 
    ##         top of auditorium              trailer park               upper aleck 
    ##                         7                        73                         2 
    ##             upper bedrock                upper hour           upper mcfarland 
    ##                         1                         2                         1 
    ##            upper robinson               upper steep          upper vance east 
    ##                        20                         3                         4 
    ##                vance west               weir riffle 
    ##                         5                         1

-   0 % of values in the `location` column are NA.

## Variable:`Type`

Description:  
Area - polygon mapped with Trimble GPS unit Point - points mapped with
Trimble GPS unit Questionable redds - polygon mapped with Trimble GPS
unit where the substrate was disturbed but did not have the proper
characteristics to be called a redd - it was no longer recorded after
2011

``` r
table(cleaner_data_2010$type)
```

    ## 
    ##   A   P   Q 
    ## 247  51 100

``` r
cleaner_data_2010 <- cleaner_data_2010 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type),
         type = if_else(type == 'q', 'Questionable Redds', type))
glimpse(cleaner_data_2010$type)
```

    ##  chr [1:398] "Questionable Redds" "Area" "Area" "Area" "Area" "Area" ...

## Expore Numeric Variables

``` r
cleaner_data_2010 %>% 
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

#### Plotting salmon counted in 2010

``` r
cleaner_data_2010 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Salmon Counted in 2010")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Daily Summary of salmon\_counted Over 2010**

``` r
cleaner_data_2010 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.00   32.00   52.00   77.92  100.00  217.00

``` r
cleaner_data_2010  %>%
  ggplot(aes(y = location, x = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 10))+
  scale_y_discrete()+
  theme(axis.text.y = element_text(size = 8,vjust = 0.1, hjust=0.2))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric summary of salmon\_counted by location in 2010**

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_counted, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    3.75    7.50   31.66   33.50  171.00

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2010 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data_2010 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2010$redd_width_m, na.rm = TRUE), max(cleaner_data_2010$redd_width_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2010**

``` r
summary(cleaner_data_2010$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.6096  1.5239  1.5239  2.2947  3.0478 12.1914     173

**NA and Unknown Values** \* 43.5 % of values in the `redd_width_m`
column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2010 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data_2010 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2010$redd_length_m, na.rm = TRUE), max(cleaner_data_2010$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2010**

``` r
summary(cleaner_data_2010$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.9144  1.5239  3.0478  3.4057  4.5718 12.1914     173

**NA and Unknown Values** \* 43.5 % of values in the `redd_length_m`
column are NA.

### Location Physical Attributes

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2010**

``` r
summary(cleaner_data_2010$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   9.025  10.000  80.000     277

**NA and Unknown Values** \* 69.6 % of values in the
`percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2010**

``` r
summary(cleaner_data_2010$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   40.17   60.00   90.00     277

**NA and Unknown Values** \* 69.6 % of values in the
`percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2010**

``` r
summary(cleaner_data_2010$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   40.00   35.08   50.00   75.00     277

**NA and Unknown Values** \* 69.6 % of values in the
`percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2010**

``` r
summary(cleaner_data_2010$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    0.00    0.00   15.21   30.00   80.00     277

**NA and Unknown Values** \* 69.6 % of values in the
`percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2010 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(y = location, x = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  labs(title = "Average Percentage of Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2010**

``` r
summary(cleaner_data_2010$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.0000  0.0000  0.3719  0.0000 15.0000     277

**NA and Unknown Values** NA and Unknown Values\*\* \* 69.6 % of values
in the `percent_large_substrate` column are NA.

### Variable: `depth_m`

``` r
cleaner_data_2010 %>% 
  group_by(location) %>% 
  summarise(mean_depth_m = mean(depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2010**

``` r
summary(cleaner_data_2010$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.13    0.32    0.39    0.42    0.50    0.93     277

**NA and Unknown Values** NA and Unknown Values\*\* \* 69.6 % of values
in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2010 %>% 
   group_by(location) %>% 
  summarise(mean_pot_depth_m = mean(pot_depth_m, na.rm = TRUE)) %>%
  ggplot(aes(x = mean_pot_depth_m, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Pot Depth By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->
**Numeric Summary of pot\_depth\_m Over 2010**

``` r
summary(cleaner_data_2010$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1500  0.3600  0.4400  0.4628  0.5600  0.9000     278

**NA and Unknown Values** NA and Unknown Values\*\* \* 69.8 % of values
in the `pot_depth_m` column are NA.

### Variable: `velocity_m/s`

``` r
cleaner_data_2010 %>% 
  group_by(location) %>% 
  summarise(`mean_velocity_m/s` = mean(`velocity_m/s`, na.rm = TRUE)) %>%
  ggplot(aes(x = `mean_velocity_m/s`, y = location)) + 
  geom_col() + 
  theme_minimal() + 
  theme(text = element_text(size = 8))+
  labs(title = "Average Velocity By Location")
```

![](feather-river-redd-survey-qc-checklist-2010_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->
**Numeric Summary of velocity\_m/s Over 2010**

``` r
summary(cleaner_data_2010$`velocity_m/s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.2800  0.4200  0.4426  0.5500  1.0500     277

**NA and Unknown Values** NA and Unknown Values\*\* \* 69.6 % of values
in the `velocity_m/s` column are NA.

``` r
feather_redd_survey_2010 <- cleaner_data_2010 %>% glimpse()
```

    ## Rows: 398
    ## Columns: 16
    ## $ date                     <date> 2010-09-17, 2010-09-17, 2010-09-18, 2010-09-~
    ## $ location                 <chr> "top of auditorium", "top of auditorium", "lo~
    ## $ type                     <chr> "Questionable Redds", "Area", "Area", "Area",~
    ## $ salmon_counted           <dbl> 1, 1, 1, 1, 2, 2, 1, 1, 1, 5, 2, 2, 3, 2, 2, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, 0.56, 0.46, 0.48, 0.26, 0.30, NA, 0.34, 0~
    ## $ pot_depth_m              <dbl> NA, 0.52, 0.46, 0.56, 0.32, 0.32, NA, 0.36, 0~
    ## $ `velocity_m/s`           <dbl> NA, 0.33, 0.46, 0.76, 0.45, 0.25, NA, 0.78, 0~
    ## $ percent_fine_substrate   <dbl> NA, 10, 10, 10, 10, 20, NA, 20, 30, 20, NA, N~
    ## $ percent_small_substrate  <dbl> NA, 90, 70, 30, 70, 80, NA, 80, 60, 20, NA, N~
    ## $ percent_medium_substrate <dbl> NA, 0, 20, 60, 20, 0, NA, 0, 10, 40, NA, NA, ~
    ## $ percent_large_substrate  <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 20, NA, NA, 40, ~
    ## $ percent_boulder          <dbl> NA, 0, 0, 0, 0, 0, NA, 0, 0, 0, NA, NA, 0, NA~
    ## $ redd_width_m             <dbl> 1.219141, NA, NA, NA, NA, NA, 2.133496, NA, N~
    ## $ redd_length_m            <dbl> 1.219141, NA, NA, NA, NA, NA, 2.438281, NA, N~

### Add cleaned data back onto google cloud

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2010,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/2010_Chinook_Redd_Survey_Data.csv")
```

    ## i 2021-10-13 09:58:25 > File size detected as  34.6 Kb

    ## i 2021-10-13 09:58:26 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-13 09:58:26 > File size detected as  34.6 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/2010_Chinook_Redd_Survey_Data.csv 
    ## Type:                csv 
    ## Size:                34.6 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2010_Chinook_Redd_Survey_Data.csv?generation=1634144306283474&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2010_Chinook_Redd_Survey_Data.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2F2010_Chinook_Redd_Survey_Data.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/2010_Chinook_Redd_Survey_Data.csv/1634144306283474 
    ## MD5 Hash:            nORE8BtD/caxKgNr44yMvQ== 
    ## Class:               STANDARD 
    ## Created:             2021-10-13 16:58:26 
    ## Updated:             2021-10-13 16:58:26 
    ## Generation:          1634144306283474 
    ## Meta Generation:     1 
    ## eTag:                CNKHjfftx/MCEAE= 
    ## crc32c:              pkXTIw==
